#include <posthttp.h>
#include <bookmark_sync.h>
#include <bmapi.h>

//extern uint gMaxGroupId;

postHttp::postHttp(QObject * parent,QSettings* s,int type ):MyThread(parent,s)
{
	postType=type;
	postTimer = NULL;
	resultBuffer = NULL;
	posthttp = NULL;
	
	//monitorTimer = 0;
	//terminateFlag = 0;
	//proxyEnable = 0;
	//QDEBUG("construction postHttp......");
}
postHttp::~postHttp(){
	THREAD_MONITOR_POINT;
}
void postHttp::clearObject()
{
	THREAD_MONITOR_POINT;
	DELETE_FILE(resultBuffer);
	DELETE_TIMER(monitorTimer);
	DELETE_TIMER(postTimer);
	DELETE_OBJECT(posthttp);
}
void postHttp::gorun()
{
	THREAD_MONITOR_POINT;
	//DELETE_TIMER(postTimer);
	/*
	monitorTimer = new QTimer();
	connect(monitorTimer, SIGNAL(timeout()), this, SLOT(monitorTimerSlot()), Qt::DirectConnection);
	monitorTimer->start(10);
	*/
	START_TIMER_INSIDE(monitorTimer,false,10,monitorTimeout);
	/*
	postTimer=new QTimer();
	connect(postTimer, SIGNAL(timeout()), this, SLOT(postTimerSlot()), Qt::DirectConnection);
	postTimer->start(POST_ITEM_TIMEOUT*SECONDS);
	postTimer->moveToThread(this);	
	*/
	
	START_TIMER_INSIDE(postTimer,false,POST_ITEM_TIMEOUT*SECONDS,postTimerSlot);
	
	
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
	posthttp->setHost(BM_SERVER_ADDRESS);
	QHttpRequestHeader header;
	switch(postType)
	{
	case POST_HTTP_TYPE_HANDLE_ITEM:
		{
			QString bm_handle_url;
			qsrand((unsigned) NOW_SECONDS);
			uint key=qrand()%(getkeylength());
			QString auth_encrypt_str=tz::encrypt(QString("username=%1 password=%2").arg(username).arg(password),key);;
			
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
	header.setValue("Host", BM_SERVER_ADDRESS);
	header.setContentType("application/x-www-form-urlencoded");
	// header.setValue("cookie", "jblog_authkey=MQkzMmJlNmM1OGRmODFkNGExMThiMmNhZjcyMGVjOTUwMA");           

	resultBuffer = new QBuffer();
	resultBuffer->moveToThread(this);
	resultBuffer->open(QIODevice::ReadWrite);
	posthttp->request(header, postString.toUtf8(), resultBuffer);

}

void postHttp::run()
{
	THREAD_MONITOR_POINT;
	gorun();
//	START_TIMER_ASYN(postTimer,true,10,gorun);
	exec();
	if(posthttp)
		disconnect(posthttp, 0, 0, 0);
	clearObject();
}

void postHttp::httpDone(bool error)
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
		setMaxGroupId(newgroupid);
		setUpdatetime(lastModified);
		setBmId(bmid);
		DELETE_OBJECT(resultXml);
		qDebug("%s resultBuffer=%s gMaxGroupId=%u lastModified=%s bmid=%u",__FUNCTION__,qPrintable( QString(resultBuffer->data())),getMaxGroupId(),qPrintable(lastModified),getBmId());
	}
	setPostError(error);
	exit(error);
}

void postHttp::postTimerSlot()
{
	THREAD_MONITOR_POINT;
	qDebug("postTimerSlot.......");
	STOP_TIMER(monitorTimer);
	STOP_TIMER(postTimer);
	posthttp->abort();
}
void postHttp::terminateThread()
{
	postTimerSlot();
	MyThread::terminateThread();
}


