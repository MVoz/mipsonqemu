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


class FILE_GET_DLL_CLASS_EXPORT GetFileHttp:public MyThread
{
	Q_OBJECT;
public:
	//QHttp * http[UPDATE_MAX_RETRY_TIME];
	//QTimer *httpTimer[UPDATE_MAX_RETRY_TIME];
	//QFile *file[UPDATE_MAX_RETRY_TIME];
//	QFile *file;
//	QString host;
//	QString url;
	QString updaterFilename;
//	QString downloadFilename;
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
	~GetFileHttp(){};
	void clearObject();
	//void setHost(const QString& s){host = s;}
	void setUrl(const QString &s){url = s;updaterFilename=s;}
	void setServerBranch(const QString &s){branch = s;}
	void setSaveFilename(const QString &s){savefilename = s;}
	void run();
	int newHttp();
	void setDestdir(const QString& s){destdir = s;}
	void sendUpdateStatusNotify(int flag,int type,int icon);
public slots: 
		void downloadFileDone(bool error);
		void on_http_responseHeaderReceived(const QHttpResponseHeader & resp);
//		void httpTimeout();
		void monitorTimeout();
		void terminateThread();
signals:
		void updateStatusNotify(int type,int status,int icon);

};
#endif
