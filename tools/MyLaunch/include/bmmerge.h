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

#include <config.h>
#include <bmapi.h>
#include <bmpost.h>
#include <bmxml.h>

#if defined(MERGE_THREAD_DLL)
#define MERGE_THREAD_CLASS_EXPORT __declspec(dllexport)
#else
#define MERGE_THREAD_CLASS_EXPORT __declspec(dllimport)
#endif
#define LOCAL_EXIST_OFFSET  2
#define LASTUPDATE_EXIST_OFFSET 1
#define SERVER_EXIST_OFFSET 0

#define HANDLE_ITEM_LOCAL 0
#define HANDLE_ITEM_SERVER 1

#define BM_ITEM_MERGE_STATUS(local,last,server) ((((local) >= 0) ? 1 : 0) << LOCAL_EXIST_OFFSET) + ((((last) >= 0) ? 1 : 0) << LASTUPDATE_EXIST_OFFSET) + ((((server) >= 0) ? 1 : 0) << SERVER_EXIST_OFFSET)

enum BM_MERGE_STATUS{
	MERGE_STATUS_NONE=0,
	MERGE_STATUS_LOCAL_0_LAST_0_SERVER_1, //only exist in server,need download to local
	MERGE_STATUS_LOCAL_0_LAST_1_SERVER_0,//only exist in lastupdate
	MERGE_STATUS_LOCAL_0_LAST_1_SERVER_1,//exist in server&lastupdate
	MERGE_STATUS_LOCAL_1_LAST_0_SERVER_0,//only exist in local
	MERGE_STATUS_LOCAL_1_LAST_0_SERVER_1,//exist in server&local
	MERGE_STATUS_LOCAL_1_LAST_1_SERVER_0,//exist in local&lastupdate
	MERGE_STATUS_LOCAL_1_LAST_1_SERVER_1////exist in local,lastupdate&server
};

class MERGE_THREAD_CLASS_EXPORT bmMerge:public QThread
{
	Q_OBJECT;
public:
	bmMerge(QObject * parent = 0,QSqlDatabase* b=0,QSettings* s=0,QString u="",QString p="");
	~bmMerge();
public:
	void run();
	int isBmEntryEqual(const bookmark_catagory& b,const bookmark_catagory& bm);
	int copyBmCatagory(bookmark_catagory * dst, bookmark_catagory * src);
	void postItemToHttpServer(bookmark_catagory * bc, int action, int parentId,int browserType);
	void downloadToLocal(bookmark_catagory * bc, int action, QString path,int browserType,uint local_parentId);
	void handleBmData();
	int bmMergeAction(QList < bookmark_catagory > *localList, QList < bookmark_catagory > *lastupdateList, QList < bookmark_catagory > *serverList, QList < bookmark_catagory > *resultList, uint parentId,QString iePath,int browserType,uint local_parentId
		#ifdef POST_DOWN_AFTER_MERGE
			,uint doit
		#endif
	);
	int bmItemInList(bookmark_catagory * item, QList < bookmark_catagory > *list);
	void handleItem(bookmark_catagory * item, QList < bookmark_catagory > *list,QString &path, int status, uint parentId,int browserType,int local_parentId,int localOrServer
		#ifdef POST_DOWN_AFTER_MERGE
			,uint doit
		#endif
		);
	bool deleteIdFromFirefoxDb(uint id);	
	void productFFId(QString & randString,int length);
	void setTerminated(uint flag){terminatedFlag=flag;}
	bool checkXmlfileFromServer();
	bool loadLastupdateData(bmXml **lastUpdate);		
	void storeLocalbmData(const QString& path,struct browserinfo* b,uint* browserenable,QList < bookmark_catagory > *result,bmXml **lastUpdate,const QString& time);
	void setMergeStatus(QString& n,QString& f,uint i,uint a,uint s);
signals:
	void done(bool error);
	void mergeStatusNotify(int);
public:
	DoNetThread* postHttp;
	
	QFile *file;
	QSettings* settings;	
	
	QSqlDatabase ff_db;
	QSqlDatabase* db;
	
	uint modifiedInServer;
	volatile uint mergestatus;
	int firefox_version;
	volatile uint terminatedFlag;

//	QString iePath;
	QString filename_fromserver;
	QString username;
	QString password;
	
	void setRandomFileFromserver(QString &s);
public:
	static void bmintolaunchdb(QSqlQuery* q,QList < bookmark_catagory > *bc,int comefrom,uint delId);
#ifdef TOUCH_ANY_DEBUG
	static void dumpBcList(QList<bookmark_catagory>* s);
#endif
	static void keeplaunchdb(QSqlQuery* q,int comefrom,uint delId);;
};

#endif
