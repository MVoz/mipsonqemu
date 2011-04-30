#include <catalog_types.h>
#include <catalog.h>

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
#if 0
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
#endif
/*
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
*/
void SlowCatalog::addItem(CatItem& item,int comefrom,uint delId)
{
	item.comeFrom = comefrom;
	item.delId=delId;
	catList.push_back(item);
}
void SlowCatalog::clearItem()
{
	catList.clear();
}
#endif
/*
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
*/
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
void Catalog::searchCatalogs(QString txt, QList < CatItem* > &out)
{
	bool fuzzyMatch=settings->value("adv/ckFuzzyMatch", false).toBool();	
	bool CaseSensitive=settings->value("adv/ckCaseSensitive", false).toBool();	

	if(!fuzzyMatch&&!CaseSensitive)
		txt = txt.toLower();
	out= search(txt);
	//qDebug("%s found count=%d",__FUNCTION__,out.count());
	// Now prioritize the catalog items
	//	searchText = txt;
	//qSort(out.begin(), out.end(), CatLess);

#if 0
	// Check for history matches
	QString location = "History/" + txt;
	QStringList hist;
	hist = settings->value(location, hist).toStringList();
	if (hist.count() == 2)
	{
		for (int i = 0; i < out.count(); i++)
		{
			if (out[i]->lowName == hist[0] && out[i]->fullPath == hist[1])
			{
				CatItem *tmp = out[i];
				out.removeAt(i);
				out.push_front(tmp);
			}
		}
	}
#endif
	
}


void Catalog::getHistory(QList < CatItem *> &out)
{
	QSqlQuery	q("", *db);
	uint i=0;
	uint numresults=get_search_result_num(settings);
	QString s=QString("SELECT * FROM %1  ORDER BY time DESC LIMIT %3").arg(DBTABLEINFO_NAME(COME_FROM_SHORTCUT)).arg(numresults);
	if(q.exec(s)){
		while(q.next()){
			CatItem* item=&searchResults[i++];
			item->idInTable = Q_VALUE_UINT(q,"id");
			item->fullPath=Q_VALUE_STRING(q,"fullPath");
			item->shortName=Q_VALUE_STRING(q,"shortName");
			item->lowName=Q_VALUE_STRING(q,"lowName");								
			item->usage=Q_VALUE_UINT(q,"usage");
			item->isHasPinyin=(unsigned char )(Q_VALUE_UINT(q,"isHasPinyin"));
			item->comeFrom=(unsigned char )(Q_VALUE_UINT(q,"comeFrom"));
			item->shortCut=(unsigned char )(Q_VALUE_UINT(q,"shortCut"));
			item->icon=Q_VALUE_STRING(q,"icon");
			item->alias2=Q_VALUE_STRING(q,"alias2");
			item->args=Q_VALUE_STRING(q,"args");
			out.push_back(item);
		}
		q.clear();
	}
}
void Catalog::checkHistory(QString txt, QList < CatItem *> &list)
{
	// Check for history matches
	QString location = "History/" + txt;
	QStringList hist;
	hist = settings->value(location, hist).toStringList();
	if (hist.count() == 2)
	{
		for (int i = 0; i < list.count(); i++)
		{
			if (list[i]->lowName == hist[0] && list[i]->fullPath == hist[1])
			{
				CatItem* tmp = list[i];
				list.removeAt(i);
				list.push_front(tmp);
			}
		}
	}
}
int SlowCatalog::isAllIn(const QString& src,const QString& all)
{
	int i = 0;
	for(i = 0; i < src.size();i++)
	{
		if(all.indexOf(src.at(i))==-1)
			return 0;
	}
	return 1;
}
/*
*/
bool SlowCatalog::isExistInSearchResults(int pos,QString& realname,QString& fullpath,QString& args)
{
	int i = 0;
	for(i=0; i <pos;i++){
		CatItem* item=&searchResults[i];
		if(item->realname!=realname)
			continue;
		if(item->fullPath==fullpath)
			continue;
		if(item->args==args)
			continue;
		return TRUE;
	}
	return FALSE;
}
QList < CatItem * >SlowCatalog::search(QString searchTxt)
{
	QList < CatItem * >ret;

	if (searchTxt == "")
		return ret;
	//      QString lowSearch = searchTxt.toLower();

	// Find the smallest char list
//	QTime t;
//	t.start(); 
	searchTxt.replace("'","\'");
	searchTxt.replace("\\","\\\\");
	QSqlQuery	q("", *db);
	uint i=0;
	uint numresults=get_search_result_num(settings);
	uint leftnums = numresults;
	//db.transaction();
	//QString queryStr=QString("select * from (select * from %1 order by usage desc )  where shortCut='%2' or shortName LIKE '%%3%' or fullpath LIKE '%%4%' limit %5").arg(DB_TABLE_NAME).arg(searchTxt).arg(searchTxt).arg(searchTxt).arg(numresults);
	//QString s=QString("select * from (select * from %1 order by usage desc )  where shortCut='%2' or shortName LIKE '%%3%'  limit %4").arg(DB_TABLE_NAME).arg(searchTxt).arg(searchTxt).arg(numresults);
	//QString s=QString("select * from %1  where shortCut='%2' or shortName LIKE '%%3%'  limit %4").arg(DB_TABLE_NAME).arg(searchTxt).arg(searchTxt).arg(numresults);
	QList<struct dbtableinfo*> dblist = tz::dbTableInfoList();
	QString s;
	foreach(struct dbtableinfo* info, dblist) {
		uint hanzi_flag = 0;
		uint shortName_flag = 0;
		leftnums = numresults - i;
		QStringList ids;
		if(info->id ==COME_FROM_MYBOOKMARK )
			continue;
		if(info->id == COME_FROM_SHORTCUT){
			//s=QString("SELECT * FROM %1  WHERE alias2 LIKE '%%2%'  limit %3").arg(info->name).arg(searchTxt).arg(leftnums);
			s=QString("SELECT * FROM %1  WHERE alias2 LIKE '%").arg(info->name);
			s.append(searchTxt);
			s.append("%' or shortName LIKE '%");
			s.append(searchTxt);
			s.append("%' or realname LIKE '%");
			s.append(searchTxt);
			s.append(QString("%'  limit %1").arg(leftnums));
			
		}else if(info->id >= COME_FROM_BROWSER){
			//s=QString("SELECT * FROM %1  WHERE shortCut=0 AND (shortName LIKE '%%2%' or domain LIKE '%%3%' or realname LIKE '%%4%')  limit %5").arg(info->name).arg(searchTxt).arg(searchTxt).arg(searchTxt).arg(leftnums);
			s=QString("SELECT * FROM %1  WHERE shortCut=0 AND (shortName LIKE '%").arg(info->name);
			s.append(searchTxt);
			s.append("%' or domain LIKE '%");
			s.append(searchTxt);
			s.append("%' or realname LIKE '%");
			s.append(searchTxt);
			s.append(QString("%')  limit %1").arg(leftnums));
		}else
			{
				//s=QString("SELECT * FROM %1  WHERE shortCut=0 AND (shortName LIKE '%%2%' or realname LIKE '%%3%')  limit %4").arg(info->name).arg(searchTxt).arg(searchTxt).arg(leftnums);
				s=QString("SELECT * FROM %1  WHERE shortCut=0 AND (shortName LIKE '%").arg(info->name);
				s.append(searchTxt);
				s.append("%' or realname LIKE '%");
				s.append(searchTxt);
				s.append(QString("%')  limit %1").arg(leftnums));
			}
RETRY:
		if(shortName_flag){
		  //just for COME_FROM_SHORTCUT
			if(ids.size())
				{
					//s=QString("SELECT * FROM %1  WHERE id not in (%2) AND (shortName LIKE '%%3%' or domain LIKE '%%4%' or realname LIKE '%%5%') limit %6").arg(info->name).arg(ids.join(",")).arg(searchTxt).arg(searchTxt).arg(searchTxt).arg(leftnums);
					s=QString("SELECT * FROM %1  WHERE id not in (%2) AND (shortName LIKE '%").arg(info->name).arg(ids.join(","));
					s.append(searchTxt);
					s.append("%' or domain LIKE '%");
					s.append(searchTxt);
					s.append("%' or realname LIKE '%");
					s.append(searchTxt);
					s.append(QString("%')  limit %1").arg(leftnums));
				}
			else	{
					//s=QString("SELECT * FROM %1  WHERE (shortName LIKE '%%2%' or domain LIKE '%%3%' or realname LIKE '%%4%') LIKE '%%5%'  limit %6").arg(info->name).arg(searchTxt).arg(searchTxt).arg(searchTxt).arg(leftnums);
					s=QString("SELECT * FROM %1  WHERE (shortName LIKE '%").arg(info->name);
					s.append(searchTxt);
					s.append("%' or domain LIKE '%");
					s.append(searchTxt);
					s.append("%' or realname LIKE '%");
					s.append(searchTxt);
					s.append(QString("%')  limit %1").arg(leftnums));
				}
		}
		if(hanzi_flag){
			if(info->id == COME_FROM_SHORTCUT)
			{
				if(ids.size())
					s=QString("SELECT * FROM %1 WHERE id not in (%2) AND isHasPinyin=1").arg(ids.join(",")).arg(info->name);					
				else
					s=QString("SELECT * FROM %1 WHERE isHasPinyin=1").arg(info->name);
			}
			else
			{
				if(ids.size())
					s=QString("SELECT * FROM %1 WHERE id not in (%2) AND shortCut=0 AND isHasPinyin=1").arg(ids.join(",")).arg(info->name);					
				else
					s=QString("SELECT * FROM %1 WHERE shortCut=0 AND isHasPinyin=1").arg(info->name);
			}
		}
		//qDebug()<<searchTxt<<"  "<<s;
		if(q.exec(s)){
			while(q.next()&&(numresults>i)) {	
				QString pinyinReg=Q_VALUE_STRING(q,"pinyinReg");
				QString allchars=Q_VALUE_STRING(q,"allchars");
				uint pos = 0;
				if(hanzi_flag){
					QString searchs;
					for(int m =0; m < searchTxt.length();m++)
					{
						if(searchs.indexOf(searchTxt.at(m))==-1)										
							searchs.append(searchTxt.at(m));
					}
					bool matched=0;
					if(allchars.size()<searchs.size()||!isAllIn(searchs,allchars))
						continue;								

					QStringList regStr=pinyinReg.split(BROKEN_TOKEN_STR);

					int regsize = regStr.size();
					for(int m = 0; m <regsize ; m++)
					{
						int depth=0;
						if(!(matched=pinyinsearch(regStr,regStr.size(),0,searchTxt,searchTxt.size(),depth,"")))										
							regStr.removeFirst();
						else{
							pos = regsize-regStr.size();
							break;
						}
					}

					if(!matched) continue;
				}
				//20110430 check wheather it existed in the results
				if(isExistInSearchResults(i,Q_VALUE_STRING(q,"realname"),Q_VALUE_STRING(q,"fullPath"),Q_VALUE_STRING(q,"args")))
					continue;
				CatItem* item=&searchResults[i++];
				item->idInTable = Q_VALUE_UINT(q,"id");
				ids<<QString(item->idInTable);
				item->fullPath=Q_VALUE_STRING(q,"fullPath");
				item->shortName=Q_VALUE_STRING(q,"shortName");
				item->realname=Q_VALUE_STRING(q,"realname");
				item->lowName=Q_VALUE_STRING(q,"lowName");								
				item->usage=Q_VALUE_UINT(q,"usage");
				item->isHasPinyin=(unsigned char )(Q_VALUE_UINT(q,"isHasPinyin"));
				item->comeFrom=(unsigned char )(Q_VALUE_UINT(q,"comeFrom"));
				item->shortCut=(unsigned char )(Q_VALUE_UINT(q,"shortCut"));
				//item->comeFrom = info->id;
				item->icon=Q_VALUE_STRING(q,"icon");
				item->pinyinReg=pinyinReg;
				item->allchars=allchars;
				item->alias2=Q_VALUE_STRING(q,"alias2");
				item->domain=Q_VALUE_STRING(q,"domain");
				item->type=Q_VALUE_UINT(q,"type");
				item->args=Q_VALUE_STRING(q,"args");
				item->pos = pos;
				//qDebug("%s",qPrintable(item->fullPath));
				ret.push_back(item);
			}
			q.clear();
		}

		if((numresults>i)&&!hanzi_flag)
		{
			hanzi_flag = 1;
			goto RETRY;
		}
		if((numresults>i)&&(info->id == COME_FROM_SHORTCUT)&&!shortName_flag)
		{
			shortName_flag = 1;
			goto RETRY;
		}
	}
	//qDebug("Time elapsed: %d ms", t.elapsed());
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
bool SlowCatalog::pinyinsearch(const QStringList& list,const int size,int pos,const QString& searchtxt,const int ssize,int& depth,QString suffix)
{
	if(depth < pos)
		depth=pos;
	if( (size == pos)||(ssize<=suffix.size()) )
		return false;
	QStringList sdiv =  list.at(pos).split("|") ;


	int i =0;
	for( i =0 ; i <sdiv.size(); i++ )
	{
		//	qDebug()<<pos << " :: " << depth;
		if((pos==depth)&&i>0&&(sdiv.at(i).at(0)==sdiv.at(i-1).at(0)))
			continue;

		QString t=QString(suffix).append(sdiv.at(i));
		//	int r= searchtxt.indexOf(t);
		//if(debugon)
		//qDebug()<<	searchtxt<<" : "<<t;
		if(searchtxt.startsWith(t))
		{
			if(ssize==t.size())
				return true;
			else
			{
				if(pinyinsearch(list,size,pos+1,searchtxt,ssize,depth,t))
					return true; 				
			}

		} 
	}  
	return false;
}