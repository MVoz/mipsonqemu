/*
Launchy: Application Launcher
Copyright (C) 2007  Josh Karlin

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

#ifndef OPTIONS_H
#define OPTIONS_H
#include <QString>
#include <QStringList>
#include <QList>
#include <config.h>
#include <globals.h>
#include <QtWebKit/QWebView>
#include <QtWebKit/QWebFrame>
#include <QResource>
#include <QMenu>
#include <QSettings>
#include <QContextMenuEvent>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QNetworkProxy>
#include <QNetworkRequest>
#include <updaterThread>


#include "bookmark_sync.h"
#include "synchronizeDlg.h"
#if defined(OPTIONS_DLL)
#define OPTIONS_CLASS_EXPORT __declspec(dllexport)
#else
#define OPTIONS_CLASS_EXPORT  __declspec(dllimport)
#endif
typedef struct cmd_list{
	qint32 index;
	QString name;
	QString base;
	QString parameters;
}CMD_LIST;
class OPTIONS_CLASS_EXPORT OptionsDlg:public QDialog
{
	Q_OBJECT
 public:
	OptionsDlg(QWidget * parent = 0,QDateTime*d=0,QSettings *s=0,QString path="",QSqlDatabase *db=NULL,void* catalogbuilder=NULL);
	~OptionsDlg();
public:
	QWebView *webView;
	synchronizeDlg *syncDlg;
	synchronizeDlg *updaterDlg;
	updaterThread* updaterthread;
	QStringList metaKeys;
	QStringList actionKeys;
	QList < int >iMetaKeys;
	QList < int >iActionKeys;
	QList <CMD_LIST> cmdLists;
	QList <Directory> dirLists;
	shared_ptr <BookmarkSync> gSyncer;
	shared_ptr <CatBuilder> catalogBuilder;
	QSettings *settings;
	QDateTime* updateTime;
	postHttp *accountTestHttp;
	QString iePath;
	QNetworkAccessManager *manager;
	QNetworkReply *reply;
	QNetworkProxy proxy;
	QNetworkRequest request;
	QTimer testProxyTimer;
	QSqlDatabase *db_p;
public:
	int checkListDirExist(const QString& dirname);
	int checkListDirSpecialchar(const QString& dirname);
	void addCatitemToDb(CatItem& item);
	void modifyCatitemFromDb(CatItem& item,uint index);
	void deleteCatitemFromDb(CatItem& item,uint index);
public slots: 
	
	void populateJavaScriptWindowObject();
	void contextMenuEvent(QContextMenuEvent* event);
	void startSync();
	void getHtml(const QString &path);
	void loading(const QString &name);
	void accept();
	void reject();
	void apply(const QString& name,const QVariant &value);
	void cmdApply(const int& type,const QString& cmdName,const QString &cmdCommand,const QString &cmdParameter,const QString& cmdIndex);
	void listApply(const int& type,const QString& listPath,const QString &listSuffix,const bool &isIncludeChildDir,const int& childDeep,const int& index);
	void getListDirectory(const QString& id,const int& type);
	//void bookmark_finished(bool error);
	//void testAccountFinished(bool err,QString result);
	void accountTestClick(const QString& name,const QString& password);
	void proxyTestClick(const QString& proxyAddr,const QString& proxyPort,const QString& proxyUsername,const QString& proxyPassword);
	void proxyTestslotError(QNetworkReply::NetworkError err);
	void  proxyTestslotFinished(QNetworkReply * testreply);
	void proxtTestTimerSlot();
	void rebuildcatalog();
	void startUpdater();
signals:
	void rebuildcatalogSignal();
	void optionStartSyncNotify();
	void testAccountNotify(const QString&,const QString&);
};
#endif
