#include <Bookmark_sync.h>
#include <QUrl>
#include <QWaitCondition>
#include <QDir>
#include <QStringList>
#include <bmapi.h>
#include <posthttp.h>
//QHttpRequestHeader header=QHttpRequestHeader("POST", BM_TEST_ACCOUNT_URL);

//header.setValue("Host", BM_SERVER_ADDRESS);
//header.setContentType("application/x-www-form-urlencoded");
// header.setValue("cookie", "jblog_authkey=MQkzMmJlNmM1OGRmODFkNGExMThiMmNhZjcyMGVjOTUwMA");			
// postString.sprintf("name=%s&link=%s",qPrintable(bc.name),qPrintable(bc.link));
//resuleBuffer=new QBuffer(NUll); //this will bring out "create"
/*
void BookmarkSync::setNetworkProxy()
{
//check proxy
if(settings->value("HttpProxy/proxyEnable", false).toBool())
{
qDebug()<<"http proxy enable!";
httpProxyEnable=1;
netProxy=new QNetworkProxy();
netProxy->setType(QNetworkProxy::HttpProxy);
netProxy->setHostName(settings->value("HttpProxy/proxyAddress", "").toString());

netProxy->setPort(settings->value("HttpProxy/proxyPort", 0).toUInt());
netProxy->setUser(settings->value("HttpProxy/proxyUsername", "").toString());
netProxy->setPassword(settings->value("HttpProxy/proxyPassword", "").toString());

}
}
*/
void BookmarkSync::on_http_stateChanged(int stat)
{

	switch (stat)
	{
	case QHttp::Unconnected:
		// qDebug("Unconnected");
		//  emit updateStatusNotify(HTTP_UNCONNECTED);
		break;
	case QHttp::HostLookup:
		//  qDebug("HostLookup");
		//  emit updateStatusNotify(HTTP_HOSTLOOKUP);
		break;
	case QHttp::Connecting:
		//  qDebug("Connecting");
		//  emit updateStatusNotify(HTTP_CONNECTING);
		break;
	case QHttp::Sending:
		//  qDebug("Sending");
		//  emit updateStatusNotify(HTTP_SENDING);
		break;
	case QHttp::Reading:
		//  qDebug("Reading");
		//  emit updateStatusNotify(HTTP_READING);
		break;
	case QHttp::Connected:
		//  qDebug("Connected");
		//  emit updateStatusNotify(HTTP_CONNECTED);
		break;
	case QHttp::Closing:
		//  qDebug("Closing");
		//  emit updateStatusNotify(HTTP_CLOSING);
		break;
	}

}

void BookmarkSync::on_http_dataReadProgress(int done, int total)
{
	qDebug("Downloaded:%d bytes out of %d", done, total);
	emit readDateProgressNotify(done, total);
}

void BookmarkSync::on_http_dataSendProgress(int done, int total)
{
}
void BookmarkSync::on_http_requestFinished(int id, bool error)
{
}

void BookmarkSync::on_http_requestStarted(int id)
{
}
void BookmarkSync::on_http_responseHeaderReceived(const QHttpResponseHeader & resp)
{
}
BookmarkSync::BookmarkSync(QObject* parent,QSqlDatabase* db,QSettings* s,int m): MyThread(parent),settings(s),mode(m)
{

	//httpTimerId=startTimer(10*1000);
	//	updateTime=d;
	this->db=db;
	
	//	netProxy=NULL;
	httpProxyEnable=0;
	http_finish=0;
	http_timerover=0;
	error=0;
	testServerResult = 0;
	resultBuffer = NULL;
	testThread = NULL;
	file =NULL;
	http =NULL;
	mgthread=NULL;
	httpTimer = NULL;
	accountTestHttp=NULL;
	//monitorTimer = NULL;
	//terminateFlag = 0;

	//QDEBUG("%s updateTime=0x%08x",__FUNCTION__,updateTime);


}
BookmarkSync::~BookmarkSync(){
		DELETE_OBJECT(http);
		DELETE_TIMER(httpTimer);
		DELETE_OBJECT(accountTestHttp);
		DELETE_OBJECT(mgthread);
		DELETE_OBJECT(testThread);
		DELETE_FILE(resultBuffer);
		DELETE_FILE(file);
		QDEBUG_LINE;
}
void BookmarkSync::httpTimerSlot()
{
	//qDebug("httpTimerSlot.......");
	if(!terminateFlag)
		emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_TIMEOUT);	
	http_timerover=1;
	/*
	if(httpTimer->isActive())
	httpTimer->stop();
	*/
	STOP_TIMER(httpTimer);
	if(!http_finish)
		http->abort();
}
void BookmarkSync::stopSync()
{
	/*
	switch (http_finish)
	{
	case 0:			
	http->abort();
	break;
	case 1:
	if(mgthread&&mgthread->isRunning())
	{
	qDebug("shut down the mergethread!");
	mgthread->setTerminated(1);
	}
	break;			

	}
	*/
	//qDebug("%s %d currentthreadid=0x%08x",__FUNCTION__,__LINE__,QThread::currentThreadId());
	terminateThread();

}
void BookmarkSync::testNetFinished()
{
	//testServerResult = tz::testNetResult(GET_MODE,0);
	//	qDebug("%s %d currentthreadid=0x%08x",__FUNCTION__,__LINE__,QThread::currentThreadId());
	testServerResult = tz::runParameter(GET_MODE,RUN_PARAMETER_TESTNET_RESULT,0);
	//qDebug("testNetFinishedx result=%d",testServerResult);
	/*
	if(testThread)
	delete testThread;
	*/
	DELETE_OBJECT(testThread);
	switch(testServerResult)
	{
	case -1:
		if(!terminateFlag)
			emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_NET_ERROR);	
		quit();
		break;
	case 0:
		if(!terminateFlag)
			emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_SERVER_REFUSE);		
		quit();
		break;
	case 1:
		{

			http = new QHttp();
			//if(httpProxyEnable)
			//	http->setProxy(*netProxy);
			SET_NET_PROXY(http);
			/*
			httpProxyEnable = tz::runParameter(GET_MODE,RUN_PARAMETER_NETPROXY_ENABLE, httpProxyEnable);
			if(httpProxyEnable){
			tz::runParameter(GET_MODE,RUN_PARAMETER_NETPROXY_USING, 1);
			tz::netProxy(GET_MODE,settings,netProxy);
			http->setProxy(*netProxy);	
			}
			*/
			httpTimer=new QTimer();
			connect(httpTimer, SIGNAL(timeout()), this, SLOT(httpTimerSlot()), Qt::DirectConnection);
			httpTimer->start(10*1000);
			httpTimer->setSingleShot(true);

			if(mode==BOOKMARK_SYNC_MODE)	
			{
				connect(http, SIGNAL(done(bool)), this, SLOT(bookmarkGetFinished(bool)),Qt::DirectConnection);
				//qDebug("BookmarkSync run...........");
				filename_fromserver.clear();
				getUserLocalFullpath(settings,QUuid::createUuid ().toString(),filename_fromserver);
				//qDebug("random file from server:%s",qPrintable(filename_fromserver));
				file = new QFile(filename_fromserver);

				int ret1=file->open(QIODevice::ReadWrite | QIODevice::Truncate);
				http->setHost(host);
				if(!terminateFlag)
					emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,BOOKMARK_SYNC_START);	
				//qDebug()<<"url:"<<url;
				http->get(url, file);

			}else if(mode==BOOKMARK_TESTACCOUNT_MODE){

				http->setHost(BM_SERVER_ADDRESS);
				connect(http, SIGNAL(done(bool)), this, SLOT(testAccountFinished(bool)));

				resultBuffer = new QBuffer();
				resultBuffer->moveToThread(this);
				resultBuffer->open(QIODevice::ReadWrite);

				http->get(url, resultBuffer);

			}


		}						
		break;
	}	
}
void BookmarkSync::terminateThread()
{
	//qDebug("%s %d currentthreadid=0x%08x",__FUNCTION__,__LINE__,QThread::currentThreadId());
	/*
	if(monitorTimer&&monitorTimer->isActive())
	monitorTimer->stop();
	*/
	STOP_TIMER(monitorTimer);
	if(testThread&&testThread->isRunning())
		testThread->setTerminateFlag(1);
	if(httpTimer&&httpTimer->isActive())
		httpTimerSlot();
	if(mgthread&&mgthread->isRunning())
	{
		mgthread->setTerminated(1);
		if(mgthread->posthp&&mgthread->posthp->isRunning())
			mgthread->posthp->setTerminateFlag(1);
		//emit mergeTerminateNotify();
	}
	MyThread::terminateThread();
}
/*
void BookmarkSync::monitorTimerSlot()
{
STOP_TIMER(monitorTimer);

if(terminateFlag)
terminateThread();
else
monitorTimer->start(10);
}
*/
void BookmarkSync::run()
{
	qRegisterMetaType<QHttpResponseHeader>("QHttpResponseHeader");
	//qDebug("%s %d currentthreadid=0x%08x",__FUNCTION__,__LINE__,QThread::currentThreadId());
	/*
	monitorTimer = new QTimer();
	connect(monitorTimer, SIGNAL(timeout()), this, SLOT(monitorTimerSlot()), Qt::DirectConnection);
	monitorTimer->start(10);
	monitorTimer->moveToThread(this);
	*/
	MyThread::run();
	tz::netProxy(SET_MODE,settings,NULL);
	//check server status
	{
		testThread = new testServerThread();
		testThread->moveToThread(this);
		connect(testThread,SIGNAL(finished()), this, SLOT(testNetFinished()));
		if(!terminateFlag)
			emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,HTTP_CONNECT_SERVER);	
		//connect(this,SIGNAL(testNetTerminateNotify()), testThread, SLOT(testThreadterminateThread()),Qt::DirectConnection);
		//qDebug("start testServerThread::");
		//qDebug("start testServerThread 0x%08x result=%d",testThread,testThread->result);
		testThread->start(QThread::IdlePriority);
	}	
	//connect(this->parent(), SIGNAL(stopSyncNotify()), this, SLOT(stopSync()));
	// qDebug("%s currentThread id=0x%08x",__FUNCTION__,currentThread());


	//setNetworkProxy();




	int ret=exec();
	if(testServerResult==1){
		switch(mode)
		{
		case BOOKMARK_SYNC_MODE:
			if(!http_timerover)
				emit bookmarkFinished(ret);
			//	qDebug("sync thread quit.............");
			break;
		case BOOKMARK_TESTACCOUNT_MODE:
			if(!http_timerover)
				emit testAccountFinishedNotify(ret,QString(resultBuffer->data()));						
			//	qDebug("testAccount thread quit.............\n");
			break;
		}
		/*
		if(httpTimer->isActive())
		{
		qDebug("kill http timer!");
		httpTimer->stop();		
		}
		*/
		STOP_TIMER(httpTimer);
		DELETE_FILE(resultBuffer);
		/*
		if(resultBuffer){
		resultBuffer->close();
		delete resultBuffer;
		resultBuffer=NULL;
		}
		*/
		tz::runParameter(SET_MODE,RUN_PARAMETER_NETPROXY_USING, 0);
	}
}

#ifdef CONFIG_HTTP_TIMEOUT
//void BookmarkSync::timerEvent(QTimerEvent * event)
//{
//	QDEBUG("timerevent id=%d httpTimerId=%d", event->timerId(), httpTimerId);
//	emit updateStatusNotify(HTTP_TIMEOUT);
//}
#endif
/*
void BookmarkSync::quit()
{
if (loop.isRunning())
loop.exit(0);
}
*/
void BookmarkSync::testAccountFinished(bool error)
{
	/*
	if(httpTimer->isActive())
	httpTimer->stop();
	*/
	STOP_TIMER(httpTimer);
	http_finish=1;
	this->error=error;
	//httpTimer->stop();
	exit(error);
}
void BookmarkSync::mgUpdateStatus(int flag,int status)
{
	//qDebug()<<flag<<"  "<<str;
	if(!terminateFlag)
		emit updateStatusNotify(flag,status);

}

void BookmarkSync::bookmarkGetFinished(bool error)
{
	//qDebug("%s %d currentthreadid=0x%08x",__FUNCTION__,__LINE__,QThread::currentThreadId());
	/*
	if(httpTimer->isActive())
	httpTimer->stop();
	*/
	STOP_TIMER(httpTimer);
	http_finish=1;
	this->error=error;
#ifdef CONFIG_HTTP_TIMEOUT

#else
	//if (httpTimerId)
	//	http->killTimer(httpTimerId);
	//httpTimerId = 0;
#endif
	//qDebug("emit bookmarkFinished error %d to networkpage", error);
	if(!error)	
	{
		//QDEBUG("%s updateTime=0x%08x",__FUNCTION__,updateTime);
		mgthread = new mergeThread(this,db,settings,username,password);
		//emit updateStatusNotify(UPDATE_PROCESSING);
		mgthread->setRandomFileFromserver(filename_fromserver);


		connect(mgthread, SIGNAL(finished()), this, SLOT(mergeDone()));
		connect(mgthread, SIGNAL(mgUpdateStatusNotify(int,int)), this, SLOT(mgUpdateStatus(int,int)));
		//connect(this, SIGNAL(mergeTerminateNotify()), mgthread, SLOT(terminateThread()));

		mgthread->start();
		//qDebug("start merge thread...........");
	}
	else
	{
		if(http->error()!=QHttp::ProxyAuthenticationRequiredError)			
		{
			//qDebug("http error %s",qPrintable(http->errorString()));
			if(!terminateFlag)
				emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_NET_ERROR);
		}
		//else
		//qDebug("http error %s",qPrintable(http->errorString()));
		mergeDone();
	}
	/*
	if (!IS_NULL(file))
	{
	file->close();
	delete file;
	file = NULL;
	}
	*/
	DELETE_FILE(file);
	//  this->quit();
}

void BookmarkSync::mergeDone()
{
	qDebug("quit merge thread...........");
	if(!error&&!terminateFlag){
		emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,SYNC_SUCCESSFUL);
	}
	DELETE_OBJECT(mgthread);
	/*
	if(mgthread){
	mgthread->deleteLater();
	mgthread=NULL;
	}

	if(netProxy){
	delete netProxy;
	netProxy=NULL;
	}
	*/
	exit(error);
}


