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
#include <QApplication>
#include <QFont>
#include <QPushButton>
#include <QWidget>
#include <QPalette>
#include <QLineEdit>
#include <QPixmap>
#include <QBitmap>
#include <QLabel>
#include <QFile>
#include <QIcon>
#include <QSettings>
#include <QMouseEvent>
#include <QMessageBox>
#include <QDir>
#include <QMenu>
#include <QSettings>
#include <QTimer>
#include <QDateTime>
#include <QDesktopWidget>
#include <QTranslator>


#include <icon_delegate.h>
#include "main.h"
#include <globals.h>
#include <optionUI.h>

#include "plugin_interface.h"

extern shared_ptr<CatBuilder> gBuilder;
extern CatItem* gSearchResult;
extern shared_ptr <bmSync> gSyncer;
#ifdef CONFIG_DIGG_XML
extern shared_ptr<diggXml> gDiggXmler;
#endif

struct {
	QString name;
	QString fullpath;
	QString args;
}netfinders[]={
	{QString("google"),"http://www.google.com/","search?q="},
	{QString("baidu"),"http://www.baidu.com/","s?ie=utf-8&wd="},	
	{0,"",""}
};

void MyWidget::configModify(int type){
	switch(type){
		case HOTKEY:
		{
			qDebug()<<"set new hotkey";
			int curMeta = gSettings->value("hotkeyModifier", HOTKEY_PART_0).toInt();
			int curAction = gSettings->value("hotkeyAction",HOTKEY_PART_1).toInt();
			if (!setHotkey(curMeta, curAction))
			{
				QMessageBox::warning(this, tr(APP_NAME), tr("The hotkey you have chosen is already in use. Please select another from "APP_NAME"'s preferences."));
			}
		}
		break;
		case SHOWTRAY:
		qDebug()<<"systray...";
		if(gSettings->value("ckShowTray", true).toBool())
		{
			trayIcon->show();
		}else
			trayIcon->hide();
		break;
		case NETPROXY:
			qDebug()<<"NETPROXY...";
			//tz::netProxy(int mode,QSettings * s,QNetworkProxy * * r)
		break;
		case DIRLIST:
			qDebug()<<"scan directory.......................";
			buildCatalog();
		break;
		default:
		break;
	}
	storeConfig();
}

void MyWidget::restoreUserCommand()
{
	QString storesuffix =QString("%1").arg(qHash(QDir::homePath()));
	QString name = qApp->applicationDirPath()+"/"+APP_DATA_PATH+"/"+CONFIG_USER_CONFIG_DIR+"/"+"config."+storesuffix;

	if(!QFile::exists(name))
				return;
	QSettings*	src = new QSettings(name, QSettings::IniFormat, this);		
	db.transaction();
	QSqlQuery	q("", db);;
	int count = src->beginReadArray("commands");
	for(int i=0; i< count ; i++){
					src->setArrayIndex(i);
					QString shortname = src->value("shortName","").toString();
					QString fullpath = src->value("fullPath","").toString();
					QString args = src->value("args", "").toString();
					if(!shortname.isEmpty()&&!fullpath.isEmpty())
					{
						CatItem item(fullpath,shortname,args,COME_FROM_COMMAND);
						CatItem::prepareInsertQuery(&q,item);
						q.exec();
					}
	}
	db.commit();
	q.clear();

	src->endArray();
	delete src;
}
//0--store 1---restore
void MyWidget::storeConfig(int mode)
{
	
	QString storesuffix =QString("%1").arg(qHash(QDir::homePath()));
	if(!QFile::exists(qApp->applicationDirPath()+"/"+APP_DATA_PATH+"/"+CONFIG_USER_CONFIG_DIR))
	{
		QDir d(qApp->applicationDirPath()+"/"+APP_DATA_PATH);
		d.mkdir(CONFIG_USER_CONFIG_DIR);
	}
	QString name = qApp->applicationDirPath()+"/"+APP_DATA_PATH+"/"+CONFIG_USER_CONFIG_DIR+"/"+"config."+storesuffix;
	QString sname = name+".temp";

	QSettings *backup_s=NULL;

	QSettings* src=NULL,*dst=NULL;
	
	switch(mode){
		case 0://store
			if(QFile::exists(sname))
				QFile::remove(sname);			
			src = gSettings;
			dst = backup_s = new QSettings(sname, QSettings::IniFormat, this);			 
		break;
		case 1://restore
			if(!QFile::exists(name))
				return;
			dst = gSettings;
			src = backup_s = new QSettings(name, QSettings::IniFormat, this);		
		break;
	}
	
	//now backup.......
	dst->setValue("language",src->value("language", DEFAULT_LANGUAGE).toInt());
	dst->setValue("skin", src->value("skin", dirs["defSkin"][0]).toString());
	dst->setValue("ckStartWithSystem",src->value("ckStartWithSystem", true).toBool());
	dst->setValue("ckShowTray",src->value("ckShowTray", true).toBool());
	dst->setValue("hotkeyModifier",src->value("hotkeyModifier", HOTKEY_PART_0).toInt());
	dst->setValue("hotkeyAction",src->value("hotkeyAction", HOTKEY_PART_1).toInt());

	//back directory
	QList<Directory> dirLists;
	int count = src->beginReadArray("directories");
	for (int i = 0; i < count; ++i)
	{
			src->setArrayIndex(i);
			Directory tmp;
			tmp.name = src->value("name").toString();
			tmp.types = src->value("types").toStringList();
			tmp.indexDirs = src->value("indexDirs", false).toBool();
			//tmp.indexExe = settings->value("indexExes", false).toBool();
			tmp.depth = src->value("depth", 100).toInt();
			dirLists.append(tmp);
	}
	src->endArray();
	dst->beginWriteArray("directories");
	for (int i = 0; i < dirLists.size(); ++i)
	{
		dst->setArrayIndex(i);
		dst->setValue("name", dirLists.at(i).name);
		dst->setValue("types", dirLists.at(i).types);
		dst->setValue("indexDirs", dirLists.at(i).indexDirs);
		dst->setValue("depth", dirLists.at(i).depth);
	}
	dst->endArray();
	//back user defined command
	QSqlQuery	q("", db);;
	if(mode == 0)//store
	{
		QString  s=QString("SELECT * FROM %1 ").arg(DBTABLEINFO_NAME(COME_FROM_COMMAND));
		dst->beginWriteArray("commands");
		if(q.exec(s))
		{
				int i = 0;
				while(q.next()) {
					dst->setArrayIndex(i);
					dst->setValue("shortName", q.value(Q_RECORD_INDEX(q,"shortName")).toString());
					dst->setValue("fullPath", q.value(Q_RECORD_INDEX(q,"fullPath")).toString());
					dst->setValue("args", q.value(Q_RECORD_INDEX(q,"args")).toString());
					i++;
				}
				q.clear();
		}

		dst->endArray();
	}else{
		//restoreUserCommand();
	}

	dst->sync();
	if(mode==0)//store
	{
		if(QFile::exists(name))
			QFile::remove(name);
		QFile::copy(sname,name);
		QFile::remove(sname);
	}
	if(backup_s)
		delete backup_s;
}
QString MyWidget::getShortkeyString()
{
		int curMeta = gSettings->value("hotkeyModifier", HOTKEY_PART_0).toInt();
		int curAction = gSettings->value("hotkeyAction", HOTKEY_PART_1).toInt();
		QString keys("");
		switch(curMeta){
			//case Qt::AltModifier:
			//	text.arg("ALT");
			//	break;
			case Qt::ShiftModifier:
				keys.append("Shift");
				break;
			case Qt::ControlModifier:
				keys.append("Ctrl");
				break;
			case Qt::MetaModifier:
				keys.append("Win");
				break;
			default:
				keys.append("Alt");
				break;
		}
		switch(curAction){
			case Qt::Key_Space:
				keys.append("+Space");
				break;
			case Qt::Key_Tab:
				keys.append("+Tab");
				break;
			//case Qt::Enter:
			//	text.arg("Enter");
			//	break;
			default:
				keys.append("+Enter");
				break;				
		}
		return keys;
}

MyWidget::MyWidget(QWidget * parent, PlatformBase * plat, bool rescue):
#ifdef Q_WS_WIN
QWidget(parent, Qt::FramelessWindowHint | Qt::Tool),
#endif
#ifdef Q_WS_X11
//QWidget(parent, Qt::SplashScreen | Qt::FramelessWindowHint | Qt::Tool ),
QWidget(parent, Qt::FramelessWindowHint | Qt::Tool),
#endif
//platform(plat), catalogBuilderTimer(NULL), dropTimer(NULL), alternatives(NULL)
platform(plat),  dropTimer(NULL), alternatives(NULL)
{
	setAttribute(Qt::WA_AlwaysShowToolTips);
	setAttribute(Qt::WA_InputMethodEnabled);
	//      setWindowFlags(windowFlags() | Qt::WindowStaysOnTopHint);
	//    setWindowFlags(windowFlags() & ~Qt::WindowStaysOnTopHint);
	// Load settings
	dirs = platform->GetDirectories();
	if (QFile::exists(dirs["portConfig"][0]))
		gSettings = new QSettings(dirs["portConfig"][0], QSettings::IniFormat, this);
	else
	{
		if(QFile::exists(dirs["config"][0]))
			gSettings = new QSettings(dirs["config"][0], QSettings::IniFormat, this);
		else{
			qDebug()<<"restore config!";
			gSettings = new QSettings(dirs["config"][0], QSettings::IniFormat, this);
			storeConfig(1);
		}
	}
	//inital language
	setLanguage(gSettings->value("language", DEFAULT_LANGUAGE).toInt()) ;
	shortkeyString=getShortkeyString();
	if (platform->isAlreadyRunning())
		{
			QString text=tz::tr("app_is_runing");
			text.replace("shortkey",shortkeyString);		
			QMessageBox::warning(this, tr(APP_NAME),text, QMessageBox::Ok,QMessageBox::Ok);
			exit(1);
		}
	gSemaphore.release(1);
	fader = new Fader(this);
	connect(fader, SIGNAL(fadeLevel(double)), this, SLOT(setFadeLevel(double)));
	connect(fader, SIGNAL(finishedFade(double)), this, SLOT(finishedFade(double)));

	gMainWidget = this;
	menuOpen = false;
	optionsOpen = false;
	gSearchTxt = "";
	//syncDlgTimer=NULL;
	inputMode = 0;
	rebuildAll = 0;
	closeflag = 0;

	setFocusPolicy(Qt::ClickFocus);

	alwaysShowLaunchy = false;
	createActions();
	createTrayIcon();

	//      hideLaunchy();
	label = new QLabel(this);

	opsButton = new QPushButton(label);
	opsButton->setObjectName("opsButton");
	opsButton->setToolTip(tr(APP_NAME" Options"));
	connect(opsButton, SIGNAL(pressed()), this, SLOT(menuOptions()));

	closeButton = new QPushButton(label);
	closeButton->setObjectName("closeButton");
	closeButton->setToolTip(tr("Close "APP_NAME));
	connect(closeButton, SIGNAL(pressed()), qApp, SLOT(quit()));


	output = new QLineEditMenu(label);
	output->setAlignment(Qt::AlignHCenter);
	output->setReadOnly(true);
	output->setObjectName("output");
	connect(output, SIGNAL(menuEvent(QContextMenuEvent *)), this, SLOT(menuEvent(QContextMenuEvent *)));

	input = new QCharLineEdit(label);
	input->setObjectName("input");
	connect(input, SIGNAL(keyPressed(QKeyEvent *)), this, SLOT(inputKeyPressEvent(QKeyEvent *)));
	connect(input, SIGNAL(focusOut(QFocusEvent *)), this, SLOT(focusOutEvent(QFocusEvent *)));
	connect(input, SIGNAL(inputMethod(QInputMethodEvent *)), this, SLOT(inputMethodEvent(QInputMethodEvent *)));
	connect(trayIcon, SIGNAL(activated(QSystemTrayIcon::ActivationReason)), this, SLOT(iconActivated(QSystemTrayIcon::ActivationReason)));

	licon = new QLabel(label);
	ops = NULL;

	tz::getUserIniDir(SET_MODE,dirs["userdir"][0]);
#ifdef CONFIG_LOG_ENABLE
	//      dump_setting(NULL);
#endif

	// If this is the first time running or a new version, call updateVersion
	bool showLaunchyFirstTime = false;
/*
	if (gSettings->value("version", 0).toInt() != LAUNCHY_VERSION)
	{
		updateVersion(gSettings->value("version", 0).toInt());
		showLaunchyFirstTime = true;
	}
*/
	//pre-alloc the search result
	gSearchResult=new CatItem[MAX_SEARCH_RESULT];
	db = QSqlDatabase::addDatabase("QSQLITE", "dbManage");
	QString dest ;
	getUserLocalFullpath(gSettings,QString(DB_DATABASE_NAME),dest);
	bool rebuilddatabase = FALSE;
	if(!QFile::exists(dest)){
		rebuildAll|=(1<<TIMER_ACTION_BMSYNC)|(1<<TIMER_ACTION_CATBUILDER);
		rebuilddatabase = TRUE;
	}
	db.setDatabaseName(dest);		
	if ( !db.open())	 
	{
		qDebug("connect database %s failure!\n",qPrintable(dest)) 	;
		exit(1);
	} 
	else{
		//   qDebug("connect database %s successfully!\n",qPrintable(dest));  
		tz::initDbTables(db,gSettings,rebuilddatabase);
		if(rebuilddatabase)
			restoreUserCommand();
		//createDbFile();
	}
	catalog.reset((Catalog*)new SlowCatalog(gSettings,gSearchResult,&db));
	GetShellDir(CSIDL_FAVORITES, gIeFavPath);
	defBrowser = tz::getDefaultBrowser();
	if(!QFile::exists(defBrowser)){
		defBrowser.clear();	
	}	
	alternatives = new QCharListWidget(this);
	listDelegate = new IconDelegate(this);
	defaultDelegate = alternatives->itemDelegate();
	setCondensed(gSettings->value("condensedView", false).toBool());
	alternatives->setObjectName("alternatives");
	alternatives->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
	alternatives->setTextElideMode(Qt::ElideLeft);
	alternatives->setWindowFlags(Qt::Window | Qt::Tool | Qt::FramelessWindowHint);
	altScroll = alternatives->verticalScrollBar();
	altScroll->setObjectName("altScroll");
	//      combo->setSizeAdjustPolicy(QComboBox::AdjustToContentsOnFirstShow);
	connect(alternatives, SIGNAL(keyPressed(QKeyEvent *)), this, SLOT(altKeyPressEvent(QKeyEvent *)));
	connect(alternatives, SIGNAL(focusOut(QFocusEvent *)), this, SLOT(focusOutEvent(QFocusEvent *)));


	// Load the plugins
//	plugins.loadPlugins();

	// Load the skin
	applySkin(gSettings->value("skin", dirs["defSkin"][0]).toString());

	// Move to saved position
	QPoint x;
	/*
	if (rescue)
	{
		QDesktopWidget* desktop = QApplication::desktop(); 
		x = QPoint((desktop->width() - width())/2, (desktop->height() - height())/2);
	}
	else
	*/
		x = loadPosition(rescue);
	move(x);
	platform->MoveAlphaBorder(x);
	//get broswerenable
	//getBrowserEnable(gSettings,tz::getbrowserInfo());
	setBrowserEnable(gSettings);

	// Set the general options
	setAlwaysShow(gSettings->value("alwaysshow", false).toBool());
	setAlwaysTop(gSettings->value("alwaystop", false).toBool());
	setPortable(gSettings->value("isportable", false).toBool());


	// Check for udpates?
	/*
	if (gSettings->value("updatecheck", true).toBool())
	{
		checkForUpdate();
	}
	*/
	// Set the hotkey
	int curMeta = gSettings->value("hotkeyModifier", HOTKEY_PART_0).toInt();
	int curAction = gSettings->value("hotkeyAction", HOTKEY_PART_1).toInt();
	if (!setHotkey(curMeta, curAction))
	{
		QMessageBox::warning(this, tr(APP_NAME), tr("The hotkey you have chosen is already in use. Please select another from "APP_NAME"'s preferences."));
		rescue = true;
	}
	// Set the timers
	updateSuccessTimer = NULL;
	runseconds = NOW_SECONDS;
	
	timer_actionlist = new TIMER_ACTION_LIST[TIMER_ACTION_MAX];

	/*
	timer_actionlist[TIMER_ACTION_BMSYNC].actionType= TIMER_ACTION_BMSYNC;
	timer_actionlist[TIMER_ACTION_BMSYNC].enable =  (gSettings->value("ckbmsync", true).toBool())?1:0;
#ifdef QT_NO_DEBUG
	timer_actionlist[TIMER_ACTION_BMSYNC].startAfterRun =  (short)(30);
#else
	timer_actionlist[TIMER_ACTION_BMSYNC].startAfterRun =  (short)(5);
#endif
	timer_actionlist[TIMER_ACTION_BMSYNC].lastActionSeconds = (gSettings->value("lastbmsync", 0).toUInt());
	if(timer_actionlist[TIMER_ACTION_BMSYNC].lastActionSeconds>runseconds){
		timer_actionlist[TIMER_ACTION_BMSYNC].lastActionSeconds=0;
	}
	timer_actionlist[TIMER_ACTION_BMSYNC].interval= (SILENT_SYNC_INTERVAL*SILENT_SYNC_INTERVAL_UNIT)/(SECONDS);
*/
#ifdef QT_NO_DEBUG
	INIT_TIMER_ACTION_LIST(TIMER_ACTION_BMSYNC,"bmsync",30,(SILENT_SYNC_INTERVAL*SILENT_SYNC_INTERVAL_UNIT)/(SECONDS));
	INIT_TIMER_ACTION_LIST(TIMER_ACTION_CATBUILDER,"catbuilder",60,(CATALOG_BUILDER_INTERVAL*CATALOG_BUILDER_INTERVAL_UNIT)/(SECONDS));
	INIT_TIMER_ACTION_LIST(TIMER_ACTION_AUTOLEARNPROCESS,"autolearnprocess",90,(AUTO_LEARN_PROCESS_INTERVAL*AUTO_LEARN_PROCESS_INTERVAL_UNIT)/(SECONDS));
	timer_actionlist[TIMER_ACTION_AUTOLEARNPROCESS].enable = 1;//special
	INIT_TIMER_ACTION_LIST(TIMER_ACTION_DIGGXML,"diggxml",120,(DIGG_XML_INTERVAL*DIGG_XML_INTERVAL_UNIT)/(SECONDS));
	INIT_TIMER_ACTION_LIST(TIMER_ACTION_SILENTUPDATER,"silentupdate",150,(24*HOURS)/(SECONDS));
#else
	INIT_TIMER_ACTION_LIST(TIMER_ACTION_BMSYNC,"bmsync",5,(SILENT_SYNC_INTERVAL*SILENT_SYNC_INTERVAL_UNIT)/(SECONDS));
	INIT_TIMER_ACTION_LIST(TIMER_ACTION_CATBUILDER,"catbuilder",10,(CATALOG_BUILDER_INTERVAL*CATALOG_BUILDER_INTERVAL_UNIT)/(SECONDS));
	INIT_TIMER_ACTION_LIST(TIMER_ACTION_AUTOLEARNPROCESS,"autolearnprocess",15,(AUTO_LEARN_PROCESS_INTERVAL*AUTO_LEARN_PROCESS_INTERVAL_UNIT)/(SECONDS));
	timer_actionlist[TIMER_ACTION_AUTOLEARNPROCESS].enable = 1;//special
	INIT_TIMER_ACTION_LIST(TIMER_ACTION_DIGGXML,"diggxml",20,(DIGG_XML_INTERVAL*DIGG_XML_INTERVAL_UNIT)/(SECONDS));
	INIT_TIMER_ACTION_LIST(TIMER_ACTION_SILENTUPDATER,"silentupdate",25,(24*HOURS)/(SECONDS));
#endif
	
	slientUpdate =NULL;
#ifdef CONFIG_AUTO_LEARN_PROCESS
	learnProcessTimes = 0;
#endif
#if 0	
	NEW_TIMER(catalogBuilderTimer);
	NEW_TIMER(silentupdateTimer);
	NEW_TIMER(syncTimer);
	connect(catalogBuilderTimer, SIGNAL(timeout()), this, SLOT(catalogBuilderTimeout()));
	connect(silentupdateTimer, SIGNAL(timeout()), this, SLOT(silentupdateTimeout()));
	connect(syncTimer, SIGNAL(timeout()), this, SLOT(syncTimeout()));
#ifdef CONFIG_AUTO_LEARN_PROCESS
	NEW_TIMER(autoLearnProcessTimer);
	
	connect(autoLearnProcessTimer, SIGNAL(timeout()), this, SLOT(autoLearnProcessTimeout()));
	autoLearnProcessTimer->start(AUTO_LEARN_PROCESS_INTERVAL*AUTO_LEARN_PROCESS_INTERVAL_UNIT);
#endif
#ifdef CONFIG_DIGG_XML
		NEW_TIMER(diggXmlTimer);
		connect(diggXmlTimer, SIGNAL(timeout()), this, SLOT(diggXmlTimeout()));
		diggXmlTimer->start(DIGG_XML_INTERVAL);//60m
#endif
	if (gSettings->value("catalogBuilderTimer", 10).toInt() != 0)
		catalogBuilderTimer->start(1*SECONDS);//1m
	if (gSettings->value("silentUpdateTimer", 10).toInt() != 0)
		silentupdateTimer->start(1*SECONDS);//1m
	if (gSettings->value("synctimer", SILENT_SYNC_INTERVAL).toInt() != 0)
		syncTimer->start(SILENT_SYNC_INTERVAL*SILENT_SYNC_INTERVAL_UNIT);//5m
#endif


	NEW_TIMER(dropTimer);
	dropTimer->setSingleShot(true);
	connect(dropTimer, SIGNAL(timeout()), this, SLOT(dropTimeout()));

	// Load the catalog
	updateTimes=0;

	showLaunchyFirstTime=gSettings->value("ckShowMainwindow", false).toBool();

	if (showLaunchyFirstTime || rescue)
		showLaunchy();
	else
		hideLaunchy();
	
	icon =QIcon("images/"+QString(APP_NAME)+".png");
	icon_problem=QIcon("images/"+QString(APP_NAME)+"_gray.png");	
	setWindowIcon(icon);
	
	setIcon(1,QString(APP_NAME));
	if(gSettings->value("ckShowTray", true).toBool())
	{
		trayIcon->show();
	}
	if(!gSettings->value("exportbookmark", true).toBool()){
		tz::deleteNetworkBookmark(&db,0);
	}
	
	NEW_TIMER(monitorTimer);
	connect(monitorTimer, SIGNAL(timeout()), this, SLOT(monitorTimerTimeout()), Qt::DirectConnection);					
	monitorTimer->start(MONITER_TIME_INTERVAL);	
}

void MyWidget::setCondensed(int condensed)
{
	if (alternatives == NULL || listDelegate == NULL || defaultDelegate == NULL)
		return;
	if (condensed)
		alternatives->setItemDelegate(defaultDelegate);
	else
		alternatives->setItemDelegate(listDelegate);

}
bool MyWidget::setHotkey(int meta, int key)
{
	QKeySequence keys = QKeySequence(meta + key);
	return platform->SetHotkey(keys, this, SLOT(onHotKey()));
}

void MyWidget::menuEvent(QContextMenuEvent * evt)
{
	contextMenuEvent(evt);
}

void MyWidget::showAlternatives(bool show)
{
	if (!isVisible())
		return;

	if (searchResults.size() <= 1)
		return;
	QRect n = altRect;
	n.translate(pos());

	alternatives->setGeometry(n);

	if (show)
	{
		//alternatives->clear();
		int num = alternatives->count();
		for (int i = 0; i < num; ++i)
		{
			QListWidgetItem *item = alternatives->takeItem(0);
			if (item != NULL)
				delete item;
		}


		for (int i = 0; i < searchResults.size(); ++i)
		{
			QFileInfo fileInfo(searchResults[i]->fullPath);

			QIcon icon = getIcon(searchResults[i]);
			QListWidgetItem *item = new QListWidgetItem(icon, QDir::toNativeSeparators(searchResults[i]->fullPath), alternatives);
			//                      QListWidgetItem *item = new QListWidgetItem(alternatives);
			item->setData(ROLE_FULL, QDir::toNativeSeparators(searchResults[i]->fullPath));
			//  qDebug("size=%d fullPath=%s\n",searchResults.size(),qPrintable(searchResults[i].fullPath));
			item->setData(ROLE_SHORT, searchResults[i]->shortName);
			item->setData(ROLE_ICON, icon);
			item->setToolTip(QDir::toNativeSeparators(searchResults[i]->fullPath));
			alternatives->addItem(item);
			alternatives->setFocus();
		}
		if (alternatives->count() > 0)
		{
			int numViewable = gSettings->value("numviewable", "4").toInt();
			//QRect r = alternatives->geometry();
			int min = alternatives->count() < numViewable ? alternatives->count() : numViewable;
			n.setHeight(min * alternatives->sizeHintForRow(0));

			altRect.setHeight(n.height());

			// Is there room for the dropdown box?
			if (n.y() + n.height() > qApp->desktop()->height())
			{
				n.moveTop(pos().y() + input->pos().y() - n.height());
			}
			alternatives->setGeometry(n);
		}
		double opaqueness = (double) gSettings->value("opaqueness", 100).toInt();
		opaqueness /= 100.0;
		alternatives->setWindowOpacity(opaqueness);
		alternatives->show();
		qApp->syncX();
		alternatives->raise();
	} else
	{
		alternatives->hide();
	}
}

void MyWidget::increaseUsage(CatItem& item,const QString& alias)
{
	QSqlQuery	q("", db);
	uint time = NOW_SECONDS;
	//queryStr=QString("update  %1 set usage=usage+1,shortCut='%2' where hashId=%3 and fullPath='%4'").arg(DB_TABLE_NAME).arg(shortCut).arg(qHash(fullPath)).arg(fullPath);

	if(item.shortCut==0){
		item.usage = 1;
		item.alias2 = alias;
		item.shortCut = 1;
		item.time = time;
		//inputData[0].setTopResult(item);
		CatItem::prepareInsertQuery(&q,item,COME_FROM_SHORTCUT);
		q.exec();
		q.clear();

		q.prepare(
			QString(
			"UPDATE %1 set shortCut=1 where id=:id"
			).arg(DBTABLEINFO_NAME(item.comeFrom))
			);
		//qDebug()<<QString("UPDATE %1 set shortCut=1 where id=%2").arg(DBTABLEINFO_NAME(item.comeFrom)).arg(item.idInTable);
		q.bindValue(":id", item.idInTable);
		q.exec();
		q.clear();
	}
	else
	{
		//check similar
		int similar = -1;

		if(item.alias2.size()>=alias.size())
		{
			similar = item.alias2.indexOf(alias);
		}else
			similar = alias.indexOf(item.alias2);

		if(similar >= 0)//similar
		{
			if( item.alias2.size()< alias.size())
			{
				q.prepare(
					QString(
					"UPDATE %1 set usage=usage+1,alias2=:alias2,time=:time where id=:id"
					).arg(DBTABLEINFO_NAME(COME_FROM_SHORTCUT))
					);
				q.bindValue(":alias2", alias);
				q.bindValue(":time", time);
			}else{
				q.prepare(
					QString(
					"UPDATE %1 set usage=usage+1,time=:time where id=:id"
					).arg(DBTABLEINFO_NAME(COME_FROM_SHORTCUT))
					);
			}
			q.bindValue(":time", time);
			q.bindValue(":id", item.idInTable);
			q.exec();
			q.clear();
		}				
		else{//not similar,join original
			q.prepare(
				QString(
				"UPDATE %1 set usage=usage+1,alias2=:alias2,time=:time where id=:id"
				).arg(DBTABLEINFO_NAME(COME_FROM_SHORTCUT))
				);
			q.bindValue(":alias2", item.alias2.append(" ").append(alias));
			q.bindValue(":time", time);
			q.bindValue(":id", item.idInTable);
			q.exec();
			q.clear();					
		}

	}		
}
void MyWidget::launchBrowserObject(CatItem& res)
{
	QString bin;
	getBrowserFullpath(res.comeFrom-COME_FROM_BROWSER_START,bin);	
	if(bin.isEmpty())
		bin = defBrowser;
	qDebug()<<bin;
	if(!bin.isEmpty()){
		if(bin.endsWith(BROWSER_FIREFOX_BIN_NAME,Qt::CaseInsensitive))
			runProgram(bin,tr("-new-tab %1").arg(res.fullPath));
		else
			runProgram(bin,tr(" %1").arg(res.fullPath));
	}
	else
		runProgram(res.fullPath,QString(""));
}

void MyWidget::launchObject()
{
	CatItem res;
	if((inputMode&(1<<INPUT_MODE_NULL_PAGEDOWN))||inputData.isEmpty())
	{
		res = *(searchResults[0]);
		increaseUsage(res,"");

	}else{
		CatItem& r = inputData[0].getTopResult();
		increaseUsage(r,inputData[0].getText());
		res = r;
	}

	if (res.comeFrom<=COME_FROM_PROGRAM)
	{
		QString arg,args(res.args);
		if (inputData.count() > 1)
			for (int i = 1; i < inputData.count(); ++i)
				arg += inputData[i].getText() + " ";
		if(IS_URL(res.fullPath))
			arg = QUrl::toPercentEncoding(arg.trimmed());
		else
			arg.trimmed();
		if(args.indexOf("%s",Qt::CaseInsensitive)!=-1)
			args.replace("%s",arg);
		else
			args.append(" ").append(arg);
		qDebug()<<" "<<res.shortName <<" with argument: "<<args<< " from "<<res.comeFrom;
		if (!platform->Execute(res.fullPath, args))
		{

			if(IS_URL(res.fullPath)){
				QString urlpath(res.fullPath);
				if(res.fullPath.trimmed().endsWith("/",Qt::CaseInsensitive))
					urlpath.append(args);
				else
					urlpath.append("/").append(args);
				runProgram(urlpath, "");
			}
			else
				runProgram(res.fullPath, args);
		}
	} else if(IS_FROM_BROWSER(res.comeFrom)){
		//Weby web(gSettings);
		//web.launchItem(&inputData, &res);
		launchBrowserObject(res);
		/*
		if(res.comeFrom==COME_FROM_FIREFOX)
		{
			QString ff_bin;
			if(getFirefoxBinPath(ff_bin)){
				qDebug()<<ff_bin;
				runProgram(ff_bin,tr("-new-tab %1").arg(res.fullPath));
			}else{
				ff_bin=gSettings->value("adv/firefoxbin","").toString();
				if(!ff_bin.isEmpty())
					runProgram(ff_bin,tr("-new-tab %1").arg(res.fullPath));
				else
					runProgram(res.fullPath,QString(""));

			}
		}if(res.comeFrom==COME_FROM_NETBOOKMARK){
			//QString bin=gSettings->value("netbookmarkbrowser","").toString();		
			QString bin;
			getBrowserFullpath(COME_FROM_NETBOOKMARK-COME_FROM_BROWSER_START,bin);
			qDebug()<<bin;
			if(!bin.isEmpty())
				runProgram(bin,tr("-new-tab %1").arg(res.fullPath));
			else
				runProgram(res.fullPath,QString(""));

			
		}else{
			QString ie_bin=getIEBinPath();

			
			if(getIEBinPath(ie_bin)){
				qDebug()<<ie_bin;
				runProgram(ie_bin,res.fullPath);
			}else{
				ie_bin=gSettings->value("adv/iebin","").toString();
				if(!ie_bin.isEmpty())
					runProgram(ie_bin,res.fullPath);
				else
					runProgram(res.fullPath,QString(""));

			}
		}
		*/


	}
	else {
#if 0
		int ops = plugins.execute(&inputData, &res);
		if (ops > 1)
		{
			switch (ops)
			{
			case MSG_CONTROL_EXIT:
				close();
				break;
			case MSG_CONTROL_OPTIONS:
				menuOptions();
				break;
			case MSG_CONTROL_REBUILD:
				buildCatalog();
				break;
			default:
				break;
			}
		}
#endif
	}
	//catalog->incrementUsage(res);
}

void MyWidget::focusOutEvent(QFocusEvent * evt)
{
	if (evt->reason() == Qt::ActiveWindowFocusReason)
	{
		if (gSettings->value("hideiflostfocus", false).toBool())
			if (!this->isActiveWindow() && !alternatives->isActiveWindow() && !optionsOpen)
			{
				hideLaunchy();
			}
	}
}


void MyWidget::altKeyPressEvent(QKeyEvent * key)
{
	//LOG_RUN_LINE;
	if (key->key() == Qt::Key_Escape)
	{
		alternatives->hide();
	}
	if (key->key() == Qt::Key_Up)
	{
		key->ignore();
	} else if (key->key() == Qt::Key_Down)
	{
		key->ignore();
	} else if (key->key() == Qt::Key_Return || key->key() == Qt::Key_Enter || key->key() == Qt::Key_Tab)
	{
		if (searchResults.count() > 0)
		{
			int row = alternatives->currentRow();
			if (row > -1)
			{
				QString location = "History/" + input->text();
				QStringList hist;
				hist << searchResults[row]->lowName << searchResults[row]->fullPath;
				gSettings->setValue(location, hist);

				CatItem* tmp = searchResults[row];
				searchResults[row] = searchResults[0];
				searchResults[0] = tmp;

				updateDisplay();

				/* This seems to be unnecessary
				if (key->key() == Qt::Key_Tab) {
				inputData.last().setText(searchResults[0].fullPath);
				input->setText(printInput() + searchResults[0].fullPath);
				}
				*/
				alternatives->hide();


				if (key->key() == Qt::Key_Tab)
				{
					doTab();
					parseInput(input->text());
					searchOnInput();
					updateDisplay();
					dropTimer->stop();
					dropTimer->start(1000);
				} else
				{
					doEnter();
				}
			}
		}
	} else
	{
		alternatives->hide();
		activateWindow();
		raise();
		input->setFocus();
		key->ignore();
		input->setText(input->text() + key->text());
		keyPressEvent(key);
	}
}





void MyWidget::inputKeyPressEvent(QKeyEvent * key)
{
	if (key->key() == Qt::Key_Tab)
	{
		keyPressEvent(key);
	} else
	{
		key->ignore();
	}
}

void MyWidget::parseInput(QString text)
{
	//      QStringList spl = text.split(" | ");
	if(!text.isEmpty())
		inputMode&=(~(1<<INPUT_MODE_NULL_PAGEDOWN));
	else{
		inputData.clear();
		return;
	}

	if(text.endsWith(QString(" ") + sepChar()))
	{
		text.chop(QString(" ").append(sepChar()).size());
		input->setText(text);
	}
	QStringList spl = text.split(QString(" ") + sepChar() + QString(" "));
	if (spl.count() < inputData.count())
	{
		inputData = inputData.mid(0, spl.count());
	}
#ifdef CONFIG_LOG_ENABLE_1
	for (int i = 0; i < inputData.size(); i++)
	{
		qDebug("%s inputData[%d] %s", __FUNCTION__, i, TOCHAR(inputData[i].getText()));
	}
#endif

	for (int i = 0; i < inputData.size(); i++)
	{
		if (inputData[i].getText() != spl[i])
		{
			inputData = inputData.mid(0, i);
			break;
		}
	}

	for (int i = inputData.count(); i < spl.count(); i++)
	{
		InputData data(spl[i]);
		inputData.push_back(data);
	}
	if(  text.indexOf(QString(" ") + sepChar()+QString(" ")) == -1)
		inputMode&=(~(1<<INPUT_MODE_TAB));
}

// Print all of the input up to the last entry
QString MyWidget::printInput()
{
	QString res = "";
	for (int i = 0; i < inputData.count() - 1; ++i)
	{
		res += inputData[i].getText();
		res += QString(" ") + sepChar() + QString(" ");
	}
	return res;
}

void MyWidget::doTab()
{
	//	LOG_RUN_LINE;
	if ( ((inputMode&(1<<INPUT_MODE_NULL_PAGEDOWN))||inputData.count() > 0) && searchResults.count() > 0)
	{
		// If it's an incomplete file or dir, complete it
		QFileInfo info(searchResults[0]->fullPath);
		inputMode |=(1<<INPUT_MODE_TAB);
		if ((/*inputData.last().hasLabel(LABEL_FILE) ||*/ info.isDir()))	//     && input->text().compare(QDir::toNativeSeparators(searchResults[0].fullPath), Qt::CaseInsensitive) != 0)
		{
			QString path;
			if (info.isSymLink())
				path = info.symLinkTarget();
			else
				path = searchResults[0]->fullPath;

			if (info.isDir() && !path.endsWith(QDir::separator()))
				path += QDir::separator();

			input->setText(printInput() + QDir::toNativeSeparators(path));
		} else
		{
			// Looking for a plugin
			if(inputMode&(1<<INPUT_MODE_NULL_PAGEDOWN))
			{
				input->setText(searchResults[0]->shortName + " " + sepChar() + " ");	
				parseInput(input->text());
				inputData[0].setTopResult(*searchResults[0]);
			}else{
				input->setText(input->text() + " " + sepChar() + " ");
				inputData.last().setText(searchResults[0]->shortName);
				input->setText(printInput() + searchResults[0]->shortName + " " + sepChar() + " ");				   
			}
			input->repaint();
		}
	}
}

void MyWidget::doEnter()
{

	if (dropTimer->isActive())
		dropTimer->stop();
	if (searchResults.count() > 0 || inputData.count() > 1)
		launchObject();
	else{
		//google or baidu

		if(gSearchTxt!="")
		{
			QString netsearchbrowser=gSettings->value("netsearchbrowser","").toString().trimmed();
			//runProgram(netsearchbrowser,"");
			//uint   netfinder = gSettings->value("netfinder",qhashEx(QString("google"),QString("google").count())).toUInt();
			int i = 0;
			while(netfinders[i].name!=0){				
				if(gSettings->value(QString("netfinder/").append(netfinders[i].name),true).toBool())
				{
					QString args =  QString(netfinders[i].args).append(QUrl::toPercentEncoding(gSearchTxt));					
					if(!netsearchbrowser.isEmpty()){
						qDebug()<<netsearchbrowser<<QString(netfinders[i].fullpath).append(args);
						runProgram(netsearchbrowser,QString(netfinders[i].fullpath).append(args));
					}else{
						if (!platform->Execute(netfinders[i].fullpath,args))
						{
							runProgram(QString(netfinders[i].fullpath).append(args), "");
						}
					}
				}
				i++;
			}
		}
	}
	hideLaunchy();
	inputMode=0;;

}
void MyWidget::doPageDown(int mode)
{
	inputMode|=(1<<mode);
	if(mode == INPUT_MODE_PAGEDOWN)
	{
		if( searchResults.count() > 0 ){
			CatItem *item = searchResults[0];
			//qDebug()<<"shortName :"<<item->shortName<<" fullpath: "<<item->fullPath;
			QFileInfo f(item->fullPath);
			QFileInfo realfile ;
			if(f.exists()){
				//qDebug()<<"fileName :"<<f.fileName()<<" filePath: "<<f.filePath()<<" isSymLink"<<f.isSymLink();
				if(f.isSymLink())
				{
					//qDebug()<<"symLinkTarget:"<<f.symLinkTarget();
					realfile = QFileInfo(f.symLinkTarget());							
				}
				else
					realfile = f;
				if(realfile.exists())
				{
					runProgram(realfile.dir().absolutePath(),"");
					if (dropTimer->isActive())
						dropTimer->stop();

					hideLaunchy();
					inputMode=0;
				}
			}
		}
	}
}



void MyWidget::keyPressEvent(QKeyEvent * key)
{
	//LOG_RUN_LINE;
	switch(key->key())
	{
	case Qt::Key_Escape:
		if (alternatives->isVisible())
			alternatives->hide();
		else
			hideLaunchy();
		break;
	case Qt::Key_Return:
	case Qt::Key_Enter:
		doEnter();
		break;
	case Qt::Key_Down:
		if (!alternatives->isVisible())
		{
			dropTimer->stop();
			showAlternatives();
		}
		if (alternatives->isVisible() && this->isActiveWindow())
		{
			alternatives->setFocus();
			if (alternatives->count() > 0)
			{
				alternatives->setCurrentRow(0);
			}


			alternatives->activateWindow();

		}
		break;
	case Qt::Key_Up:
		// Prevent alternatives from being hidden on up key
		break;
	case Qt::Key_Tab:
		doTab();
		processKey();
		break;
	case Qt::Key_Slash:
	case Qt::Key_Backslash:
		if (inputData.size() > 0 && inputData.last().hasLabel(LABEL_FILE))
			doTab();
		processKey();
		break;
	case Qt::Key_PageDown:
		if(input->text().isEmpty()){
			doPageDown(INPUT_MODE_NULL_PAGEDOWN);
			key->ignore();			   	
			processKey();
		}else	{
			doPageDown(INPUT_MODE_PAGEDOWN);
			key->ignore();
		}
		break;
	default:
		key->ignore();
		processKey();
		break;
	}
	/*	
	if (key->key() == Qt::Key_Escape)
	{
	if (alternatives->isVisible())
	alternatives->hide();
	else
	hideLaunchy();
	}

	else if (key->key() == Qt::Key_Return || key->key() == Qt::Key_Enter)
	{
	doEnter();
	}

	else if (key->key() == Qt::Key_Down)
	{
	if (!alternatives->isVisible())
	{
	dropTimer->stop();
	showAlternatives();
	}
	if (alternatives->isVisible() && this->isActiveWindow())
	{
	alternatives->setFocus();
	if (alternatives->count() > 0)
	{
	alternatives->setCurrentRow(0);
	}


	alternatives->activateWindow();

	}
	}

	else if (key->key() == Qt::Key_Up)
	{
	// Prevent alternatives from being hidden on up key
	}


	else
	{
	if (key->key() == Qt::Key_Tab)
	{
	doTab();
	} else if (key->key() == Qt::Key_Slash || key->key() == Qt::Key_Backslash)
	{
	if (inputData.size() > 0 && inputData.last().hasLabel(LABEL_FILE))
	doTab();
	} else
	{
	key->ignore();
	}

	processKey();

	}
	*/
}


void MyWidget::processKey()
{
	alternatives->hide();
	dropTimer->stop();
	dropTimer->start(1000);

	parseInput(input->text());
	searchOnInput();
	updateDisplay();

}

void MyWidget::inputMethodEvent(QInputMethodEvent * e)
{
	e = e;			// Warning removal
	processKey();
}

void MyWidget::searchOnInput()
{
	if (catalog == NULL)
		return;

	searchResults.clear();
	if(inputMode&(1<<INPUT_MODE_NULL_PAGEDOWN))
	{
		catalog->getHistory(searchResults);
		return;
	}

	gSearchTxt = inputData.count() > 0 ? inputData.last().getText() : "";


	//qDebug()<<inputData.count() <<"  : "<<gSearchTxt;

	if (inputData.count() <= 1)
		catalog->searchCatalogs(gSearchTxt, searchResults);



	if (searchResults.count() != 0)
		inputData.last().setTopResult(*(searchResults[0]));
	else{
		//google or baidu
		
	}

	//	plugins.getLabels(&inputData);
	//	plugins.getResults(&inputData, &searchResults);
#if 0
	qDebug()<<"search results:";
	for (int i = 0; i < searchResults.count(); i++)
	{
		//qDebug("%d fullpath=%s iconpath=%s useage=%d", i, qPrintable(searchResults[i].fullPath), qPrintable(searchResults[i].icon), searchResults[i].usage);
		qDebug()<<" "<<searchResults[i]->shortName<<" "<<searchResults[i]->fullPath<<" "<<searchResults[i]->comeFrom;
	}
#endif
	qSort(searchResults.begin(), searchResults.end(), CatLess);


	//          qDebug() << gSearchTxt;
	// Is it a file?

	if (gSearchTxt.contains(QDir::separator()) || gSearchTxt.startsWith("~") || (gSearchTxt.size() == 2 && gSearchTxt[1] == ':'))
	{
		searchFiles(gSearchTxt, searchResults);

	}
	//catalog->checkHistory(gSearchTxt, searchResults);
}

void MyWidget::updateDisplay()
{
	if (searchResults.count() > 0)
	{
		QIcon icon = getIcon(searchResults[0]);

		licon->setPixmap(icon.pixmap(QSize(32, 32), QIcon::Normal, QIcon::On));
		output->setText(searchResults[0]->shortName);

		// Did the plugin take control of the input?
		// if (inputData.last().getID() != 0)
		//	  searchResults[0]->comeFrom = inputData.last().getID();
		if(!inputData.isEmpty())
			inputData.last().setTopResult(*(searchResults[0]));

	} else
	{
		if( !(inputMode&(1<<INPUT_MODE_TAB)))
		{
			licon->clear();
			output->clear();
		}
	}
}

QIcon MyWidget::getIcon(CatItem * item)
{
	
	if (item->icon.isEmpty()||item->icon.isNull())
	{
		QDir dir(item->fullPath);
		qDebug()<<item->fullPath;
		if (dir.exists())
			return platform->icons->icon(QFileIconProvider::Folder);
		else if(QFile::exists(item->fullPath))
			return platform->icon(QDir::toNativeSeparators(item->fullPath));
		else{
			qDebug()<<"Catitem:"<<item->fullPath;
			//修正自定义的url
			QUrl url(item->fullPath);
			if(url.isValid()){
					qDebug()<<item->fullPath<<" is valid url";
					return platform->icon(QDir::toNativeSeparators(defBrowser));
			}
		}
		return platform->icon(QDir::toNativeSeparators(item->fullPath));
	} else{
		//qDebug()<<item->fullPath<<" "<<item->icon;
		//#ifdef Q_WS_X11 // Windows needs this too for .png files
		if (QFile::exists(item->icon))
		{
			if(!IS_FROM_BROWSER(item->comeFrom))
				return platform->icon(QDir::toNativeSeparators(item->icon));
			else{
				//maybe the wrong file
				QImageReader imgread(item->icon);			
				if(imgread.format().isEmpty()){
						QString browserfullpath("");
						getBrowserFullpath(item->comeFrom-COME_FROM_BROWSER_START,browserfullpath);
						return platform->icon(QDir::toNativeSeparators(browserfullpath));
				}else{
						return platform->icon(QDir::toNativeSeparators(QString(QCoreApplication::applicationDirPath()).append("\\").append(item->icon)));
				}
			}
		}else if(IS_FROM_BROWSER(item->comeFrom)/*&&QFile::exists(QString(FAVICO_DIRECTORY"/%1.ico").arg(tz::getBrowserName(item->comeFrom-COME_FROM_BROWSER_START).toLower()))*/){
			//return QIcon(QString(FAVICO_DIRECTORY"/%1.ico").arg(tz::getBrowserName(item->comeFrom-COME_FROM_BROWSER_START).toLower()));
			QString browserfullpath("");
			getBrowserFullpath(item->comeFrom-COME_FROM_BROWSER_START,browserfullpath);
			qDebug()<<browserfullpath;
			return platform->icon(QDir::toNativeSeparators(browserfullpath));
		}
		//#endif
		return platform->icon(QDir::toNativeSeparators(item->icon));
	}
}

void MyWidget::searchFiles(const QString & input, QList < CatItem* > &searchResults)
{
	/*
	// Split the string on the last slash

	QString path = QDir::fromNativeSeparators(input);
	if (path.startsWith("~"))
	path.replace("~", QDir::homePath());

	if (path.size() == 2 && path[1] == ':')
	path += "/";

	// Network searches are too slow
	if (path.startsWith("//"))
	return;

	QString dir, file;
	dir = path.mid(0, path.lastIndexOf("/") + 1);
	file = path.mid(path.lastIndexOf("/") + 1);


	QFileInfo info(dir);
	if (!info.isDir())
	return;


	inputData.last().setLabel(LABEL_FILE);

	// Okay, we have a directory, find files that match "file"
	QDir qd(dir);
	QStringList ilist;
	if (gSettings->value("GenOps/showHiddenFiles", false).toBool())
	ilist = qd.entryList(QStringList(file + "*"), QDir::Hidden | QDir::AllDirs | QDir::Files, QDir::DirsFirst | QDir::IgnoreCase | QDir::LocaleAware);
	else
	ilist = qd.entryList(QStringList(file + "*"), QDir::AllDirs | QDir::Files, QDir::DirsFirst | QDir::IgnoreCase | QDir::LocaleAware);


	for (int i = ilist.size() - 1; i >= 0; i--)
	{
	QString inf = ilist[i];

	if (inf.startsWith("."))
	continue;
	if (inf.mid(0, file.count()).compare(file, Qt::CaseInsensitive) == 0)
	{
	QString fp = qd.absolutePath() + "/" + inf;
	fp = QDir::cleanPath(fp);
	QFileInfo in(fp);
	if (in.isDir())
	fp += "/";


	CatItem item(QDir::toNativeSeparators(fp), inf,COME_FROM_PROGRAM);
	searchResults.push_front(item);
	}
	}

	// Showing a directory
	if (file == "")
	{
	QString n = QDir::toNativeSeparators(dir);
	if (!n.endsWith(QDir::separator()))
	n += QDir::separator();
	CatItem item(n,COME_FROM_PROGRAM);
	searchResults.push_front(item);
	}
	*/
	return;
}


void MyWidget::catalogBuilt(int type,int status)
{
	//catalog.reset();
	//catalog = gBuilder->getCatalog();
	//qDebug()<<__FUNCTION__<<gBuilder<<type;
	gBuilder->wait();
	gBuilder.reset();
	//qDebug()<<__FUNCTION__<<"release gSemaphore";
	gSemaphore.release(1);
	//QDEBUG("%s gBuilder=0x%08x\n",__FUNCTION__,gBuilder);
	/*
	delete gBuilder;
	gBuilder = NULL;
	*/
	//      qDebug() << "The catalog is built, need to re-search input text" << catalog->count();
	// Do a search here of the current input text
#if 1
	searchOnInput();
	updateDisplay();
	switch(type){
		case CAT_BUILDMODE_ALL:
			{
				 SAVE_TIMER_ACTION(TIMER_ACTION_CATBUILDER,"catbuilder",TRUE);
				if(status){
					scanDbFavicon();
					//gSettings->setValue("lastcatbuilder", NOW_SECONDS);
					//rebuildAll&=~(1<<TIMER_ACTION_CATBUILDER);
					//timer_actionlist[TIMER_ACTION_CATBUILDER].lastActionSeconds = NOW_SECONDS;
					 //gSettings->setValue("lastcatbuilder", timer_actionlist[TIMER_ACTION_CATBUILDER].lastActionSeconds);
					
					/*
					int time = gSettings->value("catalogBuilderTimer", CATALOG_BUILDER_INTERVAL).toInt();
					if (time != 0)
						catalogBuilderTimer->start(time * CATALOG_BUILDER_INTERVAL_UNIT);//minutes
					*/
				}else
					close();
			}
		break;
		case CAT_BUILDMODE_BOOKMARK:
			//scanDbFavicon();
		break;
		case CAT_BUILDMODE_COMMAND:
		break;
		case CAT_BUILDMODE_IMPORT_NETBOOKMARK:
		if(ops)
			ops->importNetBookmarkFinished(status);
		break;
#ifdef CONFIG_AUTO_LEARN_PROCESS
		case CAT_BUILDMODE_LEARN_PROCESS:
			//timer_actionlist[TIMER_ACTION_AUTOLEARNPROCESS].lastActionSeconds = NOW_SECONDS;
			// gSettings->setValue("lastautolearnprocess", timer_actionlist[TIMER_ACTION_AUTOLEARNPROCESS].lastActionSeconds);
			 SAVE_TIMER_ACTION(TIMER_ACTION_AUTOLEARNPROCESS,"autolearnprocess",TRUE);
			//autoLearnProcessTimer->start(AUTO_LEARN_PROCESS_INTERVAL*AUTO_LEARN_PROCESS_INTERVAL_UNIT);//1m
		break;
#endif
		default:
		break;
	}
#else
	if(type){//successful
		searchOnInput();
		updateDisplay();

		scanDbFavicon();
		gSettings->setValue("lastscan", NOW_SECONDS);
		rebuildAll&=~(1<<REBUILD_CATALOG);

		int time = gSettings->value("catalogBuilderTimer", 10).toInt();
		if (time != 0)
			catalogBuilderTimer->start(time * MINUTES);//minutes
	}else
		close();
#endif
}

void MyWidget::setSkin(QString dir, QString name)
{

	bool wasShowing = isVisible();
	QPoint p = pos();
	hideLaunchy(true);
	applySkin(dir + "/" + name);

	//    applySkin(qApp->applicationDirPath() + "/skins/" + name);
	move(p);
	platform->MoveAlphaBorder(p);
	platform->ShowAlphaBorder();
	if (wasShowing)
		showLaunchy(true);
}

QPoint MyWidget::loadPosition(int rescue)
{
	QRect r = geometry();
	int primary = qApp->desktop()->primaryScreen();
	QRect scr = qApp->desktop()->availableGeometry(primary);

	QPoint p;
	p.setX(scr.width() / 2.0 - r.width() / 2.0);
	p.setY(scr.height() / 2.0 - r.height() / 2.0);

	if (gSettings->value("alwayscenter", false).toBool()||rescue)
	{
		return p;
	}
	QPoint pt = gSettings->value("Display/pos", p).toPoint();
	// See if pt is in the current screen resolution, if not go to center

	if (pt.x() > scr.width() || pt.y() > scr.height() || pt.x() < 0 || pt.y() < 0)
	{
		pt.setX(scr.width() / 2.0 - r.width() / 2.0);
		pt.setY(scr.height() / 2.0 - r.height() / 2.0);
	}
	return pt;
}

/*
void MyWidget::savePosition() {
QPair<double,double> rpos = relativePos();
gSettings->setValue("Display/rposX", rpos.first);
gSettings->setValue("Display/rposY", rpos.second);
}
*/
#if 0

void MyWidget::syncTimeout()
{
	// one hour
	STOP_TIMER(syncTimer);
#ifdef CONFIG_ACTION_LIST
	struct ACTION_LIST item;
	item.action = ACTION_LIST_BOOKMARK_SYNC;
	item.id.mode = SYN_MODE_SILENCE;
	addToActionList(item);
#else	
	_startSync(SYNC_MODE_BOOKMARK,SYN_MODE_SILENCE);	
#endif	
}

void MyWidget::silentupdateTimeout()
{
	//int time = gSettings->value("silentUpdateTimer", 10).toInt();

	silentupdateTimer->stop();

	//	qDebug("silentupdateTimeout !!!startSilentUpdate.....isActive=%d",silentupdateTimer->isActive());
	//do something
	startSilentUpdate();
	//	catalogBuilderTimer->start(time * 60000);//minutes
}

void MyWidget::catalogBuilderTimeout()
{

	// Save the settings periodically
	savePosition();
	gSettings->sync();
	//updateTimes++;
	//bool includeDir=false;
	catalogBuilderTimer->stop();

	//if(updateTimes*time>3600)
	//{
	//	includeDir=true;
	//	updateTimes=0;
	//}
	// //Perform the database update
	/*
	if (gBuilder == NULL)
	{
	gBuilder.reset(new CatBuilder(includeDir,CAT_BUILDMODE_ALL,&db));
	connect(gBuilder.get(), SIGNAL(catalogFinished()), this, SLOT(catalogBuilt()));
	gBuilder->start(QThread::IdlePriority);
	}
	*/
	uint interval = NOW_SECONDS-gSettings->value("lastscan", 0).toUInt();
	qDebug()<<__FUNCTION__<<interval<<" :"<<rebuildAll;
	if((rebuildAll&(1<<REBUILD_CATALOG))||interval>DAYS)
		buildCatalog();

}
#ifdef CONFIG_AUTO_LEARN_PROCESS
void MyWidget::autoLearnProcessTimeout()
{
#ifdef CONFIG_ACTION_LIST
		QDEBUG_LINE;
		STOP_TIMER(autoLearnProcessTimer);
		struct ACTION_LIST item;
		item.action = ACTION_LIST_CATALOGBUILD;
		item.id.mode = CAT_BUILDMODE_LEARN_PROCESS;
		addToActionList(item);
#endif
}
#endif

#ifdef  CONFIG_DIGG_XML
void MyWidget::diggXmlTimeout()
{
#ifdef CONFIG_ACTION_LIST
		STOP_TIMER(diggXmlTimer);
		struct ACTION_LIST item;
		item.action = ACTION_LIST_GET_DIGG_XML;
		addToActionList(item);
#endif
}
#endif

#endif
void MyWidget::dropTimeout()
{
	if (input->text() != ""||(inputMode&(1<<INPUT_MODE_NULL_PAGEDOWN)))
		showAlternatives();
}

void MyWidget::onHotKey()
{

	if (menuOpen || optionsOpen)
	{
		showLaunchy();
		return;
	}

	if (isVisible())
	{
		hideLaunchy();
	} else
	{
		showLaunchy();
	}
}




void MyWidget::closeEvent(QCloseEvent * event)
{
	closeflag = 1;
#if 0
	STOP_TIMER(catalogBuilderTimer);
	STOP_TIMER(silentupdateTimer);
	STOP_TIMER(syncTimer);
#endif
	qDebug()<<"emit erminateNotify"<<gBuilder<<":"<<slientUpdate<<":"<<gSyncer;
	if(gBuilder&&gBuilder->isRunning())
	{
		//emit catalogTerminateNotify();
		gBuilder->terminateflag = 1;
		event->ignore();
		return;

	}
	if(THREAD_IS_RUNNING(slientUpdate))
	{
		//emit silentUpdateTerminateNotify();
		slientUpdate->setTerminateFlag(1);
		event->ignore();
		return;
	}
	if(gSyncer&&gSyncer->isRunning())
	{
		gSyncer->setTerminateFlag(1);
		event->ignore();
		return;
	}

	//      gSettings->setValue("Display/pos", relativePosition());
	savePosition();
	gSettings->sync();
	if (trayIcon->isVisible()) {
		trayIcon->hide();
	}

	QDir dest(gSettings->fileName());
	dest.cdUp();
	//CatBuilder builder(catalog, &plugins);
	//builder.storeCatalog(dest.absoluteFilePath("Launchy.db"));

	// Delete the platform (to unbind hotkeys) right away
	// else XUngrabKey segfaults if done later
	/*
	if (platform)
	delete platform;
	platform = NULL;
	*/
	platform.reset();


	event->accept();

	qApp->quit();
}
void MyWidget::updateSuccessTimeout()
{
	//updateSuccessTimer->stop();
	STOP_TIMER(updateSuccessTimer);
	//check syn , catebulder...
	if(gBuilder||gSyncer)
		updateSuccessTimer->start(1*SECONDS);
	else{
		qDebug("%s start %s !",__FUNCTION__,qPrintable(QString(UPDATE_SETUP_DIRECTORY).append(APP_SETUP_NAME)));
		if(QFile::exists(QString(UPDATE_SETUP_DIRECTORY).append(APP_SETUP_NAME)))
		{
			runProgram(QString(UPDATE_SETUP_DIRECTORY).append(APP_SETUP_NAME),QString(""));
			close();
		}
	}
}
void MyWidget::updateSuccess()
{
	/*
	QSettings s(QString(APP_HKEY_PATH),QSettings::NativeFormat);	
	QString filepath=qApp->applicationFilePath().replace(QString("/"), QString("\\"));
	s.setValue(APP_HEKY_UPDATE_ITEM,1);	
	//	s.remove(APP_NAME);
	s.sync();
	*/
	//if(catalogBuilderTimer&&catalogBuilderTimer->isActive())
	//	catalogBuilderTimer->stop();
#if 0
	STOP_TIMER(catalogBuilderTimer);
	//if(silentupdateTimer&&silentupdateTimer->isActive())
	//	silentupdateTimer->stop();
	STOP_TIMER(silentupdateTimer);
	//if(syncTimer&&syncTimer->isActive())
	//	syncTimer->stop();
	STOP_TIMER(syncTimer);
#ifdef CONFIG_AUTO_LEARN_PROCESS
	STOP_TIMER(autoLearnProcessTimer);
#endif
#ifdef CONFIG_DIGG_XML
	STOP_TIMER(diggXmlTimer);
#endif
#endif

	NEW_TIMER(updateSuccessTimer);
	connect(updateSuccessTimer, SIGNAL(timeout()), this, SLOT(updateSuccessTimeout()));
	updateSuccessTimer->start(1*SECONDS);

}

MyWidget::~MyWidget()
{

	//delete catalogBuilderTimer;
#if 0
	DELETE_TIMER(catalogBuilderTimer);
	DELETE_TIMER(silentupdateTimer);
	DELETE_TIMER(syncTimer);
#ifdef CONFIG_AUTO_LEARN_PROCESS
	DELETE_TIMER(autoLearnProcessTimer);
#endif
#ifdef CONFIG_DIGG_XML
	DELETE_TIMER(diggXmlTimer);
#endif
#endif
	//delete dropTimer;
	DELETE_TIMER(dropTimer);
	/*
	if (platform)
	delete platform;
	*/
	delete alternatives;
	/*
	if(syncDlgTimer&&syncDlgTimer->isActive())
	{
	syncDlgTimer->stop();
	delete syncDlgTimer;
	}
	*/
	DELETE_TIMER(monitorTimer);
	delete[] timer_actionlist;
	DELETE_TIMER(updateSuccessTimer);
	if(catalog)
		catalog.reset();
	platform.reset();
	if(gSearchResult)
		delete[] gSearchResult;
	if(db.isOpen())
		db.close();

}


void MyWidget::MoveFromAlpha(QPoint pos)
{
	move(pos);
	if (alternatives)
		alternatives->hide();
}

void MyWidget::setAlwaysShow(bool alwaysShow)
{
	alwaysShowLaunchy = alwaysShow;
	if (!isVisible() && alwaysShow)
		showLaunchy();
}

void MyWidget::setAlwaysTop(bool alwaysTop)
{
	if (alwaysTop)
	{
		//              setWindowFlags( windowFlags() | Qt::WindowStaysOnTopHint);
	} else
	{
		if ((windowFlags() & Qt::WindowStaysOnTopHint) != 0)
			setWindowFlags(windowFlags() & ~Qt::WindowStaysOnTopHint);
	}

}
void MyWidget::setPortable(bool portable)
{
	if (portable && gSettings->fileName().compare(dirs["portConfig"][0], Qt::CaseInsensitive) != 0)
	{
		delete gSettings;

		// Copy the old settings
		QFile oldSet(dirs["config"][0]);
		oldSet.copy(dirs["portConfig"][0]);
		oldSet.close();

		QFile oldDB(dirs["db"][0]);
		oldDB.copy(dirs["portDB"][0]);
		oldDB.close();

		gSettings = new QSettings(dirs["portConfig"][0], QSettings::IniFormat, this);
	} else if (!portable && gSettings->fileName().compare(dirs["portConfig"][0], Qt::CaseInsensitive) == 0)
	{
		delete gSettings;

		// Remove the ini file we're going to copy to so that copy can work
		QFile newF(dirs["config"][0]);
		newF.remove();
		newF.close();

		// Copy the local ini + db files to the users section
		QFile oldSet(dirs["portConfig"][0]);
		oldSet.copy(dirs["config"][0]);
		oldSet.remove();
		oldSet.close();

		QFile oldDB(dirs["portDB"][0]);
		oldDB.copy(dirs["db"][0]);
		oldDB.remove();
		oldDB.close();

		// Load up the user section ini file
		gSettings = new QSettings(dirs["config"][0], QSettings::IniFormat, this);

	}
}


void MyWidget::setOpaqueness(int val)
{
	double max = (double) val;
	max /= 100.0;
	this->setWindowOpacity(max);
	platform->SetAlphaOpacity(max);
}

void MyWidget::applySkin(QString directory)
{
	// Hide the buttons by default
	closeButton->hide();
	opsButton->hide();

	if (listDelegate == NULL)
		return;

	// Use default skin if this one doesn't exist
	if (!QFile::exists(directory + "/misc.txt"))
	{
		directory = dirs["defSkin"][0];
		gSettings->setValue("skin", dirs["defSkin"][0]);
	}

	// Set positions
	if (QFile::exists(directory + "/misc.txt"))
	{
		QFile file(directory + "/misc.txt");
		if (file.open(QIODevice::ReadOnly | QIODevice::Text))
		{
			QTextStream in(&file);
			while (!in.atEnd())
			{
				QString line = in.readLine();
				if (line.startsWith(";"))
					continue;
				QStringList spl = line.split("=");
				if (spl.size() == 2)
				{
					QStringList sizes = spl.at(1).trimmed().split(",");
					QRect rect;
					if (sizes.size() == 4)
					{
						rect.setRect(sizes[0].toInt(), sizes[1].toInt(), sizes[2].toInt(), sizes[3].toInt());
					}

					if (spl.at(0).trimmed().compare("input", Qt::CaseInsensitive) == 0)
						input->setGeometry(rect);
					else if (spl.at(0).trimmed().compare("output", Qt::CaseInsensitive) == 0)
						output->setGeometry(rect);
					else if (spl.at(0).trimmed().compare("alternatives", Qt::CaseInsensitive) == 0)
						altRect = rect;
					else if (spl.at(0).trimmed().compare("boundary", Qt::CaseInsensitive) == 0)
					{
						setGeometry(rect);
						label->setGeometry(rect);
					} else if (spl.at(0).trimmed().compare("icon", Qt::CaseInsensitive) == 0)
						licon->setGeometry(rect);
					else if (spl.at(0).trimmed().compare("optionsbutton", Qt::CaseInsensitive) == 0)
					{
						opsButton->setGeometry(rect);
						opsButton->show();
					} else if (spl.at(0).trimmed().compare("closebutton", Qt::CaseInsensitive) == 0)
					{
						closeButton->setGeometry(rect);
						closeButton->show();
					} else if (spl.at(0).trimmed().compare("dropPathColor", Qt::CaseInsensitive) == 0)
						listDelegate->setColor(spl.at(1));
					else if (spl.at(0).trimmed().compare("dropPathSelColor", Qt::CaseInsensitive) == 0)
						listDelegate->setColor(spl.at(1), true);
					else if (spl.at(0).trimmed().compare("dropPathFamily", Qt::CaseInsensitive) == 0)
						listDelegate->setFamily(spl.at(1));
					else if (spl.at(0).trimmed().compare("dropPathSize", Qt::CaseInsensitive) == 0)
						listDelegate->setSize(spl.at(1).toInt());
					else if (spl.at(0).trimmed().compare("dropPathWeight", Qt::CaseInsensitive) == 0)
						listDelegate->setWeight(spl.at(1).toInt());
					else if (spl.at(0).trimmed().compare("dropPathItalics", Qt::CaseInsensitive) == 0)
						listDelegate->setItalics(spl.at(1).toInt());
				}

			}
			file.close();
		}
	}
	// Load the style sheet
	if (QFile::exists(directory + "/style.qss"))
	{
		QFile file(directory + "/style.qss");
		if (file.open(QIODevice::ReadOnly | QIODevice::Text))
		{
			QString styleSheet = QLatin1String(file.readAll());
			// This is causing the ::destroyed connect errors
			qApp->setStyleSheet(styleSheet);
			file.close();
		}
	}
	// Set the background image
	if (!platform->SupportsAlphaBorder() && QFile::exists(directory + "/background_nc.png"))
	{
		QPixmap image(directory + "/background_nc.png");
		label->setPixmap(image);
	}

	else if (QFile::exists(directory + "/background.png"))
	{
		QPixmap image(directory + "/background.png");
		label->setPixmap(image);
	}
	// Set the background mask
	if (!platform->SupportsAlphaBorder() && QFile::exists(directory + "/mask_nc.png"))
	{
		QPixmap image(directory + "/mask_nc.png");
		setMask(image);
	}

	else if (QFile::exists(directory + "/mask.png"))
	{
		QPixmap image(directory + "/mask.png");
		// For some reason, w/ compiz setmask won't work
		// for rectangular areas.  This is due to compiz and
		// XShapeCombineMask
		setMask(image);
	}

	// Set the alpha background
	if (QFile::exists(directory + "/alpha.png") && platform->SupportsAlphaBorder())
	{
		platform->CreateAlphaBorder(this, directory + "/alpha.png");
		connectAlpha();
		platform->MoveAlphaBorder(pos());
	}


}


void MyWidget::connectAlpha()
{
	shared_ptr < QWidget > w = platform->getAlphaWidget();
	if (!w)
		return;
	connect(w.get(), SIGNAL(menuEvent(QContextMenuEvent *)), this, SLOT(menuEvent(QContextMenuEvent *)));
	connect(w.get(), SIGNAL(mousePress(QMouseEvent *)), this, SLOT(mousePressEvent(QMouseEvent *)));
	connect(w.get(), SIGNAL(mouseMove(QMouseEvent *)), this, SLOT(mouseMoveEvent(QMouseEvent *)));
}


void MyWidget::mousePressEvent(QMouseEvent * e)
{
	//alternatives->hide();
	activateWindow();
	raise();
	showAlternatives(false);
	moveStartPoint = e->pos();
}

void MyWidget::mouseMoveEvent(QMouseEvent * e)
{
	QPoint p = e->globalPos();
	p -= moveStartPoint;
	move(p);
	platform->MoveAlphaBorder(p);
	showAlternatives(false);
	input->setFocus();
}



void MyWidget::contextMenuEvent(QContextMenuEvent * event)
{
	QMenu menu(this);
	menu.addAction(rebuildCatalogAction);
	menu.addAction(optionsAction);
	menu.addAction(restoreAction);
	menu.addAction(syncAction);
	menu.addSeparator();
	menu.addAction(quitAction);
	menuOpen = true;
	menu.exec(event->globalPos());
	menuOpen = false;
}
#ifdef CONFIG_ACTION_LIST
/*
void MyWidget::importNetBookmarkFinished(int status)
{
	QDEBUG_LINE;
	gBuilder->wait();
	gBuilder.reset();
	//emit importNetBookmarkFinishedSignal(status);
	if(ops)
		ops->importNetBookmarkFinished(status);
	gSemaphore.release(1);
}

void MyWidget::importNetBookmark(CATBUILDMODE mode,uint browserid)
{
	qDebug()<<__FUNCTION__<<gBuilder;
	if (gBuilder == NULL)
	{
		gBuilder.reset(new CatBuilder(true,mode,&db));
		gBuilder->browserid = browserid;
		connect(gBuilder.get(), SIGNAL(importNetBookmarkFinishedSignal(int)), this, SLOT(importNetBookmarkFinished(int)));
		//if(ops)
		//	connect(gBuilder.get(), SIGNAL(importNetBookmarkFinishedSignal(int)), ops, SLOT(importNetBookmarkFinished(int)));
		gBuilder->start(QThread::IdlePriority);
	}
}
*/

#endif
void MyWidget::_buildCatalog(CATBUILDMODE mode,uint browserid)
{
	if(updateSuccessTimer)
		return;

	qDebug("Current cpu usage:%d",tz::GetCpuUsage());
	if(mode==CAT_BUILDMODE_ALL&&tz::GetCpuUsage()>CPU_USAGE_THRESHOLD)
	{
	/*
		int time = gSettings->value("catalogBuilderTimer", CATALOG_BUILDER_INTERVAL).toInt();
		if (time != 0)
			catalogBuilderTimer->start(time * CATALOG_BUILDER_INTERVAL_UNIT);//minutes
	*/
			return;
	}

	if (gBuilder == NULL)
	{

		gBuilder.reset(new CatBuilder(true,mode,&db));
		// gBuilder->setPreviousCatalog(catalog);
		switch(mode){
			case CAT_BUILDMODE_ALL:
				gSettings->setValue("lastscan", 0);//just for exception
			break;
			case CAT_BUILDMODE_DIRECTORY:
			break;
			case CAT_BUILDMODE_BOOKMARK:
			break;
			case CAT_BUILDMODE_COMMAND:
			break;
			case CAT_BUILDMODE_IMPORT_NETBOOKMARK:
				gBuilder->browserid = browserid;
	//		connect(gBuilder.get(), SIGNAL(importNetBookmarkFinishedSignal(int)), this, SLOT(importNetBookmarkFinished(int)));
			break;
#ifdef CONFIG_AUTO_LEARN_PROCESS
			case CAT_BUILDMODE_LEARN_PROCESS:
				gBuilder->clean =gSettings->value("ckAutoLearnProcess",true).toBool()?( ((learnProcessTimes++)&0x0f)?1:2):(0);
			break;
#endif			
		
		}
		connect(gBuilder.get(), SIGNAL(catalogFinished(int,int)), this, SLOT(catalogBuilt(int,int)));
		//  connect(this, SIGNAL(catalogTerminateNotify()), gBuilder.get(), SLOT(quit()));
		gBuilder->start(QThread::IdlePriority);
	}
}
void MyWidget::buildCatalog()
{
#ifdef CONFIG_ACTION_LIST
	struct ACTION_LIST item;
	item.action = ACTION_LIST_CATALOGBUILD;
	item.id.mode = CAT_BUILDMODE_ALL;
	addToActionList(item);
#else
	_buildCatalog(CAT_BUILDMODE_ALL);
#endif
}

void MyWidget::stopSync()
{
	if(gSyncer){
		qDebug("stop sync %s currentThread id=0x%08x",__FUNCTION__,QThread::currentThreadId());
		gSyncer->setTerminateFlag(1);	
	}

}
void MyWidget::reSync()
{

#ifdef CONFIG_ACTION_LIST
//	qDebug("%s %d gSyncer=0x%08x syncDlg=0x%08x mode=%d syncMode=%d",__FUNCTION__,__LINE__,SHAREPTRPRINT(gSyncer),SHAREPTRPRINT(syncDlg),mode,syncMode);
	struct ACTION_LIST item;
	switch(syncMode)
	{
	case SYNC_MODE_BOOKMARK:
	case SYNC_MODE_REBOOKMARK:
		item.action =ACTION_LIST_BOOKMARK_SYNC;
		break;
	case SYNC_MODE_TESTACCOUNT:
		item.action =ACTION_LIST_TEST_ACCOUNT;			
		break;
	}
	item.id.mode = SYN_MODE_NOSILENCE;
	addToActionList(item);
#else
	int mode;
	switch(syncMode)
	{
	case SYNC_MODE_BOOKMARK:
	case SYNC_MODE_REBOOKMARK:
		mode=SYNC_MODE_REBOOKMARK;
		break;
	case SYNC_MODE_TESTACCOUNT:
		mode=SYNC_MODE_TESTACCOUNT;			
		break;
	}
	_startSync(mode,SYN_MODE_NOSILENCE);		
#endif
}
void MyWidget::startSync()
{
#ifdef CONFIG_ACTION_LIST
	struct ACTION_LIST item;
	item.action = ACTION_LIST_BOOKMARK_SYNC;
	item.id.mode = SYN_MODE_NOSILENCE;
	addToActionList(item);
#else
	_startSync(SYNC_MODE_BOOKMARK,SYN_MODE_NOSILENCE);
#endif
}

void MyWidget::_startSync(int mode,int silence)      
{
	QString localBmFullPath;
	QString url;
	QString auth_encrypt_str;
	uint key;
	QString name,password;
	//qDebug("%s currentThread id=0x%08x",__FUNCTION__,QThread::currentThread());
	if(updateSuccessTimer)
		goto SYNCOUT;
	//start to all browser is disable ,don't sync
	struct browserinfo* browserInfo =tz::getbrowserInfo();
	int i = 0,browsers_enable=0;
	while(!browserInfo[i].name.isEmpty())
	{
		browsers_enable|=(browserInfo[i].enable?1:0);
		i++;
	}
	if(!browsers_enable)
	{
		goto	SYNCOUT;
	}
	//end to all browser is disable ,don't sync
	if((silence!=SYN_MODE_NOSILENCE)&&tz::GetCpuUsage()>CPU_USAGE_THRESHOLD)
	{
		goto	SYNCOUT;
	}
	
	syncMode = mode;

	//qDebug()<<__FUNCTION__<<__LINE__<<"mode:"<<mode<<"silent:"<<silence;
	//qDebug("%s %d gSyncer=0x%08x syncDlg=0x%08x mode=%d syncMode=%d",__FUNCTION__,__LINE__,SHAREPTRPRINT(gSyncer),SHAREPTRPRINT(syncDlg),mode,syncMode);
	switch(mode)
	{
	case SYNC_MODE_BOOKMARK:
	case SYNC_MODE_REBOOKMARK:
		name=gSettings->value("Account/Username","").toString();
		password=tz::decrypt(gSettings->value("Account/Userpasswd","").toString(),PASSWORD_ENCRYPT_KEY);					
		break;
	case SYNC_MODE_TESTACCOUNT:
		name=testAccountName;
		password=testAccountPassword;
		break;
	}
	if(name.isEmpty()||password.isEmpty())
		goto	SYNCOUT;
	if(gSyncer){
		if((silence ==SYN_MODE_NOSILENCE)&&syncDlg)
		{
			syncDlg->setModal(1);
			syncDlg->show();
		}
		return;
	}

	//deleteSynDlgTimer();
	if(!syncDlg)
	{
		syncDlg.reset(new synchronizeDlg(this));
		connect(syncDlg.get(),SIGNAL(reSyncNotify()),this,SLOT(reSync()));
		connect(syncDlg.get(),SIGNAL(stopSyncNotify()),this,SLOT(stopSync()));
	}else{
		syncDlg->status=HTTP_UNCONNECTED;
	}
	if(silence == SYN_MODE_NOSILENCE)
	{
		syncDlg->setModal(1);
		syncDlg->show();
	}else{
		syncDlg->hide();
	}
	switch(mode)
	{
	case SYNC_MODE_BOOKMARK:
	case SYNC_MODE_REBOOKMARK:
		gSyncer.reset(new bmSync(this,gSettings,&db,&gSemaphore,BOOKMARK_SYNC_MODE));
		break;
	case SYNC_MODE_TESTACCOUNT:
		gSyncer.reset(new bmSync(this,gSettings,&db,&gSemaphore,BOOKMARK_TESTACCOUNT_MODE));
		break;
	}

	connect(gSyncer.get(), SIGNAL(bmSyncFinishedStatusNotify(int)), this, SLOT(bmSyncFinishedStatus(int)));
	connect(gSyncer.get(), SIGNAL(finished()), this, SLOT(bmSyncerFinished()));
	connect(gSyncer.get(), SIGNAL(updateStatusNotify(int,int)), syncDlg.get(), SLOT(updateStatus(int,int)));
	connect(gSyncer.get(), SIGNAL(readDateProgressNotify(int, int)), syncDlg.get(), SLOT(readDateProgress(int, int)));
	connect(gSyncer.get(), SIGNAL(testAccountFinishedNotify(bool,QString)), this, SLOT(testAccountFinished(bool,QString)));

	syncAction->setDisabled(TRUE);
#ifdef CONFIG_SERVER_IP_SETTING
	SET_HOST_IP(gSettings,gSyncer);
#else
	gSyncer->setHost(BM_SERVER_ADDRESS);
#endif

	qsrand((unsigned) NOW_SECONDS);
	key=qrand()%(getkeylength());
	auth_encrypt_str=tz::encrypt(QString("username=%1 password=%2").arg(name).arg(password),key);

	switch(mode)
	{
	case SYNC_MODE_BOOKMARK:
	case SYNC_MODE_REBOOKMARK:
		gSyncer->setUsername(name);
		gSyncer->setPassword(password);
		if (			
			getUserLocalFullpath(gSettings,QString(LOCAL_BM_SETTING_FILE_NAME),localBmFullPath)
			&&QFile::exists(localBmFullPath)
		)
		{
			
			QFile f(localBmFullPath);
			if(f.open(QIODevice::ReadOnly)){
				bmXml r(&f,gSettings);
				r.getUserId();
				f.close();
				if(r.userId!=qhashEx(name,name.length()))
				{
					//if the userid don't arrocrding with userid in localbm
					gSettings->setValue("localbmkey",0);
					gSettings->sync();
				}
			}
			QString filemd5 = tz::fileMd5(localBmFullPath);
			if((silence != SYN_MODE_NOSILENCE)&&(qhashEx(filemd5,filemd5.length())==gSettings->value("localbmkey",0).toUInt()))
				url=QString(BM_SERVER_GET_BMXML_URL).arg(auth_encrypt_str).arg(key).arg(gSettings->value("updateTime","0").toString());	
			else
				url=QString(BM_SERVER_GET_BMXML_URL).arg(auth_encrypt_str).arg(key).arg(0);
		}else{
			url=QString(BM_SERVER_GET_BMXML_URL).arg(auth_encrypt_str).arg(key).arg(0);
		}
		break;
	case SYNC_MODE_TESTACCOUNT:
		url=QString(BM_SERVER_TESTACCOUNT_URL).arg(auth_encrypt_str).arg(key);
		gSyncer->setUsername(testAccountName);
		gSyncer->setPassword(testAccountPassword);
		break;
	}
#ifdef CONFIG_SERVER_IP_SETTING
//	QString serverIp = gSettings->value("serverip","" ).toString();
//	if( !serverIp.isEmpty())
//		url.replace(BM_SERVER_ADDRESS,serverIp);
	SET_SERVER_IP(gSettings,url);
#endif
	gSyncer->setUrl(url);
	gSyncer->start(QThread::IdlePriority);
	gSettings->setValue("lastsyncstatus",SYNC_STATUS_PROCESSING);
	//gSettings->setValue("lastsynctime", NOW_SECONDS);
	gSettings->sync();
	return;
SYNCOUT:
	SAVE_TIMER_ACTION(TIMER_ACTION_BMSYNC,"bmsync",FALSE);
#if 0	
	int time = gSettings->value("synctimer", SILENT_SYNC_INTERVAL).toInt();
	if (time != 0)
		syncTimer->start(time * SILENT_SYNC_INTERVAL_UNIT);
#endif
	return;
	
}
void MyWidget::bmSyncFinishedStatus(int status)
{
	if(!trayIcon->isVisible()) return;
	char *statusStr = tz::getstatusstring(status);
	switch(status){
		case BM_SYNC_SUCCESS_NO_ACTION:
			setIcon(1,tz::tr(statusStr));			
			break;
		case BM_SYNC_SUCCESS_WITH_ACTION:
			setIcon(1,tz::tr(statusStr));
			trayIcon->showMessage(APP_NAME,tz::tr(statusStr), QSystemTrayIcon::Information);
			break;
		case BM_SYNC_FAIL:
			break;
		case BM_SYNC_FAIL_SERVER_NET_ERROR:
		case BM_SYNC_FAIL_SERVER_REFUSE:
		case BM_SYNC_FAIL_SERVER_BMXML_FAIL:
		case BM_SYNC_FAIL_BMXML_TIMEOUT:
		case BM_SYNC_FAIL_MERGE_ERROR:
		case BM_SYNC_FAIL_PROXY_ERROR:
		case BM_SYNC_FAIL_PROXY_AUTH_ERROR:
		case BM_SYNC_FAIL_SERVER_LOGIN:
			setIcon(0,tz::tr(statusStr));
			break;
		case BM_SYNC_FAIL_SERVER_TESTACCOUNT_FAIL:
			break;		
	}	
}

void MyWidget::testAccountFinished(bool err,QString result)
{
	qDebug("%s %d error=%d syncDlg=0x%08x result=%s",__FUNCTION__,__LINE__,err,SHAREPTRPRINT(syncDlg),qPrintable(result));
	if (!err&&syncDlg)
	{
		if(result==DOSUCCESSS)
		{
			syncDlg->updateStatus(UPDATESTATUS_FLAG_APPLY,HTTP_TEST_ACCOUNT_SUCCESS) ;
			//createSynDlgTimer();
		}
		else
			syncDlg->updateStatus(UPDATESTATUS_FLAG_RETRY,HTTP_TEST_ACCOUNT_FAIL) ;

	}
}

void MyWidget::testAccount(const QString& name,const QString& password)
{
	testAccountName=name;
	testAccountPassword=password;
#ifdef CONFIG_ACTION_LIST
	struct ACTION_LIST item;
	item.action = ACTION_LIST_TEST_ACCOUNT;
	item.id.mode = SYN_MODE_NOSILENCE;
	addToActionList(item);
#else
	_startSync(SYNC_MODE_TESTACCOUNT,SYN_MODE_NOSILENCE);
#endif
	return;
}
void MyWidget::monitorTimerTimeout()
{	
	for(int i = 0 ; i < TIMER_ACTION_MAX; i++ ){
		if(!(timer_actionlist[i].enable&0x01))//enable ?
			continue;
		//if((((uint)(NOW_SECONDS-timer_actionlist[i].lastActionSeconds)) <(2*timer_actionlist[i].interval))&&(timer_actionlist[i].enable&0x02))//in queue?
		if((timer_actionlist[i].enable&0x02))//in queue?			
			continue;
	
		if(!(rebuildAll&(1<<i))){
			
			if(((uint)(NOW_SECONDS-runseconds)) < timer_actionlist[i].startAfterRun)
				continue;
			if(((uint)(NOW_SECONDS-timer_actionlist[i].lastActionSeconds)) < (((timer_actionlist[i].faileds>=10)?(10+2):(timer_actionlist[i].faileds+2))*(timer_actionlist[i].interval)/2))
				continue;
		}
		timer_actionlist[i].enable|=0x02 ;//in queue
		switch(i){
			case TIMER_ACTION_BMSYNC:
				{
					struct ACTION_LIST item;
					item.action = ACTION_LIST_BOOKMARK_SYNC;
					item.id.mode = SYN_MODE_SILENCE;
					addToActionList(item);
				}
			break;
			case TIMER_ACTION_CATBUILDER:
				buildCatalog();				
			break;
			case TIMER_ACTION_AUTOLEARNPROCESS:
				{
					struct ACTION_LIST item;
					item.action = ACTION_LIST_CATALOGBUILD;
					item.id.mode = CAT_BUILDMODE_LEARN_PROCESS;
					addToActionList(item);
				}
			break;
			case TIMER_ACTION_DIGGXML:
				{
					struct ACTION_LIST item;
					item.action = ACTION_LIST_GET_DIGG_XML;
					addToActionList(item);
				}
			break;
			case TIMER_ACTION_SILENTUPDATER:
				startSilentUpdate();
			break;
		}

		
	}
	
	STOP_TIMER(monitorTimer);
	//processing ........
#ifdef CONFIG_ACTION_LIST
	struct ACTION_LIST item;
	if(!closeflag&&!gBuilder&&!gSyncer&&!updateSuccessTimer&&getFromActionList(item)){
		qDebug()<<item.action<<item.fullpath<<item.name<<item.id.browserid;
		switch(item.action){
			case ACTION_LIST_CATALOGBUILD:
				_buildCatalog((CATBUILDMODE)item.id.mode,0);
				break;
			case ACTION_LIST_BOOKMARK_SYNC:
				_startSync(SYNC_MODE_BOOKMARK,item.id.mode);
				break;
			case ACTION_LIST_TEST_ACCOUNT:
				_startSync(SYNC_MODE_TESTACCOUNT,item.id.mode);
				break;
			case ACTION_LIST_IMPORT_BOOKMARK:
				//importNetBookmark(CAT_BUILDMODE_IMPORT_NETBOOKMARK,item.id.browserid);
				_buildCatalog(CAT_BUILDMODE_IMPORT_NETBOOKMARK,item.id.browserid);
				break;
			case ACTION_LIST_ADD_NETBOOKMARK_DIR:
				{
					uint showgroupId = 0;
					CatItem t("",item.name,"",COME_FROM_MYBOOKMARK);	
					t.parentId = item.id.groupid;
					t.type = 1;
					showgroupId=t.groupId=tz::getNetBookmarkMaxGroupid(&db);			
					CatItem::addCatitemToDb(&db,t);
				}
				break;
			case ACTION_LIST_MODIFY_NETBOOKMARK_DIR:
				{
					uint showgroupId = 0;
					CatItem t("",item.name,"",COME_FROM_MYBOOKMARK);		
					unsigned int bmid = tz::getBmidFromGroupId(&db, item.id.groupid);
					if(bmid){
						t.parentId = tz::getBmParentId(&db,bmid);
						t.type = 1;
						showgroupId=t.groupId =  item.id.groupid;;
						CatItem::modifyCatitemFromDb(&db,t,bmid);
					}
				}
				break;
			case ACTION_LIST_DELETE_NETBOOKMARK_DIR:
				{
					uint showgroupId = 0;
					uint bmid = tz::getBmidFromGroupId(&db,item.id.groupid);
					if(bmid){
						showgroupId= tz::getBmParentId(&db,bmid);
					}
					tz::deleteNetworkBookmark(&db,item.id.groupid);
				}
				break;
			case ACTION_LIST_ADD_NETBOOKMARK_ITEM:
				{
					uint showgroupId = 0;
					CatItem t(item.fullpath,item.name,"",COME_FROM_MYBOOKMARK);	
					showgroupId=t.parentId = item.id.groupid;
					t.type = 0;	
					CatItem::addCatitemToDb(&db,t);
				}
				break;
			case ACTION_LIST_MODIFY_NETBOOKMARK_ITEM:
				{
					uint showgroupId = 0;
					CatItem t(item.fullpath,item.name,"",COME_FROM_MYBOOKMARK);	
					showgroupId = tz::getBmParentId(&db,item.id.bmid);
					CatItem::modifyCatitemFromDb(&db,t,item.id.bmid);
				}
				break;
			case ACTION_LIST_DELETE_NETBOOKMARK_ITEM:
				{
					uint showgroupId = 0;
					CatItem t(item.fullpath,item.name,"",COME_FROM_MYBOOKMARK);	
					showgroupId = tz::getBmParentId(&db,item.id.bmid);
					CatItem::deleteCatitemFromDb(&db,t,item.id.bmid);
				}
				break;
#ifdef CONFIG_DIGG_XML
			case ACTION_LIST_GET_DIGG_XML:
				{
					startDiggXml();
				}
				break;
#endif
			default:
				break;
		}

	}
#endif
	if(syncDlg){
		//qDebug()<<__FUNCTION__<<syncDlg;
		switch(syncDlg->result())
		{
		case QDialog::Accepted:				
		case QDialog::Rejected:
			DELETE_SHAREOBJ(syncDlg);
			break;
		default:
			if(syncDlg->status==UPDATE_SUCCESSFUL||syncDlg->status==HTTP_TEST_ACCOUNT_SUCCESS||syncDlg->status==BM_SYNC_SUCCESS_NO_ACTION)
			{
				if((NOW_SECONDS-syncDlg->statusTime)>10)
				{
					DELETE_SHAREOBJ(syncDlg);
				}
			}
			break;
		}		

	}
	//clear user directory	
	monitorTimer->start(MONITER_TIME_INTERVAL);
}
#ifdef CONFIG_DIGG_XML
void MyWidget::diggXmlFinished(int status)
{
	gDiggXmler->wait();								
	gDiggXmler.reset();
	SAVE_TIMER_ACTION(TIMER_ACTION_DIGGXML,"diggxml",status);
}
void MyWidget::startDiggXml()
{
	if(gDiggXmler)
		return;
	gDiggXmler.reset(new diggXml(this,gSettings));
#ifdef CONFIG_SERVER_IP_SETTING
	SET_HOST_IP(gSettings,gDiggXmler);
#else
	gDiggXmler->setHost(BM_SERVER_ADDRESS);
#endif
	connect(gDiggXmler.get(), SIGNAL(diggXmlFinishedStatusNotify(int)), this, SLOT(diggXmlFinished(int)));
	QString url=QString(BM_SERVER_GET_DIGGXML_URL);

#ifdef CONFIG_SERVER_IP_SETTING
	SET_SERVER_IP(gSettings,url);
#endif
	gDiggXmler->setUrl(url);
	gDiggXmler->start(QThread::IdlePriority);

}
#endif
void MyWidget::bmSyncerFinished()
{	
	//QDEBUG_LINE;
	if(gSyncer->terminateFlag)
	{
		DELETE_SHAREOBJ(syncDlg);
	}
	if(syncDlg&&syncDlg->isHidden()){
		DELETE_SHAREOBJ(syncDlg);
	}
	gSyncer->wait();								
	gSyncer.reset();
	//qDebug()<<__FUNCTION__<<"release gSemaphore";
	gSemaphore.release(1);
	scanDbFavicon();
	syncAction->setDisabled(FALSE);
	if(closeflag)
		close();
	else{
		// timer_actionlist[TIMER_ACTION_BMSYNC].lastActionSeconds = NOW_SECONDS;
		// gSettings->setValue("lastbmsync", timer_actionlist[TIMER_ACTION_BMSYNC].lastActionSeconds);
		// timer_actionlist.enable &=(~(0x02)); 
		 SAVE_TIMER_ACTION(TIMER_ACTION_BMSYNC,"bmsync",TRUE);
		// rebuildAll&=~(1<<TIMER_ACTION_BMSYNC);		
#if 0		
		int time = gSettings->value("synctimer", SILENT_SYNC_INTERVAL).toInt();
		if (time != 0)
			syncTimer->start(time * SILENT_SYNC_INTERVAL_UNIT);			
#endif
	}
	
}

void MyWidget::menuOptions()
{
	if (optionsOpen == true && ops)
	{
		ops->activateWindow();
		return;
	}
	optionsOpen = true;
	ops = new OptionsDlg(this,gSettings,&db);
	connect(ops, SIGNAL(rebuildcatalogSignal()), this, SLOT(buildCatalog()));
	connect(ops, SIGNAL(optionStartSyncNotify()), this, SLOT(startSync()));
	connect(ops, SIGNAL(configModifyNotify(int)), this, SLOT(configModify(int)));
	connect(ops, SIGNAL(testAccountNotify(const QString&,const QString&)), this, SLOT(testAccount(const QString&,const QString&)));	

	ops->setModal(0);
	ops->setObjectName("options");
	ops->exec();
	DELETE_OBJECT(ops);
	freeOccupyMemeory();
}


void Fader::fadeIn()
{

	int time = gSettings->value("fadein", 0).toInt();
	double end = (double) gSettings->value("opaqueness", 100).toInt();
	end /= 100.0;
	if (time != 0)
	{
		double delay = ((double) time) / (end / 0.05);

		for (double i = 0.0; i < end + 0.01 && keepRunning; i += 0.05)
		{
			emit fadeLevel(i);
			//                      qApp->syncX();
			msleep(delay);
		}
	}
	emit fadeLevel(end);
	emit finishedFade(end);
	return;
}

void Fader::fadeOut()
{
	int time = gSettings->value("fadeout", 0).toInt();

	if (time != 0)
	{
		double start = (double) gSettings->value("opaqueness", 100).toInt();
		start /= 100.0;
		double delay = ((double) time) / (start / 0.05);


		for (double i = start; i > -0.01 && keepRunning; i -= 0.05)
		{
			emit fadeLevel(i);
			msleep(delay);
		}
	}
	emit fadeLevel(0.0);
	emit finishedFade(0.0);

	return;
}

void Fader::run()
{
	keepRunning = true;
	if (fadeType)
		fadeIn();
	else
		fadeOut();
}

void MyWidget::setFadeLevel(double d)
{
	this->setWindowOpacity(d);
	platform->SetAlphaOpacity(d);
}

void MyWidget::finishedFade(double d)
{
	if (d == 0.0)
	{
		hide();
		platform->HideAlphaBorder();
	}
}

void MyWidget::fadeIn()
{
	if (fader->isRunning())
		fader->stop();
	while (fader->isRunning())
	{
	}
	fader->setFadeType(true);
	fader->start();
}

void MyWidget::fadeOut()
{
	if (fader->isRunning())
		fader->stop();
	while (fader->isRunning())
	{
	}
	fader->setFadeType(false);
	fader->start();
}



void MyWidget::showLaunchy(bool now)
{
	//shouldDonate();
	alternatives->hide();



	// This gets around the weird Vista bug
	// where the alpha border would dissappear
	// on sleep or user switch

	move(loadPosition(0));
#ifdef Q_WS_WIN
	platform->CreateAlphaBorder(this, "");
	connectAlpha();
#endif
	platform->MoveAlphaBorder(pos());

	setFadeLevel(0.0);

	platform->ShowAlphaBorder();
	this->show();

	if (!now)
	{
		fadeIn();
	} else
	{
		double end = (double) gSettings->value("opaqueness", 100).toInt();
		end /= 100.0;
		setFadeLevel(end);
	}

	// Terrible hack to steal focus from other apps when using splashscreen

#ifdef Q_WS_X11
	for (int i = 0; i < 100; i++)
	{
		activateWindow();
		raise();
		qApp->syncX();
	}
#endif

	qApp->syncX();
	input->activateWindow();
	input->raise();
	input->selectAll();
	input->setFocus();
	qApp->syncX();
	// Let the plugins know
//	plugins.showLaunchy();
}



void MyWidget::hideLaunchy(bool now)
{
	if (!isVisible())
		return;
	savePosition();
	if (dropTimer != NULL && dropTimer->isActive())
		dropTimer->stop();
	if (alwaysShowLaunchy)
		return;

	if (alternatives != NULL)
		alternatives->hide();

	if (isVisible())
	{
		if (!now)
			fadeOut();
		else
		{
			setFadeLevel(0.0);
			finishedFade(0.0);
		}
	}
	// let the plugins know
//	plugins.hideLaunchy();
	freeOccupyMemeory();
}


QChar MyWidget::sepChar()
{
	QFontMetrics met = input->fontMetrics();
	QChar arrow(0x25ba);
	if (met.inFont(arrow))
		return arrow;
	else
		return QChar('|');
}

void MyWidget::updateApp()
{

	/*
	QProcess updatePrc;
	updatePrc.start("updater.exe"); 
	qDebug("update process start!");
	if(updatePrc.waitForFinished ())
	{
	qDebug("update process finished!");
	QDir dir(".");
	if(dir.exists(UPDATE_DIRECTORY))
	{

	QFile file("out.txt");
	if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
	return;
	QTextStream out(&file);
	out << 1 << "\n";
	qDebug("set General/updater as 1");
	if (!platform->Execute("newer.exe", ""))
	runProgram("newer.exe", "");
	close();
	}
	}
	*/
}
void MyWidget::createActions()
{
	/*
	minimizeAction = new QAction(tr("Mi&nimize"), this);
	connect(minimizeAction, SIGNAL(triggered()), this, SLOT(hide()));
	*/

	rebuildCatalogAction = new QAction(tr("Rebuild Catalog"), this);
	connect(rebuildCatalogAction, SIGNAL(triggered()), this, SLOT(buildCatalog()));
	optionsAction = new QAction(tr("Options"), this);
	connect(optionsAction, SIGNAL(triggered()), this, SLOT(menuOptions()));
	restoreAction = new QAction(tr("&Restore"), this);
	connect(restoreAction, SIGNAL(triggered()), this, SLOT(onHotKey()));
	syncAction = new QAction(tr("&Sync"), this);
	connect(syncAction, SIGNAL(triggered()), this, SLOT(startSync()));
	updateAction = new QAction(tr("&Update"), this);
	connect(updateAction, SIGNAL(triggered()), this, SLOT(updateApp()));
	quitAction = new QAction(tr("&Quit"), this);
	connect(quitAction, SIGNAL(triggered()), this, SLOT(close()));
}

void MyWidget::createTrayIcon()
{
	trayIconMenu = new QMenu(this);
	//trayIconMenu->addAction(minimizeAction);
	trayIconMenu->addAction(rebuildCatalogAction);
	trayIconMenu->addAction(optionsAction);
	trayIconMenu->addAction(restoreAction);
	trayIconMenu->addAction(syncAction);
	trayIconMenu->addAction(updateAction);
	trayIconMenu->addSeparator();
	trayIconMenu->addAction(quitAction);

	trayIcon = new QSystemTrayIcon(this);
	trayIcon->setContextMenu(trayIconMenu);
}

void MyWidget::setIcon(int type,const QString& tip)
{
	switch(type){
		case 0:
			trayIcon->setIcon(icon_problem);
		break;
		default:
			trayIcon->setIcon(icon);
		break;
	}	
	QString tips = tip;
	tips.append("\n");
	tips.append(tz::tr("shortkey"));
	tips.append(":");
	tips.append(shortkeyString);
	trayIcon->setToolTip(tips);
}

void MyWidget::iconActivated(QSystemTrayIcon::ActivationReason reason)
{
	qDebug()<<__FUNCTION__<<reason;
	switch (reason)
	{
	case QSystemTrayIcon::Trigger:
	case QSystemTrayIcon::DoubleClick:
		activateWindow();
		if (!isVisible())
			showLaunchy();
		
		break;
	case QSystemTrayIcon::MiddleClick:
		break;
	case QSystemTrayIcon::Context:
		this->trayIcon->contextMenu();
		break;
	default:
		;
	}
}
void MyWidget::freeOccupyMemeory()
{
	//#ifdef CONFIG_LOG_ENABLE
	//#else
	QDialog dlg;
	
	dlg.setWindowFlags(Qt::SplashScreen|Qt::FramelessWindowHint);
	dlg.resize(0,0);
	dlg.show();	
	dlg.showMinimized();		
	dlg.accept();
	//#endif
}
void MyWidget::silentUpdateFinished()
{
	//QDEBUG_LINE;
	//qDebug("slientUpdate=0x%08x,isFinished=%d",slientUpdate,(slientUpdate)?slientUpdate->isFinished():0);
	//qDebug("silent update finished!!!!!");
	//qDebug("%s %d currentthreadid=0x%08x this=0x%08x",__FUNCTION__,__LINE__,QThread::currentThread(),this);
	SAVE_TIMER_ACTION(TIMER_ACTION_SILENTUPDATER,"silentupdate",TRUE);
	DELETE_OBJECT(slientUpdate);
	/*
	if(slientUpdate)
	{
	
		if(slientUpdate->error==0)///no error
			{
				 //timer_actionlist[TIMER_ACTION_SILENTUPDATER].lastActionSeconds = NOW_SECONDS;
				 //gSettings->setValue("lastsilentupdate", timer_actionlist[TIMER_ACTION_SILENTUPDATER].lastActionSeconds);
				 
			}
			
		DELETE_OBJECT(slientUpdate);	
	}
	*/
	if(closeflag)
		close();
	else{
#ifdef QT_NO_DEBUG
			
#else		
		//silentupdateTimer->start(100*SECONDS);	
#endif	
	}
}
void MyWidget::startSilentUpdate()
{
	QDEBUG_LINE;
	//qDebug("%s %d currentthreadid=0x%08x this=0x%08x",__FUNCTION__,__LINE__,QThread::currentThread(),this);
	if(tz::GetCpuUsage()>CPU_USAGE_THRESHOLD)
		return;

	//qDebug("slientUpdate=0x%08x,isFinished=%d",slientUpdate,(slientUpdate)?slientUpdate->isFinished():0);
	if(!slientUpdate||slientUpdate->isFinished()){
		slientUpdate=new appUpdater(this,gSettings,UPDATE_SILENT_MODE); 
		connect(slientUpdate,SIGNAL(finished()),this,SLOT(silentUpdateFinished()));		
		//connect(this,SIGNAL(silentUpdateTerminateNotify()),slientUpdate,SLOT(terminateThread()));
		slientUpdate->start(QThread::IdlePriority);		
	}
}
void MyWidget::getFavicoFinished()
{
	//qDebug("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
	qDebug("%s %d currentthreadid=0x%08x this=0x%08x",__FUNCTION__,__LINE__,QThread::currentThread(),this);
	int i =getfavicolist.size();
	while((--i)>=0){
		GetFileHttp* icogh = getfavicolist.at(i);
		if(icogh->isFinished())
		{
			getfavicolist.removeOne(icogh);
			delete icogh;
		}
	}
}

void MyWidget::getFavico(const QString& host,const QString& filename)
{
	//qDebug("%s %d currentthreadid=0x%08x this=0x%08x",__FUNCTION__,__LINE__,QThread::currentThread(),this);
	GetFileHttp* icogh =  new GetFileHttp(NULL,gSettings,UPDATE_MODE_GET_FILE,"");
	getfavicolist.append(icogh);
	qDebug()<<__FUNCTION__<<"get fav ico from"<<host;
	connect(icogh,SIGNAL(finished()),this,SLOT(getFavicoFinished()));
	icogh->setHost(host);
	icogh->setUrl(filename);

	icogh->setDestdir(FAVICO_DIRECTORY);
	QString extension = filename.section( '.', -1 );
	if(extension.isEmpty())
		icogh->setSaveFilename(QString("%1").arg(qhashEx(host,host.length())));
	else
		icogh->setSaveFilename(QString("%1.%2").arg(qhashEx(host,host.length())).arg(extension));
	icogh->start(QThread::IdlePriority);
}
void MyWidget::scanDbFavicon()
{
	QSqlQuery	q("", db);
	QString s=QString("SELECT fullPath FROM %1 ").arg(DBTABLEINFO_NAME(COME_FROM_BROWSER));
	if(q.exec(s)){
		//getFavico("www.sohu.com","favicon.ico");
		while(q.next()) {
			QString fullPath = q.value(q.record().indexOf("fullPath")).toString();		
			if(fullPath.startsWith("http",Qt::CaseInsensitive)||fullPath.startsWith("https",Qt::CaseInsensitive))
			{
				QUrl url(fullPath);									
				if(url.isValid()){
					QString host = url.host();
					if(!QFile::exists(QString(FAVICO_DIRECTORY"/%1.ico").arg(qhashEx(host,host.length()))))
						getFavico(host,"favicon.ico");
				}
			}
		}
	}	
	q.clear();
}


#ifdef CONFIG_LOG_ENABLE
void MyWidget::dumpBuffer(char* addr,int length)
{
	int i=0;
	for(i=0;i<length;i++)
	{
		//if(i&&!(i%8))QDEBUG("\n");
		qDebug()<<(addr[i]&0xff);
		//if(i&&((i&0x7)==0x7)) QDEBUG("\n");
	}
	qDebug("\n");
}

#endif

#ifdef CONFIG_LOG_ENABLE
void myMessageOutput(QtMsgType type, const char *msg)
{
	switch (type) {
	 case QtDebugMsg:
		 {
			 if(gSettings){
				 gSettings->sync();
				 if((gSettings->value("debug",0).toUInt())&0x01)			
					 fprintf(stderr, "Debug: %s\n", msg);

				 if((gSettings->value("debug",0).toUInt())&0x02)
				 {
					 QFile debugfile("log.txt");
					 debugfile.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Append);
					 QTextStream debugos(&debugfile);
					 debugos.setCodec("UTF-8");
					 QString msgstr=QString::fromLocal8Bit(msg);
					 debugos << "[";
					 debugos << QDateTime::currentDateTime().toString("hh:mm:ss");
					 debugos << "] " << msgstr << "\n";
					 debugfile.close();
				 }
			 }
		 }
		 break;
	 case QtWarningMsg:
		 fprintf(stderr, "Warning: %s\n", msg);
		 break;
	 case QtCriticalMsg:
		 fprintf(stderr, "Critical: %s\n", msg);
		 break;
	 case QtFatalMsg:
		 fprintf(stderr, "Fatal: %s\n", msg);
		 abort();
	}
}
#endif
void kickoffSilentUpdate()
{
	if(QFile::exists(APP_SILENT_UPDATE_NAME))
	{
		qDebug("run %s",APP_SILENT_UPDATE_NAME);
		runProgram(QString(APP_SILENT_UPDATE_NAME),QString("-r"));
		exit(0);
	}
}
/*
bool CatLessNoPtr(CatItem & a, CatItem & b)
{
return CatLess(&a,&b);
}
*/
int itempriority(int comefrom)
{
	//COME_FROM_SHORTCUT>COME_FROM_COMMAND>COMF_FROM_NETBOOKMARK(COME_FROM_IE,COME_FROM_FIREFOX)>COME_FROM_PREDEFINE>COME_FROM_PROGRAM
	
	int priority = 0;
	switch(comefrom)
	{
		case COME_FROM_SHORTCUT:
			return priority;
		break;
		case COME_FROM_COMMAND:
			return priority+1;
		break;
		case COME_FROM_NETBOOKMARK:
		case COME_FROM_IE:
		case COME_FROM_FIREFOX:
		case COME_FROM_OPERA:
			return priority+2;
		break;
		case COME_FROM_PREDEFINE:
			return priority+3;
		break;
		case COME_FROM_PROGRAM:
			return priority+4;
		break;
		default:
			return priority+5;
		break;
	}
	return priority;
}
bool CatLess(CatItem * a, CatItem * b)
{
	/*
	if (a->isHistory) { return true; }
	if (b->isHistory) { return false; }
	*/
	bool localEqual = a->lowName == gSearchTxt;
	bool otherEqual = b->lowName == gSearchTxt;

	if (localEqual && !otherEqual)
		return true;
	if (!localEqual && otherEqual)
		return false;


	if (a->usage > b->usage)
		return true;
	if (a->usage < b->usage)
		return false;
	if(a->isHasPinyin&&b->isHasPinyin)
	{
		if(a->pos<b->pos)
			return true; 
	}
	if(itempriority(a->comeFrom)<itempriority(b->comeFrom))
		return true;
	if(itempriority(a->comeFrom)>itempriority(b->comeFrom))
		return false;

	int localFind = a->lowName.indexOf(gSearchTxt);
	int otherFind = b->lowName.indexOf(gSearchTxt);

	if (localFind != -1 && otherFind == -1)
		return true;
	else if (localFind == -1 && otherFind != -1)
		return false;

	if (localFind != -1 && otherFind != -1)
	{
		if (localFind < otherFind)
			return true;
		else if (otherFind < localFind)
			return false;
	}

	int localLen = a->lowName.count();
	int otherLen = b->lowName.count();

	if (localLen < otherLen)
		return true;
	if (localLen > otherLen)
		return false;
//priority from come from
//COME_FROM_SHORTCUT>COME_FROM_COMMAND>COMF_FROM_NETBOOKMARK(COME_FROM_IE,COME_FROM_FIREFOX)>COME_FROM_PREDEFINE>COME_FROM_PROGRAM


	// Absolute tiebreaker to prevent loops
	if (a->fullPath < b->fullPath)
		return true;
	return false;
}

int main(int argc, char *argv[])
{
#ifdef Q_WS_WIN
	shared_ptr < QApplication > app(new QApplication(argc, argv));
#endif
	PlatformBase *platform = loadPlatform();
#ifdef Q_WS_X11
	shared_ptr < QApplication > app(platform->init(argc, argv));
#endif

	QStringList args = qApp->arguments();
	app->setQuitOnLastWindowClosed(false);

	//HANDLE hProcessThis=GetCurrentProcess();
	//SetPriorityClass(hProcessThis,HIGH_PRIORITY_CLASS); 

	bool rescue = false;

	if (args.size() > 1)
		if (args[1] == "rescue")
		{
			rescue = true;
			// Kill all existing Launchy's
			//                      platform->KillLaunchys();
		}
		QTextCodec::setCodecForTr(QTextCodec::codecForName("UTF-8"));
		QTextCodec::setCodecForCStrings(QTextCodec::codecForName("UTF-8"));
		//check update in register
		if(tz::registerInt(REGISTER_GET_MODE,APP_HKEY_PATH,APP_HEKY_UPDATE_ITEM,0)&&QFile::exists(APP_SILENT_UPDATE_NAME)&&tz::checkSilentUpdateFiles())
		{
				runProgram(QString(APP_SILENT_UPDATE_NAME),QString("c0190ce05af9ce7cd818f50d794b8d11"));
				app.reset();
				exit(0);
		}
		QCoreApplication::setApplicationName(APP_NAME);
		QCoreApplication::setOrganizationDomain(APP_NAME);
#if 0
		QString locale = QLocale::system().name();

		QTranslator translator;
		translator.load(QString("tr/launchy_" + locale));
		app->installTranslator(&translator);
#endif
		if (!QSystemTrayIcon::isSystemTrayAvailable())
		{
			QMessageBox::critical(0, QObject::tr("Systray"), QObject::tr("I couldn't detect any system tray " "on this system."));
			return 1;
		}

		tz::GetCpuUsage();
		MyWidget widget(NULL, platform, rescue);
		widget.freeOccupyMemeory();
		app->exec();
}
