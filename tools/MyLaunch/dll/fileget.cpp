#include <fileget.h>
#include <bmapi.h>
#include <config.h>
void GetFileHttp::terminateThread()
{
	httpTimeout();
	retryTime = UPDATE_MAX_RETRY_TIME;

}
GetFileHttp::~GetFileHttp(){
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

void GetFileHttp::downloadFileDone(bool error)
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
					//emit getIniDoneNotify(HTTP_GET_INI_SUCCESSFUL);					
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
						//qDebug("downloadFilename=%s md5=%s caclmd5=%s isEqual=%d",qPrintable(downloadFilename),qPrintable(md5),qPrintable(tz::fileMd5(downloadFilename)),isEqual);
						if(isEqual){
							sendUpdateStatusNotify(UPDATESTATUS_FLAG_APPLY,HTTP_GET_FILE_SUCCESSFUL);
							//emit getFileDoneNotify(HTTP_GET_FILE_SUCCESSFUL);	
							errCode=0;
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

	switch(errCode){
	case HTTP_NEED_RETRY:
		sendUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,HTTP_NEED_RETRY);
		qDebug("%d times to get %s from server!",retryTime,qPrintable(updaterFilename));
		break;
	default:
		this->quit();
		break;
	}
}