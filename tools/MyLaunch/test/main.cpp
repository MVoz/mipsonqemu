#include <QApplication>
#include <QString>
#include <QDir>
#include <QFileInfo>
#include <QFileInfoList>
#include <QTextStream>
#include <windows.h>
#include <shlobj.h>
#define BOOKMARK_CATAGORY_FLAG 1
#define BOOKMARK_ITEM_FLAG 2
#define MASK_TYPE 0x03
#include <QPair>
#include <QList>
#include <QUrl>
#include <qDebug>
#include <QTextCodec>
#include <QTime>
/*
class Firefox_BM{
public:
	Firefox_BM(QString n,QString s,QRegExp r,int t,int d):name(n),str(s),reg(r),type(t),dataType(d)
	{
	}
	~Firefox_BM(){
		};
	QString name;
	QString str;
	QRegExp reg; 
	int type;
	int dataType;
	
};
QList<Firefox_BM> ff_bm;
void init_ff_bm()
{
	ff_bm<<Firefox_BM(QString("ICON"),QString(""),QRegExp("ICON=\"([^\"]*)\"",Qt::CaseInsensitive),BOOKMARK_ITEM_FLAG)
		 <<Firefox_BM(QString("ID"),QString(""),QRegExp("ID=\"([^\"]*)\"",Qt::CaseInsensitive),BOOKMARK_ITEM_FLAG|BOOKMARK_CATAGORY_FLAG)
		 <<Firefox_BM(QString("ADD_DATE"),QString(""),QRegExp("ADD_DATE=\"([^\"]*)\"",Qt::CaseInsensitive),BOOKMARK_ITEM_FLAG|BOOKMARK_CATAGORY_FLAG)
		 <<Firefox_BM(QString("LAST_MODIFIED"),QString(""),QRegExp("LAST_MODIFIED=\"([^\"]*)\"",Qt::CaseInsensitive),BOOKMARK_ITEM_FLAG|BOOKMARK_CATAGORY_FLAG)
		 <<Firefox_BM(QString("LAST_CHARSET"),QString(""),QRegExp("LAST_CHARSET=\"([^\"]*)\"",Qt::CaseInsensitive),BOOKMARK_ITEM_FLAG)
		 <<Firefox_BM(QString("PERSONAL_TOOLBAR_FOLDER"),QString(""),QRegExp("PERSONAL_TOOLBAR_FOLDER=\"([^\"]*)\"",Qt::CaseInsensitive),BOOKMARK_CATAGORY_FLAG)
		  <<Firefox_BM(QString("FEEDURL"),QString(""),QRegExp("FEEDURL=\"([^\"]*)\"",Qt::CaseInsensitive),BOOKMARK_ITEM_FLAG)		 
		 ;
	qDebug("ff_mm 's size is %d",ff_bm.size());
}
void handler_line(QString line,int type)
{
	qDebug("line=%s",qPrintable(line));
	int i=0;
	for(i=0;i<ff_bm.size();i++){
		//clear the lasest result
		ff_bm[i].str="";
		if(!(ff_bm[i].type&type))
			continue;		
		if(ff_bm[i].reg.indexIn(line)!=-1)
			{
				
				ff_bm[i].str=ff_bm[i].reg.cap(1);
				qDebug("str=%s",qPrintable(ff_bm[i].str));
			}
	}
}
void outToFile(QTextStream& os)
{
	foreach(Firefox_BM  bm,ff_bm){
			if(!bm.str.isEmpty())
				os<<"<"<<bm.name<<"><![CDATA["<<bm.str<<"]]></"<<bm.name<<">"<<"\n";
		}
}
void item_end(QTextStream& os,int type,int& finish)
{
	if(type==BOOKMARK_ITEM_FLAG&&!finish)
	{
		os<<"</item>"<<"\n";
		finish=1;
	}

}
void indexFirefox(QString path)
{
	QFile file(path);
	if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
		return;
        QFile ff_file("./firefox.xml");
	if (!ff_file.open(QIODevice::WriteOnly | QIODevice::Text))
		return;
	QTextStream ff_in(&ff_file);
	ff_in.setCodec("UTF-8");
	ff_in<<"<?xml version=\"1.0\" encoding=\"utf-8\"?>"<<"\n";
	ff_in<<"<bookmark version=\"1.0\" updateTime=\"2009-11-22 21:36:20\">"<<"\n";
	QRegExp regex_dir("<DT><H3 [\\s\\S]*>([\\s\\S]*)</H3>", Qt::CaseInsensitive);
	QRegExp regex_url("<a href=\"([^\"]*)\"", Qt::CaseInsensitive);
	QRegExp regex_urlname("\">([^<]*)</A>", Qt::CaseInsensitive);
	QRegExp regex_shortcut("SHORTCUTURL=\"([^\"]*)\"");
	QRegExp regex_postdata("POST_DATA", Qt::CaseInsensitive);
	QRegExp regex_dirstart("<DL><p>",Qt::CaseInsensitive);
	QRegExp regex_dirend("</DL><p>",Qt::CaseInsensitive);
	QRegExp regex_h1("<H1 [\\s\\S]*>([\\s\\S]*)</H1>",Qt::CaseInsensitive);
	QRegExp regex_dd("<DD>([\\s\\S]*)",Qt::CaseInsensitive);

	int now_type;//catagory or item
	int now_finish;
	while (!file.atEnd()) {
		QString line = QString::fromUtf8(file.readLine());
		if (regex_dir.indexIn(line) != -1) {
			item_end(ff_in,now_type,now_finish);
			//qDebug("dir=%s",qPrintable(regex_dir.cap(1)));
			//qDebug("line=%s",qPrintable(line));
			ff_in<<"<category>"<<"\n";
			ff_in<<"<name><![CDATA["<<regex_dir.cap(1)<<"]]></name>"<<"\n";
			handler_line(line,BOOKMARK_CATAGORY_FLAG);
			outToFile(ff_in);
			now_type=BOOKMARK_CATAGORY_FLAG;
		}
		if (regex_dd.indexIn(line) != -1) {
			ff_in<<"<DD><![CDATA["<<regex_dd.cap(1)<<"]]></DD>"<<"\n";
			item_end(ff_in,now_type,now_finish);

		}
		if (regex_dirend.indexIn(line) != -1&&!file.atEnd()) {
			//abbreviate the last "</DL><p>"
			qDebug("dir=%s",qPrintable(regex_dirend.cap(1)));
			item_end(ff_in,now_type,now_finish);
			ff_in<<"</category>"<<"\n";
		}
		if(regex_dirstart.indexIn(line)!=-1){
			qDebug("dir start.....\n");
		}
		if (regex_url.indexIn(line) != -1) {
				item_end(ff_in,now_type,now_finish);
				QString url = regex_url.cap(1);	
				if (regex_urlname.indexIn(line) != -1) {
					QString name = regex_urlname.cap(1);				

				qDebug("url=%s name=%s",qPrintable(url),qPrintable(name));
				ff_in<<"<item>"<<"\n";
				ff_in<<"<name><![CDATA["<<name<<"]]></name>"<<"\n";
				ff_in<<"<link><![CDATA["<<url<<"]]></link>"<<"\n";
				handler_line(line,BOOKMARK_ITEM_FLAG);
				outToFile(ff_in);
				now_type=BOOKMARK_ITEM_FLAG;	
				now_finish=0;

			}			
		}
	
	}
	item_end(ff_in,now_type,now_finish);
	ff_in<<"</bookmark>"<<"\n";
}
*/


//#define _WIN32_WINNT   0x0501

#include <Windows.h>
 #define PINYIN_TOKEN_FLAG "(p)"
void pinyinMatchesEx(QStringList& strlist,QString &txt,bool& ret,bool CaseSensitive)
{
		QString regToken("");
		QString pinyin_token(PINYIN_TOKEN_FLAG);
		foreach(QString token,strlist){
				qDebug()<<token;
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
							qDebug("txt=%s regToken=%s",qPrintable(txt),qPrintable(regToken));
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
int isAllIn(QString src,QString all)
{
	int i = 0;
	for(i = 0; i < src.size();i++)
	{
		if(all.indexOf(src.at(i))==-1)
			return 0;
	}
	return 1;
}

struct SearchStatistic{
	QChar c;
	uint n;
};
bool searchLess(struct SearchStatistic a,struct SearchStatistic b)
{
	if(a.n<b.n)
		return true;
	else
		return false;

}

bool search(const QStringList& list,const int size,int pos,const QString& searchtxt,const int ssize,int& depth,QString suffix);
int main(int argc, char *argv[])
{
		QTextCodec::setCodecForTr(QTextCodec::codecForName("UTF-8"));
	    QTextCodec::setCodecForCStrings(QTextCodec::codecForName("UTF-8"));
	//	QTextCodec::setCodecForLocale(QTextCodec::codecForName("GB18030"));
		QStringList args = qApp->arguments();
		QApplication *app=new QApplication(argc, argv);
	    app->setQuitOnLastWindowClosed(true);
	/*
		init_ff_bm();
		indexFirefox("./bookmarks.html");

		QRegExp rxlen("<DT><H3 [\\s\\S]*>([\\s\\S]*)</H3>", Qt::CaseInsensitive);
	 int pos = rxlen.indexIn("<DT><H3 >足球</H3>");
	 if (pos > -1) {
		 QString value = rxlen.cap(0); // "189"
		 QString unit = rxlen.cap(1);  // "cm"
		 qDebug("value=%s unit=%s",qPrintable(value),qPrintable(unit));
	 }
		//app->exec();
*/	
	#define BROKEN_TOKEN_STR "$#@#$"
	//QString s("$#@#$j|ji|x|xi(p)$#@#$t|tong(p)$#@#$g|gong(p)$#@#$j|ju(p)$#@#$p|pi(p)$#@#$c|ch|chu(p)$#@#$l|li(p)$#@#$");

//	QString s("j|ji|x|xi$#@#$t|tong$#@#$g|gong$#@#$j|ju$#@#$p|pi$#@#$c|ch|chu$#@#$l|li");
QString s("$#@#$q|qiang|j|jiang$#@#$l|li$#@#$x|xie$#@#$z|zai|z|zi$#@#$d|dian$#@#$n|nao$#@#$s|sh|shang$#@#$d|de|d|di$#@#$r|ruan$#@#$j|jian|m|mou$#@#$");

	QStringList regStr=s.split(BROKEN_TOKEN_STR);
	QString allchars;
	bool matched=0;
	int i =0;
	QString ss = s.replace(BROKEN_TOKEN_STR,"");
	ss = ss.replace(PINYIN_TOKEN_FLAG,"");
	ss = ss.replace("|","");
	qDebug()<<ss;
	for(i =0; i < ss.length();i++)
	{
		if(allchars.indexOf(ss.at(i))==-1)
			allchars.append(ss.at(i));
	}
	qDebug()<<allchars;

	QString searchtxt(argv[1]);

	QString searchs;


	QList<struct SearchStatistic> s_ch_list;

	for(i =0; i < searchtxt.length();i++)
	{
		if(searchs.indexOf(searchtxt.at(i))==-1)
		{
			searchs.append(searchtxt.at(i));
			
		}
		int j=0;
		for (j = 0; j < s_ch_list.size(); ++j) {
				   struct SearchStatistic m=s_ch_list.at(j);
			 if (m.c == searchtxt.at(i))
				{
					m.n++;
					s_ch_list.replace(j,m);
					break;
				}
		}
		if(j==s_ch_list.size())
		{
			struct SearchStatistic t;
			t.c= searchtxt.at(i);
			t.n=1;
			s_ch_list.append(t)	;
		}
		

	}
	qDebug()<<searchs;

	
	/*
	 qSort(s_ch_list.begin(), s_ch_list.end(),searchLess);

	  	 for (int j = 0; j < s_ch_list.size(); ++j) {
			qDebug() << s_ch_list.at(j).c << ": " << s_ch_list.at(j).n;
		}
	  */

	QTime t;
	t.start();
	 i=0;
	while((i++)<1)
	{

			if(allchars.size()<searchs.size())
				break;
			if(!isAllIn(searchs,allchars))
				break;
			 //QString s("$#@#$j|ji|x|xi(p)$#@#$t|tong(p)$#@#$g|gong(p)$#@#$j|ju(p)$#@#$p|pi(p)$#@#$c|ch|chu(p)$#@#$l|li(p)$#@#$");
			   for (int i = 0; i < regStr.size(); ++i)
					qDebug()<<regStr.at(i);
			
		//	pinyinMatchesEx(regStr,QString(argv[1]),matched,Qt::CaseInsensitive);
				int regsize = regStr.size();
				for (int i = 0; i <regsize ; ++i)
				{
					int depth=0;
					if(!(matched=search(regStr,regStr.size(),0,searchtxt,searchtxt.size(),depth,"")))
					{
						qDebug()<<"removeFirst";
						
						 regStr.removeFirst();
					}else
						break;
				}
	}

	qDebug("Time elapsed:matched=%d %d ms",matched, t.elapsed());
	return 0;  	
}	
bool search(const QStringList& list,const int size,int pos,const QString& searchtxt,const int ssize,int& depth,QString suffix)
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
		int r= searchtxt.indexOf(t);
		qDebug()<<	searchtxt<<" : "<<t;
		if(searchtxt.startsWith(t))
		{
			 if(ssize==t.size())
				 return true;
			 else
			{
				 if(search(list,size,pos+1,searchtxt,ssize,depth,t))
					 return true; 				
			}

		} 
	}  
	return false;
 }
 			 //QString s("$#@#$j|ji|x|xi(p)$#@#$t|tong(p)$#@#$g|gong(p)$#@#$j|ju(p)$#@#$p|pi(p)$#@#$c|ch|chu(p)$#@#$l|li(p)$#@#$");
	//		 QString s("j|ji|x|xi$#@#$t|tong$#@#$g|gong$#@#$j|ju$#@#$p|pi$#@#$c|ch|chu$#@#$l|li");