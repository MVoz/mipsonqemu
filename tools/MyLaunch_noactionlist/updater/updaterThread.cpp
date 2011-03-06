#include <updaterThread.h>
#include <QUrl>
#include <QWaitCondition>
#include <QSemaphore>
#include <QDir>
#include <QStringList>
#include <bmapi.h>
void SetColor(unsigned short ForeColor=FOREGROUND_INTENSITY,unsigned short BackGroundColor=0) 
{ 
	    HANDLE hCon = GetStdHandle(STD_OUTPUT_HANDLE);/*STD_OUTPUT_HANDLE,STD_ERROR_HANDLE*/
	    SetConsoleTextAttribute(hCon,ForeColor|BackGroundColor); 
} 

void GetFileHttp::on_http_stateChanged(int stat)
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

void GetFileHttp::on_http_dataReadProgress(int done, int total)
{
	qDebug("Downloaded:get file %s %d bytes out of %d", qPrintable(updaterFilename),done, total);
//	emit readDateProgressNotify(done, total);
}

void GetFileHttp::on_http_dataSendProgress(int done, int total)
{
}
void GetFileHttp::on_http_requestFinished(int id, bool error)
{
}

void GetFileHttp::on_http_requestStarted(int id)
{
}
void GetFileHttp::on_http_responseHeaderReceived(const QHttpResponseHeader & resp)
{
	qDebug("%s %d statuscode=%d.......",__FUNCTION__,__LINE__,resp.statusCode());
	statusCode=resp.statusCode();
}

void GetFileHttp::run()
{
		qRegisterMetaType<QHttpResponseHeader>("QHttpResponseHeader");
		http = new QHttp();
		httpTimer=new QTimer();
		connect(httpTimer, SIGNAL(timeout()), this, SLOT(httpTimerSlot()), Qt::DirectConnection);
     		httpTimer->start(10*1000);
		connect(http, SIGNAL(stateChanged(int)), this, SLOT(on_http_stateChanged(int)),Qt::DirectConnection);
		//connect(http, SIGNAL(stateChanged(int)), this, SLOT(on_http_stateChanged(int)));
		//connect(http, SIGNAL(readyRead (QHttpResponseHeader )),this,SLOT(on_http_responseHeaderReceived(QHttpResponseHeader)));
		connect(http, SIGNAL(dataReadProgress(int, int)), this, SLOT(on_http_dataReadProgress(int, int)),Qt::DirectConnection);
		connect(http, SIGNAL(dataSendProgress(int, int)), this, SLOT(on_http_dataSendProgress(int, int)),Qt::DirectConnection);
		// connect(http, SIGNAL(done(bool)), this, SLOT(on_http_done(bool)));
		connect(http, SIGNAL(requestFinished(int, bool)), this, SLOT(on_http_requestFinished(int, bool)),Qt::DirectConnection);
		connect(http, SIGNAL(requestStarted(int)), this, SLOT(on_http_requestStarted(int)),Qt::DirectConnection);
		connect(http, SIGNAL(responseHeaderReceived(const QHttpResponseHeader &)), this, SLOT(on_http_responseHeaderReceived(const QHttpResponseHeader &)),Qt::DirectConnection);
		connect(http, SIGNAL(done(bool)), this, SLOT(getFileDone(bool)),Qt::DirectConnection);
		QDir dir(".");
		if(!dir.exists("temp"))
			dir.mkdir("temp");
		QStringList na = updaterFilename.split("/");
		QString  dirPath=QString("temp\\");
		int i=0;
		int count=na.count();
		for(i=0;i<count-1&&count>1;i++)
		{
			dirPath.append(na.at(i));
			if(!dir.exists(dirPath))
				dir.mkdir(dirPath);		
			 dirPath.append("\\");
		}
		file = new QFile(dirPath.append(na.at(count-1)));
		this->mode=mode;
		int ret1=file->open(QIODevice::ReadWrite | QIODevice::Truncate);
		http->setHost(host);
		QString url("/download/");
		url.append(updaterFilename);
		qDebug("url=%s filename=%s\n",qPrintable(url),qPrintable(dirPath));
		http->get(url, file);
		retryTime++;
		exec();	
		httpTimer->stop();
}
void GetFileHttp::httpTimerSlot()
{
	qDebug("httpTimerSlot.......");
	emit updateStatusNotify(HTTP_TIMEOUT);
	httpTimer->stop();
	http->abort();
}
GetFileHttp::GetFileHttp(QObject* parent,int mode,QString name): QThread(parent),mode(mode)
{
	errCode=0;
	statusCode=0;
	mode=0;
	downloadFilename=name;
}

void GetFileHttp::getFileDone(bool error)
{
	if (!IS_NULL(file))
	  {
		  file->close();
		  delete file;
		  file = NULL;
	  }
	switch(mode){
		case UPDATE_MODE_GET_INI:
			if(!error)
			{
				switch(statusCode)
				{
				case HTTP_OK:
					emit updateStatusNotify(HTTP_GET_INI_SUCCESSFUL);
					emit getIniDoneNotify(HTTP_GET_INI_SUCCESSFUL);
					break;
				default:
					emit updateStatusNotify(HTTP_GET_INI_NOT_EXISTED);
					errCode=HTTP_GET_INI_NOT_EXISTED;
					break;
				}
			}else{
				if(retryTime<UPDATE_MAX_RETRY_TIME)
				{
						httpTimer->start(10*1000);
						http->get(url, file);
						retryTime++;
						errCode=HTTP_NEED_RETRY;
				}
				else
					{
						emit updateStatusNotify(HTTP_GET_INI_FAILED);
						errCode=HTTP_GET_INI_FAILED;						
					}
			}
			break;
		case UPDATE_MODE_GET_FILE:
			if(!error){
					switch(statusCode)
					{
					case HTTP_OK:
						emit updateStatusNotify(HTTP_GET_FILE_SUCCESSFUL);
					         emit getFileDoneNotify(HTTP_GET_FILE_SUCCESSFUL);						
						break;
					default:
						emit updateStatusNotify(HTTP_GET_FILE_NOT_EXISTED);
						errCode=HTTP_GET_FILE_NOT_EXISTED;						
						break;
					}
				}else{
					if(retryTime<UPDATE_MAX_RETRY_TIME)
					{
						httpTimer->start(10*1000);
						http->get(url, file);						
						retryTime++;
						errCode=HTTP_NEED_RETRY;
					}
					else
						{
							emit updateStatusNotify(HTTP_GET_FILE_FAILED);
							errCode=HTTP_GET_FILE_FAILED;							
						}
				}
			break;
		default:
			break;
		}
	 if(errCode)
	 	{
	 		emit updateStatusNotify(UPDATE_FAILED);
			switch(errCode){
					case HTTP_NEED_RETRY:
						qDebug("%d times to get %s from server!",retryTime,qPrintable(updaterFilename));
						break;
					case HTTP_GET_INI_NOT_EXISTED:
						 emit getIniDoneNotify(HTTP_GET_INI_NOT_EXISTED);
						qDebug("The file %s doesn't exist in server!",qPrintable(updaterFilename));
						this->quit();
						break;
					case HTTP_GET_FILE_NOT_EXISTED:
						emit getFileDoneNotify(HTTP_GET_FILE_NOT_EXISTED);
						qDebug("The file %s doesn't exist in server!",qPrintable(updaterFilename));
						this->quit();
						break;
					case HTTP_GET_INI_FAILED:
						emit getIniDoneNotify(HTTP_GET_INI_FAILED);
						qDebug("get file %s from server failed at %d times!\n",qPrintable(updaterFilename),retryTime);
						this->quit();
						break;
					case HTTP_GET_FILE_FAILED:
						emit getFileDoneNotify(HTTP_GET_FILE_FAILED);
						qDebug("get file %s from server failed at %d times!\n",qPrintable(updaterFilename),retryTime);
						this->quit();
						break;
				}
	 	}
	 else
	 	{
	 		emit updateStatusNotify(UPDATE_SUCCESSFUL);
			qDebug("get file %s from server successfully!",qPrintable(updaterFilename));
 	 		this->quit();
	 	}
	 
}




updaterThread::updaterThread(QObject* parent): QThread(parent)
{
	timers=0;
}
updaterThread::~updaterThread()
{
	qDebug("~~updaterThread");

}
void updaterThread::clearObject()
{
	sem_downfile_success.release(sem_downfile_success.available());
	sem_downfile_start.release(sem_downfile_start.available());
	DELETE_OBJECT(localSettings);
	DELETE_OBJECT(serverSettings);
	//DELETE_TIMER(updateTime);
	DELETE_OBJECT(testThread);
	//DELETE_TIMER(monitorTimer);
	DELETE_OBJECT(fh);
}


void updaterThread::run()
{

		downloadFileFromServer(UPDATE_SERVER_URL,UPDATE_MODE_GET_INI);
		int ret=exec();
		clearObject();
		qDebug("sync thread quit.............");

}
/*
	0---same
	1---newer
	-1---older
*/
int updaterThread::checkToSetiing(QSettings *settings,const QString &filename1,const QString& version1)
{
	int ret=-2;
	int count = settings->beginReadArray("files");
		  for (int i = 0; i < count; i++)
		    {
			    settings->setArrayIndex(i);
			         QString filename2=settings->value("name").toString();
				QString version2=settings->value("version").toString();	
				if(filename1!=filename2) continue;
				qDebug("filename1=%s version1=%s version2=%s",qPrintable(filename1),qPrintable(version1),qPrintable(version2));
				QStringList version1_list = version1.split(".");
				QStringList version2_list = version2.split(".");
				//qDebug("VERSION_INFO(version1)=%d VERSION_INFO(version2)=%d\n",VERSION_INFO(version1_list),VERSION_INFO(version2_list));
				if(VERSION_INFO(version1_list)==VERSION_INFO(version2_list))
					ret=0;
				if(VERSION_INFO(version1_list)>VERSION_INFO(version2_list))
					ret=1;
			       if(VERSION_INFO(version1_list)<VERSION_INFO(version2_list))
					ret= -1;
				break;
		    }
		  settings->endArray();
		  return ret;
}

/*
	mode:
		0--local to server ,1--server to local
*/
void updaterThread::mergeSettings(QSettings* srcSettings,QSettings* dstSetting,int mode)
{
	//merge local with server
			  int count = srcSettings->beginReadArray("files");
			  for (int i = 0; i < count; i++)
				{
					srcSettings->setArrayIndex(i);
					QString filename=srcSettings->value("name").toString();
					QString version=srcSettings->value("version").toString(); 
					switch(checkToSetiing(dstSetting,filename,version))
					{
						case -2://no found
							if(mode==SETTING_MERGE_SERVERTOLOCAL)
								{
									qDebug("The file %s doesn't exist on the local ,need download from server!",qPrintable(filename));
									downloadFileFromServer(filename,UPDATE_MODE_GET_FILE);
								}
							break;
						case -1:
							if(mode==SETTING_MERGE_LOCALTOSERVER)
							{
								qDebug("The server file %s version is newer than local.need download from server!",qPrintable(filename));
								downloadFileFromServer(filename,UPDATE_MODE_GET_FILE);
								
							}
							break;
						case 0:
							//qDebug("The server version is the same with local.do nothing!");
							break;
						case 1:
							//qDebug("The server version is older than local.please update it!");
							break;
						default:
							break;
					}
				}
			  srcSettings->endArray();

}
void updaterThread::getIniDone(int error)
{
	if(error==HTTP_GET_INI_SUCCESSFUL){
		//merge local with server
		if (QFile::exists(UPDATE_FILE_NAME))
			localSettings = new QSettings(UPDATE_FILE_NAME, QSettings::IniFormat, NULL);
		else
			localSettings=new QSettings(NULL,QSettings::IniFormat, NULL);
			serverSettings = new QSettings(QString("temp/").append(UPDATE_FILE_NAME), QSettings::IniFormat, NULL);
			qDebug(" Merger localsetting with serverSettings! ");
			mergeSettings(localSettings,serverSettings,SETTING_MERGE_LOCALTOSERVER);
			qDebug("Merger serverSettings with localsetting!");
			mergeSettings(serverSettings,localSettings,SETTING_MERGE_SERVERTOLOCAL);
			//update all downloaded files
			sem1.acquire(1);
			//msleep(500);
			//find the "lanuchy"
			
			//HWND   hWnd   = ::FindWindow(NULL, (LPCWSTR) QString("debug").utf16());
			//qDebug("hWnd=0x%08x\n",hWnd);
			//::SendMessage(hWnd, WM_CLOSE, 0, 0);
			

	}else
		{
			qDebug("%s error %d happened",__FUNCTION__,error);
			quit();
		}	

}
void updaterThread::getFileDone(int error)
{
		if(error==HTTP_GET_FILE_SUCCESSFUL){
			SetColor(FOREGROUND_GREEN);
			//qDebug("%s %d sem1=%d sem2=%d",__FUNCTION__,__LINE__,sem1.available(),sem2.available());
			sem2.acquire(1);
			sem1.release(1);
			//qDebug("%s %d sem1=%d sem2=%d",__FUNCTION__,__LINE__,sem1.available(),sem2.available());
			SetColor();
		}else{
			sem2.acquire(1);
			sem1.release(1);
			this->quit();			
		}
}
void updaterThread::downloadFileFromServer(QString pathname,int mode)
{
	if(mode==UPDATE_MODE_GET_FILE)	{
		sem2.release(1);		
		}
	if((mode==UPDATE_MODE_GET_FILE)&&(timers>0))
	{	
		
		sem1.acquire(1);
		msleep(500);
	}
	if(mode==UPDATE_MODE_GET_FILE) timers++;
	fprintf(stderr,"%s pathname=%s mode=%d timers=%d sem=%d sem2=%d ",__FUNCTION__,qPrintable(pathname),mode,timers,sem1.available(),sem2.available());	
		GetFileHttp *fh=new GetFileHttp(NULL,mode);
		connect(fh,SIGNAL(getIniDoneNotify(int)),this, SLOT(getIniDone(int)),Qt::DirectConnection);
		connect(fh,SIGNAL(getFileDoneNotify(int)),this, SLOT(getFileDone(int)),Qt::DirectConnection);		
		connect(fh, SIGNAL(updateStatusNotify(int)), this->parent(), SLOT(updateStatus(int)));
		fh->setHost(UPDATE_SERVER_HOST);
		fh->setUrl(pathname);
		fh->start(QThread::IdlePriority);

}
/*
int updaterThread::getRandString(QString & randString){   
    int max = 8;   
    QString tmp = QString("0123456789ABCDEFGHIJKLMNOPQRSTUVWZYZ");   
    QString str = QString();   
    QTime t;   
    t= QTime::currentTime();   
    qsrand(t.msec()+t.second()*1000);   
    for(int i=0;i<max;i++) {   
        int ir = qrand()%tmp.length();   
        str[i] = tmp.at(ir);   
    }   
    randString.append(str);   
	return 0;
}  
*/

