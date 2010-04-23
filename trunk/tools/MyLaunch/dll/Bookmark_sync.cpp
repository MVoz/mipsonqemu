#include <Bookmark_sync.h>
#include <QUrl>
#include <QWaitCondition>
#include <QDir>
#include <QStringList>
#include <bmapi.h>
#include <posthttp.h>
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

void BookmarkSync::run()
{
		 qRegisterMetaType<QHttpResponseHeader>("QHttpResponseHeader");
		 http_finish=0;
		 http_timerover=0;
		 error=0;
		http = new QHttp();
#if 1
		httpTimer=new QTimer();
		//QDEBUG("http=%08x httpTimer=%08x",http,httpTimer);
		connect(httpTimer, SIGNAL(timeout()), this, SLOT(httpTimerSlot()), Qt::DirectConnection);
     		httpTimer->start(10*1000);
		httpTimer->moveToThread(this);
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
		//if(!updateTime->isNull())
		//{
		//	QSettings s("HKEY_CURRENT_USER\\Software\\Yiye\\",	QSettings::NativeFormat);
		//	s.setValue("lastUpdateTime", updateTime->toString(TIME_FORMAT));
		//	s.sync();
		//}
		if(!http_timerover)
			emit bookmarkFinished(ret);
	//	QDEBUG("close httptimer");
		//if(!http_timerover)
		if(httpTimer->isActive())
			httpTimer->stop();		
		QDEBUG("sync thread quit.............");
	 }else if(mode==BOOKMARK_TESTACCOUNT_MODE){

		http->setHost(BM_SERVER_ADDRESS);
		connect(http, SIGNAL(done(bool)), this, SLOT(testAccountFinished(bool)));
		QHttpRequestHeader header=QHttpRequestHeader("POST", BM_TEST_ACCOUNT_URL);
		
		header.setValue("Host", BM_SERVER_ADDRESS);
		header.setContentType("application/x-www-form-urlencoded");
		// header.setValue("cookie", "jblog_authkey=MQkzMmJlNmM1OGRmODFkNGExMThiMmNhZjcyMGVjOTUwMA");           
		// postString.sprintf("name=%s&link=%s",qPrintable(bc.name),qPrintable(bc.link));
		//       logToFile("%s %d postString=%s",__FUNCTION__,__LINE__,qPrintable(postString));
		//resuleBuffer=new QBuffer(NUll); //this will bring out "create"
		resultBuffer = new QBuffer();
		resultBuffer->moveToThread(this);
		resultBuffer->open(QIODevice::ReadWrite);
		QString postString = QString("name=%1&password=%2").arg(QString(QUrl::toPercentEncoding(username))).arg(QString(QUrl::toPercentEncoding(password)));
		http->request(header, postString.toUtf8(), resultBuffer);
		int ret=exec();	

		emit testAccountFinishedNotify(ret,QString(resultBuffer->data()));

	//	QDEBUG("http=0x%08x ",http);
		resultBuffer->close();
		delete resultBuffer;
		resultBuffer=NULL;
		QDEBUG("testAccount thread quit.............\n");
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
	QDEBUG_LINE;
	httpTimer->stop();
	exit(error);
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
		mergeThread *mgthread = new mergeThread(this,db,settings,iePath);
		emit updateStatusNotify(UPDATE_PROCESSING);
		connect(mgthread, SIGNAL(finished()), this, SLOT(mergeDone()));
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
	exit();
}


