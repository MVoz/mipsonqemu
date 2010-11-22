#ifndef UPDATER_THREAD_H
#define UPDATER_THREAD_H

#include <config.h>
#include <globals.h>
#include <bmxml.h>
#include <bmnet.h>
#include <fileget.h>

#if defined(UPDATER_THREAD_DLL)
#define UPDATER_THREAD_DLL_CLASS_EXPORT __declspec(dllexport)
#else
#define UPDATER_THREAD_DLL_CLASS_EXPORT __declspec(dllimport)
#endif

#define UPDATE_FILE_PREFIX "ramen_launchy_"
#define UPDATE_MODE_GET_INI 1
#define UPDATE_MODE_GET_FILE 2
#define UPDATE_MAX_RETRY_TIME 3

#define SETTING_MERGE_LOCALTOSERVER  0
#define SETTING_MERGE_SERVERTOLOCAL  1

class  UPDATER_THREAD_DLL_CLASS_EXPORT appUpdater:public MyThread
{
	Q_OBJECT;
public:
	QSettings *localSettings;
	QSettings *serverSettings;
	int timers;
	testNet *testThread;
	GetFileHttp *fh;
	//QSemaphore sem_downfile_success;
	//QSemaphore sem_downfile_start;
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
	int checkToSetting(QSettings *s,const QString &filename1,const QString& md51);
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
