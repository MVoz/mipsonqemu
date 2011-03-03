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

#include <config.h>
#include <globals.h>

#include <appUpdater.h>
#include <bmsync.h>

#include <QtWebKit/QWebView>
#include <QtWebKit/QWebFrame>


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

class OPTIONS_CLASS_EXPORT synchronizeDlg:public QDialog
{
	Q_OBJECT;
public:
	synchronizeDlg(QWidget *parent);
	~synchronizeDlg();
public:
	QWebView *webView;
	int status;
	uint statusTime;//second
public slots:
		void getHtml(const QString &path);
		void accept();
		void reject();
		void retry();
		void populateJavaScriptWindowObject();
		void updateStatus(int type,int s);
		void readDateProgress(int done,int total);
		void reSyncSlot();
signals:
		void reSyncNotify();
		void stopSyncNotify();
		void updateSuccessNotify();
};


class OPTIONS_CLASS_EXPORT OptionsDlg:public QDialog
{
	Q_OBJECT;
public:
	OptionsDlg(QWidget * parent = 0,QSettings *s=0,QSqlDatabase *b=NULL);
	~OptionsDlg();
public:
	QWebView *webView;
	synchronizeDlg *syncDlg;
	synchronizeDlg *updaterDlg;
	appUpdater* updaterthread;
	QStringList metaKeys;
	QStringList actionKeys;
	QList < int >iMetaKeys;
	QList < int >iActionKeys;
	QList <Directory> dirLists;
	QSettings *settings;

	QSqlDatabase *db;
	
	QNetworkAccessManager *manager;
	QNetworkReply *reply;
	QNetworkProxy *proxy;
	QNetworkRequest request;
	QTimer* testProxyTimer;

	volatile char testproxying;
	
public:
	int checkListDirExist(const QString& dirname);
	int checkListDirSpecialchar(const QString& dirname);
public slots: 
	void populateJavaScriptWindowObject();
	void contextMenuEvent(QContextMenuEvent* event);
	void startSync();
	void getHtml(const QString &path);
	void gohref(const QString &url);
	void loading(const QString &name);
	void accept();
	void reject();
	void apply(const QString& name,const QVariant &value);
	void cmdApply(const int& type,const QString& cmdName,const QString &cmdCommand,const QString &cmdParameter,const QString& cmdIndex);
	void listApply(const int& type,const QString& listPath,const QString &listSuffix,const bool &isIncludeChildDir,const int& childDeep,const int& index);
	void getListDirectory(const QString& id,const int& type);
	void accountTestClick(const QString& name,const QString& password);
	void proxyTestClick(const QString& proxyAddr,const QString& proxyPort,const QString& proxyUsername,const QString& proxyPassword);
//	void proxyTestslotError(QNetworkReply::NetworkError err);
	void  proxyTestFinished(QNetworkReply * testreply);
	void proxyTestTimeout();
	void rebuildcatalog();
	void startUpdater();
	void getSyncStatus();
	QString tr(const QString & s);
	void getbmfromid(const int& groupid,const int& browserid,const QString& name,const int& isroot );
	void netbookmarkmenu(int browserid,int parentid,QString func,QString& jsresult);
	void bmApply(const int& action,const QString& name,const QString& url,const int& id);
	void bmDirApply(const int& action,const QString& name,const QString& url,const int& type,const int& id);
signals:
	void rebuildcatalogSignal();
	void optionStartSyncNotify();
	void testAccountNotify(const QString&,const QString&);
	void configModifyNotify(int type);
};



#endif
