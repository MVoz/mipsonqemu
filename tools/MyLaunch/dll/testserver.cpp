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
	QDEBUG_LINE;
}

void MyThread::setTerminateFlag(int f)
{
	terminateFlag=f;
}
void MyThread::monitorTimerSlot(){
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
	//qDebug()<<__FUNCTION__;
	monitorTimer = new QTimer();
	connect(monitorTimer, SIGNAL(timeout()), this, SLOT(monitorTimerSlot()), Qt::DirectConnection);
	monitorTimer->start(10);
	monitorTimer->moveToThread(this);
}
void MyThread::terminateThread(){
	//qDebug()<<QThread::currentThreadId();
	//if(monitorTimer&&monitorTimer->isActive())
	//	monitorTimer->stop();
	STOP_TIMER(monitorTimer);
}
void testServerThread::testServerFinished(QNetworkReply* reply)
{
	//qDebug("network reply error code %d isactive=%d",reply->error(),testNetTimer->isActive());
	/*
	if(testNetTimer->isActive())
	testNetTimer->stop();
	*/
	DELETE_TIMER(testNetTimer);
	//DELETE_TIMER(monitorTimer);
	int error=reply->error();
	if(!error)
	{
		QString replybuf(reply->readAll());
		//	qDebug()<<__FUNCTION__<<__LINE__<<"reply:"<<replybuf;
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
	STOP_TIMER(monitorTimer);
	STOP_TIMER(testNetTimer);
	reply->abort();
}
void testServerThread::terminateThread()
{
	//qDebug("%s %d currentthreadid=0x%08x",__FUNCTION__,__LINE__,QThread::currentThreadId());
	testServerTimeout();
	MyThread::terminateThread();
}
void testServerThread::gorun()
{
	monitorTimer = new QTimer(this);
	connect(monitorTimer, SIGNAL(timeout()), this, SLOT(monitorTimerSlot()), Qt::DirectConnection);
	monitorTimer->start(10);
//	monitorTimer->moveToThread(this);
	
	tz::runParameter(SET_MODE,RUN_PARAMETER_TESTNET_RESULT,0);
	manager=new QNetworkAccessManager(this);

	SET_NET_PROXY(manager);

	//manager->moveToThread(this);
	testNetTimer=new QTimer(this);
	//testNetTimer->moveToThread(this);
	connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(testServerFinished(QNetworkReply*)),Qt::DirectConnection);
	reply=manager->get(QNetworkRequest(QUrl(TEST_NET_URL)));
	testNetTimer->start(30*SECONDS);
	connect(testNetTimer, SIGNAL(timeout()), this, SLOT(testServerTimeout()), Qt::DirectConnection);
}
void testServerThread::run()
{
	//qDebug("%s %d testServerThread run currentthreadid=0x%08x",__FUNCTION__,__LINE__,QThread::currentThreadId());
	//monitorTimer = new QTimer();
	//connect(monitorTimer, SIGNAL(timeout()), this, SLOT(monitorTimerSlot()), Qt::DirectConnection);
	//monitorTimer->start(10);
	//monitorTimer->moveToThread(this);
	
	QTimer::singleShot(10, this, SLOT(gorun()));
	
	exec();
}
