#include <bmnet.h>
#include <bmapi.h>

NetThread::NetThread(QObject * parent,QSettings* s,int m):QThread(parent),settings(s),doWhat(m)
{
	resultBuffer = NULL;
	http =NULL;
	monitorTimer=NULL;
	header = NULL;
	file = NULL;
	
	http_state = 0;
	http_timeout = 0;
	http_send_len = 0;
	http_rcv_len = 0;
	terminateFlag=0;
	dlgmode = UPDATE_DLG_MODE;
	statusCode =0;
	httpRspCode = 0;
}
NetThread::~NetThread(){
}

void NetThread::setTerminateFlag(int f)
{
	terminateFlag=f;
}
void NetThread::monitorTimeout(){
	if(http){
		http_timeout++;
		if(tz::getParameterMib(http_state)&&((http_timeout*tz::getParameterMib(SYS_MONITORTIMEOUT)/1000)>tz::getParameterMib(http_state))){
			http->abort();
		}
	}
/*
	if(terminateFlag)
		terminateThread();
	else
	{
		monitorTimer->start((tz::getParameterMib(SYS_MONITORTIMEOUT)));
	}
*/
	monitorTimer->start((tz::getParameterMib(SYS_MONITORTIMEOUT)));
}
void NetThread::run(){
	qRegisterMetaType<QHttpResponseHeader>("QHttpResponseHeader");
	START_TIMER_INSIDE(monitorTimer,false,(tz::getParameterMib(SYS_MONITORTIMEOUT)),monitorTimeout);
}
void NetThread::terminateThread(){
	STOP_TIMER(monitorTimer);
}
void NetThread::newHttp(bool needHeader,bool needBuffer,bool needFile,bool hidden){
	http = new QHttp();
	http->moveToThread(this);
	http->setHost(BM_SERVER_ADDRESS);	
	SET_NET_PROXY(http,settings);
	/*
	I found the problem:
	From the Qt docs, a Qt::QueuedConnection will cause the slot to execute when control returns to the event loop 
	of the thread where the receiver object lives. The receiver object in my case is the QThread object which is 
	created, and thus lives, in the main GUI thread. The QTimer is created in the thread spawned off of the 
	QThread object. So in this case I needed a Qt:: DirectConnection.
	*/
	connect(http, SIGNAL(stateChanged(int)), this, SLOT(httpstateChanged(int)),Qt::DirectConnection);
	connect(http, SIGNAL(dataSendProgress(int,int)), this, SLOT(httpdataSendProgress(int,int)),Qt::DirectConnection);
	connect(http, SIGNAL(dataReadProgress(int,int)), this, SLOT(httpdataReadProgress(int,int)),Qt::DirectConnection);	
	connect(http, SIGNAL(responseHeaderReceived(const QHttpResponseHeader &)), this, SLOT(httpResponseHeaderReceived(const QHttpResponseHeader &)),Qt::DirectConnection);
	if(needHeader){
		header=new QHttpRequestHeader("POST", url);
		header->setContentType("application/x-www-form-urlencoded");
		header->setValue("Host", BM_SERVER_ADDRESS);
	}
	if(needBuffer){
		resultBuffer = new QBuffer();
		resultBuffer->moveToThread(this);
		resultBuffer->open(QIODevice::ReadWrite);
	}
	if(needFile){
		file = new QFile(filename);
		if(file->open(QIODevice::ReadWrite | QIODevice::Truncate)){
			if(hidden)
				SetFileAttributes(filename.utf16(),FILE_ATTRIBUTE_HIDDEN);
		}
	}
	SET_HOST_IP(settings,http,&url,header);
}

void NetThread::setUrl(const QString &s){
	url = s;
}

void NetThread::setFilename(const QString &s){
	filename.clear();
	filename = s;
}
void NetThread::cleanObjects(){
	THREAD_MONITOR_POINT;
	DELETE_TIMER(monitorTimer);
	DELETE_OBJECT(http);	
	DELETE_OBJECT(header);	
	DELETE_BUFFER(resultBuffer);
	DELETE_FILE(file);
}







DoNetThread::DoNetThread(QObject * parent ,QSettings* s,int m,int d):NetThread(parent,s,m),id(d)
{
}


void DoNetThread::monitorTimeout(){
	STOP_TIMER(monitorTimer);
	NetThread::monitorTimeout();
}
void DoNetThread::doPostItemDone(bool error){
	THREAD_MONITOR_POINT;
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
		DELETE_OBJECT(resultXml);
		//qDebug("%s resultBuffer=%s gMaxGroupId=%u lastModified=%s bmid=%u",__FUNCTION__,qPrintable( QString(resultBuffer->data())),GET_RUN_PARAMETER(RUN_PARAMETER_POST_MAX_GROUPID),qPrintable(lastModified),GET_RUN_PARAMETER(RUN_PARAMETER_POST_BMID));
	}
	SET_RUN_PARAMETER(RUN_PARAMETER_POST_ERROR,error);
	exit(error);
}

void DoNetThread::doHttpFinished(bool error){
	 TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<doWhat);
	if(!error)
	{		
		switch(doWhat){
			case DOWHAT_TEST_SERVER_NET:	
				{
					QString replybuf(resultBuffer->data().trimmed());
					if(replybuf.startsWith(QString("1")))
						statusCode = TEST_NET_SUCCESS;
					else
						statusCode = TEST_NET_REFUSE;
				}
			break;
#ifdef CONFIG_DIGG_XML
			case DOWHAT_TEST_SERVER_DIGG_XML:
				{
					QString replybuf(resultBuffer->data().trimmed());
					if(replybuf.startsWith(QString("1"))){
						statusCode = TEST_DIGGXML_SUCCESS;
					}else if(replybuf.startsWith(QString("0"))){
						statusCode = TEST_DIGGXML_UNNEED;
					}
				}
			break;
#endif
			case DOWHAT_TEST_SERVER_VERSION:
				{
					QString replybuf(resultBuffer->data().trimmed());
					qDebug()<<replybuf;
					QRegExp verre("^[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}$");
					statusCode = TEST_VERSION_UNNEED;
					if(verre.exactMatch(replybuf)){
						QDEBUG_LINE;							
						QStringList s_version = replybuf.split(".");
						QStringList l_version = QString(APP_VERSION).split(".");
						 for (int i = 0; i < s_version.size(); ++i)
       							{ 
       								if(s_version.at(i).toUInt()>l_version.at(i).toUInt())
       								{
									statusCode = TEST_VERSION_SUCCESS;
									break;
       								}       								
						 	}						
					}
				}
			break;
			case DOWHAT_GET_DIGGXML_FILE:
			case DOWHAT_GET_BMXML_FILE:
				 TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<filename<<md5key);
				//if(md5key.isEmpty()||(md5key==tz::fileMd5(filename)))
				if(1){
						statusCode = DOWHAT_GET_FILE_SUCCESS;
				}else{
						statusCode = DOWHAT_GET_FILE_FAIL;
						exit(-1);
						return;
				}
				break;
			case DOWHAT_TEST_ACCOUNT:
				{
					if(QString(resultBuffer->data())==DOSUCCESSS){
						statusCode = HTTP_TEST_ACCOUNT_SUCCESS;
					}else{	
						statusCode = HTTP_TEST_ACCOUNT_FAIL;
						exit(-1);
						return;
					}
				}
				break;
			case DOWHAT_POST_ITEM:
				break;

		}
		 TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<statusCode);
		exit(0);
		return;
	}
	

	switch(http->error()){
		case QHttp::ProxyAuthenticationRequiredError:
			statusCode = TEST_NET_ERROR_PROXY_AUTH;
			break;
		default:
			statusCode = TEST_NET_ERROR_SERVER;
			break;
	}
	 TD(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__<<statusCode);
	exit(0);
	return;
}
void DoNetThread::terminateThread()
{
	THREAD_MONITOR_POINT;
	NetThread::terminateThread();
}
void DoNetThread::run()
{
	THREAD_MONITOR_POINT;	
	NetThread::run();
	switch(doWhat){
		case DOWHAT_TEST_ACCOUNT:
		case DOWHAT_TEST_SERVER_NET:
			NetThread::newHttp(FALSE,TRUE,FALSE,FALSE);
			connect(http, SIGNAL(done(bool)), this, SLOT(doHttpFinished(bool)),Qt::DirectConnection);
			http->get(url, resultBuffer);
			break;
		case DOWHAT_TEST_SERVER_VERSION:
			setUrl(TOUCHANY_VERSION_URL);
			NetThread::newHttp(FALSE,TRUE,FALSE,FALSE);
			connect(http, SIGNAL(done(bool)), this, SLOT(doHttpFinished(bool)),Qt::DirectConnection);
			http->get(url, resultBuffer);
			break;
#ifdef CONFIG_DIGG_XML
		case DOWHAT_TEST_SERVER_DIGG_XML:
			NetThread::newHttp(FALSE,TRUE,FALSE,FALSE);
			connect(http, SIGNAL(done(bool)), this, SLOT(doHttpFinished(bool)),Qt::DirectConnection);
			http->get(url, resultBuffer);
			break;
#endif
		case DOWHAT_GET_DIGGXML_FILE:
		case DOWHAT_GET_BMXML_FILE:
			NetThread::newHttp(FALSE,FALSE,TRUE,TRUE);
			connect(http, SIGNAL(done(bool)), this, SLOT(doHttpFinished(bool)),Qt::DirectConnection);
			sendUpdateStatusNotify(BM_SYNC_START);
			http->get(url, file);
			break;
		case DOWHAT_POST_ITEM:
			{
				qsrand((unsigned) NOW_SECONDS);
				uint key=qrand()%(getkeylength());
				QString auth_encrypt_str=tz::encrypt(QString("username=%1 password=%2").arg(username).arg(password),key);	
				switch(action){
					case POST_HTTP_ACTION_ADD_ITEM:
					case POST_HTTP_ACTION_ADD_DIR:
						url=QString(BM_SERVER_ADD_URL).arg(parentid).arg(browserid).arg(auth_encrypt_str).arg(key);
					break;
					case POST_HTTP_ACTION_DELETE_ITEM:
						url=QString(BM_SERVER_DELETE_URL).arg(bmid).arg(browserid).arg(auth_encrypt_str).arg(key);
					break;
					case POST_HTTP_ACTION_DELETE_DIR:
						url=QString(BM_SERVER_DELETE_DIR).arg(bmid).arg(browserid).arg(auth_encrypt_str).arg(key);
					break;
				}
				NetThread::newHttp(TRUE,TRUE,FALSE,FALSE);
				connect(http, SIGNAL(done(bool)), this, SLOT(doPostItemDone(bool)), Qt::DirectConnection);
				http->request(*header, postString.toUtf8(), resultBuffer);
			}
			break;
		default:
			break;
	}
	TD(DEBUG_LEVEL_NORMAL,url);
	exec();
	emit doNetStatusNotify(statusCode);
	cleanObjects();
}
void DoNetThread::cleanObjects(){
	NetThread::cleanObjects();
}

