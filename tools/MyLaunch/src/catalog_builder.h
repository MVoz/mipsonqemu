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

#ifndef CATALOG_BUILDER
#define CATALOG_BUILDER
#include "..\dll\catalog_types.h"
#include "plugin_handler.h"
#include <QThread>
#include <QSqlDatabase>
#include <QtSql>


#include <boost/shared_ptr.hpp>

using namespace boost;
enum catbuildmode{
	CAT_BUILDMODE_ALL=0,
	CAT_BUILDMODE_DIRECTORY,
	CAT_BUILDMODE_BOOKMARK,
	CAT_BUILDMODE_COMMAND,	
};

#define STOP_FLAG_CHECK if(terminateflag) goto bad;
class CatBuilder : public QThread
{
	Q_OBJECT

private:

	shared_ptr<Catalog> curcat;
	//PluginHandler* plugins;
	bool buildWithStart;


	shared_ptr<Catalog> cat;
	QHash<QString, bool> indexed;
	QSqlDatabase *db;
	catbuildmode buildMode;
public:
	bool terminateflag;
public:
	//bool loadCatalog(QString);
	void storeCatalog(uint);
	void buildCatalog(uint);
	void buildCatalog_bookmark(uint);
	void buildCatalog_directory(uint);
	void buildCatelog_command(uint);
	void buildCatelog_define(uint);
	void clearShortcut();
	void _clearShortcut(int type);
	void indexDirectory(QString dir, QStringList filters, bool fdirs, bool fbin, int depth,int comeFrom,uint delId);
	//void produceInsetQueryStr(CatItem& item,QString& s );
	//bool createDbFile();
	//bool createConnection(QSqlDatabase& db,const QString &name);
	//void setPreviousCatalog(shared_ptr<Catalog> cata) {	
	//	curcat = cata;
	//}


	shared_ptr<Catalog> getCatalog() { return cat; }
	CatBuilder(bool fromArchive,catbuildmode mode,QSqlDatabase *dbs);
	//CatBuilder(shared_ptr<Catalog> catalog,QSqlDatabase *dbs) :  buildWithStart(false),db(dbs),cat(catalog){}
	~CatBuilder(){
		cat.reset();
	}
	void run();
	void clearDb(uint delId);
	//uint isExistInDb(CatItem &item);

signals:
	void catalogFinished(int);
	void catalogIncrement(float);

};

#endif
