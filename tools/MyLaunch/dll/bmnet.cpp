#include <bmnet.h>
#include <bmapi.h>

MyThread::MyThread(QObject * parent,QSettings* s):QThread(parent),settings(s)
{
	resultBuffer = NULL;
	http =NULL;
	http_state = 0;
	http_timeout = 0;
	http_send_len = 0;
	http_rcv_len = 0;
	terminateFlag=0;
	monitorTimer=NULL;
	header = NULL;
	file = NULL;
	dlgmode = UPDATE_DLG_MODE;
}
MyThread::~MyThread()
{
	clearObject();
}

void MyThread::setTerminateFlag(int f)
{
	terminateFlag=f;
}
void MyThread::monitorTimeout(){
	if(http){
		http_timeout++;
		if(tz::getParameterMib(http_state)&&((http_timeout*tz::getParameterMib(SYS_MONITORTIMEOUT)/1000)>tz::getParameterMib(http_state))){
			http->abort();
		}
	}
/*
	if(terminateFlag)
		terminateThread();
	else
	{
		monitorTimer->start((tz::getParameterMib(SYS_MONITORTIMEOUT)));
	}
*/
	monitorTimer->start((tz::getParameterMib(SYS_MONITORTIMEOUT)));
}
void MyThread::run(){
	qRegisterMetaType<QHttpResponseHeader>("QHttpResponseHeader");
	START_TIMER_INSIDE(monitorTimer,false,(tz::getParameterMib(SYS_MONITORTIMEOUT)),monitorTimeout);
}
void MyThread::terminateThread(){
	STOP_TIMER(monitorTimer);
}
void MyThread::clearObject(){
	DELETE_TIMER(monitorTimer);
	DELETE_OBJECT(http);	
	DELETE_OBJECT(header);	
	DELETE_FILE(resultBuffer);
	DELETE_FILE(file);
}
void MyThread::newHttpX(bool needHeader,bool needBuffer,bool needFile,bool hidden){
	http = new QHttp();
	http->moveToThread(this);
	http->setHost(BM_SERVER_ADDRESS);	
	SET_NET_PROXY(http,settings);
	/*
	I found the problem:
	From the Qt docs, a Qt::QueuedConnection will cause the slot to execute when control returns to the event loop 
	of the thread where the receiver object lives. The receiver object in my case is the QThread object which is 
	created, and thus lives, in the main GUI thread. The QTimer is created in the thread spawned off of the 
	QThread object. So in this case I needed a Qt:: DirectConnection.
	*/
	connect(http, SIGNAL(stateChanged(int)), this, SLOT(httpstateChanged(int)),Qt::DirectConnection);
	connect(http, SIGNAL(dataSendProgress(int,int)), this, SLOT(httpdataSendProgress(int,int)),Qt::DirectConnection);
	connect(http, SIGNAL(dataReadProgress(int,int)), this, SLOT(httpdataReadProgress(int,int)),Qt::DirectConnection);
	if(needHeader){
		header=new QHttpRequestHeader("POST", url);
		header->setContentType("application/x-www-form-urlencoded");
		header->setValue("Host", BM_SERVER_ADDRESS);
	}
	if(needBuffer){
		resultBuffer = new QBuffer();
		resultBuffer->moveToThread(this);
		resultBuffer->open(QIODevice::ReadWrite);
	}
	if(needFile){
		file = new QFile(filename);
		if(file->open(QIODevice::ReadWrite | QIODevice::Truncate)){
			if(hidden)
				SetFileAttributes(filename.utf16(),FILE_ATTRIBUTE_HIDDEN);
		}
	}
	SET_HOST_IP(settings,http,&url,header);
}

void MyThread::setUrl(const QString &s){
	url = s;
}

void MyThread::setFilename(const QString &s){
	filename.clear();
	filename = s;
}




testNet::testNet(QObject * parent ,QSettings* s,int m,int d):MyThread(parent,s),mode(m),id(d)
{
#ifdef USE_HTTP
#else
	manager = NULL;
	reply = NULL;
//	testNetTimer = NULL;
#endif
}


void testNet::monitorTimeout(){
	STOP_TIMER(monitorTimer);
	MyThread::monitorTimeout();
}


#ifdef USE_HTTP
void testNet::testServerFinished(bool error)
#else
void testNet::testServerFinished(QNetworkReply* reply)
#endif
{
	QDEBUG_LINE;

	//STOP_TIMER(testNetTimer);
#ifdef USE_HTTP
#else
	QNetworkReply::NetworkError error=reply->error();
#endif
	if(!error)
	{
#ifdef USE_HTTP
		QString replybuf(resultBuffer->data().trimmed());
#else
		QString replybuf(reply->readAll().trimmed());
#endif
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
#ifdef USE_HTTP
				//case QNetworkReply::ProxyConnectionRefusedError:
				//case QNetworkReply::ProxyConnectionClosedError:
				//case QNetworkReply::ProxyNotFoundError:
				//case QNetworkReply::ProxyTimeoutError:
				//	SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT,TEST_NET_ERROR_PROXY);
				//	break;
				case QHttp::ProxyAuthenticationRequiredError:
					SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT,TEST_NET_ERROR_PROXY_AUTH);
					break;
				default:
					SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT,TEST_NET_ERROR_SERVER);
					break;
#else
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
#endif
			}		
		}else if(mode == TEST_SERVER_VERSION){
		}
	}
	QDEBUG_LINE;
	quit();
}
/*
void testNet::testServerTimeout()
{
	THREAD_MONITOR_POINT;
	//STOP_TIMER(monitorTimer);
	STOP_TIMER(testNetTimer);
	reply->abort();
}
*/
void testNet::terminateThread()
{
	THREAD_MONITOR_POINT;
//	testServerTimeout();
	MyThread::terminateThread();
}
void testNet::clearObject()
{
	//QDEBUG_LINE;
	THREAD_MONITOR_POINT;
#ifdef USE_HTTP
	MyThread::clearObject();
#else
	DELETE_OBJECT(reply);
	DELETE_OBJECT(manager);
	DELETE_TIMER(monitorTimer);
#endif	
//	DELETE_TIMER(testNetTimer);
//	
//	QDEBUG_LINE;
}
void testNet::run()
{
	THREAD_MONITOR_POINT;	
	//QString url ="";
	//START_TIMER_INSIDE(monitorTimer,false,(tz::getParameterMib(SYS_MONITORTIMEOUT)),monitorTimeout);	
	MyThread::run();
	switch(mode){
		case TEST_SERVER_NET:
			SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT,TEST_NET_REFUSE);
			setUrl(TEST_NET_URL);
			break;
		case TEST_SERVER_VERSION:
			SET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_VERSION,0);
			setUrl(TOUCHANY_VERSION_URL);
			break;
#ifdef CONFIG_DIGG_XML
		case TEST_SERVER_DIGG_XML:
			SET_RUN_PARAMETER(RUN_PARAMETER_DIGG_XML,0);
			setUrl(QString(TEST_DIGGXML_URL).append(QString("&id=%1").arg(id)));
			break;
#endif
	}
#ifdef USE_HTTP
	MyThread::newHttpX(FALSE,TRUE,FALSE,FALSE);
	connect(http, SIGNAL(done(bool)), this, SLOT(testServerFinished(bool)),Qt::DirectConnection);
#else

	manager=new QNetworkAccessManager();
	manager->moveToThread(this);	
	SET_NET_PROXY(manager,settings);	

	connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(testServerFinished(QNetworkReply*)),Qt::DirectConnection);	
#endif
/*
#ifdef CONFIG_SERVER_IP_SETTING
	do{
		QString serverIp = (settings)->value("serverip","" ).toString().trimmed();
		if( !serverIp.isEmpty())
			url.replace(BM_SERVER_ADDRESS, serverIp);	
		http->setHost(serverIp);
	}while(0);
#endif
*/
  //    SET_HOST_IP(settings,http,&url,header);

#ifdef USE_HTTP		
	//resultBuffer = new QBuffer();
	//resultBuffer->moveToThread(this);
	//resultBuffer->open(QIODevice::ReadWrite);
	//MyThread::newHttpBuffer();
	http->get(url, resultBuffer);
#else
	reply=manager->get(QNetworkRequest(QUrl(url)));
#endif

	TD(DEBUG_LEVEL_NORMAL,url);
//	START_TIMER_INSIDE(testNetTimer,false,(tz::getParameterMib(SYS_MONITORTIMEOUT))*SECONDS,testServerTimeout);
	exec();
	clearObject();		
	QDEBUG_LINE;
}
