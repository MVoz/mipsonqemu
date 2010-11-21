#ifndef TEST_SERVER_H
#define TEST_SERVER_H

#include <config.h>
#include "globals.h"

#if defined(TEST_SERVER_DLL)
#define TEST_SERVER_DLL_CLASS_EXPORT __declspec(dllexport)
#else
#define TEST_SERVER_DLL_CLASS_EXPORT __declspec(dllimport)
#endif
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
	
public slots:
	virtual void monitorTimeout();
public:
	void run();
	virtual void setTerminateFlag(int f);
	virtual void terminateThread();
};
class  TEST_SERVER_DLL_CLASS_EXPORT testNet:public MyThread
{
	Q_OBJECT;
public:
	QNetworkAccessManager *manager;
	QNetworkReply *reply;
	QTimer* testNetTimer;
public:
	testNet(QObject * parent = 0,QSettings* s=0);
	~testNet(){};
	void run();
	void clearObject();
public slots: 
	void testServerFinished(QNetworkReply*);
	void testServerTimeout();
	void terminateThread();
};
#endif