#include <appupdater.h>
#include <bmapi.h>
#include <config.h>
void appUpdater::sendUpdateStatusNotify(int flag,int type,int icon)
{
	if(mode!=UPDATE_DLG_MODE) 
		return;
	emit updateStatusNotify(flag,type,icon);	
}
void appUpdater::testNetFinished()
{
	switch(GET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_RESULT))
	{
	case TEST_NET_ERROR_SERVER:
		sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_NET_ERROR,UPDATE_STATUS_ICON_FAILED);
		error = 1;
		quit();
		break;
	case TEST_NET_REFUSE:
		sendUpdateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_SERVER_REFUSE,UPDATE_STATUS_ICON_REFUSED);
		error = 1;
		quit();
		break;
	case TEST_NET_ERROR_PROXY:
		sendUpdateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_NET_ERROR_PROXY,UPDATE_STATUS_ICON_FAILED);
		error = 1;
		quit();
		break;
	case TEST_NET_ERROR_PROXY_AUTH:
		sendUpdateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_NET_ERROR_PROXY_AUTH,UPDATE_STATUS_ICON_FAILED);
		error = 1;
		quit();
		break;
	case TEST_NET_SUCCESS:
		{
			testThread = new testNet(NULL,settings,TEST_SERVER_VERSION);
			testThread->moveToThread(this);
			testThread->start(QThread::IdlePriority);				
		}
		break;
	}	
}
void appUpdater::testVersionFinished()
{
	switch(GET_RUN_PARAMETER(RUN_PARAMETER_TESTNET_VERSION))
	{
		case 0:
			quit();
			break;
		case 1:
			downloadFileFromServer(UPDATE_SERVER_URL,UPDATE_MODE_GET_INI,"");
			break;
	}
}
void appUpdater::clearObject()
{
	DELETE_OBJECT(testThread);
	if(fh)
		fh->wait();
	DELETE_OBJECT(fh);
	DELETE_OBJECT(localSettings);
	DELETE_OBJECT(serverSettings);
	MyThread::clearObject();
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
	 	if(testThread->mode==TEST_SERVER_NET){
			DELETE_OBJECT(testThread);
	 		testNetFinished();
	 	}else if(testThread->mode==TEST_SERVER_VERSION){
	 		QDEBUG_LINE;
	 		DELETE_OBJECT(testThread);
	 		testVersionFinished();
	 	}
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
	monitorTimer->start(tz::getParameterMib(SYS_MONITORTIMEOUT));	
}

void appUpdater::run()
{
	START_TIMER_INSIDE(monitorTimer,false,tz::getParameterMib(SYS_MONITORTIMEOUT),monitorTimeout);
	if(mode == UPDATE_DLG_MODE )
		connect(this, SIGNAL(updateStatusNotify(int,int,int)), this->parent(), SLOT(updateStatus(int,int,int)));
	
	testThread = new testNet(NULL,settings);
	testThread->moveToThread(this);
	testThread->start(QThread::IdlePriority);	
	exec();
	clearObject();
}

/*
m:0--local to server ,1--server to local
flag:0--download file 1---checkfile
*/
int appUpdater::mergeSettings(QSettings* srcSettings,QSettings* dstSetting,int m)
{
	//merge local with server
	int count = srcSettings->beginReadArray(UPDATE_PORTABLE_KEYWORD);
	for (int i = 0; i < count; i++)
	{
		if(terminateFlag||error)
			break;
		srcSettings->setArrayIndex(i);
		QString filename=srcSettings->value("name").toString();
		QString md5=srcSettings->value("md5","").toString(); 
		int  flag =tz::checkToSetting(dstSetting,filename,md5);
		switch(flag)
		{
		case -1://no found
		case 1://newer
			if(m==SETTING_MERGE_SERVERTOLOCAL)
				md5=srcSettings->value("md5","").toString(); //reupdate md5,just md5 from server is valid
			if(((m==SETTING_MERGE_SERVERTOLOCAL)&&(flag==-1))||((m==SETTING_MERGE_LOCALTOSERVER)&&(flag==1)))
			{
				if(
					(!QFile::exists(QString(UPDATE_PORTABLE_DIRECTORY).append(filename))||
					(md5!=tz::fileMd5(QString(UPDATE_PORTABLE_DIRECTORY).append(filename))))&&
					(!QFile::exists(filename)||(md5!=tz::fileMd5(filename)))
				  )
				{
					needed=1;
					downloadFileFromServer(filename,UPDATE_MODE_GET_FILE,md5);	

				}
			}
			break;
		default:
			break;
		}
	}
end:
	srcSettings->endArray();
	return needed;
}
void  appUpdater::checkSilentUpdateApp()
{
	if(QFile::exists(QString(UPDATE_PORTABLE_DIRECTORY).append(APP_SILENT_UPDATE_NAME)))		
	{
		QFile::copy(QString(UPDATE_PORTABLE_DIRECTORY).append(APP_SILENT_UPDATE_NAME),APP_SILENT_UPDATE_NAME);
		//QFile::remove(QString(UPDATE_PORTABLE_DIRECTORY).append(APP_SILENT_UPDATE_NAME));
	}
}
void appUpdater::getIniDone(int err)
{
	THREAD_MONITOR_POINT;
	if(terminateFlag||error)	goto end;
	switch(mode){
		case UPDATE_SILENT_MODE:				
			if(!err){
				//merge local with server
				localSettings = new QSettings(UPDATE_FILE_NAME, QSettings::IniFormat, NULL);
				serverSettings = new QSettings(QString(UPDATE_PORTABLE_DIRECTORY).append(UPDATE_FILE_NAME), QSettings::IniFormat, NULL);
				mergeSettings(localSettings,serverSettings,SETTING_MERGE_LOCALTOSERVER);
				mergeSettings(serverSettings,localSettings,SETTING_MERGE_SERVERTOLOCAL);
				if(terminateFlag)	goto end;
				if(!error&&needed) 
				{
					checkSilentUpdateApp();
					tz::registerInt(REGISTER_SET_MODE,APP_HKEY_PATH,APP_HEKY_UPDATE_ITEM,1);
					//write update.ini
					/*
					int count = serverSettings->beginReadArray(UPDATE_PORTABLE_KEYWORD);
					localSettings->beginWriteArray(UPDATE_PORTABLE_KEYWORD);
					for (int i = 0; i < count; i++)
							{
								serverSettings->setArrayIndex(i);								
								localSettings->setArrayIndex(i);
								localSettings->setValue("name",serverSettings->value("name").toString());
								localSettings->setValue("md5",serverSettings->value("md5").toString()); 
							}
					serverSettings->endArray();
					localSettings->endArray();
					localSettings->sync();
					*/
				}
			}
			break;
		case UPDATE_DLG_MODE:
			if(!err){
				serverSettings = new QSettings(QString(UPDATE_SETUP_DIRECTORY).append(UPDATE_FILE_NAME), QSettings::IniFormat, NULL);
				QString filename = serverSettings->value("setup/name", "").toString();
				QString servermd5 = serverSettings->value("setup/md5", "").toString();
				if(filename.isEmpty()||servermd5.isEmpty())
				{
					//get wrong content form server
					sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_FAILED,UPDATE_STATUS_ICON_FAILED);
					error = 1;
					goto end;
				}
				if (QFile::exists(UPDATE_FILE_NAME))
				{
					localSettings = new QSettings(UPDATE_FILE_NAME, QSettings::IniFormat, NULL);
					QString localmd5 = serverSettings->value("setup/md5", "").toString();
					if( servermd5 == localmd5)
					{
						sendUpdateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_NO_NEED,UPDATE_STATUS_ICON_SUCCESSFUL);					
						goto end;
					}
				}
				//start download setup.exe
				if(!filename.isEmpty()&&!servermd5.isEmpty())
				{
					needed = 1;
					downloadFileFromServer(filename,UPDATE_MODE_GET_FILE,servermd5);
				}
				if(terminateFlag||error)
					goto end;
				if(error){
					sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_FAILED,UPDATE_STATUS_ICON_FAILED);
				}else if(needed) 
				{
					sendUpdateStatusNotify(UPDATESTATUS_FLAG_APPLY,UPDATE_SUCCESSFUL,UPDATE_STATUS_ICON_SUCCESSFUL);
					//write update.ini
					if(!localSettings)
						localSettings = new QSettings(UPDATE_FILE_NAME, QSettings::IniFormat, NULL);
					localSettings->setValue("setup/name",filename);
					localSettings->setValue("setup/md5",servermd5);
					localSettings->sync();
				}		

			}else{
				sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,UPDATE_FAILED,UPDATE_STATUS_ICON_FAILED);
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
void appUpdater::downloadFileFromServer(QString pathname,int m,QString md5)
{
	THREAD_MONITOR_POINT;
	if(terminateFlag||error)
		return;
	qDebug()<<"download......"<<pathname<<"md5:"<<md5;
	DELETE_OBJECT(fh);
	fh=new GetFileHttp(NULL,settings,m,md5);

	if(mode==UPDATE_DLG_MODE) {
		connect(fh, SIGNAL(updateStatusNotify(int,int,int)), this->parent(), SLOT(updateStatus(int,int,int)));
		connect(this, SIGNAL(updateStatusNotify(int,int,int)), this->parent(), SLOT(updateStatus(int,int,int)));
	}
#ifdef CONFIG_SERVER_IP_SETTING
	SET_HOST_IP(settings,fh);
#else
	fh->setHost(UPDATE_SERVER_HOST);
#endif
	fh->setDestdir(UPDATE_DIRECTORY);
	fh->setServerBranch("/download");
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
	 error = fh->errCode;
	 qDebug()<<pathname<<" error code:"<<error;
}


