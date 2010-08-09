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
	//qDebug()<<resp.value("md5key");
	md5key = resp.value("md5key");
}
BookmarkSync::BookmarkSync(QObject* parent,QSqlDatabase* db,QSettings* s,QSemaphore* p,int m): MyThread(parent),settings(s),semaphore(p),mode(m)
{
	this->db=db;
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
	needwatchchild = false;
}
BookmarkSync::~BookmarkSync(){
}
void BookmarkSync::httpTimerSlot()
{
	THREAD_MONITOR_POINT;
	if(!terminateFlag)
		emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_TIMEOUT);	
	http_timerover=1;
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

	THREAD_MONITOR_POINT;
	testServerResult = tz::runParameter(GET_MODE,RUN_PARAMETER_TESTNET_RESULT,0);
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
			http->moveToThread(this);

			SET_NET_PROXY(http);

			START_TIMER_INSIDE(httpTimer,false,10*SECONDS,httpTimerSlot);
			
			if(mode==BOOKMARK_SYNC_MODE)	
			{
				connect(http, SIGNAL(done(bool)), this, SLOT(bookmarkGetFinished(bool)),Qt::DirectConnection);
				connect(http, SIGNAL(responseHeaderReceived(const QHttpResponseHeader &)), this, SLOT(on_http_responseHeaderReceived(const QHttpResponseHeader &)),Qt::DirectConnection);
				//qDebug("BookmarkSync run...........");
				filename_fromserver.clear();
				getUserLocalFullpath(settings,QUuid::createUuid ().toString(),filename_fromserver);
				filename_fromserver=tz::getUserIniDir(GET_MODE,"")+"/"+QString(FROMSERVER_XML_PREFIX"%1.xml").arg(qhashEx(filename_fromserver,filename_fromserver.length()));
				//qDebug("random file from server:%s",qPrintable(filename_fromserver));
				file = new QFile(filename_fromserver);

				int ret1=file->open(QIODevice::ReadWrite | QIODevice::Truncate);
				SetFileAttributes(filename_fromserver.utf16(),FILE_ATTRIBUTE_HIDDEN);
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
	THREAD_MONITOR_POINT;
	//STOP_TIMER(monitorTimer);
	if(THREAD_IS_RUNNING(testThread))
		testThread->setTerminateFlag(1);
	if(TIMER_IS_ACTIVE(httpTimer))
		httpTimerSlot();
	if(THREAD_IS_RUNNING(mgthread))
	{
		mgthread->setTerminated(1);
		if(THREAD_IS_RUNNING(mgthread->posthp))
			mgthread->posthp->setTerminateFlag(1);
	}
	//MyThread::terminateThread();
}
void BookmarkSync::monitorTimerSlot()
{
	THREAD_MONITOR_POINT;
	STOP_TIMER(monitorTimer);
	 if(THREAD_IS_FINISHED(testThread))
	 	{
	 		DELETE_OBJECT(testThread);
	 		testNetFinished();
	 	}
	 if(THREAD_IS_FINISHED(mgthread))
	 	{
	 		DELETE_OBJECT(mgthread);
	 		mergeDone();
	 	}

	if(!needwatchchild&&terminateFlag)
	{
		needwatchchild = true;
		terminateThread();
	}

	monitorTimer->start(10);
	
}
void BookmarkSync::clearobject()
{
		THREAD_MONITOR_POINT;
		DELETE_OBJECT(http);			
		DELETE_TIMER(httpTimer);
		DELETE_OBJECT(accountTestHttp);
		DELETE_OBJECT(mgthread);
		DELETE_OBJECT(testThread);
		DELETE_FILE(resultBuffer);
		DELETE_FILE(file);
		//clear directory to avoid the xml file come from server
		{
			QDir dir = QDir(tz::getUserIniDir(GET_MODE,""));
			QStringList filters;
			filters << "*.xml" ;
	   	        dir.setNameFilters(filters);
			QStringList fromserverxmls = dir.entryList(QDir::Files|QDir::Hidden);
			for (int i = 0; i < fromserverxmls.count(); ++i)
			{
				QRegExp rx("^"FROMSERVER_XML_PREFIX"\\d+.xml$");
				if(rx.exactMatch(fromserverxmls.at(i)))
					dir.remove(fromserverxmls.at(i));
			}
		}
}
void BookmarkSync::run()
{
	qDebug()<<__FUNCTION__<<"try to aacquirec semphore!";
	semaphore->acquire(1);
	qDebug()<<__FUNCTION__<<"try to aacquirec semphore!";
	qRegisterMetaType<QHttpResponseHeader>("QHttpResponseHeader");
	THREAD_MONITOR_POINT;

	START_TIMER_INSIDE(monitorTimer,false,10,monitorTimerSlot);

	tz::netProxy(SET_MODE,settings,NULL);
	
	//check server status
	{
		testThread = new testServerThread();
		testThread->moveToThread(this);
		//connect(testThread,SIGNAL(finished()),this,  SLOT(testNetFinished()));
		if(!terminateFlag)
			emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,HTTP_CONNECT_SERVER);	
		testThread->start(QThread::IdlePriority);
	}	

	int ret=exec();
	if(testServerResult==1){
		switch(mode)
		{
		case BOOKMARK_SYNC_MODE:
			if(!http_timerover)
				emit bookmarkFinished(ret);
			break;
		case BOOKMARK_TESTACCOUNT_MODE:
			if(!http_timerover)
				emit testAccountFinishedNotify(ret,QString(resultBuffer->data()));						
			break;
		}
		STOP_TIMER(httpTimer);
		DELETE_FILE(resultBuffer);
		tz::runParameter(SET_MODE,RUN_PARAMETER_NETPROXY_USING, 0);	
	}
	clearobject();
}

void BookmarkSync::testAccountFinished(bool error)
{
	STOP_TIMER(httpTimer);
	http_finish=1;
	this->error=error;
	exit(error);
}
void BookmarkSync::mgUpdateStatus(int flag,int status)
{
	if(!terminateFlag)
		emit updateStatusNotify(flag,status);

}

void BookmarkSync::bookmarkGetFinished(bool error)
{
	THREAD_MONITOR_POINT;
	file->flush();
	DELETE_FILE(file);
	STOP_TIMER(httpTimer);
	http_finish=1;
	this->error=error;
	//qDebug("emit bookmarkFinished error %d to networkpage", error);
	if(!error)	
	{
		if(md5key==tz::fileMd5(filename_fromserver)){
			mgthread = new mergeThread(NULL,db,settings,username,password);		
			//emit updateStatusNotify(UPDATE_PROCESSING);
			mgthread->setRandomFileFromserver(filename_fromserver);
			connect(mgthread, SIGNAL(mgUpdateStatusNotify(int,int)), this, SLOT(mgUpdateStatus(int,int)));
			mgthread->start();
			//qDebug("start merge thread...........");
			return;
		}

	}
	
	if(http->error()!=QHttp::ProxyAuthenticationRequiredError)			
	{
		if(!terminateFlag)
			emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_NET_ERROR);
	}
		//else
		//qDebug("http error %s",qPrintable(http->errorString()));
	mergeDone();
	
}

void BookmarkSync::mergeDone()
{
	THREAD_MONITOR_POINT;
	if(!error&&!terminateFlag){
		emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,SYNC_SUCCESSFUL);
	}
	DELETE_OBJECT(mgthread);
	exit(error);
}


