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

	getHtml("./html/common.html");
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
	menustring.append("<ul>");
	QStringList menulsit;
	menulsit<<"Common"<<"Custom"<<"Command"<<"Advance"<<"Network"<<"About";
	foreach (QString m, menulsit) {
		menustring.append("<li>");
    		menustring.append("<a href=\"#\" onclick=\"getHtml('./html/"+m+".html');\""+((m==name)?"class=\"current\"":"")+">"+tz::tr(TOCHAR(m))+"</a>");
		menustring.append("</li>");
        }
	menustring.append("</ul>");
	menustring.replace("\"","\\\"");
	jsStr.append("$('menu').innerHTML=\""+menustring+"\";");
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
	jsStr.append("$('footer').innerHTML=\""+footerstring+"\";");

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
		QDateTime lastsynctime=QDateTime::fromTime_t(settings->value("lastsynctime", 0).toUInt());
		uint lastsyncstatus=settings->value("lastsyncstatus", SYNC_STATUS_FAIL).toUInt();
		jsStr.append(QString("$('lastsynctime').innerHTML ='%1';").arg(lastsynctime.toString(Qt::SystemLocaleShortDate)));
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
		
		int curMeta = settings->value("hotkeyModifier", HOTKEY_PART_0).toInt();
		int curAction = settings->value("hotkeyAction", HOTKEY_PART_1).toInt();
		jsStr.append(QString("set_selected('%1','hotkey_0');").arg(curMeta));
		jsStr.append(QString("set_selected('%1','hotkey_1');").arg(curAction));


	} else if (name == "Network")
	{
		JS_APPEND_CHECKED("proxyEnable","HttpProxy",false);
		JS_APPEND_VALUE("proxyAddress","HttpProxy","");
		JS_APPEND_VALUE("proxyPort","HttpProxy","");
		JS_APPEND_VALUE("proxyUsername","HttpProxy","");
		JS_APPEND_PASSWD("proxyPassword","HttpProxy","");
		jsStr.append(QString("$('version').innerHTML ='%1';").arg(APP_VERSION));
		jsStr.append(QString("proxyEnableClick();"));

	} else if (name == "Command")
	{
		/*jsStr.append(QString("$('cmd_table').innerHTML='<table width=\"100%\" align=\"center\" cellspacing=\"1\" >\
							 <tr bgcolor=\"#ffffff\" align=\"center\">\
							 <td width=\"5%\">"+tz::tr("html_select")+"</td>\
							 <td width=\"15%\">"+tz::tr("html_name")+"</td>\
							 <td width=\"60%\">"+tz::tr("html_command")+"</td>\
							 <td width=\"20%\">"+tz::tr("html_argument")+"</td>\
							 </tr>"));
		*/
		jsStr.append("$('cmdlist').innerHTML='");
		//cmdLists.clear();
		QSqlQuery q("",*db);
		QString  s=QString("SELECT * FROM %1 ").arg(DBTABLEINFO_NAME(COME_FROM_COMMAND));
		if(q.exec(s))
		{
			QSqlRecord rec = q.record();
			int id_Idx=rec.indexOf("id");
			int fullPath_Idx = rec.indexOf("fullPath"); // index of the field "name"
			int shortName_Idx = rec.indexOf("shortName"); // index of the field "name"
			int args_Idx = rec.indexOf("args"); // index of the field "name" 
			int i = 0;
			while(q.next()) {
				qDebug()<<q.value(shortName_Idx).toString()<<":"<<q.value(fullPath_Idx).toString();
				jsStr.append(QString("<tr class=\"%1\">").arg((i%2)?("even"):("odd")));
				jsStr.append("<td><input type=\"radio\" name=\"select\" ");
				jsStr.append(QString("onclick=\"postItem(\\'%1\\',\\'%2\\',\\'%3\\',\\'%4\\');\">").arg(q.value(shortName_Idx).toString().replace("\\", "\\\\\\\\")).arg(q.value(fullPath_Idx).toString().replace("\\", "\\\\\\\\")).arg(q.value(args_Idx).toString()).arg(q.value(id_Idx).toUInt()));
				jsStr.append("</td>");
				jsStr.append("<td >"+q.value(shortName_Idx).toString().replace("\\", "\\\\")+"</td>");
				jsStr.append("<td >"+q.value(fullPath_Idx).toString().replace("\\", "\\\\")+"</td>");
				jsStr.append("<td >"+q.value(args_Idx).toString()+"</td>");
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
		jsStr.append(QString("</table>';"));

	} else if (name == "Custom")
	{
#ifdef CONFIG_OPTION_NEWUI
		dirLists.clear();
		int count = settings->beginReadArray("directories");
		jsStr.append("$('dirlist').innerHTML='");
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

		}
		jsStr.append("';");
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

		
	}else if(name=="About"){
		jsStr.append(QString("$('version').innerHTML='%1';").arg(APP_VERSION));
		jsStr.append(QString("$('buildtime').innerHTML='%1';").arg(QDateTime::fromTime_t(APP_BUILD_TIME).toString(Qt::SystemLocaleShortDate)));
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
	else if(name=="adv/ckSupportIe"||name=="adv/ckSupportFirefox"||name=="adv/ckSupportOpera"){
		setBrowserEnable(settings);
	}
		
}
void OptionsDlg::addCatitemToDb(CatItem& item)
{
	QSqlQuery q("",*db);
	/*
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
	*/
	CatItem::prepareInsertQuery(&q,item);
	q.exec();
	q.clear();

}
void OptionsDlg::modifyCatitemFromDb(CatItem& item,uint index)
{
	QSqlQuery q("",*db);
	q.prepare(
		QString("UPDATE %1 SET fullPath=:fullpath, shortName=:shortName, lowName=:lowName,"
		"icon=:icon,usage=:usage,hashId=:hashId,"
		"isHasPinyin=:isHasPinyin,"
		"comeFrom=:comeFrom,"
		"pinyinReg=:pinyinReg,allchars=:allchars,alias2=:alias2',shortCut=:shortCut,delId=:delId where id=:id"
		).arg(DBTABLEINFO_NAME(item.comeFrom))
		);
	BIND_CATITEM_QUERY(&q,item);
	q.bindValue("id", index);
	/*	
	QString queryStr=QString("update %1 set fullPath='%2', shortName='%3', lowName='%4',"
	"icon='%5',usage=%6,hashId=%7,"
	"groupId=%8, parentId=%9, isHasPinyin=%10,"
	"comeFrom=%11,hanziNums=%12,pinyinDepth=%13,"
	"pinyinReg='%14',alias1='%15',alias2='%16',shortCut='%17',delId=%18 where id=%19)").arg(DB_TABLE_NAME).arg(item.fullPath) .arg(item.shortName).arg(item.lowName)
	.arg(item.icon).arg(item.usage).arg(qHash(item.fullPath))
	.arg(item.groupId).arg(item.parentId).arg(item.isHasPinyin)
	.arg(item.comeFrom).arg(item.hanziNums).arg(item.pinyinDepth)
	.arg(item.pinyinReg).arg(item.alias1).arg(item.alias2).arg(item.shortCut).arg(item.delId).arg(index);
	*/
	q.exec();
	q.clear();
}
void OptionsDlg::deleteCatitemFromDb(CatItem& item,uint index)
{
	QSqlQuery q("",*db);
	q.prepare(QString("DELETE FROM %1 where id=:id").arg(DBTABLEINFO_NAME(item.comeFrom)));
	q.bindValue("id", index);
	q.exec();
	q.clear();
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
		addCatitemToDb(item);
		break;
	case 1:		//modify
		modifyCatitemFromDb(item,cmdIndex.toInt());
		break;
	case 2:		//delete
		//qDebug("type=%d cmdinex=%d cmdLists.size=%d",type,cmdIndex.toInt(),cmdLists.size());
		//  cmdLists.removeAt(cmdIndex.toInt());
		deleteCatitemFromDb(item,cmdIndex.toInt());
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
	//QMessageBox msgBox;
	//QString str = QString("%1 ").arg(dir.replace("/", "\\\\"));
	//msgBox.setText(str);
	//msgBox.exec();

	QString status = QString("$('%1').value= '%2';").arg(id).arg(dir.replace("/", "\\\\"));
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
		QDateTime lastsynctime=QDateTime::fromTime_t(settings->value("lastsynctime", 0).toUInt());
		uint lastsyncstatus=settings->value("lastsyncstatus", SYNC_STATUS_FAIL).toUInt();
		jsStr.append(QString("$('lastsynctime').innerHTML ='%1';").arg(lastsynctime.toString(Qt::SystemLocaleShortDate)));
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
