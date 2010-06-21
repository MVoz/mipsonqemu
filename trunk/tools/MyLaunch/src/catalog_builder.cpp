
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
CatBuilder::CatBuilder(bool fromArchive,QSqlDatabase *dbs):
 buildWithStart(fromArchive),db(dbs)
{
	//if (gSettings->value("GenOps/fastindexer", false).toBool())
	//	cat.reset((Catalog *) new FastCatalog(gSettings));
	//else
		cat.reset((Catalog *) new SlowCatalog(gSettings,gSearchResult,db));
}

void CatBuilder::run()
{
	QString dest = gSettings->fileName();
	int lastSlash = dest.lastIndexOf(QLatin1Char('/'));
	if (lastSlash == -1)
		return;
	dest = dest.mid(0, lastSlash);
	dest += "/";
	dest +=DB_DATABASE_NAME;

	qDebug("%s buildWithStart=%d",__FUNCTION__,buildWithStart);
	//if buildWithStart is true,rescan all item
	//else
	//includedir true--include dir
	if (buildWithStart)
	 {
	 	  uint delId=QDateTime(QDateTime::currentDateTime()).toTime_t();
		  qDebug("delId=%d",delId);
		  buildCatalog(delId);
		  storeCatalog(dest,delId);
		  clearDb(0,delId);
	  }
	emit catalogFinished();
}
void CatBuilder::clearDb(int type,uint delId)
{
		QSqlQuery	query("", *db);
		QString queryStr;
	//	if(buildWithStart)
	//		queryStr=QString("delete  from %1 where comefrom=%2 and delId!=%3 ").arg(DB_TABLE_NAME).arg(COME_FROM_PROGRAM).arg(delId);
	//	else
			queryStr=QString("delete  from %1 where comeFrom=%2 and delId!=%3").arg(DB_TABLE_NAME).arg(COME_FROM_PROGRAM).arg(delId);
		qDebug("queryStr=%s",qPrintable(queryStr));
		if(query.exec(queryStr)){
				query.clear();
			}
}
void CatBuilder::buildCatalog(uint delId)
{
	MyWidget *main = qobject_cast < MyWidget * >(gMainWidget);
	if (main == NULL)
		return;
	if(buildWithStart)
	{
		QList < Directory > memDirs;
		int size = gSettings->beginReadArray("dirs");
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
		  }
		for (int i = 0; i < memDirs.count(); ++i)
		  {
			  emit(catalogIncrement(100.0 * (float) (i + 1) / (float) memDirs.count()));
			  QString cur = main->platform->expandEnvironmentVars(memDirs[i].name);
			  QDEBUG("scan directory %s......",qPrintable(memDirs[i].name));
			  indexDirectory(cur, memDirs[i].types, memDirs[i].indexDirs, memDirs[i].indexExe, memDirs[i].depth,COME_FROM_PROGRAM,delId);
		  }
	}
	QList < CatItem > pitems;
#if 1
//load from xml file
	 QString dest ;
	if (getUserLocalFullpath(gSettings,QString(LOCAL_BM_SETTING_FILE_NAME),dest)&&QFile::exists(dest))
	  {
		  QFile f(dest);
		  f.open(QIODevice::ReadOnly);
		  XmlReader bm_xml(&f,gSettings);
		  //bm_xml.getCatalog(&pitems);
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
		// qDebug("fullpath=%s iconpath=%s useage=%d name=%s delId=%d comeFrom=%d",  qPrintable(item.fullPath), qPrintable(item.icon), item.usage,qPrintable(item.shortName),delId,item.comeFrom);
		 cat->addItem(item,item.comeFrom,delId);
	}

	emit(catalogIncrement(0.0));

}

void CatBuilder::indexDirectory(QString dir, QStringList filters, bool fdirs, bool fbin, int depth,int flag,uint delId)
{
	MyWidget *main = qobject_cast < MyWidget * >(gMainWidget);
	if (!main)
		return;
	dir = QDir::toNativeSeparators(dir);

	QDir qd(dir);
	dir = qd.absolutePath();
	QStringList dirs = qd.entryList(QDir::AllDirs);
	if (depth > 0)
	  {
		  for (int i = 0; i < dirs.count(); ++i)
		    {
			    if (dirs[i].startsWith("."))
				    continue;
			    QString cur = dirs[i];
			    if (cur.contains(".lnk"))
				    continue;
			    indexDirectory(dir + "/" + dirs[i], filters, fdirs, fbin, depth - 1,flag,delId);
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


				      CatItem item(dir + "/" + dirs[i],flag, !isShortcut);
				      if (curcat != NULL)
					      item.usage = curcat->getUsage(item.fullPath);
				      cat->addItem(item,flag,delId);
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
						CatItem item(dir + "/" + dirs[i], flag,true);
						if (curcat != NULL)
							item.usage = curcat->getUsage(item.fullPath);
#ifdef CONFIG_LOG_ENABLE
						//logToFile("item address 0x%08x",&item);
#endif
						cat->addItem(item,flag,delId);
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
				      CatItem item(dir + "/" + bins[i],flag);
				      if (curcat != NULL)
					      item.usage = curcat->getUsage(item.fullPath);
				      cat->addItem(item,flag,delId);
				     QDEBUG("add item:fullpath=%s shortName=%s\n",qPrintable(item.fullPath),qPrintable(item.shortName));
				      indexed[dir + "/" + bins[i]] = true;
			      }
		    }
	  }
	// Don't want a null file filter, that matches everything..
	if (filters.count() == 0)
		return;

	QStringList files = qd.entryList(filters, QDir::Files | QDir::System, QDir::Unsorted);
	for (int i = 0; i < files.count(); ++i)
	  {
		  if (!indexed.contains(dir + "/" + files[i]))
		    {
			    CatItem item(dir + "/" + files[i],flag);
			    if (curcat != NULL)
				    item.usage = curcat->getUsage(item.fullPath);
			    main->platform->alterItem(&item);
			    cat->addItem(item,flag,delId);
			    indexed[dir + "/" + files[i]] = true;
		    }
	  }
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
void CatBuilder::produceInsetQueryStr(CatItem& item,QString& s )
{

	s=QString("INSERT INTO %1 (fullPath, shortName, lowName,"
				   "icon,usage,hashId,"
				   "groupId, parentId, isHasPinyin,"
				   "comeFrom,hanziNums,pinyinDepth,"
				   "pinyinReg,alias1,alias2,shortCut,delId,args) "
				   "VALUES ('%2','%3','%4','%5',%6,%7,%8,%9,%10,%11,%12,%13,'%14','%15','%16','%17',%18,'%19')").arg(DB_TABLE_NAME).arg(item.fullPath) .arg(item.shortName).arg(item.lowName)
				   .arg(item.icon).arg(item.usage).arg(qHash(item.fullPath))
				   .arg(item.groupId).arg(item.parentId).arg(item.isHasPinyin)
				   .arg(item.comeFrom).arg(item.hanziNums).arg(item.pinyinDepth)
				   .arg(item.pinyinReg).arg(item.alias1).arg(item.alias2).arg(item.shortCut).arg(item.delId).arg(item.args);
}
uint CatBuilder::isExistInDb(CatItem &item)
{
	QSqlQuery query("",*db);
	QString queryStr;
	uint id=0;
	queryStr=QString("select id from %1 where hashId=%2 and fullPath='%3'").arg(DB_TABLE_NAME).arg(qHash(item.fullPath)).arg(item.fullPath);
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

void CatBuilder::storeCatalog(QString dest,uint delId)
{
#if 1

		qDebug("count=%d",this->cat->count());
		QString queryStr;
		if(this->cat->count())
		{
			QSqlQuery	query("", *db);
			db->transaction();
			for (int i = 0; i < this->cat->count(); i++)
		  	{
				  CatItem item = cat->getItem(i);
				  uint id=isExistInDb(item);
				  if(id){
					queryStr=QString("update  %1 set delId=%2 where id=%3").arg(DB_TABLE_NAME).arg(delId).arg(id);
					//qDebug("queryStr=%s",qPrintable(queryStr));
					query.exec(queryStr);
				  }else
				  {			
				 	 produceInsetQueryStr(item,queryStr);
					  qDebug("queryStr:%s",qPrintable(queryStr));				  	
					query.exec(queryStr);
				  }
		  	}
			db->commit();
			query.clear();
			this->cat->clearItem();
		}
//}

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
}
