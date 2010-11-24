#include <fileget.h>
#include <bmapi.h>
#include <config.h>
void GetFileHttp::terminateThread()
{
	httpTimeout();
	retryTime = UPDATE_MAX_RETRY_TIME;

}
void GetFileHttp::clearObject(){
		for(int i=0;i<=retryTime;i++)
		{
			DELETE_OBJECT(http[i]);
			DELETE_FILE(file[i]);
			DELETE_TIMER(httpTimer[i]);
		}
		DELETE_TIMER(monitorTimer);
}
void GetFileHttp::sendUpdateStatusNotify(int flag,int type)
{
	if(type == HTTP_GET_FILE_SUCCESSFUL||type == HTTP_GET_INI_SUCCESSFUL)
		errCode = 0;
	else
		errCode = type;
	if(mode!=UPDATE_DLG_MODE) 
		return;
	emit updateStatusNotify(flag,type);
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
	connect(http[retryTime], SIGNAL(done(bool)), this, SLOT(downloadFileDone(bool)),Qt::DirectConnection);
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
//	qDebug("downloadFilename=%s",qPrintable(downloadFilename));
	file[retryTime] = new QFile(downloadFilename);
	file[retryTime]->open(QIODevice::ReadWrite | QIODevice::Truncate);


	url=QString(branch).append("/").append(updaterFilename);
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
GetFileHttp::GetFileHttp(QObject* parent,QSettings* s,int m,QString c): MyThread(parent,s),mode(m),md5(c)
{
	errCode=0;
	statusCode=0;
	retryTime=-1;
	for(int i=0;i<UPDATE_MAX_RETRY_TIME;i++)
	{
		http[i]=NULL;
		httpTimer[i]=NULL;
		file[i]=NULL;
	}
}
void GetFileHttp::on_http_responseHeaderReceived(const QHttpResponseHeader & resp)
{
	statusCode=resp.statusCode();
	if(statusCode == HTTP_OK)
		STOP_TIMER(httpTimer[retryTime]); 
}
void GetFileHttp::downloadFileDone(bool error)
{
	THREAD_MONITOR_POINT;
	DELETE_FILE( file[retryTime] );
        if(terminateFlag)
	{
		errCode=HTTP_GET_FILE_FAILED;
		quit();
		return;
        }
	qDebug()<<"statusCode"<<statusCode<<" error:"<<error<<" "<<http[retryTime]->errorString();
	if(!error){
		switch(statusCode)
			{
			case HTTP_OK:
				{
					qDebug()<<"md5"<<md5<<" filemd5:"<<tz::fileMd5(downloadFilename);
					if(md5.isEmpty()||tz::fileMd5(downloadFilename)==md5){
						sendUpdateStatusNotify(UPDATESTATUS_FLAG_APPLY,HTTP_GET_FILE_SUCCESSFUL);
					}else{
						goto RETRY;
					}	
				}
				break;
			case HTTP_FILE_NOT_FOUND:	
				sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,(mode==UPDATE_MODE_GET_FILE)?HTTP_GET_FILE_NOT_EXISTED:HTTP_GET_INI_NOT_EXISTED);				
				break;
			default:
				sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,(mode==UPDATE_MODE_GET_FILE)?HTTP_GET_FILE_FAILED:HTTP_GET_INI_FAILED);
				break;
			}
	}else{
		goto RETRY;
	}
	quit();
	return;
RETRY:
	if(newHttp())	
		sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_NEED_RETRY);
	else
		sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,(mode==UPDATE_MODE_GET_FILE)?HTTP_GET_FILE_FAILED:HTTP_GET_INI_FAILED);	
	if(errCode!=HTTP_NEED_RETRY)
		quit();	
	return;
}