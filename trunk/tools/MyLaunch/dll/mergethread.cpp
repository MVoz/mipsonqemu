#include <mergethread.h>
#include <QDir>
#include <QUrl>
#include <QMessageBox>
#include <globals.h>
mergeThread::mergeThread(QObject * parent ,QSqlDatabase* b,QSettings* s,QString u,QString p):QThread(parent),db(b),settings(s),username(u),password(p)
{
	file = NULL;
	//  localxmlFile = NULL;
	//  serverxmlFile = NULL;;
	//   ie_xmlLastUpdate = NULL;;
	//   firefox_xmlLastUpdate = NULL;;
	//   opera_xmlLastUpdate = NULL;;
	//   ie_xmlHttpServer = NULL;;
	//   firefox_xmlHttpServer = NULL;;
	//   opera_xmlHttpServer = NULL;;
	//	   firefoxReader = NULL;;
	posthp=NULL;

	firefox_version=0;
	modifiedFlag=0;
	terminatedFlag=0;
	//posthp = NULL;
	GetShellDir(CSIDL_FAVORITES, iePath);
}
mergeThread::~mergeThread(){	
}

void mergeThread::setRandomFileFromserver(QString& s)
{
	filename_fromserver = s;
}
bool mergeThread::checkXmlfileFromServer()
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
			((BookmarkSync*)(this->parent()))->error=LOGIN_FALIL;
			emit mgUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,LOGIN_FALIL);
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
void mergeThread::clearObject()
{
	DELETE_FILE(file);
	DELETE_OBJECT(posthp);
	if(!filename_fromserver.isEmpty()&&QFile::exists(filename_fromserver))
	{
		QFile::remove(filename_fromserver);	
	
	}
}
void mergeThread::handleBmData()
{
	THREAD_MONITOR_POINT;
	int i = 0;
	setPostError(false);

	/*for result */
	QList < bookmark_catagory > result_bc[BROWSE_TYPE_MAX];
	/*for current*/
	QList < bookmark_catagory > current_bc[BROWSE_TYPE_MAX];

	XmlReader *lastUpdate[BROWSE_TYPE_MAX]={NULL};
	XmlReader *fromServer[BROWSE_TYPE_MAX]={NULL};

	bool browserenable[BROWSE_TYPE_MAX];
	//from lastupdater
	QString localBmFullPath;	
	QString ff_path;
	QString updateTime;
	QFile f;


	modifiedInServer=1;

	if(!checkXmlfileFromServer())
		return;
	/*check localbm.dat if md5 faile ,remove it*/
	{
		getUserLocalFullpath(settings,QString(LOCAL_BM_SETTING_FILE_NAME),localBmFullPath);
		if(QFile::exists(localBmFullPath)){
			QString filemd5 =  tz::fileMd5(localBmFullPath);			
			if(qhashEx(filemd5,filemd5.length())!=settings->value("localbmkey",0).toUInt())
			{
				qDebug()<<"md5 error remove "<<localBmFullPath;
				QFile::remove(localBmFullPath);
			}
		}
	}

	struct browserinfo* browserInfo =tz::getbrowserInfo();
	//get browser enable
	i = 0;
	while(!browserInfo[i].name.isEmpty())
	{
		browserenable[i] =browserInfo[i].enable;
		i++;
	}

	{

		i = 0;
		while(!browserInfo[i].name.isEmpty())
		{
			int browserid = browserInfo[i].id;

			//lastupdate xml file whether enable or not
			if(QFile::exists(localBmFullPath))
			{
				f.setFileName(localBmFullPath);
				f.open(QIODevice::ReadOnly);						  
				lastUpdate[i] = new XmlReader(&f,settings);
				lastUpdate[i]->readStream(browserid);
				f.close();
			}else	{
				lastUpdate[i] = new XmlReader(NULL,settings);
			}
			setBrowserInfoOpFlag(browserid, BROWSERINFO_OP_LASTUPDATE);

			if( browserenable[i] )
			{
				//from server xml file

				if(QFile::exists(filename_fromserver)&&modifiedInServer)
				{

					f.setFileName(filename_fromserver);

					f.open(QIODevice::ReadOnly);
					fromServer[i] = new XmlReader(&f,settings);
					fromServer[i]->readStream(BROWSE_TYPE_IE);
					setUpdatetime(fromServer[i]->updateTime);
					f.close();
					setBrowserInfoOpFlag(browserid, BROWSERINFO_OP_FROMSERVER);
				}
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
						if(!XmlReader::readFirefoxBookmark3(&ff_db,&current_bc[BROWSE_TYPE_FIREFOX]))
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
					if(modifiedInServer)
						bmMerge(&current_bc[browserid], &(lastUpdate[browserid]->bm_list), &(fromServer[browserid]->bm_list), &result_bc[browserid], "",iePath,browserid);
					else
						bmMergeWithoutModifyInServer(&current_bc[browserid], &(lastUpdate[browserid]->bm_list), &result_bc[browserid], "",iePath,browserid);	
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
	if((!QFile::exists(localBmFullPath)||modifiedFlag)&&!terminatedFlag){
		QFile localfile(localBmFullPath);
		localfile.open(QIODevice::WriteOnly| QIODevice::Truncate);
		QTextStream os(&localfile);
		os.setCodec("UTF-8");
		i = 0;
		while(!browserInfo[i].name.isEmpty())
		{
			int browserid = browserInfo[i].id;
			XmlReader::bmListToXml(((browserid==BROWSE_TYPE_IE)?BM_WRITE_HEADER:((browserid==(BROWSE_TYPE_MAX-1))?BM_WRITE_END:0)), (browserenable[i])?(&result_bc[browserid]):&(lastUpdate[browserid]->bm_list), &os,browserid,1,updateTime);	

			i++;
		}		
		localfile.close();
		QString filemd5 = tz::fileMd5(localBmFullPath);
		settings->setValue("localbmkey",qhashEx(filemd5,filemd5.length()));
	}

	getUpdatetime(updateTime);
	qDebug()<<"updateTime="<<updateTime<<"modifiedFlag="<<modifiedFlag;
	if(!terminatedFlag&&!updateTime.isEmpty())
		settings->setValue("updateTime", updateTime);
	setUpdatetime("");	//set null

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
			delete fromServer[browserid];			
		}
		delete lastUpdate[browserid];
		result_bc[browserid].clear();
		current_bc[browserid].clear();
		clearBrowserInfoOpFlag(browserid);
		i++;
	}
	qDebug()<<"terminatedFlag:"<<terminatedFlag;
}

int mergeThread::copyBmCatagory(bookmark_catagory * dst, bookmark_catagory * src)
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
void mergeThread::postItemToHttpServer(bookmark_catagory * bc, int action, int parentId,int browserType)
{
	THREAD_MONITOR_POINT;
	QString postString;
	uint nowparentid=0;
	DELETE_OBJECT(posthp);
	posthp = new postHttp(NULL,POST_HTTP_TYPE_HANDLE_ITEM);
	posthp->parentid=parentId;
	posthp->browserid=browserType;
	posthp->username = username;
	posthp->password = password;
	//posthp->username=settings->value("Account/Username","").toString();
	//posthp->password=tz::decrypt(settings->value("Account/Userpasswd","").toString(),PASSWORD_ENCRYPT_KEY);
	//qDebug()<<__FUNCTION__<<posthp->username<<":"<<posthp->password;
	//	  connect(this->parent(),SIGNAL(posthttpTerminateNotify()),posthp,SLOT(terminateThread()));

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
	//	posthp = new postHttp(NULL,POST_HTTP_TYPE_HANDLE_ITEM);

		if (action)
		{
			//add
			bc->parentId = parentId;
			bc->groupId = 0;
			postString = QString("address=%1&subject=%2&addsubmit=true&category=0&source=client").arg(QString(QUrl::toPercentEncoding(bc->link, ":/?"))).arg(QString(QUrl::toPercentEncoding(bc->name)));	
			posthp->action = POST_HTTP_ACTION_ADD_URL;
		}else
		{
			//delete
			postString = QString("deletesubmit=true&source=client");
			posthp->action = POST_HTTP_ACTION_DELETE_URL;
		}

		posthp->bmid =  bc->bmid;

		posthp->postString = postString;
		posthp->start();
		posthp->wait();
		bc->groupId= 0;
		bc->bmid= getBmId();
		if(getPostError())
		{
			qDebug("post error happen!");
			terminatedFlag  = 1;
			return;
		}
		break;
	}


}
void mergeThread::deleteIdFromDb(uint id)
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

void mergeThread::downloadToLocal(bookmark_catagory * bc, int action, QString path,int browserType,uint local_parentId)
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

int mergeThread::bookmarkMerge(QString path, QList < bookmark_catagory > *retlist, QList < bookmark_catagory > *localBmList, QList < bookmark_catagory > *serverBmList, QString localDirName, QDateTime lastUpdateTime, int flag, int type)
{
	return 0;
}
/*
server  lastupdate local

*/
void mergeThread::handleItem(bookmark_catagory * item, int ret, QString dir, uint parentId, QList < bookmark_catagory > *list,QString &path,int browserType,int local_parentId,int localOrServer)
{
	modifiedFlag=1;
	switch (ret)
	{
	case 0:		//never exist 
		break;
	case 1:		//only exist in server,need download to local
		if(browserType==BROWSE_TYPE_FIREFOX)
		{
			item->id.append("rdf:#$");
			item->addDate=QDateTime::currentDateTime();
			productFFId(item->id,6);
		}	  	 
		qDebug()<<"Down to Local[add]:name:"<<item->name<<" local_parentId:"<<local_parentId;
		//downloadToLocal(item, ACTION_ITEM_ADD, (dir == "") ? path : path + "/" + dir,browserType,local_parentId);
		downloadToLocal(item, ACTION_ITEM_ADD, (dir == "") ? path : dir,browserType,local_parentId);
		list->push_back(*item);
		break;
	case 2:		//only exist in lastupdate,do nothing
		break;
	case 3:		//exist in server&lastupdate,need to delete from server
		qDebug()<<"Post to Server[delete]:name:"<<item->name;
		postItemToHttpServer(item, ACTION_ITEM_DELETE, parentId,browserType);
		break;
	case 4:		//only exist in local,need post to server
		qDebug()<<"Post to Server[add]:name="<<item->name<<" hr:"<<item->hr;		  
		postItemToHttpServer(item, ACTION_ITEM_ADD, parentId,browserType);
		list->push_back(*item);
		break;
	case 5:		//exist in server&local,shouldn't  appear
		//just keep the local
		//	  if(localOrServer==HANDLE_ITEM_LOCAL)
		//  		list->push_back(*item);
		break;
	case 6:		//exist in local&lastupdate,need delete from local
		qDebug()<<"Down to Local[delete]:name"<<item->name<<" local_parentId:"<<local_parentId<<" path:"<<QString( (dir == "") ? path : dir);
		downloadToLocal(item, ACTION_ITEM_DELETE, (dir == "") ? path : dir,browserType,local_parentId);
		break;
	case 7:		//exist in local,lastupdate&server,do nothing
		break;
	default:
		break;
	}
}
int mergeThread::isBmEntryEqual(const bookmark_catagory& b,const bookmark_catagory& bm)
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
int mergeThread::bmItemInList(bookmark_catagory * item, QList < bookmark_catagory > *list)
{
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

int mergeThread::bmMerge(QList < bookmark_catagory > *localList, QList < bookmark_catagory > *lastupdateList, QList < bookmark_catagory > *serverList, QList < bookmark_catagory > *resultList, QString localDirName,QString& path,int browserType)
{
	int ret = 0;
	uint parentId = 0;
	foreach(bookmark_catagory item, *serverList)
	{
		parentId = item.parentId;
		break;
	}
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
		int inServer = bmItemInList(&item, serverList);
		ret = (1 << LOCAL_EXIST_OFFSET) + (((inLast >= 0) ? 1 : 0) << LASTUPDATE_EXIST_OFFSET) + (((inServer >= 0) ? 1 : 0) << SERVER_EXIST_OFFSET);
		//qDebug()<<__FUNCTION__<<" ret="<<ret<<" name:"<<item.name;
		if (ret != 7&&ret!=5)
		{
			/*
			if(ret==5)//just exist in local&server,not in lastupdate
			{
			//handle the localbm.dat lost
			item.bmid=(*serverList)[inServer].bmid;
			item.groupId=(*serverList)[inServer].groupId;
			item.parentId=(*serverList)[inServer].parentId;
			QDEBUG("ret=5 name=%s bmid=%u groupid=%u",qPrintable(item.name),item.bmid,item.groupId);
			}
			*/
			handleItem(&item, ret, localDirName, parentId, resultList,path,browserType,local_parentId,HANDLE_ITEM_LOCAL);
		}
		else		//exist in local,lastupdate&server,merge child
		{
			bookmark_catagory tmp;
			copyBmCatagory(&tmp, &((*serverList)[inServer]));
			//qDebug()<<__FUNCTION__<<" name="<<tmp.name<<" bmid:"<<tmp.bmid<<"groupid="<<tmp.groupId;
			resultList->push_back(tmp);
			//when re=5,inLast=-1,use lastupdateList
			bmMerge(&(item.list), (inLast>=0)?(&((*lastupdateList)[inLast].list)):(lastupdateList), &((*serverList)[inServer].list), &(resultList->last().list), (localDirName == "") ? path : path + "/" + localDirName,path,browserType);
		}
	}
	foreach(bookmark_catagory item, *serverList)
	{
		if(terminatedFlag)
			break;
		int inLocal = bmItemInList(&item, localList);		
		if(inLocal>=0){
			continue;
		}
		int inLast = bmItemInList(&item, lastupdateList);
		ret = (((inLocal >= 0) ? 1 : 0) << LOCAL_EXIST_OFFSET) + (((inLast >= 0) ? 1 : 0) << LASTUPDATE_EXIST_OFFSET) + (1 << SERVER_EXIST_OFFSET);
		if (ret != 7)
			handleItem(&item, ret, localDirName, parentId, resultList,path,browserType,local_parentId,HANDLE_ITEM_SERVER);
	}
	return 1;
}
int mergeThread::bmMergeWithoutModifyInServer(QList < bookmark_catagory > *localList, QList < bookmark_catagory > *lastupdateList, QList < bookmark_catagory > *resultList, QString localDirName,QString& path,int browserType)
{
	int ret = 0;
	uint parentId = 0;
	foreach(bookmark_catagory item, *lastupdateList)
	{
		parentId = item.parentId;
		break;
	}
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
		ret = (1 << LOCAL_EXIST_OFFSET) + (((inLast >= 0) ? 1 : 0) << LASTUPDATE_EXIST_OFFSET) + (((inServer >= 0) ? 1 : 0) << SERVER_EXIST_OFFSET);
		qDebug()<<__FUNCTION__<<" ret="<<ret<<" name:"<<item.name;
		if (ret != 7&&ret!=5){
			handleItem(&item, ret, localDirName, parentId, resultList,path,browserType,local_parentId,HANDLE_ITEM_LOCAL);
		}
		else		//exist in local,lastupdate&server,merge child
		{
			bookmark_catagory tmp;
			copyBmCatagory(&tmp, &((*lastupdateList)[inLast]));
			qDebug()<<__FUNCTION__<<" name="<<tmp.name<<" bmid:"<<tmp.bmid<<"groupid="<<tmp.groupId;
			resultList->push_back(tmp);
			// resultList->push_back(lastupdateList->at(inLast));
			bmMergeWithoutModifyInServer(&(item.list), &((*lastupdateList)[inLast].list), &(resultList->last().list), (localDirName == "") ? path : path + "/" + localDirName,path,browserType);
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
		ret = (((inLocal >= 0) ? 1 : 0) << LOCAL_EXIST_OFFSET) + (((inLast >= 0) ? 1 : 0) << LASTUPDATE_EXIST_OFFSET) + (1 << SERVER_EXIST_OFFSET);
		if (ret != 7)
			handleItem(&item, ret, localDirName, parentId, resultList,path,browserType,local_parentId,HANDLE_ITEM_SERVER);
	}
	return 1;
}
void mergeThread::run()
{
	//QDEBUG_LINE;
	THREAD_MONITOR_POINT;
	handleBmData();
	exit();
	emit done(0);
}
void mergeThread::productFFId(QString & randString,int length){   
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


void mergeThread::bmintolaunchdb(QSqlQuery* q,QList < bookmark_catagory > *bc,int frombrowsertype,uint delId)
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


