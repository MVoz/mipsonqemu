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

#include <optionUI.h>
#include <globals.h>

#include <QDesktopWidget>
#include <catalog.h>

OptionsDlg::OptionsDlg(QWidget * parent,QSettings *s,QSqlDatabase *b):QDialog(parent,Qt::SplashScreen|Qt::MSWindowsFixedSizeDialogHint
| Qt::WindowTitleHint),settings(s),db(b)
{
	manager=NULL;
	reply=NULL;
	updaterDlg=NULL;
	updaterthread=NULL;
	testProxyTimer =NULL;
	proxy = NULL;
	testproxying = 0;
	webView = new QWebView(this);

	webView->setObjectName(QString::fromUtf8("webView"));
	webView->setMinimumSize(QSize(805, 480));
	webView->setMaximumSize(QSize(805, 16777215));
	webView->setContextMenuPolicy(Qt::NoContextMenu);
	connect(webView->page()->mainFrame(), SIGNAL(javaScriptWindowObjectCleared()), this, SLOT(populateJavaScriptWindowObject()));
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

	//getHtml("./html/Customx.html");
	getHtml("./html/common.html");
	/*
	webView->setHtml(QString("data:text/html,<frameset rows=\"100px,*\">"
								"<frame src=\"./html/menu.html\">"
								"<frame src=\"data:text/html,content\"></frameset>"), QUrl());
	*/
	QDesktopWidget* desktop = QApplication::desktop(); // =qApp->desktop();
	move((desktop->width() - width())/2,(desktop->height() - height())/2); 


}
OptionsDlg::~OptionsDlg()
{
	QResource::unregisterResource("options.rcc");
	if(testproxying){
		disconnect(manager, 0, 0, 0);
		proxyTestTimeout();
	}
	dirLists.clear();
	metaKeys.clear();
	iActionKeys.clear();
	actionKeys.clear();	
	DELETE_OBJECT(reply);
	DELETE_OBJECT(proxy);
	DELETE_OBJECT(manager);
	DELETE_OBJECT(updaterthread);
	DELETE_OBJECT(updaterDlg);
	DELETE_OBJECT(webView);
	DELETE_TIMER(testProxyTimer);	
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
}
void OptionsDlg::proxyTestFinished(QNetworkReply * testreply)
{	
	int err=testreply->error();
	qDebug("%s error=%d\n",__FUNCTION__,testreply->error());
	STOP_TIMER(testProxyTimer);	
	switch (err){
		case QNetworkReply::NoError:
			QMessageBox::information(this, windowTitle(), tz::tr("proxy_test_success"));
			break;
		case  QNetworkReply::ProxyAuthenticationRequiredError:
			QMessageBox::critical(0, windowTitle(), QObject::tr("The proxy server needs the right name and password"));			
			break;
		default:
			QMessageBox::critical(this, windowTitle(), QObject::tr("The proxy server works failed"));
			break;			
	}
	reply->close();
	disconnect(manager, 0, 0, 0);	
	testproxying = 0;
}
void OptionsDlg::proxyTestTimeout()
{
	STOP_TIMER(testProxyTimer);
	if(reply) 
		reply->abort();
}
void OptionsDlg::proxyTestClick(const QString& proxyAddr,const QString& proxyPort,const QString& proxyUsername,const QString& proxyPassword)
{
	if(testproxying){
		return;		
	}
	testproxying = 1;
	DELETE_TIMER(testProxyTimer);
	DELETE_OBJECT(proxy);
	DELETE_OBJECT(reply);
	DELETE_OBJECT(manager);
	if(!manager)
	{
		request.setUrl(QUrl(QString("http://www.sohu.com")));
		request.setRawHeader("User-Agent", "MyOwnBrowser 1.0");
		manager = new QNetworkAccessManager(this);

		if(proxy ==NULL)
		{
				proxy=new QNetworkProxy();
				proxy->setType(QNetworkProxy::HttpProxy);				
		}
		if(proxy){
				proxy->setHostName(proxyAddr);		
				proxy->setPort(proxyPort.toUInt());
				proxy->setUser(proxyUsername);
				proxy->setPassword(proxyPassword);
		}
		
		manager->setProxy(*proxy);
		manager->setObjectName(tr("manager"));

		reply=manager->get(request);

		START_TIMER_SYN(testProxyTimer,TRUE,10*SECONDS,proxyTestTimeout);
		connect(manager, SIGNAL(finished(QNetworkReply *)), this, SLOT(proxyTestFinished(QNetworkReply *)));
	}

}
void OptionsDlg::accountTestClick(const QString& name,const QString& password)
{
	qDebug("username=%s password=%s......",qPrintable(name),qPrintable(password));
	emit testAccountNotify(name,password);
}
QString OptionsDlg::tr(const QString & s){
	 return tz::tr(TOCHAR(s));
}
void OptionsDlg::getHtml(const QString & path)
{
	QFile htmlFile(path);
	if (!htmlFile.open(QIODevice::ReadOnly | QIODevice::Text))
		return;
	webView->setHtml(trUtf8(htmlFile.readAll()));

	htmlFile.close();
}
void OptionsDlg::gohref(const QString & url)
{
	runProgram(url,"");
}
void OptionsDlg::loading(const QString & name)
{
	QString jsStr;
	//menu
	QString menustring;
	//menustring.append("<ul>");
	QStringList menulsit;
	menulsit<<"Common"<<"bookmark"<<"Custom"<<"Command"<<"Advance"<<"Network"<<"About";
	foreach (QString m, menulsit) {
		menustring.append("<li>");
    		menustring.append("<a href=\"#\" onclick=\"getHtml('./html/"+m+".html');\""+((m==name)?"class=\"current\"":"")+">"+tz::tr(TOCHAR(m))+"</a>");
		menustring.append("</li>");
        }
	//menustring.append("</ul>");
	menustring.replace("\"","\\\"");
	jsStr.append("$('#tmenu').html(\""+menustring+"\");");
	//footer
	QString footerstring;
	footerstring.append("<div class=\"btn\">");
	footerstring.append("<a href=\"#\"  onclick=\"reject();\" >"+tz::tr("cancel")+"</a>");
	footerstring.append("</div >");
	footerstring.append("<div  class=\"btn\">");
	footerstring.append("<a href=\"#\"  onclick=\"apply('"+name+"');\" >"+tz::tr("apply")+"</a>");
	footerstring.append("</div >");
	footerstring.append("<p style=\"text-align:center;\">");
	footerstring.append("Copyright 2010 ");
	footerstring.append("<a  href=\"#\" onclick=\"gohref('"HTTP_SERVER_URL"');\">"+tz::tr(APP_NAME)+"</a>");
	footerstring.append("</p>");
	footerstring.replace("\"","\\\"");
	jsStr.append("$('#footer').html(\""+footerstring+"\");");

	if (name == "Common")
	{
		JS_APPEND_CHECKED("ckStartWithSystem","",false);
		JS_APPEND_CHECKED("ckShowTray","",true);
		JS_APPEND_CHECKED("ckShowMainwindow","",false);
		JS_APPEND_CHECKED("ckAutoUpdate","",false);
		JS_APPEND_CHECKED("ckScanDir","",false);
		JS_APPEND_VALUE("Username","Account","");
		JS_APPEND_PASSWD("Userpasswd","Account","");
		//lastsynctime
		QDateTime lastsynctime=QDateTime::fromTime_t(settings->value("lastbmsync", 0).toUInt());
		uint lastsyncstatus=settings->value("lastsyncstatus", SYNC_STATUS_FAIL).toUInt();
		jsStr.append(QString("$obj('lastbmsync').innerHTML ='%1';").arg(lastsynctime.toString(Qt::SystemLocaleShortDate)));
		switch(lastsyncstatus){
			case SYNC_STATUS_FAIL:
				jsStr.append(QString("$obj('lastsyncstatus').innerHTML ='';"));	
				jsStr.append(QString("$obj('lastsyncstatus').className ='fail';"));	
				break;
			case SYNC_STATUS_SUCCESS:
				jsStr.append(QString("$obj('lastsyncstatus').innerHTML ='';"));	
				jsStr.append(QString("$obj('lastsyncstatus').className ='success';"));	
				break;
			case SYNC_STATUS_PROCESSING:
				jsStr.append(QString("$obj('lastsyncstatus').className ='';"));	
				jsStr.append(QString("$obj('lastsyncstatus').innerHTML ='processing...';"));	
				break;
		}		
		
		int curMeta = settings->value("hotkeyModifier", HOTKEY_PART_0).toInt();
		int curAction = settings->value("hotkeyAction", HOTKEY_PART_1).toInt();
		jsStr.append(QString("set_selected('%1','hotkey_0');").arg(curMeta));
		jsStr.append(QString("set_selected('%1','hotkey_1');").arg(curAction));
	}else if (name == "bookmark"){
		/*
		QString   name=settings->value("Account/Username","").toString();
		QString   password=tz::decrypt(settings->value("Account/Userpasswd","").toString(),PASSWORD_ENCRYPT_KEY);	
		jsStr.append(QString("$('#netbookmark').attr(\"src\",\"http://"HTTP_SERVER_HOST"/do.php?ac=4e9ded254714e0a04aca9db62e5e8fd9&source=client&username="+name+"&password="+password+"\");"));	
		*/
		jsStr.append("$('#menu').html('");
		netbookmarkmenu(COME_FROM_MYBOOKMARK,0,"getbmfromid",jsStr);
		getbmfromid(0,COME_FROM_MYBOOKMARK,"root",1);
		jsStr.append("');");
		
		JS_APPEND_VALUE("netbookmarkbrowser","","");
		//qDebug()<<jsStr;
	}else if (name == "Network"){
		JS_APPEND_CHECKED("proxyEnable","HttpProxy",false);
		JS_APPEND_VALUE("proxyAddress","HttpProxy","");
		JS_APPEND_VALUE("proxyPort","HttpProxy","");
		JS_APPEND_VALUE("proxyUsername","HttpProxy","");
		JS_APPEND_PASSWD("proxyPassword","HttpProxy","");
		jsStr.append(QString("$('#version').html('%1');").arg(APP_VERSION));
		jsStr.append(QString("proxyEnableClick();"));

	} else if (name == "Command"){
		/*jsStr.append(QString("$('cmd_table').innerHTML='<table width=\"100%\" align=\"center\" cellspacing=\"1\" >\
							 <tr bgcolor=\"#ffffff\" align=\"center\">\
							 <td width=\"5%\">"+tz::tr("html_select")+"</td>\
							 <td width=\"15%\">"+tz::tr("html_name")+"</td>\
							 <td width=\"60%\">"+tz::tr("html_command")+"</td>\
							 <td width=\"20%\">"+tz::tr("html_argument")+"</td>\
							 </tr>"));
		*/
		jsStr.append("$('#cmdlist').html('");
		//cmdLists.clear();
		QSqlQuery q("",*db);
		QString  s=QString("SELECT * FROM %1 ").arg(DBTABLEINFO_NAME(COME_FROM_COMMAND));
		int i = 0;
		if(q.exec(s))
		{
			while(q.next()) {
				qDebug()<<Q_VALUE_STRING(q,"shortName")<<":"<<Q_VALUE_STRING(q,"fullPath");
				jsStr.append(QString("<tr class=\"%1\">").arg((i%2)?("even"):("odd")));
				jsStr.append("<td><input type=\"radio\" name=\"select\" ");
				jsStr.append(QString("onclick=\"postItem(\\'%1\\',\\'%2\\',\\'%3\\',\\'%4\\');\">").arg(Q_VALUE_STRING_HTML(q,"shortName")).arg(Q_VALUE_STRING_HTML(q,"fullPath")).arg(Q_VALUE_STRING(q,"args")).arg(Q_VALUE_UINT(q,"id")));
				jsStr.append("</td>");
				jsStr.append("<td >"+Q_VALUE_STRING(q,"shortName").replace("\\", "\\\\")+"</td>");
				jsStr.append("<td >"+Q_VALUE_STRING(q,"fullPath").replace("\\", "\\\\")+"</td>");
				jsStr.append("<td >"+Q_VALUE_STRING(q,"args")+"</td>");

				//action
				jsStr.append(QString("<td > <a class=\"thickbox\" "));
				jsStr.append(QString("onclick=\"postItem(\\'%1\\',\\'%2\\',\\'%3\\',\\'%4\\');\" ").arg(Q_VALUE_STRING_HTML(q,"shortName")).arg(Q_VALUE_STRING_HTML(q,"fullPath")).arg(Q_VALUE_STRING(q,"args")).arg(Q_VALUE_UINT(q,"id")));
				
				jsStr.append(QString("href=\"qrc:editcmd\">edit</a> "));
				jsStr.append(QString("<a class=\"thickbox\"")); 
				jsStr.append(QString("onclick=\"postDelItem(\\'%1\\',%2);\" ").arg(Q_VALUE_STRING_HTML(q,"fullPath")).arg(Q_VALUE_UINT(q,"id")));
					
				jsStr.append(QString("href=\"qrc:deletecmd\">del</a>"));
				jsStr.append(QString("</td >"));
				/*				
				jsStr.append(QString("<tr bgcolor=\"#ffffff\" align=\"center\">\
									 <td width=\"5%\"><input type=\"radio\" name=\"select\" value=\"0\" onclick=\"postItem(\\'%1\\',\\'%2\\',\\'%3\\',\\'%4\\');\"></td>\
									 <td width=\"15%\">%5</td>\
									 <td width=\"60%\"  style=\"font-size:10;\" align=\"left\"><span class=\"cmd\">%6</span></td>\
									 <td width=\"20%\" style=\"font-size:10;\">%7</td>\
									 </tr>")
									 .arg(q.value(shortName_Idx).toString().replace("\\", "\\\\\\\\"))
									 .arg(q.value(fullPath_Idx).toString().replace("\\", "\\\\\\\\"))
									 .arg(q.value(args_Idx).toString())
									 .arg(q.value(id_Idx).toUInt())
									 .arg(q.value(shortName_Idx).toString().replace("\\", "\\\\"))
									 .arg(q.value(fullPath_Idx).toString().replace("\\", "\\\\"))
									 .arg(q.value(args_Idx).toString()));
				*/
				i++;
			}

		}
		q.clear();
		jsStr.append("');");
		//jsStr.append(QString("</table>';"));

	} else if (name == "Custom")
	{
#ifdef CONFIG_OPTION_NEWUI
		dirLists.clear();
		int count = settings->beginReadArray("directories");
		jsStr.append("$('#dirlist').html('");
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
				typesResult += tmp.types.at(j);
				if (j != (tmp.types.size() - 1))
					typesResult += ";";
			}
			jsStr.append(QString("<tr class=\"%1\">").arg((i%2)?("even"):("odd")));
			jsStr.append("<td><input type=\"radio\" name=\"select\" ");
			jsStr.append(QString("onclick=\"postItem(\\'%1\\',\\'%2\\',%3,%4,%5);\">").arg(settings->value("name").toString().replace("\\", "\\\\\\\\")).arg(typesResult).arg(settings->value("indexDirs", false).toBool()).arg(settings->value("depth", 100).toInt()).arg(i));
			jsStr.append("</td>");
			jsStr.append("<td >"+settings->value("name").toString().replace("\\", "\\\\")+"</td>");
			jsStr.append("<td >"+typesResult+"</td>");
			jsStr.append(QString("<td >%1</td>").arg(settings->value("indexDirs", false).toBool()));
			jsStr.append(QString("<td >%1</td>").arg(settings->value("depth", 100).toInt()));
			jsStr.append(QString("<td > <a class=\"thickbox\" "));
			jsStr.append(QString("onclick=\"postItem(\\'%1\\',\\'%2\\',%3,%4,%5);\" ").arg(settings->value("name").toString().replace("\\", "\\\\\\\\")).arg(typesResult).arg(settings->value("indexDirs", false).toBool()).arg(settings->value("depth", 100).toInt()).arg(i));
			
			jsStr.append(QString("href=\"qrc:editdir\">edit</a> "));
			jsStr.append(QString("<a class=\"thickbox\"")); 
			jsStr.append(QString("onclick=\"postDelItem(\\'%1\\',%2);\" ").arg(settings->value("name").toString().replace("\\", "\\\\\\\\")).arg(i));
				
			jsStr.append(QString("href=\"qrc:deletedir\">del</a>"));
			jsStr.append(QString("</td >"));

		}
		jsStr.append("');");
		settings->endArray();
#else
		jsStr.append(QString("$('list_table').innerHTML='<table width=\"580\" align=\"center\" cellspacing=\"1\" >\
							 <tr bgcolor=\"#ffffff\" align=\"center\">\
							 <td width=\"5%\">"+tz::tr("html_select")+"</td>\
							 <td width=\"61%\">"+tz::tr("html_path")+"</td>\
							 <td width=\"20%\">"+tz::tr("html_suffix")+"</td>\
							 <td width=\"7%\">"+tz::tr("html_childdir")+"</td>\
							 <td width=\"7%\">"+tz::tr("html_depth")+"</td>\
							 </tr>"));
		dirLists.clear();
		int count = settings->beginReadArray("directories");
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
								 <td width=\"5%\"><input type=\"radio\" name=\"select\" value=\"0\" );\" onclick=\"postItem(\\'%1\\',\\'%2\\',%3,%4,%5);\"></td>\
								 <td width=\"61%\" style=\"font-size:10;\" align=\"left\">%6</td>\
								 <td width=\"20%\" style=\"font-size:10;\">%7</td>\
								 <td width=\"7%\">%8</td>\
								 <td width=\"7%\">%9</td>\
								 </tr>").arg(settings->value("name").toString().replace("\\", "\\\\\\\\")).arg(typesResult).arg(settings->value("indexDirs", false).toBool()).arg(settings->value("depth", 100).toInt()).arg(i).arg(settings->value("name").toString().replace("\\", "\\\\")).arg(typesResult).arg(settings->value("indexDirs", false).toBool()).arg(settings->value("depth", 100).toInt()));

		}

		settings->endArray();

		jsStr.append(QString("</table>';"));
#endif

	}else if(name == "Advance"){
		JS_APPEND_CHECKED("ckFuzzyMatch","adv",false);
		JS_APPEND_CHECKED("ckCaseSensitive","adv",false);
		JS_APPEND_CHECKED("ckRebuilderCatalogTimer","adv",false);
		JS_APPEND_CHECKED("ckSupportIe","adv",true);
		JS_APPEND_CHECKED("ckSupportFirefox","adv",false);
		JS_APPEND_CHECKED("ckSupportOpera","adv",false);
		JS_APPEND_CHECKED("baidu","netfinder",true);
		JS_APPEND_CHECKED("google","netfinder",true);
		JS_APPEND_VALUE("netsearchbrowser","","");		
	}else if(name=="About"){
		jsStr.append(QString("$('#version').html('%1');").arg(APP_VERSION));
		jsStr.append(QString("$('#buildtime').html('%1');").arg(QDateTime::fromTime_t(APP_BUILD_TIME).toString(Qt::SystemLocaleShortDate)));
	}

	if(name =="bookmark"){
		jsStr.append("$(function(){initMenuEx();});");
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
	if(name=="ckStartWithSystem"){
		QSettings s(QString("HKEY_LOCAL_MACHINE\\Software\\microsoft\\windows\\currentversion\\run"),QSettings::NativeFormat);	
		QString filepath=qApp->applicationFilePath().replace(QString("/"), QString("\\"));
		if(QVariant(value).toBool())
			s.setValue(APP_NAME, filepath);
		else
			s.remove(APP_NAME);
		s.sync();
	}else if(name=="adv/ckCaseSensitive"){
		QSqlQuery q("",*db);
		QString s = QString("PRAGMA case_sensitive_like %1").arg(QVariant(value).toBool()?1:0);
		qDebug() << s;
		q.exec(s);
		q.clear();
	}else if((name=="Account/Userpasswd")||(name=="HttpProxy/proxyPassword")){
		settings->setValue(name, tz::encrypt(value.toString(),PASSWORD_ENCRYPT_KEY));
		settings->sync();
		return;
	}
	settings->setValue(name, value);
	settings->sync();
	if(name=="hotkeyAction")
		emit configModifyNotify(HOTKEY);			
	else if(name == "ckShowTray")
		emit configModifyNotify(SHOWTRAY);	
	else if(name.startsWith("HttpProxy"))
		emit configModifyNotify(NETPROXY);	
	else if(name=="adv/ckSupportIe"||name=="adv/ckSupportFirefox"||name=="adv/ckSupportOpera"||name=="netbookmarkbrowser"){
		setBrowserEnable(settings);
	}
		
}




void OptionsDlg::cmdApply(const int &type, const QString & cmdName, const QString & cmdCommand, const QString & cmdParameter, const QString & cmdIndex)
{
	//CMD_LIST cl;
	//qDebug("type=%d cmdinex=%d cmdLists.size=%d",type,cmdIndex.toInt(),cmdLists.size());
	CatItem item(cmdCommand,cmdName,cmdParameter,COME_FROM_COMMAND);
	if(cmdCommand.isEmpty()) return;
	switch (type)
	{
	case 0:		//add
		CatItem::addCatitemToDb(db,item);
		break;
	case 1:		//modify
		CatItem::modifyCatitemFromDb(db,item,cmdIndex.toInt());
		break;
	case 2:		//delete
		//qDebug("type=%d cmdinex=%d cmdLists.size=%d",type,cmdIndex.toInt(),cmdLists.size());
		//  cmdLists.removeAt(cmdIndex.toInt());
		CatItem::deleteCatitemFromDb(db,item,cmdIndex.toInt());
		break;
	default:
		break;
	}
	emit configModifyNotify(CMDLIST);

}
int OptionsDlg::checkListDirExist(const QString& dirname)
{
	for (int i = 0; i < dirLists.size(); ++i)
	{
		qDebug("name=%s dirname=%s\n",qPrintable(dirLists.at(i).name),qPrintable(dirname));
		if(dirLists.at(i).name==dirname){
			return i;
		}
	}
	return -1;
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
		if(checkListDirExist(listPath)>=0)	err=-1;  
		qDebug("err=%d\n",err);
		if(err<0) goto ERR;
		dc.index = dirLists.size();
		dc.name = listPath;
		dc.types = listSuffix.split(";", QString::SkipEmptyParts);
		dc.indexDirs = isIncludeChildDir;
		dc.depth = childDeep;
		dirLists << dc;
		break;
	case 1:
		{
			if(listPath.isEmpty()||checkListDirSpecialchar(listPath)||!dir.exists()) err=-2;
			int existindex = checkListDirExist(listPath);
			if((existindex>=0)&&(existindex!=index))	
				err=-1;
			if(err<0) goto ERR;
			dc.index = index;
			dc.name = listPath;
			dc.types = listSuffix.split(";", QString::SkipEmptyParts);
			dc.indexDirs = isIncludeChildDir;
			dc.depth = childDeep;
			dirLists.replace(index, dc);	  
		}
		break;
	case 2:
		dirLists.removeAt(index);
		break;
	}
	settings->beginWriteArray("directories");
	for (int i = 0; i < dirLists.size(); ++i)
	{
		settings->setArrayIndex(i);
		settings->setValue("name", dirLists.at(i).name);
		settings->setValue("types", dirLists.at(i).types);
		settings->setValue("indexDirs", dirLists.at(i).indexDirs);
		settings->setValue("depth", dirLists.at(i).depth);
	}
	settings->endArray();
	emit configModifyNotify(DIRLIST);
	return;
ERR:
	QString errstr;
	switch(err){
			case -1:
				errstr=QString("alert('"+tz::tr("err_has_exist_item")+"');");
				break;
			case -2:
				errstr=QString("alert('"+tz::tr("err_no_exist_item")+"');");
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
//	QMessageBox msgBox;
//	QString str = QString("%1 ").arg(dir.replace("/", "\\\\"));
//	msgBox.setText(str);
//	msgBox.exec();

	QString status = QString("$('%1').attr('value', '%2');").arg(id).arg(dir.replace("/", "\\\\"));
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
		appUpdater* updaterthread=new appUpdater(updaterDlg,settings,UPDATE_DLG_MODE);	
		connect(updaterDlg,SIGNAL(updateSuccessNotify()),this->parent(),SLOT(updateSuccess()));
		connect(updaterDlg,SIGNAL(reSyncNotify()),this,SLOT(startUpdater()));
		updaterthread->start(QThread::IdlePriority);		
	}

	updaterDlg->setModal(1);
	updaterDlg->show();	
}
void OptionsDlg::getSyncStatus()
{
		//lastsynctime
		QString jsStr;
		QDateTime lastsynctime=QDateTime::fromTime_t(settings->value("lastbmsync", 0).toUInt());
		uint lastsyncstatus=settings->value("lastsyncstatus", SYNC_STATUS_FAIL).toUInt();
		jsStr.append(QString("$('lastbmsync').innerHTML ='%1';").arg(lastsynctime.toString(Qt::SystemLocaleShortDate)));
		switch(lastsyncstatus){
			case SYNC_STATUS_FAIL:
				jsStr.append(QString("$('lastsyncstatus').innerHTML ='';"));	
				jsStr.append(QString("$('lastsyncstatus').className ='fail';"));	
				break;
			case SYNC_STATUS_SUCCESS:
				jsStr.append(QString("$('lastsyncstatus').innerHTML ='';"));	
				jsStr.append(QString("$('lastsyncstatus').className ='success';"));	
				break;
			case SYNC_STATUS_PROCESSING:
				jsStr.append(QString("$('lastsyncstatus').className ='';"));	
				jsStr.append(QString("$('lastsyncstatus').innerHTML ='processing...';"));	
				break;
		}		
		
		webView->page()->mainFrame()->evaluateJavaScript(jsStr);
}
/*
synchronizeDlg parts
*/

synchronizeDlg::synchronizeDlg(QWidget * parent):QDialog(parent)
{
	QResource::registerResource("options.rcc");
	setResult(2);
	webView = new QWebView(this);
	webView->setObjectName(QString::fromUtf8("webView"));
	webView->setContextMenuPolicy(Qt::NoContextMenu);
	connect(webView->page()->mainFrame(), SIGNAL(javaScriptWindowObjectCleared()), this, SLOT(populateJavaScriptWindowObject()));
	setFixedSize(360, 100);
	getHtml("./html/processDlg.html");
	status=0;
}


synchronizeDlg::~synchronizeDlg()
{
	QResource::unregisterResource("options.rcc");
	DELETE_OBJECT(webView);
//	statusMap.clear();
}
void synchronizeDlg::getHtml(const QString & path)
{
	QFile htmlFile(path);
	if (!htmlFile.open(QIODevice::ReadOnly | QIODevice::Text))
		return;
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
	emit stopSyncNotify();
	QDialog::reject();
}
void synchronizeDlg::retry()
{
	emit reSyncNotify();
}
void synchronizeDlg::populateJavaScriptWindowObject()
{
	webView->page()->mainFrame()->addToJavaScriptWindowObject("processDlg", this);
}
void synchronizeDlg::updateStatus(int type,int s)
{
	QString jsStr;
	status=s;
	statusTime = NOW_SECONDS;
	char *statusStr = tz::getstatusstring(s);
//	qDebug()<<"statuscode:"<<s<<" "<<statusStr;
	switch(type)
	{
	case UPDATESTATUS_FLAG_APPLY:
		jsStr.append(QString("$$('loading').style.display='block';"));
		jsStr.append(QString("$$('arrow').style.display='none';"));
		jsStr.append(QString("$$('ps').innerHTML ='%1';").arg(tz::tr(statusStr)));
		jsStr.append(QString("$$('btn').innerHTML ='<a href=\"#\"  onclick=\"accept();\" >%1</a>';").arg(tz::tr(LANGUAGE_APPLY)));
		break;
	case UPDATESTATUS_FLAG_RETRY:
		jsStr.append(QString("$$('loading').style.display='block';"));
		jsStr.append(QString("$$('arrow').style.display='none';"));
		jsStr.append(QString("$$('ps').innerHTML ='%1';").arg(tz::tr(statusStr)));
		jsStr.append(QString("$$('btn').innerHTML ='<a href=\"#\"  onclick=\"retry();\" >%1</a>';").arg(tz::tr(LANGUAGE_RETRY)));
		break;
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

void OptionsDlg::bmDirApply(const int& action,const QString& name,const QString& url,const int& type,const int& groupid)
{
	qDebug()<<__FUNCTION__<<" "<<name<<" "<<url<<" "<<type<<" "<<groupid;
#ifdef CONFIG_ACTION_LIST
	struct ACTION_LIST item;
	item.fullpath = url;
	item.name = name;
#else
	unsigned int showgroupId = 0;
#endif
	switch (action)
	{
	case 0:		//add
		{
#ifdef CONFIG_ACTION_LIST			
			item.action = (type)?(ACTION_LIST_ADD_NETBOOKMARK_DIR):(ACTION_LIST_ADD_NETBOOKMARK_ITEM);
			item.id.groupid = (type)?(tz::getNetBookmarkMaxGroupid(db)):(groupid);
#else
			CatItem item(url,name,"",COME_FROM_MYBOOKMARK);	
			item.parentId = groupid;
			item.type = type;
			if(item.type == 1)//dir
			{
				showgroupId=item.groupId=tz::getNetBookmarkMaxGroupid(db);
			}else
				showgroupId = groupid;
			CatItem::addCatitemToDb(db,item);
#endif
		}
		break;
	case 1:		//modify
		{
#ifdef CONFIG_ACTION_LIST			
			item.action = ACTION_LIST_MODIFY_NETBOOKMARK_DIR;
			item.id.groupid = groupid;
#else
			CatItem item(url,name,"",COME_FROM_MYBOOKMARK);	
			unsigned int bmid = tz::getBmidFromGroupId(db,groupid);
			if(bmid){
				item.parentId = tz::getBmParentId(db,bmid);
				item.type = type;
				showgroupId=item.groupId = groupid;
				CatItem::modifyCatitemFromDb(db,item,bmid);
			}
#endif
		}
		break;
	case 2:		//delete
		{
#ifdef CONFIG_ACTION_LIST			
			item.action = ACTION_LIST_DELETE_NETBOOKMARK_DIR;
			item.id.groupid = groupid;
#else
			unsigned int bmid = tz::getBmidFromGroupId(db,groupid);
			if(bmid){
				showgroupId= tz::getBmParentId(db,bmid);
			}
			tz::deleteNetworkBookmark(db,groupid);
#endif
		}
		break;
	default:
		break;
	}
#ifdef CONFIG_ACTION_LIST
	addToActionList(item);
#else
	loading("bookmark");
	QString js("");
	qDebug()<<showgroupId;
	if(showgroupId==0)
		js.append(QString("$(\"#menu #menuroot\").click();"));
	else
		js.append(QString("$(\"#menu #menu_li_%1\").click();").arg(showgroupId));
	webView->page()->mainFrame()->evaluateJavaScript(js);	
#endif
	
}


void OptionsDlg::bmApply(const int& action,const QString& name,const QString& url,const int& id)
{
	qDebug()<<" "<<name<<" "<<url<<" "<<id<<" "<<action;
#ifdef CONFIG_ACTION_LIST
	struct ACTION_LIST item;
	item.fullpath = url;
	item.name = name;
#else
	CatItem item(url,name,"",COME_FROM_MYBOOKMARK);	
	unsigned int parentid = tz::getBmParentId(db,id);
	QString parentName;
	if(parentid!=0){
		QSqlQuery q("",*db);
		QString  s=QString("SELECT shortName FROM %1 WHERE type=1 AND comeFrom=%2 AND groupid=%3 ").arg(DBTABLEINFO_NAME(COME_FROM_MYBOOKMARK)).arg(COME_FROM_MYBOOKMARK).arg(parentid);
		if(q.exec(s))
		{
			if(q.next()) {
				 parentName = q.value(0).toString();
			}		
		}
		q.clear();
	}else
		parentName="root";
#endif
	
	switch (action)
	{
	case 0:		//add
		break;
	case 1:		//modify
#ifdef CONFIG_ACTION_LIST
		item.action = ACTION_LIST_MODIFY_NETBOOKMARK_ITEM;
		item.id.bmid = id;
#else
		CatItem::modifyCatitemFromDb(db,item,id);
#endif
		break;
	case 2:		//delete
#ifdef CONFIG_ACTION_LIST
		item.action = ACTION_LIST_DELETE_NETBOOKMARK_ITEM;
		item.id.bmid = id;
#else
		CatItem::deleteCatitemFromDb(db,item,id);
#endif
		break;
	default:
		break;
	}
#ifdef CONFIG_ACTION_LIST
		addToActionList(item);
#else
	qDebug()<<__FUNCTION__<<parentid<<parentName;
	getbmfromid(parentid,COME_FROM_MYBOOKMARK,parentName,parentid?0:1);
#endif
}

void OptionsDlg::getbmfromid(const int& groupid,const int& browserid,const QString& name,const int& isroot ){
	QSqlQuery q("",*db);
	QString js("");	
	js.append(QString("$(\"#groupname\").html(\"%1").arg(name));
	js.append("\");");
	qDebug()<<__FUNCTION__<<groupid;	
	js.append(QString("$(\".nelt\").html(\""));
	js.append(QString("<li class='bkad'><a class='thickbox' onclick='addItem(%1);' href='qrc:addbmdir'>add</a></li>").arg(groupid));
	if(!isroot){
		js.append(QString("<li class='bket'><a class='thickbox' id='%1' onclick='postDirItem(\\\"%2\\\",%3);' href='qrc:editbmdir'>mod</a></li>").arg(groupid).arg(name).arg(groupid));
		js.append(QString("<li class='bkde'><a class='thickbox' id='%1' onclick='postDelDirItem(\\\"%2\\\",%3);' href='qrc:deletebmdir'>del</a></li>").arg(groupid).arg(name).arg(groupid));
	}else{
		js.append(QString("<li class='bkad'><a class='thickbox' href='qrc:exportbm'>export</a></li>"));
	}
	js.append("\");");
		
	js.append(QString("$(\"#bklist\").html(\""));
	QString  s=QString("SELECT * FROM %1 WHERE type=0 AND comeFrom=%2 AND parentid=%3 ").arg(DBTABLEINFO_NAME(COME_FROM_MYBOOKMARK)).arg(COME_FROM_MYBOOKMARK).arg(groupid);
	if(q.exec(s))
	{
		int i = 0;
		while(q.next()) {
			js.append("<li>");
			js.append("<h3>");
			js.append(QString("<a class=\\\"url\\\" style=\\\"color: rgb(44, 98, 158);\\\" href=\\\"%1\\\" title=\\\"%2\\\">%3</a>").arg(Q_VALUE_STRING(q,"fullPath")).arg(Q_VALUE_STRING(q,"shortName")).arg(Q_VALUE_STRING(q,"shortName")));
			js.append("</h3>");
			js.append("<p class=\\\"message\\\">");
			js.append(QString("<span class=\\\"id_nodes\\\"><a href=\\\"%1\\\">%2</a> ...</span>").arg(Q_VALUE_STRING(q,"fullPath")).arg(Q_VALUE_STRING(q,"fullPath")));
			js.append("<span class=\\\"ndate\\\">2011-01-24</span>");
			js.append(QString("<a class=\\\"edit thickbox\\\" onclick=\\\"postItem('%1','%2',%3);\\\" href=\\\"qrc:editbm\\\" style=\\\"color: rgb(136, 136, 136);\\\">edit</a>").arg(Q_VALUE_STRING(q,"shortName")).arg(Q_VALUE_STRING(q,"fullPath")).arg(Q_VALUE_UINT(q,"id")));
			js.append(QString("<a class=\\\"delete thickbox\\\" onclick=\\\"postDelItem('%1',%2);\\\" href=\\\"qrc:deletebm\\\" style=\\\"color: rgb(136, 136, 136);\\\">del</a>").arg(Q_VALUE_STRING(q,"shortName")).arg(Q_VALUE_UINT(q,"id")));
			js.append("</p>");
			js.append("</li>");
		}	
	}
	q.clear();
	js.append("\");");
	js.append("tb_init('a.thickbox');");
//	qDebug()<<js;
	webView->page()->mainFrame()->evaluateJavaScript(js);
}
void OptionsDlg::netbookmarkmenu(int browserid,int parentid,QString func,QString& jsresult){
	QSqlQuery q("",*db);
	if(parentid != 0)
		jsresult.append(QString("<ul id=\"menu%1\" style=\"display: none;\">").arg(parentid));
	QString  s=QString("SELECT * FROM %1 WHERE type=1 AND comeFrom=%2 AND parentid=%3 ").arg(DBTABLEINFO_NAME(COME_FROM_MYBOOKMARK)).arg(browserid).arg(parentid);
	if(q.exec(s))
	{
		while(q.next()) {
			//<li><a class=" " value="人才网站" onclick="getbmfromid('8003','1','人才网站',0);" href="javascript:;">人才网站</a></li>
			jsresult.append(QString("<li><a alt=\"%1\" onclick=\"javascript:OptionsDlg.%2(%3,%4,\\'%5\\',%6);\" href=\"javascript:;\" id=\"menu_li_%7\"> %8</a>").arg(Q_VALUE_STRING(q,"shortName"))
			.arg(func).arg(Q_VALUE_UINT(q,"groupid")).arg(browserid).arg(Q_VALUE_STRING(q,"shortName")).arg(0).arg(Q_VALUE_UINT(q,"groupid")).arg(Q_VALUE_STRING(q,"shortName")));
			netbookmarkmenu(browserid,Q_VALUE_UINT(q,"groupid"),func,jsresult);
			jsresult.append(QString("</li>"));
		}

	}
	q.clear();
	if(parentid != 0)
		jsresult.append(QString("</ul>"));
}
#ifdef CONFIG_ACTION_LIST
void OptionsDlg::importNetBookmarkFinished(int status)
{
	QDEBUG_LINE;
	QString js;
	js.append(QString("$('#TB_window .cfgitem').html('<h2>&nbsp;&nbsp;export&raquo;</h2><p><span>%1......</span></p>');" ).arg(status?"success":"failed"));
	//js.append(QString("$('#TB_window .cfgitem').html(\\\"<h2>&nbsp;&nbsp;导入&raquo;</h2><p><span class='tl'>success......</span></p>\\\");" ));
	// js.append(QString("$('#TB_window .cfgitem').html('12345');"));
	 webView->page()->mainFrame()->evaluateJavaScript(js);	
}
#endif
void OptionsDlg::bmExport(const int& browserid)
{	
#ifdef CONFIG_ACTION_LIST
	struct ACTION_LIST item;
	item.action = ACTION_LIST_IMPORT_BOOKMARK;
	item.id.browserid = browserid;
	addToActionList(item);
#else
	struct browserinfo* browserInfo =tz::getbrowserInfo();
	QList <bookmark_catagory> bc;
	int i = 0;
	while(!browserInfo[i].name.isEmpty())
	{
		if(browserid != browserInfo[i].id)
		{
			i++;
			continue;
		}
		switch( browserid )
		{
			case BROWSE_TYPE_NETBOOKMARK:
				break;
			case BROWSE_TYPE_IE:
				if(!tz::readDirectory(tz::getUserFullpath(NULL,LOCAL_FULLPATH_IE), &bc, 0,BROWSE_TYPE_IE,1))
					{
						return;
					}
				break;
			case BROWSE_TYPE_FIREFOX:
				/*
				{
					if(!tz::checkFirefoxDir(ff_path))
						goto ffout;
					qDebug()<<"firefox path:"<<ff_path;
					int firefox_version = tz::getFirefoxVersion();
					if(!firefox_version)
					{	
						QDir ffdir(ff_path);
						if(ffdir.exists("places.sqlite"))
							firefox_version=FIREFOX_VERSION_3;
						else if(ffdir.exists("bookmarks.html"))
							firefox_version=FIREFOX_VERSION_2;
						else 
							goto ffout; 								
					}
					if(firefox_version==FIREFOX_VERSION_3){
						if(!tz::openFirefox3Db(ff_db,ff_path))
							goto ffout; 								
						if(!bmXml::readFirefoxBookmark3(&ff_db,&current_bc[BROWSE_TYPE_FIREFOX]))
							goto ffout; 							
					}
					setBrowserInfoOpFlag(browserid, BROWSERINFO_OP_LOCAL);
		ffout:
				}
			*/
				break;
			case BROWSE_TYPE_OPERA:
				break;
		}
		tz::deleteNetworkBookmark(db,0);
		CatItem::importNetworkBookmark(settings,db,&bc,0);
		return;		
	}
#endif
	return;
}

