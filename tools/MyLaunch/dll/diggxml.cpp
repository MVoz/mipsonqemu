#include <diggxml.h>
#include <bmapi.h>

void diggXml::on_http_responseHeaderReceived(const QHttpResponseHeader & resp)
{
	md5key = resp.value("md5key");
//	if(resp.statusCode() == HTTP_OK)
//		STOP_TIMER(httpTimer); 
}
diggXml::diggXml(QObject* parent,QSettings* s):MyThread(parent,s)
{
//	http_finish=0;
//	http_timerover=0;
	status=0;
	testDiggXmlResult = 0;
//	resultBuffer = NULL;
	testThread = NULL;
//	file =NULL;
//	http =NULL;
//	httpTimer = NULL;
	needwatchchild = false;
	diggid = 0;
}
/*
void diggXml::httpTimeout()
{
	THREAD_MONITOR_POINT;
	http_timerover=1;
	STOP_TIMER(httpTimer);
	if(!http_finish)
		http->abort();
}
*/
void diggXml::testNetFinished()
{
	THREAD_MONITOR_POINT;
	testDiggXmlResult=GET_RUN_PARAMETER(RUN_PARAMETER_DIGG_XML);
	DELETE_OBJECT(testThread);
	switch(testDiggXmlResult)
	{
	case TEST_NET_SUCCESS:
		{
/*
			http = new QHttp();
			http->moveToThread(this);
			SET_NET_PROXY(http,settings);
			START_TIMER_INSIDE(httpTimer,false,(tz::getParameterMib(SYS_HTTPGETRESPONDTIMEOUT))*SECONDS,httpTimeout);
*/
			//filename.clear();
			//filename=;
			setFilename(DIGG_XML_LOCAL_FILE_TMP);
			MyThread::newHttpX(FALSE,FALSE,TRUE,TRUE);
			connect(http, SIGNAL(done(bool)), this, SLOT(diggXmlGetFinished(bool)),Qt::DirectConnection);
			connect(http, SIGNAL(responseHeaderReceived(const QHttpResponseHeader &)), this, SLOT(on_http_responseHeaderReceived(const QHttpResponseHeader &)),Qt::DirectConnection);
			//filename.clear();
			//filename=QString(DIGG_XML_LOCAL_FILE);
			//file = new QFile(diggxml_fromserver);
			//if(file->open(QIODevice::ReadWrite | QIODevice::Truncate)){
			//	SetFileAttributes(diggxml_fromserver.utf16(),FILE_ATTRIBUTE_HIDDEN);
				//http->setHost(host);
//				SET_HOST_IP(settings,http,&url,header);
			http->get(url, file);
			//}
		}
		break;
	case TEST_NET_UNNEED:
		status=TEST_NET_UNNEED;
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
	if(THREAD_IS_RUNNING(testThread))
		testThread->setTerminateFlag(1);
//	if(TIMER_IS_ACTIVE(httpTimer))
//		httpTimeout();
}
void diggXml::monitorTimeout()
{
	THREAD_MONITOR_POINT;
	STOP_TIMER(monitorTimer);
	if(THREAD_IS_FINISHED(testThread))
	{
		DELETE_OBJECT(testThread);
		testNetFinished();
	}
	
	if(!needwatchchild&&terminateFlag)
	{
		needwatchchild = true;
		terminateThread();
	}
	//monitorTimer->start((tz::getParameterMib(SYS_MONITORTIMEOUT)));
	MyThread::monitorTimeout();

}
void diggXml::clearobject()
{
	THREAD_MONITOR_POINT;
	//DELETE_OBJECT(http);			
	//DELETE_TIMER(httpTimer);
	DELETE_OBJECT(testThread);
	//DELETE_FILE(resultBuffer);
//	DELETE_FILE(file);

	MyThread::clearObject();
}
void diggXml::run()
{
	THREAD_MONITOR_POINT;
	//qRegisterMetaType<QHttpResponseHeader>("QHttpResponseHeader");
	//START_TIMER_INSIDE(monitorTimer,false,(tz::getParameterMib(SYS_MONITORTIMEOUT)),monitorTimeout);
	MyThread::run();
	testThread = new testNet(NULL,settings,TEST_SERVER_DIGG_XML,diggid);
	testThread->moveToThread(this);
	testThread->start(QThread::IdlePriority);
	exec();
	if(testDiggXmlResult==1){
//		STOP_TIMER(httpTimer);
		DELETE_FILE(resultBuffer);
	}
	emit diggXmlFinishedStatusNotify(status);
	clearobject();
}

void diggXml::diggXmlGetFinished(bool error)
{
	THREAD_MONITOR_POINT;
	file->flush();
	DELETE_FILE(file);
//	STOP_TIMER(httpTimer);
//	http_finish=1;
	if(!error)	
	{
		if(md5key==tz::fileMd5(filename)){
			status = 1;
			exit(status);
			return;
		}
	}else{
		if(!filename.isEmpty()&&QFile::exists(filename)){
			QFile::remove(filename);
		}
	}
	status = 0;
	exit(status);
	return;
}
