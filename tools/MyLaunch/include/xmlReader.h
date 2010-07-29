#ifndef XML_READER_H
#define XML_READER_H
#include <config.h>
#include <QXmlStreamReader>
#include <QString>
#include <QTime>
#include <QList>
#include <QDateTime>
#include <QTextStream>
#include <QSettings>
#include <catalog>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#if defined(XMLREADER_DLL)
#define XMLREADER_DLL_CLASSEXPORT __declspec(dllexport)
#define XMLREADER_DLL_FUNCEXPORT extern "C" __declspec(dllexport)
#else
#define XMLREADER_DLL_CLASSEXPORT __declspec(dllimport)
#define XMLREADER_DLL_FUNCEXPORT extern "C" __declspec(dllimport)
#endif

#define MASK_TYPE 0x03

#define XML_FROM_HTTPSERVER 1
#define XML_FROM_IEFAV 2
#define XML_FROM_FIREFOXFAV 3
#define XML_FROM_GREENBROWSERFAV 4
#define XML_FROM_LASTUPDATE 5



//#define BROWSER_TYPE_IE   1
//#define BROWSER_TYPE_FIREFOX 2
//#define BROWSER_TYPE_OPERA 3

#define DATA_TYPE_STRING 0
#define DATA_TYPE_DATETIME 1

#define FIREFORX3_ROOT_ID 1


class XMLREADER_DLL_CLASSEXPORT Firefox_BM{
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



#define BM_WRITE_HEADER 1
#define BM_WRITE_END 2
#define BM_WRITE_MASK 0x3
class XMLREADER_DLL_CLASSEXPORT  XmlReader:public QXmlStreamReader
{
public:
	XmlReader(QIODevice * device,QSettings* setting):QXmlStreamReader(device),settings(setting){
		setDevice(device);
	}
	XmlReader();
public:

	// void readStream(uint flag);
	void readStream(int browserType);
	void readCategoryElement();
	void readItemElement();
	void readBookmarkElement();
	void CreateItem(int level,QList<bookmark_catagory>*list,uint parentId);
	void CreateCatagory(int level,QList<bookmark_catagory>* list,uint groupId,uint parentId);   
	void importItem(struct bookmark_catagory *bc,int item);
	// void importName(struct bookmark_catagory*bc);
	// void importLink(struct bookmark_catagory*bc);
	// void importDescription(struct bookmark_catagory*bc);
	// void importAdddate(struct bookmark_catagory*bc);
	// void importModifydate(struct bookmark_catagory*bc);
	void dumpBookmarkList(int level,QList<bookmark_catagory> list);
	void buildLocalBmSetting(int level,QString path,QList<bookmark_catagory> list,QTextStream *os);
	//  static void writeToFile(QTextStream* os,const char *cformat, ...);

	void getBookmarkCatalog(QList<CatItem>* items);
	void getCatalog(QList<CatItem>* items);
	// void importCatItemName(CatItem *item);
	// void importCatItemFullPath(CatItem *item);
	//  void importCatItemComefrom(CatItem *item);
	void importCatItem(CatItem *item,int im);
	void readBrowserType(int browserType);
	void setFirefoxDb(QSqlDatabase* db);

	/*******************for firefox2******************************/
	int readFirefoxBookmark2(QFile& file);
	void init_ff_bm();
	void handler_line(QString line,int type);
	void outToFile(QTextStream& os);
	void item_end(QTextStream& os,int type,int& finish);
	//  void    importID(struct bookmark_catagory*bc);
	//   void    importbmid(struct bookmark_catagory*bc);
	//  void   importFeedurl(struct bookmark_catagory*bc);
	//  void   importIcon(struct bookmark_catagory*bc);
	//  void   importLastCharset(struct bookmark_catagory*bc);		
	//   void  importPersonalToolbarFolder(struct bookmark_catagory*bc);
	//   void importLastVisit(struct bookmark_catagory*bc);
	//  void importHr(struct bookmark_catagory *bc);

public:
	QList<bookmark_catagory> bm_list;
	QSettings* settings;
	QDateTime serverLastUpdateTime;
	//	uint maxGroupId;
	uint flag;	
	//QString ff_excludeId;
	QSqlDatabase* ff_db;
	QList<Firefox_BM> ff_bm;
	QString updateTime;
public:
	/*for ie*/
	//   static void readDirectory(QString directory,QList<bookmark_catagory>* list,int level/*,uint flag*/);
	static void productFirefox2BM(int level,QList < bookmark_catagory > *list, QTextStream* os);
	//   static void addItemToSortlist(const struct bookmark_catagory &bc,QList < bookmark_catagory > *list);
	/*for firefox*/
	static int readFirefoxBookmark3(QSqlDatabase *db,QList<bookmark_catagory>* list);
	static int outChildItem(int id,QSqlDatabase *db,QTextStream& os,QList < bookmark_catagory > *list,QString& excludeid);
	static QString productExcludeIdStr(QSqlDatabase *db);
	static void bmListToXml(int flag,QList<bookmark_catagory> *list,QTextStream *os,int browserType,int start,QString updateTime);
	static  void bmItemToFile(QTextStream * os,bookmark_catagory& bm);

};

#endif
