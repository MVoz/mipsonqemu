/****************************************************************************
**
** Copyright (C) 2008 Nokia Corporation and/or its subsidiary(-ies).
** Contact: Qt Software Information (qt-info@nokia.com)
**
** This file is part of the example classes of the Qt Toolkit.
**
** Commercial Usage
** Licensees holding valid Qt Commercial licenses may use this file in
** accordance with the Qt Commercial License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Nokia.
**
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License versions 2.0 or 3.0 as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file.  Please review the following information
** to ensure GNU General Public Licensing requirements will be met:
** http://www.fsf.org/licensing/licenses/info/GPLv2.html and
** http://www.gnu.org/copyleft/gpl.html.  In addition, as a special
** exception, Nokia gives you certain additional rights. These rights
** are described in the Nokia Qt GPL Exception version 1.3, included in
** the file GPL_EXCEPTION.txt in this package.
**
** Qt for Windows(R) Licensees
** As a special exception, Nokia, as the sole copyright holder for Qt
** Designer, grants users of the Qt/Eclipse Integration plug-in the
** right for the Qt/Eclipse Integration to link to functionality
** provided by Qt Designer and its related libraries.
**
** If you are unsure which license is appropriate for your use, please
** contact the sales department at qt-sales@nokia.com.
**
****************************************************************************/

#ifndef MERGE_THREAD_H
#define MERGE_THREAD_H

#include <QObject>
#include <xmlreader.h>
#include <QString>
#include <QThread>
#include <QtNetwork/QHttp>
#include <QBuffer>
#include <QString>
#include <QEventLoop>
#include <log.h>
#include <boost/shared_ptr.hpp>

#include <QtNetwork/QHttpResponseHeader>
#include <QTimer>
#include <QFile>
#include <config.h>
#include <QSettings>
#include <QTimerEvent>
#include <windows.h>
#include <bmapi.h>
#include <QtCore/qobject.h>
#include "posthttp.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>

#include <QtSql>


using namespace boost;
#if defined(MERGE_THREAD_DLL)
#define MERGE_THREAD_CLASS_EXPORT __declspec(dllexport)
#else
#define MERGE_THREAD_CLASS_EXPORT __declspec(dllimport)
//#define MERGE_THREAD_CLASS_EXPORT 
#endif
#define LOCAL_EXIST_OFFSET  2
#define LASTUPDATE_EXIST_OFFSET 1
#define SERVER_EXIST_OFFSET 0

#define FIREFOX_VERSION_2 2
#define FIREFOX_VERSION_3 3

#define HANDLE_ITEM_LOCAL 0
#define HANDLE_ITEM_SERVER 1



class MERGE_THREAD_CLASS_EXPORT mergeThread:public QThread
{
	Q_OBJECT
      public:
	 mergeThread(QObject * parent = 0,QSqlDatabase* b=0,QSettings* s=0,QString path=""):QThread(parent),db(b),settings(s),iePath(path)
	{
		file = NULL;
		localxmlFile = NULL;
		serverxmlFile = NULL;;
		ie_xmlLastUpdate = NULL;;
		firefox_xmlLastUpdate = NULL;;
		opera_xmlLastUpdate = NULL;;
		ie_xmlHttpServer = NULL;;
		firefox_xmlHttpServer = NULL;;
		opera_xmlHttpServer = NULL;;
		ieFavReader = NULL;;
		firefoxReader = NULL;;
		ie_enabled=settings->value("adv/ckSupportIe",true).toBool();
	        firefox_enabled=settings->value("adv/ckSupportFirefox",false).toBool();
	        opera_enabled=settings->value("adv/ckSupportOpera",false).toBool();
		firefox_version=0;
		modifiedFlag=0;
		terminatedFlag=0;
	}
	 ~mergeThread()
	{
		if (!IS_NULL(file))
		  {
			  file->close();
			  delete file;
			  file = NULL;
		  }
	}
      public:
	 void run();
	 int bookmarkMerge(QString path, QList < bookmark_catagory > *retlist, QList < bookmark_catagory > *localBmList, QList < bookmark_catagory > *serverBmList, QString localDirName, QDateTime lastUpdateTime, int flag, int type);
	 int isBmEntryEqual(const bookmark_catagory& b,const bookmark_catagory& bm);
	//int findItemFromBMList(QString path,bookmark_catagory bm,QList<bookmark_catagory> *bmList,bookmark_catagory*  bx,QDateTime LastUpdateTime,int flag);
	// int findItemFromBMList(QString path, bookmark_catagory bm, QList < bookmark_catagory > *bmList, int *bx, QDateTime LastUpdateTime, int flag);
	int copyBmCatagory(bookmark_catagory * dst, bookmark_catagory * src);
	void postItemToHttpServer(bookmark_catagory * bc, int action, int parentId,int browserType);
	void downloadToLocal(bookmark_catagory * bc, int action, QString path,int browserType,uint local_parentId);
	void handleBmData(QString& iePath,int& maxGroupId);
	//int isExistInLastUpdateList(QString path, bookmark_catagory * bm);
	int bmMerge(QList < bookmark_catagory > *localList, QList < bookmark_catagory > *lastupdateList, QList < bookmark_catagory > *serverList, QList < bookmark_catagory > *resultList, QString localDirName,QString& iePath,int browserType);
	int bmMergeWithoutModifyInServer(QList < bookmark_catagory > *localList, QList < bookmark_catagory > *lastupdateList, QList < bookmark_catagory > *resultList, QString localDirName,QString& iePath,int browserType);
	
	int bmItemInList(bookmark_catagory * item, QList < bookmark_catagory > *list);
	void handleItem(bookmark_catagory * item, int ret, QString dir, uint parentId, QList < bookmark_catagory > *list,QString &iePath,int browserType,int local_parentId,int localOrServer);
	void deleteIdFromDb(uint id);
	void productFFId(QString & randString,int length);

	int testFirefoxDbLock(QSqlDatabase& db);
	void setTerminated(uint flag){
			terminatedFlag=flag;
		}
      signals:
	void done(bool error);
	void mgUpdateStatusNotify(int flag,int status,QString str);
   public:
	postHttp * posthp;
	QFile *file;
	QList < bookmark_catagory > mergeBmList;
	QFile *localxmlFile;
	QFile *serverxmlFile;
	XmlReader *ie_xmlLastUpdate;
	XmlReader *firefox_xmlLastUpdate;
	XmlReader *opera_xmlLastUpdate;
	XmlReader *ie_xmlHttpServer;
	XmlReader *firefox_xmlHttpServer;
	XmlReader *opera_xmlHttpServer;
	XmlReader *ieFavReader;
	XmlReader *firefoxReader;
	//QDateTime* updateTime;
	QSettings* settings;
	QString iePath;
	int GroupId;
	int firefox_version;
	QSqlDatabase ff_db;
	bool ie_enabled;
	bool firefox_enabled;
	bool opera_enabled;	
	QSqlDatabase* db;
	uint modifiedInServer;
	uint modifiedFlag;
	volatile uint terminatedFlag;
public:
	//static uint isExistInDb(QSqlQuery* q,const QString& name,const QString& fullpath,int frombrowsertype);
	static void bmintolaunchdb(QSqlQuery* q,QList < bookmark_catagory > *bc,int frombrowsertype,uint delId);
	static void prepareInsertQuery(QSqlQuery* q,CatItem& item);	
//	static void deletebmgarbarge(QSqlQuery* q,uint delId);
};

#endif
