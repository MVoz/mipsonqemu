#include <posthttp.h>
#include <bookmark_sync>
#include <bmapi.h>
#include <stdio.h>
#include <QXmlStreamReader>
//extern uint gMaxGroupId;

postHttp::postHttp(QObject * parent,int type ):MyThread(parent)
{
	postType=type;
	postTimer = NULL;
	resultBuffer = NULL;
	//monitorTimer = 0;
	//terminateFlag = 0;
	//proxyEnable = 0;
	//QDEBUG("construction postHttp......");
}
postHttp::~postHttp(){
	//QDEBUG("delete ~postHttp......");
	/*
	resultBuffer->close();
	delete resultBuffer;
	resultBuffer=NULL;
	*/
	DELETE_FILE(resultBuffer);
	DELETE_TIMER(monitorTimer);
	DELETE_TIMER(postTimer)
	/*
	if(monitorTimer)
		delete monitorTimer;
	if(postTimer)
		delete postTimer;
	*/
}
/*
void postHttp::setProxy(QNetworkProxy& p)
{
	proxyEnable = 1;
	proxy = p;
}
*/
void postHttp::run()
{
	MyThread::run();
#if 0
	monitorTimer = new QTimer();
	connect(monitorTimer, SIGNAL(timeout()), this, SLOT(monitorTimerSlot()), Qt::DirectConnection);
	monitorTimer->start(10);
	monitorTimer->moveToThread(this);
#endif		
	postTimer=new QTimer();
	connect(postTimer, SIGNAL(timeout()), this, SLOT(postTimerSlot()), Qt::DirectConnection);
     	postTimer->start(10*1000);
	postTimer->moveToThread(this);	
	posthttp = new QHttp();

	SET_NET_PROXY(posthttp);
	
	//QDEBUG("this thread is 0x%p\n",this);
	posthttp->moveToThread(this);
	//quitFlag=1;
	/*

	   I found the problem:

	   From the Qt docs, a Qt::QueuedConnection will cause the slot to execute when control returns to the event loop 
	   of the thread where the receiver object lives. The receiver object in my case is the QThread object which is 
	   created, and thus lives, in the main GUI thread. The QTimer is created in the thread spawned off of the 
	   QThread object. So in this case I needed a Qt:: DirectConnection.
	 */
	connect(posthttp, SIGNAL(done(bool)), this, SLOT(httpDone(bool)), Qt::DirectConnection);
	//connect(posthttp, SIGNAL(stateChanged(int)), this, SLOT(httpStateChanged(int)), Qt::DirectConnection);
	//connect(posthttp, SIGNAL(requestFinished(int, bool)), this, SLOT(httpRequestFinished(int, bool)));    
	posthttp->setHost(BM_SERVER_ADDRESS);
	QHttpRequestHeader header;
	switch(postType)
		{
			case POST_HTTP_TYPE_HANDLE_ITEM:
				{
					QString bm_handle_url;
#ifdef CONFIG_AUTH_ENCRYPTION
					qsrand((unsigned) NOW_SECONDS);
					uint key=qrand()%(getkeylength());
					QString auth_encrypt_str=tz::encrypt(QString("username=%1 password=%2").arg(username).arg(password),key);;
					//encryptstring(authstr,key,auth_encrypt_str);
#endif

					if(action==POST_HTTP_ACTION_ADD_URL||action==POST_HTTP_ACTION_ADD_DIR)
						{
#ifdef CONFIG_AUTH_ENCRYPTION
							bm_handle_url=QString(BM_SERVER_ADD_URL).arg(parentid).arg(browserid).arg(auth_encrypt_str).arg(key);
#else
							bm_handle_url=QString(BM_SERVER_ADD_URL).arg(parentid).arg(browserid).arg(username).arg(password);
#endif
						}
					else if(action==POST_HTTP_ACTION_DELETE_URL)
						{
#ifdef CONFIG_AUTH_ENCRYPTION
							bm_handle_url=QString(BM_SERVER_DELETE_URL).arg(bmid).arg(browserid).arg(auth_encrypt_str).arg(key);
#else
							bm_handle_url=QString(BM_SERVER_DELETE_URL).arg(bmid).arg(browserid).arg(username).arg(password);
#endif

						}
					else if(action==POST_HTTP_ACTION_DELETE_DIR)
						{
#ifdef CONFIG_AUTH_ENCRYPTION
							bm_handle_url=QString(BM_SERVER_DELETE_DIR).arg(bmid).arg(browserid).arg(auth_encrypt_str).arg(key);
#else
							bm_handle_url=QString(BM_SERVER_DELETE_DIR).arg(bmid).arg(browserid).arg(username).arg(password);
#endif
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
	exec();
	disconnect(posthttp, 0, 0, 0);
}

void postHttp::httpDone(bool error)
{
	if(postTimer->isActive())
		postTimer->stop();
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
					      }
				  } 
			  }
			setMaxGroupId(newgroupid);
			setUpdatetime(lastModified);
			setBmId(bmid);
			delete resultXml;
#if 0			
			if(QString(resultBuffer->data()).contains(SUCCESSSTRING, Qt::CaseInsensitive))
			{
				if(QString(resultBuffer->data()).contains("groupid=", Qt::CaseInsensitive))
					{
						uint newgroupid=0;
						uint lastModified=0;
						uint bmid=0;
						//QDEBUG("%s %d resultBuffer=%s gMaxGroupId=%u",__FUNCTION__,__LINE__,qPrintable( QString(resultBuffer->data())),(uint)gMaxGroupId);
						//sscanf(QString(resultBuffer->data()).toUtf8(),SUCCESSSTRING" lastmodified=%u groupid=%u bmid=%u",&lastModified,&newgroupid,&bmid);
						QXmlStreamReader resultXml=QXmlStreamReader(resultBuffer->data())
						setMaxGroupId(newgroupid);
						setUpdatetime(lastModified);
						setBmId(bmid);
						
					}
			}
#endif
			qDebug("%s resultBuffer=%s gMaxGroupId=%u lastModified=%s bmid=%u",__FUNCTION__,qPrintable( QString(resultBuffer->data())),getMaxGroupId(),qPrintable(lastModified),getBmId());
		}
	setPostError(error);
	exit(error);
}

//void postHttp::httpRequestFinished(int id, bool error)
//{
	//QDEBUG("%s %d %s", __FUNCTION__, posthttp->error(), qPrintable(posthttp->errorString()));
#ifdef CONFIG_LOG_ENABLE
	//quit();
#endif
//}
//void postHttp::httpStateChanged(int state)
//{
	//QDEBUG("now posthttp state is %d\n ",state);
//}
void postHttp::postTimerSlot()
{
	qDebug("postTimerSlot.......");
	/*
	if(monitorTimer&&monitorTimer->isActive())
		monitorTimer->stop();
	if(postTimer->isActive())
		postTimer->stop();
	*/
	STOP_TIMER(monitorTimer);
	STOP_TIMER(postTimer);
	posthttp->abort();
}
void postHttp::terminateThread()
{
	postTimerSlot();
	MyThread::terminateThread();
}


