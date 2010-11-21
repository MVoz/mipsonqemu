#include <testserver.h>
#include <bmapi.h>

MyThread::MyThread(QObject * parent,QSettings* s):QThread(parent),settings(s)
{
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
	STOP_TIMER(monitorTimer);
	if(terminateFlag)
		terminateThread();
	else
	{
		monitorTimer->start(10);
	}
}
void MyThread::run(){
	START_TIMER_INSIDE(monitorTimer,false,10,monitorTimeout);
}
void MyThread::terminateThread(){
	STOP_TIMER(monitorTimer);
}
testServerThread::testServerThread(QObject * parent ,QSettings* s):MyThread(parent,s)
{
	manager = NULL;
	reply = NULL;
	testNetTimer = NULL;
}
void testServerThread::testServerFinished(QNetworkReply* reply)
{
	THREAD_MONITOR_POINT;
	STOP_TIMER(testNetTimer);
	QNetworkReply::NetworkError error=reply->error();
	if(!error)
	{
		QString replybuf(reply->readAll());
		if(replybuf.startsWith(QString("1")))
		{
			//tz::runParameter(SET_MODE,RUN_PARAMETER_TESTNET_RESULT,TEST_NET_SUCCESS);	
			SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT,TEST_NET_SUCCESS);
		}

	}else{
		switch(error){
			case QNetworkReply::ProxyConnectionRefusedError:
			case QNetworkReply::ProxyConnectionClosedError:
			case QNetworkReply::ProxyNotFoundError:
			case QNetworkReply::ProxyTimeoutError:
				//tz::runParameter(SET_MODE,RUN_PARAMETER_TESTNET_RESULT,TEST_NET_ERROR_PROXY);	
				SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT,TEST_NET_ERROR_PROXY);
				break;
			case QNetworkReply::ProxyAuthenticationRequiredError:
				SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT,TEST_NET_ERROR_PROXY_AUTH);
				//tz::runParameter(SET_MODE,RUN_PARAMETER_TESTNET_RESULT,TEST_NET_ERROR_PROXY_AUTH);		
				break;
			default:
				SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT,TEST_NET_ERROR_SERVER);
				//tz::runParameter(SET_MODE,RUN_PARAMETER_TESTNET_RESULT,TEST_NET_ERROR_SERVER);
				break;
		}		
	}
	quit();
}
void testServerThread::testServerTimeout()
{
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
	START_TIMER_INSIDE(monitorTimer,false,10,monitorTimeout);
	
	//tz::runParameter(SET_MODE,RUN_PARAMETER_TESTNET_RESULT,TEST_NET_REFUSE);
	SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT,TEST_NET_REFUSE);
	manager=new QNetworkAccessManager();
	manager->moveToThread(this);	
	//tz::netProxy(SET_MODE,settings,NULL);
	SET_NET_PROXY(manager,settings);
	

	connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(testServerFinished(QNetworkReply*)),Qt::DirectConnection);
#ifdef CONFIG_SERVER_IP_SETTING
	do{
		QString url = TEST_NET_URL;
		QString serverIp = (settings)->value("serverip","" ).toString().trimmed();
		if( !serverIp.isEmpty())
			url.replace(BM_SERVER_ADDRESS, serverIp);	
		reply=manager->get(QNetworkRequest(QUrl(url)));
	}while(0);
#else
	reply=manager->get(QNetworkRequest(QUrl(TEST_NET_URL)));
#endif
	
	START_TIMER_INSIDE(testNetTimer,false,TEST_SERVER_TIMEOUT*SECONDS,testServerTimeout);
	exec();
	clearObject();	
	
}
