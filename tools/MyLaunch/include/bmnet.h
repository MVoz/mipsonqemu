#ifndef TEST_SERVER_H
#define TEST_SERVER_H

#include <config.h>
#include "globals.h"

#if defined(TEST_SERVER_DLL)
#define TEST_SERVER_DLL_CLASS_EXPORT __declspec(dllexport)
#else
#define TEST_SERVER_DLL_CLASS_EXPORT __declspec(dllimport)
#endif

#define USE_HTTP
class TEST_SERVER_DLL_CLASS_EXPORT NetThread:public QThread
{
	Q_OBJECT;
public:
	NetThread(QObject * parent = 0,QSettings* s=0,int mode=0);
	~NetThread();
public:
	
	
	QTimer* monitorTimer;
	QSettings* settings;
	QHttp * http;
	QHttpRequestHeader *header;
	QBuffer* resultBuffer;
	QFile* file;

	QString url;
	QString filename;
	QString md5key;	

	volatile int terminateFlag;
	int doWhat;	
	int http_state;
	uint32 http_timeout;
	int http_send_len;
	int http_rcv_len;
	int dlgmode;
	int statusCode;
	int httpRspCode;
	
public slots:
	virtual void monitorTimeout();
	void httpstateChanged(int state){
		if(http_state!=state)
			http_timeout=0;
		http_state = state;
		//TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<state);		
	}
	void httpdataSendProgress(int len,int total){
		if(http_send_len != len)
			http_timeout=0;
		http_send_len = len;
		//TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<http_send_len);
	}
	void httpdataReadProgress(int len,int total){
		if(http_rcv_len != len)
			http_timeout=0;
		http_rcv_len = len;
		//TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<http_rcv_len);
	}
	virtual void sendUpdateStatusNotify(int status){
		//if(dlgmode!=UPDATE_DLG_MODE) 
		//	return;
		statusCode = status;
		emit updateStatusNotify(status);
	}
	virtual void httpResponseHeaderReceived(const QHttpResponseHeader & resp){
		httpRspCode=resp.statusCode();
		if(resp.statusCode() == HTTP_OK)
			md5key = resp.value("md5key");
	}
	virtual void cleanObjects();
public:
	void run();
	virtual void newHttp(bool needHeader,bool needBuffer,bool needFile,bool hidden);
	virtual void setTerminateFlag(int f);
	virtual void terminateThread();
	virtual void setUrl(const QString &s);
	void setFilename(const QString &s);
signals:
	void updateStatusNotify(int status);
};

enum{
	DOWHAT_TEST_SERVER_NET = 0,
	DOWHAT_TEST_SERVER_VERSION,
	DOWHAT_TEST_SERVER_DIGG_XML,
	DOWHAT_GET_BMXML_FILE,
	DOWHAT_POST_ITEM,
	DOWHAT_TEST_ACCOUNT,
};
class  TEST_SERVER_DLL_CLASS_EXPORT DoNetThread:public NetThread
{
	Q_OBJECT;
public:
	uint id;
public:
	DoNetThread(QObject * parent = 0,QSettings* s=0,int m=DOWHAT_TEST_SERVER_NET,int d=0);
	~DoNetThread(){};
	void run();
public slots: 	
	void monitorTimeout();
	void terminateThread();
	void  doHttpFinished(bool error);
	virtual void cleanObjects();
signals:	
	void doNetStatusNotify(int);
};
#endif
