#include <Bookmark_sync.h>
#include <QUrl>
#include <QWaitCondition>
#include <QDir>
#include <QStringList>
#include <bmapi.h>
#include <posthttp.h>
void BookmarkSync::setNetworkProxy()
{
	//check proxy
	if(settings->value("HttpProxy/proxyEnable", false).toBool())
	{
		qDebug()<<"http proxy enable!";
		httpProxyEnable=1;
		 netProxy=new QNetworkProxy();
		 netProxy->setType(QNetworkProxy::HttpProxy);
		 netProxy->setHostName(settings->value("HttpProxy/proxyAddress", "").toString());
		
		 netProxy->setPort(settings->value("HttpProxy/proxyPort", "").toUInt());
		 netProxy->setUser(settings->value("HttpProxy/proxyUsername", "").toString());
		 netProxy->setPassword(settings->value("HttpProxy/proxyPassword", "").toString());
		
	}
}

void BookmarkSync::on_http_stateChanged(int stat)
{

	switch (stat)
	  {
	  case QHttp::Unconnected:
		  qDebug("Unconnected");
		  emit updateStatusNotify(HTTP_UNCONNECTED);
		  break;
	  case QHttp::HostLookup:
		  qDebug("HostLookup");
		  emit updateStatusNotify(HTTP_HOSTLOOKUP);
		  break;
	  case QHttp::Connecting:
		  qDebug("Connecting");
		  emit updateStatusNotify(HTTP_CONNECTING);
		  break;
	  case QHttp::Sending:
		  qDebug("Sending");
		  emit updateStatusNotify(HTTP_SENDING);
		  break;
	  case QHttp::Reading:
		  qDebug("Reading");
		  emit updateStatusNotify(HTTP_READING);
		  break;
	  case QHttp::Connected:
		  qDebug("Connected");
		  emit updateStatusNotify(HTTP_CONNECTED);
		  break;
	  case QHttp::Closing:
		  qDebug("Closing");
		  emit updateStatusNotify(HTTP_CLOSING);
		  break;
	  }

}

void BookmarkSync::on_http_dataReadProgress(int done, int total)
{
	QDEBUG("Downloaded:%d bytes out of %d", done, total);
	emit readDateProgressNotify(done, total);
}

void BookmarkSync::on_http_dataSendProgress(int done, int total)
{
}
void BookmarkSync::on_http_requestFinished(int id, bool error)
{
}

void BookmarkSync::on_http_requestStarted(int id)
{
}
void BookmarkSync::on_http_responseHeaderReceived(const QHttpResponseHeader & resp)
{
}
BookmarkSync::BookmarkSync(QObject* parent,QSqlDatabase* db,QSettings* s,QString path,int m): QThread(parent),settings(s),iePath(path),mode(m)
{
	
	//httpTimerId=startTimer(10*1000);
//	updateTime=d;
	this->db=db;
	mgthread=NULL;
	netProxy=NULL;
	httpProxyEnable=0;
	//QDEBUG("%s updateTime=0x%08x",__FUNCTION__,updateTime);

}
void BookmarkSync::httpTimerSlot()
{
	QDEBUG("httpTimerSlot.......");
	emit updateStatusNotify(HTTP_TIMEOUT);	
	http_timerover=1;
	httpTimer->stop();
	
	if(!http_finish)
		http->abort();
}
void BookmarkSync::stopSync()
{
	//emit updateStatusNotify(HTTP_TIMEOUT);	
	QDEBUG_LINE;
		qDebug("%s currentThread id=0x%08x",__FUNCTION__,currentThread());
//	if(httpTimer->isActive())
//		httpTimer->stop();
	switch (http_finish)
	{
		case 0:			
			http->abort();
			break;
		case 1:
			if(mgthread&&mgthread->isRunning())
			{
				QDEBUG("shut down the mergethread!");
				mgthread->setTerminated(1);
			}
			break;			
			
	}
}

void BookmarkSync::run()
{
		qDebug("%s currentThread id=0x%08x",__FUNCTION__,currentThread());
		 qRegisterMetaType<QHttpResponseHeader>("QHttpResponseHeader");
		 http_finish=0;
		 http_timerover=0;
		 error=0;
		 setNetworkProxy();
		http = new QHttp();
		if(httpProxyEnable)
			http->setProxy(*netProxy);
#if 1
		httpTimer=new QTimer();
		//QDEBUG("http=%08x httpTimer=%08x",http,httpTimer);
		connect(httpTimer, SIGNAL(timeout()), this, SLOT(httpTimerSlot()), Qt::DirectConnection);
     		httpTimer->start(10*1000);
		httpTimer->moveToThread(this);
		httpTimer->setSingleShot(true);
#else
		httpTimerId=startTimer(10*1000);
#endif

		//connect(http, SIGNAL(stateChanged(int)), this, SLOT(on_http_stateChanged(int)));
		//connect(http, SIGNAL(dataReadProgress(int, int)), this, SLOT(on_http_dataReadProgress(int, int)));
		//connect(http, SIGNAL(dataSendProgress(int, int)), this, SLOT(on_http_dataSendProgress(int, int)));
		// connect(http, SIGNAL(done(bool)), this, SLOT(on_http_done(bool)));
		//connect(http, SIGNAL(requestFinished(int, bool)), this, SLOT(on_http_requestFinished(int, bool)));
		//connect(http, SIGNAL(requestStarted(int)), this, SLOT(on_http_requestStarted(int)));
		//connect(http, SIGNAL(responseHeaderReceived(const QHttpResponseHeader &)), this, SLOT(on_http_responseHeaderReceived(const QHttpResponseHeader &)));

	if(mode==BOOKMARK_SYNC_MODE)	
	{
		connect(http, SIGNAL(done(bool)), this, SLOT(bookmarkGetFinished(bool)));
		QDEBUG("BookmarkSync run...........");
		file = new QFile(BM_XML_FROM_SERVER);
		int ret1=file->open(QIODevice::ReadWrite | QIODevice::Truncate);
		http->setHost(host);
	//	QDEBUG("http=0x%08x url=%s ret1=%d",http,qPrintable(url),ret1);
		emit updateStatusNotify(BOOKMARK_SYNC_START);	
		http->get(url, file);
		int ret=exec();
		if(!http_timerover)
			emit bookmarkFinished(ret);

		QDEBUG("sync thread quit.............");
	 }else if(mode==BOOKMARK_TESTACCOUNT_MODE){

		http->setHost(BM_SERVER_ADDRESS);
		connect(http, SIGNAL(done(bool)), this, SLOT(testAccountFinished(bool)));
		//QHttpRequestHeader header=QHttpRequestHeader("POST", BM_TEST_ACCOUNT_URL);
		
		//header.setValue("Host", BM_SERVER_ADDRESS);
		//header.setContentType("application/x-www-form-urlencoded");
		// header.setValue("cookie", "jblog_authkey=MQkzMmJlNmM1OGRmODFkNGExMThiMmNhZjcyMGVjOTUwMA");           
		// postString.sprintf("name=%s&link=%s",qPrintable(bc.name),qPrintable(bc.link));
		//       logToFile("%s %d postString=%s",__FUNCTION__,__LINE__,qPrintable(postString));
		//resuleBuffer=new QBuffer(NUll); //this will bring out "create"
		resultBuffer = new QBuffer();
		resultBuffer->moveToThread(this);
		resultBuffer->open(QIODevice::ReadWrite);
		//QString postString = QString("name=%1&password=%2").arg(QString(QUrl::toPercentEncoding(username))).arg(QString(QUrl::toPercentEncoding(password)));
		//http->request(header, postString.toUtf8(), resultBuffer);
		http->get(url, resultBuffer);
		int ret=exec();	
		if(!http_timerover)
			emit testAccountFinishedNotify(ret,QString(resultBuffer->data()));

	//	QDEBUG("http=0x%08x ",http);
		resultBuffer->close();
		delete resultBuffer;
		resultBuffer=NULL;
		QDEBUG("testAccount thread quit.............\n");
	 	}

			if(httpTimer->isActive())
			{
				qDebug("kill http timer!");
				httpTimer->stop();		
			}
}

#ifdef CONFIG_HTTP_TIMEOUT
//void BookmarkSync::timerEvent(QTimerEvent * event)
//{
//	QDEBUG("timerevent id=%d httpTimerId=%d", event->timerId(), httpTimerId);
//	emit updateStatusNotify(HTTP_TIMEOUT);
//}
#endif
/*
void BookmarkSync::quit()
{
	if (loop.isRunning())
		loop.exit(0);
}
*/
void BookmarkSync::testAccountFinished(bool error)
{
	http_finish=1;
	this->error=error;
	QDEBUG_LINE;
	//httpTimer->stop();
	exit(error);
}
void BookmarkSync::mgUpdateStatus(int status,QString str)
{
	//QDEBUG("%s status=%d %s",__FUNCTION__,status,qPrintable(str));
	qDebug()<<__FUNCTION__<<str;
}

void BookmarkSync::bookmarkGetFinished(bool error)
{
	http_finish=1;
	this->error=error;
#ifdef CONFIG_HTTP_TIMEOUT

#else
	//if (httpTimerId)
	//	http->killTimer(httpTimerId);
	//httpTimerId = 0;
#endif
	QDEBUG("emit bookmarkFinished error %d to networkpage", error);
     if(!error)	
	{
		//QDEBUG("%s updateTime=0x%08x",__FUNCTION__,updateTime);
		mgthread = new mergeThread(this,db,settings,iePath);
		emit updateStatusNotify(UPDATE_PROCESSING);
		connect(mgthread, SIGNAL(finished()), this, SLOT(mergeDone()));
		connect(mgthread, SIGNAL(mgUpdateStatusNotify(int,QString)), this, SLOT(mgUpdateStatus(int,QString)));
		mgthread->start();
		QDEBUG("start merge thread...........");
	}
else
	{
		if(http->error()!=QHttp::ProxyAuthenticationRequiredError)			
			{
				QDEBUG("http error %s",qPrintable(http->errorString()));
				emit updateStatusNotify(UPDATE_NET_ERROR);
			}
		else
			QDEBUG("http error %s",qPrintable(http->errorString()));
		mergeDone();
	}
if (!IS_NULL(file))
  {
	  file->close();
	  delete file;
	  file = NULL;
  }
//  this->quit();
}

void BookmarkSync::mergeDone()
{
	QDEBUG("quit merge thread...........");
	if(!error){
		emit updateStatusNotify(SYNC_SUCCESSFUL);
	}
	if(mgthread){
		mgthread->deleteLater();
		mgthread=NULL;
	}
	if(netProxy){
		delete netProxy;
		netProxy=NULL;
	}
	exit();
}


