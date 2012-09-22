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

class DIGG_XML_CLASS_EXPORT diggXml:public NetThread
{
	Q_OBJECT;
public:
	DoNetThread *donetThread;	
	
	volatile int testDiggXmlResult;
	volatile bool needwatchchild;	
	uint diggid;
	
public:
	diggXml(QObject * parent = 0,QSettings* s=0);
	~diggXml();
	void setDiggId(uint id){diggid = id;}	
	void run();
public slots: 
	void diggXmlGetFinished(bool error);
	void testNetFinished();
	void terminateThread();
	void monitorTimeout();
	virtual void cleanObjects();
signals:
	void diggXmlFinishedStatusNotify(int status);
};
#endif
