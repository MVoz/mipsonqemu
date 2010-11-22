#ifndef UPDATER_THREAD_H
#define UPDATER_THREAD_H

#include <config.h>
#include <globals.h>
#include <bmxml.h>
#include <bmnet.h>

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
	QDateTime* updateTime;
	QMutex mutex;
	QSettings *localSettings;
	QSettings *serverSettings;
	
	QString host;
	QString url;
	QString updaterFilename;
	QString downloadFilename;
	QString md5;
	QString destdir;
	QString branch;
	QString savefilename;
	
	int retryTime;
	int mode;
	int statusCode;
	int errCode;

public:
	GetFileHttp(QObject * parent = 0,QSettings* s=0,int mode=0,QString md5="");	
	~GetFileHttp();
	void clearObject();
	void setHost(const QString& s){host = s;}
	void setUrl(const QString &s){url = s;updaterFilename=s;}
	void setServerBranch(const QString &s){branch = s;}
	void setSaveFilename(const QString &s){savefilename = s;}
	void run();
	int newHttp();
	void setProxy(QNetworkProxy& p);
	void setDestdir(const QString& s){destdir = s;}
	void sendUpdateStatusNotify(int flag,int type);
public slots: 
		void getFileDone(bool error);
		void on_http_responseHeaderReceived(const QHttpResponseHeader & resp);
		void httpTimeout();
		void terminateThread();
signals:
		void  getIniDoneNotify(int error);
		void  getFileDoneNotify(int error);
		void updateStatusNotify(int type,int status);

};

class  UPDATER_THREAD_DLL_CLASS_EXPORT appUpdater:public MyThread
{
	Q_OBJECT;
public:
	QSettings *localSettings;
	QSettings *serverSettings;
	int timers;
	testNet *testThread;
	GetFileHttp *fh;
	QSemaphore sem_downfile_success;
	QSemaphore sem_downfile_start;
	int needed;
	int error;
	int mode;
	bool needwatchchild;
public:
	appUpdater(QObject * parent = 0,QSettings* s=0,int m=0):MyThread(parent,s),mode(m)
	{
		timers=0;
		needed=0;
		error=0;
		localSettings =NULL;
		serverSettings =NULL;
		testThread =NULL;
		fh = NULL;
		needwatchchild = false;
	}
	~appUpdater();
	void run();
	void clearObject();
	void downloadFileFromServer(QString pathname,int mode,QString checksum);
	int checkToSetiing(QSettings *settings,const QString &filename1,const uint& version1);
	void mergeSettings(QSettings* srcSettings,QSettings* dstSetting,int mode);
	void checkSilentUpdateApp();
	void sendUpdateStatusNotify(int flag,int type);

public slots: 
	void getIniDone(int err);
	void getFileDone(int err);
	void testNetFinished();
	void terminateThread();
	void monitorTimeout();

signals:
	void updateStatusNotify(int type,int status);
};
#endif
