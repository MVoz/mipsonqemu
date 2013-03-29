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
OptionsDlg::OptionsDlg(QWidget * parent,QSettings *s,QSqlDatabase *b):QDialog(parent,Qt::MSWindowsFixedSizeDialogHint
| Qt::WindowTitleHint),settings(s),db(b)
{
	#define  OPTION_DLG_WIDTH 800
	manager=NULL;
	reply=NULL;
	updaterDlg=NULL;
	updaterthread=NULL;
	testProxyTimer =NULL;
	proxy = NULL;
	testproxying = 0;
	webView = new QWebView(this);

	webView->setObjectName(QString::fromUtf8("webView"));
	webView->setMinimumSize(QSize(OPTION_DLG_WIDTH, 480));
	webView->setMaximumSize(QSize(OPTION_DLG_WIDTH, 16777215));
	webView->setContextMenuPolicy(Qt::NoContextMenu);
	connect(webView->page()->mainFrame(), SIGNAL(javaScriptWindowObjectCleared()), this, SLOT(populateJavaScriptWindowObject()));
	QResource::registerResource(OPTION_DLG_RCC_FILE);
	setFixedSize(OPTION_DLG_WIDTH, 550);
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
	show_tab = SHOW_TAB_DIR;
	getHtml(":index.html");
	QDesktopWidget* desktop = QApplication::desktop(); // =qApp->desktop();
	move((desktop->width() - width())/2,(desktop->height() - height())/2); 

}
OptionsDlg::~OptionsDlg()
{
	QResource::unregisterResource(OPTION_DLG_RCC_FILE);
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
	DELETE_THREAD(updaterthread);
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

		START_TIMER_SYN(testProxyTimer,TRUE,tz::getParameterMib(SYS_PROXYTESTTIMEOUTT)*SECONDS,proxyTestTimeout);
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
	#define JS_PARSE_FUNCTION "//OptionsDlgOuput."
	#define HTML_PARSE_FUNCTION "<!--OptionsDlgOuput."
	#define JS_PARSE_CALL "//OptionsDlg."
	QFile htmlFile(path);
	QString htmlcontent;
	htmlcontent.clear();
	if (!htmlFile.open(QIODevice::ReadOnly | QIODevice::Text))
		return;
	while (!htmlFile.atEnd()) {
		QString line = htmlFile.readLine();
		QString xline=line.simplified();
		if (xline.startsWith(JS_PARSE_FUNCTION)) {
			TD(DEBUG_LEVEL_NORMAL,"xline:"<<xline);
			 xline.remove(JS_PARSE_FUNCTION);
			 xline.replace(QString(";"), QString(" "));
			 xline.replace(QString("("), QString(" "));
			 xline.replace(QString(")"), QString(" "));
			 xline.replace(QString("'"), QString(" "));
			 xline.replace(QString("\""), QString(" "));
			 xline=xline.simplified();
			 QStringList func_args=xline.split(" ");
			 if(func_args.at(0)=="loading"){
			 	loading(func_args.at(1),&line);
			 }
		}else if (xline.startsWith(HTML_PARSE_FUNCTION)) {
			TD(DEBUG_LEVEL_NORMAL,"xline:"<<xline);
			 xline.remove(HTML_PARSE_FUNCTION);
			 xline.replace(QString("-->"), QString(" "));
			 xline.replace(QString(";"), QString(" "));
			 xline.replace(QString("("), QString(" "));
			 xline.replace(QString(")"), QString(" "));
			 xline.replace(QString("'"), QString(" "));
			 xline.replace(QString("\""), QString(" "));
			 xline=xline.simplified();
			 QStringList func_args=xline.split(" ");	

			 if(func_args.at(0)=="loading"){
			 	loading(func_args.at(1),&line);
			 }
		}else if (xline.startsWith(JS_PARSE_CALL)) {
//			TD(DEBUG_LEVEL_NORMAL,"xline:"<<xline);
			 line=xline.remove("//");
//			 TD(DEBUG_LEVEL_NORMAL,"line:"<<line);			
		}
		htmlcontent.append(line);
		//TD(DEBUG_LEVEL_NORMAL,htmlcontent);
	}
	//webView->setHtml(trUtf8(htmlcontent.toLocal8Bit()));
	webView->setHtml(htmlcontent);
	htmlFile.close();
}
void OptionsDlg::gohref(const QString & url)
{
	runProgram(url,"");
}
void OptionsDlg::loading(const QString & name,QString* c)
{
	c->clear();
	if (name == "index"){
		JS_APPEND_CHECKED(c,settings,"","ckStartWithSystem",false);
		JS_APPEND_CHECKED(c,settings,"","ckShowTray",true);
		JS_APPEND_CHECKED(c,settings,"","ckShowMainwindow",false);
		JS_APPEND_CHECKED(c,settings,"","ckAutoUpdate",false);
		JS_APPEND_CHECKED(c,settings,"","ckScanDir",false);
		uint curMeta = settings->value("hotkeyModifier", HOTKEY_PART_0).toUInt();
		uint curAction = settings->value("hotkeyAction", HOTKEY_PART_1).toUInt();
		c->append(QString("$('#hotkey_0').val(%1);").arg(curMeta));
		c->append(QString("$('#hotkey_1').val(%2);").arg(curAction));



                   JS_APPEND_CHECKED(c,settings,"adv","ckalwaystop",false);
		JS_APPEND_CHECKED(c,settings,"adv","ckalwayscenter",false);
		JS_APPEND_CHECKED(c,settings,"adv","cktransparent",false);
		JS_APPEND_CHECKED(c,settings,"adv","ckfade",false);
		JS_APPEND_CHECKED(c,settings,"adv","ckFuzzyMatch",false);
		JS_APPEND_CHECKED(c,settings,"adv","ckCaseSensitive",false);
		JS_APPEND_CHECKED(c,settings,"adv","ckRebuilderCatalogTimer",false);
#ifdef CONFIG_SUPPORT_IE
		JS_APPEND_CHECKED(c,settings,"adv","ckSupportIe",true);
#endif
#ifdef CONFIG_SUPPORT_FIREFOX
		JS_APPEND_CHECKED(c,settings,"adv","ckSupportFirefox",false);
#endif
#ifdef CONFIG_SUPPORT_OPERA
		JS_APPEND_CHECKED(c,settings,"adv","ckSupportOpera",false);
#endif
		JS_APPEND_CHECKED(c,settings,"netfinder","baidu",true);
		JS_APPEND_CHECKED(c,settings,"netfinder","google",true);
		c->append(QString("$('#netsearchbrowser').html('%1');").arg(QSETTING_VALUE_STRING_HTML(settings,"netfinder","netsearchbrowser",QSETTING_DEFAULT_STRING)));
	}else if(name == "net"){
		JS_APPEND_VALUE(c,settings,"Account","Username",QSETTING_DEFAULT_STRING);
		JS_APPEND_PASSWD(c,settings,"Account","Userpasswd",QSETTING_DEFAULT_STRING);
		
		JS_APPEND_CHECKED(c,settings,"HttpProxy","proxyEnable",false);
		JS_APPEND_VALUE(c,settings,"HttpProxy","proxyAddress",QSETTING_DEFAULT_STRING);
		JS_APPEND_VALUE(c,settings,"HttpProxy","proxyPort",QSETTING_DEFAULT_STRING);
		JS_APPEND_VALUE(c,settings,"HttpProxy","proxyUsername",QSETTING_DEFAULT_STRING);
		JS_APPEND_PASSWD(c,settings,"HttpProxy","proxyPassword",QSETTING_DEFAULT_STRING);

		QDateTime lastsynctime=QDateTime::fromTime_t(settings->value("lastbmsync", 0).toUInt());
		uint lastsyncstatus=settings->value("lastsyncstatus", SYNC_STATUS_FAILED).toUInt();
		c->append(QString("$('#lastbmsync').html('%1');").arg(lastsynctime.toString(Qt::SystemLocaleShortDate)));
		c->append(QString("$('#lastsyncstatus').html('%1');").arg((lastsyncstatus==SYNC_STATUS_FAILED)?"failed":((lastsyncstatus==SYNC_STATUS_SUCCESSFUL)?"successful":"processing...")));
	
		c->append(QString("$('#version').html('%1');").arg(APP_VERSION));
		
	}else if(name == "showtab"){
		c->append(QString("showtab(%1);").arg(show_tab));
	}else if(name == "version"){
		c->append(QString("<a class=\"version\" href=\"#\" onclick=\"gohref('%1')\">%2</a>;").arg(HTTP_SERVER_URL_VERSION).arg(APP_VERSION));		
	}else if(name == "custom"){
		
	}else if(name == "footer"){
		c->append(QString("$('#footer ul').append(\"<li>&copy; 2012 - <a href='#' onclick=gohref('%1')>%2</a> &nbsp;/&nbsp; <a href='#' onclick=gohref('%3%4')>Help</a></li>\");").arg(HTTP_SERVER_URL).arg(APP_NAME).arg(HTTP_SERVER_URL).arg(HTTP_SERVER_URL_HELP));	
		TD(DEBUG_LEVEL_NORMAL,(*c));
	}else if(name == "dirlist"){
		dirLists.clear();
		int count = settings->beginReadArray("directories");
		for (int i = 0; i < count; ++i)
		{
			settings->setArrayIndex(i);
			Directory tmp;
			tmp.name = QSETTING_VALUE_STRING(settings,"","name",QSETTING_DEFAULT_STRING);
			tmp.types =  QSETTING_VALUE_STRINGLIST(settings,"","types",QSETTING_DEFAULT_STRINGLIST);
			tmp.indexDirs = QSETTING_VALUE_BOOL(settings,"","indexDirs", false);
			tmp.depth =QSETTING_VALUE_UINT(settings,"","depth", 100);
			dirLists.append(tmp);

			QString typesResult;
			for (int j = 0; j < tmp.types.size(); j++)
			{
				typesResult += tmp.types.at(j);
				if (j != (tmp.types.size() - 1))
					typesResult += ";";
			}
			c->append(QString("<tr class=\"%1\">").arg((i%2)?("even"):("odd")));
			c->append(QString("<td><input type=\"radio\" name=\"ckdir\" id=\"dir_%1\"/></td>").arg(i));
			c->append(QString("<td id='d_t_p_%1'>%2</td>").arg(i).arg(QSETTING_VALUE_STRING(settings,"","name",QSETTING_DEFAULT_STRING)));
			c->append(QString("<td id='d_t_s_%1'>%2</td>").arg(i).arg(typesResult));
			c->append(QString("<td id='d_t_i_%1' class='%2' ><div class='%3'>&nbsp;</div></td>").arg(i).arg(QSETTING_VALUE_BOOL(settings,"","indexDirs", false)?"checked":"").arg((QSETTING_VALUE_BOOL(settings,"","indexDirs", false)?"ind":"exd")));
			c->append(QString("<td id='d_t_d_%1'>%2</td>").arg(i).arg(QSETTING_VALUE_UINT(settings,"","depth", 100)));			
			c->append(QString("</tr>"));

		}
		settings->endArray();
	}else if(name == "cmdlist"){	
		QSqlQuery q("",*db);
		QString  s=QString("SELECT * FROM %1 ").arg(DBTABLEINFO_NAME(COME_FROM_COMMAND));
		int i = 0;
		if(q.exec(s))
		{
			while(q.next()) {
				qDebug()<<Q_VALUE_UINT(q,"id")<<Q_VALUE_STRING(q,"shortName")<<":"<<Q_VALUE_STRING(q,"fullPath");

				c->append(QString("<tr class=\"%1\">").arg((i%2)?("even"):("odd")));
				c->append(QString("<td><input type=\"radio\" name=\"ckcmd\" id=\"cmd_%1\"/></td>").arg(Q_VALUE_UINT(q,"id")));
				c->append(QString("<td id='c_t_n_%1'>%2</td>").arg(Q_VALUE_UINT(q,"id")).arg(Q_VALUE_STRING(q,"shortName")));
				c->append(QString("<td id='c_t_p_%1'>%2</td>").arg(Q_VALUE_UINT(q,"id")).arg(Q_VALUE_STRING(q,"fullPath")));
				c->append(QString("<td id='c_t_a_%1'>%2</td>").arg(Q_VALUE_UINT(q,"id")).arg(Q_VALUE_STRING(q,"args")));	
				c->append(QString("</tr>"));
				i++;
			}
		}
		q.clear();
	}
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
	else if(name.startsWith("netfinder"))
		emit configModifyNotify(NET_SEARCH_MODIFY);	
	else if(name.startsWith("Account"))
		emit configModifyNotify(NET_ACCOUNT_MODIFY);	
	else if(name=="adv/ckSupportIe"||name=="adv/ckSupportFirefox"||name=="adv/ckSupportOpera"||name=="netbookmarkbrowser"){
		setBrowserEnable(settings);
	}
		
}




void OptionsDlg::cmdApply(const int &type, const QString & cmdName, const QString & cmdCommand, const QString & cmdParameter, const int & cmdIndex)
{
	show_tab = SHOW_TAB_CMD;
	TD(DEBUG_LEVEL_NORMAL,type<<cmdIndex);
	CatItem item(cmdCommand,cmdName,cmdParameter,COME_FROM_COMMAND);
	
	switch (type)
	{
	case 0:		//add
		if(cmdCommand.isEmpty()) return;
		CatItem::addCatitemToDb(db,item);
		break;
	case 1:		//modify
		if(cmdCommand.isEmpty()) return;
		CatItem::modifyCatitemFromDb(db,item,cmdIndex);
		break;
	case 2:		//delete
		CatItem::deleteCatitemFromDb(db,item,cmdIndex);
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
	show_tab = SHOW_TAB_DIR;
	TD(DEBUG_LEVEL_NORMAL,type<<listPath<<listSuffix<<isIncludeChildDir<<childDeep<<index);
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

	QString js ;
	//js.append(QString("alert($('%1').html());").arg("#TB_iframeContent"));
	js.append(QString("$('%1').html('%2');").arg(id).arg(dir.replace("/", "\\\\")));
	//js.append(QString("alert($('%1').html());").arg(id));
	TD(DEBUG_LEVEL_NORMAL,js);
	webView->page()->mainFrame()->evaluateJavaScript(js);
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
		updaterDlg->mode = SYNC_MODE_UPGRADE;
	}
	qDebug("updaterthread=0x%08x,isFinished=%d",updaterthread,(updaterthread)?updaterthread->isFinished():0);
	if(!updaterthread||updaterthread->isFinished()){
		appUpdater* updaterthread=new appUpdater(updaterDlg,settings);
		updaterthread->dlgmode = UPDATE_DLG_MODE;
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
		uint lastsyncstatus=settings->value("lastsyncstatus", SYNC_STATUS_FAILED).toUInt();
		jsStr.append(QString("$('lastbmsync').innerHTML ='%1';").arg(lastsynctime.toString(Qt::SystemLocaleShortDate)));
		switch(lastsyncstatus){
			case SYNC_STATUS_FAILED:
				jsStr.append(QString("$obj('lastsyncstatus').innerHTML ='failed';"));	
				jsStr.append(QString("$obj('lastsyncstatus').className ='ip fail';"));	
				break;
			case SYNC_STATUS_SUCCESSFUL:
				jsStr.append(QString("$obj('lastsyncstatus').innerHTML ='successful';"));	
				jsStr.append(QString("$obj('lastsyncstatus').className ='ip success';"));	
				break;
			case SYNC_STATUS_PROCESSING:
				jsStr.append(QString("$obj('lastsyncstatus').className ='ip';"));	
				jsStr.append(QString("$obj('lastsyncstatus').innerHTML ='processing...';"));	
				break;
		}		
		
		webView->page()->mainFrame()->evaluateJavaScript(jsStr);
}
/*
synchronizeDlg parts
*/

synchronizeDlg::synchronizeDlg(QWidget * parent):QDialog(parent,Qt::MSWindowsFixedSizeDialogHint|Qt::WindowTitleHint)
{
	QResource::registerResource(OPTION_DLG_RCC_FILE);
	setResult(2);
	webView = new QWebView(this);
	webView->setObjectName(QString::fromUtf8("webView"));
	webView->setContextMenuPolicy(Qt::NoContextMenu);
	connect(webView->page()->mainFrame(), SIGNAL(javaScriptWindowObjectCleared()), this, SLOT(populateJavaScriptWindowObject()));
	setFixedSize(620, 160);
	getHtml(":processDlg.html");
	status=0;
}


synchronizeDlg::~synchronizeDlg()
{
	QResource::unregisterResource(OPTION_DLG_RCC_FILE);
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
	switch(mode){
		case SYNC_MODE_BOOKMARK:
		case SYNC_MODE_REBOOKMARK:
			emit stopSyncNotify();
		break;
		case SYNC_MODE_TESTACCOUNT:
		break;
		case SYNC_MODE_UPGRADE:
		break;
	}
	
	//QDialog::reject();
	hide();
}
void synchronizeDlg::retry()
{
	emit reSyncNotify();
}
void synchronizeDlg::populateJavaScriptWindowObject()
{
	webView->page()->mainFrame()->addToJavaScriptWindowObject("processDlg", this);
}
void synchronizeDlg::updateStatus(int status)
{
#if 1
	QString jsStr;
	statusTime = NOW_SECONDS;	
	TD(DEBUG_LEVEL_NORMAL,tz::getstatusstring(status));
	int icon =0;
	int type = 0;
	if(status>SUCCESS_MIN&&status<SUCCESS_MAX){
		icon = UPDATE_STATUS_ICON_SUCCESSFUL;
		type = UPDATESTATUS_FLAG_APPLY;
	}else if(status>REFUSE_MIN&&status<REFUSE_MAX){
		icon = UPDATE_STATUS_ICON_REFUSED;
		type = UPDATESTATUS_FLAG_APPLY;
	}else if(status>FAIL_MIN&&status<FAIL_MAX){
		icon = UPDATE_STATUS_ICON_FAILED;
		type = UPDATESTATUS_FLAG_RETRY;
	} else if(status>LOADING_MIN&&status<LOADING_MAX){		
		icon = UPDATE_STATUS_ICON_LOADING;
		type = UPDATESTATUS_FLAG_APPLY;
	}
		
	switch(icon){
		case UPDATE_STATUS_ICON_SUCCESSFUL:
			jsStr.append(QString("$$('loading').innerHTML='<img src=\"qrc:images/%1\">';").arg("success.png"));
			break;
		case UPDATE_STATUS_ICON_FAILED:
			jsStr.append(QString("$$('loading').innerHTML='<img src=\"qrc:images/%1\">';").arg("fail.png"));
			break;
		case UPDATE_STATUS_ICON_REFUSED:
			jsStr.append(QString("$$('loading').innerHTML='<img src=\"qrc:images/%1\">';").arg("refused.png"));
			break;
		case UPDATE_STATUS_ICON_LOADING:
			jsStr.append(QString("$$('loading').innerHTML='<img src=\"qrc:images/%1\">';").arg("loading.gif"));
			break;
	}
	switch(type)
	{
	case UPDATESTATUS_FLAG_APPLY:
		jsStr.append(QString("$$('info').innerHTML ='%1';").arg(tz::tr(tz::getstatusstring(status))));
		jsStr.append(QString("$$('apply').innerHTML ='<a href=\"#\"  onclick=\"accept();\" >%1</a>';").arg(tz::tr(LANGUAGE_APPLY)));
		break;
	case UPDATESTATUS_FLAG_RETRY:
		jsStr.append(QString("$$('info').innerHTML ='%1';").arg(tz::tr(tz::getstatusstring(status))));
		jsStr.append(QString("$$('apply').innerHTML ='<a href=\"#\"  onclick=\"retry();\" >%1</a>';").arg(tz::tr(LANGUAGE_RETRY)));
		break;
	}
	webView->page()->mainFrame()->evaluateJavaScript(jsStr);
	update();
#endif
}
void synchronizeDlg::readDateProgress(int done, int total)
{
	QString jsStr;
	jsStr.append(QString("$$('tip_text').innerHTML ='Getting data......';"));
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

#define QSTRING_HTML_JS_FORMAT(x) (x).replace("\"","\\\\\"")

void OptionsDlg::getbmfromid(const int& groupid,const int& browserid,const QString& name,const int& isroot ){
	QSqlQuery q("",*db);
	QString js("");	
	js.append(QString("$(\"#groupname\").html(\"%1&raquo;").arg(name));
	js.append("\");");
	qDebug()<<__FUNCTION__<<groupid;	
	js.append(QString("$(\".nelt\").html(\""));
	js.append(QString("<li class='bkad'><a class='thickbox'  name='add&raquo;' onclick='addItem(%1);' href='qrc:addbmdir' rel='width=540&height=100'>add</a></li>").arg(groupid));
	//js.append(QString("<li class='bkad'><a class='thickbox'  name='axxdd&raquo;'  href='qrc:addbmdir' rel='width=540&height=100'>add</a></li>"));
	if(!isroot){
		js.append(QString("<li class='bket'><a class='thickbox' id='%1'  name='modify&raquo;' onclick='postDirItem(\\\"%2\\\",%3);' href='qrc:editbmdir' rel='width=540&height=100'>mod</a></li>").arg(groupid).arg(name).arg(groupid));
		js.append(QString("<li class='bkde'><a class='thickbox' id='%1' name='delete&raquo;' onclick='postDelDirItem(\\\"%2\\\",%3);' href='qrc:deletebmdir' rel='width=540&height=80'>del</a></li>").arg(groupid).arg(name).arg(groupid));
	}else{
		js.append(QString("<li class='bket'><a class='thickbox' name='export&raquo;' href='qrc:exportbm' rel='width=540&height=80'>export</a></li>"));
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
			js.append(QString("<a class=\\\"url\\\"  href=\\\"%1\\\" title=\\\"%2\\\">%3</a>").arg(Q_VALUE_STRING(q,"fullPath")).arg(Q_VALUE_STRING(q,"shortName")).arg(Q_VALUE_STRING(q,"shortName")));
			//js.append(QSTRING_HTML_JS_FORMAT(QString("<a class=\"url\" style=\"color: rgb(44, 98, 158);\" href=\"%1\" title=\"%2\">%3</a>").arg(Q_VALUE_STRING(q,"fullPath")).arg(Q_VALUE_STRING(q,"shortName")).arg(Q_VALUE_STRING(q,"shortName"))));
			
			js.append("<span class=\\\"ndate\\\">(2011-01-24)</span>");
			js.append("</h3>");
			js.append("<div class=\\\"message\\\">");
			js.append(QString("<span><a href=\\\"%1\\\">%2</a></span>").arg(Q_VALUE_STRING(q,"fullPath")).arg(Q_VALUE_STRING(q,"fullPath")));
			js.append(QString("<a class=\\\"del thickbox\\\" name=\\\"delete&raquo;\\\" onclick=\\\"postDelItem('%1',%2);\\\" href=\\\"qrc:deletebm\\\"  rel=\\\"width=540&height=100\\\"></a>").arg(Q_VALUE_STRING(q,"shortName")).arg(Q_VALUE_UINT(q,"id")));
			js.append(QString("<a class=\\\"edit thickbox\\\"  name=\\\"edit&raquo;\\\" onclick=\\\"postItem('%1','%2',%3);\\\" href=\\\"qrc:editbm\\\" rel=\\\"width=540&height=100\\\"></a>").arg(Q_VALUE_STRING(q,"shortName")).arg(Q_VALUE_STRING(q,"fullPath")).arg(Q_VALUE_UINT(q,"id")));
			js.append("</div>");
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
				if(!tz::readDirectory(tz::getUserFullpath(NULL,LOCAL_FULLPATH_IEFAV), &bc, 0,BROWSE_TYPE_IE,1))
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

