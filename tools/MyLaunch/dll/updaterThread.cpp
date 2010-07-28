#include <updaterThread.h>
#include <QUrl>
#include <QWaitCondition>
#include <QSemaphore>
#include <QDir>
#include <QStringList>
#include <bmapi.h>
#include "config.h"
void GetFileHttp::terminateThread()
{
	httpTimerSlot();
	retryTime = UPDATE_MAX_RETRY_TIME;

}
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
	//qDebug("Downloaded:get file %s %d bytes out of %d", qPrintable(updaterFilename),done, total);
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

		SET_NET_PROXY(http[retryTime]);
		
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
			QString  dirPath=QString(destdir).append("\\");
			int i=0;
			int count=na.count();
			for(i=0;i<count-1&&count>1;i++)
			{
				dirPath.append(na.at(i));
				if(!dir.exists(dirPath))
					dir.mkdir(dirPath);		
				 dirPath.append("\\");
			}
			if(savefilename.isEmpty())
				downloadFilename=QString(dirPath.append(na.at(count-1)));//real filename
			else
				downloadFilename=QString(dirPath.append(savefilename));//real filename
		}		
		qDebug("downloadFilename=%s",qPrintable(downloadFilename));
		file[retryTime] = new QFile(downloadFilename);
		file[retryTime]->open(QIODevice::ReadWrite | QIODevice::Truncate);
		

		url=QString(branch).append("/").append(updaterFilename);
		//qDebug("url=%s filename=%s\n",qPrintable(url),qPrintable(dirPath));
		http[retryTime]->get(url, file[retryTime]);
		httpTimer[retryTime]=new QTimer();
		
     		httpTimer[retryTime]->start(10*1000);
		connect(httpTimer[retryTime], SIGNAL(timeout()), this, SLOT(httpTimerSlot()), Qt::DirectConnection);
}
void GetFileHttp::run()
{
		qRegisterMetaType<QHttpResponseHeader>("QHttpResponseHeader");
		monitorTimer = new QTimer();
		connect(monitorTimer, SIGNAL(timeout()), this, SLOT(monitorTimerSlot()), Qt::DirectConnection);
		monitorTimer->start(10);
		monitorTimer->moveToThread(this);
		
		QDir dir(".");
		if(!dir.exists(destdir))
			dir.mkdir(destdir);

		this->mode=mode;
		newHttp();
		exec();	
		//httpTimer->stop();
}
void GetFileHttp::httpTimerSlot()
{
	if(monitorTimer&&monitorTimer->isActive())
		monitorTimer->stop();
	qDebug("httpTimerSlot.......");
	if(mode==UPDATE_DLG_MODE) 
		emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_TIMEOUT);
	if(httpTimer[retryTime]&&httpTimer[retryTime]->isActive())
		httpTimer[retryTime]->stop();
	http[retryTime]->abort();	
}
GetFileHttp::GetFileHttp(QObject* parent,int mode,QString c): QThread(parent),mode(mode),md5(c)
{
	errCode=0;
	statusCode=0;
	retryTime=0;
	mode=0;
	monitorTimer =NULL;
	terminateFlag = 0;
	for(int i=0;i<UPDATE_MAX_RETRY_TIME;i++)
		{
			http[i]=NULL;
			httpTimer[i]=NULL;
			file[i]=NULL;
		}
}
void GetFileHttp::monitorTimerSlot()
{
	if(monitorTimer&&monitorTimer->isActive())
		monitorTimer->stop();
	if(terminateFlag)
		terminateThread();
	else
		monitorTimer->start(10);
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
					if(mode==UPDATE_DLG_MODE) 
						emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,HTTP_GET_INI_SUCCESSFUL);
					emit getIniDoneNotify(HTTP_GET_INI_SUCCESSFUL);

					break;
				case HTTP_FILE_NOT_FOUND:	
					if(mode==UPDATE_DLG_MODE) 
						emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_INI_NOT_EXISTED);
					errCode=HTTP_GET_INI_NOT_EXISTED;
					break;
				default:
					if(mode==UPDATE_DLG_MODE) 
						emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_INI_FAILED);
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
						if(mode==UPDATE_DLG_MODE) 
							emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_INI_FAILED);
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
						int isEqual=0;
						if(md5.isEmpty()||tz::fileMd5(downloadFilename)==md5)
							isEqual = 1;
						qDebug("downloadFilename=%s md5=%s caclmd5=%s isEqual=%d",qPrintable(downloadFilename),qPrintable(md5),qPrintable(tz::fileMd5(downloadFilename)),isEqual);
						/*	
						QFile fileCkSum(downloadFilename);
						
						if(fileCkSum.open(QIODevice::ReadOnly)){
							//qDebug("ini file's checkSum is %d",getFileChecksum(&fileCkSum));
							isEqual=(checksum==getFileChecksum(&fileCkSum));
							fileCkSum.close();
						}	
						*/
						if(isEqual){
								if(mode==UPDATE_DLG_MODE) 
									emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,HTTP_GET_FILE_SUCCESSFUL);
					         		emit getFileDoneNotify(HTTP_GET_FILE_SUCCESSFUL);		
							}else{
								if(retryTime<UPDATE_MAX_RETRY_TIME)
								{
																
										retryTime++;
										newHttp();
										errCode=HTTP_NEED_RETRY;
								}else
								{
									if(mode==UPDATE_DLG_MODE) 
										emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_FILE_FAILED);
									errCode=HTTP_GET_FILE_FAILED;							
								}

							}	
						}
						break;
					case HTTP_FILE_NOT_FOUND:	
						if(mode==UPDATE_DLG_MODE) 
							emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_FILE_NOT_EXISTED);
						errCode=HTTP_GET_FILE_NOT_EXISTED;						
						break;
					default:
							if(mode==UPDATE_DLG_MODE) 
								emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_FILE_FAILED);
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
							if(mode==UPDATE_DLG_MODE) 
								emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_FILE_FAILED);
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
						if(mode==UPDATE_DLG_MODE) 
							emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_NEED_RETRY);
						qDebug("%d times to get %s from server!",retryTime,qPrintable(updaterFilename));
						break;
					case HTTP_GET_INI_NOT_EXISTED:
						 emit getIniDoneNotify(HTTP_GET_INI_NOT_EXISTED);
						qDebug("The file %s doesn't exist in server!",qPrintable(updaterFilename));
						//deleteDirectory(QString("temp"));
						this->quit();
						break;
					case HTTP_GET_FILE_NOT_EXISTED:
						emit getFileDoneNotify(HTTP_GET_FILE_NOT_EXISTED);
						qDebug("The file %s doesn't exist in server!",qPrintable(updaterFilename));
						//deleteDirectory(QString("temp"));
						this->quit();
						break;
					case HTTP_GET_INI_FAILED:
						emit getIniDoneNotify(HTTP_GET_INI_FAILED);
						qDebug("get file %s from server failed at %d times!\n",qPrintable(updaterFilename),retryTime);
						//deleteDirectory(QString("temp"));
						this->quit();
						break;
					case HTTP_GET_FILE_FAILED:
						emit getFileDoneNotify(HTTP_GET_FILE_FAILED);
						qDebug("get file %s from server failed at %d times!\n",qPrintable(updaterFilename),retryTime);
						//deleteDirectory(QString("temp"));
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
/*
void updaterThread::testNetFinished(QNetworkReply* reply)
{
	qDebug("network reply error code %d isactive=%d",reply->error(),testNetTimer->isActive());
	if(testNetTimer->isActive())
		testNetTimer->stop();
	//qDebug("network reply error code %d isactive=%d",reply->error(),testNetTimer->isActive());
	error=reply->error();
//	testNet.release(1);
	if(!error)
	{
			QString replybuf(reply->readAll());
			qDebug("%s replly=%s",__FUNCTION__,qPrintable(replybuf));
			if(replybuf == "1")
				downloadFileFromServer(UPDATE_SERVER_URL,UPDATE_MODE_GET_INI,"");
			else{
				if(mode==UPDATE_DLG_MODE) 
					emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_SERVER_REFUSE,tz::tr(UPDATE_SERVER_REFUSE_STRING));
				quit();
			}
			
	}else{
		if(mode==UPDATE_DLG_MODE) 
			emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_NET_ERROR,tz::tr(UPDATE_NET_ERROR_STRING));
		quit();
	}
}
void updaterThread::testNetTimeout()
{
	qDebug("%s %d",__FUNCTION__,__LINE__);
	if(testNetTimer->isActive())
		testNetTimer->stop();
	reply->abort();
}
*/
void updaterThread::testNetFinishedx()
{
	qDebug("testNetFinishedx result=%d",tz::runParameter(GET_MODE,RUN_PARAMETER_TESTNET_RESULT,0));
	if(testThread)
			delete testThread;
	switch(tz::runParameter(GET_MODE,RUN_PARAMETER_TESTNET_RESULT,0))
				{
					case -1:
						if(mode==UPDATE_DLG_MODE) 
							emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_NET_ERROR);	
						quit();
					break;
					case 0:
						if(mode==UPDATE_DLG_MODE) 
							emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_SERVER_REFUSE);		
						quit();
					break;
					case 1:
						downloadFileFromServer(UPDATE_SERVER_URL,UPDATE_MODE_GET_INI,"");
					break;
		}	

	
	//qDebug("testNetFinishedx result=%d",testThread->result);

}
void updaterThread::terminateThread()
{	
	if(monitorTimer&&monitorTimer->isActive())
		monitorTimer->stop();
	if(testThread&&testThread->isRunning())
		testThread->setTerminateFlag(1);
	if(fh&&fh->isRunning())
		fh->setTerminateFlag(1);
}
void updaterThread::monitorTimerSlot()
{
	if(monitorTimer&&monitorTimer->isActive())
		monitorTimer->stop();
	if(terminateFlag)
		terminateThread();
	else
		monitorTimer->start(10);
}

void updaterThread::run()
{
		monitorTimer = new QTimer();
		connect(monitorTimer, SIGNAL(timeout()), this, SLOT(monitorTimerSlot()), Qt::DirectConnection);
		monitorTimer->start(10);
		monitorTimer->moveToThread(this);
		
		 tz::netProxy(SET_MODE,settings,NULL);
		 
		if(mode == UPDATE_DLG_MODE )
			connect(this, SIGNAL(updateStatusNotify(int,int)), this->parent(), SLOT(updateStatus(int,int)));
#if 0
		manager=new QNetworkAccessManager();
		manager->moveToThread(this);
		testNetTimer=new QTimer();
		testNetTimer->moveToThread(this);
		connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(testNetFinished(QNetworkReply*)),Qt::DirectConnection);
		reply=manager->get(QNetworkRequest(QUrl(TEST_NET_URL)));
		testNetTimer->start(30*SECONDS);
		connect(testNetTimer, SIGNAL(timeout()), this, SLOT(testNetTimeout()), Qt::DirectConnection);
#else
		//testServerThread *testThread = new testServerThread(NULL);
		{
			testThread = new testServerThread(NULL);

			connect(testThread,SIGNAL(finished()), this, SLOT(testNetFinishedx()));
			//connect(this,SIGNAL(testNetTerminateNotify()), testThread, SLOT(terminateThread()));
			qDebug("start testServerThread::");
			//qDebug("start testServerThread 0x%08x result=%d",testThread,testThread->result);
			testThread->start(QThread::IdlePriority);
		}	
		
#endif
		
		exec();
		tz::runParameter(SET_MODE,RUN_PARAMETER_NETPROXY_USING,0);
		qDebug("sync thread quit.............");


}
/*
	0---same
	1---newer
	-1---older
*/
int updaterThread::checkToSetiing(QSettings *settings,const QString &filename1,const uint& version1)
{
	int ret=-2;
	int count = settings->beginReadArray(UPDATE_PORTABLE_KEYWORD);
		  for (int i = 0; i < count; i++)
		    {
			    settings->setArrayIndex(i);
			         QString filename2=settings->value("name").toString();
				 uint version2=settings->value("version").toUInt();	
				if(filename1!=filename2) continue;
				if(version2 ==version1 )
					ret= 0;
				else if(version2 < version1 )
					ret = 1;
				else if(version2 > version1 )
					ret = -1;
				/*
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
				*/
				break;
		    }
		  settings->endArray();
		  return ret;
}

/*
	mode:
		0--local to server ,1--server to local
*/
void updaterThread::mergeSettings(QSettings* srcSettings,QSettings* dstSetting,int m)
{
	//merge local with server
			  int count = srcSettings->beginReadArray(UPDATE_PORTABLE_KEYWORD);
			  for (int i = 0; i < count; i++)
				{
					srcSettings->setArrayIndex(i);
					QString filename=srcSettings->value("name").toString();
					uint version=srcSettings->value("version").toUInt(); 
					QString md5=srcSettings->value("md5",0).toString(); 
					//qDebug("%s filename=%s version=%d",__FUNCTION__,qPrintable(filename),version);
					int  flag = checkToSetiing(dstSetting,filename,version);
					switch(flag)
					{
						case -2://no found
						
							if(m==SETTING_MERGE_SERVERTOLOCAL)
								{
									qDebug("The file %s doesn't exist on the local ,need download from server!",qPrintable(filename));
									
									if(
										(!QFile::exists(QString(UPDATE_PORTABLE_DIRECTORY).append(filename))||(md5!=tz::fileMd5(QString(UPDATE_PORTABLE_DIRECTORY).append(filename))))
										&&
										(!QFile::exists(filename)||(md5!=tz::fileMd5(filename)))
									 )
										{
											needed=1;
											downloadFileFromServer(filename,UPDATE_MODE_GET_FILE,md5);		
										}
								}
							break;
						
						case -1:
							if(m==SETTING_MERGE_LOCALTOSERVER)
							{
									qDebug("The server file %s version is newer than local.need download from server!",qPrintable(filename));
									
									//check whether existes in temp directory!
									if(
										(!QFile::exists(QString(UPDATE_PORTABLE_DIRECTORY).append(filename))||(md5!=tz::fileMd5(QString(UPDATE_PORTABLE_DIRECTORY).append(filename))))
										&&
										(!QFile::exists(filename)||(md5!=tz::fileMd5(filename)))
									 )
									 {
											needed=1;
											downloadFileFromServer(filename,UPDATE_MODE_GET_FILE,md5);								
									}
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
void  updaterThread::checkSilentUpdateApp()
{
	if(QFile::exists(QString(UPDATE_PORTABLE_DIRECTORY).append(APP_SILENT_UPDATE_NAME)))		
		{
			QFile::copy(QString(UPDATE_PORTABLE_DIRECTORY).append(APP_SILENT_UPDATE_NAME),APP_SILENT_UPDATE_NAME);
			QFile::remove(QString(UPDATE_PORTABLE_DIRECTORY).append(APP_SILENT_UPDATE_NAME));
		}
}
void updaterThread::getIniDone(int err)
{

	switch(mode){
		case UPDATE_SILENT_MODE:				
			if(err==HTTP_GET_INI_SUCCESSFUL){
			//merge local with server
			//if (QFile::exists(UPDATE_FILE_NAME))
				localSettings = new QSettings(UPDATE_FILE_NAME, QSettings::IniFormat, NULL);
			//else
			//	localSettings=new QSettings(NULL,QSettings::IniFormat, NULL);
			serverSettings = new QSettings(QString(UPDATE_PORTABLE_DIRECTORY).append(UPDATE_FILE_NAME), QSettings::IniFormat, NULL);
			//get newer.exe independently
			
			
			qDebug(" Merger localsetting with serverSettings! ");
			mergeSettings(localSettings,serverSettings,SETTING_MERGE_LOCALTOSERVER);
			qDebug("Merger serverSettings with localsetting!");
			mergeSettings(serverSettings,localSettings,SETTING_MERGE_SERVERTOLOCAL);
			//update all downloaded files
			//qDebug("%s error %d happened",__FUNCTION__,__LINE__);
				if(error){
							//emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_FAILED,tz::tr(UPDATE_FAILED_STRING));
							tz::registerInt(REGISTER_SET_MODE,APP_HKEY_PATH,APP_HEKY_UPDATE_ITEM,0);
				}else{
					if(needed) 
						{
							sem_downfile_success.acquire(1);
							checkSilentUpdateApp();
							tz::registerInt(REGISTER_SET_MODE,APP_HKEY_PATH,APP_HEKY_UPDATE_ITEM,1);
						//	emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_SUCCESSFUL,tz::tr(UPDATE_SUCCESSFUL_STRING));
						}
					//else
						//emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_NO_NEED,tz::tr(UPDATE_NO_NEED_STRING));
					//write update.ini
					int count = serverSettings->beginReadArray(UPDATE_PORTABLE_KEYWORD);
					localSettings->beginWriteArray(UPDATE_PORTABLE_KEYWORD);
					for (int i = 0; i < count; i++)
					{
						serverSettings->setArrayIndex(i);								
						localSettings->setArrayIndex(i);
						localSettings->setValue("version",serverSettings->value("version").toUInt());
						localSettings->setValue("name",serverSettings->value("name").toString());
						localSettings->setValue("md5",serverSettings->value("md5").toString());	
					}
					  serverSettings->endArray();
					 localSettings->endArray();
					 localSettings->sync();
				}
			}else
			{
					//emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_FAILED,tz::tr(UPDATE_FAILED_STRING));
					tz::registerInt(REGISTER_SET_MODE,APP_HKEY_PATH,APP_HEKY_UPDATE_ITEM,0);
					qDebug("%s error %d happened",__FUNCTION__,error);
				
			}
			break;
		case UPDATE_DLG_MODE:
			if(err==HTTP_GET_INI_SUCCESSFUL){
				serverSettings = new QSettings(QString(UPDATE_SETUP_DIRECTORY).append(UPDATE_FILE_NAME), QSettings::IniFormat, NULL);
				QString sversion =  serverSettings->value("setup/version", "").toString();
				QString filename = serverSettings->value("setup/name", "").toString();
				QString md5 = serverSettings->value("setup/md5", "").toString();
				if(sversion.isEmpty()||filename.isEmpty()||md5.isEmpty())
					{
						//get wrong content form server
						emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_FAILED);
						error = 1;
						goto end;
					}
				if (QFile::exists(UPDATE_FILE_NAME))
				{
					localSettings = new QSettings(UPDATE_FILE_NAME, QSettings::IniFormat, NULL);
					

					QString lversion =  localSettings->value("setup/version", "").toString();
					
					if( lversion == sversion)
						{
							emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_NO_NEED);					
							goto end;
						}
				}
				//start download setup.exe
				if(!filename.isEmpty()&&!md5.isEmpty())
					{
						needed = 1;
						downloadFileFromServer(filename,UPDATE_MODE_GET_FILE,md5);
						
					}
				if(error){
						emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_FAILED);
				}else if(needed) 
					{
							sem_downfile_success.acquire(1);
							emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_SUCCESSFUL);
							//write update.ini
							if(!localSettings)
								localSettings = new QSettings(UPDATE_FILE_NAME, QSettings::IniFormat, NULL);
							localSettings->setValue("setup/version",sversion);
							localSettings->setValue("setup/name",filename);
							localSettings->setValue("setup/md5",md5);
							localSettings->sync();
							
					}
				else{
							emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_NO_NEED);
					}			
				
			}else{
				emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_FAILED);
			}
			break;
		default:
			break;
	}

	//msleep(500);
		//find the "lanuchy"
		
		//HWND	 hWnd	= ::FindWindow(NULL, (LPCWSTR) QString("debug").utf16());
		//qDebug("hWnd=0x%08x\n",hWnd);
		//::SendMessage(hWnd, WM_CLOSE, 0, 0);
end:
	quit();

}
void updaterThread::getFileDone(int err)
{
		if(err==HTTP_GET_FILE_SUCCESSFUL){
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
void updaterThread::downloadFileFromServer(QString pathname,int m,QString md5)
{
	if(m==UPDATE_MODE_GET_FILE)	{
		sem_downfile_start.release(1);		
	
		}
	if((m==UPDATE_MODE_GET_FILE)&&(timers>0))
	{	
		
		sem_downfile_success.acquire(1);
			if(error) return;
		msleep(500);
	}
	if(m==UPDATE_MODE_GET_FILE) timers++;
	
		qDebug("%s pathname=%s md5=%s  sem=%d sem2=%d ",__FUNCTION__,qPrintable(pathname),qPrintable(md5),sem_downfile_success.available(),sem_downfile_start.available());	
		//GetFileHttp *fh=new GetFileHttp(NULL,m,md5);
		if(fh)
			delete fh;
		fh=new GetFileHttp(NULL,m,md5);
		
		connect(fh,SIGNAL(getIniDoneNotify(int)),this, SLOT(getIniDone(int)),Qt::DirectConnection);
		connect(fh,SIGNAL(getFileDoneNotify(int)),this, SLOT(getFileDone(int)),Qt::DirectConnection);	
		//connect(this,SIGNAL(getFileTerminateNotify()),fh, SLOT(terminateThread()),Qt::DirectConnection);
		
		if(mode==UPDATE_DLG_MODE) {
			connect(fh, SIGNAL(updateStatusNotify(int,int)), this->parent(), SLOT(updateStatus(int,int)));
			connect(this, SIGNAL(updateStatusNotify(int,int)), this->parent(), SLOT(updateStatus(int,int)));
		}
		
		fh->setHost(UPDATE_SERVER_HOST);
		fh->setDestdir(UPDATE_DIRECTORY);
		fh->setServerBranch("/download");
		/*
		if(pathname.lastIndexOf("/")==-1){
			fh->setSaveFilename(pathname.section( '/', -1 ))
		}else
			fh->setSaveFilename(pathname);
		*/	
		//htttp://www.tanzhi.com/download/setup/tanzhi.exe
		//htttp://www.tanzhi.com/download/portable/tanzhi.exe
		switch(mode)
		{
			case UPDATE_DLG_MODE:
				fh->setUrl(QString("setup/").append(pathname));
				break;
			case UPDATE_SILENT_MODE:
				fh->setUrl(QString("portable/").append(pathname));
				break;
		}
		
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

