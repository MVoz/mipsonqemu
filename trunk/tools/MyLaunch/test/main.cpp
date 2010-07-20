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

#include <QUrl>
#include <qDebug>
#include <QTextCodec>
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


#define SystemBasicInformation 0 
#define SystemPerformanceInformation 2 
#define SystemTimeInformation 3

#define Li2Double(x) ((double)((x).HighPart) * 4.294967296E9 + (double)((x).LowPart))

typedef struct 
{ 
 DWORD dwUnknown1; 
 ULONG uKeMaximumIncrement; 
 ULONG uPageSize; 
 ULONG uMmNumberOfPhysicalPages; 
 ULONG uMmLowestPhysicalPage; 
 ULONG uMmHighestPhysicalPage; 
 ULONG uAllocationGranularity; 
 PVOID pLowestUserAddress; 
 PVOID pMmHighestUserAddress; 
 ULONG uKeActiveProcessors; 
 BYTE bKeNumberProcessors; 
 BYTE bUnknown2; 
 WORD wUnknown3; 
} SYSTEM_BASIC_INFORMATION;

typedef struct 
{ 
 LARGE_INTEGER liIdleTime; 
 DWORD dwSpare[76]; 
} SYSTEM_PERFORMANCE_INFORMATION;

typedef struct 
{ 
 LARGE_INTEGER liKeBootTime; 
 LARGE_INTEGER liKeSystemTime; 
 LARGE_INTEGER liExpTimeZoneBias; 
 ULONG uCurrentTimeZoneId; 
 DWORD dwReserved; 
} SYSTEM_TIME_INFORMATION;

typedef LONG (WINAPI *PROCNTQSI)(UINT,PVOID,ULONG,PULONG);

PROCNTQSI NtQuerySystemInformation;


int GetCpuUsage()
{ 
 SYSTEM_PERFORMANCE_INFORMATION SysPerfInfo; 
 SYSTEM_TIME_INFORMATION SysTimeInfo; 
 SYSTEM_BASIC_INFORMATION SysBaseInfo; 
 double dbIdleTime; 
 double dbSystemTime; 
 LONG status; 
 static LARGE_INTEGER liOldIdleTime = {0,0}; 
 static LARGE_INTEGER liOldSystemTime = {0,0};
 
 NtQuerySystemInformation = (PROCNTQSI)GetProcAddress(GetModuleHandle(TEXT("ntdll")),"NtQuerySystemInformation");
 if (!NtQuerySystemInformation) 
  return -1;

 // get number of processors in the system 
 status = NtQuerySystemInformation(SystemBasicInformation,&SysBaseInfo,sizeof(SysBaseInfo),NULL); 
 if (status != NO_ERROR) 
  return -1;

  // get new system time 
  status = NtQuerySystemInformation(SystemTimeInformation,&SysTimeInfo,sizeof(SysTimeInfo),0); 
  if (status!=NO_ERROR) 
   return -1;

  // get new CPU's idle time 
  status =NtQuerySystemInformation(SystemPerformanceInformation,&SysPerfInfo,sizeof(SysPerfInfo),NULL); 
  if (status != NO_ERROR) 
   return -1;

  // if it's a first call - skip it 
  if (liOldIdleTime.QuadPart != 0) 
  { 
   // CurrentValue = NewValue - OldValue 
   dbIdleTime = Li2Double(SysPerfInfo.liIdleTime) - Li2Double(liOldIdleTime); 
   dbSystemTime = Li2Double(SysTimeInfo.liKeSystemTime) - Li2Double(liOldSystemTime);
   
   // CurrentCpuIdle = IdleTime / SystemTime 
   dbIdleTime = dbIdleTime / dbSystemTime;
   
   // CurrentCpuUsage% = 100 - (CurrentCpuIdle * 100) / NumberOfProcessors 
   dbIdleTime = 100.0 - dbIdleTime * 100.0 / (double)SysBaseInfo.bKeNumberProcessors + 0.5;
   
  }
  
  // store new CPU's idle and system time 
  liOldIdleTime = SysPerfInfo.liIdleTime; 
  liOldSystemTime = SysTimeInfo.liKeSystemTime;
  
  return (int)dbIdleTime;
}


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
	for (;;)
 {
  qDebug()<<GetCpuUsage();
  Sleep(1000);
 }
 return 0;
return 0;  

	
}
