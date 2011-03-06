#include <qdir.h>
#include <qfile.h>
#include <qfileinfo.h>
#include <qstringlist.h>
#include <stdio.h>
#include <QSqlDatabase>
#include <QtSql>
#include <QTime>
#include <iostream>
QString excludeId;
int outChildItem(int id,QSqlDatabase &db,QTextStream& os)
{

		QString queryStr=QString("select * from moz_bookmarks bookmarks left join moz_places places on bookmarks.fk=places.id where bookmarks.parent=%1 and bookmarks.id not in (%2);").arg(id).arg(excludeId);
		qDebug()<<queryStr<<"\n";
		QSqlQuery   query(queryStr, db);
		if(query.exec()){
					// os<<"##################################################\n";
					
					 QSqlRecord rec = query.record();
					  int idIndex = rec.indexOf("id"); // index of the field "name"
					  int typeIndex=rec.indexOf("type");
					  int urlIndex=rec.indexOf("url");
					  int titleIndex=rec.indexOf("title");
					  int parentIndex=rec.indexOf("parent");
					  while(query.next()) { 
						   if(query.value(urlIndex).toString().startsWith("place:")/*&&query.value(titleIndex).toString().isEmpty()*/)
											continue;
						    /*
							   for(int j=0;j<rec.count();j++){
								   (os)<<"|"<<query.value(j).toString();									
							   }
							  */
							 if(query.value(typeIndex).toInt()!=2){
								 if(!query.value(titleIndex).toString().isNull())
								 {
									  //os<<"<item itemId=\""<<query.value(idIndex).toString()<<"\" parentId=\""<<query.value(parentIndex).toString()<<"\">"<<"\n";
									  os<<"<item  parentId=\""<<query.value(parentIndex).toString()<<"\">"<<"\n";
									  os<<"<name><![CDATA["<<query.value(titleIndex).toString()<<"]]></name>"<<"\n";
									  os<<"<link><![CDATA["<<query.value(urlIndex).toString()<<"]]></link>"<<"\n";
									  os<<"</item>"<<"\n";
								 }
							 }
							//(os)<<"\n";
							if(query.value(typeIndex).toInt()==2)
							{
								 	os<<"<category groupId=\""<<query.value(idIndex).toString()<<"\" parentId=\""<<query.value(parentIndex).toString()<<"\">"<<"\n";
									os<<"<name><![CDATA["<<query.value(titleIndex).toString()<<"]]></name>"<<"\n";
									os<<"<link><![CDATA["<<query.value(urlIndex).toString()<<"]]></link>"<<"\n";
									outChildItem(query.value(idIndex).toInt(),db,os);
									os<<"</category>"<<"\n";
								 
							}
					  }
				
		}
		return 0;
}
/*
	bmexport.exe -t [ie|ff|op] -i  xxx -o  xxx.xml
*/


int productExcludeIdStr(QSqlDatabase &db)
{
	    QStringList excludeStr;
        excludeStr << "tags" << "unfiled"; 
		for (int i = 0; i < excludeStr.size(); ++i)
		{
			
			QString queryStr=QString("select folder_id from moz_bookmarks_roots where root_name='%1';").arg(excludeStr.at(i));
			qDebug()<<queryStr<<"\n";
			QSqlQuery   query(queryStr, db);
			if(query.exec()){
				     qDebug()<<"query success "<<db.connectionName()<<db.connectOptions();
					if(!excludeId.isEmpty()) 
						excludeId.append(",");
					while(query.next()) { 
						excludeId.append(query.value(0).toString());
					}
			}else{
				qDebug()<<query.lastError()<<db.connectionName()<<db.connectOptions();
			}
		}
		 QString exclude_moz_anno_attributes_id;
		 QStringList exclude_moz_anno_attributes_id_str;
		 exclude_moz_anno_attributes_id_str<<"Places/SmartBookmark"<<"placesInternal/READ_ONLY"<<"livemark/feedURI"<<"livemark/siteURI"
		 <<"livemark/expiration"<<"places/excludeFromBackup"<<"PlacesOrganizer/OrganizerFolder"<<"PlacesOrganizer/OrganizerQuery"<<"URIProperties/characterSet";
		for (int i = 0; i < exclude_moz_anno_attributes_id_str.size(); ++i)
		{
			
			QString queryStr=QString("select id from moz_anno_attributes where name='%1';").arg(exclude_moz_anno_attributes_id_str.at(i));
			qDebug()<<queryStr<<"\n";
			QSqlQuery   query(queryStr, db);
			if(query.exec()){
					if(!exclude_moz_anno_attributes_id.isEmpty()) 
						exclude_moz_anno_attributes_id.append(",");
					while(query.next()) { 
						exclude_moz_anno_attributes_id.append(query.value(0).toString());
					}
			}
		}
		qDebug()<<exclude_moz_anno_attributes_id<<"\n";
		
		QString queryStr=QString("select distinct item_id from moz_items_annos where anno_attribute_id in (%1);").arg(exclude_moz_anno_attributes_id);
		qDebug()<<queryStr<<"\n";
			QSqlQuery   query(queryStr, db);
			if(query.exec()){				
					while(query.next()) { 
							if(!excludeId.isEmpty()) 
						excludeId.append(",");
						excludeId.append(query.value(0).toString());
					}
			}
		qDebug()<<"xxxxxxxxxxx"<<excludeId<<"\n";
		return 0;
}
uint getIEBinPath(QString& bin)
{	
	 QSettings reg("HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\App Paths",QSettings::NativeFormat);
	 reg.beginGroup("IeXPLORE.EXE");		 
	 bin=reg.value(".").toString();
	if(!bin.isEmpty())
		return 1;
	else
		return 0;
}
int main(int argc, char* argv[])
{
	QString ie_bin;
	getIEBinPath(ie_bin);
	qDebug()<<ie_bin;
	QString type;
	QString inPath;
	QString outPath;
	QSqlDatabase db;
	if(argc!=7)
			goto usage;
	int i=0;
	for(i=1;i<argc;i++)
	{
		if(!strcmp(argv[i],"-t"))
		{
			if(argv[++i]==NULL)
				goto usage;
			else
				type=QString(argv[i]);
		}else if(!strcmp(argv[i],"-i"))
		{
			if(argv[++i]==NULL)
				goto usage;
			else
				inPath=QString(argv[i]);
		}else if(!strcmp(argv[i],"-o"))
		{
			if(argv[++i]==NULL)
				goto usage;
			else
				outPath=QString(argv[i]);
		}
		else
		{
			goto usage;
		}
	}
	qDebug("type=%s inPath=%s outPath=%s\n",qPrintable(type),qPrintable(inPath),qPrintable(outPath));
	db = QSqlDatabase::addDatabase("QSQLITE", "dbManage");
    db.setDatabaseName(inPath); 
	//db.setConnectOptions("QSQLITE_BUSY_TIMEOUT=1");
        if ( !db.open())     
            {
				 qDebug("数据库连接失败！");     
          } 
		  else{
				qDebug("connect database %s successfully!\n",qPrintable(inPath));     
			//	QSqlQuery   query("", db);
				productExcludeIdStr(db);
				bool    bsuccess = false;
				QTime    tmpTime;

				// 开始启动事务
				//db_sqlite.transaction();
				tmpTime.start();
				// bsuccess = query.exec("select * from moz_bookmarks where parent=0;");
				 QFile file(outPath);
				 file.open(QIODevice::WriteOnly | QIODevice::Text /*| QIODevice::Append*/);
				 QTextStream os(&file);
				
				 os.setCodec("UTF-8");
				 os<<"<?xml version=\"1.0\" encoding=\"utf-8\"?>"<<"\n";
				 os<<"<bookmark version=\"1.0\" updateTime=\"2009-11-22 21:36:20\">"<<"\n";
				 os<<"<browserType name=\"firefox\">"<<"\n";
				  outChildItem(0,db,os);
				 /*
				if(bsuccess){

					  QSqlRecord rec = query.record();
					  int idIndex = rec.indexOf("id"); // index of the field "name"
					  while(query.next()) { 
							   for(int j=0;j<rec.count();j++){
								   os<<"|"<<query.value(j).toString();
							   }
							os<<"\n";
							outChildItem(query.value(idIndex).toInt(),&db,&os);
							//lname = QString::fromLocal8Bit(query.value(1).toByteArray());
							//fname = QString::fromLocal8Bit(query.value(2).toByteArray());
							//dob = query.value(3).toDateTime();
							//phone = QString::fromLocal8Bit(query.value(4).toByteArray());					
						   }

				}
				*/
				os<<"</browserType>"<<"\n";
				os<<"</bookmark>"<<"\n";
				file.close();
				// 提交事务，这个时候才是真正打开文件执行SQL语句的时候
				//db_sqlite.commit(); 
			  qDebug("take %d ms time\n",tmpTime.elapsed());

		  }

	return 0;
usage:
	fprintf(stdout,"Usage : bmexport.exe -t [ie|ff|op] -i  xxx -o  xxx.xml\n");
	return 0;
}
