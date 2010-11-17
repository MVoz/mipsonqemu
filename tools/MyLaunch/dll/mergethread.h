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
#include "config.h"
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

enum{
	MERGE_STATUS_SUCCESS_NO_MODIFY=0,
	MERGE_STATUS_SUCCESS_WITH_MODIFY,
	MERGE_STATUS_FAIL,
	MERGE_STATUS_FAIL_LOGIN
};

class MERGE_THREAD_CLASS_EXPORT mergeThread:public QThread
{
	Q_OBJECT;
public:
	mergeThread(QObject * parent = 0,QSqlDatabase* b=0,QSettings* s=0,QString u="",QString p="");
	~mergeThread();
public:
	void run();
	int isBmEntryEqual(const bookmark_catagory& b,const bookmark_catagory& bm);
	int copyBmCatagory(bookmark_catagory * dst, bookmark_catagory * src);
	void postItemToHttpServer(bookmark_catagory * bc, int action, int parentId,int browserType);
	void downloadToLocal(bookmark_catagory * bc, int action, QString path,int browserType,uint local_parentId);
	void handleBmData();
	int bmMerge(QList < bookmark_catagory > *localList, QList < bookmark_catagory > *lastupdateList, QList < bookmark_catagory > *serverList, QList < bookmark_catagory > *resultList, uint parentId,QString iePath,int browserType);
	int bmItemInList(bookmark_catagory * item, QList < bookmark_catagory > *list);
	void handleItem(bookmark_catagory * item, QList < bookmark_catagory > *list,QString &path, int status, uint parentId,int browserType,int local_parentId,int localOrServer);
	void deleteIdFromDb(uint id);
	void productFFId(QString & randString,int length);
	void setTerminated(uint flag){	terminatedFlag=flag;}
	bool checkXmlfileFromServer();
	bool loadLastupdateData(struct browserinfo* b,int modifiedInServer,XmlReader **lastUpdate,const QString filepath,uint *browserenable);		
	void storeLocalbmData(const QString path,struct browserinfo* b,uint* browserenable,QList < bookmark_catagory > *result,XmlReader **lastUpdate,const QString time);

signals:
	void done(bool error);
	void mgUpdateStatusNotify(int flag,int status);
public:
	postHttp * posthp;
	
	QFile *file;
	QSettings* settings;	
	
	QSqlDatabase ff_db;
	QSqlDatabase* db;
	
	uint modifiedInServer;
	uint status;
	int firefox_version;
	volatile uint terminatedFlag;

	QString iePath;
	QString filename_fromserver;
	QString username;
	QString password;
	
	void setRandomFileFromserver(QString &s);
	void clearObject();

public:
	static void bmintolaunchdb(QSqlQuery* q,QList < bookmark_catagory > *bc,int frombrowsertype,uint delId);
	static void dumpBcList(QList<bookmark_catagory>* s);
};

#endif
