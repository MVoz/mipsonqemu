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

#ifndef WEBY_H
#define WEBY_H
//#include "gui.h"
#include "globals.h"

//#include "plugin_interface.h"

#include <boost/shared_ptr.hpp>
#include <QString>
#include <QSettings>
#include <catalog>

using namespace boost;
#if defined(WEBY_DLL)
#define WEBY_DLL_CLASS_EXPORT __declspec(dllexport)
#else
#define WEBY_DLL_CLASS_EXPORT __declspec(dllimport)
//#define CATALOG_DLL_CLASS_EXPORT 
#endif


struct WebySite {
    QString base;
    QString name;
    QString query;
    bool def;
    
    WebySite() { def = false; }

    WebySite(QString b, QString n, QString q, bool d = true) :
	base(b), name(n), query(q), def(d) {}
};

struct Bookmark {
	QString url;
	QString shortcut;
	QString name;
};

class WEBY_DLL_CLASS_EXPORT Weby : public QObject
{
	Q_OBJECT;
public:
	uint HASH_WEBSITE;
	uint HASH_WEBY;
	QList<WebySite> sites;
	QList<Bookmark> marks;
	QSettings* settings;

private:
//	shared_ptr<Gui> gui;
public:
	QString libPath;
	Weby(QSettings* s) {
//		gui = NULL;
		settings=s;
		HASH_WEBSITE = qHash(QString("website"));
		HASH_WEBY = qHash(QString("weby"));
	}
	~Weby() {}
	//int msg(int msgId, void* wParam = NULL, void* lParam = NULL); 
	void setPath(QString * path);
	void getLabels(QList<InputData>*);
	void getID(uint*);
	void getName(QString*);
	void getResults(QList<InputData>* id, QList<CatItem>* results);
	void getCatalog(QList<CatItem>* items);
	void launchItem(QList<InputData>*, CatItem*);
//	void doDialog(QWidget* parent, QWidget**);
//	void endDialog(bool accept);
	WebySite getDefault();
	void init();
	QString getFirefoxPath();
	void indexFirefox(QString path, QList<CatItem>* items);
	QString getIcon();
//#ifdef Q_WS_WIN
	void indexIE(QString path, QList<CatItem>* items);
//#endif
};

//extern WebyPlugin* gWebyInstance;
#endif
