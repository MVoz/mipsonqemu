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
					}
				
		}else
				tz::runParameter(SET_MODE,RUN_PARAMETER_TESTNET_RESULT,-1);
		quit();
}
void testServerThread::testNetTimeout()
{
		qDebug("%s %d",__FUNCTION__,__LINE__);
		if(testNetTimer->isActive())
			testNetTimer->stop();
		reply->abort();
}
void testServerThread::run()
{
		qDebug("testServerThread::run");
		tz::runParameter(SET_MODE,RUN_PARAMETER_TESTNET_RESULT,0);
		manager=new QNetworkAccessManager();
		manager->moveToThread(this);
		testNetTimer=new QTimer();
		testNetTimer->moveToThread(this);
		connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(testNetFinished(QNetworkReply*)),Qt::DirectConnection);
		reply=manager->get(QNetworkRequest(QUrl(TEST_NET_URL)));
		testNetTimer->start(30*SECONDS);
		connect(testNetTimer, SIGNAL(timeout()), this, SLOT(testNetTimeout()), Qt::DirectConnection);
		exec();
}

