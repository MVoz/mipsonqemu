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

#include <globals.h>
#include <QDir>
#include <QFile>
#include <QDateTime>
#include <QTextStream>
#include <QTextCodec>
#include <QMessageBox>
#include <bookmark_sync>
#include <catalog>
//#include <QCString>


QWidget *gMainWidget;
QDateTime gLastUpdateTime;
QString gIeFavPath;
QDateTime gNowUpdateTime;
uint gPostLock = 0;
//uint gMaxGroupId = 0;
//shared_ptr<int> gMaxGroupId;

QSettings *gSettings;
QString gSearchTxt;
shared_ptr < CatBuilder > gBuilder;
shared_ptr < BookmarkSync> gSyncer;
QString gNativeSep = QDir::toNativeSeparators("/");
CatItem* gSearchResult;



/*
void log(QString str)
{

	QFile file("log.txt");
	file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Append);
	QTextStream os(&file);
	os << "[";
	os << QDateTime::currentDateTime().toString("hh:mm:ss");
	os << "] " << str << "\n";
}
*/
#ifdef CONFIG_LOG_ENABLE
#pragma warning(disable:4996)


QString toQString(QVariant t)
{
	QString str;
	switch (t.type())
	  {
	  case QVariant::Int:
		  str.sprintf("%d", t.toUInt());
		  break;
	  case QVariant::String:
		  str = t.toString();
		  break;
	  default:
		  str.sprintf("%s", "unprocessed");
		  break;

	  }
	return str;
}

void dump_setting(const QString prefix)
{
	if (!prefix.isNull())
	  {
		  gSettings->beginGroup(prefix);
		  QStringList keys = gSettings->childKeys();
		  for (int j = 0; j < keys.size(); j++)
			 qDebug("[gSettings]:%s=%s", qPrintable(keys.at(j)), qPrintable(toQString(gSettings->value(keys.at(j)))));
		  gSettings->endGroup();
	} else
	  {
		  QStringList keys = gSettings->allKeys();
		  for (int j = 0; j < keys.size(); j++)
			  qDebug("[gSettings]:%s=%s", qPrintable(keys.at(j)), qPrintable(toQString(gSettings->value(keys.at(j)))));
	  }
}
#endif
