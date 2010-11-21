#ifndef BOOKMARK_SYNC_H
#define BOOKMARK_SYNC_H

#include <config.h>
#include <globals.h>
#include <bmnet.h>
#include <bmMerge.h>
#include <posthttp.h>


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
class BOOKMARK_SYNC_CLASS_EXPORT bmSync:public MyThread
{
	Q_OBJECT;
public:
	QFile *file;
	QBuffer* resultBuffer;
	QTimer* httpTimer;
	QSemaphore *semaphore;
	QSqlDatabase *db;
	
	QString host;
	QString url;
	QString username;
	QString password;
	QString filename_fromserver;
	QString md5key;
	
	int mode;	
	int http_finish;
	int http_timerover;	
	int status;

	volatile int testServerResult;
	volatile bool needwatchchild;	
	
	testNet *testThread;
	bmMerge *mgthread;
	QHttp * http;
	
public:
	bmSync(QObject * parent = 0,QSettings* s=0,QSqlDatabase *db=0,QSemaphore* p=NULL,int m=BOOKMARK_SYNC_MODE);
	~bmSync();
	void setHost(const QString& s){host = s;}
	void setUrl(const QString& s){url = s;}
	void setUsername(const QString& s){username = s;}
	void setPassword(const QString& s){password = s;}
	void run();
public slots: 
	void bmxmlGetFinished(bool error);
	void testAccountFinished(bool error);
	void on_http_responseHeaderReceived(const QHttpResponseHeader & resp);
	void mergeDone();
	void httpTimeout();
	void mgUpdateStatus(int flag,int status);
	void testNetFinished();
	void terminateThread();
	void monitorTimeout();
	void clearobject();
signals:
	void bmSyncFinishedStatusNotify(int status);
	void updateStatusNotify(int type,int status);
	void readDateProgressNotify(int done, int total);
	void testAccountFinishedNotify(bool error,QString result);
};

#define LOCAL_EXIST_OFFSET  2
#define LASTUPDATE_EXIST_OFFSET 1
#define SERVER_EXIST_OFFSET 0
#endif
