#ifndef BMAPI_H
#define BMAPI_H
#include <config.h>
#include <QString>
#include <QStringList>
#include <QDir>
#include <windows.h>
#include <log.h>
#include <QSettings>
 #include <QDataStream>
 #include <QFile>
 #include <QCoreApplication>
 #ifdef Q_WS_WIN
#include <windows.h>
#include <shlobj.h>
#include <tchar.h>
#endif
#if defined(BMAPI_DLL)
#define BMAPI_DLL_CLASSEXPORT __declspec(dllexport)
#define BMAPI_DLL_FUNCEXPORT extern "C" __declspec(dllexport)
#else
#define BMAPI_DLL_CLASSEXPORT __declspec(dllexport)
#define BMAPI_DLL_FUNCEXPORT  extern "C" __declspec(dllimport)
#endif


extern uint gMaxGroupId;
/*
extern "C" __declspec(dllexport) void fun3();
class CLASSEXPORT  mylibclass {
public:
	mylibclass(){};
	~mylibclass(){};
public :
	void func(){printf("\n mylibclass api \n");}
	void func2();

};
*/
#define DESKTOP_WINDOWS 0
//BMAPI_DLL_FUNCEXPORT int  getFileTime(QString filename,QString* createTime,QString* lastAccessTime,QString* lastWriteTime,int flag);
//BMAPI_DLL_FUNCEXPORT int  setFileTime(QString filename,QString createTime,QString* lastAccessTime,QString* lastWriteTime,int flag);
BMAPI_DLL_FUNCEXPORT int deleteDirectory(QString path);
BMAPI_DLL_FUNCEXPORT void runProgram(QString path, QString args) ;
BMAPI_DLL_FUNCEXPORT BOOL GetShellDir(int iType, QString & szPath);
BMAPI_DLL_FUNCEXPORT bool getUserLocalFullpath(QSettings* settings,QString filename,QString& dest);
BMAPI_DLL_FUNCEXPORT int getDesktop();
BMAPI_DLL_FUNCEXPORT void SetColor(unsigned short ForeColor,unsigned short BackGroundColor);
BMAPI_DLL_FUNCEXPORT quint16 getFileChecksum(QFile *f);
BMAPI_DLL_FUNCEXPORT int getFirefoxPath(QString &path);
BMAPI_DLL_FUNCEXPORT void setMaxGroupId(uint id);
BMAPI_DLL_FUNCEXPORT uint getMaxGroupId();
BMAPI_DLL_FUNCEXPORT void setPostError(bool err);
BMAPI_DLL_FUNCEXPORT bool getPostError();
BMAPI_DLL_FUNCEXPORT void setPostResponse(uint type);
BMAPI_DLL_FUNCEXPORT uint getPostResponse();
BMAPI_DLL_FUNCEXPORT int decryptstring(QString para,uint secindex,QString &out);
BMAPI_DLL_FUNCEXPORT int  encryptstring(QString para,uint secindex,QString& out);
BMAPI_DLL_FUNCEXPORT int getkeylength();
BMAPI_DLL_FUNCEXPORT int handleUrlString(QString& url);
BMAPI_DLL_FUNCEXPORT void setUpdatetime(QString time);
BMAPI_DLL_FUNCEXPORT void getUpdatetime(QString& time);
BMAPI_DLL_FUNCEXPORT uint qhashEx(QString str, int len);
BMAPI_DLL_FUNCEXPORT void setBmId(uint bmid);
BMAPI_DLL_FUNCEXPORT uint getBmId();
BMAPI_DLL_FUNCEXPORT uint getFirefoxBinPath(QString& ff_bin);
BMAPI_DLL_FUNCEXPORT uint getIEBinPath(QString& ff_bin);
BMAPI_DLL_FUNCEXPORT uint getLanguage(QString str,QString lang,QString& res);


//int setDirectoryTimeIncludeAllFiles(QString path);
#endif
