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

#include "options.h"
#include <globals.h>
#include <QSettings>
#include <QDir>
#include <QPixmap>
#include <QBitmap>
#include <QPainter>
#include <QFileDialog>
#include <QTextStream>
#include <QMessageBox>
#include <QDesktopWidget>
#include <catalog>

OptionsDlg::OptionsDlg(QWidget * parent,QDateTime*d,QSettings *s,QString path,QSqlDatabase *db,void* catalogbuilder):QDialog(parent),updateTime(d),settings(s),db_p(db),iePath(path)
{
	//catalogBuilder=*(shared_ptr <CatBuilder>*)(catalogBuilder);
	webView = new QWebView(this);
	webView->setObjectName(QString::fromUtf8("webView"));
	webView->setMinimumSize(QSize(805, 500));
	webView->setMaximumSize(QSize(805, 16777215));
	webView->setContextMenuPolicy(Qt::NoContextMenu);
	connect(webView->page()->mainFrame(), SIGNAL(javaScriptWindowObjectCleared()), this, SLOT(populateJavaScriptWindowObject()));
	QDEBUG("register resource options.rcc");
	QResource::registerResource("options.rcc");
	setFixedSize(805, 450);
	metaKeys << tr("Alt") << tr("Win") << tr("Shift") << tr("Control");
	iMetaKeys << Qt::AltModifier << Qt::MetaModifier << Qt::ShiftModifier << Qt::ControlModifier;

	actionKeys << tr("Space") << tr("Tab") << tr("Backspace") << tr("Enter") << tr("Esc") << tr("Home") << tr("End") << tr("Pause") << tr("Print") << tr("Up") << tr("Down") << tr("Left") << tr("Right") << tr("F1") << tr("F2") << tr("F3") << tr("F4") << tr("F5") << tr("F6") << tr("F7") << tr("F8") << tr("F9") << tr("F10") << tr("F11") << tr("F12") << tr("F13");


	for (int i = 'A'; i <= 'Z'; i++)
		actionKeys << QString(QChar(i));
	iActionKeys << Qt::Key_Space << Qt::Key_Tab << Qt::Key_Backspace << Qt::Key_Enter << Qt::Key_Escape << Qt::Key_Home << Qt::Key_End << Qt::Key_Pause << Qt::Key_Print << Qt::Key_Up << Qt::Key_Down << Qt::Key_Left << Qt::Key_Right << Qt::Key_F1 << Qt::Key_F2 << Qt::Key_F3 << Qt::Key_F4 << Qt::Key_F5 << Qt::Key_F6 << Qt::Key_F7 << Qt::Key_F8 << Qt::Key_F9 << Qt::Key_F10 << Qt::Key_F11 << Qt::Key_F12 << Qt::Key_F13;

	for (int i = 'A'; i <= 'Z'; i++)
		iActionKeys << i;


	// Find the current hotkey
	//QKeySequence keys = gSettings->value("Options/hotkey", QKeySequence(Qt::ControlModifier + Qt::Key_Space)).value < QKeySequence > ();
	
	getHtml("./html/general.html");
	QDesktopWidget* desktop = QApplication::desktop(); // =qApp->desktop();也可以
	move((desktop->width() - width())/2,(desktop->height() - height())/2); 
	manager=NULL;
	reply=NULL;
	updaterDlg=NULL;
	updaterthread=NULL;
	
}
OptionsDlg::~OptionsDlg()
{
	QDEBUG(" ~OptionsDlg unregister resource options.rcc");
	QResource::unregisterResource("options.rcc");
	cmdLists.clear();
	dirLists.clear();
	if(manager){
				 manager->deleteLater();
				 manager=NULL;
		}

	QDialog::accept();
}

#ifdef CONFIG_UI_WEBKIT
void OptionsDlg::populateJavaScriptWindowObject()
{
	webView->page()->mainFrame()->addToJavaScriptWindowObject("OptionsDlg", this);
}

void OptionsDlg::contextMenuEvent(QContextMenuEvent * event)
{
	QList < QAction * >actions;
	QAction *copyAction = webView->page()->action(QWebPage::Copy);
	QAction *pasteAction = webView->page()->action(QWebPage::Paste);
	actions.append(copyAction);
	actions.append(pasteAction);
	QAction *chosen = QMenu::exec(actions, event->globalPos());
	if (chosen == copyAction)
	  {
		  webView->page()->triggerAction(QWebPage::Copy);
	} else if (chosen == pasteAction)
		webView->page()->triggerAction(QWebPage::Paste);

}

void OptionsDlg::startSync()
{
	emit optionStartSyncNotify();
#if 0
	qDebug("%s gSyncer=0x%08x",__FUNCTION__,gSyncer);

	if(!(settings->value("Account/Username","").toString().isEmpty())&&!(settings->value("Account/Userpasswd","").toString().isEmpty()))
	{
		if(!gSyncer)
		{
			syncDlg = new synchronizeDlg(this);
			syncDlg->setModal(1);
			syncDlg->show();
			gSyncer.reset(new BookmarkSync(this,db_p,settings,iePath,BOOKMARK_SYNC_MODE));
			connect(gSyncer.get(), SIGNAL(bookmarkFinished(bool)), this, SLOT(bookmark_finished(bool)));
			connect(gSyncer.get(), SIGNAL(updateStatusNotify(int)), syncDlg, SLOT(updateStatus(int)));
			connect(gSyncer.get(), SIGNAL(readDateProgressNotify(int, int)), syncDlg, SLOT(readDateProgress(int, int)));
			gSyncer->setHost(BM_SERVER_ADDRESS);
			#ifdef CONFIG_AUTH_ENCRYPTION
				qsrand((unsigned) QDateTime::currentDateTime().toTime_t());
				uint key=qrand()%(getkeylength());
				QString authstr=QString("username=%1 password=%2").arg(settings->value("Account/Username","").toString()).arg(settings->value("Account/Userpasswd","").toString());
				QString auth_encrypt_str="";
				encryptstring(authstr,key,auth_encrypt_str);
#ifdef CONFIG_SYNC_TIMECHECK
				QString localBmFullPath;
				QString bmxml_url;
					if (getUserLocalFullpath(settings,QString(LOCAL_BM_SETTING_FILE_NAME),localBmFullPath)&&QFile::exists(localBmFullPath))
					{
						bmxml_url=QString(BM_SERVER_GET_BMXML_URL).arg(auth_encrypt_str).arg(key).arg(settings->value("updateTime","0").toString());
					}else{
						bmxml_url=QString(BM_SERVER_GET_BMXML_URL).arg(auth_encrypt_str).arg(key).arg(0);
				}
#else				
				QString bmxml_url=QString(BM_SERVER_GET_BMXML_URL).arg(auth_encrypt_str).arg(key);
#endif
			#else
				QString bmxml_url=QString(BM_SERVER_GET_BMXML_URL).arg(settings->value("Account/Username","").toString()).arg(settings->value("Account/Userpasswd","").toString());
			#endif
			gSyncer->setUrl(bmxml_url);
			gSyncer->start();
		}
	}
#endif
}
/*
void OptionsDlg::bookmark_finished(bool error)
{
	QDEBUG("%s %d error=%d syncDlg=0x%08x",__FUNCTION__,__LINE__,error,syncDlg);
	gSyncer->wait();
	gSyncer.reset();
	if (!error&&syncDlg)
		syncDlg->accept();	
}

void OptionsDlg::testAccountFinished(bool err,QString result)
{
	QDEBUG("%s %d error=%d syncDlg=0x%08x result=%s",__FUNCTION__,__LINE__,err,syncDlg,qPrintable(result));
	gSyncer->wait();
	gSyncer.reset();
	if (!err&&syncDlg)
		{
			if(result==SUCCESSSTRING)
				syncDlg->updateStatus(HTTP_TEST_ACCOUNT_SUCCESS) ;
			else
				syncDlg->updateStatus(HTTP_TEST_ACCOUNT_FAIL) ;
			
		}
}
*/
void OptionsDlg::proxyTestslotError(QNetworkReply::NetworkError err)
{
	QDEBUG("%s error=%d\n",__FUNCTION__,err);
	 testProxyTimer.stop();
	switch (err){
		case  QNetworkReply::ProxyAuthenticationRequiredError:
			 QMessageBox::critical(0, windowTitle(), QObject::tr("The proxy server needs the right name and password"));			
			break;
		default:
			QMessageBox::critical(this, windowTitle(), QObject::tr("The proxy server works failed"));
			break;
			
		}
}
void OptionsDlg::proxyTestslotFinished(QNetworkReply * testreply)
{	
	int err=testreply->error();
	QDEBUG("%s error=%d\n",__FUNCTION__,testreply->error());
	if(testProxyTimer.isActive())
		testProxyTimer.stop();
	switch (err){
		case QNetworkReply::NoError:
			QMessageBox::information(this, windowTitle(), QString::fromUtf8("代理服务器工作正常！"));
			break;
		case  QNetworkReply::ProxyAuthenticationRequiredError:
			 QMessageBox::critical(0, windowTitle(), QObject::tr("The proxy server needs the right name and password"));			
			break;
		default:
			QMessageBox::critical(this, windowTitle(), QObject::tr("The proxy server works failed"));
			break;			
		}
	//reply->close();
	//disconnect(manager, 0, 0, 0);	
	
	//delete manager;
	//manager=NULL;
}
void OptionsDlg::proxtTestTimerSlot()
{
	QDEBUG_LINE;
	if(testProxyTimer.isActive())
		testProxyTimer.stop();
	reply->abort();
}
void OptionsDlg::proxyTestClick(const QString& proxyAddr,const QString& proxyPort,const QString& proxyUsername,const QString& proxyPassword)
{


	QDEBUG("%s proxyAddr=%s proxyPort=%s proxyUsername=%s proxyPassword=%s manager=0x%08x reply=0x%08x\n",
	__FUNCTION__,qPrintable(proxyAddr),qPrintable(proxyPort),qPrintable(proxyUsername),qPrintable(proxyPassword),manager,reply);
	if(!manager)
	{
	 proxy.setType(QNetworkProxy::HttpProxy);
	 proxy.setHostName(proxyAddr);
	
	 proxy.setPort(proxyPort.toInt());
	 proxy.setUser(proxyUsername);
	 proxy.setPassword(proxyPassword);
	// QNetworkProxy::setApplicationProxy(proxy);
	// QNetworkRequest request; 
	 request.setUrl(QUrl(QString("http://www.sohu.com")));
	 request.setRawHeader("User-Agent", "MyOwnBrowser 1.0");
	 manager = new QNetworkAccessManager(this);
	 manager->setProxy(proxy);
	 manager->setObjectName(tr("manager"));
 	// connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(replyFinished(QNetworkReply*)));

	 reply = manager->get(request);

	// testProxyTimer=new QTimer(this);

	 testProxyTimer.start(10);
	testProxyTimer.setSingleShot(TRUE);
	
	 connect(&testProxyTimer, SIGNAL(timeout()), this, SLOT(proxtTestTimerSlot()), Qt::DirectConnection);
	// connect(reply, SIGNAL(readyRead()), this, SLOT(slotReadyRead()));
	// connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(proxyTestslotError(QNetworkReply::NetworkError)));
	 connect(manager, SIGNAL(finished ( QNetworkReply * )), this, SLOT(proxyTestslotFinished(QNetworkReply *)));
	
	}

}
void OptionsDlg::accountTestClick(const QString& name,const QString& password)
{
	QDEBUG("username=%s password=%s......",qPrintable(name),qPrintable(password));
	emit testAccountNotify(name,password);
#if 1
#if 0
	if(!gSyncer)
	{
		syncDlg = new synchronizeDlg(this);
		syncDlg->setModal(1);
		syncDlg->show();	
		gSyncer.reset(new BookmarkSync(this,db_p,settings,iePath,BOOKMARK_TESTACCOUNT_MODE));
		connect(gSyncer.get(), SIGNAL(testAccountFinishedNotify(bool,QString)), this, SLOT(testAccountFinished(bool,QString)));
		connect(gSyncer.get(), SIGNAL(updateStatusNotify(int)), syncDlg, SLOT(updateStatus(int)));
		connect(gSyncer.get(), SIGNAL(readDateProgressNotify(int, int)), syncDlg, SLOT(readDateProgress(int, int)));
		gSyncer->setHost(BM_SERVER_ADDRESS);
		gSyncer->setUrl(BM_TEST_ACCOUNT_URL);

		qsrand((unsigned) QDateTime::currentDateTime().toTime_t());
		uint key=qrand()%(getkeylength());
		QString authstr=QString("username=%1 password=%2").arg(name).arg(password);
		QString auth_encrypt_str="";
		encryptstring(authstr,key,auth_encrypt_str);

		QString testaccount_url;
		
		testaccount_url=QString(BM_SERVER_TESTACCOUNT_URL).arg(auth_encrypt_str).arg(key);		

		gSyncer->setUrl(testaccount_url);
		gSyncer->setUsername(password);
		gSyncer->setPassword(name);
		gSyncer->start();
	}
#endif
#else
	postHttp accountTestHttp(this,POST_HTTP_TYPE_TESTACCOUNT);
	QString postString = QString("name=%1&password=%2").arg(QString(QUrl::toPercentEncoding(name))).arg(QString(QUrl::toPercentEncoding(password)));
	accountTestHttp.postString = postString;
	accountTestHttp.start();
	accountTestHttp.wait();
	QDEBUG("account test complish........");
#endif
}
void OptionsDlg::getHtml(const QString & path)
{
	QFile htmlFile(path);
	if (!htmlFile.open(QIODevice::ReadOnly | QIODevice::Text))
		return;
	webView->setHtml(trUtf8(htmlFile.readAll()));

	htmlFile.close();
}
void OptionsDlg::loading(const QString & name)
{
	QString jsStr;
	if (name == "general_html")
	  {
		  jsStr.append(QString("document.getElementById('ckStartWithSystem').checked =%1;").arg(settings->value("generalOpt/ckStartWithSystem", false).toBool()? "true" : "false"));
		  jsStr.append(QString("document.getElementById('ckShowTray').checked =%1;").arg(settings->value("generalOpt/ckShowTray", false).toBool()? "true" : "false"));
		  jsStr.append(QString("document.getElementById('ckShowMainwindow').checked =%1;").arg(settings->value("generalOpt/ckShowMainwindow", false).toBool()? "true" : "false"));
		  jsStr.append(QString("document.getElementById('ckAutoUpdate').checked =%1;").arg(settings->value("generalOpt/ckAutoUpdate", false).toBool()? "true" : "false"));
		  jsStr.append(QString("document.getElementById('ckScanDir').checked =%1;").arg(settings->value("generalOpt/ckScanDir", false).toBool()? "true" : "false"));
#ifdef Q_WS_WIN
		  int curMeta = settings->value("GenOps/hotkeyModifier", Qt::AltModifier).toInt();
#endif
#ifdef Q_WS_X11
		  int curMeta = settings->value("GenOps/hotkeyModifier", Qt::ControlModifier).toInt();
#endif
		  int curAction = settings->value("GenOps/hotkeyAction", Qt::Key_Space).toInt();
		  jsStr.append(QString("set_selected('%1','hotkey_0');").arg(curMeta));
		  jsStr.append(QString("set_selected('%1','hotkey_1');").arg(curAction));
		 

	} else if (name == "net_mg_html")
	  {
		  jsStr.append(QString("document.getElementById('Username').value ='%1';").arg(settings->value("Account/Username", "").toString()));
		  jsStr.append(QString("document.getElementById('Userpasswd').value ='%1';").arg(settings->value("Account/Userpasswd", "").toString()));
		  jsStr.append(QString("document.getElementById('proxyEnable').checked =%1;").arg(settings->value("HttpProxy/proxyEnable", false).toBool()? "true" : "false"));
		  jsStr.append(QString("document.getElementById('proxyAddress').value ='%1';").arg(settings->value("HttpProxy/proxyAddress", "").toString()));
		  jsStr.append(QString("document.getElementById('proxyPort').value ='%1';").arg(settings->value("HttpProxy/proxyPort", "").toString()));
		  jsStr.append(QString("document.getElementById('proxyUsername').value ='%1';").arg(settings->value("HttpProxy/proxyUsername", "").toString()));
		  jsStr.append(QString("document.getElementById('proxyPassword').value ='%1';").arg(settings->value("HttpProxy/proxyPassword", "").toString()));
		  jsStr.append(QString("proxyEnableClick();"));

	} else if (name == "cmd_mg_html")
	  {
		  jsStr.append(QString("document.getElementById('cmd_table').innerHTML='<table width=\"580\" align=\"center\" cellspacing=\"1\" >\
							 <tr bgcolor=\"#ffffff\" align=\"center\">\
							 <td width=\"8%\">选择</td>\
							 <td width=\"8%\">名字</td>\
							 <td width=\"64%\">命令</td>\
							 <td width=\"20%\">参数</td>\
							 </tr>"));
		  cmdLists.clear();
		  /*
		  int count = settings->beginReadArray("weby/sites");
		  int i=0;
		  for (i = 0; i < count; i++)
		    {
			    settings->setArrayIndex(i);
			    CMD_LIST cl;
			    cl.index = i;
			    cl.name = settings->value("name").toString();
			    cl.base = settings->value("base").toString();
			    cl.parameters = settings->value("query").toString();
			    cmdLists << cl;
			    jsStr.append(QString("<tr bgcolor=\"#ffffff\" align=\"center\">\
								 <td width=\"8%\"><input type=\"radio\" name=\"select\" value=\"0\" onclick=\"postItem(\\'%1\\',\\'%2\\',\\'%3\\',\\'%4\\');\"></td>\
								 <td width=\"8%\">%5</td>\
								 <td width=\"64%\" style=\"font-size:10;\">%6</td>\
								 <td width=\"20%\" style=\"font-size:10;\">%7</td>\
								 </tr>")
								 .arg(settings->value("name").toString().replace("\\", "\\\\\\\\"))
								 .arg(settings->value("base").toString().replace("\\", "\\\\\\\\"))
								 .arg(settings->value("query").toString())
								 .arg(i)
								 .arg(settings->value("name").toString().replace("\\", "\\\\\\\\"))
								 .arg(settings->value("base").toString().replace("\\", "\\\\"))
								 .arg(settings->value("query").toString()));

		    }
		  settings->endArray();
		  */
		  /*
		  int count = settings->beginReadArray("runner/cmds");
		  for (int j = 0; j < count;j++)
		    {
			    settings->setArrayIndex(j);
			    CMD_LIST cl;
			    cl.index =j;
			    cl.name = settings->value("name").toString();
			    cl.base = settings->value("file").toString();
			    cl.parameters = settings->value("args").toString();
			    cmdLists << cl;
			    qDebug("name=%s file=%s",qPrintable(settings->value("name").toString()),qPrintable(settings->value("file").toString()));
			    jsStr.append(QString("<tr bgcolor=\"#ffffff\" align=\"center\">\
								 <td width=\"8%\"><input type=\"radio\" name=\"select\" value=\"0\" onclick=\"postItem(\\'%1\\',\\'%2\\',\\'%3\\',\\'%4\\');\"></td>\
								 <td width=\"8%\">%5</td>\
								 <td width=\"64%\" style=\"font-size:10;\">%6</td>\
								 <td width=\"20%\" style=\"font-size:10;\">%7</td>\
								 </tr>")
								 .arg(settings->value("name").toString().replace("\\", "\\\\\\\\"))
								 .arg(settings->value("file").toString().replace("\\", "\\\\\\\\"))
								 .arg(settings->value("args").toString())
								 .arg(j)
								 .arg(settings->value("name").toString().replace("\\", "\\\\\\\\"))
								 .arg(settings->value("file").toString().replace("\\", "\\\\"))
								 .arg(settings->value("args").toString()));

		    }
		  settings->endArray();
		*/
		  QSqlQuery query("",*db_p);
		  QString  queryStr=QString("select * from %1 where comeFrom=%2").arg(DB_TABLE_NAME).arg(COME_FROM_RUNNER);
		  if(query.exec(queryStr))
		  	{
		  		  	   QSqlRecord rec = query.record();
					   int id_Idx=rec.indexOf("id");
					   int fullPath_Idx = rec.indexOf("fullPath"); // index of the field "name"
					   int shortName_Idx = rec.indexOf("shortName"); // index of the field "name"
					 //  int lowName_Idx = rec.indexOf("lowName"); // index of the field "name"
					  // int icon_Idx = rec.indexOf("icon"); // index of the field "name"
					  // int usage_Idx = rec.indexOf("usage"); // index of the field "name"
					  // int hashId_Idx = rec.indexOf("hashId"); // index of the field "name"
					  // int groupId_Idx = rec.indexOf("groupId"); // index of the field "name"
					  // int parentId_Idx = rec.indexOf("parentId"); // index of the field "name"
					  // int isHasPinyin_Idx = rec.indexOf("isHasPinyin"); // index of the field "name"
					   //int comeFrom_Idx = rec.indexOf("comeFrom"); // index of the field "name"
					  // int hanziNums_Idx = rec.indexOf("hanziNums"); // index of the field "name"
					  // int pinyinDepth_Idx = rec.indexOf("pinyinDepth"); // index of the field "name"
					 //  int pinyinReg_Idx = rec.indexOf("pinyinReg"); // index of the field "name"
					 //  int alias1_Idx = rec.indexOf("alias1"); // index of the field "name"
					 //  int alias2_Idx = rec.indexOf("alias2"); // index of the field "name"
					   int args_Idx = rec.indexOf("args"); // index of the field "name" 
					 while(query.next()) {
					 		 jsStr.append(QString("<tr bgcolor=\"#ffffff\" align=\"center\">\
								 <td width=\"8%\"><input type=\"radio\" name=\"select\" value=\"0\" onclick=\"postItem(\\'%1\\',\\'%2\\',\\'%3\\',\\'%4\\');\"></td>\
								 <td width=\"8%\">%5</td>\
								 <td width=\"64%\" style=\"font-size:10;\">%6</td>\
								 <td width=\"20%\" style=\"font-size:10;\">%7</td>\
								 </tr>")
								 .arg(query.value(shortName_Idx).toString().replace("\\", "\\\\\\\\"))
								 .arg(query.value(fullPath_Idx).toString().replace("\\", "\\\\\\\\"))
								 .arg(query.value(args_Idx).toString())
								 .arg(query.value(id_Idx).toUInt())
								 .arg(query.value(shortName_Idx).toString().replace("\\", "\\\\\\\\"))
								 .arg(query.value(fullPath_Idx).toString().replace("\\", "\\\\\\\\"))
								 .arg(query.value(args_Idx).toString()));
					 	}
		  		
		  	}
		  query.clear();
		  jsStr.append(QString("</table>';"));

	} else if (name == "list_mg_html")
	  {
		  jsStr.append(QString("document.getElementById('list_table').innerHTML='<table width=\"580\" align=\"center\" cellspacing=\"1\" >\
							 <tr bgcolor=\"#ffffff\" align=\"center\">\
							 <td width=\"10%\">选择</td>\
							 <td width=\"50%\">路径</td>\
							 <td width=\"20%\">后缀名　</td>\
							 <td width=\"10%\">子目录　</td>\
							 <td width=\"10%\">深度</td>\
							 </tr>"));
		  dirLists.clear();
		  int count = settings->beginReadArray("dirs");
		  for (int i = 0; i < count; ++i)
		    {
			    settings->setArrayIndex(i);
			    Directory tmp;
			    tmp.name = settings->value("name").toString();
			    tmp.types = settings->value("types").toStringList();
			    tmp.indexDirs = settings->value("indexDirs", false).toBool();
			    //tmp.indexExe = settings->value("indexExes", false).toBool();
			    tmp.depth = settings->value("depth", 100).toInt();
			    dirLists.append(tmp);

			    QString typesResult;
			    for (int j = 0; j < tmp.types.size(); j++)
			      {
				      //foreach (QString str, tmp.types) {
				      typesResult += tmp.types.at(j);
				      if (j != (tmp.types.size() - 1))
					      typesResult += ";";
			      }

			    jsStr.append(QString("<tr bgcolor=\"#ffffff\" align=\"center\">\
								 <td width=\"10%\"><input type=\"radio\" name=\"select\" value=\"0\" );\" onclick=\"postItem(\\'%1\\',\\'%2\\',%3,%4,%5);\"></td>\
								 <td width=\"50%\" style=\"font-size:10;\" align=\"left\">%6</td>\
								 <td width=\"20%\" style=\"font-size:10;\">%7</td>\
								 <td width=\"10%\">%8</td>\
								 <td width=\"10%\">%9</td>\
								 </tr>").arg(settings->value("name").toString().replace("\\", "\\\\\\\\")).arg(typesResult).arg(settings->value("indexDirs", false).toBool()).arg(settings->value("depth", 100).toInt()).arg(i).arg(settings->value("name").toString().replace("\\", "\\\\")).arg(typesResult).arg(settings->value("indexDirs", false).toBool()).arg(settings->value("depth", 100).toInt()));

		    }

		  settings->endArray();

		  jsStr.append(QString("</table>';"));

	  }else if(name == "adv_html"){
	   	  jsStr.append(QString("document.getElementById('ckFuzzyMatch').checked =%1;").arg(settings->value("adv/ckFuzzyMatch", false).toBool()? "true" : "false"));
		  jsStr.append(QString("document.getElementById('ckCaseSensitive').checked =%1;").arg(settings->value("adv/ckCaseSensitive", false).toBool()? "true" : "false"));
		  jsStr.append(QString("document.getElementById('ckRebuilderCatalogTimer').checked =%1;").arg(settings->value("adv/ckRebuilderCatalogTimer", false).toBool()? "true" : "false"));
		  jsStr.append(QString("document.getElementById('ckSupportIe').checked =%1;").arg(settings->value("adv/ckSupportIe", false).toBool()? "true" : "false"));
		  jsStr.append(QString("document.getElementById('ckSupportFirefox').checked =%1;").arg(settings->value("adv/ckSupportFirefox", false).toBool()? "true" : "false"));
		  jsStr.append(QString("document.getElementById('ckSupportOpera').checked =%1;").arg(settings->value("adv/ckSupportOpera", false).toBool()? "true" : "false"));
	  	}
	webView->page()->mainFrame()->evaluateJavaScript(jsStr);
}

void OptionsDlg::accept()
{
	settings->sync();
	QDialog::accept();
}

void OptionsDlg::reject()
{
	QDialog::reject();
}
void OptionsDlg::apply(const QString & name, const QVariant & value)
{
	settings->setValue(name, value);
	if(name=="generalOpt/ckStartWithSystem"){
		QDEBUG("set generalOpt/ckStartWithSystem! ");
		QSettings s(QString("HKEY_LOCAL_MACHINE\\Software\\microsoft\\windows\\currentversion\\run"),QSettings::NativeFormat);	
		QString filepath=qApp->applicationFilePath().replace(QString("/"), QString("\\"));
		if(QVariant(value).toBool())
			s.setValue(APP_NAME, filepath);
		else
			s.remove(APP_NAME);
		s.sync();
	}
}
void OptionsDlg::addCatitemToDb(CatItem& item)
{
	QSqlQuery query("",*db_p);
	QString queryStr=QString("INSERT INTO %1 (fullPath, shortName, lowName,"
				   "icon,usage,hashId,"
				   "groupId, parentId, isHasPinyin,"
				   "comeFrom,hanziNums,pinyinDepth,"
				   "pinyinReg,alias1,alias2,shortCut,delId,args) "
				   "VALUES ('%2','%3','%4','%5',%6,%7,%8,%9,%10,%11,%12,%13,'%14','%15','%16','%17',%18,'%19')").arg(DB_TABLE_NAME).arg(item.fullPath) .arg(item.shortName).arg(item.lowName)
				   .arg(item.icon).arg(item.usage).arg(qHash(item.fullPath))
				   .arg(item.groupId).arg(item.parentId).arg(item.isHasPinyin)
				   .arg(item.comeFrom).arg(item.hanziNums).arg(item.pinyinDepth)
				   .arg(item.pinyinReg).arg(item.alias1).arg(item.alias2).arg(item.shortCut).arg(item.delId).arg(item.args);
	qDebug("queryStr=%s",qPrintable(queryStr));
	query.exec(queryStr);
	query.clear();
	
}
void OptionsDlg::modifyCatitemFromDb(CatItem& item,uint index)
{
	QSqlQuery query("",*db_p);
	QString queryStr=QString("update %1 set fullPath='%2', shortName='%3', lowName='%4',"
				   "icon='%5',usage=%6,hashId=%7,"
				   "groupId=%8, parentId=%9, isHasPinyin=%10,"
				   "comeFrom=%11,hanziNums=%12,pinyinDepth=%13,"
				   "pinyinReg='%14',alias1='%15',alias2='%16',shortCut='%17',delId=%18 where id=%19)").arg(DB_TABLE_NAME).arg(item.fullPath) .arg(item.shortName).arg(item.lowName)
				   .arg(item.icon).arg(item.usage).arg(qHash(item.fullPath))
				   .arg(item.groupId).arg(item.parentId).arg(item.isHasPinyin)
				   .arg(item.comeFrom).arg(item.hanziNums).arg(item.pinyinDepth)
				   .arg(item.pinyinReg).arg(item.alias1).arg(item.alias2).arg(item.shortCut).arg(item.delId).arg(index);
	query.exec(queryStr);
	query.clear();
}
void OptionsDlg::deleteCatitemFromDb(CatItem& item,uint index)
{
	QSqlQuery query("",*db_p);
	QString queryStr=QString("delete from %1 where id=%2").arg(DB_TABLE_NAME).arg(index) ;;
	query.exec(queryStr);
	query.clear();
}


void OptionsDlg::cmdApply(const int &type, const QString & cmdName, const QString & cmdCommand, const QString & cmdParameter, const QString & cmdIndex)
{
	//CMD_LIST cl;
	qDebug("type=%d cmdinex=%d cmdLists.size=%d",type,cmdIndex.toInt(),cmdLists.size());
	CatItem item(cmdCommand,cmdName,cmdParameter,COME_FROM_RUNNER);
	if(cmdCommand.isEmpty()) return;
	switch (type)
	  {
	  case 0:		//add
		 // cl.index = cmdLists.size();
		 // cl.name = cmdName;
		 // cl.base = cmdCommand;
		 // cl.parameters = cmdParameter;
		//  cmdLists << cl;
		  addCatitemToDb(item);
		  break;
	  case 1:		//modify

		//  cl.index = cmdIndex.toInt();
		//  cl.name = cmdName;
		//  cl.base = cmdCommand;
		//  cl.parameters = cmdParameter;
		//  cmdLists.replace(cmdIndex.toInt(), cl);
		  modifyCatitemFromDb(item,cmdIndex.toInt());
		  break;
	  case 2:		//delete
	  	  qDebug("type=%d cmdinex=%d cmdLists.size=%d",type,cmdIndex.toInt(),cmdLists.size());
		//  cmdLists.removeAt(cmdIndex.toInt());
		 deleteCatitemFromDb(item,cmdIndex.toInt());
		  break;
	  default:
		  break;
	  }
	qDebug("type=%d cmdinex=%d cmdLists.size=%d",type,cmdIndex.toInt(),cmdLists.size());
#if 1
/*
		QString pattern("^[ ]{0,}[a-zA-Z]:\\[^/*\"<>\|\?]*$");
		QRegExp pathReg(pattern);
		pathReg.setCaseSensitivity(Qt::CaseSensitive);
		QRegExp::PatternSyntax syntax = QRegExp::PatternSyntax(QRegExp::RegExp);
		pathReg.setPatternSyntax(syntax);
		int cmdindex=0;
		int webIndex=0;
		for (int i = 0; i < cmdLists.size(); i++)
		  {
		  	//int cmdLength=cmdLists.at(i).base.length();
			//int matchPos=pathReg.indexIn(cmdLists.at(i).base);
			//int matchLength=pathReg.matchedLength();
				//if(matchPos==0&&cmdLength==matchLength){
				 	  settings->beginWriteArray("runner/cmds");
				  	  settings->setArrayIndex(i);
					  settings->setValue("name", cmdLists.at(i).name);
					  settings->setValue("file", cmdLists.at(i).base);
					  settings->setValue("args", cmdLists.at(i).parameters);
					  settings->endArray();
				}else{
					  settings->beginWriteArray("weby/sites");	
					  settings->setArrayIndex(webIndex++);
					  settings->setValue("name", cmdLists.at(i).name);
					  settings->setValue("base", cmdLists.at(i).base);
					  settings->setValue("query", cmdLists.at(i).parameters);
					  settings->setValue("default", true);
					  settings->endArray();
				}
		  }
*/	
#else
	QString pattern("^[ ]{0,}[a-zA-Z]:\[^/*\"<>\|?]*$");
	QRegExp pathReg(pattern);
	pathReg.setCaseSensitivity(Qt::CaseSensitive);
	QRegExp::PatternSyntax syntax = QRegExp::PatternSyntax(QRegExp::RegExp);
	pathReg.setPatternSyntax(syntax);
	int cmdLength=cmdCommand.length();
	int matchPos=pathReg.indexIn(cmdCommand);
	int matchLength=pathReg.matchedLength();
        QDEBUG("cmd=%s regvalid=%d cmdlength=%d matchPos=%d matchLength=%d\n",qPrintable(cmdCommand),pathReg.isValid(),cmdLength,matchPos,matchLength);
	if(matchPos==0&&cmdLength==matchLength){
//is command
		settings->beginWriteArray("runner/cmds");		
		for (int i = 0; i < cmdLists.size(); ++i)
		  {
		  	  settings->setArrayIndex(i);
			  settings->setValue("name", cmdLists.at(i).name);
			  settings->setValue("file", cmdLists.at(i).base);
			  settings->setValue("args", cmdLists.at(i).parameters);
		  }
		settings->endArray();
	}else{//is http
		settings->beginWriteArray("weby/sites");		
		for (int i = 0; i < cmdLists.size(); ++i)
		  {
		  	  settings->setArrayIndex(i);
			  settings->setValue("name", cmdLists.at(i).name);
			  settings->setValue("base", cmdLists.at(i).base);
			  settings->setValue("query", cmdLists.at(i).parameters);
			  settings->setValue("default", true);
		  }
		settings->endArray();
		}
#endif

}
int OptionsDlg::checkListDirExist(const QString& dirname)
{
	for (int i = 0; i < dirLists.size(); ++i)
		{
			        QDEBUG("name=%s dirname=%s\n",qPrintable(dirLists.at(i).name),qPrintable(dirname));
				if(dirLists.at(i).name==dirname){
						return 1;
					}
		}
	return 0;
}
int OptionsDlg::checkListDirSpecialchar(const QString& dirname)
{
	QList<QChar> specialChars;
	specialChars<<QChar('?')<<QChar('"')<<QChar('&');
	for(int i=0;i<specialChars.count();i++){
			if(dirname.contains(specialChars.at(i), Qt::CaseInsensitive))
				return 1;
		}
	return 0;
}
void OptionsDlg::listApply(const int &type, const QString & listPath, const QString & listSuffix, const bool & isIncludeChildDir, const int &childDeep, const int &index)
{
	
	Directory dc;
	QDir dir(listPath);
	int err=0;
	
	switch (type)
	  {
	  case 0:		//add
	  	  //check the dir path	  	
		  if(listPath.isEmpty()||checkListDirSpecialchar(listPath)||!dir.exists()) err=-2;
		  if(checkListDirExist(listPath))	err=-1;  
		  QDEBUG("err=%d\n",err);
 		  if(err<0) goto ERR;
		  dc.index = dirLists.size();
		  dc.name = listPath;
		  dc.types = listSuffix.split(";", QString::SkipEmptyParts);
		  dc.indexDirs = isIncludeChildDir;
		  dc.depth = childDeep;
		  dirLists << dc;
		  break;
	  case 1:
	  		  if(listPath.isEmpty()||checkListDirSpecialchar(listPath)||!dir.exists()) err=-2;
			  if(checkListDirExist(listPath))	err=-1;
			  if(err<0) goto ERR;
			  dc.index = index;
			  dc.name = listPath;
			  dc.types = listSuffix.split(";", QString::SkipEmptyParts);
			  dc.indexDirs = isIncludeChildDir;
			  dc.depth = childDeep;
			  dirLists.replace(index, dc);	  
		  break;
	  case 2:
		  dirLists.removeAt(index);
		  break;
	  }
	settings->beginWriteArray("dirs");
	for (int i = 0; i < dirLists.size(); ++i)
	  {
		  settings->setArrayIndex(i);
		  QDEBUG("directory path:%s",qPrintable(dirLists.at(i).name));
		  settings->setValue("name", qPrintable(dirLists.at(i).name));
		  settings->setValue("types", dirLists.at(i).types);
		  settings->setValue("indexDirs", dirLists.at(i).indexDirs);
		  settings->setValue("depth", dirLists.at(i).depth);
	  }
	settings->endArray();
	return;
ERR:
	  QString errstr;
	  switch(err){
	  		case -1:
				errstr=QString("alert('指定项已存在!');");
				break;
			case -2:
				errstr=QString("alert('指定路径不存在!');");
				break;
			default:
				break;
	  	}
	   webView->page()->mainFrame()->evaluateJavaScript(errstr);


}
#endif
/*
	type:
			0---just show directory
			1---show all
*/
void OptionsDlg::getListDirectory(const QString & id,const int& type)
{
	QString dir ;
	if(type==0)
		dir= QFileDialog::getExistingDirectory(this, tr("Select a directory"), "C:", QFileDialog::ShowDirsOnly);
	else
		 dir= QFileDialog::getOpenFileName(this, tr("Open File"),"C:", tr("*.*"));
	QMessageBox msgBox;
	QString str = QString("%1 ").arg(dir.replace("/", "\\\\"));
	msgBox.setText(str);
	msgBox.exec();

	QString status = QString("document.getElementById('%1').value= '%2';").arg(id).arg(dir.replace("/", "\\\\"));
	webView->page()->mainFrame()->evaluateJavaScript(status);
}
void OptionsDlg::rebuildcatalog()
{	
	
	/*if(catalogBuilder) {
		QDEBUG("catalog builder is runing!");
		return;
		}
		*/
        emit rebuildcatalogSignal();
}

void OptionsDlg::startUpdater()
{
	if(!updaterDlg){
		updaterDlg = new synchronizeDlg(this);
		}
	qDebug("updaterthread=0x%08x,isFinished=%d",updaterthread,(updaterthread)?updaterthread->isFinished():0);
	if(!updaterthread||updaterthread->isFinished()){
	
		updaterThread* updaterthread=new updaterThread(updaterDlg);	
		connect(updaterDlg,SIGNAL(updateSuccessNotify()),this->parent(),SLOT(updateSuccess()));
		connect(updaterDlg,SIGNAL(reSync()),this,SLOT(startUpdater()));
		updaterthread->start(QThread::IdlePriority);		
	}

		updaterDlg->setModal(1);
		updaterDlg->show();	
		
}