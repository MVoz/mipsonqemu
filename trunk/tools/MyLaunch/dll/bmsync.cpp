#include <bmsync.h>
#include <QWaitCondition>
#include <bmapi.h>
#include <bmpost.h>
bmSync::bmSync(QObject* parent,QSettings* s,QSqlDatabase* db,QSemaphore* p,int m): NetThread(parent,s,m),semaphore(p)
{
	this->db=db;
	doNetThread = NULL;
	//doTestNetThread=NULL;
	mgthread=NULL;
	needwatchchild = false;
	bmSyncMode = SYN_MODE_SILENCE;
}
void bmSync::testNetFinished(int status)
{
	THREAD_MONITOR_POINT;
//	doTestNetThread->finish_flag = true;
         TD(DEBUG_LEVEL_NORMAL, tz::getstatusstring(status));
	switch(status)
	{
	case TEST_NET_SUCCESS:
		{
			if(doWhat==SYNC_DO_BOOKMARK)	
			{				
				doNetThread = new DoNetThread(NULL,settings,DOWHAT_GET_BMXML_FILE,0);
				doNetThread->setFileWithFullpath(tz::getUserFullpath(NULL,LOCAL_FULLPATH_TEMP)+QString(FROMSERVER_XML_PREFIX"%1.xml").arg(tz::qhashEx(QTime::currentTime().toString("hh:mm:ss.zzz"))));
				setFileWithFullpath(doNetThread->fileWithFullpath);
				sendUpdateStatusNotify(BM_SYNC_START);
			}else if(doWhat==SYNC_DO_TESTACCOUNT){
				doNetThread = new DoNetThread(NULL,settings,DOWHAT_TEST_ACCOUNT,0);
				sendUpdateStatusNotify(BM_TESTACCOUNT_START);
			}
			doNetThread->moveToThread(this);	
			doNetThread->setUrl(url);
			threadList.append((QThread*)doNetThread);
			connect(doNetThread, SIGNAL(doNetStatusNotify(int)), this, SLOT(sendUpdateStatusNotify(int)),Qt::DirectConnection);
			//connect(doNetThread, SIGNAL(doNetStatusNotify(int)), this, SLOT(sendUpdateStatusNotify(int)));
			doNetThread->start(QThread::IdlePriority);
		}						
		break;
	case TEST_DIGGXML_SUCCESS:
		doNetThread = new DoNetThread(NULL,settings,DOWHAT_GET_DIGGXML_FILE,0);
		doNetThread->setFileWithFullpath(DIGG_XML_LOCAL_FILE_TMP);
		doNetThread->moveToThread(this);	
		doNetThread->setUrl(url);
		threadList.append((QThread*)doNetThread);
		doNetThread->start(QThread::IdlePriority);
		break;
	default:
		exit(-1);
		break;
	}	
}
void bmSync::terminateThread()
{
	THREAD_MONITOR_POINT;
	if(THREAD_IS_RUNNING(doNetThread))
		doNetThread->setTerminateFlag(1);

	if(THREAD_IS_RUNNING(mgthread))
	{
		mgthread->setTerminated(1);
		if(THREAD_IS_RUNNING(mgthread->postHttp))
			mgthread->postHttp->setTerminateFlag(1);
	}
}
void bmSync::monitorTimeout()
{
	THREAD_MONITOR_POINT;
	STOP_TIMER(monitorTimer);
/*
	if(THREAD_IS_FINISHED(doTestNetThread))
	{
		if(!doTestNetThread->finish_flag){
			int d = doTestNetThread->doWhat;
			int s = doTestNetThread->statusCode;
			switch(d){
				case DOWHAT_TEST_SERVER_NET:
				case DOWHAT_TEST_SERVER_DIGG_XML:
					testNetFinished(s);
				break;
			}
		}
	}
*/
	if(THREAD_IS_FINISHED(doNetThread))
	{
		//TD(DEBUG_LEVEL_NORMAL,doNetThread->doWhat);
		if(!doNetThread->finish_flag){
			doNetThread->finish_flag=true;
			int d = doNetThread->doWhat;
			int s = doNetThread->statusCode;
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
				case DOWHAT_TEST_ACCOUNT:
					statusCode = s;
					exit(-1);
				break;
			}
		}
		
	}
	if(THREAD_IS_FINISHED(mgthread))
	{
		//if(!mgthread->finish_flag){
			mergeDone();
			return;
		//}
	}

	if(!needwatchchild&&terminateFlag)
	{
		needwatchchild = true;
		terminateThread();
	}
	NetThread::monitorTimeout();
}
void bmSync::cleanObjects(){
	
	if(!fileWithFullpath.isEmpty()&&QFile::exists(fileWithFullpath)){
		QFile::remove(fileWithFullpath);
	}
	NetThread::cleanObjects();	
}
void bmSync::doTestNetFinished(){
	THREAD_MONITOR_POINT;	
//	TD(DEBUG_LEVEL_NORMAL, "######"<<doTestNetThread->isFinished());
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
			doNetThread = new DoNetThread(NULL,settings,DOWHAT_TEST_SERVER_NET,0);
			doNetThread->setUrl(TEST_NET_URL);
		break;
		case SYNC_DO_DIGG:
			doNetThread = new DoNetThread(NULL,settings,DOWHAT_TEST_SERVER_DIGG_XML,diggid);
			doNetThread->setUrl(QString(TEST_DIGGXML_URL).append(QString("&id=%1").arg(diggid)));
		break;
		default:
		break;
	}	
	threadList.append((QThread*)doNetThread);
	//doNetThread->moveToThread(this);		
	connect(doNetThread, SIGNAL(doNetStatusNotify(int)), this, SLOT(sendUpdateStatusNotify(int)),Qt::DirectConnection);
	//connect(doTestNetThread, SIGNAL(finished()), this, SLOT(doTestNetFinished()),Qt::DirectConnection);
	doNetThread->start(QThread::IdlePriority);
		
	exec();
	cleanObjects();
}
void bmSync::bmxmlGetFinished(int status)
{
	//doNetThread->finish_flag = true;
	TD(DEBUG_LEVEL_NORMAL, tz::getstatusstring(status)<<fileWithFullpath);
	THREAD_MONITOR_POINT;
	if(status==DOWHAT_GET_FILE_SUCCESS){
		sendUpdateStatusNotify(BM_MERGE_START);
		mgthread = new bmMerge(NULL,db,settings,username,password);		
		mgthread->setRandomFileFromserver(fileWithFullpath);
		threadList.append((QThread*)mgthread);
		connect(mgthread, SIGNAL(mergeStatusNotify(int)), this, SLOT(sendUpdateStatusNotify(int)),Qt::DirectConnection);
		mgthread->start(QThread::IdlePriority);
		return;
	}
	exit(-1);	
}
void bmSync::diggxmlGetFinished(int status)
{
	THREAD_MONITOR_POINT;
	//doNetThread->finish_flag = true;
	TD(DEBUG_LEVEL_NORMAL, tz::getstatusstring(status) );
	statusCode = status;
	exit(-1);	
}

void bmSync::mergeDone()
{
	THREAD_MONITOR_POINT;
	TD(DEBUG_LEVEL_NORMAL, tz::getstatusstring(mgthread->mergestatus));
	if(mgthread->mergestatus==BM_SYNC_SUCCESS_NO_MODIFY||mgthread->mergestatus==BM_SYNC_SUCCESS_WITH_MODIFY)
		exit(0);
	else
		exit(-1);
}


