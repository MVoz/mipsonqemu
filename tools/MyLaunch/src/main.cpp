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

extern CatBuilder* gBuilder;
extern CatItem* gSearchResult;
extern bmSync* gSyncer;
extern shared_ptr < bmSync> gTestAccounter;
#ifdef CONFIG_DIGG_XML
extern bmSync* gDiggXmler;
#endif

enum{
	NET_SEARCH_GOOGLE=0,
	NET_SEARCH_BAIDU	
};

struct {
	QString name;
	QString fullpath;
	QString args;
	QString icon;
}netfinders[]={
	{QString("Google"),"http://www.google.com/","search?q=","./images/google_icon.png"},
	{QString("Baidu"),"http://www.baidu.com/","s?ie=utf-8&wd=","./images/baidu_icon.png"},	
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
		case NET_SEARCH_MODIFY:
#ifdef CONFIG_SKIN_FROM_RESOURCE		
		//QResource::registerResource("skins/default.rcc");
#endif

		if(!googleButton->isHidden()){
#ifdef CONFIG_SKIN_FROM_RESOURCE		
			//TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<QFile::exists(":/skins/Default/google.png")<<(QString(":/skins/Default").append(QString("/%1").arg(gSettings->value(QString("netfinder/").append(netfinders[NET_SEARCH_GOOGLE].name),true).toBool()?"google.png":"google_gray.png"))));
			  //googleButton->setStyleSheet("QToolButton { border: none; padding: 0px; }");->setIcon(QIcon(QPixmap(QString(":/skins/").append(QString("%1").arg(gSettings->value(QString("netfinder/").append(netfinders[NET_SEARCH_GOOGLE].name),true).toBool()?"google_on.png":"google_off.png")))));
			  googleButton->setStyleSheet(QString("QPushButton#googleButton{border: none;background: url(:/skins/%1);}\nQPushButton#googleButton:hover{border: none;background: url(:/skins/google_hover);}").arg(gSettings->value(QString("netfinder/").append(netfinders[NET_SEARCH_GOOGLE].name),true).toBool()?"google_on.png":"google_off.png"));
#else
			googleButton->setIcon(QIcon(QString(gSettings->value("skin", dirs["defSkin"][0]).toString()).append(QString("/%1").arg(gSettings->value(QString("netfinder/").append(netfinders[NET_SEARCH_GOOGLE].name),true).toBool()?"google.png":"google_gray.png"))));
#endif
			googleButton->repaint();
		}
		if(!baiduButton->isHidden()){
#ifdef CONFIG_SKIN_FROM_RESOURCE		
			 baiduButton->setStyleSheet(QString("QPushButton#baiduButton{border: none;background: url(:/skins/%1);}\nQPushButton#baiduButton:hover{border: none;background: url(:/skins/baidu_hover);}").arg(gSettings->value(QString("netfinder/").append(netfinders[NET_SEARCH_BAIDU].name),true).toBool()?"baidu_on.png":"baidu_off.png"));
			//baiduButton->setIcon(QIcon(QPixmap(QString(":/skins/").append(QString("%1").arg(gSettings->value(QString("netfinder/").append(netfinders[NET_SEARCH_BAIDU].name),true).toBool()?"baidu_on.png":"baidu_off.png")))));						
#else
			baiduButton->setIcon(QIcon(QString(gSettings->value("skin", dirs["defSkin"][0]).toString()).append(QString("/%1").arg(gSettings->value(QString("netfinder/").append(netfinders[NET_SEARCH_BAIDU].name),true).toBool()?"baidu.png":"baidu_gray.png"))));
#endif
			baiduButton->repaint();
		}
		updateDisplay();
#ifdef CONFIG_SKIN_FROM_RESOURCE		
		//QResource::unregisterResource("skins/default.rcc");
#endif

		break;
		case NET_ACCOUNT_MODIFY:
#ifdef CONFIG_SKIN_FROM_RESOURCE		
		//QResource::registerResource("skins/default.rcc");
#endif

		if(!syncButton->isHidden()){
#ifdef CONFIG_SKIN_FROM_RESOURCE		
		syncButton->setIcon(QIcon(QPixmap(QString(":/skins/Default").append(QString("/%1").arg(((!gSettings->value(QString("Account/Username"),"").toString().isEmpty()&&!gSettings->value(QString("Account/Userpasswd"),"").toString().isEmpty())?"sync.png":"sync_gray.png"))))));
#else
		syncButton->setIcon(QIcon(QString(gSettings->value("skin", dirs["defSkin"][0]).toString()).append(QString("/%1").arg(((!gSettings->value(QString("Account/Username"),"").toString().isEmpty()&&!gSettings->value(QString("Account/Userpasswd"),"").toString().isEmpty())?"sync.png":"sync_gray.png")))));
#endif
		syncButton->repaint();
		}
#ifdef CONFIG_SKIN_FROM_RESOURCE		
		//QResource::unregisterResource("skins/default.rcc");
#endif
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
					dst->setValue("shortName", Q_VALUE_STRING(q,"shortName"));
					dst->setValue("fullPath",Q_VALUE_STRING(q,"fullPath"));
					dst->setValue("args", Q_VALUE_STRING(q,"args"));
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
	syncDlg=NULL;
	tz::initParameterMib(gSettings);
	//inital language
	setLanguage(gSettings->value("language", DEFAULT_LANGUAGE).toInt()) ;
	shortkeyString=getShortkeyString();
	if (platform->isAlreadyRunning())
		{
			QString text=tz::tr("app_is_runing");
			text.replace("shortkey",shortkeyString);		
			QMessageBox::warning(this, tr(APP_NAME),text, QMessageBox::Ok,QMessageBox::Ok);
			exit(1);
			return;
		}
	gSemaphore.release(1);
	fader = new Fader(this);
	connect(fader, SIGNAL(fadeLevel(double)), this, SLOT(setFadeLevel(double)));
	connect(fader, SIGNAL(finishedFade(double)), this, SLOT(finishedFade(double)));

	gMainWidget = this;
	menuOpen = false;
//	optionsOpen = false;
	gSearchTxt = "";
	iconOnLabel="";
	pathOnoutput="";
	//syncDlgTimer=NULL;
	inputMode = 0;
	rebuildAll = 0;
	maincloseflag = 0;

	setFocusPolicy(Qt::ClickFocus);

	alwaysShowLaunchy = false;
	createActions();
	createTrayIcon();

	//      hideLaunchy();
	label = new QLabel(this);

	opsButton = new QPushButton(label);
	opsButton->setObjectName("opsButton");
	opsButton->setToolTip(tr(APP_NAME" Options"));
	opsButton->setFocusPolicy(Qt::NoFocus);
	connect(opsButton, SIGNAL(pressed()), this, SLOT(menuOptions()));

	homeButton = new QPushButton(label);
	homeButton->setObjectName("homeButton");
	homeButton->setToolTip(tr(APP_NAME" Home"));
	homeButton->setFocusPolicy(Qt::NoFocus);
	connect(homeButton, SIGNAL(pressed()), this, SLOT(homeBtnPressed()));
	
	userButton = new QPushButton(label);
	userButton->setObjectName("userButton");
	userButton->setToolTip(tr(APP_NAME" User"));
	userButton->setFocusPolicy(Qt::NoFocus);
	connect(userButton, SIGNAL(pressed()), this, SLOT(userBtnPressed()));
	
	syncButton = new QPushButton(label);
	syncButton->setObjectName("syncButton");
	syncButton->setToolTip(tr(APP_NAME" Sync"));
	syncButton->setFocusPolicy(Qt::NoFocus);
	connect(syncButton, SIGNAL(pressed()), this, SLOT(startSync()));

	baiduButton = new QPushButton(label);
	baiduButton->setObjectName("baiduButton");
	baiduButton->setToolTip(tr(APP_NAME" Baidu"));
	baiduButton->setFocusPolicy(Qt::NoFocus);
	connect(baiduButton, SIGNAL(pressed()), this, SLOT(baiduBtnPressed()));

	googleButton = new QPushButton(label);
	googleButton->setObjectName("googleButton");
	googleButton->setToolTip(tr(APP_NAME" Google"));
	googleButton->setFocusPolicy(Qt::NoFocus);
	connect(googleButton, SIGNAL(pressed()), this, SLOT(googleBtnPressed()));

	goButton = new QPushButton(label);
	goButton->setObjectName("goButton");
	goButton->setToolTip(tr(APP_NAME" Go"));
	goButton->setFocusPolicy(Qt::NoFocus);
	connect(goButton, SIGNAL(pressed()), this, SLOT(goBtnPressed()));

	minButton = new QPushButton(label);
	minButton->setObjectName("minButton");
	minButton->setToolTip(tr("Min "APP_NAME));
	connect(minButton, SIGNAL(pressed()), this, SLOT(minBtnPressed()));


	output = new QLineEditMenu(label);
	output->setAlignment(Qt::AlignHCenter);
	output->setReadOnly(true);
	output->setObjectName("output");
	output->setWordWrapMode(QTextOption::NoWrap);
	output->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff) ;
	output->setVerticalScrollBarPolicy ( Qt::ScrollBarAlwaysOff ) ; 
	connect(output, SIGNAL(menuEvent(QContextMenuEvent *)), this, SLOT(menuEvent(QContextMenuEvent *)));
#ifdef CONFIG_DIGG_XML
	diggxmloutput = new QTextBrowser(label);
	diggxmloutput->setAlignment(Qt::AlignRight);
	diggxmloutput->setReadOnly(true);
	diggxmloutput->setOpenLinks (false );
	diggxmloutput->setObjectName("diggxmloutput");
	diggxmloutput->setWordWrapMode(QTextOption::NoWrap);
	diggxmloutput->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff) ;
	diggxmloutput->setVerticalScrollBarPolicy ( Qt::ScrollBarAlwaysOff ) ; 
//	connect(diggxmloutput, SIGNAL(menuEvent(QContextMenuEvent *)), this, SLOT(menuEvent(QContextMenuEvent *)));
	connect(diggxmloutput, SIGNAL(anchorClicked(const QUrl&)), this, SLOT(diggxmloutputAnchorClicked(const QUrl&)));
	 
#endif



	input = new QCharLineEdit(label);
	input->setObjectName("input");
	//input->setFrame(false);
	connect(input, SIGNAL(keyPressed(QKeyEvent *)), this, SLOT(inputKeyPressEvent(QKeyEvent *)));
	connect(input, SIGNAL(focusOut(QFocusEvent *)), this, SLOT(focusOutEvent(QFocusEvent *)));
	connect(input, SIGNAL(inputMethod(QInputMethodEvent *)), this, SLOT(inputMethodEvent(QInputMethodEvent *)));
	connect(trayIcon, SIGNAL(activated(QSystemTrayIcon::ActivationReason)), this, SLOT(iconActivated(QSystemTrayIcon::ActivationReason)));

	licon = new QLabel(label);
	optionDlg = NULL;

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
	QString dest =tz::getUserFullpath(gSettings,LOCAL_FULLPATH_DB);
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
		return;
	} 
	else{
		//   qDebug("connect database %s successfully!\n",qPrintable(dest));  
		tz::initDbTables(db,gSettings,rebuilddatabase);
		if(rebuilddatabase)
			restoreUserCommand();
		//createDbFile();
	}
	catalog.reset((Catalog*)new SlowCatalog(gSettings,gSearchResult,&db));
	//GetShellDir(CSIDL_FAVORITES, gIeFavPath);
	tz::getUserFullpath(NULL,LOCAL_FULLPATH_DEFBROWSER);
	/*
	defBrowser = tz::getUserFullpath(NULL,LOCAL_FULLPATH_DEFBROWSER);
	if(!QFile::exists(defBrowser)){
		defBrowser.clear();	
	}
	*/
#ifdef CONFIG_DIGG_XML
//	diggxmler=new diggXmler(this,diggxmloutput);
//	connect(diggxmler, SIGNAL(diggxmlNotify(QString)), this, SLOT(displayDiggxml(QString)));
#endif

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
	connect(alternatives, SIGNAL(itemSelectionChanged()), this, SLOT(itemSelectionChangedEvent()));
	


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
	syncStatusTimer = NULL;
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
	INIT_TIMER_ACTION_LIST(TIMER_ACTION_BMSYNC,"bmsync",5,(SILENT_SYNC_INTERVAL*HOURS)/(SECONDS));
	INIT_TIMER_ACTION_LIST(TIMER_ACTION_CATBUILDER,"catbuilder",10,(CATALOG_BUILDER_INTERVAL*CATALOG_BUILDER_INTERVAL_UNIT)/(SECONDS));
	INIT_TIMER_ACTION_LIST(TIMER_ACTION_AUTOLEARNPROCESS,"autolearnprocess",15,(AUTO_LEARN_PROCESS_INTERVAL*AUTO_LEARN_PROCESS_INTERVAL_UNIT)/(SECONDS));
	timer_actionlist[TIMER_ACTION_AUTOLEARNPROCESS].enable = 1;//special
	INIT_TIMER_ACTION_LIST(TIMER_ACTION_DIGGXML,"diggxml",20,(DIGG_XML_INTERVAL*DIGG_XML_INTERVAL_UNIT)/(SECONDS));
	INIT_TIMER_ACTION_LIST(TIMER_ACTION_SILENTUPDATER,"silentupdate",15,(24*HOURS)/(SECONDS));
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
	icon_problem=QIcon("images/"+QString(APP_NAME)+"_failed.png");	
	setWindowIcon(icon);
	
	setIcon(SYNC_STATUS_NONE,QString(APP_NAME));
	if(gSettings->value("ckShowTray", true).toBool())
	{
		trayIcon->show();
	}
	if(!gSettings->value("exportbookmark", true).toBool()){
		tz::deleteNetworkBookmark(&db,0);
	}
	
	NEW_TIMER(monitorTimer);
	connect(monitorTimer, SIGNAL(timeout()), this, SLOT(monitorTimerTimeout()), Qt::DirectConnection);					
	monitorTimer->start((tz::getParameterMib(SYS_MONITORTIMEOUT)));	
#ifdef CONFIG_DIGG_XML
//	diggxmler->start();
#endif

#ifdef CONFIG_SYNC_STATUS_DEBUG
	syncStatus = SYNC_STATUS_PROCESSING;
	NEW_TIMER(syncStatusTimer);
	syncStatusTimer->setSingleShot(false);
	connect(syncStatusTimer, SIGNAL(timeout()), this, SLOT(syncStatusTimeout()));
	syncStatusTimer->start(200);
#endif
	updateDisplay();
//	QDEBUG_LINE;
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
	getBrowserFullpath(COMEFROM_TO_BROWSER_ID(res.comeFrom),bin);	
	if(bin.isEmpty())
		bin = tz::getUserFullpath(NULL,LOCAL_FULLPATH_DEFBROWSER);
	TD(DEBUG_LEVEL_NORMAL,"default browser "<<bin);
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
	TD(DEBUG_LEVEL_NORMAL,res.shortName <<" with argument: "<<res.args<< " from "<<res.comeFrom);

	if (res.comeFrom<=COME_FROM_LEARNPROCESS)
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
		int optionDlg = plugins.execute(&inputData, &res);
		if (optionDlg > 1)
		{
			switch (optionDlg)
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
void MyWidget::itemSelectionChangedEvent()
{
	if (searchResults.count() > 0)
		{
			int row = alternatives->currentRow();
			if (row > -1)
			{
				updateMainDisplay(searchResults[row]);
			}
		}
}

void MyWidget::focusOutEvent(QFocusEvent * evt)
{
	if (evt->reason() == Qt::ActiveWindowFocusReason)
	{
		if (gSettings->value("hideiflostfocus", false).toBool())
			if (!this->isActiveWindow() && !alternatives->isActiveWindow() /*&& !optionsOpen*/)
			{
				hideLaunchy();
			}
	}
}


void MyWidget::altKeyPressEvent(QKeyEvent * key)
{
	
	if (key->key() == Qt::Key_Escape)
	{
		alternatives->hide();
	}
	if (key->key() == Qt::Key_Up||key->key() == Qt::Key_Down)
	{
		key->ignore();		
		
	} else if (key->key() == Qt::Key_Return || key->key() == Qt::Key_Enter || key->key() == Qt::Key_Tab)
	{
		if (searchResults.count() > 0)
		{
			int row = alternatives->currentRow();
			if (row > -1)
			{
				/*
				QString location = "History/" + input->text();
				QStringList hist;
				hist << searchResults[row]->lowName << searchResults[row]->fullPath;
				gSettings->setValue(location, hist);
				*/
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
	input->repaint();
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
	TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<gSearchTxt)
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
		QDEBUG_LINE;
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
		if(!input->hasFocus()){
			 input->setFocus();
			  input->keyPressEvent(key);
			  return;
		}
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
	//TD(DEBUG_LEVEL_NORMAL,inputData.count() <<"  : "<<input->text());
	if (inputData.count() <= 1)
		catalog->searchCatalogs(gSearchTxt, searchResults);



	if (searchResults.count() != 0)
		inputData.last().setTopResult(*(searchResults[0]));
	else{
		//google or baidu
		
	}

	//	plugins.getLabels(&inputData);
	//	plugins.getResults(&inputData, &searchResults);
#ifndef CONFIG_RELEASE
	if(gSettings->value("serachresultshow", false).toBool()){
		TD(DEBUG_LEVEL_NORMAL,"search results:");
		for (int i = 0; i < searchResults.count(); i++)
		{
			TD(DEBUG_LEVEL_NORMAL," "<<searchResults[i]->shortName<<" "<<searchResults[i]->fullPath<<" "<<searchResults[i]->comeFrom);
		}
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

void MyWidget::updateMainDisplay(CatItem* t)
{
		iconOnLabel="";
		pathOnoutput="";
		QIcon icon = getIcon(t);
		licon->setPixmap(icon.pixmap(QSize(OUTPUT_ICON_DEFAULT_SIZE, OUTPUT_ICON_DEFAULT_SIZE), QIcon::Normal, QIcon::On));
	 	QString outputs=QString(outputFormat).arg(t->shortName).arg(t->fullPath);
		output->setHtml(outputs);
		licon->repaint();
		output->repaint();
}
void MyWidget::_updateSearcherDisplay(const QString& iconpath,const QString& outputstring)
{
	//TD(DEBUG_LEVEL_NORMAL,iconpath<<outputstring);
	if(iconOnLabel!=iconpath){
		iconOnLabel = iconpath;
		if(iconpath.isEmpty()||iconpath.isNull()){
			licon->clear();
			licon->repaint();
		}else{
			QIcon icon(iconpath);
			licon->setPixmap(icon.pixmap(QSize(OUTPUT_ICON_DEFAULT_SIZE, OUTPUT_ICON_DEFAULT_SIZE), QIcon::Normal, QIcon::On));
			licon->repaint();			
		}
	}
	if(pathOnoutput!=outputstring){
		pathOnoutput = outputstring;
		if(outputstring.isEmpty()||outputstring.isNull()){
			output->clear();
			output->repaint();
		}else{
			output->setHtml(outputstring);
			output->repaint();			
		}
	}
}

void MyWidget::updateSearcherDisplay()
{
	int searcherindex =0;
	QString outputs;
	QString iconpath;
	if(gSettings->value(QString("netfinder/").append(netfinders[NET_SEARCH_GOOGLE].name),true).toBool()&&gSettings->value(QString("netfinder/").append(netfinders[NET_SEARCH_BAIDU].name),true).toBool())
	{
		iconpath=netfinders[NET_SEARCH_GOOGLE].icon;
		outputs=QString(outputFormat).arg(netfinders[NET_SEARCH_GOOGLE].name+"&"+netfinders[NET_SEARCH_BAIDU].name).arg("");
	}else{
		if(gSettings->value(QString("netfinder/").append(netfinders[NET_SEARCH_GOOGLE].name),true).toBool()){
				searcherindex = NET_SEARCH_GOOGLE;
		}else if(gSettings->value(QString("netfinder/").append(netfinders[NET_SEARCH_BAIDU].name),true).toBool()){
				searcherindex = NET_SEARCH_BAIDU;
		}else{
		/*
			licon->clear();
			output->clear();
			licon->repaint();
			output->repaint();
		*/
			_updateSearcherDisplay("","");
			return;			
		}
		iconpath=netfinders[searcherindex].icon;		
		outputs=QString(outputFormat).arg(netfinders[searcherindex].name).arg(netfinders[searcherindex].fullpath);
	}
	_updateSearcherDisplay(iconpath,outputs);
	/*
	licon->setPixmap(icon.pixmap(QSize(32, 32), QIcon::Normal, QIcon::On));
	output->setHtml(outputs);
	licon->repaint();
	output->repaint();
	*/
}

void MyWidget::updateDisplay()
{
	if (searchResults.count() > 0)
	{
/*
		QIcon icon = getIcon(searchResults[0]);

		licon->setPixmap(icon.pixmap(QSize(32, 32), QIcon::Normal, QIcon::On));
#if 1
	 	//QString outputs=QString("<span style=\"color:#286fa6;font-weight:bold;\">%1</span><span style=\"font-size:10px;color:#585755\">(%2)</span>").arg(searchResults[0]->shortName).arg(searchResults[0]->fullPath);
		QString outputs=QString(outputFormat).arg(searchResults[0]->shortName).arg(searchResults[0]->fullPath);

		//TD(DEBUG_LEVEL_NORMAL,outputs);

		output->setHtml(outputs);
#else
		output->setText(searchResults[0]->shortName);
#endif
*/
		updateMainDisplay(searchResults[0]);
		// Did the plugin take control of the input?
		// if (inputData.last().getID() != 0)
		//	  searchResults[0]->comeFrom = inputData.last().getID();
		if(!inputData.isEmpty())
			inputData.last().setTopResult(*(searchResults[0]));

	} else
	{
		if( !(inputMode&(1<<INPUT_MODE_TAB)))
		{
			/*
			licon->clear();
			output->clear();
			licon->repaint();
			output->repaint();
			*/
			updateSearcherDisplay();
		}
	}
}

QIcon MyWidget::getIcon(CatItem * item)
{
	
	if (item->icon.isEmpty()||item->icon.isNull())
	{
		QDir dir(item->fullPath);
		//qDebug()<<item->fullPath;
		if (dir.exists())
			return platform->icons->icon(QFileIconProvider::Folder);
		else if(QFile::exists(item->fullPath))
			return platform->icon(QDir::toNativeSeparators(item->fullPath));
		else{
			//qDebug()<<"Catitem:"<<item->fullPath;
			//修正自定义的url
			QUrl url(item->fullPath);
			if(url.isValid()){
					//qDebug()<<item->fullPath<<" is valid url";
					return platform->icon(QDir::toNativeSeparators(tz::getUserFullpath(NULL,LOCAL_FULLPATH_DEFBROWSER)));
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
						getBrowserFullpath(COMEFROM_TO_BROWSER_ID(item->comeFrom),browserfullpath);
						return platform->icon(QDir::toNativeSeparators(browserfullpath));
				}else{
						return platform->icon(QDir::toNativeSeparators(QString(QCoreApplication::applicationDirPath()).append("\\").append(item->icon)));
				}
			}
		}else if(IS_FROM_BROWSER(item->comeFrom)/*&&QFile::exists(QString(FAVICO_DIRECTORY"/%1.ico").arg(tz::getBrowserName(item->comeFrom-COME_FROM_BROWSER_START).toLower()))*/){
			//return QIcon(QString(FAVICO_DIRECTORY"/%1.ico").arg(tz::getBrowserName(item->comeFrom-COME_FROM_BROWSER_START).toLower()));
			QString browserfullpath("");
			getBrowserFullpath(COMEFROM_TO_BROWSER_ID(item->comeFrom),browserfullpath);
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
	//gBuilder.reset();
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
		if(optionDlg)
			optionDlg->importNetBookmarkFinished(status);
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
	if(maincloseflag)
		close();
	gBuilder->finish_flag=true;
}
#ifdef CONFIG_SKIN_CONFIGURABLE
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
#endif
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
#if 1
	showLaunchy();
#else
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
#endif
}




void MyWidget::closeEvent(QCloseEvent * event)
{
	maincloseflag = 1;
#if 0
	STOP_TIMER(catalogBuilderTimer);
	STOP_TIMER(silentupdateTimer);
	STOP_TIMER(syncTimer);
#endif
	TD(DEBUG_LEVEL_NORMAL,"emit erminateNotify"<<gBuilder<<":"<<slientUpdate<<":"<<gSyncer);
	if(THREAD_IS_RUNNING(gBuilder))
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
	if(THREAD_IS_RUNNING(gSyncer))
	{
		gSyncer->setTerminateFlag(1);
		event->ignore();
		return;
	}
#ifdef CONFIG_DIGG_XML
	if(THREAD_IS_RUNNING(gDiggXmler))
	{
		gDiggXmler->setTerminateFlag(1);
		event->ignore();
		return;
	}
/*
	if(diggxmler){	
		if(diggxmler->isRunning())
			diggxmler->stop();
		while(diggxmler->isRunning());
		//DELETE_OBJECT(diggxmler);		
	}
*/
#endif

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
	QDEBUG_LINE;
	//delete dropTimer;
	DELETE_TIMER(dropTimer);
	DELETE_TIMER(syncStatusTimer);
/*
	if(diggxmler){
		
		if(diggxmler->isRunning())
			diggxmler->stop();
		DELETE_THREAD(diggxmler);
		
	}
*/
//	DELETE_TIMER(diggxmlDisplayTimer);

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
#ifdef CONFIG_SKIN_FROM_RESOURCE
	QResource::registerResource("skins/default.rcc");
#endif
	homeButton->hide();
	userButton->hide();
	syncButton->hide();
	googleButton->hide();
	baiduButton->hide();
	minButton->hide();
	opsButton->hide();	
	goButton->hide();
#ifdef CONFIG_DIGG_XML
	QString diggxmloutputFormat;
	diggxmloutputFormat=QString("<p><a href=\"%1\" style=\"text-decoration: none\">%2</a></p>");
#endif
	outputFormat.clear();
	outputFormat=QString("<span style=\"padding:0;\">%1</span><span style=\"padding:1;\">(%2)</span>");

	

	if (listDelegate == NULL)
		return;
#ifdef CONFIG_SKIN_FROM_RESOURCE
	// Use default skin if this one doesn't exist
	if (!QFile::exists(":/skins/misc.txt"))
	{
		directory = dirs["defSkin"][0];
		gSettings->setValue("skin", dirs["defSkin"][0]);
	}

#else
	// Use default skin if this one doesn't exist
	if (!QFile::exists(directory + "/misc.txt"))
	{
		directory = dirs["defSkin"][0];
		gSettings->setValue("skin", dirs["defSkin"][0]);
	}
#endif
	// Set positions
#ifdef CONFIG_SKIN_FROM_RESOURCE
	if (QFile::exists(":/skins/misc.txt"))
#else
	if (QFile::exists(directory + "/misc.txt"))
#endif
	{
#ifdef CONFIG_SKIN_FROM_RESOURCE
		QFile file(":/skins/misc.txt");
#else
		QFile file(directory + "/misc.txt");
#endif
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
					else if (spl.at(0).trimmed().compare("homebutton", Qt::CaseInsensitive) == 0)
					{
						homeButton->setAttribute(Qt::WA_StyledBackground, true);
						homeButton->setGeometry(rect);
						homeButton->show();						
					}else if (spl.at(0).trimmed().compare("userbutton", Qt::CaseInsensitive) == 0)
					{
						userButton->setAttribute(Qt::WA_StyledBackground, true);
						userButton->setGeometry(rect);
						userButton->show();						
					}else if (spl.at(0).trimmed().compare("syncbutton", Qt::CaseInsensitive) == 0)
					{
						syncButton->setAttribute(Qt::WA_StyledBackground, true);
						syncButton->setGeometry(rect);
						syncButton->show();
					}else if (spl.at(0).trimmed().compare("googlebutton", Qt::CaseInsensitive) == 0)
					{
						googleButton->setAttribute(Qt::WA_StyledBackground, true);
						googleButton->setGeometry(rect);
						googleButton->show();
					}else if (spl.at(0).trimmed().compare("baidubutton", Qt::CaseInsensitive) == 0)
					{
						baiduButton->setAttribute(Qt::WA_StyledBackground, true);
						baiduButton->setGeometry(rect);
						baiduButton->show();
					}else if (spl.at(0).trimmed().compare("optionsbutton", Qt::CaseInsensitive) == 0)
					{
						opsButton->setAttribute(Qt::WA_StyledBackground, true);
						opsButton->setGeometry(rect);
						opsButton->show();
					}else if (spl.at(0).trimmed().compare("minbutton", Qt::CaseInsensitive) == 0)
					{
						minButton->setAttribute(Qt::WA_StyledBackground, true);
						minButton->setGeometry(rect);
						minButton->show();
					}else if (spl.at(0).trimmed().compare("gobutton", Qt::CaseInsensitive) == 0)
					{
						goButton->setAttribute(Qt::WA_StyledBackground, true);
						goButton->setGeometry(rect);
						goButton->show();
					}
#ifdef CONFIG_DIGG_XML
					else if (spl.at(0).trimmed().compare("diggxmloutput", Qt::CaseInsensitive) == 0)
					{
	
						diggxmloutput->setGeometry(rect);
						diggxmloutput->show();
					}else if (spl.at(0).trimmed().compare("diggxmloutputalign", Qt::CaseInsensitive) == 0)
					{
						diggxmloutputFormat.replace("<p>",QString("<p align=\"%1\">").arg(spl.at(1).trimmed()));
					}else if (spl.at(0).trimmed().compare("diggxmloutputcolor", Qt::CaseInsensitive) == 0)
					{
						diggxmloutputFormat.replace("text-decoration: none",QString("color:%1;text-decoration: none").arg(spl.at(1).trimmed()));
					}else if (spl.at(0).trimmed().compare("diggxmloutputFamily", Qt::CaseInsensitive) == 0)
					{
						diggxmloutputFormat.replace("text-decoration: none",QString("font:%1;text-decoration: none").arg(spl.at(1).trimmed()));
					}else if (spl.at(0).trimmed().compare("diggxmloutputSize", Qt::CaseInsensitive) == 0)
					{
						diggxmloutputFormat.replace("text-decoration: none",QString("font-size:%1px;text-decoration: none").arg(spl.at(1).trimmed()));
					}else if (spl.at(0).trimmed().compare("diggxmloutputWeight", Qt::CaseInsensitive) == 0)
					{
						diggxmloutputFormat.replace("text-decoration: none",QString("font-weight:%1;text-decoration: none").arg(spl.at(1).trimmed()));
					}			
#endif
//output name
					else if (spl.at(0).trimmed().compare("outputNameColor", Qt::CaseInsensitive) == 0)
					{
						outputFormat.replace("padding:0;",QString("color:%1;padding:0;").arg(spl.at(1).trimmed()));
					}else if (spl.at(0).trimmed().compare("outputNameSize", Qt::CaseInsensitive) == 0)
					{
						outputFormat.replace("padding:0;",QString("font-size:%1px;padding:0;").arg(spl.at(1).trimmed()));
					}else if (spl.at(0).trimmed().compare("outputNameWeight", Qt::CaseInsensitive) == 0)
					{
						outputFormat.replace("padding:0;",QString("font-weight:%1;padding:0;").arg(spl.at(1).trimmed()));
					}	
//output path
					else if (spl.at(0).trimmed().compare("outputPathColor", Qt::CaseInsensitive) == 0)
					{
						outputFormat.replace("padding:1;",QString("color:%1;padding:1;").arg(spl.at(1).trimmed()));
					}
					else if (spl.at(0).trimmed().compare("outputPathFamily", Qt::CaseInsensitive) == 0)
					{
							outputFormat.replace("padding:1;",QString("font:%1;padding:1;").arg(spl.at(1).trimmed()));
					}else if (spl.at(0).trimmed().compare("outputPathSize", Qt::CaseInsensitive) == 0)
					{
						outputFormat.replace("padding:1;",QString("font-size:%1px;padding:1;").arg(spl.at(1).trimmed()));
					}else if (spl.at(0).trimmed().compare("diggxmloutputWeight", Qt::CaseInsensitive) == 0)
					{
						outputFormat.replace("padding:1;",QString("font-weight:%1;padding:1;").arg(spl.at(1).trimmed()));
					}					 

					else if (spl.at(0).trimmed().compare("minbutton", Qt::CaseInsensitive) == 0)
					{
						minButton->setGeometry(rect);
						minButton->show();
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
#ifdef CONFIG_SKIN_FROM_RESOURCE

	if (QFile::exists(":/skins/style.qss"))
	{
		QFile file(":/skins/style.qss");
		if (file.open(QIODevice::ReadOnly | QIODevice::Text))
		{
			QString styleSheet = QLatin1String(file.readAll());
			// This is causing the ::destroyed connect errors
			qApp->setStyleSheet(styleSheet);
			file.close();
		}
	}
	if ( QFile::exists(":/skins/home.png"))
	{
	//	QDEBUG_LINE;
		//homeButton->setStyleSheet(QString("background: url(:/skins/home.png);"));
		//QDEBUG_LINE;
		//homeButton->setStyleSheet(QString::fromUtf8("background-image: url(:/skins/home.png); "));
		//qApp->setStyleSheet("QPushButton#homeButton{background: url(:/skins/default/home.png);} ");
		//homeButton->setIcon(QIcon(QPixmap(":/skins/Default/home.png")));
	}
	//	if ( QFile::exists(":/skins/input.png"))
	{
	//	input->setStyleSheet(QString(" color: #ff0000;background: url(:/skins/input.png);"));
		//homeButton->setStyleSheet("background-image: url(:/skins/default/home.png); ");
		//qApp->setStyleSheet("QPushButton#homeButton{background: url(:/skins/default/home.png);} ");
		//homeButton->setIcon(QIcon(QPixmap(":/skins/Default/home.png")));
	}

	if ( QFile::exists(":/skins/Default/opsbutton.png"))
	{
		opsButton->setIcon(QIcon(QPixmap(":/skins/Default/opsbutton.png")));
	}
	
	// Set the background image
	if (!platform->SupportsAlphaBorder() && QFile::exists(":/skins/Default/background_nc.png"))
	{
		QPixmap image(":/skins/Default/background_nc.png");
		label->setPixmap(image);
	}

	else if (QFile::exists(":/skins/background.png"))
	{
		QPixmap image(":/skins/background.png");
		label->setPixmap(image);
	}
	// Set the background mask
	if (!platform->SupportsAlphaBorder() && QFile::exists(":/skins/Default/mask_nc.png"))
	{
		QPixmap image(":/skins/Default/mask_nc.png");
		setMask(image);
	}

	else if (QFile::exists(":/skins/mask.png"))
	{
		QPixmap image(":/skins/mask.png");
		// For some reason, w/ compiz setmask won't work
		// for rectangular areas.  This is due to compiz and
		// XShapeCombineMask
		setMask(image);
	}

	// Set the alpha background
	if (QFile::exists(":/skins/alpha.png") && platform->SupportsAlphaBorder())
	{
		platform->CreateAlphaBorder(this, ":/skins/alpha.png");
		connectAlpha();
		platform->MoveAlphaBorder(pos());
	}
#else
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
#endif
#ifdef CONFIG_SKIN_FROM_RESOURCE
	//QResource::unregisterResource("skins/default.rcc");
	input->setStyle(new LineEditStyle);
#endif

	configModify(NET_SEARCH_MODIFY);
	configModify(NET_ACCOUNT_MODIFY);
#ifdef CONFIG_DIGG_XML
//	diggxmler->setDiggXmlFormat(diggxmloutputFormat);
#endif


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
	if(optionDlg)
		optionDlg->importNetBookmarkFinished(status);
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
		//if(optionDlg)
		//	connect(gBuilder.get(), SIGNAL(importNetBookmarkFinishedSignal(int)), optionDlg, SLOT(importNetBookmarkFinished(int)));
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
	if(THREAD_IS_FINISHED(gBuilder)){
		delete gBuilder ;
		gBuilder=NULL;
	}

	if (gBuilder == NULL)
	{

		gBuilder=new CatBuilder(true,mode,&db);
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
		connect(gBuilder, SIGNAL(catalogFinished(int,int)), this, SLOT(catalogBuilt(int,int)));
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
int MyWidget::checkLocalBmDatValid()
{
	QString localBmFullPath=tz::getUserFullpath(gSettings,LOCAL_FULLPATH_BMDAT);
	struct browserinfo* browserInfo =tz::getbrowserInfo();
	QString username=gSettings->value("Account/Username","").toString().trimmed();
	int i = 0;
	if(!QFile::exists(localBmFullPath))
		return 0;

	if((tz::qhashEx(tz::fileMd5(localBmFullPath))!=gSettings->value("localbmkey",0).toUInt())){
		if(!QFile::remove(localBmFullPath))
			return -1;
		return 0;
	}
	
	QFile f(localBmFullPath);	
	if(!f.open(QIODevice::ReadOnly))
		return -1;	
	bmXml r(&f,gSettings);
	while(!browserInfo[i].name.isEmpty())
	{
		r.getBrowserEnable(i);
		bool browserenable = (r.browserenable)?true:false;
		if((browserenable !=browserInfo[i].enable)&&browserInfo[i].enable){
			/*
				now 	past         result
				true       true         unchange
				true	       false        need request bm.xml
				false      true        unchange
				false      false       unchange
			*/
			//don't need remove the localBm.dat
			return 0;
		}
		i++;
	}		
	f.close();
	
	if(r.userId!=tz::qhashEx(username)){
			//if the userid don't arrocrding with userid in localbm
			gSettings->setValue("localbmkey",0);
			gSettings->sync();
			goto bad;
	}
	return 1;
bad:
	if(!QFile::remove(localBmFullPath))
			return -1;
	return 0;
}

void MyWidget::startSync()
{
#ifdef CONFIG_ACTION_LIST
#if 0
	if(!syncDlg)
	{
		syncDlg.reset(new synchronizeDlg(this));
		connect(syncDlg.get(),SIGNAL(reSyncNotify()),this,SLOT(reSync()));
		connect(syncDlg.get(),SIGNAL(stopSyncNotify()),this,SLOT(stopSync()));
	}else{
		syncDlg->status=HTTP_UNCONNECTED;
	}
	if(1)
	{
		syncDlg->setModal(1);
		syncDlg->show();
	}else{
		syncDlg->hide();
	}

#endif
	struct ACTION_LIST item;
	item.action = ACTION_LIST_BOOKMARK_SYNC;
	item.id.mode = SYN_MODE_NOSILENCE;
	addToActionList(item);
#else
	_startSync(SYNC_MODE_BOOKMARK,SYN_MODE_NOSILENCE);
#endif
}
void MyWidget::_startTestAccount(const QString& testAccountName,const QString& testAccountPassword) 
{
	TD(DEBUG_LEVEL_NORMAL,gTestAccounter<<testAccountDlg);
	QString auth_encrypt_str;
	uint key;

	if(testAccountName.isEmpty()||testAccountPassword.isEmpty())
		return;
	if(gTestAccounter&&testAccountDlg){
		testAccountDlg->setModal(1);
		testAccountDlg->show();
		return;
	}
	if(!testAccountDlg)
	{
		testAccountDlg.reset(new synchronizeDlg(this));
		testAccountDlg->mode = SYNC_MODE_TESTACCOUNT;
		connect(testAccountDlg.get(),SIGNAL(reSyncNotify()),this,SLOT(reSync()));
		connect(testAccountDlg.get(),SIGNAL(stopSyncNotify()),this,SLOT(stopSync()));
	}else{
		testAccountDlg->status=HTTP_UNCONNECTED;		
	}
	testAccountDlg->setResult(-1);
	testAccountDlg->setModal(1);
	testAccountDlg->show();	
	qsrand((unsigned) NOW_SECONDS);
	key=qrand()%(getkeylength());
	auth_encrypt_str=tz::encrypt(QString("username=%1 password=%2").arg(testAccountName).arg(testAccountPassword),key);
	
	gTestAccounter.reset(new bmSync(this,gSettings,&db,NULL,SYNC_DO_TESTACCOUNT));
	gTestAccounter->setUsername(testAccountName);
	gTestAccounter->setPassword(testAccountPassword);
	
	connect(gTestAccounter.get(), SIGNAL(finished()), this, SLOT(testAccountFinished()));
	connect(gTestAccounter.get(), SIGNAL(updateStatusNotify(int)), testAccountDlg.get(), SLOT(updateStatus(int)));

	gTestAccounter->setUrl(QString(BM_SERVER_TESTACCOUNT_URL).arg(auth_encrypt_str).arg(key));
	gTestAccounter->start(QThread::IdlePriority);
	return;
}	

void MyWidget::_startSync(int mode,int silence)      
{
	QString localBmFullPath;
	QString url;
	QString auth_encrypt_str;
	uint key;
	QString name,password;
	int i = 0,browsers_enable=0;
	
	//start to all browser is disable ,don't sync
	struct browserinfo* browserInfo =tz::getbrowserInfo();	
	while(!browserInfo[i].name.isEmpty())
	{
		browsers_enable|=(browserInfo[i].enable?1:0);
		i++;
	}
	//end to all browser is disable ,don't sync
	if((updateSuccessTimer)||(!browsers_enable)||((silence!=SYN_MODE_NOSILENCE)&&tz::GetCpuUsage()>CPU_USAGE_THRESHOLD))
		goto	SYNCOUT;
	name=gSettings->value("Account/Username","").toString();
	password=tz::decrypt(gSettings->value("Account/Userpasswd","").toString(),PASSWORD_ENCRYPT_KEY);					
	if(name.isEmpty()||password.isEmpty())
		goto	SYNCOUT;
	//silence = SYN_MODE_NOSILENCE;
/*	
	if(THREAD_IS_FINISHED(gSyncer)){
		delete gSyncer ;
		gSyncer=NULL;
	}
*/
	TD(DEBUG_LEVEL_NORMAL,gSyncer<<syncDlg);
	if(gSyncer){
		if((silence ==SYN_MODE_NOSILENCE))
		{
			if(!syncDlg){
				syncDlg=new synchronizeDlg(this);
				connect(syncDlg,SIGNAL(reSyncNotify()),this,SLOT(reSync()));
				connect(syncDlg,SIGNAL(stopSyncNotify()),this,SLOT(stopSync()));
				connect(gSyncer, SIGNAL(updateStatusNotify(int)), syncDlg, SLOT(updateStatus(int)));
				syncDlg->setModal(1);
				syncDlg->show();
				gSyncer->bmSyncMode = SYN_MODE_NOSILENCE;
			}
		}
		return;
	}

	qsrand((unsigned) NOW_SECONDS);
	key=qrand()%(getkeylength());
	auth_encrypt_str=tz::encrypt(QString("username=%1 password=%2").arg(name).arg(password),key);
	

	switch(checkLocalBmDatValid()){
			case -1:
				goto SYNCOUT;
				break;
			case 0:
				url=QString(BM_SERVER_GET_BMXML_URL).arg(auth_encrypt_str).arg(key).arg(0);
				break;
			case 1:
				url=QString(BM_SERVER_GET_BMXML_URL).arg(auth_encrypt_str).arg(key).arg(gSettings->value("updateTime","0").toString());
				break;
	}
	
	if(silence == SYN_MODE_NOSILENCE)
		url=QString(BM_SERVER_GET_BMXML_URL).arg(auth_encrypt_str).arg(key).arg(0);
	gSyncer=new bmSync(this,gSettings,&db,&gSemaphore,SYNC_DO_BOOKMARK);
	if((silence ==SYN_MODE_NOSILENCE)){
			if(!syncDlg){
				syncDlg=new synchronizeDlg(this);
				syncDlg->setModal(1);
				syncDlg->show();				
			}
			syncDlg->activateWindow();
			connect(syncDlg,SIGNAL(reSyncNotify()),this,SLOT(reSync()));
			connect(syncDlg,SIGNAL(stopSyncNotify()),this,SLOT(stopSync()));
			//connect(gSyncer, SIGNAL(updateStatusNotify(int)), syncDlg, SLOT(updateStatus(int)),Qt::QueuedConnection);
			connect(gSyncer, SIGNAL(updateStatusNotify(int)), syncDlg, SLOT(updateStatus(int)));
			gSyncer->bmSyncMode = SYN_MODE_NOSILENCE;
	}
	gSyncer->setUsername(name);
	gSyncer->setPassword(password);
	//connect(gSyncer, SIGNAL(finished()), this, SLOT(bmSyncerFinished()),Qt::QueuedConnection);	
	connect(gSyncer, SIGNAL(finished()), this, SLOT(bmSyncerFinished()));
	syncAction->setDisabled(TRUE);
	gSyncer->setUrl(url);
	gSyncer->start(QThread::IdlePriority);
	gSettings->setValue("lastsyncstatus",SYNC_STATUS_PROCESSING);
	gSettings->sync();
#ifndef CONFIG_SYNC_STATUS_DEBUG
	syncStatus = SYNC_STATUS_PROCESSING;
	NEW_TIMER(syncStatusTimer);
	syncStatusTimer->setSingleShot(false);
	connect(syncStatusTimer, SIGNAL(timeout()), this, SLOT(syncStatusTimeout()));
	syncStatusTimer->start(SECONDS/2);
#endif

	return;
SYNCOUT:
	SAVE_TIMER_ACTION(TIMER_ACTION_BMSYNC,"bmsync",FALSE);
	return;	
}
void MyWidget::bmSyncerFinished()
{	
	bmSyncFinishedStatus(gSyncer->statusCode);
	gSemaphore.release(1);
	scanDbFavicon();
	syncAction->setDisabled(FALSE);
	if(maincloseflag)
		close();
	else{
		 SAVE_TIMER_ACTION(TIMER_ACTION_BMSYNC,"bmsync",TRUE);
	}	
	DELETE_THREAD(gSyncer);
}

void MyWidget::bmSyncFinishedStatus(int status)
{
//	TD(DEBUG_LEVEL_NORMAL, tz::getstatusstring(status));

	if(status==BM_SYNC_SUCCESS_NO_MODIFY||status==BM_SYNC_SUCCESS_WITH_MODIFY){
			gSettings->setValue("lastsyncstatus",SYNC_STATUS_SUCCESSFUL);
	}else{
			gSettings->setValue("lastsyncstatus",SYNC_STATUS_FAILED);
	}
	gSettings->sync();

#ifndef CONFIG_SYNC_STATUS_DEBUG
	DELETE_TIMER(syncStatusTimer);
#endif	
	if(!syncButton->isHidden()){
		configModify(NET_ACCOUNT_MODIFY);
	}
	if(!trayIcon->isVisible()) 
		return;
	switch(status){
		case BM_SYNC_SUCCESS_NO_MODIFY:
#ifndef CONFIG_SYNC_STATUS_DEBUG
			setIcon(SYNC_STATUS_SUCCESSFUL,tz::tr(tz::getstatusstring(status)));			
#endif
			break;
		case BM_SYNC_SUCCESS_WITH_MODIFY:
#ifndef CONFIG_SYNC_STATUS_DEBUG
			setIcon(SYNC_STATUS_SUCCESSFUL,tz::tr(tz::getstatusstring(status)));
#endif
			trayIcon->showMessage(APP_NAME,tz::tr(tz::getstatusstring(status)), QSystemTrayIcon::Information);
			break;
		case BM_SYNC_FAIL_SERVER_NET_ERROR:
		case BM_SYNC_FAIL_SERVER_REFUSE:
		case BM_SYNC_FAIL_SERVER_BMXML_FAIL:
		case BM_SYNC_FAIL_BMXML_TIMEOUT:
		case BM_SYNC_FAIL_MERGE_ERROR:
		case BM_SYNC_FAIL_PROXY_ERROR:
		case BM_SYNC_FAIL_PROXY_AUTH_ERROR:
		case BM_SYNC_FAIL_SERVER_LOGIN:
		default:
#ifndef CONFIG_SYNC_STATUS_DEBUG
			setIcon(SYNC_STATUS_FAILED,tz::tr(tz::getstatusstring(status)));
#endif
			break;	
	}	
}

void MyWidget::testAccountFinished()
{
	gTestAccounter->wait();								
	gTestAccounter.reset();
	TD(DEBUG_LEVEL_NORMAL,gTestAccounter);
}

void MyWidget::syncStatusTimeout()
{
	//TD(DEBUG_LEVEL_NORMAL,"syncStatus:"<<syncStatus);
	if((syncStatus>=SYNC_STATUS_PROCESSING)&&(syncStatus<SYNC_STATUS_PROCESSING_MAX)){
		syncStatus = (syncStatus+1);
		if(syncStatus == SYNC_STATUS_PROCESSING_MAX)
			syncStatus=SYNC_STATUS_PROCESSING_1;
		setIcon(syncStatus,"syncing......");
		if(!syncButton->isHidden()){
#ifdef CONFIG_SKIN_FROM_RESOURCE
			syncButton->setIcon(QIcon(QPixmap(QString(":/skins/%1/%2").arg(gSettings->value("skin", dirs["defSkin"][0]).toString()).arg(syncStatus==(SYNC_STATUS_PROCESSING_1)?"sync_on.png":"sync_off.png"))));	
#else
			syncButton->setIcon(QIcon(QString(gSettings->value("skin", dirs["defSkin"][0]).toString()).append(QString("/%1").arg(syncStatus==(SYNC_STATUS_PROCESSING_1)?"sync.png":"sync2.png"))));			
#endif
		}
	}	
}
void MyWidget::monitorTimerTimeout()
{	
		STOP_TIMER(monitorTimer);
#if 0

	//TD(DEBUG_LEVEL_NORMAL,gSyncer<<gBuilder);
	if(THREAD_IS_FINISHED(gSyncer)){
		//TD(DEBUG_LEVEL_NORMAL,gSyncer);
		if(gSyncer->finish_flag){
			delete gSyncer;
			gSyncer=NULL;
		}
	}

	if(THREAD_IS_FINISHED(gDiggXmler)){
		if(gDiggXmler->finish_flag){
			delete gDiggXmler ;
			gDiggXmler=NULL;
		}
	}
	if(THREAD_IS_FINISHED(slientUpdate)){
		if(slientUpdate->finish_flag){
			delete slientUpdate ;
			slientUpdate=NULL;
		}
	}
#endif

	if(THREAD_IS_FINISHED(gBuilder)){
		if(gBuilder->finish_flag){
			delete gBuilder ;
			gBuilder=NULL;
		}
	}


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
	

	//processing ........
#ifdef CONFIG_ACTION_LIST
	struct ACTION_LIST item;
	if(!maincloseflag&&!gBuilder&&!gSyncer&&!updateSuccessTimer&&getFromActionList(item)){
#ifndef CONFIG_RELEASE
		if(gSettings->value("actiondebug", false).toBool()){
			TD(DEBUG_LEVEL_NORMAL,"runtime:"<<(NOW_SECONDS-runseconds)<<","<<tz::getActionListName(item.action));
		}
#endif		
		switch(item.action){
			case ACTION_LIST_CATALOGBUILD:
				_buildCatalog((CATBUILDMODE)item.id.mode,0);
				break;
			case ACTION_LIST_BOOKMARK_SYNC:
				_startSync(SYNC_MODE_BOOKMARK,item.id.mode);
				break;
/*
			case ACTION_LIST_TEST_ACCOUNT:
				_startSync(SYNC_MODE_TESTACCOUNT,item.id.mode);
				break;
*/
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
		switch(syncDlg->result()){
		case QDialog::Accepted:				
		case QDialog::Rejected:
			//DELETE_SHAREOBJ(syncDlg);
			QDEBUG_LINE;
			delete syncDlg;
			syncDlg=NULL;
			break;
		default:
			if(syncDlg->status==UPDATE_SUCCESSFUL||syncDlg->status==HTTP_TEST_ACCOUNT_SUCCESS||syncDlg->status==BM_SYNC_SUCCESS_NO_MODIFY)
			{
				QDEBUG_LINE;
				if((NOW_SECONDS-syncDlg->statusTime)>10)
				{
					//DELETE_SHAREOBJ(syncDlg);
					if(!gSyncer||THREAD_IS_FINISHED(gSyncer)){
						QDEBUG_LINE;
						delete syncDlg;
						syncDlg=NULL;
					}
				}
			}
			break;
		}
	}
	if(testAccountDlg){
		switch(testAccountDlg->result()){
		case QDialog::Accepted:				
		case QDialog::Rejected:			
			QDEBUG_LINE;
			DELETE_SHAREOBJ(testAccountDlg);
			break;
		}
	}
	//TD(DEBUG_LEVEL_NORMAL,optionDlg);
	if(optionDlg){
		switch(optionDlg->result()){
		case QDialog::Accepted:				
		case QDialog::Rejected:			
			QDEBUG_LINE;
			delete optionDlg;
			optionDlg=NULL;
			break;
		}
	}
	//clear user directory	
	monitorTimer->start((tz::getParameterMib(SYS_MONITORTIMEOUT)));
}
#ifdef CONFIG_DIGG_XML

void diggXmler::diggxmlDisplayTimeout()
{
	QString diggxmloutputs;
	if(diggXmllist.size()){
		uint index = (diggxmlDisplayIndex++)%diggXmllist.size();
		
		//QString diggxmloutputs=QString("<p align=\"right\"><a href=\"%1\" style=\"color:#2C629E;text-decoration: none\">%2</a></p>").arg(diggXmllist.at(index).link).arg(diggXmllist.at(index).name);
		diggxmloutputs=QString(diggxmloutputFormat).arg(diggXmllist.at(index).link).arg(diggXmllist.at(index).name);
		
		// TD(DEBUG_LEVEL_NORMAL,diggxmloutputs);
		//QString diggxmloutputs=QString("<html><body><p><a href=\"%1\">%2</a></p></body></html>").arg(diggXmllist.at(index).link).arg(diggXmllist.at(index).name);
		//ui.textBrowser->append(QString::fromLocal8Bit("<a href = \"http://www.sina.com.cn/\">新浪</a>"));
		//diggxmloutput->setOpenExternalLinks (true );
		
	}else{
		diggxmloutputs=QString(diggxmloutputFormat).arg(HTTP_SERVER_URL).arg(QString(APP_NAME)+"-"+QString(APP_SLOGAN));
	}
	//textoutput->setHtml(diggxmloutputs);
	emit diggxmlNotify(diggxmloutputs);
}
void diggXmler::loadDiggXml()
{
	if(QFile::exists(DIGG_XML_LOCAL_FILE_TMP)&&!gDiggXmler){
		
		QFile::remove(DIGG_XML_LOCAL_FILE);
		QFile::copy(DIGG_XML_LOCAL_FILE_TMP,DIGG_XML_LOCAL_FILE);
	}
	QFile f(DIGG_XML_LOCAL_FILE);
	if(f.open(QIODevice::ReadOnly)){
		diggxmlDisplayIndex = 0;
		bmXml r(&f,gSettings);			
		bmXml diggXmlReader(&f,gSettings);
		diggXmlReader.readStream(0);
		diggXmllist.clear();
		diggXmllist = diggXmlReader.bm_list;
#ifdef TOUCH_ANY_DEBUG
		//foreach(bookmark_catagory diggitem, diggXmllist)
		//{
		//	TD(DEBUG_LEVEL_NORMAL,diggitem.bmid<<diggitem.name<<diggitem.link);
		//}
#endif	
		f.close();
	}else{
		diggXmllist.clear();		
	}
	diggxmlDisplayIndex=0;
	diggxmlDisplayTimeout();
}
void MyWidget::diggxmloutputAnchorClicked(const QUrl & link)
{
		TD(DEBUG_LEVEL_NORMAL,link.toString());
		runProgram(link.toString(),"");			
}

void MyWidget::diggXmlFinished()
{

	if(maincloseflag)
		close();
	else{
		SAVE_TIMER_ACTION(TIMER_ACTION_DIGGXML,"diggxml",((gDiggXmler->statusCode ==DOWHAT_GET_FILE_SUCCESS)?1:0));
		if(gDiggXmler->statusCode == DOWHAT_GET_FILE_SUCCESS){
			emit diggXmlNewSignal();
		}
	}
	gDiggXmler->finish_flag = true;
	DELETE_THREAD(gDiggXmler);
	//gDiggXmler->wait();								
	//gDiggXmler.reset();
	//gDiggXmler->finish_flag = true;
	//delete gDiggXmler ;
	//gDiggXmler=NULL;
	
}
void MyWidget::displayDiggxml(QString s)
{
	diggxmloutput->setHtml(s);
}
void MyWidget::startDiggXml()
{
	return;
	if(THREAD_IS_RUNNING(gDiggXmler)){
		return;
	}
	if(THREAD_IS_FINISHED(gDiggXmler)){
		delete gDiggXmler ;
		gDiggXmler=NULL;
	}
	
	gDiggXmler=new bmSync(NULL,gSettings,&db,NULL,SYNC_DO_DIGG);
	connect(gDiggXmler, SIGNAL(finished()), this, SLOT(diggXmlFinished()),Qt::QueuedConnection);
	gDiggXmler->setUrl(BM_SERVER_GET_DIGGXML_URL);
#if 1
	//gDiggXmler->setDiggId(diggxmler->getMaxDiggid());
	gDiggXmler->setDiggId(0);
#else
	if(diggXmllist.size())
	{
		bookmark_catagory bc = diggXmllist.at(0);
		gDiggXmler->setDiggId(bc.bmid);
	}
#endif
	gDiggXmler->start(QThread::IdlePriority);

}
#endif

void MyWidget::homeBtnPressed()
{
	runProgram(HTTP_SERVER_URL,"");
	input->setFocus();
}
void MyWidget::userBtnPressed()
{
	runProgram(HTTP_SERVER_URL,"");
	input->setFocus();
}

void MyWidget::googleBtnPressed()
{
	gSettings->setValue(QString("netfinder/").append(netfinders[NET_SEARCH_GOOGLE].name),!gSettings->value(QString("netfinder/").append(netfinders[NET_SEARCH_GOOGLE].name),true).toBool());
	configModify(NET_SEARCH_MODIFY);
	input->setFocus();
}
void MyWidget::baiduBtnPressed()
{
	gSettings->setValue(QString("netfinder/").append(netfinders[NET_SEARCH_BAIDU].name),!gSettings->value(QString("netfinder/").append(netfinders[NET_SEARCH_BAIDU].name),true).toBool());
	configModify(NET_SEARCH_MODIFY);
	input->setFocus();
}
void MyWidget::goBtnPressed()
{
	doEnter();
}
void MyWidget::minBtnPressed()
{
	hideLaunchy();
}

void MyWidget::menuOptions()
{
	if (optionDlg)
	{
		//TD(DEBUG_LEVEL_NORMAL,optionDlg->result());
		optionDlg->activateWindow();
		optionDlg->show();	
		return;
	}
//	optionsOpen = true;
	optionDlg = new OptionsDlg(this,gSettings,&db);
	connect(optionDlg, SIGNAL(rebuildcatalogSignal()), this, SLOT(buildCatalog()));
	connect(optionDlg, SIGNAL(optionStartSyncNotify()), this, SLOT(startSync()));
	connect(optionDlg, SIGNAL(configModifyNotify(int)), this, SLOT(configModify(int)));
	connect(optionDlg, SIGNAL(testAccountNotify(const QString&,const QString&)), this, SLOT(_startTestAccount(const QString&,const QString&)));	
	TD(DEBUG_LEVEL_NORMAL,optionDlg->result());
	optionDlg->setModal(1);
	optionDlg->setObjectName("options");
	optionDlg->show();	
	optionDlg->activateWindow();
	//optionDlg->exec();
	//DELETE_OBJECT(optionDlg);
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
	syncStatus = type;
	switch(type){
		case SYNC_STATUS_PROCESSING_1:
		case SYNC_STATUS_PROCESSING_2:
			trayIcon->setIcon(QIcon(QString("images/"+QString(APP_NAME)+"_%1.png").arg(type-SYNC_STATUS_PROCESSING_1+1)));	
		break;
		case SYNC_STATUS_FAILED:
			trayIcon->setIcon(QIcon("images/"+QString(APP_NAME)+"_failed.png"));	
		break;
		case SYNC_STATUS_SUCCESSFUL:
			trayIcon->setIcon(QIcon("images/"+QString(APP_NAME)+"_successful.png"));	
		break;
		case SYNC_STATUS_NONE:
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
	TD(DEBUG_LEVEL_NORMAL,reason);
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
		//this->trayIcon->contextMenu()->exec(QCursor::pos());
		this->trayIcon->contextMenu()->showNormal();
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
	//slientUpdate->wait();
	
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
	if(maincloseflag)
		close();
	else{
#ifdef QT_NO_DEBUG
			
#else		
		//silentupdateTimer->start(100*SECONDS);	
#endif	
	}
	//slientUpdate->finish_flag=true;
	DELETE_THREAD(slientUpdate);
}
void MyWidget::startSilentUpdate()
{
	TD(DEBUG_LEVEL_NORMAL,"########################################");
	//qDebug("%s %d currentthreadid=0x%08x this=0x%08x",__FUNCTION__,__LINE__,QThread::currentThread(),this);
	if(tz::GetCpuUsage()>CPU_USAGE_THRESHOLD)
		return;
	if(slientUpdate)
		return;
#ifdef QT_NO_DEBUG
#else
	tz::deleteDirectory(UPDATE_DIRECTORY);
#endif
	//qDebug("slientUpdate=0x%08x,isFinished=%d",slientUpdate,(slientUpdate)?slientUpdate->isFinished():0);

	slientUpdate=new appUpdater(this,gSettings); 
	slientUpdate->dlgmode = UPDATE_SILENT_MODE;
	connect(slientUpdate,SIGNAL(finished()),this,SLOT(silentUpdateFinished()));		
	//connect(this,SIGNAL(silentUpdateTerminateNotify()),slientUpdate,SLOT(terminateThread()));
	slientUpdate->start(QThread::IdlePriority);		

}
void MyWidget::getFavicoFinished()
{
	//qDebug("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
	//qDebug("%s %d currentthreadid=0x%08x this=0x%08x",__FUNCTION__,__LINE__,QThread::currentThread(),this);
	int i =getfavicolist.size();
	while((--i)>=0){
		DoNetThread* icogh = getfavicolist.at(i);
		if(icogh->isFinished())
		{
			getfavicolist.removeOne(icogh);
			delete icogh;
		}
	}
}

void MyWidget::getFavico(const QString& host,const QString& f)
{
	DoNetThread* icogh =  new DoNetThread(NULL,gSettings,DOWHAT_GET_COMMON_FILE,0);
	getfavicolist.append(icogh);
	TD(DEBUG_LEVEL_NORMAL,"get fav ico from"<<host);
	connect(icogh,SIGNAL(finished()),this,SLOT(getFavicoFinished()));
	icogh->setHost(host);
	icogh->setUrl("/"+f);
	icogh->setDestDirectory(FAVICO_DIRECTORY);
	QString extension = f.section( '.', -1 );
	if(extension.isEmpty())
		icogh->setSaveFilename(QString("%1").arg(tz::qhashEx(host)));
	else
		icogh->setSaveFilename(QString("%1.%2").arg(tz::qhashEx(host)).arg(extension));
	icogh->start(QThread::IdlePriority);
}
void MyWidget::scanDbFavicon()
{
	QSqlQuery	q("", db);
	QString s=QString("SELECT fullPath FROM %1 ").arg(DBTABLEINFO_NAME(COME_FROM_BROWSER));
	if(q.exec(s)){
		//getFavico("www.sohu.com","favicon.ico");
		while(q.next()) {
			QString fullPath = Q_VALUE_STRING(q,"fullpath");		
			if(fullPath.startsWith("http",Qt::CaseInsensitive)||fullPath.startsWith("https",Qt::CaseInsensitive))
			{
				QUrl url(fullPath);									
				if(url.isValid()){
					QString host = url.host();
					if(!QFile::exists(QString(FAVICO_DIRECTORY"/%1.ico").arg(tz::qhashEx(host))))
						getFavico(host,"favicon.ico");
				}
			}
		}
	}	
	q.clear();
}


#ifdef TOUCH_ANY_DEBUG
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


void touchAnyDebugOutput(QtMsgType type, const char *msg)
{
	switch (type) {
	 case QtDebugMsg:
		 {
			 if(gSettings){
				 gSettings->sync();
				 uint debuglevel = gSettings->value("debug",1<<DEBUG_LEVEL_NORMAL).toUInt();
				 if(1){		
				 	 QString debugmsg(msg);
					 int index = debugmsg.indexOf(QString(" :"));
					 if(index ==-1)
					 	return;
					 uint level = debugmsg.left(index).trimmed().toUInt();
					 if((1<<level)&debuglevel){
						// fprintf(stderr, "%s\n",TOCHAR(debugmsg.remove(0,index+QString(" :").size())));
						 fprintf(stderr,"%s\n",msg);
					 }				 
					
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
		case COME_FROM_LEARNPROCESS:
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

	if(itempriority(a->comeFrom)<itempriority(b->comeFrom))
		return true;
	if(itempriority(a->comeFrom)>itempriority(b->comeFrom))
		return false;
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

#ifdef TOUCH_ANY_DEBUG
	qInstallMsgHandler(touchAnyDebugOutput);
 #endif
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
