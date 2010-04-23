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

#ifndef CATALOG_H
#define CATALOG_H

#include <QString>
#include <QStringList>
#include <QBitArray>
#include <QIcon>
#include <QHash>
#include <QDataStream>
#include <QDir>
#include <QSet>
#include <bmapi.h>
#include <pinyin>
#if defined(CATALOG_DLL)
#define CATALOG_DLL_CLASS_EXPORT __declspec(dllexport)
#else
#define CATALOG_DLL_CLASS_EXPORT __declspec(dllimport)
//#define CATALOG_DLL_CLASS_EXPORT 
#endif
/** 
\brief CatItem (Catalog Item) stores a single item in the index
*/
#define NO_PINYIN_FLAG 0
#define HAS_PINYIN_FLAG 1
#define BROKEN_TOKEN_STR "$#@#$"
#define PINYIN_MAX_DEPTH 16
#define PINYIN_MAX_NUMBER 4
#define PINYIN_TOKEN_FLAG "(p)"

#define COME_FROM_PROGRAM 1
#define COME_FROM_RUNNER 2
#define COME_FROM_DEFINE 3

#define COME_FROM_IE 5
#define COME_FROM_FIREFOX 6
#define COME_FROM_OPERA 7

class CATALOG_DLL_CLASS_EXPORT CatItem {
public:
    
	/** The full path of the indexed item */
	QString fullPath;
	/** The abbreviated name of the indexed item */
	QString shortName;
	/** The lowercase name of the indexed item */
	QString lowName;
	/** A path to an icon for the item */
	QString icon;
	/** How many times this item has been called by the user */
	int usage;
	/** This is unused, and meant for plugin writers and future extensions */
	void* data;
	/** The plugin id of the creator of this CatItem */
	uint hash_id;

        uint groupId;
        uint parentId;
	/*is has pingyin*/
	unsigned char isHasPinyin;
	unsigned char comeFrom;
	unsigned short hanziNums;
	/*pinyin depth*/
	unsigned int pinyinDepth;
	/*pinyin reg*/
	QString pinyinReg;
	QString alias1;
	QString alias2;
	QString shortCut;
	uint delId;
	QString args;
	CatItem() {}



	CatItem(QString full,int flag,bool isDir = false) 
		: fullPath(full),comeFrom(flag) {
			int last = fullPath.lastIndexOf("/");
			if (last == -1) {
				shortName = fullPath;

			} else {
				shortName = fullPath.mid(last+1);
				if (!isDir)
					shortName = shortName.mid(0,shortName.lastIndexOf("."));
			}

			lowName = shortName.toLower();
			getPinyinReg(shortName);
			data = NULL;
			usage = 0;
			groupId=0;
			parentId=0;
			hash_id = qHash(fullPath);
			alias1="";
			alias2="";
			shortCut="";
			delId=0;
			args="";
	}


	CatItem(QString full, QString shortN,int flag) 
		: fullPath(full), shortName(shortN),comeFrom(flag)
	{
		lowName = shortName.toLower();
		getPinyinReg(shortName);
		data = NULL;
		usage = 0;
		groupId=0;
		parentId=0;
		hash_id = qHash(fullPath);
		alias1="";
		alias2="";
		shortCut="";
		delId=0;
		args="";
	}

	CatItem(QString full, QString shortN, uint i_d,int flag)  
	    :  fullPath(full), shortName(shortN), hash_id(i_d),comeFrom(flag)
	{
		lowName = shortName.toLower();
		getPinyinReg(shortName);
		data = NULL;
		usage = 0;
		groupId=0;
		parentId=0;
		hash_id = qHash(fullPath);
		alias1="";
		alias2="";
		shortCut="";
		delId=0;
		args="";
	}
	CatItem(QString full, QString shortN,QString arg, int flag)  
	    :  fullPath(full), shortName(shortN), args(arg),comeFrom(flag)
	{
		lowName = shortName.toLower();
		getPinyinReg(shortName);
		data = NULL;
		usage = 0;
		groupId=0;
		parentId=0;
		hash_id = qHash(fullPath);
		alias1="";
		alias2="";
		shortCut="";
		delId=0;
	}
	/** This is the constructor most used by plugins 
	\param full The full path of the file to execute
	\param The abbreviated name for the entry
	\param i_d Your plugin id (0 for Launchy itself)
	\param iconPath The path to the icon for this entry
	\warning It is usually a good idea to append ".your_plugin_name" to the end of the full parameter
	so that there are not multiple items in the index with the same full path.
	*/
	CatItem(QString full, QString shortN, uint i_d, QString iconPath,int flag)   
	    : fullPath(full), shortName(shortN), icon(iconPath), hash_id(i_d),comeFrom(flag)
	{
		lowName = shortName.toLower();
		getPinyinReg(shortName);
		data = NULL;
		usage = 0;
		groupId=0;
		parentId=0;
		hash_id = qHash(fullPath);
		alias1="";
		alias2="";
		shortCut="";
		delId=0;
		args="";
	}
	CatItem(QString full, QString shortN,QString arg, uint i_d, QString iconPath,int flag)   
	    : fullPath(full), shortName(shortN),args(arg), icon(iconPath), hash_id(i_d),comeFrom(flag)
	{
		lowName = shortName.toLower();
		getPinyinReg(shortName);
		data = NULL;
		usage = 0;
		groupId=0;
		parentId=0;
		hash_id = qHash(fullPath);
		alias1="";
		alias2="";
		shortCut="";
		delId=0;
	}

	CatItem(const CatItem &s) {
		fullPath = s.fullPath;
		shortName = s.shortName;
		lowName = s.lowName;
		icon = s.icon;
		usage = s.usage;
		data = s.data;
		groupId=s.groupId;
		parentId=s.parentId;
		hash_id = s.hash_id;
		comeFrom=s.comeFrom;
		isHasPinyin=s.isHasPinyin;
		pinyinDepth=s.pinyinDepth;
		hanziNums=s.hanziNums;
		pinyinReg=s.pinyinReg;
		alias1=s.alias1;
		alias2=s.alias2;
		shortCut=s.shortCut;
		delId=s.delId;
		args=s.args;
	}
	void getPinyinReg(QString& str){
	isHasPinyin=NO_PINYIN_FLAG;
	pinyinReg="";
	pinyinDepth=1;
	hanziNums=0;
	if(str.size()==0)
		return;
	if(str.toLocal8Bit().length()==str.size())
		return;
	hanziNums=str.toLocal8Bit().length()-str.size();
	QStringList  shengmo;
	shengmo<<"sh"<<"zh"<<"ch";

	QStringList src_list = str.split(QRegExp("\\s+"));
	//qDebug("shortName=%s",qPrintable(shortName));
	foreach (QString s_s, src_list) {
		//QString s_s=QString::fromLocal8Bit(s);
		if(s_s.toLocal8Bit().length()==s_s.size())
			{
				pinyinReg.append(s_s);
				pinyinReg.append(" ");
				continue;
			}
		//qDebug("%s str=%s s_s=%s",__FUNCTION__,qPrintable(str),qPrintable(s_s));
		
		 for(int i=0;i<s_s.size();i++)
		{
			QString strUnit=QString(s_s.at(i));
			if(strUnit.toLocal8Bit().length()==strUnit.size()){
					pinyinReg.append(strUnit);	
					continue;
				}
			int numbers=0;/*the number by split by "|"*/
			int ret=get_pinyin(strUnit.toUtf8());	
			//qDebug("%s ret=0x%08x",__FUNCTION__,ret);
			if(ret!=-1)
			{
				isHasPinyin=HAS_PINYIN_FLAG;
				if(!pinyinReg.endsWith(BROKEN_TOKEN_STR))
						pinyinReg.append(BROKEN_TOKEN_STR);
				QString str1=pinyin_list[ret>>16]->at(ret&0xffff);
				str1.remove(0,2);

				QStringList list2 = str1.split(" ", QString::SkipEmptyParts);	
				
				for(int i=0;i<list2.size();i++)
				{
					pinyinReg.append(list2.at(i).at(0));
					numbers++;
					if(list2.at(i).size()>1)
						   pinyinReg.append("|");
					//start check shengmo
					for(int j=0;j<shengmo.size();j++)
					{
						if(list2.at(i).startsWith (shengmo.at(j),Qt::CaseInsensitive))
						{
							pinyinReg.append(shengmo.at(j));
							pinyinReg.append("|");
							numbers++;
							break;
						}
					}
					//end check shengmo
					if(list2.at(i).size()>1)
						{
							pinyinReg.append(list2.at(i));
							numbers++;
						}
					if(i!=(list2.size()-1))
						pinyinReg.append("|");
					else
						{
						pinyinReg.append(PINYIN_TOKEN_FLAG);
					         pinyinReg.append(BROKEN_TOKEN_STR);
						}
				}
			}else
				{
					pinyinReg.append(strUnit);			
					numbers=1;
	    		 	}

				pinyinDepth=pinyinDepth*numbers;
			}
			
		}
		//qDebug("shortName=%s regstr=%s pinyinDepth=%u",qPrintable(shortName),qPrintable(pinyinReg),pinyinDepth);
	}
	CatItem& operator=( const CatItem &s ) {
		fullPath = s.fullPath;
		shortName = s.shortName;
		lowName = s.lowName;
		icon = s.icon;
		usage = s.usage;
		data = s.data;
		hash_id = s.hash_id;
		groupId=s.groupId;
		parentId=s.parentId;
		comeFrom=s.comeFrom;
		isHasPinyin=s.isHasPinyin;
		pinyinDepth=s.pinyinDepth;
		pinyinReg=s.pinyinReg;
		hanziNums=s.hanziNums;
		alias1=s.alias1;
		alias2=s.alias2;
		shortCut=s.shortCut;
		delId=s.delId;
		args=s.args;
		return *this;
	}

	bool operator==(const CatItem& other) const{
		if (fullPath == other.fullPath)
			return true;
		return false;
	}

};


/** InputData shows one segment (between tabs) of a user's query 
	A user's query is typically represented by List<InputData>
	and each element of the list represents a segment of the query.

	E.g.  query = "google <tab> this is my search" will have 2 InputData segments
	in the list.  One for "google" and one for "this is my search"
*/
class CATALOG_DLL_CLASS_EXPORT InputData 
{
private:
	/** The user's entry */
	QString text;
	/** Any assigned labels to this query segment */
	QSet<uint> labels;
	/** A pointer to the best catalog match for this segment of the query */
	CatItem topResult;
	/** The plugin id of this query's owner */
	uint id;
public:
	/** Get the labels applied to this query segment */
	QSet<uint>  getLabels() { return labels; }
	/** Apply a label to this query segment */
	void setLabel(uint l) { labels.insert(l); }
	/** Check if it has the given label applied to it */
	bool hasLabel(uint l) { return labels.contains(l); }

	/** Set the id of this query

	This can be used to override the owner of the selected catalog item, so that 
	no matter what item is chosen from the catalog, the given plugin will be the one
	to execute it.

	\param i The plugin id of the plugin to execute the query's best match from the catalog
	*/
	void setID(uint i) { id = i; }

	/** Returns the current owner id of the query */
	uint getID() { return id; }

	/** Get the text of the query segment */
	QString  getText() { return text; }

	/** Set the text of the query segment */
	void setText(QString t) { text = t; }

	/** Get a pointer to the best catalog match for this segment of the query */
	CatItem&  getTopResult() { return topResult; }

	/** Change the best catalog match for this segment */
	void setTopResult(CatItem sr) { topResult = sr; }

	InputData() { id = 0; }
	InputData(QString str) : text(str) { id = 0;}
};
extern QString searchTxt;
CATALOG_DLL_CLASS_EXPORT bool  CatLess (CatItem* left, CatItem* right); 
CATALOG_DLL_CLASS_EXPORT bool  CatLessNoPtr (CatItem & a, CatItem & b);

inline QDataStream &operator<<(QDataStream &out, const CatItem &item) {
	out << item.fullPath;
	out << item.shortName;
	out << item.lowName;
	out << item.icon;
	out << item.usage;
	out << item.hash_id;
	out << item.groupId;
	out << item.parentId;
	out << item.isHasPinyin;
	out << item.comeFrom;
	out << item.hanziNums;
	out << item.pinyinDepth;	
	out << item.pinyinReg;
	out << item.alias1;
	out << item.alias2;
	out << item.shortCut;
	out << item.delId;
	out << item.args;
	return out;
}

inline QDataStream &operator>>(QDataStream &in, CatItem &item) {
	in >> item.fullPath;
	in >> item.shortName;
	in >> item.lowName;
	in >> item.icon;
	in >> item.usage;
	in >> item.hash_id;
	in >> item.groupId;
	in >> item.parentId;
	in >> item.isHasPinyin;
	in >> item.comeFrom;
	in >> item.hanziNums;
	in >> item.pinyinDepth;
	in >> item.pinyinReg;
	in >> item.alias1;
	in >> item.alias2;
	in >> item.shortCut;
	in >> item.delId;
	in >> item.args;
	return in;
}




#endif
