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

#ifndef GLOBALS_H
#define GLOBALS_H
#include <QString>
#include <QDateTime>
#include <QList>
#include <QWidget>
#include <QSettings>
#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QCheckBox>
#include <QtGui/QComboBox>
#include <QtGui/QDialog>
#include <QtGui/QDialogButtonBox>
#include <QtGui/QGroupBox>
#include <QtGui/QHBoxLayout>
#include <QtGui/QLabel>
#include <QtGui/QLineEdit>
#include <QtGui/QListWidget>
#include <QtGui/QProgressBar>
#include <QtGui/QPushButton>
#include <QtGui/QSlider>
#include <QtGui/QSpacerItem>
#include <QtGui/QSpinBox>
#include <QtGui/QTabWidget>
#include <QtGui/QVBoxLayout>
#include <QtGui/QWidget>
#include <QXmlStreamReader>
#include <QTextStream>
#include "../src/catalog_builder.h"

#include <bmapi.h>
#include <config.h>
#include <xmlReader.h>
#include <bookmark_sync>
#include <posthttp>
#include <mergethread>
#include <QSqlDatabase>

extern QWidget* gMainWidget;
extern QSettings* gSettings;
extern QString gIeFavPath;
extern QDateTime gLastUpdateTime;
extern QDateTime gNowUpdateTime;
extern uint gPostLock;
extern uint gMaxGroupId;
//extern shared_ptr<int> gMaxGroupId;

extern shared_ptr<CatBuilder> gBuilder;
extern QString gNativeSep;
extern QString gSearchTxt;
extern CatItem* gSearchResult;
//extern QSqlDatabase db;
//extern int language;


struct Directory
{
	Directory():indexDirs(false), indexExe(false), depth(100)
	{

	}
	Directory(QString n, QStringList t, bool d, bool e, int dep):indexDirs(d), indexExe(e), name(n), types(t), depth(dep)
	{
	}
	bool indexDirs;
	bool indexExe;
	QString name;
	QStringList types;
	int depth;
	int index;
};
#endif
