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

#include "catalog.h"
#include "globals.h"
#include <qdebug.h>

#include <QtAlgorithms>
//QString searchTxt;
#define INIT_CATITEM_PART  do{\
			lowName = shortName.toLower();\
			getPinyinReg(shortName);\
			time = 0;\
			usage = 0;\
			hash_id = qHash(shortName);\
			alias2="";\
			shortCut=0;\
			delId=0;\
			args="";\
			idInTable=0;\
			pos = 0;\
			realname="";\
			if(IS_FROM_BROWSER(flag)){\
				if(fullPath.startsWith("http",Qt::CaseInsensitive)||fullPath.startsWith("https",Qt::CaseInsensitive)){\
						QUrl url(fullPath);\
						if(url.isValid()){\
							QString site = url.host();\
							icon = QString("%1/%2.ico").arg(FAVICO_DIRECTORY).arg(qhashEx(site,site.length()));\
						}\
					}\
			}\
		}while(0);

CatItem::CatItem(QString full,int flag,bool isDir ) : fullPath(full),comeFrom(flag) {
			int last = fullPath.lastIndexOf("/");
			if (last == -1) {
				shortName = fullPath;

			} else {
				shortName = fullPath.mid(last+1);
				if (!isDir)
					shortName = shortName.mid(0,shortName.lastIndexOf("."));
			}
			INIT_CATITEM_PART;
			
			if( comeFrom == COME_FROM_PROGRAM){
				QFileInfo f(full);
				QFileInfo realfile ;
				if(f.exists()){
					//qDebug()<<"fileName :"<<f.fileName()<<" filePath: "<<f.filePath()<<" isSymLink"<<f.isSymLink();
					if(f.isSymLink())
						{
							//qDebug()<<"symLinkTarget:"<<f.symLinkTarget();
							args=tz::GetShortcutTarget(full);
							realfile = QFileInfo(f.symLinkTarget());	
							if(realfile.exists())
							{
								fullPath =realfile.absoluteFilePath();
								realname = realfile.fileName();
							}
						}					
				}
			}
			

			
}
/*
	just for defined catitem
*/
CatItem::CatItem(const QString& full,  const QString& shortN,const QString& realName):fullPath(full), shortName(shortN),realname(realName)
{
			int flag = COME_FROM_PREDEFINE;
			INIT_CATITEM_PART;
			comeFrom = COME_FROM_PREDEFINE;
			realname = realName;			
}

CatItem::CatItem(QString full, QString shortN,int flag): fullPath(full), shortName(shortN),comeFrom(flag)
{
		INIT_CATITEM_PART;		
}
CatItem::CatItem(QString full, QString shortN, uint i_d,int flag)  :  fullPath(full), shortName(shortN), hash_id(i_d),comeFrom(flag)
{
		INIT_CATITEM_PART;
		hash_id = i_d;
}
CatItem::CatItem(QString full, QString shortN,QString arg, int flag)  :  fullPath(full), shortName(shortN), args(arg),comeFrom(flag)
{
		INIT_CATITEM_PART;
		args = arg;	
}
CatItem::CatItem(QString full, QString shortN, uint i_d, QString iconPath,int flag)  : fullPath(full), shortName(shortN), icon(iconPath), hash_id(i_d),comeFrom(flag)
{
		INIT_CATITEM_PART;
		icon = iconPath;
		hash_id = i_d;

}
CatItem::CatItem(QString full, QString shortN,QString arg, uint i_d, QString iconPath,int flag) : fullPath(full), shortName(shortN),args(arg), icon(iconPath), hash_id(i_d),comeFrom(flag)
{
		INIT_CATITEM_PART;
		args = arg;
		icon = iconPath;
		hash_id = i_d;
}

CatItem::CatItem(const CatItem &s) {
		COPY_CATITEM(s);
}
void CatItem:: getPinyinReg(const QString& str){
	isHasPinyin=NO_PINYIN_FLAG;
	if(str.size()==0)
		return;
	if(str.toLocal8Bit().length()==str.size())
		return;
	//hanziNums=str.toLocal8Bit().length()-str.size();
	QStringList  shengmo;
	shengmo<<"sh"<<"zh"<<"ch";

	QStringList src_list = str.split(QRegExp("\\s+"));
	foreach (QString s_s, src_list) {
			if(s_s.toLocal8Bit().length()==s_s.size())	{
					pinyinReg.append(s_s+" ");
					continue;
			}
		
			 for(int i=0;i<s_s.size();i++)
			{
				QString strUnit=QString(s_s.at(i));
				if(strUnit.toLocal8Bit().length()==strUnit.size()){
						pinyinReg.append(strUnit);	
						continue;
					}
				QString  r=tz::getPinyin(strUnit.toUtf8());	
				if(r != QString(strUnit.toUtf8()))
				{
					isHasPinyin=HAS_PINYIN_FLAG;
					if(pinyinReg.size()>0&&!pinyinReg.endsWith(BROKEN_TOKEN_STR))
							pinyinReg.append(BROKEN_TOKEN_STR);

					QStringList list2 = r.split(" ", QString::SkipEmptyParts);	
					
					QStringList singlePinyinreg;
					for(int i=0;i<list2.size();i++)
					{
						singlePinyinreg<<QString(list2.at(i).at(0));
						//start check shengmo
						for(int j=0;j<shengmo.size();j++)
						{
							if(list2.at(i).startsWith (shengmo.at(j),Qt::CaseInsensitive))
							{
								singlePinyinreg<<shengmo.at(j);
								break;
							}
						}
						//end check shengmo
						if(list2.at(i).size()>1)
								singlePinyinreg<<list2.at(i);		
					}

					//clear the same string
					for(int i=0;i<singlePinyinreg.size();i++){
						for(int j=i+1;j<singlePinyinreg.size();)
							{
								if(singlePinyinreg.at(i)==singlePinyinreg.at(j))
								 {
								 	singlePinyinreg.removeAt(j);							
								 }else
								 	j++;						
							}
					}					
					pinyinReg.append(singlePinyinreg.join("|"));
					pinyinReg.append(BROKEN_TOKEN_STR);					
				}else			
				pinyinReg.append(strUnit);				
			}			
		}
	//get allchars
	QString allchar = pinyinReg;
	allchar.replace(BROKEN_TOKEN_STR,"");
	allchar.replace("|","");
	for(int m =0; m < allchar.length();m++)
	{
		if(allchars.indexOf(allchar.at(m))==-1)
			allchars.append(allchar.at(m));
	}	
}

void CatItem::prepareInsertQuery(QSqlQuery* q,const CatItem& item,int tableid)
{
	q->prepare(
				QString("INSERT INTO %1"
				"("
					"fullPath, shortName, lowName,realname,icon,usage,hashId,"
					"isHasPinyin,comeFrom,time,"
					"pinyinReg,allchars,alias2,shortCut,delId,args"
				") VALUES ("
					":fullPath, :shortName, :lowName,:realname,:icon,:usage,:hashId,"
					":isHasPinyin,:comeFrom,:time,"
					":pinyinReg,:allchars,:alias2,:shortCut,:delId,:args"		
			   	")").arg(tableid?(DBTABLEINFO_NAME(tableid)):(DBTABLEINFO_NAME(item.comeFrom)))
			   );
	 BIND_CATITEM_QUERY(q,item);
}


