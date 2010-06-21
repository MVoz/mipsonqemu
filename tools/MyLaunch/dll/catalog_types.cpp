#include "catalog_types.h"
#include <QSqlDatabase>
#include <catalog>
#include "globals.h"
#if 0
void FastCatalog::addItem(CatItem item)
{
	catList.push_back(item);
	int index = catList.count() - 1;
	CatItem *pCatItem = &catList[index];
	foreach(QChar c, item.lowName)
	{
		if (catIndex[c].count() == 0 || catIndex[c].last() != pCatItem)
			catIndex[c].push_back(pCatItem);
	}
}

int FastCatalog::getUsage(const QString & path)
{
	for (int i = 0; i < catList.size(); ++i)
	  {
		  if (path == catList[i].fullPath)
		    {
			    return catList[i].usage;
		    }
	  }
	return 0;
}

void FastCatalog::incrementUsage(const CatItem & item)
{
	for (int i = 0; i < catList.size(); ++i)
	  {
		  if (item == catList[i])
		    {
			    catList[i].usage += 1;
			    break;
		    }
	  }
}
#endif
#if 1
int SlowCatalog::getUsage(const QString & path)
{
	for (int i = 0; i < catList.size(); ++i)
	  {
		  if (path == catList[i].fullPath)
		    {
			    return catList[i].usage;
		    }
	  }
	return 0;
}

void SlowCatalog::incrementUsage(const CatItem & item)
{
	for (int i = 0; i < catList.size(); ++i)
	  {
		  if (item == catList[i])
		    {
			    catList[i].usage += 1;
			    break;
		    }
	  }
}
uint SlowCatalog::isExistInDb(CatItem &item)
{
	QSqlQuery query("",*dbs);
	QString queryStr;
	uint id=0;
	queryStr=QString("select id from %1 where hashId=%2 and fullPath='%3'").arg(DB_TABLE_NAME).arg(qHash(item.fullPath)).arg(item.fullPath);
	if(query.exec(queryStr)){
					  QSqlRecord rec = query.record();
					   
					   int id_Idx = rec.indexOf("id"); // index of the field "name"
					   while(query.next()) {	
								        id=query.value(id).toUInt();
									query.clear();
									return id;		
					 	}					 	
			}else{
				qDebug("%s query error",__FUNCTION__);
				}
	query.clear();
	return id;
	
}
void SlowCatalog::addItem(CatItem& item,int type,uint delId)
{
#if 1
			item.delId=delId;
			catList.push_back(item);
	
#else
	catList.push_back(item);
#endif
}
void SlowCatalog::clearItem()
{
	catList.clear();
}
#endif
void Catalog::pinyinMatches(QStringList& strlist,int i,int max,QString e_s,QString &txt,bool& ret)
{
		QString match_s=e_s;
		if(ret)
			return;
		if(i==max)
		{
			//qDebug("%s",qPrintable(match_s));
			ret=(match_s.contains(txt,Qt::CaseInsensitive));
			return;
		}
		QStringList sl=strlist.at(i).split("|");
		i++;
		foreach(QString s,sl){
			match_s.append(s);
			pinyinMatches(strlist,i,max,match_s,txt,ret);
			if(ret) break;
			match_s=e_s;
			}

}
void Catalog::pinyinMatchesEx(QStringList& strlist,QString &txt,bool& ret,bool CaseSensitive)
{
		QString regToken("");
		QString pinyin_token(PINYIN_TOKEN_FLAG);
		foreach(QString token,strlist){
				if(token.contains(pinyin_token))
				{
					token.remove(token.size()-pinyin_token.size(),token.size()-1);
					regToken.append("(");
					regToken.append(token);
					regToken.append(")?");
						
				}else{
					//firtst check regToken
					if(regToken.size()){
							QRegExp rx(regToken);
							//qDebug("txt=%s regToken=%s",qPrintable(txt),qPrintable(regToken));
							int res=rx.indexIn(txt);
							if(res>=0&&(rx.matchedLength()==txt.size())){
								ret=true;
								return;
							}
						}
					if(token.contains(txt, (CaseSensitive)?Qt::CaseSensitive:Qt::CaseInsensitive))
						{
							ret=true;
							return;
						}
					regToken="";
				}				
			}
		if(regToken.size()){
							qDebug()<<__FUNCTION__<<regToken;
							QRegExp rx(regToken);
							//qDebug("txt=%s regToken=%s",qPrintable(txt),qPrintable(regToken));
							int res=rx.indexIn(txt);
							if(res>=0&&(rx.matchedLength()==txt.size())){
								qDebug()<<__FUNCTION__<<" found! ";
								ret=true;
								return;
							}
			}
		return ;

}
#if 0
bool Catalog::matches(CatItem * item, QString & txt)
{
	int size = item->lowName.count();
	int txtSize = txt.count();
	int curChar = 0;
	bool fuzzyMatch=settings->value("adv/ckFuzzyMatch", false).toBool();	
	bool CaseSensitive=settings->value("adv/ckCaseSensitive", false).toBool();	
	//qDebug("fuzzyMatch=%d,CaseSensitive=%d",fuzzyMatch,CaseSensitive);
	 //Fuzzy Match
	 if(fuzzyMatch){	
			 for (int i = 0; i < size; i++)
			  {
				  if (item->lowName[i] == txt[curChar])
				    {
					    curChar++;
					    if (curChar >= txtSize)
					      {
						      return true;
					      }
				    }
		 	}
		 }else{
		 		bool ret=item->shortName.contains(txt, (CaseSensitive)?Qt::CaseSensitive:Qt::CaseInsensitive);
		 		if(ret)
					return true;
		 		if(item->isHasPinyin==HAS_PINYIN_FLAG){
						QStringList regStr=item->pinyinReg.split(BROKEN_TOKEN_STR);
						//qDebug("pinyinReg=%s shortname=%s txt=%s pinyinDepth=%u\n",qPrintable(item->pinyinReg),qPrintable(item->shortName),qPrintable(txt),item->pinyinDepth);
						if(item->hanziNums<=PINYIN_MAX_NUMBER&&item->pinyinDepth<=PINYIN_MAX_DEPTH)
							pinyinMatches(regStr,0,regStr.size(),"",txt,ret);
						else{
							pinyinMatchesEx(regStr,txt,ret,CaseSensitive);
						}
						//qDebug("pinyinReg=%s shortname=%s txt=%s ret=%d\n",qPrintable(item->pinyinReg),qPrintable(item->shortName),qPrintable(txt),ret);
						return ret;
		 			}
				return false;	 		
		 	}
				
	
	return false;
}
#endif
void Catalog::searchCatalogs(QString txt, QList < CatItem > &out)
{
	bool fuzzyMatch=settings->value("adv/ckFuzzyMatch", false).toBool();	
	bool CaseSensitive=settings->value("adv/ckCaseSensitive", false).toBool();	

	if(!fuzzyMatch&&!CaseSensitive)
		txt = txt.toLower();
	QList < CatItem * >catMatches = search(txt);
	qDebug("%s found count=%d",__FUNCTION__,catMatches.count());
	// Now prioritize the catalog items
	searchText = txt;
	qSort(catMatches.begin(), catMatches.end(), CatLess);

	// Check for history matches
	QString location = "History/" + txt;
	QStringList hist;
	hist = settings->value(location, hist).toStringList();
	if (hist.count() == 2)
	  {
		  for (int i = 0; i < catMatches.count(); i++)
		    {
			    if (catMatches[i]->lowName == hist[0] && catMatches[i]->fullPath == hist[1])
			      {
				      CatItem *tmp = catMatches[i];
				      catMatches.removeAt(i);
				      catMatches.push_front(tmp);
			      }
		    }
	  }
	// Load up the results
//	int max = settings->value("GenOps/numresults", 10).toInt();
	for (int i = 0;  i < catMatches.count(); i++)	  {
		  out.push_back(*catMatches[i]);
	  }
}


void Catalog::checkHistory(QString txt, QList < CatItem > &list)
{
	// Check for history matches
	QString location = "History/" + txt;
	QStringList hist;
	hist = settings->value(location, hist).toStringList();
	if (hist.count() == 2)
	  {
		  for (int i = 0; i < list.count(); i++)
		    {
			    if (list[i].lowName == hist[0] && list[i].fullPath == hist[1])
			      {
				      CatItem tmp = list[i];
				      list.removeAt(i);
				      list.push_front(tmp);
			      }
		    }
	  }
}


QList < CatItem * >SlowCatalog::search(QString searchTxt)
{
	QList < CatItem * >ret;
	if (searchTxt == "")
		return ret;
//      QString lowSearch = searchTxt.toLower();

	// Find the smallest char list
#if 1
		QSqlQuery	query("", *dbs);
		int i=0;
		int retry=0;
		int bookmark_retry=0;
		int numresults=settings->value("GenOps/numresults",10).toInt();
		//db.transaction();
		//QString queryStr=QString("select * from (select * from %1 order by usage desc )  where shortCut='%2' or shortName LIKE '%%3%' or fullpath LIKE '%%4%' limit %5").arg(DB_TABLE_NAME).arg(searchTxt).arg(searchTxt).arg(searchTxt).arg(numresults);
		QString queryStr=QString("select * from (select * from %1 order by usage desc )  where shortCut='%2' or shortName LIKE '%%3%'  limit %4").arg(DB_TABLE_NAME).arg(searchTxt).arg(searchTxt).arg(numresults);
RETRY:
		qDebug("queryStr=%s",qPrintable(queryStr));
		if(query.exec(queryStr)){
					   QSqlRecord rec = query.record();
					   int fullPath_Idx = rec.indexOf("fullPath"); // index of the field "name"
					   int shortName_Idx = rec.indexOf("shortName"); // index of the field "name"
					   int lowName_Idx = rec.indexOf("lowName"); // index of the field "name"
					   int icon_Idx = rec.indexOf("icon"); // index of the field "name"
					   int usage_Idx = rec.indexOf("usage"); // index of the field "name"
					   int hashId_Idx = rec.indexOf("hashId"); // index of the field "name"
					   int groupId_Idx = rec.indexOf("groupId"); // index of the field "name"
					   int parentId_Idx = rec.indexOf("parentId"); // index of the field "name"
					   int isHasPinyin_Idx = rec.indexOf("isHasPinyin"); // index of the field "name"
					   int comeFrom_Idx = rec.indexOf("comeFrom"); // index of the field "name"
					   int hanziNums_Idx = rec.indexOf("hanziNums"); // index of the field "name"
					   int pinyinDepth_Idx = rec.indexOf("pinyinDepth"); // index of the field "name"
					   int pinyinReg_Idx = rec.indexOf("pinyinReg"); // index of the field "name"
					   int alias1_Idx = rec.indexOf("alias1"); // index of the field "name"
					   int alias2_Idx = rec.indexOf("alias2"); // index of the field "name"

					 while(query.next()) {
					 			CatItem* item=&searchResults[i++];
								item->fullPath=query.value(fullPath_Idx).toString();
								item->shortName=query.value(shortName_Idx).toString();
								item->lowName=query.value(lowName_Idx).toString();
								item->icon=query.value(icon_Idx).toString();
								item->usage=query.value(usage_Idx).toUInt();
								item->hash_id=query.value(hashId_Idx).toUInt();
								item->groupId=query.value(groupId_Idx).toUInt();
								item->parentId=query.value(parentId_Idx).toUInt();
								item->isHasPinyin=(unsigned char )(query.value(isHasPinyin_Idx).toUInt());
								item->comeFrom=(unsigned char )(query.value(comeFrom_Idx).toUInt());
								item->hanziNums=(unsigned short )(query.value(hanziNums_Idx).toUInt());
								item->pinyinDepth=query.value(pinyinDepth_Idx).toUInt();
								item->pinyinReg=query.value(pinyinReg_Idx).toString();
								item->alias1=query.value(alias1_Idx).toString();
								item->alias2=query.value(alias2_Idx).toString();
								qDebug("%s",qPrintable(item->fullPath));
								ret.push_back(item);
					 	}
					  numresults-=i;
					  query.clear();
			}
/*
	//	db.commit();
		if(!retry&&numresults){	
			retry=1;
			//select * from (select * from launch_db order by usage) where shortName like '%tc%' limit 10;
			queryStr=QString("select * from (select * from %1 order by usage desc ) where shortName LIKE '%%2%' limit %3 ").arg(DB_TABLE_NAME).arg(searchTxt).arg(numresults);
			goto RETRY;
			}
//look for the bookmark address 
		if(!bookmark_retry&&numresults){	
			bookmark_retry=1;
			//select * from (select * from launch_db order by usage) where shortName like '%tc%' limit 10;
			queryStr=QString("select * from (select * from %1 order by usage desc ) where fullpath LIKE '%%2%' limit %3 ").arg(DB_TABLE_NAME).arg(searchTxt).arg(numresults);
			goto RETRY;
			}
*/
		if(numresults){
			//find from pinyin
				queryStr=QString("select * from %1 where hanziNums>0").arg(DB_TABLE_NAME);
				if(query.exec(queryStr)){
						 QSqlRecord rec = query.record();
						   int fullPath_Idx = rec.indexOf("fullPath"); // index of the field "name"
						   int shortName_Idx = rec.indexOf("shortName"); // index of the field "name"
						   int lowName_Idx = rec.indexOf("lowName"); // index of the field "name"
						   int icon_Idx = rec.indexOf("icon"); // index of the field "name"
						   int usage_Idx = rec.indexOf("usage"); // index of the field "name"
						   int hashId_Idx = rec.indexOf("hashId"); // index of the field "name"
						   int groupId_Idx = rec.indexOf("groupId"); // index of the field "name"
						   int parentId_Idx = rec.indexOf("parentId"); // index of the field "name"
						   int isHasPinyin_Idx = rec.indexOf("isHasPinyin"); // index of the field "name"
						   int comeFrom_Idx = rec.indexOf("comeFrom"); // index of the field "name"
						   int hanziNums_Idx = rec.indexOf("hanziNums"); // index of the field "name"
						   int pinyinDepth_Idx = rec.indexOf("pinyinDepth"); // index of the field "name"
						   int pinyinReg_Idx = rec.indexOf("pinyinReg"); // index of the field "name"
						   int alias1_Idx = rec.indexOf("alias1"); // index of the field "name"
						   int alias2_Idx = rec.indexOf("alias2"); // index of the field "name"
						  while(query.next()&&numresults) {
						  		QString pinyinReg=query.value(pinyinReg_Idx).toString();
								QStringList regStr=pinyinReg.split(BROKEN_TOKEN_STR);
								CatItem item;
								item.fullPath=query.value(fullPath_Idx).toString();
								item.shortName=query.value(shortName_Idx).toString();
								item.lowName=query.value(lowName_Idx).toString();
								item.icon=query.value(icon_Idx).toString();
								item.usage=query.value(usage_Idx).toUInt();
								item.hash_id=query.value(hashId_Idx).toUInt();
								item.groupId=query.value(groupId_Idx).toUInt();
								item.parentId=query.value(parentId_Idx).toUInt();
								item.isHasPinyin=(unsigned char )(query.value(isHasPinyin_Idx).toUInt());
								item.comeFrom=(unsigned char )(query.value(comeFrom_Idx).toUInt());
								item.hanziNums=(unsigned short )(query.value(hanziNums_Idx).toUInt());
								item.pinyinDepth=query.value(pinyinDepth_Idx).toUInt();
								item.pinyinReg=query.value(pinyinReg_Idx).toString();
								item.alias1=query.value(alias1_Idx).toString();
								item.alias2=query.value(alias2_Idx).toString();
								//qDebug("pinyinReg=%s shortname=%s txt=%s pinyinDepth=%u\n",qPrintable(item->pinyinReg),qPrintable(item->shortName),qPrintable(txt),item->pinyinDepth);
								bool matched=0;
								if(item.hanziNums<=PINYIN_MAX_NUMBER&&item.pinyinDepth<=PINYIN_MAX_DEPTH)
									//pinyinMatches(regStr,0,regStr.size(),"",searchTxt,matched);
									pinyinMatchesEx(regStr,searchTxt,matched,Qt::CaseInsensitive);
								else{
									pinyinMatchesEx(regStr,searchTxt,matched,Qt::CaseInsensitive);
								}
						
								if(matched){
											qDebug("pinyinReg=%s shortname=%s txt=%s ret=%d\n",qPrintable(item.pinyinReg),qPrintable(item.shortName),qPrintable(searchTxt),ret);
											CatItem* it=&searchResults[i++];
											*it=item;
											ret.push_back(it);
											numresults--;
									}
						  	}
						  	query.clear();
					}
			}
#else
	QChar leastCommon = -1;
	foreach(QChar c, searchTxt)
	{
		if (leastCommon == -1 || catIndex[c].count() < leastCommon)
			leastCommon = c;
	}

	if (catIndex[leastCommon].count() == 0)
		return ret;

	// Search the list
	for (int i = 0; i < catIndex[leastCommon].count(); ++i)
	  {
		  if (matches(catIndex[leastCommon][i], searchTxt))
		    {
			    ret.push_back(catIndex[leastCommon][i]);
		    }
	  }
#endif
	return ret;
}
#if 0
QList < CatItem * >SlowCatalog::search(QString searchTxt)
{
	QList < CatItem * >ret;
	if (searchTxt == "")
		return ret;
//	QString lowSearch = searchTxt.toLower();

	for (int i = 0; i < catList.count(); ++i)
	  {
		  if (matches(&catList[i], searchTxt))
		    {
			    ret.push_back(&catList[i]);
		    }
	  }
	return ret;
}
#endif
