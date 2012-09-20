#include <bmpost.h>
#include <bmsync.h>
#include <bmapi.h>

bmPost::bmPost(QObject * parent,QSettings* s,int type ):MyThread(parent,s)
{
	postType=type;
//ostTimer = NULL;
//	resultBuffer = NULL;
//	posthttp = NULL;
}
void bmPost::clearObject()
{
	THREAD_MONITOR_POINT;
	MyThread::clearObject();
//	DELETE_FILE(resultBuffer);
//	DELETE_TIMER(monitorTimer);
//ELETE_TIMER(postTimer);
//	DELETE_OBJECT(posthttp);
}
void bmPost::run()
{
	THREAD_MONITOR_POINT;
	//START_TIMER_INSIDE(monitorTimer,false,(tz::getParameterMib(SYS_MONITORTIMEOUT)),monitorTimeout);
        //TART_TIMER_INSIDE(postTimer,false,POST_ITEM_TIMEOUT*SECONDS,postTimeout);	
	MyThread::run();

/*
#ifdef CONFIG_SERVER_IP_SETTING
	SET_HOST_IP(settings,http);
#else
	http->setHost(BM_SERVER_ADDRESS);
#endif
*/
	
	
	switch(postType)
	{
	case POST_HTTP_TYPE_HANDLE_ITEM:
		{
			//QString bm_handle_url;
			qsrand((unsigned) NOW_SECONDS);
			uint key=qrand()%(getkeylength());
			QString auth_encrypt_str=tz::encrypt(QString("username=%1 password=%2").arg(username).arg(password),key);			
			if(action==POST_HTTP_ACTION_ADD_ITEM||action==POST_HTTP_ACTION_ADD_DIR)
			{
				url=QString(BM_SERVER_ADD_URL).arg(parentid).arg(browserid).arg(auth_encrypt_str).arg(key);
			}
			else if(action==POST_HTTP_ACTION_DELETE_ITEM)
			{
				url=QString(BM_SERVER_DELETE_URL).arg(bmid).arg(browserid).arg(auth_encrypt_str).arg(key);
			}
			else if(action==POST_HTTP_ACTION_DELETE_DIR)
			{
				url=QString(BM_SERVER_DELETE_DIR).arg(bmid).arg(browserid).arg(auth_encrypt_str).arg(key);
			}
		}
		break;
	case POST_HTTP_TYPE_TESTACCOUNT:
		url = QString(BM_TEST_ACCOUNT_URL);	
		break;				
	}
/*
#ifdef CONFIG_SERVER_IP_SETTING
	do{
		QString serverIp = (settings)->value("serverip","" ).toString().trimmed();
		if( !serverIp.isEmpty())
			header.setValue("Host", serverIp);
		else
			header.setValue("Host", BM_SERVER_ADDRESS);
	}while(0);
#else
	header.setValue("Host", BM_SERVER_ADDRESS);
#endif
*/
	//header=new QHttpRequestHeader("POST", url);
	MyThread::newHttpX(TRUE,TRUE,FALSE,FALSE);
	connect(http, SIGNAL(done(bool)), this, SLOT(httpDone(bool)), Qt::DirectConnection);
	//SET_HOST_IP(settings,http,&url,header);
	
	//MyThread::newHttpBuffer();
	//resultBuffer = new QBuffer();
	//resultBuffer->moveToThread(this);
	//resultBuffer->open(QIODevice::ReadWrite);
	http->request(*header, postString.toUtf8(), resultBuffer);
	exec();
	if(http)
		disconnect(http, 0, 0, 0);
	clearObject();
}

void bmPost::httpDone(bool error)
{
	THREAD_MONITOR_POINT;
//	STOP_TIMER(postTimer);
	if(!error)
	{
		uint newgroupid=0;
		QString lastModified=0;
		uint bmid=0;
		QXmlStreamReader* resultXml=new QXmlStreamReader(resultBuffer->data());
		while (!resultXml->atEnd())
		{
			resultXml->readNext();
			if (resultXml->isStartElement())
			{
				if (resultXml->name() == "status" )
				{
					if(resultXml->attributes().value("result").toString()==DOSUCCESSS)
					{
						lastModified=resultXml->attributes().value("lastmodified").toString();
						newgroupid=resultXml->attributes().value("groupid").toString().toUInt();
						bmid=resultXml->attributes().value("bmid").toString().toUInt();
					}
					break;
				}
			} 
		}
		if(!lastModified.isEmpty()){
			setUpdatetime(lastModified);
		}else
			error = QHttp::UnknownError;
		switch(action){
			case POST_HTTP_ACTION_DELETE_ITEM:					
				break;
			case POST_HTTP_ACTION_DELETE_DIR:
				break;
			case POST_HTTP_ACTION_ADD_ITEM:
				if(bmid){
					SET_RUN_PARAMETER(RUN_PARAMETER_POST_BMID,bmid);
				}else
					error = QHttp::UnknownError;
				break;
			case POST_HTTP_ACTION_ADD_DIR:
				if(newgroupid&&bmid){
					SET_RUN_PARAMETER(RUN_PARAMETER_POST_MAX_GROUPID,newgroupid);
					SET_RUN_PARAMETER(RUN_PARAMETER_POST_BMID,bmid);	
				}else
					error = QHttp::UnknownError;
				break;
		}
		/*
		//groupid maybe is zero,but bmid mustn't be zero
		if((!lastModified.isEmpty())&&bmid){
			//setMaxGroupId(newgroupid);
			SET_RUN_PARAMETER(RUN_PARAMETER_POST_MAX_GROUPID,newgroupid);
			setUpdatetime(lastModified);
			//setBmId(bmid);
			SET_RUN_PARAMETER(RUN_PARAMETER_POST_BMID,bmid);			
		}else
			error = QHttp::UnknownError;
		*/
		DELETE_OBJECT(resultXml);
		qDebug("%s resultBuffer=%s gMaxGroupId=%u lastModified=%s bmid=%u",__FUNCTION__,qPrintable( QString(resultBuffer->data())),GET_RUN_PARAMETER(RUN_PARAMETER_POST_MAX_GROUPID),qPrintable(lastModified),GET_RUN_PARAMETER(RUN_PARAMETER_POST_BMID));
	}
	//setPostError(error);
	SET_RUN_PARAMETER(RUN_PARAMETER_POST_ERROR,error);
	exit(error);
}
/*
void bmPost::postTimeout()
{
	THREAD_MONITOR_POINT;
	STOP_TIMER(monitorTimer);
	STOP_TIMER(postTimer);
	http->abort();
}
*/
void bmPost::terminateThread()
{
	//postTimeout();
	MyThread::terminateThread();
}
void bmPost::monitorTimeout(){
	STOP_TIMER(monitorTimer);
/*
	if(http){
		http_timeout++;
		if(tz::getParameterMib(http_state)&&((http_timeout*tz::getParameterMib(SYS_MONITORTIMEOUT)/1000)>tz::getParameterMib(http_state))){
			http->abort();
		}
	}
	monitorTimer->start((tz::getParameterMib(SYS_MONITORTIMEOUT)));
*/
	MyThread::monitorTimeout();
}
