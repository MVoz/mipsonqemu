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
#define UPDATE_FILE_PREFIX "ramen_launchy_"
#define UPDATE_MODE_GET_INI 1
#define UPDATE_MODE_GET_FILE 2
#define UPDATE_MAX_RETRY_TIME 3
#define HTTP_OK 200

#define UPDATE_FILE_NAME "update.ini"
#define UPDATE_SERVER_HOST "192.168.115.2"
#define UPDATE_SERVER_URL "update.ini"

#define SETTING_MERGE_LOCALTOSERVER  0
#define SETTING_MERGE_SERVERTOLOCAL  1



#define VERSION_INFO(x) (((x.at(0).toInt())<<24) | ((x.at(1).toInt())<<16) | ((x.at(2).toInt())<<8) | ((x.at(3).toInt())))
class  GetFileHttp:public QThread
{
	Q_OBJECT;
public:
	QHttp * http[3];
	QTimer* httpTimer;
	QString host;
	QString url;
//	QString filename;
	QString updaterFilename;
	QString downloadFilename;
	QFile *file;
	QDateTime* updateTime;
	QSettings *localSettings;
	QSettings *serverSettings;
	QMutex mutex;
	int retryTime;
	int mode;
	int statusCode;
	int errCode;
public:
	 GetFileHttp(QObject * parent = 0,int mode=0,QString name="");	
	~GetFileHttp()
	{
		if(file){
			file->close();
			delete file;
			file=NULL;
		}
		if(http)
			{
				http->close();
			}
	}
	void setHost(QString str)
	{
		host = str;
	}
	void setUrl(QString str)
	{
		url = str;
		updaterFilename=str;
	}
	void run();
	void	downloadFileFromServer(const QString &filename,int mode);
public slots: 
	//void updaterDone(bool error);
	void getFileDone(bool error);
	void on_http_stateChanged(int stat);
	void on_http_dataReadProgress(int done, int total);
	void on_http_dataSendProgress(int done, int total);
	void on_http_requestFinished(int id, bool error);
	void on_http_requestStarted(int id);
	void on_http_responseHeaderReceived(const QHttpResponseHeader & resp);
	void httpTimerSlot();
      signals:
	void  getIniDoneNotify(int error);
	void  getFileDoneNotify(int error);
	void updateStatusNotify(int type);
	
};
class  updaterThread:public QThread
{
	Q_OBJECT;

public:
	QDateTime* updateTime;
	QSettings *localSettings;
	QSettings *serverSettings;
	int timers;
	QSemaphore sem1;
	QSemaphore sem2;
	int error;

public:
	 updaterThread(QObject * parent = 0);	
	~updaterThread()
	{
		sem1.release(sem1.available());
		sem2.release(sem2.available());
	}
	void run();
	void downloadFileFromServer(QString pathname,int mode);
	int checkToSetiing(QSettings *settings,const QString &filename1,const QString& version1);
	void mergeSettings(QSettings* srcSettings,QSettings* dstSetting,int mode);

public slots: 
	void getIniDone(int error);
    void getFileDone(int error);
      signals:
//	void  updaterDoneNotify(bool error);
//	void updateStatusNotify(int type);
	
};
#endif