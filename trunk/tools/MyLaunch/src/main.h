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

#ifndef MAIN_H
#define MAIN_H


#if 0
#include <QWidget>
#include <QLabel>
#include <QLineEdit>
#include <QListWidget>
#include <QString>
#include <QtNetwork/QHttp>
#include <QBuffer>
#include <QKeyEvent>
#include <QScrollBar>
#endif
//#include "plugin_handler.h"
#include "platform_util.h"
#include <catalog.h>
#include <catalog_builder.h>
#include <icon_delegate.h>
#include <globals.h>
#include <config.h>
#include <optionUI.h>
#include <bmsync.h>
#ifdef CONFIG_DIGG_XML
#include <diggxml.h>
#endif
#include <QProcess>
//#include <weby>





class QLineEditMenu : public QLineEdit
{
	Q_OBJECT
public:
	QLineEditMenu(QWidget* parent = 0) :
	QLineEdit(parent) {setAttribute(Qt::WA_InputMethodEnabled);}
	void contextMenuEvent(QContextMenuEvent *evt) {
		emit menuEvent(evt);
	}
signals:
	void menuEvent(QContextMenuEvent*);
};

class QCharLineEdit : public QLineEdit
{
	Q_OBJECT
public:
	QCharLineEdit(QWidget* parent = 0) : 
	QLineEdit(parent) 
	{
		setAttribute(Qt::WA_InputMethodEnabled);
	}
	void keyPressEvent(QKeyEvent* key) {
		//	LOG_RUN_LINE;
		QLineEdit::keyPressEvent(key);
		emit keyPressed(key);
	}
	// This is how you pick up the tab key
	bool focusNextPrevChild(bool next) {
		next = next; // Remove compiler warning
		QKeyEvent key(QEvent::KeyPress, Qt::Key_Tab, NULL);
		emit keyPressed(&key);
		return true;
	}
	void focusOutEvent ( QFocusEvent * evt) {
		emit focusOut(evt);
	}

	void inputMethodEvent(QInputMethodEvent *e) {
		QLineEdit::inputMethodEvent(e);
		if (e->commitString() != "") {
			emit inputMethod(e);
		}
	}
	/*
	void mouseReleaseEvent(QMouseEvent* e)
	{
	if (event->button() & RightButton) {
	QContextMenuEvent
	emit contextMenuEvent
	}
	}
	*/
signals:
	void keyPressed(QKeyEvent*);
	void focusOut(QFocusEvent* evt);
	void inputMethod(QInputMethodEvent *e);
};

class QCharListWidget : public QListWidget
{
	Q_OBJECT
public:
	QCharListWidget(QWidget* parent = 0) : 
	QListWidget(NULL)
	{
		parent = parent; // warning
#ifdef Q_WS_X11
		setWindowFlags( windowFlags() |   Qt::Tool | Qt::SplashScreen);
#endif
		setAttribute(Qt::WA_AlwaysShowToolTips);

		setAlternatingRowColors(false);
	}
	void keyPressEvent(QKeyEvent* key) {
		emit keyPressed(key);
		QListWidget::keyPressEvent(key);
		key->ignore();
	}
	void mouseDoubleClickEvent( QMouseEvent * event  ) {
		event = event; // Remove compiler warning
		QKeyEvent key(QEvent::KeyPress, Qt::Key_Enter, NULL);
		emit keyPressed(&key);
	}
	void focusOutEvent ( QFocusEvent * evt) {
		emit focusOut(evt);
	}

signals:
	void keyPressed(QKeyEvent*);
	void focusOut(QFocusEvent* evt);
};

class Fader : public QThread
{
	Q_OBJECT
private:
	bool keepRunning;
	bool fadeType;
public:
	Fader(QObject* parent = NULL)
		: QThread(parent), keepRunning(true) {}
	~Fader() {}
	void stop() { keepRunning = false; }
	void run();
	void fadeIn();
	void fadeOut();
	void setFadeType(bool type) { fadeType = type; }
signals:
	void fadeLevel(double);
	void finishedFade(double);
};
enum {
	SYNC_MODE_BOOKMARK=0,
	SYNC_MODE_REBOOKMARK,	
	SYNC_MODE_TESTACCOUNT
};
enum{
	INPUT_MODE_NULL=0,
	INPUT_MODE_TAB,
	INPUT_MODE_NULL_PAGEDOWN,
	INPUT_MODE_PAGEDOWN
};
/*
enum{
	REBUILD_CATALOG=0,
	REBUILD_SILENT_SYNC,
	REBUILD_DATABASE
};
*/

enum{
	TIMER_ACTION_BMSYNC=0,
	TIMER_ACTION_CATBUILDER,
	TIMER_ACTION_AUTOLEARNPROCESS,
	TIMER_ACTION_DIGGXML,
	TIMER_ACTION_SILENTUPDATER,
	TIMER_ACTION_MAX
};

struct  TIMER_ACTION_LIST{
	char actionType;
	char enable;//0x01--enable  0x02--in queue
	short startAfterRun;
	uint lastActionSeconds;//seconds for units
	uint interval;//seconds for units
	uint faileds;//record continous fail nums 
};

class MyWidget : public QWidget
{
	Q_OBJECT  // Enable signals and slots
public:
	MyWidget() {};
	MyWidget(QWidget *parent, PlatformBase*, bool rescue );
	~MyWidget();

	QHash<QString, QList<QString> > dirs;
	Fader* fader;
	QPoint moveStartPoint;
	shared_ptr<PlatformBase> platform;	
	QLabel* label;
	QLineEditMenu *output;
	QCharLineEdit *input;

#if 1
	struct  TIMER_ACTION_LIST* timer_actionlist;
	uint runseconds;	
#else
	QTimer* syncTimer;
	QTimer* silentupdateTimer;
	QTimer* catalogBuilderTimer;
#ifdef CONFIG_AUTO_LEARN_PROCESS
	QTimer* autoLearnProcessTimer;
	uint learnProcessTimes;
#endif
#ifdef CONFIG_DIGG_XML
	QTimer* diggXmlTimer;
#endif
#endif

	QTimer* dropTimer;	
	QCharListWidget *alternatives;
	QPushButton *opsButton;
	QPushButton *closeButton;
	QRect altRect;
	QLabel * licon;
	QSqlDatabase db;
	uint inputMode;

	QScrollBar* altScroll;
	shared_ptr<Catalog> catalog;
	shared_ptr<CatBuilder> catBuilder;
	//shared_ptr<SlowCatalog*> main_catalog;;
	QList<CatItem*> searchResults;
	QList<InputData> inputData;
//	PluginHandler plugins;
	bool visible;
	bool alwaysShowLaunchy;
	bool menuOpen;
	bool optionsOpen;
	uint rebuildAll;
	uint updateTimes;// update times
	//	QTimer* syncDlgTimer;
	QTimer* updateSuccessTimer;
	IconDelegate* listDelegate;
	QAbstractItemDelegate * defaultDelegate;
	QString testAccountName;
	QString testAccountPassword;
	int syncMode;
	QList<GetFileHttp*> getfavicolist;

	shared_ptr < synchronizeDlg> syncDlg;

	void connectAlpha();
	QIcon getIcon(CatItem * item);
	void MoveFromAlpha(QPoint pos);
	void applySkin(QString);
	void contextMenuEvent(QContextMenuEvent *event);
	void closeEvent(QCloseEvent *event);
	void showLaunchy(bool now = false);
	void hideLaunchy(bool now = false);
//	void updateVersion(int oldVersion);
//	void checkForUpdate();
//	void shouldDonate();
	void setCondensed(int condensed);
	bool setHotkey(int, int);
	void showAlternatives(bool show=true);
	void launchObject();
	void launchBrowserObject(CatItem& res);
	void searchFiles(const QString & input, QList<CatItem*>& searchResults);
	void parseInput(QString text);
	void resetLaunchy();
	void applySkin2(QString directory);
	void updateDisplay();
	void searchOnInput();
	void fadeIn();
	void fadeOut();
	//	QPair<double,double> relativePos();
	//	QPoint absolutePos(QPair<double,double> relPos);
	QPoint loadPosition(int rescue);
	void savePosition() { gSettings->setValue("Display/pos", pos()); }
	void doTab();
	void doEnter();
	void doPageDown(int mode);
	QChar sepChar();
	QString printInput();
	void processKey();
	//bool createDbFile();
	void	increaseUsage(CatItem& item,const QString& alias);
#ifdef TOUCH_ANY_DEBUG
	void dumpBuffer(char* addr,int length);
#endif
	void createTrayIcon();
	void createActions();
	void freeOccupyMemeory();
	//void createSynDlgTimer();
	//	void deleteSynDlgTimer();
	void getFavico(const QString& host,const QString& filename);
	void scanDbFavicon();
	QString getShortkeyString();
private:
	QHttp *http;
	QBuffer *verBuffer;
	QBuffer *counterBuffer;
	//    QAction *minimizeAction;
	QAction *rebuildCatalogAction;
	QAction *optionsAction;
	QAction *restoreAction;
	QAction* syncAction;
	QAction* updateAction;
	QAction *quitAction;

	QSystemTrayIcon *trayIcon;
	QMenu *trayIconMenu;
	QIcon icon;
	QIcon icon_problem;
	appUpdater *slientUpdate;
	volatile int closeflag;
	QTimer* monitorTimer;
	OptionsDlg *ops;
	QString shortkeyString;
	QString defBrowser;
#ifdef CONFIG_AUTO_LEARN_PROCESS
	uint learnProcessTimes;
#endif
#ifdef CONFIG_DIGG_XML
	QList<bookmark_catagory> diggXmllist;
#endif
public slots:
		void monitorTimerTimeout();
		void updateSuccessTimeout();
		void menuOptions();
		void onHotKey();		
#if 0
		void catalogBuilderTimeout();
		void silentupdateTimeout();
		
		void syncTimeout();
		
#ifdef CONFIG_AUTO_LEARN_PROCESS
		void autoLearnProcessTimeout();
#endif
#ifdef CONFIG_DIGG_XML
		void diggXmlTimeout();
#endif
#endif
		void dropTimeout();
		void setAlwaysShow(bool);
		void setAlwaysTop(bool);
		void setPortable(bool);
		void mousePressEvent(QMouseEvent *e);
		void mouseMoveEvent(QMouseEvent *e);
		void setSkin(QString, QString);
//		void httpGetFinished(bool result);
		void catalogBuilt(int,int);
		void inputMethodEvent(QInputMethodEvent* e);
		void keyPressEvent(QKeyEvent*);
		void inputKeyPressEvent(QKeyEvent* key);
		void altKeyPressEvent(QKeyEvent* key);
		void focusOutEvent(QFocusEvent* evt);
		void setOpaqueness(int val);
		void setFadeLevel(double);
		void finishedFade(double d);
		void menuEvent(QContextMenuEvent*);
		void buildCatalog();
		void _buildCatalog(CATBUILDMODE,uint);
		void updateSuccess();
		void startSync();
		void _startSync(int mode,int silence);
		void updateApp();
		//	void bookmark_finished(bool error);
		void testAccountFinished(bool err,QString result);
		void bmSyncFinishedStatus(int status);
		void bmSyncerFinished();
		void reSync();
		void stopSync();
		void testAccount(const QString&name,const QString& password);
		void startSilentUpdate();
		void silentUpdateFinished();
		void getFavicoFinished();
		void configModify(int type);
		void storeConfig(int mode=0);
		void restoreUserCommand();
		int checkLocalBmDatValid();
#ifdef CONFIG_DIGG_XML
		void diggXmlFinished(int status);
		void startDiggXml();
		void loadDiggXml();
#endif
#ifdef CONFIG_ACTION_LIST
		//void importNetBookmarkFinished(int status);
		//void importNetBookmark(CATBUILDMODE mode,uint browserid);
#endif
private slots:
		void setIcon(int type,const QString& tip);
		void iconActivated(QSystemTrayIcon::ActivationReason reason);
};
void kickoffSilentUpdate();
bool CatLess(CatItem * a, CatItem * b);
#endif
