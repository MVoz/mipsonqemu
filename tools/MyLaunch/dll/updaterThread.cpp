#include "updaterThread.h"
#include <bmapi.h>
#include "config.h"
void GetFileHttp::terminateThread()
{
	httpTimeout();
	retryTime = UPDATE_MAX_RETRY_TIME;

}
GetFileHttp::~GetFileHttp(){
}
void GetFileHttp::clearObject(){
		for(int i=0;i<retryTime;i++)
		{
			DELETE_OBJECT(http[i]);
			DELETE_FILE(file[i]);
			DELETE_TIMER(httpTimer[i]);
		}
		DELETE_TIMER(monitorTimer);
}
void GetFileHttp::sendUpdateStatusNotify(int flag,int type)
{
	if(mode!=UPDATE_DLG_MODE) 
		return;
	emit updateStatusNotify(flag,type);
}
void GetFileHttp::on_http_responseHeaderReceived(const QHttpResponseHeader & resp)
{
//	qDebug("%s %d statuscode=%d.......",__FUNCTION__,__LINE__,resp.statusCode());
	statusCode=resp.statusCode();
}
/*
	1----success
	0----failed
*/
int GetFileHttp::newHttp()
{
	if(retryTime>=(UPDATE_MAX_RETRY_TIME-1))
		return 0;
	retryTime++;
	http[retryTime] = new QHttp();
	http[retryTime]->moveToThread(this);
	SET_NET_PROXY(http[retryTime],settings);
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
	START_TIMER_INSIDE(httpTimer[retryTime],false,10*SECONDS,httpTimeout);
	return 1;
}
void GetFileHttp::run()
{
	qRegisterMetaType<QHttpResponseHeader>("QHttpResponseHeader");
	START_TIMER_INSIDE(monitorTimer,false,10,monitorTimeout);
	QDir dir(".");
	if(!dir.exists(destdir))
		dir.mkdir(destdir);

	this->mode=mode;
	newHttp();
	exec();	
	clearObject();
}
void GetFileHttp::httpTimeout()
{
	STOP_TIMER(monitorTimer);
	sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_TIMEOUT);
	STOP_TIMER(httpTimer[retryTime]); 
	if(httpTimer[retryTime])
		http[retryTime]->abort();	
}
GetFileHttp::GetFileHttp(QObject* parent,QSettings* s,int mode,QString c): MyThread(parent,s),mode(mode),md5(c)
{
	errCode=0;
	statusCode=0;
	retryTime=-1;
	mode=0;
	for(int i=0;i<UPDATE_MAX_RETRY_TIME;i++)
	{
		http[i]=NULL;
		httpTimer[i]=NULL;
		file[i]=NULL;
	}
}

void GetFileHttp::getFileDone(bool error)
{

	THREAD_MONITOR_POINT;
	DELETE_FILE( file[retryTime] );
        if(terminateFlag)
	{
		switch(mode){
			case UPDATE_MODE_GET_INI:
				emit getIniDoneNotify(HTTP_GET_INI_SUCCESSFUL);
				break;
			case UPDATE_MODE_GET_FILE:
				emit getFileDoneNotify(HTTP_GET_FILE_SUCCESSFUL);
				break;
		}
		this->quit();
        }
	switch(mode){
		case UPDATE_MODE_GET_INI:
			if(!error)
			{
				switch(statusCode)
				{
				case HTTP_OK:
					sendUpdateStatusNotify(UPDATESTATUS_FLAG_APPLY,HTTP_GET_INI_SUCCESSFUL);
					errCode = 0;
					emit getIniDoneNotify(HTTP_GET_INI_SUCCESSFUL);
					
					break;
				case HTTP_FILE_NOT_FOUND:	
					sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_INI_NOT_EXISTED);
					errCode=HTTP_GET_INI_NOT_EXISTED;
					break;
				default:
					sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_INI_FAILED);
					errCode=HTTP_GET_INI_FAILED;		
					break;
				}
			}else{
				if(newHttp())
				{
					//httpTimer->start(10*1000);
					errCode=HTTP_NEED_RETRY;
				}
				else
				{
					sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_INI_FAILED);
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
							sendUpdateStatusNotify(UPDATESTATUS_FLAG_APPLY,HTTP_GET_FILE_SUCCESSFUL);
							emit getFileDoneNotify(HTTP_GET_FILE_SUCCESSFUL);		
						}else{
							if(newHttp())
							{
								errCode=HTTP_NEED_RETRY;
							}else
							{
								sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_FILE_FAILED);
								errCode=HTTP_GET_FILE_FAILED;							
							}

						}	
					}
					break;
				case HTTP_FILE_NOT_FOUND:	
					sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_FILE_NOT_EXISTED);
					errCode=HTTP_GET_FILE_NOT_EXISTED;						
					break;
				default:
					sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_FILE_FAILED);
					errCode=HTTP_GET_FILE_FAILED;	
					break;
				}
			}else{
				if(newHttp())
				{		
					//httpTimer->start(10*1000);
					errCode=HTTP_NEED_RETRY;
				}
				else
				{
					sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_GET_FILE_FAILED);
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
		sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_NEED_RETRY);
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
updaterThread::~updaterThread()
{
}
void updaterThread::sendUpdateStatusNotify(int flag,int type)
{
	if(mode!=UPDATE_DLG_MODE) 
		return;
	emit updateStatusNotify(flag,type);	
}
void updaterThread::testNetFinished()
{
	DELETE_OBJECT(testThread);
	switch(GET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT))
	{
	case TEST_NET_ERROR_SERVER:
		sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_NET_ERROR);
		error = 1;
		quit();
		break;
	case TEST_NET_REFUSE:
		sendUpdateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_SERVER_REFUSE);
		quit();
		error = 1;
		break;
	case TEST_NET_ERROR_PROXY:
		sendUpdateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_NET_ERROR_PROXY);
		quit();
		error = 1;
		break;
	case TEST_NET_ERROR_PROXY_AUTH:
		sendUpdateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_NET_ERROR_PROXY_AUTH);
		quit();
		error = 1;
		break;
	case TEST_NET_SUCCESS:
		downloadFileFromServer(UPDATE_SERVER_URL,UPDATE_MODE_GET_INI,"");
		break;
	}	


	//qDebug("testNetFinishedx result=%d",testThread->result);

}
void updaterThread::clearObject()
{
	DELETE_TIMER(monitorTimer);
	DELETE_OBJECT(testThread);
	if(fh)
		fh->wait();
	DELETE_OBJECT(fh);
	DELETE_OBJECT(localSettings);
	DELETE_OBJECT(serverSettings);

}
void updaterThread::terminateThread()
{	
	/*
	if(monitorTimer&&monitorTimer->isActive())
	monitorTimer->stop();
	*/
	QDEBUG_LINE;
	STOP_TIMER(monitorTimer);
	if(THREAD_IS_RUNNING(testThread))
		testThread->setTerminateFlag(1);
	if(THREAD_IS_RUNNING(fh))
		fh->setTerminateFlag(1);
}
void updaterThread::monitorTimeout()
{
	THREAD_MONITOR_POINT;
	STOP_TIMER(monitorTimer);
	 if(THREAD_IS_FINISHED(testThread))
	 {
	 		DELETE_OBJECT(testThread);
	 		testNetFinished();
	 }

	if(!needwatchchild&&terminateFlag)
	{
		needwatchchild = true;
		terminateThread();
	}

	monitorTimer->start(10);	
}

void updaterThread::run()
{
	START_TIMER_INSIDE(monitorTimer,false,10,monitorTimeout);
//	tz::netProxy(SET_MODE,settings,NULL);

	if(mode == UPDATE_DLG_MODE )
		connect(this, SIGNAL(updateStatusNotify(int,int)), this->parent(), SLOT(updateStatus(int,int)));
	
	testThread = new testServerThread(NULL,settings);
	testThread->moveToThread(this);
	testThread->start(QThread::IdlePriority);
	
	exec();
	//tz::runParameter(SET_MODE,RUN_PARAMETER_NETPROXY_USING,0);
	SET_RUN_PARAMETER(RUN_PARAMETER_NETPROXY_USING,0);
	clearObject();
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
	if(terminateFlag)
		goto end;
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

				//qDebug(" Merger localsetting with serverSettings! ");
				mergeSettings(localSettings,serverSettings,SETTING_MERGE_LOCALTOSERVER);
				//qDebug("Merger serverSettings with localsetting!");
				mergeSettings(serverSettings,localSettings,SETTING_MERGE_SERVERTOLOCAL);
				if(terminateFlag)
					goto end;
				//update all downloaded files
				//qDebug("%s error %d happened",__FUNCTION__,__LINE__);
				if(error){
					//emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_FAILED,tz::tr(UPDATE_FAILED_STRING));
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
					sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_FAILED);
					error = 1;
					goto end;
				}
				if (QFile::exists(UPDATE_FILE_NAME))
				{
					localSettings = new QSettings(UPDATE_FILE_NAME, QSettings::IniFormat, NULL);


					QString lversion =  localSettings->value("setup/version", "").toString();

					if( lversion == sversion)
					{
						sendUpdateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_NO_NEED);					
						goto end;
					}
				}
				//start download setup.exe
				if(!filename.isEmpty()&&!md5.isEmpty())
				{
					needed = 1;
					downloadFileFromServer(filename,UPDATE_MODE_GET_FILE,md5);

				}
				if(terminateFlag)
					goto end;
				if(error){
					sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_FAILED);
				}else if(needed) 
				{
					sem_downfile_success.acquire(1);
					sendUpdateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_SUCCESSFUL);
					//write update.ini
					if(!localSettings)
						localSettings = new QSettings(UPDATE_FILE_NAME, QSettings::IniFormat, NULL);
					localSettings->setValue("setup/version",sversion);
					localSettings->setValue("setup/name",filename);
					localSettings->setValue("setup/md5",md5);
					localSettings->sync();

				}
				else{
					sendUpdateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_NO_NEED);
				}			

			}else{
				sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_FAILED);
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
//	QDEBUG_LINE;
end:
	quit();

}
void updaterThread::getFileDone(int err)
{
	THREAD_MONITOR_POINT;
	if(err==HTTP_GET_FILE_SUCCESSFUL){
		sem_downfile_start.acquire(1);
		sem_downfile_success.release(1);
	}else{
		sem_downfile_start.acquire(1);
		sem_downfile_success.release(1);
		qDebug("%s error %d happened",__FUNCTION__,__LINE__);	
		error=1;
	}
}
void updaterThread::downloadFileFromServer(QString pathname,int m,QString md5)
{
	if(terminateFlag)
		return;
	if(m==UPDATE_MODE_GET_FILE)	{
		sem_downfile_start.release(1);		

	}
	if((m==UPDATE_MODE_GET_FILE)&&(timers>0))
	{	
		if(error) return;
		sem_downfile_success.acquire(1);		
		msleep(500);
	}
	if(m==UPDATE_MODE_GET_FILE) timers++;

	//qDebug("%s pathname=%s md5=%s  sem=%d sem2=%d ",__FUNCTION__,qPrintable(pathname),qPrintable(md5),sem_downfile_success.available(),sem_downfile_start.available());	
	//GetFileHttp *fh=new GetFileHttp(NULL,m,md5);
  	 if(fh)
		fh->wait();
	DELETE_OBJECT(fh);
	if(terminateFlag)
		return;
	fh=new GetFileHttp(NULL,settings,m,md5);

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

