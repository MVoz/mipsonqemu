#ifndef DIGG_XML_H
#define DIGG_XML_H

#include <config.h>
#include <globals.h>
#include <bmnet.h>
#if defined(DIGG_XML_DLL)
#define DIGG_XML_CLASS_EXPORT __declspec(dllexport)
#else
#define DIGG_XML_CLASS_EXPORT __declspec(dllimport)
#endif

class DIGG_XML_CLASS_EXPORT diggXml:public MyThread
{
	Q_OBJECT;
public:
	QFile *file;
	//QBuffer* resultBuffer;
	//QTimer* httpTimer;
	
	QString host;
	QString url;
	QString diggxml_fromserver;
	QString md5key;
	
	int mode;	
	//int http_finish;
	//int http_timerover;	
	int status;

	volatile int testDiggXmlResult;
	volatile bool needwatchchild;	
	
	testNet *testThread;
	//QHttp * http;
	uint diggid;
	
public:
	diggXml(QObject * parent = 0,QSettings* s=0);
	~diggXml(){};
	void setHost(const QString& s){host = s;}
	void setUrl(const QString& s){url = s;}
	void setDiggId(uint id){diggid = id;}	
	void run();
public slots: 
	void diggXmlGetFinished(bool error);
	void on_http_responseHeaderReceived(const QHttpResponseHeader & resp);
//	void httpTimeout();
	void testNetFinished();
	void terminateThread();
	void monitorTimeout();
	void clearobject();
signals:
	void diggXmlFinishedStatusNotify(int status);
};
#endif
