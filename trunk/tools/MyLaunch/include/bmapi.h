#ifndef BMAPI_H
#define BMAPI_H
#include <config.h>
#include "globals.h"

#if defined(BMAPI_DLL)
#define BMAPI_DLL_CLASSEXPORT __declspec(dllexport)
#define BMAPI_DLL_FUNCEXPORT extern "C" __declspec(dllexport)
#else
#define BMAPI_DLL_CLASSEXPORT __declspec(dllexport)
#define BMAPI_DLL_FUNCEXPORT  extern "C" __declspec(dllimport)
#endif

#define GET_MODE 0
#define SET_MODE 1

enum BROWSERINFO_OP{
	BROWSERINFO_OP_LASTUPDATE=0,
	BROWSERINFO_OP_FROMSERVER,
	BROWSERINFO_OP_LOCAL
};
struct BMAPI_DLL_CLASSEXPORT dbtableinfo{
	unsigned char id;
	QString name;
	unsigned char priority;//more less more priority
};

struct BMAPI_DLL_CLASSEXPORT browserinfo{
	QString name;
	bool enable; 
	bool defenable;
	bool lastupdate; //import lastupdate success?
	bool fromserver;//import fromserver success?
	bool local;//import local success
	int id;
};

//BMAPI_DLL_FUNCEXPORT struct browserinfo* getbrowserInfo();

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
//BMAPI_DLL_FUNCEXPORT int decryptstring(QString para,uint secindex,QString &out);
//BMAPI_DLL_FUNCEXPORT int  encryptstring(QString para,uint secindex,QString& out);
BMAPI_DLL_FUNCEXPORT int getkeylength();
BMAPI_DLL_FUNCEXPORT int handleUrlString(QString& url);
BMAPI_DLL_FUNCEXPORT void setUpdatetime(QString time);
BMAPI_DLL_FUNCEXPORT void getUpdatetime(QString& time);
BMAPI_DLL_FUNCEXPORT uint qhashEx(QString str, int len);
BMAPI_DLL_FUNCEXPORT void setBmId(uint bmid);
BMAPI_DLL_FUNCEXPORT uint getBmId();
BMAPI_DLL_FUNCEXPORT uint getFirefoxBinPath(QString& ff_bin);
BMAPI_DLL_FUNCEXPORT uint getIEBinPath(QString& ff_bin);
BMAPI_DLL_FUNCEXPORT uint setLanguage(int l);
BMAPI_DLL_FUNCEXPORT bool getBrowserEnable(uint id);
BMAPI_DLL_FUNCEXPORT void setBrowserEnable(QSettings *s);
BMAPI_DLL_FUNCEXPORT void setBrowserInfoOpFlag(uint id,enum BROWSERINFO_OP type);
BMAPI_DLL_FUNCEXPORT void clearBrowserInfoOpFlag(uint id);



extern int language;
enum BOOKMARK_CATAGORY_ITEM{
	BOOKMARK_CATAGORY_NAME=0,
	BOOKMARK_CATAGORY_LINK,
	BOOKMARK_CATAGORY_DESCIPTION,
	BOOKMARK_CATAGORY_ICON,
	BOOKMARK_CATAGORY_FEEDURL,
	BOOKMARK_CATAGORY_LAST_CHARSET,
	BOOKMARK_CATAGORY_PERSONAL_TOOLBAR_FOLDER,
	BOOKMARK_CATAGORY_ID,
	BOOKMARK_CATAGORY_BMID,
	BOOKMARK_CATAGORY_ADDDATE,
	BOOKMARK_CATAGORY_MODIFYDATE,
	BOOKMARK_CATAGORY_LAST_VISIT,
	BOOKMARK_CATAGORY_FLAGX,
	BOOKMARK_CATAGORY_GROUPID,
	BOOKMARK_CATAGORY_PARENTID,
	BOOKMARK_CATAGORY_LEVEL,
	BOOKMARK_CATAGORY_HR,
	BOOKMARK_CATAGORY_NAME_HASH,
	BOOKMARK_CATAGORY_LINK_HASH,
	BOOKMARK_CATAGORY_MAX
};
struct BMAPI_DLL_CLASSEXPORT  bookmark_catagory{
	QString name;
	QString link;
	QString desciption;
	QString icon;
	QString feedurl;
	QString last_charset;
	QString personal_toolbar_folder;
	QString id;
	QDateTime  addDate;
	QDateTime modifyDate;
	QString last_visit;
	uint flag;
	uint groupId;
	uint parentId;
	uint bmid;
	uint level;
	uint hr;
	/*for acclerate find*/
	uint name_hash;
	uint link_hash;
	QList<bookmark_catagory> list;

};

enum BMAPI_DLL_CLASSEXPORT RUNPARAMETER{
	RUN_PARAMETER_START = 0,
	RUN_PARAMETER_TESTNET_RESULT,
	RUN_PARAMETER_NETPROXY_ENABLE,
	RUN_PARAMETER_NETPROXY_USING,
	RUN_PARAMETER_END	
};
class BMAPI_DLL_CLASSEXPORT  tz {
public:
	tz(){};
	~tz(){};

public :
	static QString tr(const char* index);
	static QString encrypt(QString para,uint secindex);
	static QString decrypt(QString para,uint secindex);
	static struct browserinfo* getbrowserInfo();
	static char* getstatusstring(int i);
	static void clearbmgarbarge(QSqlQuery* q,uint delId);
	static uint isExistInDb(QSqlQuery* q,const QString& name,const QString& fullpath,int frombrowsertype);
	static int testFirefoxDbLock(QSqlDatabase* db);
	static QString getBrowserName(uint id);
	static void readDirectory(QString directory,QList<bookmark_catagory>* list,int level/*,uint flag*/);
	//   static void productFirefox2BM(int level,QList < bookmark_catagory > *list, QTextStream* os);
	static void addItemToSortlist(const struct bookmark_catagory &bc,QList < bookmark_catagory > *list);
	static int getFirefoxVersion();
	static bool checkFirefoxDir(QString& path);//get & check firefox directory
	static bool openFirefox3Db(QSqlDatabase& db,QString path);
	static void closeFirefox3Db(QSqlDatabase& db);
	static QString getIePath();
	static QString getPinyin(const char* s);
	static QString fileMd5(QString filename);
	static uint registerInt(int mode,const QString& path,const QString& name,uint val);
	static QString registerString(int mode,const QString& path,const QString& name,QString val);
	//static int testNetResult(int,int);
	static int runParameter(int,int,int);
	static void netProxy(int ,QSettings*,QNetworkProxy**);
	static int GetCpuUsage();
	static void  initDbTables(QSqlDatabase& db,QSettings *s,int flag);
	static QString dbTableName(uint);
	static struct dbtableinfo* dbTableInfo(uint id);
	static QList<struct dbtableinfo*> dbTableInfoList();
	static QString GetShortcutTarget(const QString& LinkFileName);
	static void _clearShortcut(QSqlDatabase *db,int type);
	static QString getDomain(const QString& fullpath);
	static QString getUserIniDir(int ,const QString&);
};

#define DBTABLEINFO_NAME(x)  (tz::dbTableInfo((x))->name)
inline uint get_search_result_num(QSettings* s)
{
	uint num =s->value("numresults",10).toUInt();
	return num>10?(10):((num==0)?1:num);

}

//int setDirectoryTimeIncludeAllFiles(QString path);
#endif
