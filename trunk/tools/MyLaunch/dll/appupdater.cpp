#include <appupdater.h>
#include <bmapi.h>
#include <config.h>
appUpdater::~appUpdater()
{
}
void appUpdater::sendUpdateStatusNotify(int flag,int type)
{
	if(mode!=UPDATE_DLG_MODE) 
		return;
	emit updateStatusNotify(flag,type);	
}
void appUpdater::testNetFinished()
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
}
void appUpdater::clearObject()
{
	DELETE_TIMER(monitorTimer);
	DELETE_OBJECT(testThread);
	if(fh)
		fh->wait();
	DELETE_OBJECT(fh);
	DELETE_OBJECT(localSettings);
	DELETE_OBJECT(serverSettings);

}
void appUpdater::terminateThread()
{	
	QDEBUG_LINE;
	STOP_TIMER(monitorTimer);
	if(THREAD_IS_RUNNING(testThread))
		testThread->setTerminateFlag(1);
	if(THREAD_IS_RUNNING(fh))
		fh->setTerminateFlag(1);
}
void appUpdater::monitorTimeout()
{
	THREAD_MONITOR_POINT;
	STOP_TIMER(monitorTimer);
	 if(THREAD_IS_FINISHED(testThread))
	 {
	 		DELETE_OBJECT(testThread);
	 		testNetFinished();
	 }

	 if(THREAD_IS_FINISHED(fh))
	 {
		if(fh->mode==UPDATE_MODE_GET_INI)
			{
				int err = fh->errCode;
				fh->wait();
				DELETE_OBJECT(fh);
				getIniDone(err);
			}
	 }

	if(!needwatchchild&&terminateFlag)
	{
		needwatchchild = true;
		terminateThread();
	}

	monitorTimer->start(10);	
}

void appUpdater::run()
{
	START_TIMER_INSIDE(monitorTimer,false,10,monitorTimeout);
	if(mode == UPDATE_DLG_MODE )
		connect(this, SIGNAL(updateStatusNotify(int,int)), this->parent(), SLOT(updateStatus(int,int)));
	
	testThread = new testNet(NULL,settings);
	testThread->moveToThread(this);
	testThread->start(QThread::IdlePriority);	
	exec();
	clearObject();
}
/*
0---same
1---newer
-1---older
*/
int appUpdater::checkToSetting(QSettings *s,const QString &filename1,const QString& md51)
{
	int ret=-1;
	int count = s->beginReadArray(UPDATE_PORTABLE_KEYWORD);
	for (int i = 0; i < count; i++)
	{
		s->setArrayIndex(i);
		QString filename2=s->value("name").toString();
		QString md52=s->value("md5").toUInt();	
		if(filename1!=filename2) 
			continue;
		if(md52 ==md51 )
			ret= 0;
		else 
			ret = 1;
		break;
	}
	s->endArray();
	return ret;
}

/*
mode:
0--local to server ,1--server to local
*/
void appUpdater::mergeSettings(QSettings* srcSettings,QSettings* dstSetting,int m)
{
	//merge local with server
	int count = srcSettings->beginReadArray(UPDATE_PORTABLE_KEYWORD);
	for (int i = 0; i < count; i++)
	{
		srcSettings->setArrayIndex(i);
		QString filename=srcSettings->value("name").toString();
		QString md5=srcSettings->value("md5",0).toString(); 
		int  flag = checkToSetting(dstSetting,filename,md5);
		switch(flag)
		{
		case -1://no found
		case 1://newer

			if(((m==SETTING_MERGE_SERVERTOLOCAL)&&(flag==-1))||((m==SETTING_MERGE_LOCALTOSERVER)&&(flag==1)))
			{

				if(
					(!QFile::exists(QString(UPDATE_PORTABLE_DIRECTORY).append(filename))||
					(md5!=tz::fileMd5(QString(UPDATE_PORTABLE_DIRECTORY).append(filename))))&&
					(!QFile::exists(filename)||(md5!=tz::fileMd5(filename)))
				  )
				{
					qDebug()<<"download......"<<filename;
					needed=1;
					downloadFileFromServer(filename,UPDATE_MODE_GET_FILE,md5);		
				}
			}
			break;
		default:
			break;
		}
	}
	srcSettings->endArray();

}
void  appUpdater::checkSilentUpdateApp()
{
	if(QFile::exists(QString(UPDATE_PORTABLE_DIRECTORY).append(APP_SILENT_UPDATE_NAME)))		
	{
		QFile::copy(QString(UPDATE_PORTABLE_DIRECTORY).append(APP_SILENT_UPDATE_NAME),APP_SILENT_UPDATE_NAME);
		QFile::remove(QString(UPDATE_PORTABLE_DIRECTORY).append(APP_SILENT_UPDATE_NAME));
	}
}
void appUpdater::getIniDone(int err)
{
	THREAD_MONITOR_POINT;
	if(terminateFlag)
		goto end;
	//sem_downfile_success.release(1);//let download file start
	switch(mode){
		case UPDATE_SILENT_MODE:				
			if(!err){
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
//						sem_downfile_success.acquire(1);
						checkSilentUpdateApp();
						tz::registerInt(REGISTER_SET_MODE,APP_HKEY_PATH,APP_HEKY_UPDATE_ITEM,1);
						//	emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_SUCCESSFUL,tz::tr(UPDATE_SUCCESSFUL_STRING));
					}
					//else
					//emit updateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_NO_NEED,tz::tr(UPDATE_NO_NEED_STRING));
					//write update.ini
					/*
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
					*/
				}
			}else
			{
				//emit updateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_FAILED,tz::tr(UPDATE_FAILED_STRING));
				qDebug("%s error %d happened",__FUNCTION__,error);

			}
			break;
		case UPDATE_DLG_MODE:
			if(!err){
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
	//				sem_downfile_success.acquire(1);
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
void appUpdater::getFileDone(int err)
{
	THREAD_MONITOR_POINT;
	/*
	if(err==HTTP_GET_FILE_SUCCESSFUL){
		//sem_downfile_start.acquire(1);
		//sem_downfile_success.release(1);
	}else{
		//sem_downfile_start.acquire(1);
		//sem_downfile_success.release(1);
		qDebug("%s error %d happened",__FUNCTION__,__LINE__);	
		error=1;
	}
	sem_downfile_success.release(1);
	*/
}
void appUpdater::downloadFileFromServer(QString pathname,int m,QString md5)
{
	THREAD_MONITOR_POINT;
	if(terminateFlag||error)
		return;
/*
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

	if((m==UPDATE_MODE_GET_FILE))
	{	
		sem_downfile_success.acquire(1);	
		if(terminateFlag||error)
		{
			sem_downfile_success.release(1);
			return;
		}
		//msleep(500);
	}
*/

	//qDebug("%s pathname=%s md5=%s  sem=%d sem2=%d ",__FUNCTION__,qPrintable(pathname),qPrintable(md5),sem_downfile_success.available(),sem_downfile_start.available());	
	//GetFileHttp *fh=new GetFileHttp(NULL,m,md5);

	DELETE_OBJECT(fh);
	if(terminateFlag)
		return;
	fh=new GetFileHttp(NULL,settings,m,md5);
	//fh->moveToThread(this);	

	//connect(fh,SIGNAL(getIniDoneNotify(int)),this, SLOT(getIniDone(int)),Qt::DirectConnection);
	//connect(fh,SIGNAL(getFileDoneNotify(int)),this, SLOT(getFileDone(int)),Qt::DirectConnection);	
	//connect(this,SIGNAL(getFileTerminateNotify()),fh, SLOT(terminateThread()),Qt::DirectConnection);

	if(mode==UPDATE_DLG_MODE) {
		connect(fh, SIGNAL(updateStatusNotify(int,int)), this->parent(), SLOT(updateStatus(int,int)));
		connect(this, SIGNAL(updateStatusNotify(int,int)), this->parent(), SLOT(updateStatus(int,int)));
	}
#ifdef CONFIG_SERVER_IP_SETTING
	SET_HOST_IP(settings,fh);
#else
	fh->setHost(UPDATE_SERVER_HOST);
#endif
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
	 if(fh&&(fh->mode==UPDATE_MODE_GET_FILE))
		fh->wait();

}

