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
#define UPDATE_MAX_RETRY_TIME 3


class  UPDATER_THREAD_DLL_CLASS_EXPORT appUpdater:public NetThread
{
	Q_OBJECT;
public:
	QSettings *localSettings;
	QSettings *serverSettings;
	int timers;
	DoNetThread *doNetThread;
//	GetFileHttp *fh;
	int needed;
	int error;
//	int mode;
	bool needwatchchild;
public:
	appUpdater(QObject * parent = 0,QSettings* s=0):NetThread(parent,s)
	{
		timers=0;
		needed=0;
		error=0;
		localSettings =NULL;
		serverSettings =NULL;
		doNetThread =NULL;
		needwatchchild = false;
	}
	~appUpdater();
	void run();
	void downloadFileFromServer(QString pathname,int mode,QString checksum);
//	int checkToSetting(QSettings *s,const QString &filename1,QString& md51);
	int mergeSettings(QSettings* ,QSettings* ,int );
	void checkSilentUpdateApp();
//	void sendUpdateStatusNotify(int);
public slots: 
	void getUpdateINIDone(int);
	void testNetFinished(int);
	void terminateThread();
	void monitorTimeout();
	virtual void cleanObjects();

//signals:
//	void updateStatusNotify(int type,int status,int icon);
};
#endif
