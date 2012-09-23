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
#include <QTextBrowser>
#include <diggxml.h>
#endif
#include <QProcess>
//#include <weby>
#if 1
class QLineEditMenu : public QTextEdit
{
	Q_OBJECT
public:
	QLineEditMenu(QWidget* parent = 0) :
	QTextEdit(parent) {setAttribute(Qt::WA_InputMethodEnabled);}
	void contextMenuEvent(QContextMenuEvent *evt) {
		emit menuEvent(evt);
	}
signals:
	void menuEvent(QContextMenuEvent*);
};

#else
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
#endif
class LineEditStyle : public QCommonStyle
{
public:
  int  pixelMetric(PixelMetric metric, const QStyleOption *option = 0, const QWidget *widget = 0) const{
  		
		  if (metric == QStyle::PM_TextCursorWidth){
		//  	QDEBUG_LINE;
		    return 3;

		  }
		 
		  return QCommonStyle::pixelMetric(metric,option,widget);
  	}
};

class QCharLineEdit : public QLineEdit
{
	Q_OBJECT
public:
	QCharLineEdit(QWidget* parent = 0) : 
	QLineEdit(parent) 
	{
		setAttribute(Qt::WA_InputMethodEnabled);
		setAttribute( Qt::WA_KeyCompression,true );
	//	setStyle(new LineEditStyle);
	//	setStyleSheet(QString("QLineEdit { padding-left: %25px; )}"));
#ifdef CONFIG_INPUT_WITH_ICON
	searchIcon = new QToolButton(this);
         QPixmap pixmap("google.png");
         searchIcon->setIcon(QIcon(pixmap));
         searchIcon->setIconSize(pixmap.size());
         searchIcon->setCursor(Qt::ArrowCursor);
         searchIcon->setStyleSheet("QToolButton { border: none; padding: 0px; }");
         searchIcon->hide();
         //connect(clearButton, SIGNAL(clicked()), this, SLOT(clear()));
      //   connect(this, SIGNAL(textChanged(const QString&)), this, SLOT(updateCloseButton(const QString&)));
        int frameWidth = style()->pixelMetric(QStyle::PM_DefaultFrameWidth);
      //  setStyleSheet(QString("QLineEdit { padding-left: %20px; color: #396285;image: url(:/skins/Default/input.png)} ").arg(searchIcon->sizeHint().width() + frameWidth + 1));
        QSize msz = minimumSizeHint();
        setMinimumSize(qMax(msz.width(), searchIcon->sizeHint().height() + frameWidth * 2 + 2),
                 qMax(msz.height(), searchIcon->sizeHint().height() + frameWidth * 2 + 2));
	
#endif
	
	}

	void keyPressEvent(QKeyEvent* key) {
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
#if 1
	  bool normalInputMethod = false;
	  for (int i = 0; i < e->attributes().size(); ++i) {
	        const QInputMethodEvent::Attribute &a = e->attributes().at(i);
	        if (a.type == QInputMethodEvent::Cursor) {
			//TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<< a.start<<a.length);
			normalInputMethod = a.length?true:false;
	         } 
	    }
#endif
		if(!normalInputMethod){
			QLineEdit::inputMethodEvent(e);
		}
				
		//TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<e->commitString()<<e->preeditString()<<displayText()<<text()<<e->spontaneous());
		if (e->commitString() != "") {			
			if(normalInputMethod)
				QLineEdit::inputMethodEvent(e);
			emit inputMethod(e);
		}
		repaint();
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
#ifdef CONFIG_INPUT_WITH_ICON
protected:
	void resizeEvent(QResizeEvent *){
		
		
		 QSize sz = searchIcon->sizeHint();
       		int frameWidth = style()->pixelMetric(QStyle::PM_DefaultFrameWidth);
       		//searchIcon->move(rect().right() - frameWidth - sz.width(),
                  //      (rect().bottom() + 1 - sz.height())/2);
		searchIcon->move(rect().left() + frameWidth ,
                        (rect().bottom() + 1 - sz.height())/2);
			TD(DEBUG_LEVEL_NORMAL,rect().right() <<frameWidth<<sz.width()<<sz.height());
			searchIcon->show();
	}
private:
	QToolButton *searchIcon;
#endif
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
#ifdef CONFIG_DIGG_XML
class diggXmler : public QThread
{
	Q_OBJECT
private:
	QTextBrowser *textoutput;
	QList<bookmark_catagory> diggXmllist;
	QTimer* diggxmlDisplayTimer;
	uint diggxmlDisplayIndex;
	QString diggxmloutputFormat;
public:
	diggXmler(QObject* parent = NULL,QTextBrowser* t=NULL)
		: QThread(parent),textoutput(t) {
			diggxmlDisplayIndex = 0;			
		}
	~diggXmler() {
		DELETE_TIMER(diggxmlDisplayTimer);
	}
	void stop() {
		exit();
	}
	void run(){
		loadDiggXml();
		START_TIMER_INSIDE(diggxmlDisplayTimer,false,10*SECONDS,diggxmlDisplayTimeout);
		connect(this->parent(), SIGNAL(diggXmlNewSignal()), this, SLOT(loadDiggXml()));	
		QDEBUG_LINE;
		exec();
	}
			
	void setDiggXmlFormat(QString& s){
			diggxmloutputFormat = s;
	     }	
	uint getMaxDiggid(){
		if(diggXmllist.size()){
			bookmark_catagory bc = diggXmllist.at(0);
			return bc.bmid;
		}
		return 0;
	}
public slots:
	void diggxmlDisplayTimeout();
	void loadDiggXml();
	signals:
	void diggxmlNotify(QString s);

};
#endif

struct  TIMER_ACTION_LIST{
	char actionType;
	char enable;//0x01--enable  0x02--in queue
	uint startAfterRun;
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
#ifdef CONFIG_DIGG_XML
	QTextBrowser *diggxmloutput;
	diggXmler*   diggxmler;
#endif
	QString outputFormat;
	QTimer* dropTimer;	
	QTimer* syncStatusTimer;
	QCharListWidget *alternatives;
	QPushButton *opsButton;
	QPushButton *minButton;
	QPushButton *userButton;
	QPushButton *homeButton;
	QPushButton *syncButton;
	QPushButton *baiduButton;
	QPushButton *googleButton;
	QPushButton *goButton;
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
	int syncMode;
	QList<DoNetThread*> getfavicolist;

	shared_ptr < synchronizeDlg> syncDlg;
	shared_ptr < synchronizeDlg> testAccountDlg;
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
	void updateMainDisplay(CatItem* t);
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
	void getFavico(const QString& host,const QString& f);
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
	volatile int maincloseflag;
	QTimer* monitorTimer;
	OptionsDlg *ops;
	QString shortkeyString;
	uint syncStatus;
	QString iconOnLabel;
	QString pathOnoutput;
//	QString defBrowser;
#ifdef CONFIG_AUTO_LEARN_PROCESS
	uint learnProcessTimes;
#endif

public slots:
		void monitorTimerTimeout();
		void updateSuccessTimeout();
		void menuOptions();
		void homeBtnPressed();
		void userBtnPressed();
		void googleBtnPressed();
		void baiduBtnPressed();
		void goBtnPressed();
		void minBtnPressed();
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
		void syncStatusTimeout();
		void setAlwaysShow(bool);
		void setAlwaysTop(bool);
		void setPortable(bool);
		void mousePressEvent(QMouseEvent *e);
		void mouseMoveEvent(QMouseEvent *e);
#ifdef CONFIG_SKIN_CONFIGURABLE
		void setSkin(QString, QString);
#endif
//		void httpGetFinished(bool result);
		void catalogBuilt(int,int);
		void inputMethodEvent(QInputMethodEvent* e);
		void keyPressEvent(QKeyEvent*);
		void inputKeyPressEvent(QKeyEvent* key);
		void altKeyPressEvent(QKeyEvent* key);
		void focusOutEvent(QFocusEvent* evt);
		void itemSelectionChangedEvent();
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
		void testAccountFinished();
		void bmSyncFinishedStatus(int status);
		void bmSyncerFinished();
		void reSync();
		void stopSync();
		void _startTestAccount(const QString&name,const QString& password);
		void startSilentUpdate();
		void silentUpdateFinished();
		void getFavicoFinished();
		void configModify(int type);
		void storeConfig(int mode=0);
		void restoreUserCommand();
		int checkLocalBmDatValid();
#ifdef CONFIG_DIGG_XML
		void diggXmlFinished();
		void startDiggXml();
		void displayDiggxml(QString s);
		void diggxmloutputAnchorClicked( const QUrl & link );
#endif
		void updateSearcherDisplay();
		void _updateSearcherDisplay(const QString&,const QString&);

#ifdef CONFIG_ACTION_LIST
		//void importNetBookmarkFinished(int status);
		//void importNetBookmark(CATBUILDMODE mode,uint browserid);
#endif
private slots:
		void setIcon(int type,const QString& tip);
		void iconActivated(QSystemTrayIcon::ActivationReason reason);
#ifdef CONFIG_DIGG_XML
	signals:
		void diggXmlNewSignal();
#endif

};
void kickoffSilentUpdate();
bool CatLess(CatItem * a, CatItem * b);
#endif
