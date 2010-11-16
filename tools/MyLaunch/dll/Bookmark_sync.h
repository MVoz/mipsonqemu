#ifndef BOOKMARK_SYNC_H
#define BOOKMARK_SYNC_H

#include <QThread>
#include <QtNetwork/QHttp>
#include <QBuffer>
#include <QString>
#include <QEventLoop>

#include <boost/shared_ptr.hpp>

#include <QMutex>
#include <QDialog>
#include <QtNetwork/QHttpResponseHeader>
#include <QTimer>
#include <QFile>
#include <QtNetwork/QHttp>
#include <QSettings>
#include <QTimerEvent>
#include <config.h>
#include <globals.h>
#include <xmlreader.h>
#include <QtNetwork/QNetworkProxy>
#include <log.h>
#include "mergethread.h"
#include <QtCore/qobject.h>

#include <QSqlDatabase>
#include <QtSql>
#include "testserver.h"


#include "posthttp.h"
using namespace boost;
#define BM_EQUAL 1
#define BM_MODIFY 2
#define BM_DELETE 3
#define BM_DIFFERENT 4
#define BM_ADD 5

#define MERGE_FROM_SERVER 0
#define MERGE_FROM_LOCAL 1

#define ACTION_ITEM_DELETE 0
#define ACTION_ITEM_ADD 1

#define MERGE_TYPE_EQUAL_UNDO 0
#define MERGE_TYPE_EQUAL_ADD 1

#define NAME_IS_FILE 1
#define NAME_IS_DIR 2

#define	POST_HTTP_TYPE_TESTACCOUNT  1
#define POST_HTTP_TYPE_HANDLE_ITEM 2


#if defined(BOOKMARK_SYNC_DLL)
#define BOOKMARK_SYNC_CLASS_EXPORT __declspec(dllexport)
#else
#define BOOKMARK_SYNC_CLASS_EXPORT __declspec(dllimport)
#endif
#define BOOKMARK_SYNC_MODE	0
#define BOOKMARK_TESTACCOUNT_MODE  1
class BOOKMARK_SYNC_CLASS_EXPORT BookmarkSync:public MyThread
{
	Q_OBJECT;

public:
	QHttp * http;
	postHttp *accountTestHttp;
	QTimer* httpTimer;
	QSemaphore *semaphore;
	QString host;
	QString url;
	QString username;
	QString password;
	QFile *file;
	QSettings * settings;
	int mode;
	QBuffer* resultBuffer;
	int http_finish;
	int http_timerover;
	QSqlDatabase *db;
	mergeThread *mgthread;
	int error;
	uint httpProxyEnable;
	QString filename_fromserver;
	testServerThread *testThread;
	volatile int testServerResult;
	volatile bool needwatchchild;
	QString md5key;
public:
	BookmarkSync(QObject * parent = 0,QSqlDatabase *db=0,QSettings* s=0,QSemaphore* p=NULL,int m=BOOKMARK_SYNC_MODE);
	~BookmarkSync();
	void setHost(const QString& s){host = s;}
	void setUrl(const QString& s){url = s;}
	void setUsername(const QString& s){	username = s;}
	void setPassword(const QString& s){password = s;}
	void run();
	public slots: 
		void bookmarkGetFinished(bool error);
		void testAccountFinished(bool error);
		void on_http_responseHeaderReceived(const QHttpResponseHeader & resp);
		void mergeDone();
		void httpTimerSlot();
		void mgUpdateStatus(int flag,int status);
		void testNetFinished();
		void terminateThread();
		void monitorTimerSlot();
		void clearobject();
signals:
		void bmSyncFinishedStatusNotify(bool error);
		void updateStatusNotify(int type,int status);
		void readDateProgressNotify(int done, int total);
		void testAccountFinishedNotify(bool error,QString result);
};

#define LOCAL_EXIST_OFFSET  2
#define LASTUPDATE_EXIST_OFFSET 1
#define SERVER_EXIST_OFFSET 0
#endif
