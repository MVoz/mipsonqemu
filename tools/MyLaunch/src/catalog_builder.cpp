
/*
Launchy: Application Launcher
Copyright (C) 2007  Josh Karlin

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/


#include <catalog_types>
#include "catalog_builder.h"
#include <globals.h>
#include "main.h"
#include <options>
#include <QDebug>

#include <QFile>
#include <QDataStream>
#include <weby>
#include <runner>

struct predefineoncomputer{
	int csid;
	QString name;
	QString realname;
};


struct predefinedonsystem{
	QString name;
	QString realname;
	QString suffix;
} ;


CatBuilder::CatBuilder(bool fromArchive,catbuildmode mode,QSqlDatabase *dbs):
buildWithStart(fromArchive),buildMode(mode),db(dbs)
{
	cat.reset((Catalog *) new SlowCatalog(gSettings,gSearchResult,db));
	terminateflag=0;
}

void CatBuilder::run()
{
	QString dest;
	/*
	QString dest = gSettings->fileName();
	int lastSlash = dest.lastIndexOf(QLatin1Char('/'));
	if (lastSlash == -1)
	return;
	dest = dest.mid(0, lastSlash);
	dest += "/";
	dest +=DB_DATABASE_NAME;
	*/
	//getUserLocalFullpath(gSettings,QString(DB_DATABASE_NAME),dest);


	qDebug("%s buildWithStart=%d",__FUNCTION__,buildWithStart);
	//if buildWithStart is true,rescan all item
	//else
	//includedir true--include dir
	if (buildWithStart)
	{
		uint delId=NOW_SECONDS;
		buildCatalog(delId);
		STOP_FLAG_CHECK;
		storeCatalog(delId);
		STOP_FLAG_CHECK;
	}
	emit catalogFinished(1);
	return;
bad:
	this->cat->clearItem();
	indexed.clear();
	emit catalogFinished(0);
}
void CatBuilder::_clearShortcut(int type)
{
	QSqlQuery q("", *db);
	q.prepare(QString("SELECT * FROM %1 WHERE comeFrom=%2").arg(DBTABLEINFO_NAME(COME_FROM_SHORTCUT)).arg(type));
	if(q.exec()){
		QSqlQuery qq("", *db);
		while(q.next()){
			if(!tz::isExistInDb(&qq,q.value(Q_RECORD_INDEX(q,"shortName")).toString(),q.value(Q_RECORD_INDEX(q,"fullPath")).toString(),type))
			{
				qq.prepare(QString("DELETE FROM %1 WHERE id=:id").arg(DBTABLEINFO_NAME(COME_FROM_SHORTCUT)));
				qq.bindValue(":id",q.value(Q_RECORD_INDEX(q,"id")).toUInt());
				if(qq.exec())
					qq.clear();					
			}
		}
		q.clear();
	}
}
void CatBuilder::clearShortcut()
{

	switch(buildMode)
	{
	case CAT_BUILDMODE_ALL:
		_clearShortcut(CAT_BUILDMODE_DIRECTORY);
		_clearShortcut(CAT_BUILDMODE_COMMAND);
		_clearShortcut(CAT_BUILDMODE_BOOKMARK);
		break;
	case CAT_BUILDMODE_DIRECTORY:
		_clearShortcut(CAT_BUILDMODE_DIRECTORY);				
		break;
	case CAT_BUILDMODE_BOOKMARK:
		_clearShortcut(CAT_BUILDMODE_BOOKMARK);
		break;
	case CAT_BUILDMODE_COMMAND:
		_clearShortcut(CAT_BUILDMODE_COMMAND);
		break;
	}		
}
void CatBuilder::clearDb(uint delId)
{
	QSqlQuery q("", *db);
	QString s;
	switch(buildMode)
	{
	case CAT_BUILDMODE_ALL:
		s=QString("DELETE  FROM %1 WHERE delId!=%2").arg(DBTABLEINFO_NAME(COME_FROM_PROGRAM)).arg(delId);
		break;
	case CAT_BUILDMODE_DIRECTORY:
		s=QString("DELETE  FROM %1 WHERE delId!=%2").arg(DBTABLEINFO_NAME(COME_FROM_PROGRAM)).arg(delId);
		break;
	case CAT_BUILDMODE_BOOKMARK:
		//select * from `launch_db` where (comefrom between 2 and 2) and delid=1277131483;
		//queryStr=QString("delete  from %1 where (comeFrom between %2 and %3) and delId!=%4").arg(DB_TABLE_NAME).arg(COME_FROM_IE).arg(COME_FROM_OPERA).arg(delId);
		//mergeThread::deletebmgarbarge(&query,delId);
		tz::clearbmgarbarge(&q,delId);
		break;
	case CAT_BUILDMODE_COMMAND:
		s=QString("DELETE  FROM %1 WHERE  delId!=%2").arg(DBTABLEINFO_NAME(COME_FROM_COMMAND)).arg(delId);
		break;
	}

	//qDebug("s=%s",qPrintable(s));
	if(q.exec(s)){
		q.clear();
	}
	clearShortcut();
}
void CatBuilder::buildCatalog_bookmark(uint delId)
{
#if 0
	QList < CatItem > pitems;
#if 1
	//load from xml file
	QString dest ;
	if (getUserLocalFullpath(gSettings,QString(LOCAL_BM_SETTING_FILE_NAME),dest)&&QFile::exists(dest))
	{
		QFile f(dest);
		f.open(QIODevice::ReadOnly);
		XmlReader bm_xml(&f,gSettings);
		bm_xml.getCatalog(&pitems);
		f.close();
	}
	//	runner run(gSettings);
	//	run.getCatalog(&pitems);
#else
	Weby web(gSettings); 
	web.getCatalog(&pitems);
#endif

	//	plugins->getCatalogs(&pitems);
	foreach(CatItem item, pitems)
	{
		qDebug("fullpath=%s iconpath=%s useage=%d name=%s delId=%d comeFrom=%d",  qPrintable(item.fullPath), qPrintable(item.icon), item.usage,qPrintable(item.shortName),delId,item.comeFrom);
		cat->addItem(item,item.comeFrom,delId);
	}
#endif
	struct browserinfo* browserInfo =tz::getbrowserInfo();
	bool browserenable[BROWSE_TYPE_MAX];
	QList < bookmark_catagory > current_bc[BROWSE_TYPE_MAX];
	int ff_version = 0;
	QString ff_path;
	QSqlDatabase ff_db;
	int i = 0;
	while(!browserInfo[i].name.isEmpty())
	{
		browserenable[i] =browserInfo[i].enable;
		i++;
	}

	i = 0;
	while(!browserInfo[i].name.isEmpty())
	{
		int browserid = browserInfo[i].id;
		if( browserenable[i])
		{
			switch( browserid )
			{
			case BROWSE_TYPE_IE:						
				tz::readDirectory(tz::getIePath(), &current_bc[BROWSE_TYPE_IE], 0);	
				setBrowserInfoOpFlag(browserid, BROWSERINFO_OP_LOCAL);
				break;
			case BROWSE_TYPE_FIREFOX:
				if(!tz::checkFirefoxDir(ff_path))
					goto ffout;
				ff_version = tz::getFirefoxVersion();
				if(!ff_version)
				{	
					QDir ffdir(ff_path);
					if(ffdir.exists("places.sqlite"))
						ff_version=FIREFOX_VERSION_3;
					else if(ffdir.exists("bookmarks.html"))
						ff_version=FIREFOX_VERSION_2;
					else 
						goto ffout;									
				}
				if(ff_version==FIREFOX_VERSION_3){
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
		}
		i++;
	}
	QSqlQuery q("", *db);
	db->transaction();
	i = 0;
	while(!browserInfo[i].name.isEmpty())
	{
		int browserid = browserInfo[i].id;
		if( browserenable[i]&&browserInfo[i].local)
		{
			mergeThread::bmintolaunchdb(&q,&current_bc[browserid],browserid+COME_FROM_IE,delId);
		}
		i++;
	}		
	db->commit();
	q.clear();
	//clear something
	i = 0;
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
		}
		clearBrowserInfoOpFlag(browserid);
		i++;
	}

}
void CatBuilder::buildCatalog_directory(uint delId)
{
	MyWidget *main = qobject_cast < MyWidget * >(gMainWidget);
	if (main == NULL)
		return;

	if(buildWithStart)
	{
		QList < Directory > memDirs;
		int size = gSettings->beginReadArray("directories");
		for (int i = 0; i < size; ++i)
		{
			gSettings->setArrayIndex(i);
			Directory tmp;
			tmp.name = gSettings->value("name").toString();
			tmp.types = gSettings->value("types").toStringList();
			tmp.indexDirs = gSettings->value("indexDirs", false).toBool();
			tmp.indexExe = gSettings->value("indexExes", false).toBool();
			tmp.depth = gSettings->value("depth", 100).toInt();
			memDirs.append(tmp);
		}
		gSettings->endArray();

		if (memDirs.count() == 0)
		{
			memDirs = main->platform->GetInitialDirs();
			gSettings->beginWriteArray("directories");
			//write the default directory to ini
			for (int i = 0; i < memDirs.count(); ++i)
			{
				gSettings->setArrayIndex(i);				
				gSettings->setValue("name",memDirs.at(i).name);
				gSettings->setValue("types", memDirs.at(i).types);
				gSettings->setValue("indexDirs", memDirs.at(i).indexDirs);
				gSettings->setValue("indexExes", memDirs.at(i).indexExe);
				gSettings->setValue("depth", memDirs.at(i).depth);
			}
			gSettings->endArray();
			gSettings->sync();
		}
		for (int i = 0; i < memDirs.count(); ++i)
		{
			STOP_FLAG_CHECK;
			emit(catalogIncrement(100.0 * (float) (i + 1) / (float) memDirs.count()));
			QString cur = main->platform->expandEnvironmentVars(memDirs[i].name);
			qDebug()<<"scan directory "<<memDirs[i].name;
			indexDirectory(cur, memDirs[i].types, memDirs[i].indexDirs, memDirs[i].indexExe, memDirs[i].depth,COME_FROM_PROGRAM,delId);
		}
bad:
		return;
	}

}
void CatBuilder::buildCatelog_command(uint delId)
{
}

void CatBuilder::buildCatelog_define(uint delId)
{
	MyWidget *main = qobject_cast < MyWidget * >(gMainWidget);
	if (main == NULL)
		return;

	QString  dbfile= QString("%1/%2").arg(APP_DATA_PATH).arg(APP_DEFINE_DB_NAME);
	// qDebug("connect database %s successfully!!!!!!!!!!!!!",qPrintable(dbfile));  
	if(!gSettings->value("builddefine",0).toUInt()&&QFile::exists(dbfile))
	{

		{
			QSqlDatabase  d = QSqlDatabase::addDatabase("QSQLITE", APP_DEFINE_DB_NAME);
			d.setDatabaseName(dbfile);		
			if ( !d.open())	 
			{
				qDebug("connect database %s failure!\n",qPrintable(dbfile)) 	;
				return;
			} 
			else{
				qDebug("connect database %s successfully!\n",qPrintable(dbfile));  
				QSqlQuery q("",d);
				if(q.exec("SELECT * FROM defines")){
					while(q.next()) { 
						//uint comeFrom=q.value(Q_RECORD_INDEX(q,"comeFrom")).toUInt();
						QString fullpath = main->platform->expandEnvironmentVars(q.value(Q_RECORD_INDEX(q,"fullPath")).toString());
						CatItem item(
							fullpath,
							q.value(Q_RECORD_INDEX(q,"shortName")).toString(),
							q.value(Q_RECORD_INDEX(q,"args")).toString(),
							COME_FROM_PREDEFINE											
							);									
						cat->addItem(item,COME_FROM_PREDEFINE,delId);
					}
					q.clear();
				}				
				d.close();
				//add some defines need depend on programming
				int j = 0;
				struct predefineoncomputer predefineOnComputer[]={
					{CSIDL_PERSONAL,"mydocuments","My Documents"},
					{CSIDL_FAVORITES,"favorites","Favorites"},
					{CSIDL_MYMUSIC,"mymusic","My Music"},
					{CSIDL_MYPICTURES,"mypictures","My Pictures"},
					{CSIDL_MYVIDEO,"myvideos","My Videos"},
					{0,"",""}

				};
				while(predefineOnComputer[j].csid){
					QString myDocuments;
					if(GetShellDir(predefineOnComputer[j].csid, myDocuments)){
						myDocuments=QDir::fromNativeSeparators(myDocuments);
						if(!myDocuments.isEmpty()&&QFile::exists(myDocuments)){
							CatItem item(
								myDocuments,
								tz::tr(predefineOnComputer[j].name.toLatin1().data()),
								predefineOnComputer[j].realname
								);			
							cat->addItem(item,COME_FROM_PREDEFINE,delId);
						}
					}
					j++;
				}
				//add some process on system32
				struct predefinedonsystem predefinedOnSystem32[]={
					{"controlpanel","control",".exe"},
					{"taskmgr","taskmgr",".exe"},
					{"","",""}
				};

				QString system;
				j =0 ;
				if(GetShellDir(CSIDL_SYSTEM, system)&&!system.isEmpty()){			
					system=QDir::fromNativeSeparators(system);
					while(!predefinedOnSystem32[j].name.isEmpty()){
						if(QFile::exists(system+"/"+predefinedOnSystem32[j].realname+predefinedOnSystem32[j].suffix)){
							CatItem item(
								system+"/"+predefinedOnSystem32[j].realname+predefinedOnSystem32[j].suffix,
								tz::tr(predefinedOnSystem32[j].name.toLatin1().data()),
								predefinedOnSystem32[j].realname
								);			
							cat->addItem(item,COME_FROM_PREDEFINE,delId);
						}
						j++;
					}
				}

				//add all drives
				char driver;
				for(driver='A';driver<'Z';driver++)
				{
					if(QFile::exists(QString(driver)+":"))
					{
						CatItem	item(
							QString(driver)+":",
							COME_FROM_PREDEFINE							 											
							);			
						cat->addItem(item,COME_FROM_PREDEFINE,delId);
					}
				}
				gSettings->setValue("builddefine",1);

			}

		}
		QSqlDatabase::removeDatabase(APP_DEFINE_DB_NAME);
	}
}

void CatBuilder::buildCatalog(uint delId)
{
	MyWidget *main = qobject_cast < MyWidget * >(gMainWidget);
	if (main == NULL)
		return;
	switch(buildMode)
	{
	case CAT_BUILDMODE_ALL:
		buildCatalog_directory(delId);
		buildCatalog_bookmark(delId);
		buildCatelog_command(delId);
		buildCatelog_define(delId);
		break;
	case CAT_BUILDMODE_DIRECTORY:
		buildCatalog_directory(delId);
		break;
	case CAT_BUILDMODE_BOOKMARK:
		buildCatalog_bookmark(delId);
		break;
	case CAT_BUILDMODE_COMMAND:
		buildCatelog_command(delId);
		break;
	}

	emit(catalogIncrement(0.0));

}

void CatBuilder::indexDirectory(QString dir, QStringList filters, bool fdirs, bool fbin, int depth,int comeFrom,uint delId)
{
	MyWidget *main = qobject_cast < MyWidget * >(gMainWidget);
	if (!main)
		return;

	dir = QDir::toNativeSeparators(dir);
	QStringList files;
	QDir qd(dir);
	dir = qd.absolutePath();
	QStringList dirs = qd.entryList(QDir::AllDirs);
	STOP_FLAG_CHECK;
	if (depth > 0)
	{
		for (int i = 0; i < dirs.count(); ++i)
		{
			if (dirs[i].startsWith("."))
				continue;
			QString cur = dirs[i];
			if (cur.contains(".lnk"))
				continue;
			indexDirectory(dir + "/" + dirs[i], filters, fdirs, fbin, depth - 1,comeFrom,delId);
		}
	}

	if (fdirs)
	{
		for (int i = 0; i < dirs.count(); ++i)
		{
			if (dirs[i].startsWith("."))
				continue;
			if (!indexed.contains(dir + "/" + dirs[i]))
			{
				bool isShortcut = dirs[i].endsWith(".lnk", Qt::CaseInsensitive);


				CatItem item(dir + "/" + dirs[i],comeFrom, !isShortcut);
				if (curcat != NULL)
					item.usage = curcat->getUsage(item.fullPath);
				cat->addItem(item,comeFrom,delId);
				indexed[dir + "/" + dirs[i]] = true;
			}
		}
	} else
	{
		// Grab any shortcut directories 
		// This is to work around a QT weirdness that treats shortcuts to directories as actual directories
		for (int i = 0; i < dirs.count(); ++i)
		{
			if (dirs[i].startsWith("."))
				continue;
			if (dirs[i].endsWith(".lnk", Qt::CaseInsensitive))
			{
				if (!indexed.contains(dir + "/" + dirs[i]))
				{
					CatItem item(dir + "/" + dirs[i], comeFrom,true);
					if (curcat != NULL)
						item.usage = curcat->getUsage(item.fullPath);
					cat->addItem(item,comeFrom,delId);
					indexed[dir + "/" + dirs[i]] = true;
				}
			}
		}
	}



	if (fbin)
	{
		QStringList bins = qd.entryList(QDir::Files | QDir::Executable);
		for (int i = 0; i < bins.count(); ++i)
		{
			if (!indexed.contains(dir + "/" + bins[i]))
			{
				CatItem item(dir + "/" + bins[i],comeFrom);
				if (curcat != NULL)
					item.usage = curcat->getUsage(item.fullPath);
				cat->addItem(item,comeFrom,delId);
				qDebug()<<__LINE__<<"path:"<<item.fullPath<<"Name:"<<item.shortName;
				indexed[dir + "/" + bins[i]] = true;
			}
		}
	}
	// Don't want a null file filter, that matches everything..
	if (filters.count() == 0)
		return;

	files = qd.entryList(filters, QDir::Files | QDir::System, QDir::Unsorted);
	for (int i = 0; i < files.count(); ++i)
	{
		if (!indexed.contains(dir + "/" + files[i]))
		{
			if(comeFrom = COME_FROM_PROGRAM){
				QFileInfo f(dir + "/" + files[i]);
				if(f.isSymLink())
				{
					if(!QFile::exists(f.symLinkTarget()))
						continue;
				}				
			}
			CatItem item(dir + "/" + files[i],comeFrom);
			// if (curcat != NULL)
			//	    item.usage = curcat->getUsage(item.fullPath);
			main->platform->alterItem(&item);
			//    qDebug()<<__LINE__<<"path:"<<item.fullPath<<"Name:"<<item.shortName;
			cat->addItem(item,comeFrom,delId);
			indexed[dir + "/" + files[i]] = true;
		}
	}
bad:
	return;
}
#if 0
bool CatBuilder::createConnection(QSqlDatabase& db,const QString &name)
{

	db = QSqlDatabase::addDatabase("QSQLITE", "dbManage");
	db.setDatabaseName(name);        
	if ( !db.open())	 
	{
		qDebug("数据库连接失败！"); 	
		return false;
	} 
	else{
		qDebug("connect database %s successfully!\n",qPrintable(name));  
		return true;
	}
}
#endif

#if 0
bool CatBuilder::loadCatalog(QString dest)
{
#if 0
	QFile inFile(dest);
	if (!inFile.open(QIODevice::ReadOnly))
	{
		return false;
	}
#endif

#if 1
	if(!QFile::exists(dest))
	{
		qDebug("%s isn't existed",qPrintable(dest));
		return false;
	}
	else
		qDebug("%s is existed",qPrintable(dest));
#else
	QByteArray ba = inFile.readAll();
#ifdef CATALOG_COMPRESS_ENABLE
	QByteArray unzipped = qUncompress(ba);
#else
	QByteArray unzipped = ba;
#endif
	QDataStream in(&unzipped, QIODevice::ReadOnly);
	in.setVersion(QDataStream::Qt_4_2);

	while (!in.atEnd())
	{
		CatItem item;
		in >> item;
		//qDebug("shortName=%s pinyinReg=%s",qPrintable(item.shortName),qPrintable(item.pinyinReg));
		cat->addItem(item);
	}
#endif

	return true;
}
#endif
/*

void CatBuilder::produceInsetQueryStr(CatItem& item,QString& s )
{

s=QString("INSERT INTO %1 (fullPath, shortName, lowName,"
"icon,usage,hashId,"
"groupId, parentId, isHasPinyin,"
"comeFrom,hanziNums,pinyinDepth,"
"pinyinReg,alias1,alias2,shortCut,delId,args) "
"VALUES ('%2','%3','%4','%5',%6,%7,%8,%9,%10,%11,%12,%13,'%14','%15','%16','%17',%18,'%19')").arg(DB_TABLE_NAME).arg(item.fullPath) .arg(item.shortName).arg(item.lowName)
.arg(item.icon).arg(item.usage).arg(qHash(item.shortName))
.arg(item.groupId).arg(item.parentId).arg(item.isHasPinyin)
.arg(item.comeFrom).arg(item.hanziNums).arg(item.pinyinDepth)
.arg(item.pinyinReg).arg(item.alias1).arg(item.alias2).arg(item.shortCut).arg(item.delId).arg(item.args);
}

uint CatBuilder::isExistInDb(CatItem &item)
{
QSqlQuery query("",*db);
QString queryStr;
uint id=0;
queryStr=QString("select id from %1 where hashId=%2 and fullPath='%3'").arg(DB_TABLE_NAME).arg(qHash(item.shortName)).arg(item.fullPath);
if(query.exec(queryStr)){
QSqlRecord rec = query.record();

int id_Idx = rec.indexOf("id"); // index of the field "name"
while(query.next()) {	
id=query.value(id_Idx).toUInt();
query.clear();
return id;		
}					 	
}else{
qDebug("%s query error",__FUNCTION__);
}
query.clear();
return id;

}
*/
void CatBuilder::storeCatalog(uint delId)
{
#if 1

	qDebug("store count=%d",this->cat->count());
	//QString s;
	if(this->cat->count())
	{
		QSqlQuery	q("", *db);
		db->transaction();
		for (int i = 0; i < this->cat->count(); i++)
		{
			STOP_FLAG_CHECK;
			CatItem item = cat->getItem(i);
			//uint id=isExistInDb(item);
			uint id=tz::isExistInDb(&q,item.shortName,item.fullPath,item.comeFrom);
			//qDebug("%s id=%d",__FUNCTION__,id);
			if(id){
				//queryStr=QString("update  %1 set delId=%2 where id=%3").arg(DB_TABLE_NAME).arg(delId).arg(id);
				//qDebug("queryStr=%s",qPrintable(queryStr));
				//query.exec(queryStr);
				q.prepare(QString("UPDATE %1 SET delId=:delId WHERE id=:id").arg(DBTABLEINFO_NAME(item.comeFrom)));
				q.bindValue(":delId", delId);
				q.bindValue(":id", id);
			}else
			{			
				// produceInsetQueryStr(item,queryStr);
				//  qDebug("queryStr:%s",qPrintable(queryStr));				  	
				//query.exec(queryStr);
				CatItem::prepareInsertQuery(&q,item);
			}
			q.exec();
		}
		db->commit();
		q.clear();
		this->cat->clearItem();
		indexed.clear();
	}
	//}
	clearDb(delId);
	return;
#else
	QByteArray ba;
	QDataStream out(&ba, QIODevice::ReadWrite);
	out.setVersion(QDataStream::Qt_4_2);
	QDEBUG_LINE;
	for (int i = 0; i < this->cat->count(); i++)
	{
		CatItem item = cat->getItem(i);
		out << item;
	}

	// Zip the archive
	QFile file(dest);
	if (!file.open(QIODevice::WriteOnly))
	{
		//              qDebug() << "Could not open database for writing";
	}
#ifdef CATALOG_COMPRESS_ENABLE
	file.write(qCompress(ba));
#else
	file.write(ba);
#endif
#endif
bad:
	this->cat->clearItem();
	indexed.clear();
	return;
}
