#include <bmsync.h>
#include <QWaitCondition>
#include <bmapi.h>
#include <bmpost.h>
bmSync::bmSync(QObject* parent,QSettings* s,QSqlDatabase* db,QSemaphore* p,int m): NetThread(parent,s,m),semaphore(p)
{
	this->db=db;
	donetThread = NULL;
	mgthread=NULL;
	needwatchchild = false;
}
bmSync::~bmSync(){
}

void bmSync::testNetFinished(int status)
{
	 TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<status);
	THREAD_MONITOR_POINT;
	switch(status)
	{
#if 0
	case TEST_NET_ERROR_SERVER:
		sendUpdateStatusNotify(BM_SYNC_FAIL_SERVER_NET_ERROR);
		exit(-1);
		break;
	case TEST_NET_ERROR_PROXY_AUTH:
		sendUpdateStatusNotify(BM_SYNC_FAIL_PROXY_AUTH_ERROR);
		exit(-1);
		break;
	case TEST_NET_REFUSE:
		sendUpdateStatusNotify(BM_SYNC_FAIL_SERVER_REFUSE);
		exit(-1);
		break;
#endif
	case TEST_NET_SUCCESS:
		{
			QDEBUG_LINE;
			if(doWhat==BOOKMARK_SYNC_MODE)	
			{				
#if 1
				donetThread = new DoNetThread(NULL,settings,DOWHAT_GET_BMXML_FILE,0);
				donetThread->setFilename(tz::getUserFullpath(NULL,LOCAL_FULLPATH_TEMP)+QString(FROMSERVER_XML_PREFIX"%1.xml").arg(tz::qhashEx(QTime::currentTime().toString("hh:mm:ss.zzz"))));
				sendUpdateStatusNotify(BM_SYNC_START);
#else
				setFilename(tz::getUserFullpath(NULL,LOCAL_FULLPATH_TEMP)+QString(FROMSERVER_XML_PREFIX"%1.xml").arg(tz::qhashEx(QTime::currentTime().toString("hh:mm:ss.zzz"))));
				NetThread::newHttp(FALSE,FALSE,TRUE,TRUE);
				connect(http, SIGNAL(done(bool)), this, SLOT(bmxmlGetFinished(bool)),Qt::DirectConnection);
				sendUpdateStatusNotify(BM_SYNC_START);
				http->get(url, file);
#endif
				QDEBUG_LINE;
			}else if(doWhat==BOOKMARK_TESTACCOUNT_MODE){
#if 1
				donetThread = new DoNetThread(NULL,settings,DOWHAT_TEST_ACCOUNT,0);
				sendUpdateStatusNotify(BM_TESTACCOUNT_START);
#else
				NetThread::newHttp(FALSE,TRUE,FALSE,FALSE);
				connect(http, SIGNAL(done(bool)), this, SLOT(testAccountFinished(bool)));
				sendUpdateStatusNotify(BM_TESTACCOUNT_START);
				http->get(url, resultBuffer);
#endif
			}
#if 1
				donetThread->moveToThread(this);	
				donetThread->setUrl(url);
				connect(donetThread, SIGNAL(doNetStatusNotify(int)), this, SLOT(sendUpdateStatusNotify(int)));
				donetThread->start(QThread::IdlePriority);
#endif
		}						
		break;
	default:
		exit(-1);
		break;
	}	
}
void bmSync::terminateThread()
{
	THREAD_MONITOR_POINT;
	if(THREAD_IS_RUNNING(donetThread))
		donetThread->setTerminateFlag(1);

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
	if(THREAD_IS_FINISHED(donetThread))
	{
		int d = donetThread->doWhat;
		int s = donetThread->statusCode;
		DELETE_OBJECT(donetThread);
		switch(d){
			case DOWHAT_TEST_SERVER_NET:
				testNetFinished(s);
			break;
			case DOWHAT_GET_BMXML_FILE:
				bmxmlGetFinished(s);
			break;
		}
		
	}
	if(THREAD_IS_FINISHED(mgthread))
	{
		mergeDone();
	}

	if(!needwatchchild&&terminateFlag)
	{
		needwatchchild = true;
		terminateThread();
	}
	NetThread::monitorTimeout();
}
void bmSync::cleanObjects(){
	DELETE_OBJECT(mgthread);
	DELETE_OBJECT(donetThread);
	if(!filename.isEmpty()&&QFile::exists(filename)){
		QFile::remove(filename);
	}
	NetThread::cleanObjects();
}

void bmSync::run()
{
	THREAD_MONITOR_POINT;
	semaphore->acquire(1);
	NetThread::run();
	sendUpdateStatusNotify(TRY_CONNECT_SERVER);
	donetThread = new DoNetThread(NULL,settings,DOWHAT_TEST_SERVER_NET,0);
	donetThread->moveToThread(this);	
	donetThread->setUrl(TEST_NET_URL);
	connect(donetThread, SIGNAL(doNetStatusNotify(int)), this, SLOT(sendUpdateStatusNotify(int)));
	donetThread->start(QThread::IdlePriority);
	
	
	int ret=exec();
	
	if(doWhat==BOOKMARK_SYNC_MODE){
		if(ret<0){
			settings->setValue("lastsyncstatus",SYNC_STATUS_FAILED);
		}else{
			settings->setValue("lastsyncstatus",SYNC_STATUS_SUCCESSFUL);
		}
		settings->sync();
	}
	cleanObjects();
	QDEBUG_LINE;
}
/*
void bmSync::testAccountFinished(bool error)
{
	if(!error&&QString(resultBuffer->data())==DOSUCCESSS){
		sendUpdateStatusNotify(HTTP_TEST_ACCOUNT_SUCCESS);
		exit(0);
	}else{	
		sendUpdateStatusNotify(HTTP_TEST_ACCOUNT_FAIL);
		exit(-1);
	}
}
*/
void bmSync::bmxmlGetFinished(int status)
{
	 TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<status);
	THREAD_MONITOR_POINT;
#if 0
	DELETE_FILE(file);
	if(error){
		switch(http->error()){
			case QHttp::ProxyAuthenticationRequiredError:
				sendUpdateStatusNotify(BM_SYNC_FAIL_PROXY_AUTH_ERROR);
				break;
			default:
				sendUpdateStatusNotify(BM_SYNC_FAIL_SERVER_NET_ERROR);
				break;
		}
		exit(-1);
		return;
	}
#endif
	if(status==DOWHAT_GET_FILE_SUCCESS){
		mgthread = new bmMerge(NULL,db,settings,username,password);		
		mgthread->setRandomFileFromserver(filename);
		connect(mgthread, SIGNAL(mergeStatusNotify(int)), this, SLOT(sendUpdateStatusNotify(int)));
		mgthread->start(QThread::IdlePriority);
		return;
	}else{
		//sendUpdateStatusNotify(BM_SYNC_FAIL_GET_XML_FROM_SERVER);
		exit(-1);
	}
}

void bmSync::mergeDone()
{
	THREAD_MONITOR_POINT;
	QDEBUG_LINE;
	if(mgthread->mergestatus==BM_SYNC_SUCCESS_NO_MODIFY||mgthread->mergestatus==BM_SYNC_SUCCESS_WITH_MODIFY)
		exit(0);
	else
		exit(-1);
}


