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
enum httpState
{
	HTTP_UNCONNECTED,
	HTTP_HOSTLOOKUP,
	HTTP_CONNECTING,
	HTTP_SENDING,
	HTTP_READING,
	HTTP_CONNECTED,
	HTTP_CLOSING,
	HTTP_TIMEOUT,
	HTTP_TEST_ACCOUNT_SUCCESS,
	HTTP_TEST_ACCOUNT_FAIL,
	HTTP_GET_INI_FAILED,
	HTTP_GET_INI_SUCCESSFUL,
	HTTP_GET_INI_NOT_EXISTED,
	HTTP_GET_FILE_SUCCESSFUL,
	HTTP_GET_FILE_NOT_EXISTED,
	HTTP_GET_FILE_FAILED,
	UPDATE_FAILED,
	UPDATE_SUCCESSFUL,
	HTTP_NEED_RETRY,
	UPDATE_NO_NEED,
	UPDATE_NET_ERROR,
	BOOKMARK_SYNC_START,
	UPDATE_PROCESSING,
	SYNC_SUCCESSFUL,
	LOGIN_FALIL
};

#if defined(BOOKMARK_SYNC_DLL)
#define BOOKMARK_SYNC_CLASS_EXPORT __declspec(dllexport)
#else
#define BOOKMARK_SYNC_CLASS_EXPORT __declspec(dllimport)
//#define BOOKMARK_SYNC_CLASS_EXPORT 
#endif
#define BOOKMARK_SYNC_MODE	0
#define BOOKMARK_TESTACCOUNT_MODE  1
class BOOKMARK_SYNC_CLASS_EXPORT BookmarkSync:public QThread
{
	Q_OBJECT;

      public:
	QHttp * http;
	postHttp *accountTestHttp;
	QNetworkProxy* netProxy;
	QTimer* httpTimer;
	QString host;
	QString url;
	QString username;
	QString password;
	//QEventLoop loop;
	QFile *file;
	//QDateTime* updateTime;
	QString iePath;
	QSettings * settings;
	int mode;
	QBuffer* resultBuffer;
	int http_finish;
	int http_timerover;
	QSqlDatabase *db;
	mergeThread *mgthread;
	int error;
	uint httpProxyEnable;
#ifdef CONFIG_HTTP_TIMEOUT
//	uint httpTimeout;
//	uint httpTimerId;
#endif
      public:
	 BookmarkSync(QObject * parent = 0,QSqlDatabase *db=0,QSettings* s=0,QString path="",int m=BOOKMARK_SYNC_MODE);	
	~BookmarkSync()
	{
	QDEBUG("~BookmarkSync.....");
	}
	void setHost(QString str)
	{
		host = str;
	}
	void setUrl(QString str)
	{
		url = str;
	}
	void setUsername(QString str)
	{
		username = str;
	}
	void setPassword(QString str)
	{
		password = str;
	}
	void run();
	//void quit();
#ifdef CONFIG_HTTP_TIMEOUT
     	// protected:
	//void timerEvent(QTimerEvent * event);
#endif
	public slots: 
	void bookmarkGetFinished(bool error);
	void testAccountFinished(bool error);
//      void httpRequestFinished(int id,bool  error);
//      void httpRequestStarted(int id);
	void on_http_stateChanged(int stat);
	void on_http_dataReadProgress(int done, int total);
	void on_http_dataSendProgress(int done, int total);
	// void on_http_done(bool error);
	void on_http_requestFinished(int id, bool error);
	void on_http_requestStarted(int id);
	void on_http_responseHeaderReceived(const QHttpResponseHeader & resp);
	void mergeDone();
	void httpTimerSlot();
	void stopSync();
	void setNetworkProxy();
	void mgUpdateStatus(int flag,int status,QString str);
      signals:
	void bookmarkFinished(bool error);
	void updateStatusNotify(int type,int status,QString str);
	void readDateProgressNotify(int done, int total);
	void testAccountFinishedNotify(bool error,QString result);

};

#define LOCAL_EXIST_OFFSET  2
#define LASTUPDATE_EXIST_OFFSET 1
#define SERVER_EXIST_OFFSET 0
#endif
