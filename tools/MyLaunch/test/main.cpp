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
				/*
				if (regex_shortcut.indexIn(line) != -1) {
					QString shortcut = regex_shortcut.cap(1);
						qDebug("url=%s name=%s",qPrintable(url),qPrintable(name));
				} else {

				}
				*/
	
			}			
		}
	
	}
	item_end(ff_in,now_type,now_finish);
	ff_in<<"</bookmark>"<<"\n";
}
int main(int argc, char *argv[])
{
		QStringList args = qApp->arguments();
		QApplication *app=new QApplication(argc, argv);
	    app->setQuitOnLastWindowClosed(true);
		init_ff_bm();
		indexFirefox("./bookmarks.html");

		QRegExp rxlen("<DT><H3 [\\s\\S]*>([\\s\\S]*)</H3>", Qt::CaseInsensitive);
	 int pos = rxlen.indexIn("<DT><H3 >×ãÇò</H3>");
	 if (pos > -1) {
		 QString value = rxlen.cap(0); // "189"
		 QString unit = rxlen.cap(1);  // "cm"
		 qDebug("value=%s unit=%s",qPrintable(value),qPrintable(unit));
	 }
		//app->exec();
}
