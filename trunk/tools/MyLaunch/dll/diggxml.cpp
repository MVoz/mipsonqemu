#include <diggxml.h>
#include <bmapi.h>

diggXml::diggXml(QObject* parent,QSettings* s):NetThread(parent,s,0)
{
	testDiggXmlResult = 0;
	donetThread = NULL;
	needwatchchild = false;
	diggid = 0;
}
diggXml::~diggXml(){

}
void diggXml::testNetFinished()
{
	THREAD_MONITOR_POINT;
	testDiggXmlResult=GET_RUN_PARAMETER(RUN_PARAMETER_DIGG_XML);
	DELETE_OBJECT(donetThread);
	switch(testDiggXmlResult)
	{
	case TEST_NET_SUCCESS:
		{
			setFilename(DIGG_XML_LOCAL_FILE_TMP);
			NetThread::newHttp(FALSE,FALSE,TRUE,TRUE);
			connect(http, SIGNAL(done(bool)), this, SLOT(diggXmlGetFinished(bool)),Qt::DirectConnection);
			http->get(url, file);
		}
		break;
	case TEST_NET_UNNEED:
		statusCode=TEST_NET_UNNEED;
		exit(0);
		break;
	default:
		exit(0);
		break;
	}	
}
void diggXml::terminateThread()
{
	THREAD_MONITOR_POINT;
	if(THREAD_IS_RUNNING(donetThread))
		donetThread->setTerminateFlag(1);
}
void diggXml::monitorTimeout()
{
	THREAD_MONITOR_POINT;
	STOP_TIMER(monitorTimer);
	if(THREAD_IS_FINISHED(donetThread))
	{
		DELETE_OBJECT(donetThread);
		testNetFinished();
	}
	
	if(!needwatchchild&&terminateFlag)
	{
		needwatchchild = true;
		terminateThread();
	}
	NetThread::monitorTimeout();

}
void diggXml::cleanObjects(){
	THREAD_MONITOR_POINT;
	DELETE_OBJECT(donetThread);
	NetThread::cleanObjects();
}

void diggXml::run()
{
	THREAD_MONITOR_POINT;
	NetThread::run();
	donetThread = new DoNetThread(NULL,settings,DOWHAT_TEST_SERVER_DIGG_XML,diggid);
	donetThread->moveToThread(this);
	donetThread->start(QThread::IdlePriority);
	exec();
	//if(testDiggXmlResult==1){
	//	DELETE_BUFFER(resultBuffer);
	//}
	emit diggXmlFinishedStatusNotify(statusCode);
	cleanObjects();
}

void diggXml::diggXmlGetFinished(bool error)
{
	THREAD_MONITOR_POINT;
	DELETE_FILE(file);
	if(!error)	
	{
		if(md5key==tz::fileMd5(filename)){
			statusCode = 1;
			exit(statusCode);
			return;
		}
	}else{
		if(!filename.isEmpty()&&QFile::exists(filename)){
			QFile::remove(filename);
		}
	}
	statusCode = 0;
	exit(statusCode);
	return;
}
