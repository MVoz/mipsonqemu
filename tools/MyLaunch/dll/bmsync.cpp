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
	THREAD_MONITOR_POINT;
         TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<status);
	switch(status)
	{
	case TEST_NET_SUCCESS:
		{
			QDEBUG_LINE;
			if(doWhat==SYNC_DO_BOOKMARK)	
			{				
				donetThread = new DoNetThread(NULL,settings,DOWHAT_GET_BMXML_FILE,0);
				donetThread->setFilename(tz::getUserFullpath(NULL,LOCAL_FULLPATH_TEMP)+QString(FROMSERVER_XML_PREFIX"%1.xml").arg(tz::qhashEx(QTime::currentTime().toString("hh:mm:ss.zzz"))));
				sendUpdateStatusNotify(BM_SYNC_START);
			}else if(doWhat==SYNC_DO_TESTACCOUNT){
				donetThread = new DoNetThread(NULL,settings,DOWHAT_TEST_ACCOUNT,0);
				sendUpdateStatusNotify(BM_TESTACCOUNT_START);
			}
			donetThread->moveToThread(this);	
			donetThread->setUrl(url);
			connect(donetThread, SIGNAL(doNetStatusNotify(int)), this, SLOT(sendUpdateStatusNotify(int)));
			donetThread->start(QThread::IdlePriority);
		}						
		break;
	case TEST_DIGGXML_SUCCESS:
		donetThread = new DoNetThread(NULL,settings,DOWHAT_GET_DIGGXML_FILE,0);
		donetThread->setFilename(DIGG_XML_LOCAL_FILE_TMP);
		donetThread->moveToThread(this);	
		donetThread->setUrl(url);
		donetThread->start(QThread::IdlePriority);
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
			case DOWHAT_TEST_SERVER_DIGG_XML:
				testNetFinished(s);
			break;
			case DOWHAT_GET_DIGGXML_FILE:
				diggxmlGetFinished(s);
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
	if(semaphore)
		semaphore->acquire(1);
	NetThread::run();
	sendUpdateStatusNotify(TRY_CONNECT_SERVER);


	switch(doWhat){
		case SYNC_DO_BOOKMARK:
		case SYNC_DO_TESTACCOUNT:
			donetThread = new DoNetThread(NULL,settings,DOWHAT_TEST_SERVER_NET,0);
			donetThread->setUrl(TEST_NET_URL);
		break;
		case SYNC_DO_DIGG:
			donetThread = new DoNetThread(NULL,settings,DOWHAT_TEST_SERVER_DIGG_XML,diggid);
			donetThread->setUrl(QString(TEST_DIGGXML_URL).append(QString("&id=%1").arg(diggid)));
		break;
		default:
		break;
	}
	

	donetThread->moveToThread(this);		
	connect(donetThread, SIGNAL(doNetStatusNotify(int)), this, SLOT(sendUpdateStatusNotify(int)));
	donetThread->start(QThread::IdlePriority);
	
	
	int ret=exec();
	
	if(doWhat==SYNC_DO_BOOKMARK){
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
void bmSync::bmxmlGetFinished(int status)
{
	TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<status);
	THREAD_MONITOR_POINT;
	if(status==DOWHAT_GET_FILE_SUCCESS){
		mgthread = new bmMerge(NULL,db,settings,username,password);		
		mgthread->setRandomFileFromserver(filename);
		connect(mgthread, SIGNAL(mergeStatusNotify(int)), this, SLOT(sendUpdateStatusNotify(int)));
		mgthread->start(QThread::IdlePriority);
		return;
	}
	exit(-1);	
}
void bmSync::diggxmlGetFinished(int status)
{
	THREAD_MONITOR_POINT;
	TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<status);
	statusCode = status;
	exit(-1);	
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


