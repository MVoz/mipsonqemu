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

void BookmarkSync::on_http_responseHeaderReceived(const QHttpResponseHeader & resp)
{
	md5key = resp.value("md5key");
}
BookmarkSync::BookmarkSync(QObject* parent,QSqlDatabase* db,QSettings* s,QSemaphore* p,int m): MyThread(parent),settings(s),semaphore(p),mode(m)
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
}
BookmarkSync::~BookmarkSync(){
}
void BookmarkSync::httpTimeout()
{
	THREAD_MONITOR_POINT;
	mgUpdateStatus(UPDATESTATUS_FLAG_RETRY,HTTP_TIMEOUT);
	http_timerover=1;
	STOP_TIMER(httpTimer);
	if(!http_finish)
		http->abort();
}
void BookmarkSync::testNetFinished()
{
	THREAD_MONITOR_POINT;
	testServerResult = tz::runParameter(GET_MODE,RUN_PARAMETER_TESTNET_RESULT,0);
	DELETE_OBJECT(testThread);
	switch(testServerResult)
	{
	case TEST_NET_ERROR_SERVER:
		mgUpdateStatus(UPDATESTATUS_FLAG_RETRY,UPDATE_NET_ERROR);
		status = BM_SYNC_FAIL_SERVER_NET_ERROR;
		exit(status);
		break;
	case TEST_NET_ERROR_PROXY:
		mgUpdateStatus(UPDATESTATUS_FLAG_APPLY,UPDATE_NET_ERROR_PROXY);
		status = BM_SYNC_FAIL_PROXY_ERROR;
		exit(status);
		break;
	case TEST_NET_ERROR_PROXY_AUTH:
		mgUpdateStatus(UPDATESTATUS_FLAG_APPLY,UPDATE_NET_ERROR_PROXY_AUTH);
		status = BM_SYNC_FAIL_PROXY_AUTH_ERROR;
		exit(status);
		break;
	case TEST_NET_REFUSE:
		mgUpdateStatus(UPDATESTATUS_FLAG_APPLY,UPDATE_SERVER_REFUSE);
		status = BM_SYNC_FAIL_SERVER_REFUSE;
		exit(status);
		break;
	case TEST_NET_SUCCESS:
		{
			http = new QHttp();
			http->moveToThread(this);
			SET_NET_PROXY(http);
			START_TIMER_INSIDE(httpTimer,false,10*SECONDS,httpTimeout);

			if(mode==BOOKMARK_SYNC_MODE)	
			{
				connect(http, SIGNAL(done(bool)), this, SLOT(bmxmlGetFinished(bool)),Qt::DirectConnection);
				connect(http, SIGNAL(responseHeaderReceived(const QHttpResponseHeader &)), this, SLOT(on_http_responseHeaderReceived(const QHttpResponseHeader &)),Qt::DirectConnection);
				filename_fromserver.clear();
				getUserLocalFullpath(settings,QUuid::createUuid ().toString(),filename_fromserver);
				filename_fromserver=tz::getUserIniDir(GET_MODE,"")+"/"+QString(FROMSERVER_XML_PREFIX"%1.xml").arg(qhashEx(filename_fromserver,filename_fromserver.length()));
				//qDebug("random file from server:%s",qPrintable(filename_fromserver));
				file = new QFile(filename_fromserver);
				if(file->open(QIODevice::ReadWrite | QIODevice::Truncate)){
					SetFileAttributes(filename_fromserver.utf16(),FILE_ATTRIBUTE_HIDDEN);
					http->setHost(host);
					mgUpdateStatus(UPDATESTATUS_FLAG_APPLY,BOOKMARK_SYNC_START);
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
void BookmarkSync::terminateThread()
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
void BookmarkSync::monitorTimeout()
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
		mergeDone();
		DELETE_OBJECT(mgthread);
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
	THREAD_MONITOR_POINT;
	semaphore->acquire(1);
	qRegisterMetaType<QHttpResponseHeader>("QHttpResponseHeader");
	START_TIMER_INSIDE(monitorTimer,false,10,monitorTimeout);
	tz::netProxy(SET_MODE,settings,NULL);
	//check server status
	
	testThread = new testServerThread();
	testThread->moveToThread(this);
		//connect(testThread,SIGNAL(finished()),this,  SLOT(testNetFinished()));
	mgUpdateStatus(UPDATESTATUS_FLAG_APPLY,HTTP_CONNECT_SERVER);
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
		tz::runParameter(SET_MODE,RUN_PARAMETER_NETPROXY_USING, 0);	
	}
	if(mode==BOOKMARK_SYNC_MODE)
			emit bmSyncFinishedStatusNotify(status);
	clearobject();
}

void BookmarkSync::testAccountFinished(bool error)
{
	STOP_TIMER(httpTimer);
	http_finish=1;
	if(error)
		status = BM_SYNC_FAIL_SERVER_TESTACCOUNT_FAIL;
	exit(status);
}
void BookmarkSync::mgUpdateStatus(int flag,int statusid)
{
	if(!terminateFlag)
		emit updateStatusNotify(flag,statusid);
}
void BookmarkSync::bmxmlGetFinished(bool error)
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
			mgthread = new mergeThread(NULL,db,settings,username,password);		
			mgthread->setRandomFileFromserver(filename_fromserver);
			connect(mgthread, SIGNAL(mgUpdateStatusNotify(int,int)), this, SLOT(mgUpdateStatus(int,int)));
			mgthread->start();
			return;
		}
	}
	status = BM_SYNC_FAIL_SERVER_BMXML_FAIL;

	switch(http->error()){
		case QHttp::ProxyAuthenticationRequiredError:
			status = BM_SYNC_FAIL_PROXY_AUTH_ERROR;
		break;
		default:
			mgUpdateStatus(UPDATESTATUS_FLAG_RETRY,UPDATE_NET_ERROR);
			break;
	}
	mergeDone();

}

void BookmarkSync::mergeDone()
{
	THREAD_MONITOR_POINT;
	if(mgthread){
		switch(mgthread->status){
			case MERGE_STATUS_SUCCESS_NO_MODIFY:
				status = BM_SYNC_SUCCESS_NO_ACTION;
			break;
			case MERGE_STATUS_SUCCESS_WITH_MODIFY:
				status = BM_SYNC_SUCCESS_WITH_ACTION;
			break;
			case MERGE_STATUS_FAIL:
				status = BM_SYNC_FAIL_MERGE_ERROR;
			case MERGE_STATUS_FAIL_LOGIN:
				status = BM_SYNC_FAIL_SERVER_LOGIN;
			break;
		}
		if((status == BM_SYNC_SUCCESS_NO_ACTION)||(status == BM_SYNC_SUCCESS_WITH_ACTION)){
			settings->setValue("lastsyncstatus",1);
			settings->sync();
			mgUpdateStatus(UPDATESTATUS_FLAG_APPLY,SYNC_SUCCESSFUL);
		}
	}
	DELETE_OBJECT(mgthread);
	exit(status);
}


