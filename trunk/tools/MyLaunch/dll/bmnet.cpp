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
		monitorTimer->start((tz::getParameterMib(SYS_MONITORTIMEOUT)));
	}
}
void MyThread::run(){
	START_TIMER_INSIDE(monitorTimer,false,(tz::getParameterMib(SYS_MONITORTIMEOUT)),monitorTimeout);
}
void MyThread::terminateThread(){
	STOP_TIMER(monitorTimer);
}
testNet::testNet(QObject * parent ,QSettings* s,int m,int d):MyThread(parent,s),mode(m),id(d)
{
	manager = NULL;
	reply = NULL;
	testNetTimer = NULL;
}
void testNet::testServerFinished(QNetworkReply* reply)
{
	STOP_TIMER(testNetTimer);
	QNetworkReply::NetworkError error=reply->error();
	if(!error)
	{
		QString replybuf(reply->readAll().trimmed());
		switch(mode){
			case TEST_SERVER_NET:				
				if(replybuf.startsWith(QString("1")))
				{
					SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT,TEST_NET_SUCCESS);
				}
			break;
#ifdef CONFIG_DIGG_XML
			case TEST_SERVER_DIGG_XML:
				if(replybuf.startsWith(QString("1")))
				{
					SET_RUN_PARAMETER(RUN_PARAMETER_DIGG_XML,TEST_NET_SUCCESS);
				}else if(replybuf.startsWith(QString("0"))){
					SET_RUN_PARAMETER(RUN_PARAMETER_DIGG_XML,TEST_NET_UNNEED);
				}
			break;
#endif
			case TEST_SERVER_VERSION:
				{
					qDebug()<<replybuf;
					QRegExp verre("^[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}$");
					if(verre.exactMatch(replybuf)){
						QDEBUG_LINE;	
						QStringList s_version = replybuf.split(".");
						QStringList l_version = QString(APP_VERSION).split(".");
						 for (int i = 0; i < s_version.size(); ++i)
       							{ 
       								if(s_version.at(i).toUInt()>l_version.at(i).toUInt())
       								{
       									SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_VERSION,1);
									break;
       								}       								
						 	}						
					}
				}
			break;

		}		
	}else{
		if(mode == TEST_SERVER_NET){
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
		}else if(mode == TEST_SERVER_VERSION){
		}
	}
	quit();
}
void testNet::testServerTimeout()
{
	THREAD_MONITOR_POINT;
	//STOP_TIMER(monitorTimer);
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
	DELETE_TIMER(monitorTimer);
	QDEBUG_LINE;
}
void testNet::run()
{
	THREAD_MONITOR_POINT;	
	QString url ="";
	START_TIMER_INSIDE(monitorTimer,false,(tz::getParameterMib(SYS_MONITORTIMEOUT)),monitorTimeout);	
	if(mode==TEST_SERVER_NET)
	{
		SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT,TEST_NET_REFUSE);
		url =TEST_NET_URL;
	}else if(mode==TEST_SERVER_VERSION){
		SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_VERSION,0);
		url =TOUCHANY_VERSION_URL;
	}
#ifdef CONFIG_DIGG_XML
	else if(mode ==  TEST_SERVER_DIGG_XML){
		SET_RUN_PARAMETER(RUN_PARAMETER_DIGG_XML,0);
		url =QString(TEST_DIGGXML_URL).append(QString("&id=%1").arg(id));
	}
#endif
	manager=new QNetworkAccessManager();
	manager->moveToThread(this);	
	SET_NET_PROXY(manager,settings);	

	connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(testServerFinished(QNetworkReply*)),Qt::DirectConnection);
	
#ifdef CONFIG_SERVER_IP_SETTING
	do{
		QString serverIp = (settings)->value("serverip","" ).toString().trimmed();
		if( !serverIp.isEmpty())
			url.replace(BM_SERVER_ADDRESS, serverIp);	
		reply=manager->get(QNetworkRequest(QUrl(url)));
	}while(0);
#else
	reply=manager->get(QNetworkRequest(QUrl(url)));
#endif
	TD(DEBUG_LEVEL_NORMAL,url);
	START_TIMER_INSIDE(testNetTimer,false,(tz::getParameterMib(SYS_MONITORTIMEOUT))*SECONDS,testServerTimeout);
	exec();
	clearObject();		
}
