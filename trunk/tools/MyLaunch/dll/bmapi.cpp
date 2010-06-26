#include <bmapi.h>
#include <stdio.h>
#include <QDateTime>
#include <QString>
#include <QStringList>
#include <QSettings>
#include <QTextCodec>
#include <qDebug>
#include <QUrl>
#include <QCoreApplication>
#include <QSettings>
#include <QSqlRecord>
uint gMaxGroupId=0;
QString gUpdatetime;
bool gPostError=0;
uint gPostResponse=0;
uint gBmId=0;
int language=DEFAULT_LANGUAGE;
char* gLanguageList[]={"chinese","english"};
struct browserinfo browserInfo[]={
	{QString("Ie"), true, true, false,false,false, BROWSE_TYPE_IE},
	{QString("Firefox"), false, false , false,false,false, BROWSE_TYPE_FIREFOX},
	{QString("Opera") , false , false , false,false,false, BROWSE_TYPE_OPERA},
	{QString(""),false,false, false,false,false,0}
};
void setBrowserInfoOpFlag(uint id,enum BROWSERINFO_OP type)
{
	int i = 0;
	while(!browserInfo[i].name.isEmpty())
		{
			if( browserInfo[i].id == id )
				{
					switch(type){
						case BROWSERINFO_OP_LASTUPDATE:
							browserInfo[i].lastupdate= true;
							break;
						case BROWSERINFO_OP_FROMSERVER:
							browserInfo[i].fromserver= true;
							break;
						case BROWSERINFO_OP_LOCAL:
							browserInfo[i].local= true;
							break;
					}					
					return;
				}
			i++;
		}
	return ;
}
void clearBrowserInfoOpFlag(uint id)
{
	int i = 0;
	while(!browserInfo[i].name.isEmpty())
		{
			if( browserInfo[i].id == id )
				{
					browserInfo[i].lastupdate= false;
					browserInfo[i].fromserver= false;
					browserInfo[i].local= false;
					return;
				}
			i++;
		}
	return ;
}


bool getBrowserEnable(uint id)
{
	int i = 0;
	while(!browserInfo[i].name.isEmpty())
		{
			if( browserInfo[i].id == id )
				return browserInfo[i].enable;
			i++;
		}
	return false;
}
void setBrowserEnable(QSettings *s)
{
	if(!s) return;
	int i = 0;
	while(!browserInfo[i].name.isEmpty())
		{
			browserInfo[i].enable = s->value(QString("adv/ckSupport%1").arg(browserInfo[i].name),browserInfo[i].defenable).toBool();		
			i++;
		}
}


void setPostResponse(uint  type)
{
	gPostResponse=type;
}
uint getPostResponse()
{
	return gPostResponse;
}



void setPostError(bool err)
{
	gPostError=err;
}
bool getPostError()
{
	return gPostError;
}

void setMaxGroupId(uint id)
{
	gMaxGroupId=id;
}
uint getMaxGroupId()
{
	return gMaxGroupId;
}

void setUpdatetime(QString time)
{
	gUpdatetime=time;
}
void getUpdatetime(QString& time)
{
	time=gUpdatetime;;
}
void setBmId(uint bmid)
{
	gBmId=bmid;
}
uint getBmId()
{
	return gBmId;
}


#if 0
extern QDateTime gNowUpdateTime;;
int setDirectoryTimeIncludeAllFiles(QString path)
{
	QDir qd(path);
	QString dir = qd.absolutePath();
	QStringList dirs = qd.entryList(QDir::AllDirs | QDir::NoDotAndDotDot);
	for (int i = 0; i < dirs.count(); ++i)
	  {
		  QString cur = dirs[i];
		  if (cur.contains(".lnk"))
			  continue;
		  setDirectoryTimeIncludeAllFiles(dir + "/" + dirs[i]);
		  setFileTime(dir + "/" + dirs[i], gNowUpdateTime.toString(TIME_FORMAT), NULL, NULL, NAME_IS_FILE);
	  }

	QStringList files = qd.entryList(QStringList("*.url"), QDir::Files, QDir::Unsorted);
	for (int i = 0; i < files.count(); ++i)
	  {
		  setFileTime(path + "/" + files[i], gNowUpdateTime.toString(TIME_FORMAT), NULL, NULL, NAME_IS_FILE);
	  }
	return 1;
}

int getFileTime(QString filename, QString * createTime, QString * lastAccessTime, QString * lastWriteTime, int flag)
{
	HANDLE hfile;
	FILETIME lpCreationTime, lpCreationTime1;	// creation time
	FILETIME lpLastAccessTime;	// last access time
	FILETIME lpLastWriteTime;	// last write time
	SYSTEMTIME lpSysCreationTime;
	SYSTEMTIME lpSysLastAccessTime;
	SYSTEMTIME lpSysLastWriteTime;

	hfile = CreateFile((LPCWSTR) filename.utf16(), GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_DELETE, NULL, OPEN_EXISTING, flag ? FILE_FLAG_BACKUP_SEMANTICS : FILE_ATTRIBUTE_NORMAL, NULL);

	if (hfile == INVALID_HANDLE_VALUE)
	  {
		 // logToFile("Open %s failed!\nErrorCode:%d\n", qPrintable(filename), GetLastError());
		  return NULL;
	  }
	if (hfile)
	  {
		  GetFileTime((HANDLE) hfile, &lpCreationTime, &lpLastAccessTime, &lpLastWriteTime);
		  if (!FileTimeToLocalFileTime(&lpCreationTime, &lpCreationTime1))
			  return NULL;
		  FileTimeToSystemTime(&lpCreationTime1, &lpSysCreationTime);
		  createTime->sprintf("%04d-%02d-%02d %02d:%02d:%02d", lpSysCreationTime.wYear, lpSysCreationTime.wMonth, lpSysCreationTime.wDay, lpSysCreationTime.wHour, lpSysCreationTime.wMinute, lpSysCreationTime.wSecond);
		  if (!FileTimeToLocalFileTime(&lpLastAccessTime, &lpCreationTime1))
			  return NULL;
		  FileTimeToSystemTime(&lpCreationTime1, &lpSysLastAccessTime);
		  lastAccessTime->sprintf("%04d-%02d-%02d %02d:%02d:%02d", lpSysLastAccessTime.wYear, lpSysLastAccessTime.wMonth, lpSysLastAccessTime.wDay, lpSysLastAccessTime.wHour, lpSysLastAccessTime.wMinute, lpSysLastAccessTime.wSecond);
		  if (!FileTimeToLocalFileTime(&lpLastWriteTime, &lpCreationTime1))
			  return NULL;
		  FileTimeToSystemTime(&lpCreationTime1, &lpSysLastWriteTime);
		  lastWriteTime->sprintf("%04d-%02d-%02d %02d:%02d:%02d", lpSysLastWriteTime.wYear, lpSysLastWriteTime.wMonth, lpSysLastWriteTime.wDay, lpSysLastWriteTime.wHour, lpSysLastWriteTime.wMinute, lpSysLastWriteTime.wSecond);
		  CloseHandle(hfile);
		  return NULL;
	  }
	return NULL;
}
int setFileTime(QString filename, QString createTime, QString * lastAccessTime, QString * lastWriteTime, int flag)
{
#ifdef CONFIG_LOG_ENABLE
	//logToFile("%s file=%s time=%s",__FUNCTION__,qPrintable(filename),qPrintable(createTime));
#endif
	HANDLE hfile;
	// FILETIME lpCreationTime,lpCreationTime1;   // creation time
	// FILETIME lpLastAccessTime;  // last access time
	FILETIME LastWriteTime, LastWriteTime1;	// last write time
	// SYSTEMTIME  lpSysCreationTime;
	// SYSTEMTIME  lpSysLastAccessTime;
	SYSTEMTIME SysLastWriteTime;
	hfile = CreateFile((LPCWSTR) filename.utf16(), GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_DELETE, NULL, OPEN_EXISTING, flag ? FILE_FLAG_BACKUP_SEMANTICS : FILE_ATTRIBUTE_NORMAL, NULL);

	if (hfile == INVALID_HANDLE_VALUE)
	  {
		  //logToFile("Open %s failed!\nErrorCode:%d\n", qPrintable(filename), GetLastError());
		  return NULL;
	  }
	int year, month, day, hour, minute, second;
	if (hfile)
	  {
		  memset(&SysLastWriteTime, 0, sizeof(SysLastWriteTime));
		  sscanf(createTime.toUtf8(), "%u-%u-%u %u:%u:%u", &year, &month, &day, &hour, &minute, &second);
		  SysLastWriteTime.wYear = year;
		  SysLastWriteTime.wMonth = month;
		  SysLastWriteTime.wDay = day;
		  SysLastWriteTime.wHour = hour;
		  SysLastWriteTime.wMinute = minute;
		  SysLastWriteTime.wSecond = second;
#ifdef CONFIG_LOG_ENABLE
		  //      logToFile("%s time=%u-%02u-%02u %02u:%02u:%02u",__FUNCTION__,SysLastWriteTime.wYear,SysLastWriteTime.wMonth,SysLastWriteTime.wDay,
		  //              SysLastWriteTime.wHour, SysLastWriteTime.wMinute,SysLastWriteTime.wSecond);
#endif
#if 0
		  //GetSystemTime(&lpSysCreationTime);              
		  SystemTimeToFileTime(&lpSysCreationTime, &lpLastWriteTime1);
#else
		  SystemTimeToFileTime(&SysLastWriteTime, &LastWriteTime);	// converts to file time format
		  LocalFileTimeToFileTime(&LastWriteTime, &LastWriteTime1);
#endif
		  if (!SetFileTime(hfile, &LastWriteTime1, (LPFILETIME) NULL, &LastWriteTime1))
		    {
			    //logToFile("setfiletime error %d", GetLastError());
		    }

		  CloseHandle(hfile);
		  return NULL;
	  }
	return NULL;
}
#endif
int deleteDirectory(QString path)
{
	path= QDir::toNativeSeparators(path);
	QDir dir(path);
	QString dirPath = dir.absolutePath();
	if(!dir.exists()) return 0;
	QStringList files = dir.entryList(QDir::Files);
	for(int i=0;i<files.size();i++)
		{
			qDebug("delete file %s ",qPrintable(files[i]));
			dir.remove(dirPath+ "/"+files[i]);
		}
	QStringList dirs = dir.entryList(QDir::AllDirs | QDir::NoDotAndDotDot);
	for(int i=0;i<dirs.size();i++)
	{
			deleteDirectory(dirPath+ "/"+dirs[i]);
	}
	qDebug("deleteDirectory %s ",qPrintable(dirPath));
	dir.rmdir(dirPath);
	return 1;
	
}


void runProgram(QString path, QString args) {
#ifdef Q_WS_WIN
	SHELLEXECUTEINFO ShExecInfo;
	qDebug("runProgram path=%s args=%s",qPrintable(path),qPrintable(args));
	ShExecInfo.cbSize = sizeof(SHELLEXECUTEINFO);
	ShExecInfo.fMask = SEE_MASK_FLAG_NO_UI;
	ShExecInfo.hwnd = NULL;
	ShExecInfo.lpVerb = NULL;
	ShExecInfo.lpFile = (LPCTSTR) (path).utf16();
	if (args != "") {
		ShExecInfo.lpParameters = (LPCTSTR) args.utf16();
	} else {
		ShExecInfo.lpParameters = NULL;
	}
	QDir dir(path);
	QFileInfo info(path);
	if (!info.isDir() && info.isFile())
		dir.cdUp();
	ShExecInfo.lpDirectory = (LPCTSTR)QDir::toNativeSeparators(dir.absolutePath()).utf16();
	ShExecInfo.nShow = SW_NORMAL;
	ShExecInfo.hInstApp = NULL;

	ShellExecuteEx(&ShExecInfo);	
#endif

#ifdef Q_WS_MAC

#endif

#ifdef Q_WS_X11

#endif

}
BOOL GetShellDir(int iType, QString & szPath)
{
	QString tmpp = "shell32.dll";
	HINSTANCE hInst =::LoadLibrary((LPCTSTR) tmpp.utf16());
	if (NULL == hInst)
	  {
		  return FALSE;
	  }

	HRESULT(__stdcall * pfnSHGetFolderPath) (HWND, int, HANDLE, DWORD, LPWSTR);


	pfnSHGetFolderPath = reinterpret_cast < HRESULT(__stdcall *) (HWND, int, HANDLE, DWORD, LPWSTR) >(GetProcAddress(hInst, "SHGetFolderPathW"));

	if (NULL == pfnSHGetFolderPath)
	  {
		  FreeLibrary(hInst);	// <-- here
		  return FALSE;
	  }

	TCHAR tmp[_MAX_PATH];
	pfnSHGetFolderPath(NULL, iType, NULL, 0, tmp);
	szPath = QString::fromUtf16((const ushort *) tmp);
	FreeLibrary(hInst);	// <-- and here
	return TRUE;
}
bool getUserLocalFullpath(QSettings* settings,QString filename,QString& dest)
{
	 dest = settings->fileName();
	 int lastSlash = dest.lastIndexOf(QLatin1Char('/'));
	 if (lastSlash == -1)
	 return false;
	dest = dest.mid(0, lastSlash);
	dest += "/";
	dest +=filename;
	return true;
}
int getDesktop()
{
	return DESKTOP_WINDOWS;
}

void SetColor(unsigned short ForeColor=FOREGROUND_INTENSITY,unsigned short BackGroundColor=0) 
{ 
	    HANDLE hCon = GetStdHandle(STD_OUTPUT_HANDLE);/*STD_OUTPUT_HANDLE,STD_ERROR_HANDLE*/
	    SetConsoleTextAttribute(hCon,ForeColor|BackGroundColor); 
} 
quint16 getFileChecksum(QFile *f)
{
		QDataStream ss;
		ss.setDevice(f);
		char buf[1200]={0};
		int readLength=0;
		quint16 checksum=0;
		while(!ss.atEnd())
		{
				
				readLength=ss.readRawData (buf,1024);
				checksum+=qChecksum(buf,readLength);
		}
		return checksum;

}
int getFirefoxPath(QString& path)
{
	QString iniPath;
	QString appData;
	QString osPath;

//#ifdef Q_WS_WIN
	GetShellDir(CSIDL_APPDATA, appData);
	osPath = appData + "/Mozilla/Firefox/";
//#endif



	iniPath = osPath + "profiles.ini";

	QFile file(iniPath);
	if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
		return 0;
	bool isRel = false;
	while (!file.atEnd()) {
		QString line = file.readLine();
		if (line.contains("IsRelative")) {
			QStringList spl = line.split("=");
			isRel = spl[1].toInt();
		}
		if (line.contains("Path")) {
			QStringList spl = line.split("=");
			//if (isRel)
			//	path = osPath + spl[1].mid(0,spl[1].count()-1) + "/bookmarks.html" ;
			//else
			//	path = spl[1].mid(0,spl[1].count()-1);

			path = osPath + spl[1].mid(0,spl[1].count()-1)  ;
			break;
		}
	} 	

	return 1;
}
/*encrypt*/
/*
	0    1    2	   3    4   5   6   7   8    9    

0   a	 b    c    d    e   f   g   h   i    j    

1	l    m    n    o    p   q   r   s   t    u   

2	w    x    y    z    A   B   C   D   E    F   

3	H    I    J    K    L   M   N   O   P    Q   

4   S    T    U    V    W   X   Y   Z   0    1   

5	3	 4	  5	   6    7   8   9   ~   `    !   

6   #    $    %    ^    &   *   (   )   -    -    

7   =    |    \    {    }   [   ]   :   ;    "    

8   <    >    ,    .    ?   /   k   v   G    R   

9	2	 @	 +	   ' 	0   0   0   0   0    0 
*/
uint encrypt_h=10;
uint encrypt_v=10;
uint encrypt_key_index=5;

char encrypt_key[5][10]={
	{'1','a','w','s','4','r','t','5','f','e'},
	{'2','5','t','7','g','8','s','h','b','k'},
	{'4','a','y','w','e','v','6','5','9','m'},
	{'2','r','q','s','4','w','3','5','p','n'},
	{'t','y','w','6','4','l','e','3','f','c'}
};

char encrypt_arr[10][10]={
	{'a','b','c','d','e','f','g','h','i','j'},
	{'l','m','n','o','p','q','r','s','t','u'},
	{'w','x','y','z','A','B','C','D','E','F'}, 
	{'H','I','J','K','L','M','N','O','P','Q'},
	{'S','T','U','V','W','X','Y','Z','0','1'},
	{'3','4','5','6','7','8','9','~','`','!'},
	{'#','$','%','^','&','*','(',')','-','-'},
	{'=','|','\\','{','}','[',']',':',';','\"'},
	{'<','>',',','.','?','/','k','v','G','R'},
	{'2','@','+','\'',' ','0','0','0','0','0'}
};
/*
int encryptstring(QString para,uint secindex,QString &out)
{
	para=para.trimmed();
	uint len=para.length();
	secindex=secindex%encrypt_key_index;
	uint i=0;
	uint found=0;
	int found_h=-1;
	int found_v=-1;
	while(i<len){
		found=0;
		uint m=0,n=0;
		for(m=0;m<encrypt_h;m++)
		{
			for(n=0;n<encrypt_v;n++ )
			{
				if(encrypt_arr[m][n]==para.at(i).toLatin1())
				{
					found=1;
					found_v=n;
					break;
				}
			}
			if(found)
			{
					found_h=m;
					break;
			}
		}
		if(found)
			out.append(encrypt_key[secindex][found_h]);
			out.append(encrypt_key[secindex][found_v]);
		i++;
	}
	return 1;
}

int decryptstring(QString para,uint secindex,QString &out)
{
	para=para.trimmed();
	uint len=para.length();
	if(len%2)
		return 1;
	secindex=secindex%encrypt_key_index;
	uint i=0;
	int found_h=-1;
	int found_v=-1;
	while(i<len){
		uint m=0;	
		for(m=0;m<encrypt_h;m++)
		{
			if(encrypt_key[secindex][m]==para.at(i).toLatin1())
			{
				found_h=m;
				break;
			}
			
		}
		for(m=0;m<encrypt_h;m++)
		{
			if(encrypt_key[secindex][m]==para.at(i+1).toLatin1())
			{
				found_v=m;
				break;
			}
			
		}
		i=i+2;
		out.append(encrypt_arr[found_h][found_v]);
	}
	return 1;
}
*/

int getkeylength()
{
	return encrypt_key_index;
}
/*
	process the url string:
	remove the end char:'/'
	example:http://www.sohu.com === http://www.sohu.com/
*/
int handleUrlString(QString& url)
{
	url=url.trimmed();
	while(url.endsWith("/"))
	{
			url.truncate(url.length()-1);
	}

	return 1;
}

uint qhashEx(QString str, int len)
{
    uint h = 0;
    int g=0;
	int i=0;
    while (len--) {
		QChar c=str.at(i++);
        h = ((h) << 4) +c.unicode();
        if ((g = (h & 0xf0000000)) != 0)
            h ^= g >> 23;
        h &= ~g;
    }
    return h;
}

uint getFirefoxBinPath(QString& ff_bin)
{
		QSettings ff_reg("HKEY_LOCAL_MACHINE\\Software\\Mozilla\\Mozilla Firefox",QSettings::NativeFormat);
		qDebug("firefox's version is %s",qPrintable(ff_reg.value("CurrentVersion","").toString()));
		QString firefox_v= ff_reg.value("CurrentVersion","").toString().trimmed();
		 ff_reg.beginGroup(firefox_v);
		 ff_reg.beginGroup("Main");		 
		QStringList keys = ff_reg.allKeys();
		if(keys.contains("PathToExe",Qt::CaseInsensitive)){
				ff_bin=ff_reg.value("PathToExe").toString();
				return 1;
		}
		return 0;
		 
}

uint getIEBinPath(QString& ie_bin)
{
		QSettings ff_reg("HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\App Paths",QSettings::NativeFormat);
		 ff_reg.beginGroup("IEXPLORE.EXE");		 
		QStringList keys = ff_reg.allKeys();
		ie_bin=ff_reg.value(".").toString();
		if(!ie_bin.isEmpty())
			return 1;
		else
			return 0;
}
uint setLanguage(int l)
{
	language=l;
	if(l<0||(l>=sizeof(gLanguageList)/sizeof(char*)))
		language=DEFAULT_LANGUAGE;
	return 0;	
}

QString tz::encrypt(QString para,uint secindex)
{
	QString out="";
	para=para.trimmed();
	uint len=para.length();
	secindex=secindex%encrypt_key_index;
	uint i=0;
	uint found=0;
	int found_h=-1;
	int found_v=-1;
	while(i<len){
		found=0;
		uint m=0,n=0;
		for(m=0;m<encrypt_h;m++)
		{
			for(n=0;n<encrypt_v;n++ )
			{
				if(encrypt_arr[m][n]==para.at(i).toLatin1())
				{
					found=1;
					found_v=n;
					break;
				}
			}
			if(found)
			{
					found_h=m;
					break;
			}
		}
		if(found)
			out.append(encrypt_key[secindex][found_h]);
			out.append(encrypt_key[secindex][found_v]);
		i++;
	}
	return out;
}
QString tz::decrypt(QString para,uint secindex)
{
	QString out="";
	para=para.trimmed();
	uint len=para.length();
	if(len%2)
		return 1;
	secindex=secindex%encrypt_key_index;
	uint i=0;
	int found_h=-1;
	int found_v=-1;
	while(i<len){
		uint m=0;	
		for(m=0;m<encrypt_h;m++)
		{
			if(encrypt_key[secindex][m]==para.at(i).toLatin1())
			{
				found_h=m;
				break;
			}
			
		}
		for(m=0;m<encrypt_h;m++)
		{
			if(encrypt_key[secindex][m]==para.at(i+1).toLatin1())
			{
				found_v=m;
				break;
			}
			
		}
		i=i+2;
		out.append(encrypt_arr[found_h][found_v]);
	}
	return out;
}
QString tz::tr(const char* index)
{
	QString res="unknow error";
   	if(QFile::exists(qApp->applicationDirPath()+"/data/language.dat")){
		QSettings langsetting(qApp->applicationDirPath()+"/data/language.dat",QSettings::IniFormat);	
		QByteArray langarray=langsetting.value(QString(index)+"/"+QString(gLanguageList[language]),"unknow error").toByteArray();
		res=QTextCodec::codecForName("UTF-8")->toUnicode(QString(langarray).toLatin1()); 
	}		  	
	return res;
}
struct browserinfo* tz::getbrowserInfo()
{
	return browserInfo;
}
QString tz::getBrowserName(uint id)
{
	int i = 0;
	while(!browserInfo[i].name.isEmpty())
	{
		if(browserInfo[i].id == id)
			return browserInfo[i].name;
		i++;
	}
	return "";
}

void tz::clearbmgarbarge(QSqlQuery* q,uint delId)
{
	//uint comefrom_s=0,comefrom_e=0;
	QString queryStr;
	int i = 0;
	while(!browserInfo[i].name.isEmpty())
	{
			queryStr.clear();
			queryStr=QString("delete from %1 where comeFrom=%2 and delId!=%3").arg(DB_TABLE_NAME).arg(browserInfo[i].id).arg(delId);
			q->exec(queryStr);		
			i++;
	}
}

uint tz::isExistInDb(QSqlQuery* q,const QString& name,const QString& fullpath,int frombrowsertype)
{
	{
		QString queryStr;
		uint id=0;
#if 1
		q->prepare("select id from "DB_TABLE_NAME" where comeFrom = ? and hashId=? and shortName = ? and fullPath=? limit 1");
		int i=0;
		q->bindValue(i++, frombrowsertype);
		q->bindValue(i++, qHash(name));
		q->bindValue(i++, name);
		q->bindValue(i++, fullpath);
		q->exec();
		if(q->next())
		{
			id=q->value(q->record().indexOf("id")).toUInt();
		}
		q->clear();
#else
		queryStr=QString("select id from %1 where comeFrom=%2 and hashId=%3 and shortName='%4' and fullPath='%5' limit 1").arg(DB_TABLE_NAME).arg(frombrowsertype).arg(qHash(name)).arg(name).arg(fullpath);
		qDebug("queryStr=%s",qPrintable(queryStr));
		if(q->exec(queryStr)){
						  QSqlRecord rec = q->record();
						   
						   int id_Idx = rec.indexOf("id"); // index of the field "name"
						   while(q->next()) {	
											id=q->value(id_Idx).toUInt();
										q->clear();
										return id;		
							}						
				}else{
					qDebug("%s query error",__FUNCTION__);
					}
		q->clear();
#endif
		return id;
		
	}

}
int tz::testFirefoxDbLock(QSqlDatabase* db)
{
	db->setConnectOptions(tr("QSQLITE_BUSY_TIMEOUT=%1").arg(TEST_DB_MAXINUM_TIMEOUT));
	QString queryStr=QString("select * from moz_bookmarks limit 1");
	QSqlQuery   query(queryStr, *db);
	if(query.exec()){
		qDebug("test firefox db successfuly!");
		db->setConnectOptions();
		return 1;
	}else{
		qDebug("test firefox db failed!");
		db->setConnectOptions();
		return 0;
	}
}

void tz::addItemToSortlist(const struct bookmark_catagory &bc,QList < bookmark_catagory > *list)
{
       // QDEBUG("add name=%s name_hash=%u",qPrintable(bc.name),bc.name_hash);
	int i=0;
	if(!list->size()) //empty
		{
			list->push_back(bc);
			return;
		}
	
	for(i=0;i<list->size();i++)
	{
		if(list->at(i).name_hash<bc.name_hash)
			continue;		
		list->insert(i,bc);		
		return;
	}
	if(i==list->size())
		{
			list->push_back(bc);
		}
}
//flag 0--file 1--dir

void tz::readDirectory(QString directory, QList < bookmark_catagory > *list, int level/*, uint flag*/)
{
	//if (level == 0)
	//	this->flag = flag;
	QString createTime, lastAccessTime, lastWriteTime;
	QDir qd(directory);
	QString dir = qd.absolutePath();
	QStringList dirs = qd.entryList(QDir::AllDirs | QDir::NoDotAndDotDot);


	for (int i = 0; i < dirs.count(); ++i)
	  {
		  QString cur = dirs[i];
		  if (cur.contains(".lnk"))
			  continue;
		   struct bookmark_catagory dir_bc;
		   dir_bc.name = dirs[i];
		  // dir_bc.name.trimmed();
		   dir_bc.name_hash=qhashEx(dir_bc.name,dir_bc.name.length());
		   dir_bc.link.clear();
		   dir_bc.link_hash=0;
		   dir_bc.flag = BOOKMARK_CATAGORY_FLAG;
		   dir_bc.level = level;
		  readDirectory(dir + "/" + dirs[i], &(dir_bc.list), level + 1/*,  flag*/);
		  addItemToSortlist(dir_bc,list);
	  }
	QStringList files = qd.entryList(QStringList("*.url"), QDir::Files, QDir::Unsorted);
	for (int i = 0; i < files.count(); ++i)
	  {
		  struct bookmark_catagory bc;
		  const QString FilePath(dir + "/" + files[i]);
		  QSettings favSettings (FilePath, QSettings::IniFormat);
		    {
			    struct bookmark_catagory dir_bc;
			    int dotIndex = files[i].lastIndexOf('.');
			    files[i].truncate(dotIndex);
			    dir_bc.link = favSettings.value("InternetShortcut/URL").toString();
			    if( !dir_bc.link.isEmpty())
			    {
			    	    QUrl url(dir_bc.link);
				    if (!url.isValid() || ((url.scheme().toLower() != QLatin1String("http"))&&(url.scheme().toLower() != QLatin1String("https")))) {
					//	qDebug()<<"unvalid http format!";
						break;
				    }
				    handleUrlString(dir_bc.link );
				    dir_bc.name = files[i];
				    dir_bc.name.trimmed();
				    dir_bc.name_hash=qhashEx(dir_bc.name,dir_bc.name.length());
					  
					   
				    dir_bc.link_hash=qhashEx(dir_bc.link,dir_bc.link.length());
				    dir_bc.flag = BOOKMARK_ITEM_FLAG;
				    dir_bc.level = level;			
				   // list->push_back(dir_bc);
				    addItemToSortlist(dir_bc,list);
			    	}
		    }
		  //items->push_back(CatItem(dir + "/" + files[i], files[i].mid(0,files[i].size()-4)));
	  }
}
int tz::getFirefoxVersion()
{
	int ver = 0;

	QSettings ff_reg("HKEY_LOCAL_MACHINE\\Software\\Mozilla\\Mozilla Firefox",QSettings::NativeFormat);
	qDebug("firefox's version is %s",qPrintable(ff_reg.value("CurrentVersion","").toString()));
	QString ff_v= ff_reg.value("CurrentVersion","").toString().trimmed();


 	if(!ff_v.isEmpty())
	{
		if(ff_v.at(0).isDigit())
		{
			if(QString(ff_v.at(0)).toInt()>=3)
				ver=FIREFOX_VERSION_3;
			else 
				ver=FIREFOX_VERSION_2;
		}
		else
			ver=0;
	}
		return ver;
}
bool tz::checkFirefoxDir(QString& path)
{
	if(!getFirefoxPath(path))
		return false;
	if(path.isNull()||path.isEmpty())
		return false;
	QDir ff_dir(path);
	if(!ff_dir.exists())
		return false;
}
bool tz::openFirefox3Db(QSqlDatabase& db,QString path)
{
	
	db = QSqlDatabase::addDatabase("QSQLITE", "dbFirefox");					
	QString ffpath=QString(path).append("/places.sqlite");
	db.setDatabaseName(ffpath);	
	//qDebug()<<"Open Firefox DB:"<<ffpath;
	if ( !db.open())  {
			// qDebug("connect %s failed",qPrintable(ff_path));     
			goto bad;
	 }else{ 
		//qDebug("connect database %s successfully!\n",qPrintable(ff_path));   
		 if(!tz::testFirefoxDbLock(&db)){
			qDebug()<<"firefox db is locked!";
			goto bad;
		 }
	}
	qDebug("Open Firefox DB successfully!");
	return true;	
bad:
	closeFirefox3Db(db);
	return false;
}
void tz::closeFirefox3Db(QSqlDatabase& db)
{
	if(db.isOpen())	
		db.close();
	QSqlDatabase::removeDatabase("dbFirefox");		
}

#if 0
void tz::prepareInsertQuery(QSqlQuery* q,CatItem& item)
{
	q->prepare("INSERT INTO "DB_TABLE_NAME
							"(fullPath, shortName, lowName,icon,usage,hashId,"
						   "groupId, parentId, isHasPinyin,comeFrom,hanziNums,pinyinDepth,"
						   "pinyinReg,alias1,alias2,shortCut,delId,args)"
						   "values("
							"? , ? , ? , ? , ? , ? ,"
							 "? , ? , ? , ? , ? , ? ,"
							  "? , ? , ? , ? , ? , ? "
						   ")");
						   q->bindValue("fullPath", item.fullPath);
						   q->bindValue("shortName", item.shortName);
						   q->bindValue("lowName", item.lowName);
						   q->bindValue("icon", item.icon);
						   q->bindValue("usage", item.usage);
						   q->bindValue("hashId", qHash(item.shortName));
						   q->bindValue("groupId", item.groupId);
						   q->bindValue("parentId", item.parentId);
						   q->bindValue("isHasPinyin", item.isHasPinyin);
						   q->bindValue("comeFrom", item.comeFrom);
						   q->bindValue("hanziNums", item.hanziNums);
						   q->bindValue("pinyinDepth", item.pinyinDepth);
						   q->bindValue("pinyinReg", item.pinyinReg);
						   q->bindValue("alias1", item.alias1);
						   q->bindValue("alias2", item.alias2);
						   q->bindValue("shortCut", item.shortCut);
						   q->bindValue("delId", item.delId);
						   q->bindValue("args", item.args
	);

}

void tz::bmintolaunchdb(QSqlQuery* q,QList < bookmark_catagory > *bc,int frombrowsertype,uint delId)
{

	foreach(bookmark_catagory item, *bc)
	{
		if (item.flag == BOOKMARK_CATAGORY_FLAG)
		{
			bmintolaunchdb(q,&(item.list),frombrowsertype,delId);
			
		}else{
				QString queryStr="";
				uint id=0;
				if(id=tz::isExistInDb(q,item.name,item.link,frombrowsertype)){
					//queryStr=QString("update  %1 set delId=%2 where id=%3").arg(DB_TABLE_NAME).arg(delId).arg(id);
					q->prepare("update "DB_TABLE_NAME" set delId = ? where id= ? ");
					int i=0;
					q->bindValue(i++, delId);
					q->bindValue(i++, id);
					
				}				
				else
				{
					   CatItem citem(item.link,item.name,frombrowsertype);
#if 1
					   prepareInsertQuery(q,citem);
#else
					   queryStr=QString("INSERT INTO %1 (fullPath, shortName, lowName,"
					   "icon,usage,hashId,"
					   "groupId, parentId, isHasPinyin,"
					   "comeFrom,hanziNums,pinyinDepth,"
					   "pinyinReg,alias1,alias2,shortCut,delId,args) "
					   "VALUES ('%2','%3','%4','%5',%6,%7,%8,%9,%10,%11,%12,%13,'%14','%15','%16','%17',%18,'%19')").arg(DB_TABLE_NAME).arg(citem.fullPath) .arg(citem.shortName).arg(citem.lowName)
					   .arg(citem.icon).arg(citem.usage).arg(qHash(item.name))
					   .arg(citem.groupId).arg(citem.parentId).arg(citem.isHasPinyin)
					   .arg(citem.comeFrom).arg(citem.hanziNums).arg(citem.pinyinDepth)
					   .arg(citem.pinyinReg).arg(citem.alias1).arg(citem.alias2).arg(citem.shortCut).arg(delId).arg(citem.args);
#endif
				}
				//QDEBUG("%s %s",__FUNCTION__,qPrintable(queryStr));
				  q->exec();
				//  q->clear();
		}		
	}

}
#endif

