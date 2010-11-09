#ifndef UPDATER_THREAD_H
#define UPDATER_THREAD_H

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
#include <log.h>
#include <QtCore/qobject.h>
#include <QSemaphore>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkAccessManager>
#include "testserver.h"

#define UPDATE_SILENT_MODE 0
#define UPDATE_DLG_MODE 1

#if defined(UPDATER_THREAD_DLL)
#define UPDATER_THREAD_DLL_CLASS_EXPORT __declspec(dllexport)
#else
#define UPDATER_THREAD_DLL_CLASS_EXPORT __declspec(dllimport)
#endif

#define UPDATE_FILE_PREFIX "ramen_launchy_"
#define UPDATE_MODE_GET_INI 1
#define UPDATE_MODE_GET_FILE 2
#define UPDATE_MAX_RETRY_TIME 3
#define HTTP_OK 200
#define HTTP_FILE_NOT_FOUND 404




#define SETTING_MERGE_LOCALTOSERVER  0
#define SETTING_MERGE_SERVERTOLOCAL  1

#define VERSION_INFO(x) (((x.at(0).toInt())<<24) | ((x.at(1).toInt())<<16) | ((x.at(2).toInt())<<8) | ((x.at(3).toInt())))
class  UPDATER_THREAD_DLL_CLASS_EXPORT GetFileHttp:public MyThread
{
	Q_OBJECT;
public:
	QHttp * http[UPDATE_MAX_RETRY_TIME];
	QTimer *httpTimer[UPDATE_MAX_RETRY_TIME];
	QFile *file[UPDATE_MAX_RETRY_TIME];
	QString host;
	QString url;
	//	QString filename;
	QString updaterFilename;
	QString downloadFilename;
	QString md5;

	QDateTime* updateTime;
	QSettings *localSettings;
	QSettings *serverSettings;
	QMutex mutex;
	int retryTime;
	int mode;
	int statusCode;
	int errCode;
	QString destdir;
	QString branch;
	QString savefilename;
#if 0
	//public:
	//		int terminateFlag;
	//		QTimer* monitorTimer;
	//		void setTerminateFlag(int f)
	//		{
	terminateFlag=f;
}
public slots:
	void monitorTimerSlot();
#endif
public:
	GetFileHttp(QObject * parent = 0,int mode=0,QString md5="");	
	~GetFileHttp();
	void clearObject();
	void setHost(const QString& s){host = s;}
	void setUrl(const QString &s){url = s;updaterFilename=s;}
	void setServerBranch(const QString &s){branch = s;}
	void setSaveFilename(const QString &s){savefilename = s;}
	void run();
	//	void	downloadFileFromServer(const QString &filename,int mode,uint checksum);
	int newHttp();
	void setProxy(QNetworkProxy& p);
	void setDestdir(const QString& s){destdir = s;}
	public slots: 
		//void updaterDone(bool error);
		void getFileDone(bool error);
	/*
		void on_http_stateChanged(int stat);
		void on_http_dataReadProgress(int done, int total);
		void on_http_dataSendProgress(int done, int total);
		void on_http_requestFinished(int id, bool error);
		void on_http_requestStarted(int id);
	*/
		void on_http_responseHeaderReceived(const QHttpResponseHeader & resp);
		void httpTimerSlot();
		void terminateThread();
signals:
		void  getIniDoneNotify(int error);
		void  getFileDoneNotify(int error);
		void updateStatusNotify(int type,int status);

};

class  UPDATER_THREAD_DLL_CLASS_EXPORT updaterThread:public MyThread
{
	Q_OBJECT;

public:
	//QDateTime* updateTime;
	QSettings *settings;
	QSettings *localSettings;
	QSettings *serverSettings;
	int timers;
	testServerThread *testThread;
	GetFileHttp *fh;
	QSemaphore sem_downfile_success;
	QSemaphore sem_downfile_start;
	int needed;
	int error;
	//QSemaphore testNet;
	//QNetworkAccessManager *manager;
	//QNetworkReply *reply;
	//QTimer* testNetTimer;
	int mode;
	bool needwatchchild;
#if 0	
public:
	int terminateFlag;
	QTimer* monitorTimer;
	void setTerminateFlag(int f)
	{
		terminateFlag=f;
	}
	public slots:
		void monitorTimerSlot();
#endif
public:
	updaterThread(QObject * parent = 0,int m=0,QSettings* s=0):MyThread(parent),mode(m),settings(s)
	{
		timers=0;
		needed=0;
		error=0;
		localSettings =NULL;
		serverSettings =NULL;
		//updateTime =NULL;
		//monitorTimer =NULL;
		//terminateFlag = 0;
		//testNetTimer =NULL;
		testThread =NULL;
		fh = NULL;
		needwatchchild = false;
	}
	~updaterThread();
	void run();
	void clearObject();
	void downloadFileFromServer(QString pathname,int mode,QString checksum);
	int checkToSetiing(QSettings *settings,const QString &filename1,const uint& version1);
	void mergeSettings(QSettings* srcSettings,QSettings* dstSetting,int mode);
	void checkSilentUpdateApp();

	public slots: 
		void getIniDone(int err);
		void getFileDone(int err);
		//void testNetFinished(QNetworkReply*);
		void testNetFinished();
		void terminateThread();
		void monitorTimerSlot();
		//void testNetTimeout();

signals:
		//	void  updaterDoneNotify(bool error);
		void updateStatusNotify(int type,int status);
		//	void testNetTerminateNotify();
		//	void getFileTerminateNotify();

};
#endif
