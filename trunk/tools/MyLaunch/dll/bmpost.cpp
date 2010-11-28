#include <bmpost.h>
#include <bmsync.h>
#include <bmapi.h>

bmPost::bmPost(QObject * parent,QSettings* s,int type ):MyThread(parent,s)
{
	postType=type;
	postTimer = NULL;
	resultBuffer = NULL;
	posthttp = NULL;
}
void bmPost::clearObject()
{
	THREAD_MONITOR_POINT;
	DELETE_FILE(resultBuffer);
	DELETE_TIMER(monitorTimer);
	DELETE_TIMER(postTimer);
	DELETE_OBJECT(posthttp);
}
void bmPost::gorun()
{
	THREAD_MONITOR_POINT;
	START_TIMER_INSIDE(monitorTimer,false,10,monitorTimeout);
	START_TIMER_INSIDE(postTimer,false,POST_ITEM_TIMEOUT*SECONDS,postTimeout);	
	
	posthttp = new QHttp();
	posthttp->moveToThread(this);	
	SET_NET_PROXY(posthttp,settings);
	/*

	I found the problem:
	From the Qt docs, a Qt::QueuedConnection will cause the slot to execute when control returns to the event loop 
	of the thread where the receiver object lives. The receiver object in my case is the QThread object which is 
	created, and thus lives, in the main GUI thread. The QTimer is created in the thread spawned off of the 
	QThread object. So in this case I needed a Qt:: DirectConnection.
	*/
	connect(posthttp, SIGNAL(done(bool)), this, SLOT(httpDone(bool)), Qt::DirectConnection);
#ifdef CONFIG_SERVER_IP_SETTING
	SET_HOST_IP(settings,posthttp);
#else
	posthttp->setHost(BM_SERVER_ADDRESS);
#endif
	QHttpRequestHeader header;
	switch(postType)
	{
	case POST_HTTP_TYPE_HANDLE_ITEM:
		{
			QString bm_handle_url;
			qsrand((unsigned) NOW_SECONDS);
			uint key=qrand()%(getkeylength());
			QString auth_encrypt_str=tz::encrypt(QString("username=%1 password=%2").arg(username).arg(password),key);			
			if(action==POST_HTTP_ACTION_ADD_URL||action==POST_HTTP_ACTION_ADD_DIR)
			{
				bm_handle_url=QString(BM_SERVER_ADD_URL).arg(parentid).arg(browserid).arg(auth_encrypt_str).arg(key);
			}
			else if(action==POST_HTTP_ACTION_DELETE_URL)
			{
				bm_handle_url=QString(BM_SERVER_DELETE_URL).arg(bmid).arg(browserid).arg(auth_encrypt_str).arg(key);
			}
			else if(action==POST_HTTP_ACTION_DELETE_DIR)
			{
				bm_handle_url=QString(BM_SERVER_DELETE_DIR).arg(bmid).arg(browserid).arg(auth_encrypt_str).arg(key);
			}
			header=QHttpRequestHeader("POST", bm_handle_url);
		}
		break;
	case POST_HTTP_TYPE_TESTACCOUNT:
		header=QHttpRequestHeader("POST", BM_TEST_ACCOUNT_URL);
		break;				
	}
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
	header.setContentType("application/x-www-form-urlencoded");
	resultBuffer = new QBuffer();
	resultBuffer->moveToThread(this);
	resultBuffer->open(QIODevice::ReadWrite);
	posthttp->request(header, postString.toUtf8(), resultBuffer);

}

void bmPost::run()
{
	THREAD_MONITOR_POINT;
	gorun();
	exec();
	if(posthttp)
		disconnect(posthttp, 0, 0, 0);
	clearObject();
}

void bmPost::httpDone(bool error)
{
	THREAD_MONITOR_POINT;
	STOP_TIMER(postTimer);
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
					lastModified=resultXml->attributes().value("lastmodified").toString();
					newgroupid=resultXml->attributes().value("groupid").toString().toUInt();
					bmid=resultXml->attributes().value("bmid").toString().toUInt();
					break;
				}
			} 
		}
		//groupid maybe is zero,but bmid mustn't be zero
		if((!lastModified.isEmpty())&&bmid){
			//setMaxGroupId(newgroupid);
			SET_RUN_PARAMETER(RUN_PARAMETER_POST_MAX_GROUPID,newgroupid);
			setUpdatetime(lastModified);
			//setBmId(bmid);
			SET_RUN_PARAMETER(RUN_PARAMETER_POST_BMID,bmid);			
		}else
			error = QHttp::UnknownError;
		DELETE_OBJECT(resultXml);
		qDebug("%s resultBuffer=%s gMaxGroupId=%u lastModified=%s bmid=%u",__FUNCTION__,qPrintable( QString(resultBuffer->data())),GET_RUN_PARAMETER(RUN_PARAMETER_POST_MAX_GROUPID),qPrintable(lastModified),GET_RUN_PARAMETER(RUN_PARAMETER_POST_BMID));
	}
	//setPostError(error);
	SET_RUN_PARAMETER(RUN_PARAMETER_POST_ERROR,error);
	exit(error);
}

void bmPost::postTimeout()
{
	THREAD_MONITOR_POINT;
	STOP_TIMER(monitorTimer);
	STOP_TIMER(postTimer);
	posthttp->abort();
}
void bmPost::terminateThread()
{
	postTimeout();
	MyThread::terminateThread();
}


