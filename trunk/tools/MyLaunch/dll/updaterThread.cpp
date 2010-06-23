#include <updaterThread.h>
#include <QUrl>
#include <QWaitCondition>
#include <QSemaphore>
#include <QDir>
#include <QStringList>
#include <bmapi.h>
#include "config.h"

void GetFileHttp::on_http_stateChanged(int stat)
{

	switch (stat)
	  {
	  case QHttp::Unconnected:
		 // qDebug("Unconnected");
		//  emit updateStatusNotify(HTTP_UNCONNECTED);
		  break;
	  case QHttp::HostLookup:
		//  qDebug("HostLookup");
		//  emit updateStatusNotify(HTTP_HOSTLOOKUP);
		  break;
	  case QHttp::Connecting:
		 // qDebug("Connecting");
		//  emit updateStatusNotify(HTTP_CONNECTING);
		  break;
	  case QHttp::Sending:
		 // qDebug("Sending");
		//  emit updateStatusNotify(HTTP_SENDING);
		  break;
	  case QHttp::Reading:
		//  qDebug("Reading");
		//  emit updateStatusNotify(HTTP_READING);
		  break;
	  case QHttp::Connected:
		//  qDebug("Connected");
		 // emit updateStatusNotify(HTTP_CONNECTED);
		  break;
	  case QHttp::Closing:
		//  qDebug("Closing");
		//  emit updateStatusNotify(HTTP_CLOSING);
		  break;
	  }

}

void GetFileHttp::on_http_dataReadProgress(int done, int total)
{
//	qDebug("Downloaded:get file %s %d bytes out of %d", qPrintable(updaterFilename),done, total);
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
void GetFileHttp::newHttp()
{
		http[retryTime] = new QHttp();

		connect(http[retryTime], SIGNAL(stateChanged(int)), this, SLOT(on_http_stateChanged(int)),Qt::DirectConnection);
		//connect(http, SIGNAL(stateChanged(int)), this, SLOT(on_http_stateChanged(int)));
		//connect(http, SIGNAL(readyRead (QHttpResponseHeader )),this,SLOT(on_http_responseHeaderReceived(QHttpResponseHeader)));
		connect(http[retryTime], SIGNAL(dataReadProgress(int, int)), this, SLOT(on_http_dataReadProgress(int, int)),Qt::DirectConnection);
		connect(http[retryTime], SIGNAL(dataSendProgress(int, int)), this, SLOT(on_http_dataSendProgress(int, int)),Qt::DirectConnection);
		// connect(http, SIGNAL(done(bool)), this, SLOT(on_http_done(bool)));
		connect(http[retryTime], SIGNAL(requestFinished(int, bool)), this, SLOT(on_http_requestFinished(int, bool)),Qt::DirectConnection);
		connect(http[retryTime], SIGNAL(requestStarted(int)), this, SLOT(on_http_requestStarted(int)),Qt::DirectConnection);
		connect(http[retryTime], SIGNAL(responseHeaderReceived(const QHttpResponseHeader &)), this, SLOT(on_http_responseHeaderReceived(const QHttpResponseHeader &)),Qt::DirectConnection);
		connect(http[retryTime], SIGNAL(done(bool)), this, SLOT(getFileDone(bool)),Qt::DirectConnection);
		http[retryTime]->setHost(host);
		QDir dir(".");
		if(downloadFilename.isNull())
		{
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
			downloadFilename=QString(dirPath.append(na.at(count-1)));
		}		
		qDebug("downloadFilename=%s",qPrintable(downloadFilename));
		file[retryTime] = new QFile(downloadFilename);
		file[retryTime]->open(QIODevice::ReadWrite | QIODevice::Truncate);
		

		url=QString("/download/").append(updaterFilename);
		//qDebug("url=%s filename=%s\n",qPrintable(url),qPrintable(dirPath));
		http[retryTime]->get(url, file[retryTime]);
		httpTimer[retryTime]=new QTimer();
		
     		httpTimer[retryTime]->start(10*1000);
		connect(httpTimer[retryTime], SIGNAL(timeout()), this, SLOT(httpTimerSlot()), Qt::DirectConnection);
}
void GetFileHttp::run()
{
		qRegisterMetaType<QHttpResponseHeader>("QHttpResponseHeader");
		
		
		QDir dir(".");
		if(!dir.exists("temp"))
			dir.mkdir("temp");

		this->mode=mode;
		newHttp();
		exec();	
		//httpTimer->stop();
}
void GetFileHttp::httpTimerSlot()
{
	qDebug("httpTimerSlot.......");
	emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_TIMEOUT,tz::tr(HTTP_TIMEOUT_STRING));
	httpTimer[retryTime]->stop();
	http[retryTime]->abort();	
}
GetFileHttp::GetFileHttp(QObject* parent,int mode,uint c): QThread(parent),mode(mode)
{
	errCode=0;
	statusCode=0;
	retryTime=0;
	mode=0;
	checksum=c;
	for(int i=0;i<UPDATE_MAX_RETRY_TIME;i++)
		{
			http[i]=NULL;
			httpTimer[i]=NULL;
			file[i]=NULL;
		}
}

void GetFileHttp::getFileDone(bool error)
{
	
	if (!IS_NULL(file[retryTime]))
	  {
	  	  
		  file[retryTime]->close();
		  delete file[retryTime];
		  file[retryTime] = NULL;
	  }
	 
	switch(mode){
		case UPDATE_MODE_GET_INI:
			if(!error)
			{
				switch(statusCode)
				{
				case HTTP_OK:
					emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,HTTP_GET_INI_SUCCESSFUL,tz::tr(HTTP_GET_INI_SUCCESSFUL_STRING));
					emit getIniDoneNotify(HTTP_GET_INI_SUCCESSFUL);

					break;
				case HTTP_FILE_NOT_FOUND:				
					emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_INI_NOT_EXISTED,tz::tr(HTTP_GET_INI_NOT_EXISTED_STRING));
					errCode=HTTP_GET_INI_NOT_EXISTED;
					break;
				default:
					emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_INI_FAILED,tz::tr(HTTP_GET_INI_FAILED_STRING));
					errCode=HTTP_GET_INI_FAILED;		
					break;
				}
			}else{
				if(retryTime<UPDATE_MAX_RETRY_TIME)
				{
												
						retryTime++;
						newHttp();
						//httpTimer->start(10*1000);
						errCode=HTTP_NEED_RETRY;
				}
				else
					{
						emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_INI_FAILED,tz::tr(HTTP_GET_INI_FAILED_STRING));
						errCode=HTTP_GET_INI_FAILED;						
					}
			}
			break;
		case UPDATE_MODE_GET_FILE:
			if(!error){
					switch(statusCode)
					{
					case HTTP_OK:
						{
						QFile fileCkSum(downloadFilename);
						int isEqual=0;
						if(fileCkSum.open(QIODevice::ReadOnly)){
							//qDebug("ini file's checkSum is %d",getFileChecksum(&fileCkSum));
							isEqual=(checksum==getFileChecksum(&fileCkSum));
							fileCkSum.close();
						}	
						if(isEqual){
								emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,HTTP_GET_FILE_SUCCESSFUL,tz::tr(HTTP_GET_FILE_SUCCESSFUL_STRING));
					         		emit getFileDoneNotify(HTTP_GET_FILE_SUCCESSFUL);		
							}else{
								if(retryTime<UPDATE_MAX_RETRY_TIME)
								{
																
										retryTime++;
										newHttp();
										errCode=HTTP_NEED_RETRY;
								}else
								{
									emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_FILE_FAILED,tz::tr(HTTP_GET_FILE_FAILED_STRING));
									errCode=HTTP_GET_FILE_FAILED;							
								}

							}	
						}
						break;
					case HTTP_FILE_NOT_FOUND:	
						emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_FILE_NOT_EXISTED,tz::tr(HTTP_GET_FILE_NOT_EXISTED_STRING));
						errCode=HTTP_GET_FILE_NOT_EXISTED;						
						break;
					default:
							emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_FILE_FAILED,tz::tr(HTTP_GET_FILE_FAILED_STRING));
							errCode=HTTP_GET_FILE_FAILED;	
							break;
					}
				}else{
					if(retryTime<UPDATE_MAX_RETRY_TIME)
					{		
						retryTime++;
						newHttp();
						//httpTimer->start(10*1000);
						errCode=HTTP_NEED_RETRY;
					}
					else
						{
							emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_FILE_FAILED,tz::tr(HTTP_GET_FILE_FAILED_STRING));
							errCode=HTTP_GET_FILE_FAILED;							
						}
				}
			break;
		default:
			break;
		}
	 if(errCode)
	 	{
	
			switch(errCode){
					case HTTP_NEED_RETRY:
						emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_NEED_RETRY,tz::tr(HTTP_NEED_RETRY_STRING));
						qDebug("%d times to get %s from server!",retryTime,qPrintable(updaterFilename));
						break;
					case HTTP_GET_INI_NOT_EXISTED:
						 emit getIniDoneNotify(HTTP_GET_INI_NOT_EXISTED);
						qDebug("The file %s doesn't exist in server!",qPrintable(updaterFilename));
						deleteDirectory(QString("temp"));
						this->quit();
						break;
					case HTTP_GET_FILE_NOT_EXISTED:
						emit getFileDoneNotify(HTTP_GET_FILE_NOT_EXISTED);
						qDebug("The file %s doesn't exist in server!",qPrintable(updaterFilename));
						deleteDirectory(QString("temp"));
						this->quit();
						break;
					case HTTP_GET_INI_FAILED:
						emit getIniDoneNotify(HTTP_GET_INI_FAILED);
						qDebug("get file %s from server failed at %d times!\n",qPrintable(updaterFilename),retryTime);
						deleteDirectory(QString("temp"));
						this->quit();
						break;
					case HTTP_GET_FILE_FAILED:
						emit getFileDoneNotify(HTTP_GET_FILE_FAILED);
						qDebug("get file %s from server failed at %d times!\n",qPrintable(updaterFilename),retryTime);
						deleteDirectory(QString("temp"));
						this->quit();
						break;
				}
	 	}
	 else
	 	{
	 		//emit updateStatusNotify(HTTP_GET_FILE_SUCCESSFUL);
			//qDebug("get file %s from server successfully!",qPrintable(updaterFilename));
 	 		this->quit();
	 	}
	 
}



/*
updaterThread::updaterThread(QObject* parent): QThread(parent)
{
	timers=0;
}
*/
void updaterThread::testNetFinished(QNetworkReply* reply)
{
	qDebug("network reply error code %d",reply->error());
	testNetTimer->stop();
	error=reply->error();
//	testNet.release(1);
	if(!error)
	{
			downloadFileFromServer(UPDATE_SERVER_URL,UPDATE_MODE_GET_INI,0);
	}else{
		emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_NET_ERROR,tz::tr(UPDATE_NET_ERROR_STRING));
		quit();
	}
}
void updaterThread::testNetTimeout()
{
	qDebug("%s %d",__FUNCTION__,__LINE__);
	testNetTimer->stop();
	reply->abort();
}
void updaterThread::run()
{
#if 1
		connect(this, SIGNAL(updateStatusNotify(int,int,QString)), this->parent(), SLOT(updateStatus(int,int,QString)));

		manager=new QNetworkAccessManager();
		testNetTimer=new QTimer();
		connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(testNetFinished(QNetworkReply*)));
		reply=manager->get(QNetworkRequest(QUrl("http://192.168.115.2/")));
		testNetTimer->start(30*1000);//1 
		connect(testNetTimer, SIGNAL(timeout()), this, SLOT(testNetTimeout()), Qt::DirectConnection);

#endif

		exec();
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
					uint checkSum=srcSettings->value("checksum",0).toUInt(); 
					switch(checkToSetiing(dstSetting,filename,version))
					{
						case -2://no found
							if(mode==SETTING_MERGE_SERVERTOLOCAL)
								{
									qDebug("The file %s doesn't exist on the local ,need download from server!",qPrintable(filename));
									needed=1;
									downloadFileFromServer(filename,UPDATE_MODE_GET_FILE,checkSum);
								}
							break;
						case -1:
							if(mode==SETTING_MERGE_LOCALTOSERVER)
							{
								qDebug("The server file %s version is newer than local.need download from server!",qPrintable(filename));
								needed=1;
								downloadFileFromServer(filename,UPDATE_MODE_GET_FILE,checkSum);								
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
			qDebug("%s error %d happened",__FUNCTION__,__LINE__);
			if(error){
					//sem_downfile_success.acquire(1);
					emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_FAILED,tz::tr(UPDATE_FAILED_STRING));
			}else if(needed) 
				{
					sem_downfile_success.acquire(1);
					emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_SUCCESSFUL,tz::tr(UPDATE_SUCCESSFUL_STRING));
				}
			else
					emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_NO_NEED,tz::tr(UPDATE_NO_NEED_STRING));
			quit();
			//msleep(500);
			//find the "lanuchy"
			
			//HWND   hWnd   = ::FindWindow(NULL, (LPCWSTR) QString("debug").utf16());
			//qDebug("hWnd=0x%08x\n",hWnd);
			//::SendMessage(hWnd, WM_CLOSE, 0, 0);
			

	}else
		{
			emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_FAILED,tz::tr(UPDATE_FAILED_STRING));
			qDebug("%s error %d happened",__FUNCTION__,error);
			quit();
		}	

}
void updaterThread::getFileDone(int error)
{
		if(error==HTTP_GET_FILE_SUCCESSFUL){
		//	SetColor(FOREGROUND_GREEN,0);
			sem_downfile_start.acquire(1);
			sem_downfile_success.release(1);
		//	SetColor(FOREGROUND_INTENSITY,0);
		}else{
			sem_downfile_start.acquire(1);
			sem_downfile_success.release(1);
			qDebug("%s error %d happened",__FUNCTION__,__LINE__);	
			error=1;
		//	this->quit();			
		}
}
void updaterThread::downloadFileFromServer(QString pathname,int mode,uint checksum)
{
	if(mode==UPDATE_MODE_GET_FILE)	{
		sem_downfile_start.release(1);		
	
		}
	if((mode==UPDATE_MODE_GET_FILE)&&(timers>0))
	{	
		
		sem_downfile_success.acquire(1);
			if(error) return;
		msleep(500);
	}
	if(mode==UPDATE_MODE_GET_FILE) timers++;
		fprintf(stderr,"%s pathname=%s checksum=%d  sem=%d sem2=%d ",__FUNCTION__,qPrintable(pathname),checksum,sem_downfile_success.available(),sem_downfile_start.available());	
		GetFileHttp *fh=new GetFileHttp(NULL,mode,checksum);
		connect(fh,SIGNAL(getIniDoneNotify(int)),this, SLOT(getIniDone(int)),Qt::DirectConnection);
		connect(fh,SIGNAL(getFileDoneNotify(int)),this, SLOT(getFileDone(int)),Qt::DirectConnection);		
		connect(fh, SIGNAL(updateStatusNotify(int,int,QString)), this->parent(), SLOT(updateStatus(int,int,QString)));
		connect(this, SIGNAL(updateStatusNotify(int,int,QString)), this->parent(), SLOT(updateStatus(int,int,QString)));
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

