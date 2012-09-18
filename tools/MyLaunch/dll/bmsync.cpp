#include <bmsync.h>
#include <QWaitCondition>
#include <bmapi.h>
#include <bmpost.h>
//QHttpRequestHeader header=QHttpRequestHeader("POST", BM_TEST_ACCOUNT_URL);

//header.setValue("Host", BM_SERVER_ADDRESS);
//header.setContentType("application/x-www-form-urlencoded");
// header.setValue("cookie", "jblog_authkey=MQkzMmJlNmM1OGRmODFkNGExMThiMmNhZjcyMGVjOTUwMA");			
// postString.sprintf("name=%s&link=%s",qPrintable(bc.name),qPrintable(bc.link));
//resuleBuffer=new QBuffer(NUll); //this will bring out "create"

void bmSync::on_http_responseHeaderReceived(const QHttpResponseHeader & resp)
{
	md5key = resp.value("md5key");
	if(resp.statusCode() == HTTP_OK)
		STOP_TIMER(httpTimer); 
}
bmSync::bmSync(QObject* parent,QSettings* s,QSqlDatabase* db,QSemaphore* p,int m): MyThread(parent,s),semaphore(p),mode(m)
{
	this->db=db;
	http_finish=0;
	http_timerover=0;
	status=0;
	testServerResult = 0;
	resultBuffer = NULL;
	testThread = NULL;
	file =NULL;
	http =NULL;
	mgthread=NULL;
	httpTimer = NULL;
	needwatchchild = false;
	http_state = 0;
	http_state_time = 0;
	http_send_len = 0;
	http_rcv_len = 0;
}
void bmSync::httpTimeout()
{
	THREAD_MONITOR_POINT;
	mgUpdateStatus(UPDATESTATUS_FLAG_RETRY,HTTP_TIMEOUT,UPDATE_STATUS_ICON_FAILED);
	http_timerover=1;
	STOP_TIMER(httpTimer);
	if(!http_finish)
		http->abort();
}
void bmSync::testNetFinished()
{
	THREAD_MONITOR_POINT;
	testServerResult=GET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT);
	DELETE_OBJECT(testThread);
	switch(testServerResult)
	{
	case TEST_NET_ERROR_SERVER:
		mgUpdateStatus(UPDATESTATUS_FLAG_RETRY,BM_SYNC_FAIL_SERVER_NET_ERROR,UPDATE_STATUS_ICON_FAILED);
		status = BM_SYNC_FAIL_SERVER_NET_ERROR;
		exit(status);
		break;
	case TEST_NET_ERROR_PROXY:
		mgUpdateStatus(UPDATESTATUS_FLAG_APPLY,BM_SYNC_FAIL_PROXY_ERROR,UPDATE_STATUS_ICON_FAILED);
		status = BM_SYNC_FAIL_PROXY_ERROR;
		exit(status);
		break;
	case TEST_NET_ERROR_PROXY_AUTH:
		mgUpdateStatus(UPDATESTATUS_FLAG_APPLY,BM_SYNC_FAIL_PROXY_AUTH_ERROR,UPDATE_STATUS_ICON_FAILED);
		status = BM_SYNC_FAIL_PROXY_AUTH_ERROR;
		exit(status);
		break;
	case TEST_NET_REFUSE:
		mgUpdateStatus(UPDATESTATUS_FLAG_APPLY,BM_SYNC_FAIL_SERVER_REFUSE,UPDATE_STATUS_ICON_FAILED);
		status = BM_SYNC_FAIL_SERVER_REFUSE;
		exit(status);
		break;
	case TEST_NET_SUCCESS:
		{
			http = new QHttp();
			http->moveToThread(this);
			SET_NET_PROXY(http,settings);
			//START_TIMER_INSIDE(httpTimer,false,(tz::getParameterMib(QString("httpgetrespondTimeout")))*SECONDS,httpTimeout);

			if(mode==BOOKMARK_SYNC_MODE)	
			{
				connect(http, SIGNAL(done(bool)), this, SLOT(bmxmlGetFinished(bool)),Qt::DirectConnection);
				connect(http, SIGNAL(stateChanged(int)), this, SLOT(bmxmlstateChanged(int)),Qt::DirectConnection);
				connect(http, SIGNAL(dataSendProgress(int,int)), this, SLOT(bmxmldataSendProgress(int,int)),Qt::DirectConnection);
				connect(http, SIGNAL(dataReadProgress(int,int)), this, SLOT(bmxmldataReadProgress(int,int)),Qt::DirectConnection);
				connect(http, SIGNAL(responseHeaderReceived(const QHttpResponseHeader &)), this, SLOT(on_http_responseHeaderReceived(const QHttpResponseHeader &)),Qt::DirectConnection);
				filename_fromserver.clear();
				filename_fromserver=tz::getUserFullpath(NULL,LOCAL_FULLPATH_TEMP)+QString(FROMSERVER_XML_PREFIX"%1.xml").arg(tz::qhashEx(filename_fromserver));
				file = new QFile(filename_fromserver);
				if(file->open(QIODevice::ReadWrite | QIODevice::Truncate)){
					SetFileAttributes(filename_fromserver.utf16(),FILE_ATTRIBUTE_HIDDEN);
					http->setHost(host);
					mgUpdateStatus(UPDATESTATUS_FLAG_APPLY,BM_SYNC_START,UPDATE_STATUS_ICON_LOADING);
					http->get(url, file);
				}
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
void bmSync::terminateThread()
{
	THREAD_MONITOR_POINT;
	if(THREAD_IS_RUNNING(testThread))
		testThread->setTerminateFlag(1);
	if(TIMER_IS_ACTIVE(httpTimer))
		httpTimeout();
	if(THREAD_IS_RUNNING(mgthread))
	{
		mgthread->setTerminated(1);
		if(THREAD_IS_RUNNING(mgthread->posthp))
			mgthread->posthp->setTerminateFlag(1);
	}
}
void bmSync::monitorTimeout()
{
	THREAD_MONITOR_POINT;
	STOP_TIMER(monitorTimer);
	if(http){
		http_state_time++;
		if(tz::getParameterMib(http_state)&&((http_state_time*tz::getParameterMib(SYS_MONITORTIMEOUT)/1000)>tz::getParameterMib(http_state))){
			http->abort();
		}
	}
	if(THREAD_IS_FINISHED(testThread))
	{
		DELETE_OBJECT(testThread);
		testNetFinished();
	}
	if(THREAD_IS_FINISHED(mgthread))
	{
		mergeDone();
		DELETE_OBJECT(mgthread);
	}

	if(!needwatchchild&&terminateFlag)
	{
		needwatchchild = true;
		terminateThread();
	}
	monitorTimer->start((tz::getParameterMib(SYS_MONITORTIMEOUT)));

}
void bmSync::clearobject()
{
	THREAD_MONITOR_POINT;
	DELETE_OBJECT(http);			
	DELETE_TIMER(httpTimer);
	DELETE_OBJECT(mgthread);
	DELETE_OBJECT(testThread);
	DELETE_FILE(resultBuffer);
	DELETE_FILE(file);
#if 1
	if(!filename_fromserver.isEmpty()&&QFile::exists(filename_fromserver)){
		QFile::remove(filename_fromserver);
	}
#else
	//clear directory to avoid the xml file come from server
	{
		QDir dir = QDir(tz::getUserFullpath(NULL,LOCAL_FULLPATH_TEMP));
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
#endif
}
void bmSync::run()
{
	THREAD_MONITOR_POINT;
	semaphore->acquire(1);
	qRegisterMetaType<QHttpResponseHeader>("QHttpResponseHeader");
	START_TIMER_INSIDE(monitorTimer,false,(tz::getParameterMib(SYS_MONITORTIMEOUT)),monitorTimeout);
//	tz::netProxy(SET_MODE,settings,NULL);
	//check server status
	
	testThread = new testNet(NULL,settings);
	testThread->moveToThread(this);
		//connect(testThread,SIGNAL(finished()),this,  SLOT(testNetFinished()));
	mgUpdateStatus(UPDATESTATUS_FLAG_APPLY,TRY_CONNECT_SERVER,UPDATE_STATUS_ICON_LOADING);
	testThread->start(QThread::IdlePriority);

	int ret=exec();
	if(testServerResult==1){
		switch(mode)
		{
		case BOOKMARK_SYNC_MODE:
			//if(!http_timerover)
			//	emit bmSyncFinishedNotify(ret);
			break;
		case BOOKMARK_TESTACCOUNT_MODE:
			if(!http_timerover)
				emit testAccountFinishedNotify(ret,QString(resultBuffer->data()));						
			break;
		}
		STOP_TIMER(httpTimer);
		DELETE_FILE(resultBuffer);
		//tz::runParameter(SET_MODE,RUN_PARAMETER_NETPROXY_USING, 0);	
		//SET_RUN_PARAMETER(RUN_PARAMETER_NETPROXY_USING,0);
	}
	if(mode==BOOKMARK_SYNC_MODE)
			emit bmSyncFinishedStatusNotify(status);
	clearobject();
}

void bmSync::testAccountFinished(bool error)
{
	STOP_TIMER(httpTimer);
	http_finish=1;
	if(error)
		status = BM_SYNC_FAIL_SERVER_TESTACCOUNT_FAIL;
	exit(status);
}
void bmSync::mgUpdateStatus(int flag,int statusid,int icon)
{
	THREAD_MONITOR_POINT;
	if(!terminateFlag)
		emit updateStatusNotify(flag,statusid,icon);
}
void bmSync::bmxmlstateChanged(int state){
	if(http_state!=state)
		http_state_time=0;
	http_state = state;
	TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<state);
	
}
void bmSync::bmxmldataSendProgress(int len,int total){
	if(http_send_len != len)
		http_state_time=0;
	http_send_len = len;
	TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<http_send_len);
}
void bmSync::bmxmldataReadProgress(int len,int total){
	if(http_rcv_len != len)
		http_state_time=0;
	http_rcv_len = len;
	TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<http_rcv_len);
}

void bmSync::bmxmlGetFinished(bool error)
{
	THREAD_MONITOR_POINT;
	file->flush();
	DELETE_FILE(file);
	STOP_TIMER(httpTimer);
	http_finish=1;
	//this->error=error;
	//qDebug("emit bookmarkFinished error %d to networkpage", error);
	if(!error)	
	{
		if(md5key==tz::fileMd5(filename_fromserver)){
			mgthread = new bmMerge(NULL,db,settings,username,password);		
			mgthread->setRandomFileFromserver(filename_fromserver);
			connect(mgthread, SIGNAL(mergeStatusNotify(int,int,int)), this, SLOT(mgUpdateStatus(int,int,int)));
			mgthread->start(QThread::IdlePriority);
			return;
		}
	}
	status = BM_SYNC_FAIL_SERVER_BMXML_FAIL;
	switch(http->error()){
		case QHttp::ProxyAuthenticationRequiredError:
			status = BM_SYNC_FAIL_PROXY_AUTH_ERROR;
			break;
		default:
			mgUpdateStatus(UPDATESTATUS_FLAG_RETRY,BM_SYNC_FAIL_SERVER_NET_ERROR,UPDATE_STATUS_ICON_FAILED);
			break;
	}
	mergeDone();

}

void bmSync::mergeDone()
{
	THREAD_MONITOR_POINT;
	if(mgthread){
		status = mgthread->mergestatus;
		if((status == BM_SYNC_SUCCESS_NO_MODIFY)||(status == BM_SYNC_SUCCESS_WITH_MODIFY)){
			settings->setValue("lastsyncstatus",SYNC_STATUS_SUCCESSFUL);
			settings->sync();
			mgUpdateStatus(UPDATESTATUS_FLAG_APPLY,BM_SYNC_SUCCESS_NO_MODIFY,UPDATE_STATUS_ICON_SUCCESSFUL);
		}else{
			settings->setValue("lastsyncstatus",SYNC_STATUS_FAILED);
			settings->sync();
		}
	}else{
		settings->setValue("lastsyncstatus",SYNC_STATUS_FAILED);
		settings->sync();
	}
	DELETE_OBJECT(mgthread);
	exit(status);
}


