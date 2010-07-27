#include "testserver.h"
#include <QUrl>
#include <QWaitCondition>
#include <QSemaphore>
#include <QDir>
#include <QStringList>
#include <bmapi.h>
#include "config.h"

void testServerThread::testNetFinished(QNetworkReply* reply)
{
		qDebug("network reply error code %d isactive=%d",reply->error(),testNetTimer->isActive());
		if(testNetTimer->isActive())
			testNetTimer->stop();
		int error=reply->error();
		if(!error)
		{
				QString replybuf(reply->readAll());
				qDebug("%s replly=%s",__FUNCTION__,qPrintable(replybuf));
				if(replybuf.startsWith(QString("1")))
					{
						qDebug("set testNetResult 1");
						tz::runParameter(SET_MODE,RUN_PARAMETER_TESTNET_RESULT,1);		
						qDebug("set testNetResult %d",tz::runParameter(GET_MODE,RUN_PARAMETER_TESTNET_RESULT,0));
					}
				
		}else
				tz::runParameter(SET_MODE,RUN_PARAMETER_TESTNET_RESULT,-1);
		quit();
}
void testServerThread::testNetTimeout()
{
		qDebug("%s %d currentthreadid=0x%08x",__FUNCTION__,__LINE__,QThread::currentThreadId());
		if(monitorTimer&&monitorTimer->isActive())
			monitorTimer->stop();
		if(testNetTimer->isActive())
			testNetTimer->stop();
		reply->abort();
}
void testServerThread::terminateThread()
{
	qDebug("%s %d currentthreadid=0x%08x",__FUNCTION__,__LINE__,QThread::currentThreadId());
	testNetTimeout();
}
void testServerThread::run()
{
		qDebug("%s %d testServerThread run currentthreadid=0x%08x",__FUNCTION__,__LINE__,QThread::currentThreadId());
		monitorTimer = new QTimer();
		connect(monitorTimer, SIGNAL(timeout()), this, SLOT(monitorTimerSlot()), Qt::DirectConnection);
		monitorTimer->start(10);
		monitorTimer->moveToThread(this);
		
		tz::runParameter(SET_MODE,RUN_PARAMETER_TESTNET_RESULT,0);
		manager=new QNetworkAccessManager();

		SET_NET_PROXY(manager);
				
		manager->moveToThread(this);
		testNetTimer=new QTimer();
		testNetTimer->moveToThread(this);
		connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(testNetFinished(QNetworkReply*)),Qt::DirectConnection);
		reply=manager->get(QNetworkRequest(QUrl(TEST_NET_URL)));
		testNetTimer->start(30*SECONDS);
		connect(testNetTimer, SIGNAL(timeout()), this, SLOT(testNetTimeout()), Qt::DirectConnection);
		exec();
}
void testServerThread::monitorTimerSlot()
{
	if(monitorTimer&&monitorTimer->isActive())
		monitorTimer->stop();
	if(terminateFlag)
		terminateThread();
	else
		monitorTimer->start(10);

	
}

