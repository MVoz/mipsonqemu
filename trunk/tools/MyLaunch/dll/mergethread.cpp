#include <mergethread.h>
#include <QDir>
#include <QUrl>
#include <QMessageBox>
#include "globals.h"


//uint  gMaxGroupId;
void mergeThread::handleBmData(QString& iePath,int& maxGroupId)
{
QDEBUG_LINE;
setPostError(false);
QList < bookmark_catagory > ie_bc;
QList < bookmark_catagory > firefox_bc;
QList < bookmark_catagory > opera_bc;
//from lastupdater
QString localBmFullPath;	
QString localFirefoxPlaceSqlite;
QString ff_path;
modifiedInServer=1;
//check BM_XML_FROM_SERVER
if(!QFile::exists(BM_XML_FROM_SERVER))
	return;

	QFile s_file(BM_XML_FROM_SERVER);
	if (!s_file.open(QIODevice::ReadOnly | QIODevice::Text))
		return;
	if (!s_file.atEnd()) {
		QString line = s_file.readLine();
		if (line.contains(DO_NOTHING)) {
			modifiedInServer=0;
			qDebug("no modification on server!!!");
		}else if(line.contains(LOGIN_FALIL_STRING)){
			qDebug("login failed!!!");
			((BookmarkSync*)(this->parent()))->error=LOGIN_FALIL;
			emit mgUpdateStatusNotify(UPDATESTATUS_FLAG_RETRY,LOGIN_FALIL,tz::tr(LOGIN_FALIL_STRING));
			
			s_file.close();
			return;
		}
		else
			{
				qDebug("has modification on server!!!");
			}
	}
	s_file.close();


if (getUserLocalFullpath(settings,QString(LOCAL_BM_SETTING_FILE_NAME),localBmFullPath)&&QFile::exists(localBmFullPath))
 {
// 	   QDEBUG("read %s!",qPrintable(localBmFullPath));
	  QFile lastFile;
	  lastFile.setFileName(localBmFullPath);
	  lastFile.open(QIODevice::ReadOnly);
	  ie_xmlLastUpdate = new XmlReader(&lastFile,settings);
	  ie_xmlLastUpdate->readStream(XML_FROM_LASTUPDATE,settings,BROWSER_TYPE_IE);
	  lastFile.close();

#if 1
		foreach(bookmark_catagory item, ie_xmlLastUpdate->bm_list)
	{
		//QDEBUG("lastupdate item:name=%s link=%s bmid=%u",qPrintable(item.name),qPrintable(item.link),item.bmid);
		qDebug() << "lastupdate item:name="<<item.name<<"link="<<item.link<<"bmid="<<item.bmid;
	}
	
#endif
	  
	  lastFile.setFileName(localBmFullPath);
	  lastFile.open(QIODevice::ReadOnly);
	  firefox_xmlLastUpdate = new XmlReader(&lastFile,settings);
	  firefox_xmlLastUpdate->readStream(XML_FROM_LASTUPDATE,settings,BROWSER_TYPE_FIREFOX);
	  lastFile.close();

	  
	  lastFile.setFileName(localBmFullPath);
	  lastFile.open(QIODevice::ReadOnly);
	  opera_xmlLastUpdate = new XmlReader(&lastFile,settings);
	  opera_xmlLastUpdate->readStream(XML_FROM_LASTUPDATE,settings,BROWSER_TYPE_OPERA);
	  lastFile.close();
} else{
	ie_xmlLastUpdate = new XmlReader(NULL,settings);
	firefox_xmlLastUpdate = new XmlReader(NULL,settings);
	opera_xmlLastUpdate = new XmlReader(NULL,settings);
}
/**************************************ie explore start**************************************************/
#if 1
	QString updateTime;
if(ie_enabled)
{
//from server
	if(modifiedInServer)
	{
		QFile server_file(BM_XML_FROM_SERVER);
		server_file.open(QIODevice::ReadOnly);
		ie_xmlHttpServer = new XmlReader(&server_file,settings);
		ie_xmlHttpServer->readStream(XML_FROM_HTTPSERVER,settings,BROWSER_TYPE_IE);
		setUpdatetime(ie_xmlHttpServer->updateTime);
		//qDebug()<<"Lastmodified on server is "<<updateTime;
		server_file.close();
	}

//internet explore
	ieFavReader = new XmlReader(NULL,settings);
	ieFavReader->readDirectory(iePath, &(ieFavReader->bm_list), 0, XML_FROM_IEFAV);
#if 1
		foreach(bookmark_catagory item, ieFavReader->bm_list)
	{
		qDebug("iefav item:name=%s",qPrintable(item.name));
	}
	
#endif
#if 1
	if(modifiedInServer){
			foreach(bookmark_catagory item, ie_xmlHttpServer->bm_list)
			{
				//QDEBUG("lastupdate item:name=%s link=%s bmid=%u",qPrintable(item.name),qPrintable(item.link),item.bmid);
				qDebug() << "httpserver item:name="<<item.name<<"link="<<item.link<<"bmid="<<item.bmid;
			}
	}
	
#endif
//	QDEBUG("**********Get From local IE lastupdatetime=%s*******************", qPrintable(updateTime->toString(TIME_FORMAT)));
#if 0
	//dump ie favorite to xml
	QFile ieFavXml(IE_BM_XML_FILE_NAME);
	if (!ieFavXml.open(QIODevice::WriteOnly | QIODevice::Text))
		return;
	QTextStream ie_xml_in(&ieFavXml);
	ie_xml_in.setCodec("UTF-8");
	ie_xmlHttpServer->bmListToXml(0, &(ie_xmlHttpServer->bm_list), &ie_xml_in,updateTime);
#endif	
       if(modifiedInServer)
		bmMerge(&(ieFavReader->bm_list), &(ie_xmlLastUpdate->bm_list), &(ie_xmlHttpServer->bm_list), &ie_bc, "",iePath,BROWSER_TYPE_IE);
       else
	   	bmMergeWithoutModifyInServer(&(ieFavReader->bm_list), &(ie_xmlLastUpdate->bm_list), &ie_bc, "",iePath,BROWSER_TYPE_IE);
        
}
#endif
	/**************************************ie explore end**************************************************/
	/**************************************firefox start**************************************************/
	if(firefox_enabled)
	{
	//firefox 
			QFile firefox_file("firefox.xml");
			firefox_file.open(QIODevice::ReadOnly);
			QSettings ff_reg("HKEY_LOCAL_MACHINE\\Software\\Mozilla\\Mozilla Firefox",QSettings::NativeFormat);
			qDebug("firefox's version is %s",qPrintable(ff_reg.value("CurrentVersion","").toString()));
			QString firefox_v= ff_reg.value("CurrentVersion","").toString().trimmed();

			getFirefoxPath(ff_path);
			//qDebug("ff_path=%s",qPrintable(ff_path));
			if(ff_path.isNull()||ff_path.isEmpty())
				goto OPERA;
			QDir ff_dir(ff_path);
			if(!ff_dir.exists())
				goto OPERA;
 			if(!firefox_v.isEmpty())
			{
				if(firefox_v.at(0).isDigit())
				{
					if(QString(firefox_v.at(0)).toInt()>=3)
					firefox_version=FIREFOX_VERSION_3;
					else 
					firefox_version=FIREFOX_VERSION_2;
				}
				else
					firefox_version=0;
			}
			if(!firefox_version)
				{
					
					if(QFile::exists("places.sqlite"))
						firefox_version=FIREFOX_VERSION_3;
					else if(QFile::exists("bookmarks.html"))
						firefox_version=FIREFOX_VERSION_2;
					else 
						goto OPERA;
					
				}
			if(firefox_version==FIREFOX_VERSION_3){
					ff_db = QSqlDatabase::addDatabase("QSQLITE", "dbFirefox");					
					ff_path.append("/places.sqlite");
#ifdef FIREFOX_SQLITE_UNIQUE
					ff_db.setDatabaseName(ff_path);	
					qDebug()<<"Firefox DB:"<<ff_path;
#else
					getUserLocalFullpath(settings,QString("/places.sqlite"),localFirefoxPlaceSqlite);
					if(QFile::exists(localFirefoxPlaceSqlite))
						QFile::remove(localFirefoxPlaceSqlite);
					if(!QFile::copy(ff_path,localFirefoxPlaceSqlite)) goto OPERA;
					qDebug()<<"copy firefox bookmark successfully!";
					ff_db.setDatabaseName(localFirefoxPlaceSqlite);						
#endif
			 		 if ( !ff_db.open())     
			 			   {
			 							 qDebug("connect %s failed",qPrintable(ff_path));     
			 							 goto OPERA ;
			 		 }else{ 
			 		 	 qDebug("connect database %s successfully!\n",qPrintable(ff_path));   
						 if(!testFirefoxDbLock(ff_db)){
						 	//locked						 	
							
							//QMessageBox msgBox;
							// msgBox.setText("The document has been modified.");
							// msgBox.exec();
							
							qDebug()<<"do nothing for firefox!";
							goto OPERA ;
						 	
						 }
			 		 }
						
			 			 firefoxReader = new XmlReader(&firefox_file,settings);
			 			 firefoxReader->setFirefoxDb(&ff_db);
					
			if(!firefoxReader->readFirefoxBookmark3(&(firefoxReader->bm_list)))
				goto OPERA;
			}else{
			//firefox version 2
				ff_path.append("/bookmarks.html");
				QFile ff_file(ff_path);
				ff_file.open(QIODevice::ReadOnly);
				 firefoxReader = new XmlReader(NULL,settings);
				qDebug("ff_path=%s",qPrintable(ff_path));
				if(!firefoxReader->readFirefoxBookmark2(ff_file))
				{
					ff_file.close();
					goto OPERA;
				}
				ff_file.close();
			}

	//from server
		if(modifiedInServer)
		{
			QFile server_file(BM_XML_FROM_SERVER);
			server_file.open(QIODevice::ReadOnly);
			firefox_xmlHttpServer = new XmlReader(&server_file,settings);
			firefox_xmlHttpServer->readStream(XML_FROM_HTTPSERVER,settings,BROWSER_TYPE_FIREFOX);
			//updateTime=firefox_xmlHttpServer->updateTime;
			setUpdatetime(firefox_xmlHttpServer->updateTime);
			//qDebug()<<"Lastmodified on server is "<<updateTime;
		//	if (firefox_xmlHttpServer->maxGroupId)
		//		maxGroupId = firefox_xmlHttpServer->maxGroupId + 1;
		//	else
		//		maxGroupId = PARENT_ID_START;
			server_file.close();
			
		}
#if 1
		if(modifiedInServer)
			bmMerge(&(firefoxReader->bm_list), &(firefox_xmlLastUpdate->bm_list), &(firefox_xmlHttpServer->bm_list), &firefox_bc, "",iePath,BROWSER_TYPE_FIREFOX);
		else
			bmMergeWithoutModifyInServer(&(firefoxReader->bm_list), &(firefox_xmlLastUpdate->bm_list), &firefox_bc, "",iePath,BROWSER_TYPE_FIREFOX);
#endif
		
		//qDebug("firefox:xmlLastUpdate list 's size is %d http_sever size is %d local is %d",firefox_xmlLastUpdate->bm_list.size(),firefox_xmlHttpServer->bm_list.size(),firefoxReader->bm_list.size());
		//dump to firefix bookmark when firefox version is 2
		if(firefox_version==FIREFOX_VERSION_2)
		{
			QFile ff_bm_file(ff_path);
			if (!ff_bm_file.open(QIODevice::WriteOnly | QIODevice::Text))
				return;
			QTextStream ff_bm_os(&ff_bm_file);
			ff_bm_os.setCodec("UTF-8");
			XmlReader::productFirefox2BM(0,&(firefox_bc), &ff_bm_os);
			ff_bm_file.close();
		}

		}
	/**************************************firfox end**************************************************/
	/**************************************opera start**************************************************/
OPERA:
		if(opera_enabled){
			}

	/**************************************opera end**************************************************/
#ifdef CONFIG_BOOKMARK_TODB
	if(!terminatedFlag)
	{
		QSqlQuery	query("", *db);
		db->transaction();
		uint delId=QDateTime(QDateTime::currentDateTime()).toTime_t();
		if(ie_enabled)
		   	bmintolaunchdb(&query,&ie_bc,COME_FROM_IE,delId);
		if(firefox_enabled)
			bmintolaunchdb(&query,&firefox_bc,COME_FROM_FIREFOX,delId);
		if(opera_enabled)
			bmintolaunchdb(&query,&opera_bc,COME_FROM_OPERA,delId);
		deletebmgarbarge(&query,delId);
		db->commit();
		query.clear();
	}
#endif
//write to lastupdate
	
	if(modifiedFlag&&!terminatedFlag){
		QFile localfile(localBmFullPath);
		localfile.open(QIODevice::WriteOnly| QIODevice::Truncate);
		QTextStream os(&localfile);
		os.setCodec("UTF-8");
		if(settings->value("adv/ckSupportIe",true).toBool())
			XmlReader::bmListToXml(BM_WRITE_HEADER, &ie_bc, &os,BROWSER_TYPE_IE,1,updateTime);
		else
			XmlReader::bmListToXml(BM_WRITE_HEADER, &(ie_xmlLastUpdate->bm_list), &os,BROWSER_TYPE_IE,1,updateTime);
		if(settings->value("adv/ckSupportFirefox",true).toBool())
			{
				XmlReader::bmListToXml(0, &firefox_bc, &os,BROWSER_TYPE_FIREFOX,1,updateTime);
			}
		else
			XmlReader::bmListToXml(0, &(firefox_xmlLastUpdate->bm_list), &os,BROWSER_TYPE_FIREFOX,1,updateTime);
		if(settings->value("adv/ckSupportOpera",true).toBool())
			XmlReader::bmListToXml(BM_WRITE_END, &opera_bc, &os,BROWSER_TYPE_OPERA,1,updateTime);
		else
			XmlReader::bmListToXml(BM_WRITE_END,&(opera_xmlLastUpdate->bm_list), &os,BROWSER_TYPE_OPERA,1,updateTime);
		localfile.close();
	}
	//set updatetime
	//updateTime=getUpdatetime()?getUpdatetime():updateTime;
	//if(updateTime)
//	Qstring uptime;

	getUpdatetime(updateTime);
	qDebug()<<"updateTime="<<updateTime<<"modifiedFlag="<<modifiedFlag;
	if(!terminatedFlag&&!updateTime.isEmpty())
		settings->setValue("updateTime", updateTime);
	setUpdatetime("");	//set null
//close the firefox db
	if(ie_enabled&&ieFavReader)
			delete ieFavReader;
	if(firefox_enabled){
		if(firefoxReader)
			delete firefoxReader;
#ifdef FIREFOX_SQLITE_UNIQUE
#else
		if(ff_db.isOpen())	ff_db.close();
		QSqlDatabase::removeDatabase("dbFirefox");		
	
		if(!localFirefoxPlaceSqlite.isEmpty()&&QFile::exists(localFirefoxPlaceSqlite))
		{
			if(QFile::rename(ff_path,tr("%1.%2").arg(ff_path).arg(".bak")))
			{
				if(QFile::copy(localFirefoxPlaceSqlite,ff_path))
				{
					qDebug()<<"Copy sqlite file to firefox successfully! ";
					QFile::remove(localFirefoxPlaceSqlite);
				}else{
					qDebug()<<"Copy sqlite file to firefox failed,MayBe fifefox is running!! ";
				}
			}else{
					qDebug()<<"rename sqlite file to firefox failed,MayBe fifefox is running!! ";
			}
		}
#endif
	}

}
int mergeThread::testFirefoxDbLock(QSqlDatabase& db)
{
	db.setConnectOptions(tr("QSQLITE_BUSY_TIMEOUT=%1").arg(TEST_DB_MAXINUM_TIMEOUT));
	QString queryStr=QString("select * from moz_bookmarks limit 1");
	qDebug()<<queryStr<<"\n";
	QSqlQuery   query(queryStr, db);
	if(query.exec()){
		qDebug("test firefox db successfuly!");
		db.setConnectOptions();
		return 1;
	}else{
		qDebug("test firefox db failed!");
		db.setConnectOptions();
		return 0;
	}
}

#if 0

int mergeThread::isExistInLastUpdateList(QString path, bookmark_catagory * bm)
{
	QDEBUG("%s %d path=%s link=%s", __FUNCTION__, __LINE__, qPrintable(path + "/" + bm->name), qPrintable(bm->link));
	QFile file(LOCAL_BM_SETTING_FILE_NAME);
	if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
		return 0;
	bool isRel = false;
	while (!file.atEnd())
	  {
		  QString line = file.readLine();
		  if (line.contains(path + "/" + bm->name))
		    {
			    QStringList spl = line.split(LOCAL_BM_SETTING_INTERVAL);
			    spl[1].remove("\n");
			    QDEBUG("%s %d path=%s link=%s", __FUNCTION__, __LINE__, qPrintable(spl[0]), qPrintable(spl[1]));
			    if ((spl[0] == (path + "/" + bm->name)) && (spl[1] == bm->link))
				    return 1;
		    }
	  }
	return 0;
}

//return 3 result
//BM_ADD BM_DELETE BM_EQUAL
//int BookmarkSync::findItemFromBMList(QString path,bookmark_catagory bm,QList<bookmark_catagory> *bmList,bookmark_catagory*  bx,QDateTime LastUpdateTime,int flag)
int mergeThread::findItemFromBMList(QString path, bookmark_catagory bm, QList < bookmark_catagory > *bmList, int *bx, QDateTime LastUpdateTime, int flag)
{
	int ret = 0;
	for (int i = 0; i < bmList->count(); i++)
	  {
		  *bx = i;
		  if ((ret = isBmEntryEqual(bm, (*bmList)[i])) != BM_DIFFERENT)	//find the name
			  return ret;
	  }
	//don't find the name entry
	if (LastUpdateTime.toString(TIME_FORMAT) == TIME_INIT_STR)	//first update
	  {
#ifdef CONFIG_LOG_ENABLE
		  logToFile("Client update firstly.should add ....");
#endif
		  return BM_ADD;
	  }
#ifdef CONFIG_LOG_ENABLE
	logToFile("LastUpdateTime=%s modifyDate=%s", qPrintable(LastUpdateTime.toString(TIME_FORMAT)), qPrintable(bm.modifyDate.toString(TIME_FORMAT)));
#endif

//	if local,time equal--add
//	if server ,time equal--delete

// start--- for the copy &cut url
	if (flag == MERGE_FROM_LOCAL)
	  {
		  if (isExistInLastUpdateList(path, &bm))
		    {
			    logToFile("exist in lastupdatelist");
			    return BM_DELETE;
		  } else
		    {
			    logToFile("not exist in lastupdatelist");
			    return BM_ADD;
		    }
	  }
//end--for the copy url
	if (bm.modifyDate > LastUpdateTime)
		return BM_ADD;
	else
		return BM_DELETE;
}
#endif

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
	QString postString;
	 uint nowparentid=0;
	switch (bc->flag)
	  {
	  case BOOKMARK_CATAGORY_FLAG:
	  	   posthp = new postHttp(NULL,POST_HTTP_TYPE_HANDLE_ITEM);
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
		 
		
		  posthp->parentid=parentId;
		  posthp->browserid=browserType;
		 
		  posthp->username=settings->value("Account/Username","").toString();
		  posthp->password=settings->value("Account/Userpasswd","").toString();
		  posthp->postString = postString;
		  posthp->start();
		  posthp->wait();
		   if(getPostError())
		  	{
		  		qDebug("post error happen!");
				return;
		  	}
		  if(action)//add
		  {
			  nowparentid=getMaxGroupId();
			  bc->groupId= nowparentid;
			  bc->bmid= getBmId();
			//  foreach(bookmark_catagory bm, bc->list)
			  int i=0;
			  for(i=0;i<bc->list.size();i++)
			  {
				  qDebug("Post to Server[add]:name=%s groupId=%d", qPrintable((bc->list.at(i)).name), bc->groupId);			  
				  postItemToHttpServer(&(bc->list[i]), action, nowparentid,browserType);
			  }
		  }

		  break;
	  case BOOKMARK_ITEM_FLAG:
	  	  posthp = new postHttp(NULL,POST_HTTP_TYPE_HANDLE_ITEM);
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
		 
		
		  posthp->parentid=parentId;
		  posthp->browserid=browserType;
		  posthp->bmid =  bc->bmid;
		  posthp->username=settings->value("Account/Username","").toString();
		  posthp->password=settings->value("Account/Userpasswd","").toString();
		  posthp->postString = postString;
		  posthp->start();
		  posthp->wait();
		  bc->groupId= 0;
		  bc->bmid= getBmId();
		   if(getPostError())
		  	{
		  		qDebug("post error happen!");
				return;
		  	}
		  break;
	  }


}
void mergeThread::deleteIdFromDb(uint id)
{
	QSqlQuery query("",ff_db);
	QString queryStr;
	queryStr=QString("select id from moz_bookmarks where parent=%1").arg(id);
	uint delId=0;
	if(query.exec(queryStr)){					
			while(query.next()) { 
					delId=query.value(0).toUInt();
					deleteIdFromDb(delId);
					}
		}	
	queryStr=QString("delete from moz_places where id=(select fk from moz_bookmarks where id=%1)").arg(id);
	query.exec(queryStr);
	queryStr=QString("delete from  moz_bookmarks where id=%1").arg(id);
	query.exec(queryStr);
}

void mergeThread::downloadToLocal(bookmark_catagory * bc, int action, QString path,int browserType,uint local_parentId)
{
	QString dirPath;
	QString filePath;
	DWORD NumberOfBytesWritten = 0;
	QString urlContent;
	HANDLE hFile;
	//if firefox version is 2,then return directly
	if(browserType==BROWSER_TYPE_FIREFOX&&firefox_version==FIREFOX_VERSION_2)
		return;
	switch (bc->flag)
	  {
	  case BOOKMARK_CATAGORY_FLAG:

		  switch (action)
		    {
		    case ACTION_ITEM_ADD:
			switch(browserType){
				case BROWSER_TYPE_IE:
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
				case BROWSER_TYPE_FIREFOX:
					{
							QString queryStr;
							QSqlQuery query("",ff_db);			
							//2---directory
							queryStr=QString("INSERT INTO moz_bookmarks(type,parent,title) VALUES(2,%1,'%2');").arg(local_parentId).arg(bc->name);
							query.exec(queryStr);
							queryStr=QString("select id from moz_bookmarks where title='%1' and parent=%2 and type=2 order by id desc").arg(bc->name);
							uint ownerId=0;
							if(query.exec(queryStr)){					
									while(query.next()) { 
										ownerId=query.value(0).toUInt();
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
				case BROWSER_TYPE_OPERA:
					break;  
				}
			   break;
		    case ACTION_ITEM_DELETE:
				switch(browserType){
						 case BROWSER_TYPE_IE:
						 	 dirPath = path + "\\" + bc->name;
						    if (!deleteDirectory(dirPath))
						      {
							      qDebug("Couldn't remove new directory %s error=%d.", qPrintable(dirPath),GetLastError());
							      return;
						      }
						break;
						case BROWSER_TYPE_FIREFOX:
							{
							QString queryStr;
							QSqlQuery query("",ff_db);
							//delete from moz_places where id=(select fk from moz_bookmarks where title='sohu');
							//delete from moz_bookmarks where parent
							uint id=0;
							queryStr=QString("select id from moz_bookmarks where parent=%1 and title='%2'").arg(local_parentId).arg(bc->name);
							if(query.exec(queryStr)){					
									while(query.next()) { 
										id=query.value(0).toUInt();
										break;
									}
							}
							deleteIdFromDb(id);
							return;
							}
							break;
						case BROWSER_TYPE_OPERA:
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
				case BROWSER_TYPE_IE:
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
			    case BROWSER_TYPE_FIREFOX:
					{
							QString queryStr;
							QSqlQuery query("",ff_db);
							//INSERT INTO "moz_places"(url,title) VALUES('http://www.dongua.com/');
							//INSERT INTO "moz_bookmarks"(type,fk,parent,title) VALUES(1,32,36,'ÀúÊ·');
							queryStr=QString("INSERT INTO moz_places(url) VALUES('%1')").arg(bc->link);
							bool success=query.exec(queryStr);
							qDebug("qetryStr=%s success=%d",qPrintable(queryStr),success);
							//get fk id
							queryStr=QString("select id from moz_places where url='%1' order by id desc").arg(bc->link);
							success=query.exec(queryStr);
							 qDebug("qetryStr=%s success=%d",qPrintable(queryStr),success);
							uint fk_id=0;
							if(success){		
								      qDebug("qetryStr=%s success=%d",qPrintable(queryStr),success);
									while(query.next()) { 
										fk_id=query.value(0).toUInt();
										break;
									}
							}
							if(fk_id){
							queryStr=QString("INSERT INTO moz_bookmarks(type,fk,parent,title) VALUES(1,%1,%2,'%3');").arg(fk_id).arg(local_parentId).arg(bc->name);
							success=query.exec(queryStr);
							qDebug("qetryStr=%s success=%d",qPrintable(queryStr),success);
							}
							return;
						}
				  break;
			     case BROWSER_TYPE_OPERA:
				break;  
			}
			break;
		    case ACTION_ITEM_DELETE:
				switch(browserType){
					 case BROWSER_TYPE_IE:
					      filePath = path + "\\" + bc->name + ".url";
					    if (!DeleteFile(filePath.utf16()))
					      {
						      qDebug("Couldn't remove file %s.", qPrintable(filePath));
						      return;
					      }
					    break;
					case BROWSER_TYPE_FIREFOX:
							{
							QString queryStr;
							QSqlQuery query("",ff_db);
							//delete from moz_places where id=(select fk from moz_bookmarks where title='sohu');
							//delete from moz_bookmarks where parent
							queryStr=QString("delete from moz_places where id=(select fk from moz_bookmarks where parent=%1 and title='%2')").arg(local_parentId).arg(bc->name);
							bool success=query.exec(queryStr);
							qDebug("qetryStr=%s success=%d",qPrintable(queryStr),success);
							queryStr=QString("delete from moz_bookmarks where parent=%1 and title='%2' and type=1").arg(local_parentId).arg(bc->name);
							success=query.exec(queryStr);
							qDebug("qetryStr=%s success=%d",qPrintable(queryStr),success);
							return;
							}
							break;
					case BROWSER_TYPE_OPERA:
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
void mergeThread::handleItem(bookmark_catagory * item, int ret, QString dir, uint parentId, QList < bookmark_catagory > *list,QString &iePath,int browserType,int local_parentId,int localOrServer)
{
	modifiedFlag=1;
	switch (ret)
	  {
	  case 0:		//never exist 
		  break;
	  case 1:		//only exist in server,need download to local
	  	  if(browserType==BROWSER_TYPE_FIREFOX)
	  	  	{
	  	  		item->id.append("rdf:#$");
				item->addDate=QDateTime::currentDateTime();
	  	  		productFFId(item->id,6);
	  	  	}	  	 
		  qDebug("Down to Local[add]:name=%s local_parentId=%d", qPrintable(item->name),local_parentId);
		  downloadToLocal(item, ACTION_ITEM_ADD, (dir == "") ? iePath : iePath + "/" + dir,browserType,local_parentId);
		  list->push_back(*item);
		  break;
	  case 2:		//only exist in lastupdate,do nothing
		  break;
	  case 3:		//exist in server&lastupdate,need to delete from server
		 qDebug("Post to Server[delete]:name=%s", qPrintable(item->name));
		  postItemToHttpServer(item, ACTION_ITEM_DELETE, parentId,browserType);
		  break;
	  case 4:		//only exist in local,need post to server
		  qDebug("Post to Server[add]:name=%s hr=%d", qPrintable(item->name),item->hr);		  
		  postItemToHttpServer(item, ACTION_ITEM_ADD, parentId,browserType);
		  list->push_back(*item);
		  break;
	  case 5:		//exist in server&local,shouldn't  appear
	  	  //just keep the local
	  //	  if(localOrServer==HANDLE_ITEM_LOCAL)
		//  		list->push_back(*item);
		  break;
	  case 6:		//exist in local&lastupdate,need delete from local
		  qDebug("Down to Local[delete]:name=%s local_parentId=%d path=%s", qPrintable(item->name),local_parentId,qPrintable(QString( (dir == "") ? iePath : iePath + "/" + dir)));
		  downloadToLocal(item, ACTION_ITEM_DELETE, (dir == "") ? iePath : iePath + "/" + dir,browserType,local_parentId);
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
	if((settings->value("GenOps/debugmerge",1).toUInt()&0x01)!=1)		
	{
		qDebug("b:name=%s name_hash=%u link=%s link_hash=%u flag=%d",qPrintable(b.name),b.name_hash,qPrintable(b.link),b.link_hash,b.flag);
		qDebug("bm:name=%s name_hash=%u link=%s link_hash=%u flag=%d",qPrintable(bm.name),bm.name_hash,qPrintable(bm.link),bm.link_hash,bm.flag);
	}
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
		if((settings->value("GenOps/debugmerge",1).toUInt()&0x01)!=1)		
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

int mergeThread::bmMerge(QList < bookmark_catagory > *localList, QList < bookmark_catagory > *lastupdateList, QList < bookmark_catagory > *serverList, QList < bookmark_catagory > *resultList, QString localDirName,QString& iePath,int browserType)
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
		   qDebug("%s ret=%d name=%s",__FUNCTION__,ret,qPrintable(item.name));
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
				handleItem(&item, ret, localDirName, parentId, resultList,iePath,browserType,local_parentId,HANDLE_ITEM_LOCAL);
		   	}
		  else		//exist in local,lastupdate&server,merge child
		    {
			    bookmark_catagory tmp;
			    copyBmCatagory(&tmp, &((*serverList)[inServer]));
			    qDebug("%s name=%s bmid=%u groupid=%u",__FUNCTION__,qPrintable(tmp.name),tmp.bmid,tmp.groupId);
			    resultList->push_back(tmp);
			    //when re=5,inLast=-1,use lastupdateList
			    bmMerge(&(item.list), (inLast>=0)?(&((*lastupdateList)[inLast].list)):(lastupdateList), &((*serverList)[inServer].list), &(resultList->last().list), (localDirName == "") ? iePath : iePath + "/" + localDirName,iePath,browserType);
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
			handleItem(&item, ret, localDirName, parentId, resultList,iePath,browserType,local_parentId,HANDLE_ITEM_SERVER);
	}
	return 1;
}
int mergeThread::bmMergeWithoutModifyInServer(QList < bookmark_catagory > *localList, QList < bookmark_catagory > *lastupdateList, QList < bookmark_catagory > *resultList, QString localDirName,QString& iePath,int browserType)
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
		  qDebug("%s ret=%d name=%s",__FUNCTION__,ret,qPrintable(item.name));
		  if (ret != 7&&ret!=5){
			  handleItem(&item, ret, localDirName, parentId, resultList,iePath,browserType,local_parentId,HANDLE_ITEM_LOCAL);
		  }
		  else		//exist in local,lastupdate&server,merge child
		    {
			    bookmark_catagory tmp;
			    copyBmCatagory(&tmp, &((*lastupdateList)[inLast]));
			    qDebug("%s name=%s bmid=%u groupid=%u",__FUNCTION__,qPrintable(tmp.name),tmp.bmid,tmp.groupId);
			    resultList->push_back(tmp);
			   // resultList->push_back(lastupdateList->at(inLast));
			    bmMergeWithoutModifyInServer(&(item.list), &((*lastupdateList)[inLast].list), &(resultList->last().list), (localDirName == "") ? iePath : iePath + "/" + localDirName,iePath,browserType);
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
			handleItem(&item, ret, localDirName, parentId, resultList,iePath,browserType,local_parentId,HANDLE_ITEM_SERVER);
	}
	return 1;
}
void mergeThread::run()
{
	qDebug("mergerThread running. iePath=%s.................",qPrintable(iePath));
	handleBmData(iePath,GroupId);
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
void mergeThread::prepareInsertQuery(QSqlQuery* q,CatItem& item)
{
	q->prepare("INSERT INTO "DB_TABLE_NAME
							"(fullPath, shortName, lowName,icon,usage,hashId,"
						   "groupId, parentId, isHasPinyin,comeFrom,hanziNums,pinyinDepth,"
						   "pinyinReg,alias1,alias2,shortCut,delId,args)"
						   "values("
							"? , ? , ? , ? , ? , ? ,"
							 "? , ? , ? , ? , ? , ? ,"
							  "? , ? , ? , ? , ? , ? "
						   ")");
						   q->bindValue("fullPath", item.fullPath);
						   q->bindValue("shortName", item.shortName);
						   q->bindValue("lowName", item.lowName);
						   q->bindValue("icon", item.icon);
						   q->bindValue("usage", item.usage);
						   q->bindValue("hashId", qHash(item.shortName));
						   q->bindValue("groupId", item.groupId);
						   q->bindValue("parentId", item.parentId);
						   q->bindValue("isHasPinyin", item.isHasPinyin);
						   q->bindValue("comeFrom", item.comeFrom);
						   q->bindValue("hanziNums", item.hanziNums);
						   q->bindValue("pinyinDepth", item.pinyinDepth);
						   q->bindValue("pinyinReg", item.pinyinReg);
						   q->bindValue("alias1", item.alias1);
						   q->bindValue("alias2", item.alias2);
						   q->bindValue("shortCut", item.shortCut);
						   q->bindValue("delId", item.delId);
						   q->bindValue("args", item.args
	);

}
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
				if(id=isExistInDb(q,item.name,item.link,frombrowsertype)){
					//queryStr=QString("update  %1 set delId=%2 where id=%3").arg(DB_TABLE_NAME).arg(delId).arg(id);
					q->prepare("update "DB_TABLE_NAME" set delId = ? where id= ? ");
					int i=0;
					q->bindValue(i++, delId);
					q->bindValue(i++, id);
					
				}				
				else
				{
					   CatItem citem(item.link,item.name,frombrowsertype);
#if 1
					   prepareInsertQuery(q,citem);
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
