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

#ifndef SYNC_DLG_H
#define SYNC_DLG_H
#include <QString>
#include <QStringList>
#include <QList>
#include <config.h>
#include <globals.h>
#include <QtWebKit/QWebView>
#include <QtWebKit/QWebFrame>
class synchronizeDlg:public QDialog
{
	  Q_OBJECT;
		 public:
			synchronizeDlg(QWidget *parent);
			~synchronizeDlg();
	public:
		QWebView *webView;
		QStringList httpStateString;
	public slots:
		void getHtml(const QString &path);
		void accept();
		void reject();
		void retry();
		void populateJavaScriptWindowObject();
		void updateStatus(int type);
		void readDateProgress(int done,int total);
		void reSyncSlot();
	signals:
		void reSync();
		void stopSync();
};
#endif
