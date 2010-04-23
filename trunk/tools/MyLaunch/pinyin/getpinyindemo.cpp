/*
 * getpinyindemo.c
 *
 * Copyright (C) 2006-2007 Li XianJing <http://blog.csdn.net/absurd/>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
 * Boston, MA 02111-1307, USA.
 */

//#include <stdio.h>
#include <QTextCodec>
#include <QApplication>
#include <QStringList>
 #include <QHash>
 #include <QChar>
 #include <QDataStream>
 #include <QFile>
#include "pinyin.h"
unsigned int get_pin_data_length_1(QStringList* sl)
{
	//return sizeof(py_utf8_offset)/sizeof(py_utf8_offset[0]);
	return sl->size();
}
void pinyinMatches(QStringList& strlist,int i,int max,QString e_s,QString &txt,int& ret)
{
		QString match_s=e_s;
		if(ret)
			return;
		if(i==max)
		{
			qDebug("%s",qPrintable(match_s));
			ret=(match_s.contains(txt,Qt::CaseInsensitive))?1:0;
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
#define BROKEN_TOKEN_STR "#$@$#"
extern QStringList* pinyin_list[];
void getPinyinReg(QString& str){
	qDebug("str=%s",qPrintable(str));
	QString pinyinReg="";
	if(str.toLocal8Bit().length()==str.size())
		return;
	QStringList  shengmo;
	shengmo<<"sh"<<"zh"<<"ch";

	QStringList src_list = str.split(QRegExp("\\s+"));
	
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
			int ret=get_pinyin(strUnit.toUtf8());			
			if(ret!=-1)
			{
				pinyinReg.append(BROKEN_TOKEN_STR);
				QString str1=pinyin_list[ret>>16]->at(ret&0xffff);
				str1.remove(0,2);

				QStringList list2 = str1.split(" ", QString::SkipEmptyParts);	
				for(int i=0;i<list2.size();i++)
				{
					pinyinReg.append(list2.at(i).at(0));
					pinyinReg.append("|");
					//start check shengmo
					for(int j=0;j<shengmo.size();j++)
					{
						if(list2.at(i).startsWith (shengmo.at(j),Qt::CaseInsensitive))
						{
							pinyinReg.append(shengmo.at(j));
							pinyinReg.append("|");
							break;
						}
					}
					//end check shengmo
					pinyinReg.append(list2.at(i));
					if(i!=(list2.size()-1))
						pinyinReg.append("|");
				}
			}else
				{
					pinyinReg.append(strUnit);			
				
	    		 	}
			
			}
			
		}
		qDebug("str=%s regstr=%s",qPrintable(str),qPrintable(pinyinReg));
	}

void usage(void)
{
    qDebug("Usage: \n\ttest <hanzhi>\n");
}

//extern QStringList pinyin_utf8;
extern QStringList* pinyin_list[];
QStringList shengmo;
int main(int argc ,char *argv[])
{
	QTextCodec::setCodecForTr(QTextCodec::codecForName("UTF-8"));
	QTextCodec::setCodecForCStrings(QTextCodec::codecForName("UTF-8"));
	QString resultStr;
	QString regResult;
	QRegExp rx("(n|ni)?(h|hao)?(z|zh|zhong)?(g|guo)?");   
	int ret=rx.indexIn(QString(argv[1]));          
	qDebug("ret=%d matchedLength=%d",ret,rx.matchedLength());	
	QString s=QString::fromLocal8Bit(argv[1]);
	qDebug("%s 's hash %08x\n",argv[1],qhashEx(s,s.size()))	;
	qDebug("s's size is %d  0x%08x",s.size(),(1<<32));
	foreach(QChar c,s)
		qDebug("%0x",c.unicode());
	QFile file(s);
	file.open(QIODevice::ReadOnly);
	QDataStream ss;
	ss.setDevice(&file);
	char buf[1200]={0};
	int readLength=0;
	quint16 checksum=0;
	int totalLength=0;
	while(!ss.atEnd())
	{
			
			readLength=ss.readRawData (buf,1024);
			totalLength+=readLength;
			qDebug("readlength=%d %s",readLength,buf);
			checksum+=qChecksum(buf,readLength);
	}
	qDebug("checkSum=%d totalLength=%d",checksum,totalLength);
    return 0;
}
