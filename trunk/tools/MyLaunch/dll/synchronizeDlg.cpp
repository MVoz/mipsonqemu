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
	setResult(2);
	webView = new QWebView(this);
	webView->setObjectName(QString::fromUtf8("webView"));
	webView->setContextMenuPolicy(Qt::NoContextMenu);
	connect(webView->page()->mainFrame(), SIGNAL(javaScriptWindowObjectCleared()), this, SLOT(populateJavaScriptWindowObject()));
	setFixedSize(360, 100);
	getHtml("./html/processDlg.html");
	status=0;
	statusMap[HTTP_UNCONNECTED]="http_unconnected";
	statusMap[HTTP_HOSTLOOKUP]="http_hostlookup";
	statusMap[HTTP_CONNECTING]="http_connecting";
	statusMap[HTTP_SENDING]="http_sending";
	statusMap[HTTP_READING]="http_reading";
	statusMap[HTTP_CONNECTED]="http_connected";
	statusMap[HTTP_CLOSING]="http_closing";
	statusMap[HTTP_TIMEOUT]="http_timeout";
	statusMap[HTTP_TEST_ACCOUNT_SUCCESS]="http_test_account_success";
	statusMap[HTTP_TEST_ACCOUNT_FAIL]="http_test_account_fail";
	statusMap[HTTP_GET_INI_FAILED]="http_get_ini_failed";
	statusMap[HTTP_GET_INI_SUCCESSFUL]="http_get_ini_successful";
	statusMap[HTTP_GET_INI_NOT_EXISTED]="http_get_ini_not_existed";
	statusMap[HTTP_GET_FILE_SUCCESSFUL]="http_get_file_successful";
	statusMap[HTTP_GET_FILE_NOT_EXISTED]="http_get_file_not_existed";
	statusMap[HTTP_GET_FILE_FAILED]="http_get_file_failed";
	statusMap[UPDATE_FAILED]="update_failed";
	statusMap[UPDATE_SUCCESSFUL]="update_successful";
	statusMap[HTTP_NEED_RETRY]="http_need_retry";
	statusMap[UPDATE_NO_NEED]="update_no_need";
	statusMap[UPDATE_NET_ERROR]="update_net_error";
	statusMap[BOOKMARK_SYNC_START]="bookmark_sync_start";
	statusMap[UPDATE_PROCESSING]="update_processing";
	statusMap[SYNC_SUCCESSFUL]="sync_successful";	
	statusMap[LOGIN_FALIL]="login_falil";
	statusMap[UPDATE_SERVER_REFUSE]="update_server_refuse";
	statusMap[HTTP_CONNECT_SERVER]="http_connect_server";



	/*
	httpStateString << "Unconnected......." << "Host lookup......" << "Connecting......" << "Send request......" << "Getting data......" 
	<< "Connected......." << "Closing......"<<"Timeout......."<<"账户测试成功"<<"账户测试失败"<<"get ini failed"<<"Get ini successfully"
	<<"ini doesn't exist"<<"Get file successfully"<<"file doesn't exist"<<"get file failed"<<"updating failed"
	<<"updating successfully"<<"HTTP_NEED_RETRY"<<"UPDATE_NO_NEED"<<"UPDATE_NET_ERROR"<<"BOOKMARK_SYNC_START"
	<<"UPDATE_PROCESSING"<<"SYNC_SUCCESSFUL";
	*/
}


synchronizeDlg::~synchronizeDlg()
{
	qDebug()<<__FUNCTION__<<"unregister resource options.rcc";
	QResource::unregisterResource("options.rcc");
	DELETE_OBJECT(webView);
	statusMap.clear();
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

	qDebug("synchronizeDlg::accept() status=%d UPDATE_SUCCESSFUL=%d",status,UPDATE_SUCCESSFUL);
	QDialog::accept();
}

void synchronizeDlg::reject()
{
	qDebug("%s %d currentthreadid=0x%08x",__FUNCTION__,__LINE__,QThread::currentThreadId());
	emit stopSync();
	QDialog::reject();
}
void synchronizeDlg::retry()
{
	qDebug("%s %d",__FUNCTION__,__LINE__);
	emit reSyncNotify();

}
void synchronizeDlg::populateJavaScriptWindowObject()
{
	webView->page()->mainFrame()->addToJavaScriptWindowObject("processDlg", this);
}
void synchronizeDlg::updateStatus(int type,int s)
{
	QString jsStr;
	//qDebug("%s type=%d status=%d str=%s\n",__FUNCTION__,type,status,qPrintable(statusMap[s]));
	status=s;
	statusTime = NOW_SECONDS;
	switch(type)
	{
	case UPDATESTATUS_FLAG_APPLY:
		jsStr.append(QString("$$('loading').style.display='block';"));
		jsStr.append(QString("$$('arrow').style.display='none';"));
		jsStr.append(QString("$$('ps').innerHTML ='%1';").arg(tz::tr(TOCHAR(statusMap[s]))));
		jsStr.append(QString("$$('btn').innerHTML ='<a href=\"#\"  onclick=\"accept();\" >%1</a>';").arg(tz::tr(LANGUAGE_APPLY)));
		break;
	case UPDATESTATUS_FLAG_RETRY:
		jsStr.append(QString("$$('loading').style.display='block';"));
		jsStr.append(QString("$$('arrow').style.display='none';"));
		jsStr.append(QString("$$('ps').innerHTML ='%1';").arg(tz::tr(TOCHAR(statusMap[s]))));
		//jsStr.append(QString("$$('btn').innerHTML ='<a href=\"#\"  onclick=\"this.innerText=%1;retry();\" >%2</a>';").arg(translate::tr(LANGUAGE_REJECT)).arg(translate::tr(LANGUAGE_RETRY)));
		jsStr.append(QString("$$('btn').innerHTML ='<a href=\"#\"  onclick=\"retry();\" >%1</a>';").arg(tz::tr(LANGUAGE_RETRY)));
		show();
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
	jsStr.append(QString("$$('ps').innerHTML ='Getting data......';"));
	webView->page()->mainFrame()->evaluateJavaScript(jsStr);
	update();
}
void synchronizeDlg::reSyncSlot()
{
	QString jsStr;
	jsStr.append(QString("$$('btn').innerHTML ='<a href=\"#\"  onclick=\"reject();\" >%1</a>';").arg(tz::tr(LANGUAGE_CANCEL)));
	webView->page()->mainFrame()->evaluateJavaScript(jsStr);
	update();
}

