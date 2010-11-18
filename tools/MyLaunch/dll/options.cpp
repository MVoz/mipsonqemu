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

OptionsDlg::OptionsDlg(QWidget * parent,QSettings *s,QSqlDatabase *b):QDialog(parent),settings(s),db(b)
{
	//catalogBuilder=*(shared_ptr <CatBuilder>*)(catalogBuilder);
	manager=NULL;
	reply=NULL;
	updaterDlg=NULL;
	updaterthread=NULL;
	testProxyTimer =NULL;
	webView = new QWebView(this);

	webView->setObjectName(QString::fromUtf8("webView"));
	webView->setMinimumSize(QSize(805, 500));
	webView->setMaximumSize(QSize(805, 16777215));
	webView->setContextMenuPolicy(Qt::NoContextMenu);
	connect(webView->page()->mainFrame(), SIGNAL(javaScriptWindowObjectCleared()), this, SLOT(populateJavaScriptWindowObject()));
	qDebug("register resource options.rcc");
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
	qDebug(" ~OptionsDlg unregister resource options.rcc");
	QResource::unregisterResource("options.rcc");
	//cmdLists.clear();
	dirLists.clear();
	metaKeys.clear();
	iActionKeys.clear();
	actionKeys.clear();
	DELETE_OBJECT(manager);
	DELETE_OBJECT(reply);
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

void OptionsDlg::proxyTestslotError(QNetworkReply::NetworkError err)
{
	qDebug("%s error=%d\n",__FUNCTION__,err);
	DELETE_OBJECT(testProxyTimer);
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
	qDebug("%s error=%d\n",__FUNCTION__,testreply->error());
	DELETE_OBJECT(testProxyTimer);
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
	//reply->close();
	//disconnect(manager, 0, 0, 0);	

	//delete manager;
	//manager=NULL;
//	tz::runParameter(SET_MODE,RUN_PARAMETER_NETPROXY_USING,0);
	SET_RUN_PARAMETER(RUN_PARAMETER_NETPROXY_USING,0);
}
void OptionsDlg::proxtTestTimerSlot()
{
	STOP_TIMER(testProxyTimer);
	reply->abort();
}
void OptionsDlg::proxyTestClick(/*const QString& proxyAddr,const QString& proxyPort,const QString& proxyUsername,const QString& proxyPassword*/)
{

//	tz::netProxy(SET_MODE,settings,NULL);

	if(!manager)
	{
		request.setUrl(QUrl(QString("http://www.sohu.com")));
		request.setRawHeader("User-Agent", "MyOwnBrowser 1.0");
		manager = new QNetworkAccessManager(this);
		SET_NET_PROXY(manager,settings);
		manager->setObjectName(tr("manager"));

		reply = manager->get(request);

		testProxyTimer=new QTimer(this);
		testProxyTimer->start(10);
		testProxyTimer->setSingleShot(TRUE);

		connect(testProxyTimer, SIGNAL(timeout()), this, SLOT(proxtTestTimerSlot()), Qt::DirectConnection);
		// connect(reply, SIGNAL(readyRead()), this, SLOT(slotReadyRead()));
		// connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(proxyTestslotError(QNetworkReply::NetworkError)));
		connect(manager, SIGNAL(finished ( QNetworkReply * )), this, SLOT(proxyTestslotFinished(QNetworkReply *)));

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
	struct menuhtml{
		QString name;
		QList<QString> child;
	}menuHtml[4];

	menuHtml[0].name = "common";
	menuHtml[0].child<<"list_mg"<<"cmd_mg";
	menuHtml[1].name = "adv";
	menuHtml[1].child<<"net_mg";
	menuHtml[2].name = "interface";
	//menuHtml[2].child<<"skin_mg"<<"language_mg";
	menuHtml[3].name = "about";
    
	
	//menu parts
	
	QString menustring;
	menustring.append("<ul id=\"menu\">");
	for(int j = 0; j < 4 ; j++){
		menustring.append("<li>");
		menustring.append("<a href=\"#\" onclick=\"getHtml('./html/"+menuHtml[j].name+".html');\" style=\""+((name==menuHtml[j].name)?"font-weight:bold;":"")+"\">"+tz::tr(TOCHAR(menuHtml[j].name))+"</a>");
		if(menuHtml[j].child.count()){
			menustring.append("<ul>");
			foreach(QString childname,menuHtml[j].child){
				menustring.append("<li>");
				menustring.append("<a href=\"#\" onclick=\"getHtml('./html/"+childname+".html');\" style=\""+((name==childname)?"font-weight:bold;":"")+"\">"+tz::tr(TOCHAR(childname))+"</a>");
				menustring.append("</li>");
			}
			menustring.append("</ul>");
		}
		menustring.append("</li>");
	}
	menustring.append("</ul>");	
	menustring.replace("\"","\\\"");
	jsStr.append("$('lm').innerHTML=\""+menustring+"\";");

	//button parts
	QString buttonstring;
	buttonstring.append("<table width=\"100%\"><tr>");
	buttonstring.append("<td width=\"30%\"><span style=\"padding-left:-280px;\"><a  href=\""HTTP_SERVER_URL"\">"+tz::tr(APP_NAME)+"</a>,"+tz::tr(APP_SLOGAN)+"!</span></td>");
	buttonstring.append("<td width=\"30%\" align=right>");
	buttonstring.append("<div class=\"btn\">");
	buttonstring.append("<a href=\"#\"  onclick=\"apply('"+name+"');\" >"+tz::tr("apply")+"</a>");
	buttonstring.append("</div></td>");				
	buttonstring.append("<td width=\"30%\" align=right>");	
	buttonstring.append("<div class=\"btn\">");	
	buttonstring.append("<a href=\"#\"  onclick=\"reject();\" >"+tz::tr("cancel")+"</a>");	
	buttonstring.append("</div></td></tr></table>");
	
	buttonstring.replace("\"","\\\"");
	jsStr.append("$('applybtn').innerHTML=\""+buttonstring+"\";");

	if (name == "common")
	{
		JS_APPEND_CHECKED("ckStartWithSystem","",false);
		JS_APPEND_CHECKED("ckShowTray","",false);
		JS_APPEND_CHECKED("ckShowMainwindow","",false);
		JS_APPEND_CHECKED("ckAutoUpdate","",false);
		JS_APPEND_CHECKED("ckScanDir","",false);
		JS_APPEND_VALUE("Username","Account","");
		JS_APPEND_PASSWD("Userpasswd","Account","");
		//lastsynctime
		QDateTime lastsynctime=QDateTime::fromTime_t(settings->value("lastsynctime", 0).toUInt()); 
		jsStr.append(QString("$('lastsynctime').innerHTML ='%1';").arg(lastsynctime.toString(Qt::SystemLocaleShortDate)));
#ifdef Q_WS_WIN
		int curMeta = settings->value("hotkeyModifier", Qt::AltModifier).toInt();
#endif
#ifdef Q_WS_X11
		int curMeta = settings->value("hotkeyModifier", Qt::ControlModifier).toInt();
#endif
		int curAction = settings->value("hotkeyAction", Qt::Key_Space).toInt();
		jsStr.append(QString("set_selected('%1','hotkey_0');").arg(curMeta));
		jsStr.append(QString("set_selected('%1','hotkey_1');").arg(curAction));


	} else if (name == "net_mg")
	{

		JS_APPEND_CHECKED("proxyEnable","HttpProxy",false);
		JS_APPEND_VALUE("proxyAddress","HttpProxy","");
		JS_APPEND_VALUE("proxyPort","HttpProxy","");
		JS_APPEND_VALUE("proxyUsername","HttpProxy","");
		JS_APPEND_PASSWD("proxyPassword","HttpProxy","");
		jsStr.append(QString("proxyEnableClick();"));

	} else if (name == "cmd_mg")
	{
		jsStr.append(QString("$('cmd_table').innerHTML='<table width=\"100%\" align=\"center\" cellspacing=\"1\" >\
							 <tr bgcolor=\"#ffffff\" align=\"center\">\
							 <td width=\"5%\">"+tz::tr("html_select")+"</td>\
							 <td width=\"15%\">"+tz::tr("html_name")+"</td>\
							 <td width=\"60%\">"+tz::tr("html_command")+"</td>\
							 <td width=\"20%\">"+tz::tr("html_argument")+"</td>\
							 </tr>"));
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
			while(q.next()) {
				qDebug()<<q.value(shortName_Idx).toString()<<":"<<q.value(fullPath_Idx).toString();
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
			}

		}
		q.clear();
		jsStr.append(QString("</table>';"));

	} else if (name == "list_mg")
	{
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

	}else if(name == "adv"){
		JS_APPEND_CHECKED("ckFuzzyMatch","adv",false);
		JS_APPEND_CHECKED("ckCaseSensitive","adv",false);
		JS_APPEND_CHECKED("ckRebuilderCatalogTimer","adv",false);
		JS_APPEND_CHECKED("ckSupportIe","adv",false);
		JS_APPEND_CHECKED("ckSupportFirefox","adv",false);
		JS_APPEND_CHECKED("ckSupportOpera","adv",false);
		JS_APPEND_CHECKED("baidu","netfinder",true);
		JS_APPEND_CHECKED("google","netfinder",true);
	}else if(name=="about"){
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
	if(name=="hotkeyAction"){
		emit configModifyNotify(HOTKEY);			
	}
	if(name == "ckShowTray")
		emit configModifyNotify(SHOWTRAY);	
	if(name=="adv/ckSupportIe"||name=="adv/ckSupportFirefox"||name=="adv/ckSupportOpera"){
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
	settings->beginWriteArray("directories");
	for (int i = 0; i < dirLists.size(); ++i)
	{
		settings->setArrayIndex(i);
		qDebug("directory path:%s",qPrintable(dirLists.at(i).name));
		settings->setValue("name", qPrintable(dirLists.at(i).name));
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

		updaterThread* updaterthread=new updaterThread(updaterDlg,settings,UPDATE_DLG_MODE);	
		connect(updaterDlg,SIGNAL(updateSuccessNotify()),this->parent(),SLOT(updateSuccess()));
		connect(updaterDlg,SIGNAL(reSyncNotify()),this,SLOT(startUpdater()));
		updaterthread->start(QThread::IdlePriority);		
	}

	updaterDlg->setModal(1);
	updaterDlg->show();	
}