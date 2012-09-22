#include <fileget.h>
#include <bmapi.h>
#include <config.h>

GetFileHttp::GetFileHttp(QObject* parent,QSettings* s,int m,QString c): NetThread(parent,s,m),md5(c)
{
	errCode=0;
	retryTime=-1;
}
GetFileHttp::~GetFileHttp(){
}
void GetFileHttp::terminateThread()
{
	retryTime = UPDATE_MAX_RETRY_TIME;
}
/*
	1----success
	0----failed
*/
int GetFileHttp::newHttpX()
{
	if(retryTime>=(UPDATE_MAX_RETRY_TIME-1))
		return 0;
	retryTime++;

	DELETE_OBJECT(http);
	DELETE_FILE(file);

	QDir dir(".");
	if(filename.isNull())
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
			filename=QString(dirPath.append(na.at(count-1)));//real filename
		else
			filename=QString(dirPath.append(savefilename));//real filename
	}		
	NetThread::newHttp(FALSE,FALSE,TRUE,FALSE);
	connect(http, SIGNAL(done(bool)), this, SLOT(downloadFileDone(bool)),Qt::DirectConnection);
	
	url=QString(branch).append("/").append(updaterFilename);
	http->get(url, file);
	return 1;
}
void GetFileHttp::cleanObjects()
{
	THREAD_MONITOR_POINT;
	NetThread::cleanObjects();
}
void GetFileHttp::run()
{
	NetThread::run();
	QDir dir(".");
	if(!dir.exists(destdir))
		dir.mkdir(destdir);
	newHttpX();
	exec();	
	cleanObjects();
}
void GetFileHttp::monitorTimeout()
{
	THREAD_MONITOR_POINT;
	STOP_TIMER(monitorTimer);
	NetThread::monitorTimeout();
}
void GetFileHttp::downloadFileDone(bool error)
{
	THREAD_MONITOR_POINT;
	DELETE_FILE( file );
        if(terminateFlag)
	{
		errCode=HTTP_GET_FILE_FAILED;
		quit();
		return;
        }
	qDebug()<<"httpRspCode"<<httpRspCode<<" error:"<<error<<" "<<http->errorString();
	if(!error){
		switch(httpRspCode)
			{
			case HTTP_OK:
				{
					qDebug()<<"md5"<<md5<<" filemd5:"<<tz::fileMd5(filename);
					if(md5.isEmpty()||tz::fileMd5(filename)==md5){
						sendUpdateStatusNotify(HTTP_GET_FILE_SUCCESSFUL);
					}else{
						goto RETRY;
					}	
				}
				break;
			case HTTP_FILE_NOT_FOUND:	
				sendUpdateStatusNotify((doWhat==UPDATE_MODE_GET_FILE)?(HTTP_GET_FILE_NOT_EXISTED):(HTTP_GET_INI_NOT_EXISTED));				
				break;
			default:
				sendUpdateStatusNotify((doWhat==UPDATE_MODE_GET_FILE)?(HTTP_GET_FILE_FAILED):(HTTP_GET_INI_FAILED));
				break;
			}
	}else{
		goto RETRY;
	}
	quit();
	return;
RETRY:
	if(newHttpX())	
		sendUpdateStatusNotify(HTTP_NEED_RETRY);
	else
		sendUpdateStatusNotify((doWhat==UPDATE_MODE_GET_FILE)?HTTP_GET_FILE_FAILED:(HTTP_GET_INI_FAILED));	
	if(errCode!=HTTP_NEED_RETRY)
		quit();	
	return;
}