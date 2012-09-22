#include <bmpost.h>
#include <bmsync.h>
#include <bmapi.h>

bmPost::bmPost(QObject * parent,QSettings* s,int type ):NetThread(parent,s,0)
{
	postType=type;
}
void bmPost::cleanObjects(){
	NetThread::cleanObjects();
}

void bmPost::run()
{
	THREAD_MONITOR_POINT;
	NetThread::run();	
	switch(postType)
	{
	case POST_HTTP_TYPE_HANDLE_ITEM:
		{
			//QString bm_handle_url;
			qsrand((unsigned) NOW_SECONDS);
			uint key=qrand()%(getkeylength());
			QString auth_encrypt_str=tz::encrypt(QString("username=%1 password=%2").arg(username).arg(password),key);			
			if(action==POST_HTTP_ACTION_ADD_ITEM||action==POST_HTTP_ACTION_ADD_DIR)
			{
				url=QString(BM_SERVER_ADD_URL).arg(parentid).arg(browserid).arg(auth_encrypt_str).arg(key);
			}
			else if(action==POST_HTTP_ACTION_DELETE_ITEM)
			{
				url=QString(BM_SERVER_DELETE_URL).arg(bmid).arg(browserid).arg(auth_encrypt_str).arg(key);
			}
			else if(action==POST_HTTP_ACTION_DELETE_DIR)
			{
				url=QString(BM_SERVER_DELETE_DIR).arg(bmid).arg(browserid).arg(auth_encrypt_str).arg(key);
			}
		}
		break;
	case POST_HTTP_TYPE_TESTACCOUNT:
		url = QString(BM_TEST_ACCOUNT_URL);	
		break;				
	}
	NetThread::newHttp(TRUE,TRUE,FALSE,FALSE);
	connect(http, SIGNAL(done(bool)), this, SLOT(httpDone(bool)), Qt::DirectConnection);
	http->request(*header, postString.toUtf8(), resultBuffer);
	exec();
	if(http)
		disconnect(http, 0, 0, 0);
	cleanObjects();
}

void bmPost::httpDone(bool error)
{
	THREAD_MONITOR_POINT;
//	STOP_TIMER(postTimer);
	if(!error)
	{
		uint newgroupid=0;
		QString lastModified=0;
		uint bmid=0;
		QXmlStreamReader* resultXml=new QXmlStreamReader(resultBuffer->data());
		while (!resultXml->atEnd())
		{
			resultXml->readNext();
			if (resultXml->isStartElement())
			{
				if (resultXml->name() == "status" )
				{
					if(resultXml->attributes().value("result").toString()==DOSUCCESSS)
					{
						lastModified=resultXml->attributes().value("lastmodified").toString();
						newgroupid=resultXml->attributes().value("groupid").toString().toUInt();
						bmid=resultXml->attributes().value("bmid").toString().toUInt();
					}
					break;
				}
			} 
		}
		if(!lastModified.isEmpty()){
			setUpdatetime(lastModified);
		}else
			error = QHttp::UnknownError;
		switch(action){
			case POST_HTTP_ACTION_DELETE_ITEM:					
				break;
			case POST_HTTP_ACTION_DELETE_DIR:
				break;
			case POST_HTTP_ACTION_ADD_ITEM:
				if(bmid){
					SET_RUN_PARAMETER(RUN_PARAMETER_POST_BMID,bmid);
				}else
					error = QHttp::UnknownError;
				break;
			case POST_HTTP_ACTION_ADD_DIR:
				if(newgroupid&&bmid){
					SET_RUN_PARAMETER(RUN_PARAMETER_POST_MAX_GROUPID,newgroupid);
					SET_RUN_PARAMETER(RUN_PARAMETER_POST_BMID,bmid);	
				}else
					error = QHttp::UnknownError;
				break;
		}
		/*
		//groupid maybe is zero,but bmid mustn't be zero
		if((!lastModified.isEmpty())&&bmid){
			//setMaxGroupId(newgroupid);
			SET_RUN_PARAMETER(RUN_PARAMETER_POST_MAX_GROUPID,newgroupid);
			setUpdatetime(lastModified);
			//setBmId(bmid);
			SET_RUN_PARAMETER(RUN_PARAMETER_POST_BMID,bmid);			
		}else
			error = QHttp::UnknownError;
		*/
		DELETE_OBJECT(resultXml);
		qDebug("%s resultBuffer=%s gMaxGroupId=%u lastModified=%s bmid=%u",__FUNCTION__,qPrintable( QString(resultBuffer->data())),GET_RUN_PARAMETER(RUN_PARAMETER_POST_MAX_GROUPID),qPrintable(lastModified),GET_RUN_PARAMETER(RUN_PARAMETER_POST_BMID));
	}
	//setPostError(error);
	SET_RUN_PARAMETER(RUN_PARAMETER_POST_ERROR,error);
	exit(error);
}

void bmPost::terminateThread()
{
	NetThread::terminateThread();
}
void bmPost::monitorTimeout(){
	STOP_TIMER(monitorTimer);
	NetThread::monitorTimeout();
}
