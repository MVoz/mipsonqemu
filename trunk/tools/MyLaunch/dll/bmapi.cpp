#include <bmapi.h>
#include <stdio.h>
#include <QDateTime>
#include <QString>
#include <QStringList>
#include <QSettings>
#include <QTextCodec>
#include <qDebug>
#include <QCoreApplication>
uint gMaxGroupId=0;
QString gUpdatetime;
bool gPostError=0;
uint gPostResponse=0;
uint gBmId=0;
int language=DEFAULT_LANGUAGE;
char* gLanguageList[]={"chinese","english"};

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
			QDEBUG("delete file %s ",qPrintable(files[i]));
			dir.remove(dirPath+ "/"+files[i]);
		}
	QStringList dirs = dir.entryList(QDir::AllDirs | QDir::NoDotAndDotDot);
	for(int i=0;i<dirs.size();i++)
	{
			QDEBUG("delete directory %s ",qPrintable(dirs[i]));
			deleteDirectory(dirPath+ "/"+dirs[i]);
	}
	QDEBUG("deleteDirectory %s ",qPrintable(dirPath));
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


QString translate::tr(const char* index)
{
	
   	if(QFile::exists(qApp->applicationDirPath()+"/data/language.dat")){
		QSettings langsetting(qApp->applicationDirPath()+"/data/language.dat",QSettings::IniFormat);	
		QByteArray langarray=langsetting.value(QString(index)+"/"+QString(gLanguageList[language]),"unknow error").toByteArray();
		QString res=QTextCodec::codecForName("UTF-8")->toUnicode(langarray);
		return res;
	}
	return "unknow error";
}
QString translate::encrypt(QString para,uint secindex)
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
QString translate::decrypt(QString para,uint secindex)
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



