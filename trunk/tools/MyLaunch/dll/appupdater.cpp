#include <appupdater.h>
#include <bmapi.h>
#include <config.h>
appUpdater::~appUpdater(){

}
void appUpdater::testNetFinished(int status)
{
	THREAD_MONITOR_POINT;
         TD(DEBUG_LEVEL_NORMAL,tz::getstatusstring(status));
	switch(status)
	{
	case TEST_NET_SUCCESS:
		{
			doNetThread = new DoNetThread(NULL,settings,DOWHAT_TEST_SERVER_VERSION,0);
			threadList.append((QThread*)doNetThread);
			sendUpdateStatusNotify(BM_TESTVERSION_START);	
			doNetThread->moveToThread(this);	
			doNetThread->setUrl(TOUCHANY_VERSION_URL);
			connect(doNetThread, SIGNAL(doNetStatusNotify(int)), this, SLOT(sendUpdateStatusNotify(int)));
			doNetThread->start(QThread::IdlePriority);
		}						
		break;
	case TEST_VERSION_SUCCESS:
		{
			downloadFileFromServer(UPDATE_SERVER_URL,DOWHAT_GET_UPDATEINI_FILE,"");
		}
		break;
	default:
		QDEBUG_LINE;
		exit(-1);
		break;
	}	
}
void appUpdater::terminateThread()
{	
	QDEBUG_LINE;
	STOP_TIMER(monitorTimer);
	if(THREAD_IS_RUNNING(doNetThread))
		doNetThread->setTerminateFlag(1);
//	if(THREAD_IS_RUNNING(fh))
//		fh->setTerminateFlag(1);
}
void appUpdater::monitorTimeout()
{
	THREAD_MONITOR_POINT;
	STOP_TIMER(monitorTimer);
	 if(THREAD_IS_FINISHED(doNetThread))
	 {
	 	int d = doNetThread->doWhat;
		int s = doNetThread->statusCode;		
		switch(d){
			case DOWHAT_TEST_SERVER_VERSION:
			case DOWHAT_TEST_SERVER_NET:
				testNetFinished(s);
				break;
			case DOWHAT_GET_UPDATEINI_FILE:
				getUpdateINIDone(s);
				break;
			case DOWHAT_GET_COMMON_FILE:
				break;
			}
	 }
	if(!needwatchchild&&terminateFlag)
	{
		needwatchchild = true;
		terminateThread();
	}
	monitorTimer->start(tz::getParameterMib(SYS_MONITORTIMEOUT));	
}
void appUpdater::cleanObjects(){
	QDEBUG_LINE;
//	DELETE_THREAD(doNetThread);
	DELETE_OBJECT(localSettings);
	DELETE_OBJECT(serverSettings);
	NetThread::cleanObjects();
}

void appUpdater::run()
{
	NetThread::run();
	if(dlgmode == UPDATE_DLG_MODE )
		connect(this, SIGNAL(updateStatusNotify(int)), this->parent(), SLOT(updateStatus(int)));
	
	doNetThread = new DoNetThread(NULL,settings,DOWHAT_TEST_SERVER_NET,0);
	threadList.append((QThread*)doNetThread);
	doNetThread->setUrl(TEST_NET_URL);
	doNetThread->moveToThread(this);
	doNetThread->start(QThread::IdlePriority);	
	exec();
	cleanObjects();
}

/*
m:0--local to server ,1--server to local
flag:0--download file 1---checkfile
*/
int appUpdater::mergeSettings(QSettings* srcSettings,QSettings* dstSetting,int m)
{
	//merge local with server
	int count = srcSettings->beginReadArray(UPDATE_PORTABLE_KEYWORD);
	TD(DEBUG_LEVEL_NORMAL,count);
	for (int i = 0; i < count; i++)
	{
		if(terminateFlag||error)
			break;
		srcSettings->setArrayIndex(i);
		QString f=srcSettings->value("name").toString();
		QString md5=srcSettings->value("md5","").toString(); 
		int  flag =tz::checkToSetting(dstSetting,f,md5);
		switch(flag)
		{
		case -1://no found
		case 1://newer
			if(m==SETTING_MERGE_SERVERTOLOCAL)
				md5=srcSettings->value("md5","").toString(); //reupdate md5,just md5 from server is valid
			if(((m==SETTING_MERGE_SERVERTOLOCAL)&&(flag==-1))||((m==SETTING_MERGE_LOCALTOSERVER)&&(flag==1)))
			{
				if(
					(!QFile::exists(QString(UPDATE_PORTABLE_DIRECTORY).append(f))||
					(md5!=tz::fileMd5(QString(UPDATE_PORTABLE_DIRECTORY).append(f))))&&
					(!QFile::exists(f)||(md5!=tz::fileMd5(f)))
				  )
				{
					needed=1;
					QDEBUG_LINE;
					downloadFileFromServer(f,DOWHAT_GET_COMMON_FILE,md5);	

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
void appUpdater::getUpdateINIDone(int status)
{	
	THREAD_MONITOR_POINT;
	if(terminateFlag||(status!=DOWHAT_GET_FILE_SUCCESS))
		goto end;
	switch(dlgmode){
		case UPDATE_SILENT_MODE:				
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
			break;
		case UPDATE_DLG_MODE:
			{
				serverSettings = new QSettings(QString(UPDATE_SETUP_DIRECTORY).append(UPDATE_FILE_NAME), QSettings::IniFormat, NULL);
				QString f = serverSettings->value("setup/name", "").toString();
				QString servermd5 = serverSettings->value("setup/md5", "").toString();
				if(f.isEmpty()||servermd5.isEmpty())
				{
					//get wrong content form server
					sendUpdateStatusNotify(UPDATE_FAILED);
					error = 1;
					goto end;
				}
				if (QFile::exists(UPDATE_FILE_NAME))
				{
					localSettings = new QSettings(UPDATE_FILE_NAME, QSettings::IniFormat, NULL);
					QString localmd5 = serverSettings->value("setup/md5", "").toString();
					if( servermd5 == localmd5)
					{
						sendUpdateStatusNotify(UPDATE_NO_NEED);					
						goto end;
					}
				}
				//start download setup.exe
				if(!f.isEmpty()&&!servermd5.isEmpty())
				{
					needed = 1;
					downloadFileFromServer(f,DOWHAT_GET_COMMON_FILE,servermd5);
				}
				if(terminateFlag||error)
					goto end;
				if(error){
					sendUpdateStatusNotify(UPDATE_FAILED);
				}else if(needed) 
				{
					sendUpdateStatusNotify(UPDATE_SUCCESSFUL);
					//write update.ini
					if(!localSettings)
						localSettings = new QSettings(UPDATE_FILE_NAME, QSettings::IniFormat, NULL);
					localSettings->setValue("setup/name",f);
					localSettings->setValue("setup/md5",servermd5);
					localSettings->sync();
				}	
			}
			break;
		default:
			break;
	}
end:
	if(dlgmode == UPDATE_DLG_MODE)		
		sendUpdateStatusNotify(UPDATE_FAILED);
	quit();

}
void appUpdater::downloadFileFromServer(QString pathname,int m,QString md5)
{
	THREAD_MONITOR_POINT;
	if(terminateFlag||error)
		return;
	TD(DEBUG_LEVEL_NORMAL,"download......"<<pathname<<"md5:"<<md5);
	//DELETE_THREAD(doNetThread);	
	doNetThread=new DoNetThread(NULL,settings,m,0);
	threadList.append((QThread*)doNetThread);
	doNetThread->setMD5Key(md5);
	if(dlgmode==UPDATE_DLG_MODE) {
		connect(doNetThread, SIGNAL(updateStatusNotify(int)), this->parent(), SLOT(updateStatus(int)));
	}
	doNetThread->setDestDirectory(UPDATE_DIRECTORY);
	//doNetThread->setServerBranch("/download");
	//htttp://www.tanzhi.com/download/setup/tanzhi.exe
	//htttp://www.tanzhi.com/download/portable/tanzhi.exe
	switch(dlgmode)
	{
	case UPDATE_DLG_MODE:
		doNetThread->setFileWithFullpath(QString("setup\\").append(pathname).replace("/","\\"));
		doNetThread->setUrl(QString("/download/setup/").append(pathname));
		break;
	case UPDATE_SILENT_MODE:
		doNetThread->setFileWithFullpath(QString("portable\\").append(pathname).replace("/","\\"));
		doNetThread->setUrl(QString("/download/portable/").append(pathname));
		break;
	}

	doNetThread->start(QThread::IdlePriority);
	if(doNetThread&&(doNetThread->doWhat==DOWHAT_GET_COMMON_FILE))
		doNetThread->wait();
//	 error = fh->errCode;
//	 qDebug()<<pathname<<" error code:"<<error;
}


