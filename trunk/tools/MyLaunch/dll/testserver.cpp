#include "testserver.h"
#include <QUrl>
#include <QWaitCondition>
#include <QSemaphore>
#include <QDir>
#include <QStringList>
#include <bmapi.h>
#include "config.h"
MyThread::MyThread(QObject * parent):QThread(parent){
	terminateFlag=0;
	monitorTimer=NULL;
}
MyThread::~MyThread()
{
	DELETE_TIMER(monitorTimer);
}

void MyThread::setTerminateFlag(int f)
{
	terminateFlag=f;
}
void MyThread::monitorTimeout(){
	//qDebug()<<__FUNCTION__<<QThread::currentThreadId();
	/*if(monitorTimer&&monitorTimer->isActive())
	monitorTimer->stop();
	*/
	STOP_TIMER(monitorTimer);
	if(terminateFlag)
		terminateThread();
	else
	{
		//qDebug()<<"restart monitorTimer"<<QThread::currentThreadId();
		monitorTimer->start(10);
	}
}
void MyThread::run(){
/*
	monitorTimer = new QTimer();
	connect(monitorTimer, SIGNAL(timeout()), this, SLOT(monitorTimerSlot()), Qt::DirectConnection);
	monitorTimer->start(10);
	monitorTimer->moveToThread(this);
*/
	START_TIMER_INSIDE(monitorTimer,false,10,monitorTimeout);
}
void MyThread::terminateThread(){
	//qDebug()<<QThread::currentThreadId();
	//if(monitorTimer&&monitorTimer->isActive())
	//	monitorTimer->stop();
	STOP_TIMER(monitorTimer);
}
testServerThread::testServerThread(QObject * parent ):MyThread(parent)
{
	manager = NULL;
	reply = NULL;
	testNetTimer = NULL;
}

testServerThread::~testServerThread()
{
	
}

void testServerThread::testServerFinished(QNetworkReply* reply)
{
	THREAD_MONITOR_POINT;

	//qDebug("network reply error code %d isactive=%d",reply->error(),testNetTimer->isActive());
	/*
	if(testNetTimer->isActive())
	testNetTimer->stop();
	*/
	STOP_TIMER(testNetTimer);
	//DELETE_TIMER(monitorTimer);
	int error=reply->error();
	//qDebug()<<__FUNCTION__<<__LINE__<<error;
	if(!error)
	{
		QString replybuf(reply->readAll());
			//qDebug()<<__FUNCTION__<<__LINE__<<"reply:"<<replybuf;
		if(replybuf.startsWith(QString("1")))
		{
			//qDebug("set testNetResult 1");
			tz::runParameter(SET_MODE,RUN_PARAMETER_TESTNET_RESULT,1);		
			//qDebug("set testNetResult %d",tz::runParameter(GET_MODE,RUN_PARAMETER_TESTNET_RESULT,0));
		}

	}else
		tz::runParameter(SET_MODE,RUN_PARAMETER_TESTNET_RESULT,-1);
	quit();
}
void testServerThread::testServerTimeout()
{
	//qDebug("%s %d currentthreadid=0x%08x",__FUNCTION__,__LINE__,QThread::currentThreadId());
	/*
	if(monitorTimer&&monitorTimer->isActive())
	monitorTimer->stop();

	if(testNetTimer->isActive())
	testNetTimer->stop();
	*/
	//qDebug()<<__FUNCTION__<<__LINE__;
	THREAD_MONITOR_POINT;
	STOP_TIMER(monitorTimer);
	STOP_TIMER(testNetTimer);
	reply->abort();
}
void testServerThread::terminateThread()
{
	THREAD_MONITOR_POINT;
	testServerTimeout();
	MyThread::terminateThread();
}
/*
void testServerThread::gorun()
{
	DELETE_TIMER(testNetTimer);
	qDebug("%s %d currentthreadid=0x%08x",__FUNCTION__,__LINE__,QThread::currentThread());
	START_TIMER_ASYN(monitorTimer,false,10,monitorTimerSlot);
	
	tz::runParameter(SET_MODE,RUN_PARAMETER_TESTNET_RESULT,0);
	manager=new QNetworkAccessManager();

	SET_NET_PROXY(manager);

	manager->moveToThread(this);
	
	//testNetTimer->moveToThread(this);
	connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(testServerFinished(QNetworkReply*)),Qt::DirectConnection);
	reply=manager->get(QNetworkRequest(QUrl(TEST_NET_URL)));
	
	
	testNetTimer=new QTimer();
	testNetTimer->start(TEST_SERVER_TIMEOUT*SECONDS);
	testNetTimer->moveToThread(this);
	connect(testNetTimer, SIGNAL(timeout()), this, SLOT(testServerTimeout()),Qt::DirectConnection);
	
	//START_TIMER_SYN(testNetTimer,true,TEST_SERVER_TIMEOUT*SECONDS,testServerTimeout);
}
*/
void testServerThread::clearObject()
{
	THREAD_MONITOR_POINT;
	DELETE_OBJECT(reply);
	DELETE_OBJECT(manager);
	DELETE_TIMER(testNetTimer);
}
void testServerThread::run()
{
	THREAD_MONITOR_POINT;
	//monitorTimer = new QTimer();
	//connect(monitorTimer, SIGNAL(timeout()), this, SLOT(monitorTimerSlot()), Qt::DirectConnection);
	//monitorTimer->start(10);
	//monitorTimer->moveToThread(this);
/*
	testNetTimer=new QTimer();
	testNetTimer->setSingleShot(true);
	testNetTimer->moveToThread(this);
	connect(testNetTimer, SIGNAL(timeout()), this, SLOT(gorun()), Qt::DirectConnection);
	testNetTimer->start(10);
*/
	START_TIMER_INSIDE(monitorTimer,false,10,monitorTimeout);
	
	tz::runParameter(SET_MODE,RUN_PARAMETER_TESTNET_RESULT,0);
	manager=new QNetworkAccessManager();

	SET_NET_PROXY(manager);

	manager->moveToThread(this);
	
	//testNetTimer->moveToThread(this);
	connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(testServerFinished(QNetworkReply*)),Qt::DirectConnection);
	reply=manager->get(QNetworkRequest(QUrl(TEST_NET_URL)));
	
	/*
	testNetTimer=new QTimer();
	testNetTimer->start(TEST_SERVER_TIMEOUT*SECONDS);
	testNetTimer->moveToThread(this);
	connect(testNetTimer, SIGNAL(timeout()), this, SLOT(testServerTimeout()),Qt::DirectConnection);
	*/
	
	START_TIMER_INSIDE(testNetTimer,false,TEST_SERVER_TIMEOUT*SECONDS,testServerTimeout);
	exec();
	clearObject();
	
}
