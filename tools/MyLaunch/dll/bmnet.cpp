#include <bmnet.h>
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
testNet::testNet(QObject * parent ,QSettings* s):MyThread(parent,s)
{
	manager = NULL;
	reply = NULL;
	testNetTimer = NULL;
}
void testNet::testServerFinished(QNetworkReply* reply)
{
	THREAD_MONITOR_POINT;
	STOP_TIMER(testNetTimer);
	QNetworkReply::NetworkError error=reply->error();
	if(!error)
	{
		QString replybuf(reply->readAll());
		if(replybuf.startsWith(QString("1")))
		{
			SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT,TEST_NET_SUCCESS);
		}

	}else{
		switch(error){
			case QNetworkReply::ProxyConnectionRefusedError:
			case QNetworkReply::ProxyConnectionClosedError:
			case QNetworkReply::ProxyNotFoundError:
			case QNetworkReply::ProxyTimeoutError:
				SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT,TEST_NET_ERROR_PROXY);
				break;
			case QNetworkReply::ProxyAuthenticationRequiredError:
				SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT,TEST_NET_ERROR_PROXY_AUTH);
				break;
			default:
				SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT,TEST_NET_ERROR_SERVER);
				break;
		}		
	}
	quit();
}
void testNet::testServerTimeout()
{
	THREAD_MONITOR_POINT;
	STOP_TIMER(monitorTimer);
	STOP_TIMER(testNetTimer);
	reply->abort();
}
void testNet::terminateThread()
{
	THREAD_MONITOR_POINT;
	testServerTimeout();
	MyThread::terminateThread();
}
void testNet::clearObject()
{
	THREAD_MONITOR_POINT;
	DELETE_OBJECT(reply);
	DELETE_OBJECT(manager);
	DELETE_TIMER(testNetTimer);
}
void testNet::run()
{
	THREAD_MONITOR_POINT;
	START_TIMER_INSIDE(monitorTimer,false,10,monitorTimeout);	

	SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT,TEST_NET_REFUSE);
	manager=new QNetworkAccessManager();
	manager->moveToThread(this);	
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
