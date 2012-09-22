#ifndef FILE_GET_H
#define FILE_GET_H

#include <config.h>
#include <globals.h>
#include <bmxml.h>
#include <bmnet.h>

#if defined(FILE_GET_DLL)
#define FILE_GET_DLL_CLASS_EXPORT __declspec(dllexport)
#else
#define FILE_GET_DLL_CLASS_EXPORT __declspec(dllimport)
#endif

#define UPDATE_FILE_PREFIX "ramen_launchy_"
#define UPDATE_MODE_GET_INI 1
#define UPDATE_MODE_GET_FILE 2
#define UPDATE_MAX_RETRY_TIME 3


class FILE_GET_DLL_CLASS_EXPORT GetFileHttp:public NetThread
{
	Q_OBJECT;
public:
	QString updaterFilename;
	QString md5;
	QString destdir;
	QString branch;
	QString savefilename;
	
	int retryTime;
	int errCode;

public:
	GetFileHttp(QObject * parent = 0,QSettings* s=0,int mode=0,QString md5="");	
	~GetFileHttp();
	void setUrl(const QString &s){url = s;updaterFilename=s;}
	void setServerBranch(const QString &s){branch = s;}
	void setSaveFilename(const QString &s){savefilename = s;}
	void run();
	int newHttpX();
	void setDestdir(const QString& s){destdir = s;}
public slots: 
		void downloadFileDone(bool error);
		void monitorTimeout();
		void terminateThread();
		virtual void cleanObjects();
};
#endif
