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
class TEST_SERVER_DLL_CLASS_EXPORT MyThread:public QThread
{
	Q_OBJECT;
public:
	MyThread(QObject * parent = 0,QSettings* s=0);
	~MyThread();
public:
	volatile int terminateFlag;
	
	QTimer* monitorTimer;
	QSettings* settings;

//	QString host;
	QString url;
	QString filename;
	
	int http_state;
	uint32 http_timeout;
	int http_send_len;
	int http_rcv_len;
	
	QHttp * http;
	QHttpRequestHeader *header;
	QBuffer* resultBuffer;
	QFile* file;

	int dlgmode;
	
public slots:
	virtual void monitorTimeout();
	virtual void clearObject();
	void httpstateChanged(int state){
		if(http_state!=state)
			http_timeout=0;
		http_state = state;
		TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<state);
		
	}
	void httpdataSendProgress(int len,int total){
		if(http_send_len != len)
			http_timeout=0;
		http_send_len = len;
		TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<http_send_len);
	}
	void httpdataReadProgress(int len,int total){
		if(http_rcv_len != len)
			http_timeout=0;
		http_rcv_len = len;
		TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<http_rcv_len);
	}
	virtual void sendUpdateStatusNotify(int status){
		//if(dlgmode!=UPDATE_DLG_MODE) 
		//	return;
		emit updateStatusNotify(status);
	}
public:
	void run();
	virtual void newHttpX(bool needHeader,bool needBuffer,bool needFile,bool hidden);
//	virtual void newHttpBuffer();
	virtual void setTerminateFlag(int f);
	virtual void terminateThread();
//	virtual void setHost(const QString& s){
//		host = s;
/*
		if(http)
			http->setHost(s);			
		if(header)  
		 	header->setValue("Host", s);

	}
*/
	virtual void setUrl(const QString &s);
	void setFilename(const QString &s);
signals:
	void updateStatusNotify(int status);
};

enum{
	TEST_SERVER_NET = 0,
	TEST_SERVER_VERSION,
	TEST_SERVER_DIGG_XML
};
class  TEST_SERVER_DLL_CLASS_EXPORT testNet:public MyThread
{
	Q_OBJECT;
public:
#ifdef USE_HTTP
	//QHttp * http;
	//QBuffer* resultBuffer;
#else
	QNetworkAccessManager *manager;
	QNetworkReply *reply;
#endif
//	QTimer* testNetTimer;	
	int mode;
	uint id;
public:
	testNet(QObject * parent = 0,QSettings* s=0,int m=TEST_SERVER_NET,int d=0);
	~testNet(){};
	void run();
	void clearObject();
public slots: 	
	void monitorTimeout();
//	void testServerTimeout();
	void terminateThread();
#ifdef USE_HTTP
	void testServerFinished(bool error);
//	void bmxmlstateChanged(int state);
//	void bmxmldataSendProgress(int len,int total);
//	void bmxmldataReadProgress(int len,int total);
#else
	void testServerFinished(QNetworkReply*);
#endif
};
#endif