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
	QDEBUG("register resource options.rcc");
	QResource::registerResource("options.rcc");
	webView = new QWebView(this);
	webView->setObjectName(QString::fromUtf8("webView"));
	webView->setContextMenuPolicy(Qt::NoContextMenu);
	connect(webView->page()->mainFrame(), SIGNAL(javaScriptWindowObjectCleared()), this, SLOT(populateJavaScriptWindowObject()));
	setFixedSize(360, 100);
	getHtml("./html/processDlg.html");
	status=0;
	httpStateString << "Unconnected......." << "Host lookup......" << "Connecting......" << "Send request......" << "Getting data......" 
		<< "Connected......." << "Closing......"<<"Timeout......."<<"账户测试成功"<<"账户测试失败"<<"get ini failed"<<"Get ini successfully"
		<<"ini doesn't exist"<<"Get file successfully"<<"file doesn't exist"<<"get file failed"<<"updating failed"
		<<"updating successfully"<<"HTTP_NEED_RETRY"<<"UPDATE_NO_NEED"<<"UPDATE_NET_ERROR"<<"BOOKMARK_SYNC_START"
		<<"UPDATE_PROCESSING"<<"SYNC_SUCCESSFUL";
}


synchronizeDlg::~synchronizeDlg()
{
	QDEBUG("unregister resource options.rcc");
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
	if(status==UPDATE_SUCCESSFUL)
		emit updateSuccessNotify();
			
	QDEBUG("synchronizeDlg::accept()");
	QDialog::accept();
}

void synchronizeDlg::reject()
{
	emit stopSync();
	QDialog::reject();
}
void synchronizeDlg::retry()
{
	emit reSyncNotify();
	QDEBUG("synchronizeDlg retry.....");
}
void synchronizeDlg::populateJavaScriptWindowObject()
{
	webView->page()->mainFrame()->addToJavaScriptWindowObject("processDlg", this);
}
void synchronizeDlg::updateStatus(int type,int status,QString str)
{
	QString jsStr;
	qDebug("%s type=%d\n",__FUNCTION__,type);
	status=status;
	switch(type)
		{
		case UPDATESTATUS_FLAG_APPLY:
			jsStr.append(QString("$$('loading').style.display='block';"));
			jsStr.append(QString("$$('arrow').style.display='none';"));
			jsStr.append(QString("$$('ps').innerHTML ='%1';").arg(str));
			jsStr.append(QString("$$('btn').innerHTML ='<a href=\"#\"  onclick=\"accept();\" >%1</a>';").arg(translate::tr(LANGUAGE_APPLY)));
			break;
		case UPDATESTATUS_FLAG_RETRY:
			jsStr.append(QString("$$('loading').style.display='block';"));
			jsStr.append(QString("$$('arrow').style.display='none';"));
			jsStr.append(QString("$$('ps').innerHTML ='%1';").arg(str));
			jsStr.append(QString("$$('btn').innerHTML ='<a href=\"#\"  onclick=\"this.innerText=%1;retry();\" >%2</a>';").arg(translate::tr(LANGUAGE_REJECT)).arg(translate::tr(LANGUAGE_RETRY)));
			break;
		/*
		case UPDATE_SUCCESSFUL:		
			jsStr.append(QString("document.getElementById('loading').style.display='block';"));
			jsStr.append(QString("document.getElementById('arrow').style.display='none';"));
			jsStr.append(QString("document.getElementById('ps').innerHTML ='%1';").arg(tr("下载最新文件成功，请点击确定以完成升级")));
			jsStr.append(QString("document.getElementById('btn').innerHTML ='%1';").arg("<a href=\"#\"  onclick=\"accept();\" >确定</a>"));
			break;
		case UPDATE_NET_ERROR:
			jsStr.append(QString("document.getElementById('loading').style.display='block';"));
			jsStr.append(QString("document.getElementById('arrow').style.display='none';"));
			jsStr.append(QString("document.getElementById('ps').innerHTML ='%1';").arg(QString::fromLocal8Bit("无法连接服务器，请检查网络设置")));
			jsStr.append(QString("document.getElementById('btn').innerHTML ='%1';").arg("<a href=\"#\"  onclick=\"accept();\" >确定</a>"));
			break;
		case UPDATE_NO_NEED:		
			jsStr.append(QString("document.getElementById('loading').style.display='block';"));
			jsStr.append(QString("document.getElementById('arrow').style.display='none';"));
			jsStr.append(QString("document.getElementById('ps').innerHTML ='%1';").arg(QString::fromLocal8Bit(("程序目前已处于最新状态"))));
			jsStr.append(QString("document.getElementById('btn').innerHTML ='%1';").arg("<a href=\"#\"  onclick=\"accept();\" >确定</a>"));
			break;
		case HTTP_TEST_ACCOUNT_SUCCESS:
			jsStr.append(QString("document.getElementById('ps').innerHTML ='<img src=\"image/loading.gif\">%1';").arg(httpStateString.at(type)));
			jsStr.append(QString("document.getElementById('btn').innerHTML ='%1';").arg("<a href=\"#\"  onclick=\"accept();\" >纭</a>"));
			break;
		case HTTP_TEST_ACCOUNT_FAIL:
			jsStr.append(QString("document.getElementById('ps').innerHTML ='<img src=\"image/loading.gif\">%1';").arg(httpStateString.at(type)));
			jsStr.append(QString("document.getElementById('btn').innerHTML ='%1';").arg("<img src=\"qrc:image/loading.gif\"><a href=\"#\"  onclick=\"accept();\" >纭</a>"));
			break;
		case UPDATE_FAILED:
		case HTTP_TIMEOUT:
			qDebug("%s type=%d\n",__FUNCTION__,type);
			jsStr.append(QString("document.getElementById('ps').innerHTML ='%1';").arg(httpStateString.at(type)));
			jsStr.append(QString("document.getElementById('btn').innerHTML ='%1';").arg("<a href=\"#\"  onclick=\"retry();\" >閲嶈瘯</a>"));
			break;
		case BOOKMARK_SYNC_START:
			jsStr.append(QString("document.getElementById('ps').innerHTML ='%1';").arg(tr("sync start.......")));
			jsStr.append(QString("document.getElementById('btn').innerHTML ='%1';").arg("<a href=\"#\"  onclick=\"retry();\" >閲嶈瘯</a>"));
			break;
		case UPDATE_PROCESSING:
			jsStr.append(QString("document.getElementById('ps').innerHTML ='%1';").arg(tr("processing.......")));
			break;
		case SYNC_SUCCESSFUL:
			jsStr.append(QString("document.getElementById('ps').innerHTML ='%1';").arg(tr("sync sucessful.......")));
			break;
		default:
			jsStr.append(QString("document.getElementById('ps').innerHTML ='<img src=\"image/loading.gif\">%1';").arg(httpStateString.at(type)));
			break;
		*/
		}
	
	webView->page()->mainFrame()->evaluateJavaScript(jsStr);
	update();
}
void synchronizeDlg::readDateProgress(int done, int total)
{
	QString jsStr;
	jsStr.append(QString("$$('ps').innerHTML ='%1';").arg(httpStateString.at(HTTP_READING)));
	webView->page()->mainFrame()->evaluateJavaScript(jsStr);
	update();
}
void synchronizeDlg::reSyncSlot()
{
	QString jsStr;
	jsStr.append(QString("$$('btn').innerHTML ='%1';").arg("<a href=\"#\"  onclick=\"reject();\" >涓</a>"));
	webView->page()->mainFrame()->evaluateJavaScript(jsStr);
	update();
}

