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

#include <QtGui>
#include <QUrl>
#include <QFile>
#include <QRegExp>
#include <QTextCodec>

#ifdef Q_WS_WIN
#include <windows.h>
#include <shlobj.h>
#include <tchar.h>

#endif

#include "weby.h"
//#include "gui.h"

//WebyPlugin* gWebyInstance = NULL;

void Weby::init()
{
	//if (gWebyInstance == NULL)
	//	gWebyInstance = this;



	QSettings* set = settings;
	if ( set->value("weby/version", 0.0).toDouble() == 0.0 ) {
		set->beginWriteArray("weby/sites");
		set->setArrayIndex(0);
		set->setValue("name", "Google");
		set->setValue("base", "http://www.google.com/");
		set->setValue("query", "search?source=launchy&q=%s");
		set->setValue("default", true);

		set->setArrayIndex(1);
		set->setValue("name", "Live Search");
		set->setValue("base", "http://search.live.com/");
		set->setValue("query", "results.aspx?q=%s");
		
	}
	set->setValue("weby/version", 2.0);

	// Read in the array of websites
	sites.clear();
	int count = set->beginReadArray("weby/sites");
	for(int i = 0; i < count; ++i) {
		set->setArrayIndex(i);
		WebySite s;
		s.base = set->value("base").toString();
		s.name = set->value("name").toString();
		s.query = set->value("query").toString();
		s.def = set->value("default", false).toBool();
		sites.push_back(s);
	}
	set->endArray();
}

void Weby::getID(uint* id)
{
	*id = HASH_WEBY;
}

void Weby::getName(QString* str)
{
	*str = "Weby";
}

void Weby::getLabels(QList<InputData>* id)
{
	if (id->count() > 1)
		return;

	// Apply a "website" label if we think it's a website
	const QString & text = id->last().getText();

	if (text.contains("http://", Qt::CaseInsensitive))
		id->last().setLabel(HASH_WEBSITE);
	else if (text.contains("https://", Qt::CaseInsensitive)) 
		id->last().setLabel(HASH_WEBSITE);
	else if (text.contains(".com", Qt::CaseInsensitive)) 
		id->last().setLabel(HASH_WEBSITE);
	else if (text.contains(".net", Qt::CaseInsensitive))
		id->last().setLabel(HASH_WEBSITE);
	else if (text.contains(".org", Qt::CaseInsensitive))
		id->last().setLabel(HASH_WEBSITE);
	else if (text.contains("www.", Qt::CaseInsensitive))
		id->last().setLabel(HASH_WEBSITE);
}



void Weby::getResults(QList<InputData>* id, QList<CatItem>* results)
{
/*
	if (id->last().hasLabel(HASH_WEBSITE)) {
		const QString & text = id->last().getText();
		// This is a website, create an entry for it
		results->push_front(CatItem(text + ".weby", text, HASH_WEBY, getIcon()));
	}

	if (id->count() > 1 && (unsigned int) id->first().getTopResult().id == HASH_WEBY) {
		const QString & text = id->last().getText();
		// This is user search text, create an entry for it
		results->push_front(CatItem(text + ".weby", text, HASH_WEBY, getIcon()));
	}

	// If we don't have any results, add default
	if (results->size() == 0 && id->count() <= 1) {
		const QString & text = id->last().getText();
		if (text != "") {
			QString name = getDefault().name;
			if (name != "")
				results->push_back(CatItem(text + ".weby", name, HASH_WEBY, getIcon()));
		}
	}
*/

}

#ifdef Q_WS_WIN


void Weby::indexIE(QString path, QList<CatItem>* items)
{
	QDir qd(path);
	QString dir = qd.absolutePath();
	QStringList dirs = qd.entryList(QDir::AllDirs | QDir::NoDotAndDotDot);

	for (int i = 0; i < dirs.count(); ++i) {
		QString cur = dirs[i];
		if (cur.contains(".lnk")) continue;
		indexIE(dir + "/" + dirs[i],items);
	}	

	QStringList files = qd.entryList(QStringList("*.url"), QDir::Files, QDir::Unsorted);
	for(int i = 0; i < files.count(); ++i) {
		qDebug("%s path=%s",__FUNCTION__,qPrintable(dir + "/" + files[i]));
		items->push_back(CatItem(dir + "/" + files[i], files[i].mid(0,files[i].size()-4),COME_FROM_IE));
	}
}
#endif

QString Weby::getFirefoxPath()
{
	QString path;
	QString iniPath;
	QString appData;
	QString osPath;

#ifdef Q_WS_WIN
	GetShellDir(CSIDL_APPDATA, appData);
	osPath = appData + "/Mozilla/Firefox/";
#endif

#ifdef Q_WS_X11
	osPath = QDir::homePath() + "/.mozilla/firefox/";
#endif

	iniPath = osPath + "profiles.ini";

	QFile file(iniPath);
	if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
		return "";
	bool isRel = false;
	while (!file.atEnd()) {
		QString line = file.readLine();
		if (line.contains("IsRelative")) {
			QStringList spl = line.split("=");
			isRel = spl[1].toInt();
		}
		if (line.contains("Path")) {
			QStringList spl = line.split("=");
			if (isRel)
				path = osPath + spl[1].mid(0,spl[1].count()-1) + "/bookmarks.html" ;
			else
				path = spl[1].mid(0,spl[1].count()-1);
			break;
		}
	} 	

	return path;
}

QString Weby::getIcon()
{
	return libPath + "/icons/weby.png";
}

void Weby::indexFirefox(QString path, QList<CatItem>* items)
{
	QFile file(path);
	if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
		return;

	marks.clear();

	QRegExp regex_url("<a href=\"([^\"]*)\"", Qt::CaseInsensitive);
	QRegExp regex_urlname("\">([^<]*)</A>", Qt::CaseInsensitive);
	QRegExp regex_shortcut("SHORTCUTURL=\"([^\"]*)\"");
	QRegExp regex_postdata("POST_DATA", Qt::CaseInsensitive);

	while (!file.atEnd()) {
		QString line = QString::fromUtf8(file.readLine());
		if (regex_url.indexIn(line) != -1) {
			Bookmark mark;
			mark.url = regex_url.cap(1);

			if (regex_urlname.indexIn(line) != -1) {
				mark.name = regex_urlname.cap(1);

				if (regex_postdata.indexIn(line) != -1) continue;
				if (regex_shortcut.indexIn(line) != -1) {
					mark.shortcut = regex_shortcut.cap(1);
					marks.push_back(mark);
					items->push_back(CatItem(mark.url + ".shortcut", mark.shortcut, HASH_WEBY, getIcon(),COME_FROM_FIREFOX));
				} else {
					//qDebug("%s url=%s name=%s",__FUNCTION__,qPrintable(mark.url),qPrintable(mark.name));
					items->push_back(CatItem(mark.url, mark.name, 0, getIcon(),COME_FROM_FIREFOX));
				}	
			}			
		}
	}
	qDebug("%s %d",__FUNCTION__,__LINE__);
}


/*
QString string = fileName();//fileName() returns a chinese filename
QTextCodec* gbk_codec = QTextCodec::codecForName("GB2312");
QString gbk_string = gbk_codec->toUnicode(string);
QLabel *label = new QLabel(gbk_string);
*/


WebySite Weby::getDefault() 
{
	foreach(WebySite site, sites) {
		if (site.def) {
			return site;
		}
	}
	return WebySite();
}


void Weby::getCatalog(QList<CatItem>* items)
{
	foreach(WebySite site, sites) {
		items->push_back(CatItem(site.name + ".weby", site.name, HASH_WEBY, getIcon(),COME_FROM_DEFINE));
	}
	qDebug("%s %d\n",__FUNCTION__,__LINE__);
#ifdef Q_WS_WIN
	if ((settings)->value("weby/ie", true).toBool()) {
		QString path;
		qDebug("%s %d\n",__FUNCTION__,__LINE__);
		GetShellDir(CSIDL_FAVORITES, path);
		indexIE(path, items);
	}
#endif
	if ((settings)->value("weby/firefox", true).toBool()) {
		QString path = getFirefoxPath();
		indexFirefox(path, items);
	}
}

void Weby::launchItem(QList<InputData>* id, CatItem* item)
{
	QString file = "";
	QString args = "";


	//	if (id->count() == 2) {
	    args = id->last().getText();
	    args = QUrl::toPercentEncoding(args);
	    item = &id->first().getTopResult();
	    //	}

	    //	    qDebug() << args;



     

	// Is it a Firefox shortcut?
	if (item->fullPath.contains(".shortcut")) {
		file = item->fullPath.mid(0, item->fullPath.count()-9);
		file.replace("%s", args);
	}
	else { // It's a user-specific site
		bool found = false;
		foreach(WebySite site, sites) {
			if (item->shortName == site.name) {
				found = true;
				file = site.base;
				if (args != "") {
					QString tmp = site.query;
					tmp.replace("%s", args);
					file += tmp;
				}
				break;
			}
		}

		if (!found) {
			file = item->shortName;	
			if (!file.contains("http://")) {
				file = "http://" + file;
			}
		}
	}
	//	file = file.replace("#", "%23");
	QUrl url(file);
	//	runProgram(url.toEncoded(), "");
	runProgram(url.toString(), "");
}

void Weby::setPath(QString * path) {
	libPath = *path;
}

