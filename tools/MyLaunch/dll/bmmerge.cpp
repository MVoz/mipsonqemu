#include <bmmerge.h>
bmMerge::bmMerge(QObject * parent ,QSqlDatabase* b,QSettings* s,QString u,QString p):QThread(parent),db(b),settings(s),username(u),password(p)
{
	file = NULL;
	posthp=NULL;
	firefox_version=0;
	mergestatus=MERGE_STATUS_SUCCESS_NO_MODIFY;
	terminatedFlag=0;
	GetShellDir(CSIDL_FAVORITES, iePath);
}
bmMerge::~bmMerge(){	
}

void bmMerge::setRandomFileFromserver(QString& s)
{
	filename_fromserver = s;
}
bool bmMerge::checkXmlfileFromServer()
{

	if(!QFile::exists(filename_fromserver))
		return false;

	QFile s_file(filename_fromserver);
	if (!s_file.open(QIODevice::ReadOnly | QIODevice::Text))
		return false;
	if (!s_file.atEnd()) {
		QString line = s_file.readLine();
		if (line.contains(DO_NOTHING)) {
			modifiedInServer=0;
			qDebug("no modification on server!!!");
			goto good;
		}else if(line.contains(LOGIN_FALIL_STRING)){
			qDebug("login failed!!!");
			mergestatus = MERGE_STATUS_FAIL_LOGIN;
			emit mgUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,BM_SYNC_FAIL_SERVER_LOGIN);
			goto bad;
		}
		else{
			qDebug("has modification on server!!!");
			goto good;
		}
	}

good:
	s_file.close();
	return true;
bad:
	s_file.close();
	return false;
}
#if 0
bool mergeThread::checkFirefoxDir(QString& path)
{
	QString  path;
	if(!getFirefoxPath(path))
		return false;
	if(path.isNull()||path.isEmpty())
		return false;
	QDir ff_dir(path);
	if(!ff_dir.exists())
		return false;
}
bool mergeThread::openFirefox3Db(QSqlDatabase& db,QString path)
{

	db = QSqlDatabase::addDatabase("QSQLITE", "dbFirefox");					
	QString ffpath=QString(path).append("/places.sqlite");
	db.setDatabaseName(ffpath);	
	//qDebug()<<"Open Firefox DB:"<<ffpath;
	if ( !db.open())  {
		// qDebug("connect %s failed",qPrintable(ff_path));     
		goto bad;
	}else{ 
		//qDebug("connect database %s successfully!\n",qPrintable(ff_path));   
		if(!tz::testFirefoxDbLock(&db)){
			qDebug()<<"firefox db is locked!";
			goto bad;
		}
	}
	qDebug("Open Firefox DB successfully!");
	return true;	
bad:
	closeFirefox3Db(db);
	return false;
}
void mergeThread::closeFirefox3Db(QSqlDatabase& db)
{
	if(db.isOpen())	
		db.close();
	QSqlDatabase::removeDatabase("dbFirefox");		
}
//uint  gMaxGroupId;
#endif
void bmMerge::clearObject()
{
	DELETE_FILE(file);
	DELETE_OBJECT(posthp);
	if(!filename_fromserver.isEmpty()&&QFile::exists(filename_fromserver))
	{
		QFile::remove(filename_fromserver);	
	}
}
void bmMerge::dumpBcList(QList<bookmark_catagory>* s)
{
	foreach(bookmark_catagory item, *s)
	{
		qDebug()<<"item:name:"<<item.name<<"link:"<<item.link<<"bmid:"<<item.bmid<<"parentid:"<<item.parentId<<"groupid:"<<item.groupId;
		if(item.list.count()){
			dumpBcList(&item.list);
		}
	}
}
bool bmMerge::loadLastupdateData(struct browserinfo* b,int modifiedInServer,bmXml **lastUpdate,const QString filepath,uint *browserenable)
{
	//get browser enable
	QFile f;
	int i = 0;
	while(!b[i].name.isEmpty())
	{
		int browserid = b[i].id;

		//lastupdate xml file whether enable or not
		if(QFile::exists(filepath))
		{
			f.setFileName(filepath);
			f.open(QIODevice::ReadOnly);	
#ifdef LOCALBM_COMPRESS_ENABLE
			QByteArray ba = f.readAll();
			QByteArray unzipped = qUncompress(ba);
			qDebug(unzipped.constData());
			QDataStream in(&unzipped, QIODevice::ReadOnly);
			//			in.setVersion(QDataStream::Qt_4_2);
			lastUpdate[i] = new bmXml(in.device(),settings);
			lastUpdate[i]->readStream(browserid);
#else
			lastUpdate[i] = new bmXml(&f,settings);
			lastUpdate[i]->readStream(browserid);
#endif
			f.close();

			//check whether browser's enable is correspond  with localbm.dat
			if(modifiedInServer==0){
				if((browserenable[i] )!=(lastUpdate[i]->browserenable))
				{
					qDebug()<<__FUNCTION__<<browserenable[i]<<"   "<<lastUpdate[i]->browserenable;
					return false;
				}
			}
		}else{
			lastUpdate[i] = new bmXml(NULL,settings);
		}
		setBrowserInfoOpFlag(browserid, BROWSERINFO_OP_LASTUPDATE);
		i++;
	}
	return true;
}
void bmMerge::storeLocalbmData(const QString path,struct browserinfo* b,uint* browserenable,QList < bookmark_catagory > *result,bmXml **lastUpdate,const QString time)
{
#ifdef LOCALBM_COMPRESS_ENABLE
	QByteArray ba;
	QDataStream os(&ba, QIODevice::ReadWrite);
	//os.setVersion(QDataStream::Qt_4_2);
	//os.setCodec("UTF-8");
	int i = 0;
	while(!b[i].name.isEmpty())
	{
		int browserid = b[i].id;
		//XmlReader::bmListToXml(((browserid==BROWSE_TYPE_IE)?BM_WRITE_HEADER:((browserid==(BROWSE_TYPE_MAX-1))?BM_WRITE_END:0)), (browserenable[i])?(&result[browserid]):&(lastUpdate[browserid]->bm_list), &os,browserid,1,time,browserenable[i]);
		i++;
	}
	QFile localfile(path);
	qDebug(ba.constData());
	if(localfile.open(QIODevice::WriteOnly| QIODevice::Truncate)){
		qDebug()<<"Write to localbm";
		localfile.write(qCompress(ba));
		localfile.close();			
	}
#else
	QFile localfile(path);
	if(localfile.open(QIODevice::WriteOnly| QIODevice::Truncate)){
		QTextStream os(&localfile);
		os.setCodec("UTF-8");
		int i = 0;
		uint userid = qhashEx(username,username.length());
		while(!b[i].name.isEmpty())
		{
			int browserid = b[i].id;
			bmXml::bmListToXml(((browserid==BROWSE_TYPE_IE)?BM_WRITE_HEADER:((browserid==(BROWSE_TYPE_MAX-1))?BM_WRITE_END:0)), (browserenable[i])?(&result[browserid]):&(lastUpdate[browserid]->bm_list), &os,browserid,1,time,browserenable[i],userid);
			i++;
		}		
		localfile.close();	
	}
#endif		
}	

void bmMerge::handleBmData()
{
	THREAD_MONITOR_POINT;
	int i = 0;
	setPostError(false);

	/*for result */
	QList < bookmark_catagory > result_bc[BROWSE_TYPE_MAX];
	/*for current*/
	QList < bookmark_catagory > current_bc[BROWSE_TYPE_MAX];

	bmXml *lastUpdate[BROWSE_TYPE_MAX]={NULL};
	bmXml *fromServer[BROWSE_TYPE_MAX]={NULL};

	uint browserenable[BROWSE_TYPE_MAX];
	//from lastupdater
	QString localBmFullPath;	
	QString ff_path;
	QString updateTime;
	QFile f;
	QString filemd5;

	modifiedInServer=1;

	if(!checkXmlfileFromServer())
		return;
	/*check localbm.dat if md5 faile ,remove it*/
	{
		getUserLocalFullpath(settings,QString(LOCAL_BM_SETTING_FILE_NAME),localBmFullPath);
		if(QFile::exists(localBmFullPath)){
			filemd5 =  tz::fileMd5(localBmFullPath);	
			if(qhashEx(filemd5,filemd5.length())!=settings->value("localbmkey",0).toUInt())
			{
				qDebug()<<"md5 error remove "<<localBmFullPath;
				QFile::remove(localBmFullPath);
			}
		}
	}

	//set to value to avoid crash
	settings->setValue("localbmkey",0);
	settings->sync();

	struct browserinfo* browserInfo =tz::getbrowserInfo();
	//get browser enable
	i = 0;
	while(!browserInfo[i].name.isEmpty())
	{
		//20101114 get the enable value to avoid modified
		browserenable[i] =browserInfo[i].enable?1:0;
		i++;
	}
	if(!loadLastupdateData(browserInfo,modifiedInServer,lastUpdate,localBmFullPath,browserenable))
		goto CLEAR;
	{

		i = 0;
		while(!browserInfo[i].name.isEmpty())
		{
			int browserid = browserInfo[i].id;
			if( browserenable[i] )
			{
				//from server xml file
				if(QFile::exists(filename_fromserver)&&modifiedInServer)
				{
					f.setFileName(filename_fromserver);
					f.open(QIODevice::ReadOnly);
					fromServer[i] = new bmXml(&f,settings);
					fromServer[i]->readStream(BROWSE_TYPE_IE);

					//      dumpBcList(&fromServer[i]->bm_list);	

					setUpdatetime(fromServer[i]->updateTime);
					f.close();
					setBrowserInfoOpFlag(browserid, BROWSERINFO_OP_FROMSERVER);
				}else if(modifiedInServer==0)
					setBrowserInfoOpFlag(browserid, BROWSERINFO_OP_FROMSERVER);
				//current from kinds of browser type
				switch( browserid )
				{
				case BROWSE_TYPE_IE:
					tz::readDirectory(iePath, &current_bc[BROWSE_TYPE_IE], 0);
					setBrowserInfoOpFlag(browserid, BROWSERINFO_OP_LOCAL);
					break;
				case BROWSE_TYPE_FIREFOX:
					if(!tz::checkFirefoxDir(ff_path))
						goto ffout;
					firefox_version = tz::getFirefoxVersion();
					if(!firefox_version)
					{	
						QDir ffdir(ff_path);
						if(ffdir.exists("places.sqlite"))
							firefox_version=FIREFOX_VERSION_3;
						else if(ffdir.exists("bookmarks.html"))
							firefox_version=FIREFOX_VERSION_2;
						else 
							goto ffout;									
					}
					if(firefox_version==FIREFOX_VERSION_3){
						if(!tz::openFirefox3Db(ff_db,ff_path))
							goto ffout;									
						if(!bmXml::readFirefoxBookmark3(&ff_db,&current_bc[BROWSE_TYPE_FIREFOX]))
							goto ffout;								
					}
					setBrowserInfoOpFlag(browserid, BROWSERINFO_OP_LOCAL);
ffout:
					break;
				case BROWSE_TYPE_OPERA:
					break;
				}
				/*
				foreach(bookmark_catagory item, fromServer[browserid]->bm_list)
				{
				//QDEBUG("lastupdate item:name=%s link=%s bmid=%u",qPrintable(item.name),qPrintable(item.link),item.bmid);
				qDebug() << "httpserver item:name="<<item.name<<"link="<<item.link<<"bmid="<<item.bmid;
				}
				*/		
				//start merge
				if(browserInfo[i].lastupdate&&browserInfo[i].fromserver&&browserInfo[i].local)
				{
					/*
					if(modifiedInServer)
					bmMerge(&current_bc[browserid], &(lastUpdate[browserid]->bm_list), &(fromServer[browserid]->bm_list), &result_bc[browserid],0,iePath,browserid);
					else
					bmMergeWithoutModifyInServer(&current_bc[browserid], &(lastUpdate[browserid]->bm_list), &result_bc[browserid],0,iePath,browserid);	
					*/
					bmMergeAction(&current_bc[browserid], &(lastUpdate[browserid]->bm_list), (modifiedInServer)?&(fromServer[browserid]->bm_list):NULL,&result_bc[browserid],0,iePath,browserid);
				}					
			}
			i++;
		}
	}

#ifdef CONFIG_BOOKMARK_TODB
	if(!terminatedFlag)
	{
		QSqlQuery	q("", *db);
		db->transaction();
		uint delId=NOW_SECONDS;
		i = 0;
		while(!browserInfo[i].name.isEmpty())
		{
			int browserid = browserInfo[i].id;
			if( browserenable[i])
			{
				bmintolaunchdb(&q,&result_bc[browserid],browserid+COME_FROM_IE,delId);
			}
			i++;
		}		
		tz::clearbmgarbarge(&q, delId);
		db->commit();
		q.clear();
		tz::_clearShortcut(db,COME_FROM_BROWSER);
	}
#endif
	//write to lastupdate
	if((!QFile::exists(localBmFullPath)||(mergestatus==MERGE_STATUS_SUCCESS_WITH_MODIFY))&&!terminatedFlag){
		storeLocalbmData(localBmFullPath,browserInfo,browserenable,result_bc,lastUpdate,updateTime);
	}

	getUpdatetime(updateTime);
	//qDebug()<<"updateTime="<<updateTime<<"modifiedFlag="<<modifiedFlag;
	if(!terminatedFlag&&!updateTime.isEmpty())
		settings->setValue("updateTime", updateTime);
	setUpdatetime("");	//set null
	if(QFile::exists(localBmFullPath)){
		filemd5 = tz::fileMd5(localBmFullPath);
		settings->setValue("localbmkey",qhashEx(filemd5,filemd5.length()));
	}
	settings->sync();
CLEAR:
	i = 0;
	//clear somethings
	while(!browserInfo[i].name.isEmpty())
	{
		int browserid = browserInfo[i].id;
		if( browserenable[i])
		{
			switch( browserid )
			{
			case BROWSE_TYPE_IE:
				break;
			case BROWSE_TYPE_FIREFOX:
				tz::closeFirefox3Db(ff_db);
				break;
			case BROWSE_TYPE_OPERA:
				break;
			}			
			DELETE_OBJECT(fromServer[browserid])
		}
		DELETE_OBJECT(lastUpdate[browserid])
			result_bc[browserid].clear();
		current_bc[browserid].clear();
		clearBrowserInfoOpFlag(browserid);
		i++;
	}
	//qDebug()<<"terminatedFlag:"<<terminatedFlag;
}

int bmMerge::copyBmCatagory(bookmark_catagory * dst, bookmark_catagory * src)
{
	dst->name = src->name;
	dst->link = src->link;
	dst->desciption = src->desciption;
	dst->addDate = src->addDate;
	dst->modifyDate = src->modifyDate;
	dst->flag = src->flag;
	dst->level = src->level;
	dst->groupId = src->groupId;
	dst->parentId = src->parentId;
	dst->bmid = src->bmid;
	dst->icon=src->icon;
	dst->feedurl=src->feedurl;
	dst->last_charset=src->last_charset;
	dst->personal_toolbar_folder=src->personal_toolbar_folder;
	dst->id=src->id;
	dst->last_visit=src->last_visit;
	dst->hr=src->hr;
	return 0;
}

//list:listA---------listB
/*
1:listA has,listB has----add
2:listA has,listB hasn't 
A:listA is newer than lastUpdateTime--add
B:listA isn't newer than lastUpdateTime--delete
3:listA hasn't,listB has
A:listA is newer than lastUpdateTime--add
B:listA isn't newer than lastUpdateTime--delete
*/
/*
action:0--delete 1--add
*/
void bmMerge::postItemToHttpServer(bookmark_catagory * bc, int action, int parentId,int browserType)
{
	THREAD_MONITOR_POINT;
	QString postString;
	uint nowparentid=0;
	DELETE_OBJECT(posthp);
	posthp = new bmPost(NULL,settings,POST_HTTP_TYPE_HANDLE_ITEM);
	posthp->parentid=parentId;
	posthp->browserid=browserType;
	posthp->username = username;
	posthp->password = password;

	switch (bc->flag)
	{
	case BOOKMARK_CATAGORY_FLAG:
		if (action)	//add
		{
			bc->parentId = parentId;
			postString = QString("subject=%1&addsubmit=true&category=1&source=client").arg(QString(QUrl::toPercentEncoding(bc->name)));
			posthp->action = POST_HTTP_ACTION_ADD_DIR;
		}else{
			//delete
			postString = QString("deletesubmit=true&source=client");
			posthp->action = POST_HTTP_ACTION_DELETE_DIR;
			posthp->bmid =  bc->groupId;
		}
		posthp->postString = postString;
		posthp->start();
		posthp->wait();
		if(getPostError())
		{
			qDebug("post error happen!");
			mergestatus = MERGE_STATUS_FAIL;
			terminatedFlag = 1;
			return;
		}
		if(action)//add
		{
			nowparentid=getMaxGroupId();
			bc->groupId= nowparentid;
			bc->bmid= getBmId();
			//  foreach(bookmark_catagory bm, bc->list)
			for(int i=0;i<bc->list.size();i++)
			{
				qDebug()<<"Post to Server[add]:name:"<<bc->list.at(i).name<<" groupId:"<<bc->groupId;	
				postItemToHttpServer(&(bc->list[i]), action, nowparentid,browserType);
			}
		}

		break;
	case BOOKMARK_ITEM_FLAG:
		if (action)
		{
			//add
			bc->parentId = parentId;
			bc->groupId = 0;
			//postString = QString("address=%1&subject=%2&addsubmit=true&category=0&source=client").arg(QString(QUrl::toPercentEncoding(bc->link, ":/?"))).arg(QString(QUrl::toPercentEncoding(bc->name)));
			postString = QString("address=");
			postString.append(QString(QUrl::toPercentEncoding(bc->link, ":/?")));
			postString.append("&subject=");
			postString.append(QString(QUrl::toPercentEncoding(bc->name)));
			postString.append("&addsubmit=true&category=0&source=client");
			posthp->action = POST_HTTP_ACTION_ADD_URL;
		}else
		{
			//delete
			postString = QString("deletesubmit=true&source=client");
			posthp->action = POST_HTTP_ACTION_DELETE_URL;
		}

		posthp->bmid =  bc->bmid;
		posthp->postString = postString;
		qDebug()<<"post string:"<<postString;
		posthp->start();
		posthp->wait();
		bc->groupId= 0;
		bc->bmid= getBmId();
		if(getPostError())
		{
			qDebug("post error happen!");
			mergestatus = MERGE_STATUS_FAIL;
			terminatedFlag  = 1;
			return;
		}
		break;
	}


}
void bmMerge::deleteIdFromDb(uint id)
{
	QSqlQuery q("",ff_db);
	QString s;
	s=QString("SELECT id FROM moz_bookmarks WHERE parent=%1").arg(id);
	uint delId=0;
	if(q.exec(s)){					
		while(q.next()) { 
			delId=q.value(0).toUInt();
			deleteIdFromDb(delId);
		}
	}	
	s=QString("DELETE FROM moz_places WHERE id=(SELECT fk FROM moz_bookmarks WHERE id=%1)").arg(id);
	q.exec(s);
	s=QString("DELETE FROM  moz_bookmarks WHERE id=%1").arg(id);
	q.exec(s);
}

void bmMerge::downloadToLocal(bookmark_catagory * bc, int action, QString path,int browserType,uint local_parentId)
{
	QString dirPath;
	QString filePath;
	DWORD NumberOfBytesWritten = 0;
	QString urlContent;
	HANDLE hFile;
	//if firefox version is 2,then return directly
	if(browserType==BROWSE_TYPE_FIREFOX&&firefox_version==FIREFOX_VERSION_2)
		return;
	switch (bc->flag)
	{
	case BOOKMARK_CATAGORY_FLAG:

		switch (action)
		{
		case ACTION_ITEM_ADD:
			switch(browserType){
		case BROWSE_TYPE_IE:
			{
				dirPath = path + "\\" + bc->name;
				if (!CreateDirectory(dirPath.utf16(), NULL))
				{
					qDebug("Couldn't create new directory %s.", qPrintable(dirPath));
					return;
				}
				foreach(bookmark_catagory bm, bc->list)
				{
					downloadToLocal(&bm, action, dirPath,browserType,local_parentId);
				}
			}
			break;
		case BROWSE_TYPE_FIREFOX:
			{
				QString s;
				QSqlQuery q("",ff_db);			
				//2---directory
				s=QString("INSERT INTO moz_bookmarks(type,parent,title) VALUES(2,%1,'%2');").arg(local_parentId).arg(bc->name);
				q.exec(s);
				s=QString("select id from moz_bookmarks where title='%1' and parent=%2 and type=2 order by id desc").arg(bc->name);
				uint ownerId=0;
				if(q.exec(s)){					
					while(q.next()) { 
						ownerId=q.value(0).toUInt();
						break;
					}
				}
				foreach(bookmark_catagory bm, bc->list)
				{
					downloadToLocal(&bm, action, dirPath,browserType,ownerId);
				}						
				return;
			}
			break;
		case BROWSE_TYPE_OPERA:
			break;  
			}
			break;
		case ACTION_ITEM_DELETE:
			switch(browserType){
		case BROWSE_TYPE_IE:
			dirPath = path + "\\" + bc->name;
			if (!deleteDirectory(dirPath))
			{
				qDebug("Couldn't remove new directory %s error=%d.", qPrintable(dirPath),GetLastError());
				return;
			}
			break;
		case BROWSE_TYPE_FIREFOX:
			{
				QString s;
				QSqlQuery q("",ff_db);
				//delete from moz_places where id=(select fk from moz_bookmarks where title='sohu');
				//delete from moz_bookmarks where parent
				uint id=0;
				s=QString("select id from moz_bookmarks where parent=%1 and title='%2'").arg(local_parentId).arg(bc->name);
				if(q.exec(s)){					
					while(q.next()) { 
						id=q.value(0).toUInt();
						break;
					}
				}
				deleteIdFromDb(id);
				return;
			}
			break;
		case BROWSE_TYPE_OPERA:
			break;
			}
			break;
		}
		break;
	case BOOKMARK_ITEM_FLAG:

		switch (action)
		{
		case ACTION_ITEM_ADD:
			switch(browserType){
		case BROWSE_TYPE_IE:
			filePath = path + "\\" + bc->name + ".url";
			hFile = CreateFile(filePath.utf16(),	// open MYFILE.TXT 
				GENERIC_READ | GENERIC_WRITE,	// open for reading 
				FILE_SHARE_READ | FILE_SHARE_WRITE,	// share for reading 
				NULL,	// no security 
				CREATE_ALWAYS,	// existing file only 
				FILE_ATTRIBUTE_NORMAL,	// normal file 
				NULL);	// no attr. template 

			if (hFile == INVALID_HANDLE_VALUE)
			{
				qDebug("Could not create file %s.", qPrintable(filePath));	// process error 
				return;
			}
			urlContent = QString("[InternetShortcut]\nURL=%1\n").arg(bc->link);
			WriteFile(hFile, urlContent.toUtf8(), urlContent.count(), &NumberOfBytesWritten, NULL);
			CloseHandle(hFile);
			// setFileTime(filePath, gLastUpdateTime.toString(TIME_FORMAT), NULL, NULL, NAME_IS_FILE);
			break;
		case BROWSE_TYPE_FIREFOX:
			{
				//QString s;
				QSqlQuery q("",ff_db);
				//INSERT INTO "moz_places"(url,title) VALUES('http://www.dongua.com/');
				//INSERT INTO "moz_bookmarks"(type,fk,parent,title) VALUES(1,32,36,'ÀúÊ·');
				//s=QString("INSERT INTO moz_places(url) VALUES('")+bc->link+("')");
				q.prepare("INSERT INTO moz_places(url) VALUES(':url')");
				q.bindValue(":url",bc->link);
				bool success=q.exec();
				//qDebug()<<"query:"<<s<<" result:"<<success;
				//get fk id
				q.prepare("SELECT id FROM moz_places WHERE url=':url' ORDER BY id DESC");
				q.bindValue(":url",bc->link);
				//s=QString("SELECT id FROM moz_places WHERE url='")+bc->link+("' ORDER BY id DESC");
				success=q.exec();
				//qDebug()<<"query:"<<s<<" result:"<<success;
				uint fk_id=0;
				if(success){		
					while(q.next()) { 
						fk_id=q.value(0).toUInt();
						break;
					}
				}
				if(fk_id){
					//s=QString("INSERT INTO moz_bookmarks(type,fk,parent,title) VALUES(1,%1,%2,'%3');").arg(fk_id).arg(local_parentId).arg(bc->name);
					q.prepare("INSERT INTO moz_bookmarks(type,fk,parent,title) VALUES(1,:type,:fk,':title');");
					q.bindValue(":type",fk_id);
					q.bindValue(":fk",local_parentId);
					q.bindValue(":title",bc->name);
					success=q.exec();
					//qDebug()<<"query:"<<s<<" result:"<<success;
				}
				return;
			}
			break;
		case BROWSE_TYPE_OPERA:
			break;  
			}
			break;
		case ACTION_ITEM_DELETE:
			switch(browserType){
		case BROWSE_TYPE_IE:
			if(!QFile::remove(path + "/" + bc->name + ".url"))
			{
				qDebug()<<"Couldn't remove file "<<path + "/" + bc->name + ".url";
				return;
			}
			/*
			if (!DeleteFile(filePath.utf16()))
			{
			qDebug("Couldn't remove file %s.", qPrintable(filePath));
			return;
			}
			*/
			break;
		case BROWSE_TYPE_FIREFOX:
			{
				QString s;
				QSqlQuery q("",ff_db);
				//delete from moz_places where id=(select fk from moz_bookmarks where title='sohu');
				//delete from moz_bookmarks where parent
				s=QString("DELETE FROM moz_places WHERE id=(SELECT fk FROM moz_bookmarks WHERE parent=%1 AND title='%2')").arg(local_parentId).arg(bc->name);
				bool success=q.exec(s);
				qDebug()<<"query:"<<s<<" result:"<<success;
				q=QString("DELETE FROM moz_bookmarks WHERE parent=%1 AND title='%2' AND type=1").arg(local_parentId).arg(bc->name);
				success=q.exec(s);
				qDebug()<<"query:"<<s<<" result:"<<success;
				return;
			}
			break;
		case BROWSE_TYPE_OPERA:
			break;
			}
			break;
		}

	}
}
/*
server  lastupdate local

*/


void bmMerge::handleItem(
							 bookmark_catagory * item,
							 QList < bookmark_catagory > *list,
							 QString &path,
							 int status,
							 uint parentId,	
							 int browserType,
							 int local_parentId,
							 int localOrServer
							 )
{
	mergestatus=MERGE_STATUS_SUCCESS_WITH_MODIFY;
	switch (status)
	{
	case MERGE_STATUS_NONE:		//never exist 
		break;
	case MERGE_STATUS_LOCAL_0_LAST_0_SERVER_1:		//only exist in server,need download to local
		if(browserType==BROWSE_TYPE_FIREFOX)
		{
			item->id.append("rdf:#$");
			item->addDate=QDateTime::currentDateTime();
			productFFId(item->id,6);
		}	  	 
		qDebug()<<"Down to Local[add]:name:"<<item->name<<" local_parentId:"<<local_parentId;
		downloadToLocal(item, ACTION_ITEM_ADD, path ,browserType,local_parentId);
		list->push_back(*item);
		break;
	case MERGE_STATUS_LOCAL_0_LAST_1_SERVER_0:		//only exist in lastupdate,do nothing
		break;
	case MERGE_STATUS_LOCAL_0_LAST_1_SERVER_1:		//exist in server&lastupdate,need to delete from server
		qDebug()<<"Post to Server[delete]:name:"<<item->name;
		postItemToHttpServer(item, ACTION_ITEM_DELETE, parentId,browserType);
		break;
	case MERGE_STATUS_LOCAL_1_LAST_0_SERVER_0:		//only exist in local,need post to server
		qDebug()<<"Post to Server[add]:name="<<item->name<<" parentid:"<<parentId<<" hr:"<<item->hr;		  
		postItemToHttpServer(item, ACTION_ITEM_ADD, parentId,browserType);
		list->push_back(*item);
		break;
	case MERGE_STATUS_LOCAL_1_LAST_0_SERVER_1:		//exist in server&local,shouldn't  appear
		//just keep the local
		//	  if(localOrServer==HANDLE_ITEM_LOCAL)
		//  		list->push_back(*item);
		break;
	case MERGE_STATUS_LOCAL_1_LAST_1_SERVER_0:		//exist in local&lastupdate,need delete from local
		qDebug()<<"Down to Local[delete]:name"<<item->name<<" local_parentId:"<<local_parentId<<" path:"<<path ;
		downloadToLocal(item, ACTION_ITEM_DELETE,path,browserType,local_parentId);
		break;
	case MERGE_STATUS_LOCAL_1_LAST_1_SERVER_1:		//exist in local,lastupdate&server,do nothing
		break;
	default:
		break;
	}
}
int bmMerge::isBmEntryEqual(const bookmark_catagory& b,const bookmark_catagory& bm)
{
	settings->sync();
#ifdef QT_NO_DEBUG
#else

	if((settings->value("debugmerge",1).toUInt()&0x01)!=1)		
	{
		qDebug()<<"b:name="<<b.name<<" name_hash="<<b.name_hash<<" link="<<b.link<<" link_hash="<<b.link_hash<<" flag="<<b.flag;
		qDebug()<<"bm:name="<<bm.name<<" name_hash="<<bm.name_hash<<" link="<<bm.link<<" link_hash="<<bm.link_hash<<" flag="<<bm.flag;
	}
#endif
	if ((b.name_hash!= bm.name_hash) || (b.link_hash!= bm.link_hash) || (b.flag != bm.flag)||(b.name != bm.name) || (b.link != bm.link))
		return BM_DIFFERENT;
	else
		return BM_EQUAL;

}
int bmMerge::bmItemInList(bookmark_catagory * item, QList < bookmark_catagory > *list)
{
	if(list == NULL)
		return -1;
	int i = 0;
	for (i = 0; i < list->size(); i++)
	{
#if 1
		settings->sync();
		if((settings->value("debugmerge",1).toUInt()&0x01)!=1)		
		{
			if(list->at(i).name_hash<item->name_hash)
				continue;
			if(list->at(i).name_hash>item->name_hash)
				return -1;
		}
#endif
		if (isBmEntryEqual(*item, list->at(i)) == BM_EQUAL)
			return i;
	}
	return -1;
}
/*
server item's parentid
*/
int bmMerge::bmMergeAction(
						 QList < bookmark_catagory > *localList, 
						 QList < bookmark_catagory > *lastupdateList,
						 QList < bookmark_catagory > *serverList,
						 QList < bookmark_catagory > *resultList,
						 uint parentId,
						 QString path,
						 int browserType
						 )
{
	int status = 0;
	uint local_parentId=0;
	foreach(bookmark_catagory item, *localList)
	{
		local_parentId = item.parentId;
		break;
	}
	QList < bookmark_catagory > *list=NULL;
	if(modifiedInServer)
		list = serverList;
	else
		list = lastupdateList;

	for (int i = 0; i < localList->size(); i++)
	{
		if(terminatedFlag)
			break;
		bookmark_catagory item = (*localList)[i];
		int inLastupdatePosition = bmItemInList(&item, lastupdateList);
		int inServerPosition = -1;
		if(modifiedInServer)
			inServerPosition=bmItemInList(&item, list);
		else
			inServerPosition=inLastupdatePosition;
		status = BM_ITEM_MERGE_STATUS(1,inLastupdatePosition,inServerPosition);
		qDebug()<<__FUNCTION__<<" status="<<status<<" name:"<<item.name;
		if (status != MERGE_STATUS_LOCAL_1_LAST_1_SERVER_1&&status!=MERGE_STATUS_LOCAL_1_LAST_0_SERVER_1)
		{
			handleItem(&item, resultList,path, status, parentId,browserType,local_parentId,HANDLE_ITEM_LOCAL);
		}
		else		//exist in local,lastupdate&server,merge child
		{
			bookmark_catagory tmp;
			copyBmCatagory(&tmp, &((*list)[inServerPosition]));
			resultList->push_back(tmp);
			//when re=5,inLast=-1,use lastupdateList
			bmMergeAction(
				&(item.list), 
				(inLastupdatePosition>=0)?(&((*lastupdateList)[inLastupdatePosition].list)):(NULL), 
				&((*list)[inServerPosition].list), 
				&(resultList->last().list),
				(*list)[inServerPosition].groupId,
				path+ "/"+item.name ,
				browserType
				);
		}
	}
	if(list == NULL)
		return 1;
	foreach(bookmark_catagory item, *list)
	{
		if(terminatedFlag)
			break;
		int inLocalPosition = bmItemInList(&item, localList);		
		if(inLocalPosition>=0){
			continue;
		}
		int inLastupdatePosition = -1;
		if(modifiedInServer)
			inLastupdatePosition = bmItemInList(&item, lastupdateList);
		else
			inLastupdatePosition = 1;

		status = BM_ITEM_MERGE_STATUS(inLocalPosition,inLastupdatePosition,1);
		if (status != MERGE_STATUS_LOCAL_1_LAST_1_SERVER_1)
			handleItem(&item, resultList,path, status,  parentId,browserType,local_parentId,HANDLE_ITEM_SERVER);
	}
	return 1;
}
/*
int mergeThread::bmMergeWithoutModifyInServer(
QList < bookmark_catagory > *localList,
QList < bookmark_catagory > *lastupdateList,
QList < bookmark_catagory > *resultList,
uint parentId,
QString path,
int browserType
)
{
int status = 0;
uint local_parentId=0;
foreach(bookmark_catagory item, *localList)
{
local_parentId = item.parentId;
break;
}
for (int i = 0; i < localList->size(); i++)
{
if(terminatedFlag)
break;
bookmark_catagory item = (*localList)[i];
int inLast = bmItemInList(&item, lastupdateList);
int inServer = inLast;
status = (1 << LOCAL_EXIST_OFFSET) + (((inLast >= 0) ? 1 : 0) << LASTUPDATE_EXIST_OFFSET) + (((inServer >= 0) ? 1 : 0) << SERVER_EXIST_OFFSET);
qDebug()<<__FUNCTION__<<" status="<<status<<" name:"<<item.name;
if (status != 7&&status!=5){
handleItem(&item, resultList,path, status,  parentId,browserType,local_parentId,HANDLE_ITEM_LOCAL);
}
else		//exist in local,lastupdate&server,merge child
{
bookmark_catagory tmp;
copyBmCatagory(&tmp, &((*lastupdateList)[inLast]));
qDebug()<<__FUNCTION__<<" name="<<tmp.name<<" bmid:"<<tmp.bmid<<"groupid="<<tmp.groupId;
resultList->push_back(tmp);
bmMergeWithoutModifyInServer(
&(item.list),
&((*lastupdateList)[inLast].list),
&(resultList->last().list),
(*lastupdateList)[inLast].groupId,
path+ "/"+item.name ,
browserType
);
}
}
foreach(bookmark_catagory item, *lastupdateList)
{
if(terminatedFlag)
break;
int inLocal = bmItemInList(&item, localList);
int inLast = 1;
if(inLocal>=0){
continue;
}
status = (((inLocal >= 0) ? 1 : 0) << LOCAL_EXIST_OFFSET) + (((inLast >= 0) ? 1 : 0) << LASTUPDATE_EXIST_OFFSET) + (1 << SERVER_EXIST_OFFSET);
if (status != 7)
handleItem(&item, resultList,path, status,  parentId,browserType,local_parentId,HANDLE_ITEM_SERVER);
}
return 1;
}
*/
void bmMerge::run()
{
	THREAD_MONITOR_POINT;
	handleBmData();
	exit();
	emit done(terminatedFlag);
}
void bmMerge::productFFId(QString & randString,int length){   
	int max = length;   
	QString tmp = QString("0123456789abcdefghijklmnopqistuvwxyzABCDEFGHIJKLMNOPQRSTUVWZYZ");   
	QString str = QString();   
	QTime t;   
	t= QTime::currentTime();   
	qsrand(t.msec()+t.second()*1000);   
	for(int i=0;i<max;i++) {   
		int ir = qrand()%tmp.length();   
		if(i==(max-1))
			ir=ir%10;
		str[i] = tmp.at(ir);   
	}   
	randString.append(str);   
	return;
}

#if 0
void mergeThread::deletebmgarbarge(QSqlQuery* q,uint delId)
{
	//uint comefrom_s=0,comefrom_e=0;
	QString queryStr;
	int i = 0;
	struct browserinfo* browserInfo=tz::getbrowserInfo();
	while(!browserInfo[i].name.isEmpty())
	{
		queryStr.clear();
		queryStr=QString("delete from %1 where comeFrom=%2 and delId!=%3").arg(DB_TABLE_NAME).arg(browserInfo[i].id).arg(delId);
		q->exec(queryStr);		
		i++;
	}
	/*
	if(browserEnable.ieEnable)
	{
	queryStr.clear();
	queryStr=tr("delete from %1 where comeFrom=%2 and delId!=%3").arg(DB_TABLE_NAME).arg(COME_FROM_IE).arg(delId);
	q->exec(queryStr);		
	}
	if(browserEnable.firefoxEnable)
	{
	queryStr.clear();
	queryStr=tr("delete from %1 where comeFrom=%2 and delId!=%3").arg(DB_TABLE_NAME).arg(COME_FROM_FIREFOX).arg(delId);
	q->exec(queryStr);		
	}
	if(browserEnable.operaEnable)
	{
	queryStr.clear();
	queryStr=tr("delete from %1 where comeFrom=%2 and delId!=%3").arg(DB_TABLE_NAME).arg(COME_FROM_FIREFOX).arg(delId);
	q->exec(queryStr);		
	}
	*/

}

uint mergeThread::isExistInDb(QSqlQuery* q,const QString& name,const QString& fullpath,int frombrowsertype)
{
	QString queryStr;
	uint id=0;
#if 1
	q->prepare("select id from "DB_TABLE_NAME" where comeFrom = ? and hashId=? and shortName = ? and fullPath=? limit 1");
	int i=0;
	q->bindValue(i++, frombrowsertype);
	q->bindValue(i++, qHash(name));
	q->bindValue(i++, name);
	q->bindValue(i++, fullpath);
	q->exec();
	if(q->next())
	{
		id=q->value(q->record().indexOf("id")).toUInt();
	}
	q->clear();
#else
	queryStr=QString("select id from %1 where comeFrom=%2 and hashId=%3 and shortName='%4' and fullPath='%5' limit 1").arg(DB_TABLE_NAME).arg(frombrowsertype).arg(qHash(name)).arg(name).arg(fullpath);
	qDebug("queryStr=%s",qPrintable(queryStr));
	if(q->exec(queryStr)){
		QSqlRecord rec = q->record();

		int id_Idx = rec.indexOf("id"); // index of the field "name"
		while(q->next()) {	
			id=q->value(id_Idx).toUInt();
			q->clear();
			return id;		
		}					 	
	}else{
		qDebug("%s query error",__FUNCTION__);
	}
	q->clear();
#endif
	return id;

}

#endif 


void bmMerge::bmintolaunchdb(QSqlQuery* q,QList < bookmark_catagory > *bc,int frombrowsertype,uint delId)
{

	foreach(bookmark_catagory item, *bc)
	{
		if (item.flag == BOOKMARK_CATAGORY_FLAG)
		{
			bmintolaunchdb(q,&(item.list),frombrowsertype,delId);

		}else{
			QString queryStr="";
			uint id=0;
			if(id=tz::isExistInDb(q,item.name,item.link,frombrowsertype)){
				//queryStr=QString("update  %1 set delId=%2 where id=%3").arg(DB_TABLE_NAME).arg(delId).arg(id);

				q->prepare(QString("UPDATE %1 SET delId=:delId WHERE id=:id").arg(DBTABLEINFO_NAME(COME_FROM_BROWSER)));
				q->bindValue(":delId", delId);
				q->bindValue(":id", id);


			}				
			else
			{
				CatItem citem(item.link,item.name,frombrowsertype);
				citem.delId = delId;
#if 1
				CatItem::prepareInsertQuery(q,citem);
#else
				queryStr=QString("INSERT INTO %1 (fullPath, shortName, lowName,"
					"icon,usage,hashId,"
					"groupId, parentId, isHasPinyin,"
					"comeFrom,hanziNums,pinyinDepth,"
					"pinyinReg,alias1,alias2,shortCut,delId,args) "
					"VALUES ('%2','%3','%4','%5',%6,%7,%8,%9,%10,%11,%12,%13,'%14','%15','%16','%17',%18,'%19')").arg(DB_TABLE_NAME).arg(citem.fullPath) .arg(citem.shortName).arg(citem.lowName)
					.arg(citem.icon).arg(citem.usage).arg(qHash(item.name))
					.arg(citem.groupId).arg(citem.parentId).arg(citem.isHasPinyin)
					.arg(citem.comeFrom).arg(citem.hanziNums).arg(citem.pinyinDepth)
					.arg(citem.pinyinReg).arg(citem.alias1).arg(citem.alias2).arg(citem.shortCut).arg(delId).arg(citem.args);
#endif
			}
			//QDEBUG("%s %s",__FUNCTION__,qPrintable(queryStr));
			q->exec();
			//  q->clear();
		}		
	}

}


