/*
Launchy: Application Launcher
Copyright (C) 2007  Josh Karlin

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

#include "synchronizeDlg.h"
#include <globals.h>
#include <QSettings>
#include <QDir>
#include <QPixmap>
#include <QBitmap>
#include <QPainter>
#include <QFileDialog>
#include <QTextStream>
#include <QMessageBox>
#include <QResource>

synchronizeDlg::synchronizeDlg(QWidget * parent):QDialog(parent)
{
	qDebug("register resource options.rcc");
	QResource::registerResource("options.rcc");
	webView = new QWebView(this);
	webView->setObjectName(QString::fromUtf8("webView"));
	webView->setContextMenuPolicy(Qt::NoContextMenu);
	connect(webView->page()->mainFrame(), SIGNAL(javaScriptWindowObjectCleared()), this, SLOT(populateJavaScriptWindowObject()));
	setFixedSize(320, 80);
	getHtml("./html/processDlg.html");
	httpStateString << "Unconnected......." << "Host lookup......" << "Connecting......" << "Send request......" << "Getting data......" << "Connected......." << "Closing......"<<"Timeout......."\
		<<"验证正确"<<"验证错误"<<"get ini failed"<<"Get ini successfully"<<"ini doesn't exist"<<"get file failed"<<"Get file successfully"<<"file doesn't exist"<<"get file failed"<<"updating failed"<<"updating successfully"
	<<"HTTP_NEED_RETRY";
}


synchronizeDlg::~synchronizeDlg()
{
	qDebug("unregister resource options.rcc");
	QResource::unregisterResource("options.rcc");
}
void synchronizeDlg::getHtml(const QString & path)
{
	QFile htmlFile(path);
	if (!htmlFile.open(QIODevice::ReadOnly | QIODevice::Text))
		return;
	//webView->setHtml(QString(htmlFile.readAll()));
	webView->setHtml(trUtf8(htmlFile.readAll()));

	htmlFile.close();
}

void synchronizeDlg::accept()
{
	qDebug("synchronizeDlg::accept()");
	QDialog::accept();
}

void synchronizeDlg::reject()
{
	emit stopSync();
	QDialog::reject();
}
void synchronizeDlg::retry()
{
	emit reSync();
	qDebug("synchronizeDlg retry.....");
}
void synchronizeDlg::populateJavaScriptWindowObject()
{
	webView->page()->mainFrame()->addToJavaScriptWindowObject("processDlg", this);
}

void synchronizeDlg::updateStatus(int type)
{
	QString jsStr;
	jsStr.append(QString("document.getElementById('ps').innerHTML ='%1';").arg(httpStateString.at(type)));
	switch(type)
		{
		case HTTP_TEST_ACCOUNT_SUCCESS:
			jsStr.append(QString("document.getElementById('btn').innerHTML ='%1';").arg("<a href=\"#\"  onclick=\"accept();\" >确认</a>"));
			break;
		case HTTP_TEST_ACCOUNT_FAIL:
			jsStr.append(QString("document.getElementById('btn').innerHTML ='%1';").arg("<a href=\"#\"  onclick=\"accept();\" >确认</a>"));
			break;
		case UPDATE_FAILED:
		case HTTP_TIMEOUT:
			jsStr.append(QString("document.getElementById('btn').innerHTML ='%1';").arg("<a href=\"#\"  onclick=\"retry();\" >重试</a>"));
			break;		
		}	
	webView->page()->mainFrame()->evaluateJavaScript(jsStr);
	update();
	//if(type==UPDATE_SUCCESSFUL)	accept();
}
void synchronizeDlg::readDateProgress(int done, int total)
{
	QString jsStr;
	jsStr.append(QString("document.getElementById('ps').innerHTML ='%1';").arg(httpStateString.at(HTTP_READING)));
	webView->page()->mainFrame()->evaluateJavaScript(jsStr);
	update();
}
void synchronizeDlg::reSyncSlot()
{
	QString jsStr;
	jsStr.append(QString("document.getElementById('btn').innerHTML ='%1';").arg("<a href=\"#\"  onclick=\"reject();\" >中止</a>"));
	webView->page()->mainFrame()->evaluateJavaScript(jsStr);
	update();
}

