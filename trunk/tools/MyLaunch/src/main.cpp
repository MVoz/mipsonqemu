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
#include <QApplication>
#include <QFont>
#include <QPushButton>
#include <QWidget>
#include <QPalette>
#include <QLineEdit>
#include <QPixmap>
#include <QBitmap>
#include <QLabel>
#include <QFile>
#include <QIcon>
#include <QSettings>
#include <QMouseEvent>
#include <QMessageBox>
#include <QDir>
#include <QMenu>
#include <QSettings>
#include <QTimer>
#include <QDateTime>
#include <QDesktopWidget>
#include <QTranslator>


#include "icon_delegate.h"
#include "main.h"
#include <globals.h>
#include <options>
//#include "dsingleapplication.h"
#include "plugin_interface.h"
extern shared_ptr < BookmarkSync> gSyncer;


bool MyWidget::createDbFile()
{
		qDebug("%s %d\n",__FUNCTION__,__LINE__);
		QString queryStr;
		queryStr=QString("DROP TABLE %1").arg(DB_TABLE_NAME);
		QSqlQuery query(queryStr,db);
		query.exec();	
		queryStr=QString("CREATE TABLE %1 ("
				   "id INTEGER PRIMARY KEY AUTOINCREMENT, "
				   "fullPath VARCHAR(1024) NOT NULL, "
				   "shortName VARCHAR(1024) NOT NULL, "
				   "lowName VARCHAR(1024) NOT NULL, "
				   "icon VARCHAR(1024), "
				   "usage INTEGER NOT NULL,"
				    "hashId INTEGER NOT NULL,"
				   "groupId INTEGER NOT NULL, "
				    "parentId INTEGER NOT NULL, "				   
				    "isHasPinyin INTEGER NOT NULL, "
				    "comeFrom INTEGER NOT NULL, "
				    "hanziNums INTEGER NOT NULL, "
				    "pinyinDepth INTEGER NOT NULL, "
				    "pinyinReg VARCHAR(1024), "
				     "alias1 VARCHAR(1024), "
				     "alias2 VARCHAR(1024),"
				     "shortCut VARCHAR(1024),"
				     "delId INTEGER NOT NULL,"
				     "args VARCHAR(1024))").arg(DB_TABLE_NAME);
		query=QSqlQuery(queryStr,db);
		query.exec(queryStr);
		query.clear();
		return true;

}

MyWidget::MyWidget(QWidget * parent, PlatformBase * plat, bool rescue):
#ifdef Q_WS_WIN
QWidget(parent, Qt::FramelessWindowHint | Qt::Tool),
#endif
#ifdef Q_WS_X11
//QWidget(parent, Qt::SplashScreen | Qt::FramelessWindowHint | Qt::Tool ),
    QWidget(parent, Qt::FramelessWindowHint | Qt::Tool),
#endif
    platform(plat), catalogBuilderTimer(NULL), dropTimer(NULL), alternatives(NULL)
{
	setAttribute(Qt::WA_AlwaysShowToolTips);
	setAttribute(Qt::WA_InputMethodEnabled);
	//      setWindowFlags(windowFlags() | Qt::WindowStaysOnTopHint);
	//    setWindowFlags(windowFlags() & ~Qt::WindowStaysOnTopHint);

	if (platform->isAlreadyRunning())
		exit(1);
	//inital language
#ifdef CONFIG_PINYIN_FROM_DB
#else
	init_pinyin_utf8_list();
#endif
	fader = new Fader(this);
	connect(fader, SIGNAL(fadeLevel(double)), this, SLOT(setFadeLevel(double)));
	connect(fader, SIGNAL(finishedFade(double)), this, SLOT(finishedFade(double)));

	gMainWidget = this;
	menuOpen = false;
	optionsOpen = false;
	gSearchTxt = "";
	syncDlgTimer=NULL;
//      gBuilder = NULL;
//      catalog = NULL;
//	gMaxGroupId=0;
	
	setFocusPolicy(Qt::ClickFocus);

	alwaysShowLaunchy = false;
#ifdef CONFIG_SYSTEM_TRAY
	createActions();
	createTrayIcon();
#endif
	
	//      hideLaunchy();
	label = new QLabel(this);

	opsButton = new QPushButton(label);
	opsButton->setObjectName("opsButton");
	opsButton->setToolTip(tr(APP_NAME" Options"));
	connect(opsButton, SIGNAL(pressed()), this, SLOT(menuOptions()));

	closeButton = new QPushButton(label);
	closeButton->setObjectName("closeButton");
	closeButton->setToolTip(tr("Close "APP_NAME));
	connect(closeButton, SIGNAL(pressed()), qApp, SLOT(quit()));


	output = new QLineEditMenu(label);
	output->setAlignment(Qt::AlignHCenter);
	output->setReadOnly(true);
	output->setObjectName("output");
	connect(output, SIGNAL(menuEvent(QContextMenuEvent *)), this, SLOT(menuEvent(QContextMenuEvent *)));

	input = new QCharLineEdit(label);
	input->setObjectName("input");
	connect(input, SIGNAL(keyPressed(QKeyEvent *)), this, SLOT(inputKeyPressEvent(QKeyEvent *)));
	connect(input, SIGNAL(focusOut(QFocusEvent *)), this, SLOT(focusOutEvent(QFocusEvent *)));
	connect(input, SIGNAL(inputMethod(QInputMethodEvent *)), this, SLOT(inputMethodEvent(QInputMethodEvent *)));
#ifdef CONFIG_SYSTEM_TRAY
	connect(trayIcon, SIGNAL(activated(QSystemTrayIcon::ActivationReason)), this, SLOT(iconActivated(QSystemTrayIcon::ActivationReason)));
#endif


	licon = new QLabel(label);

	dirs = platform->GetDirectories();
#if 0
	QHash < QString, QList < QString > >::const_iterator i;
	for (i = dirs.constBegin(); i != dirs.constEnd(); ++i)
	  {
		  logToFile("%s:", i.key().toLatin1().data());
		  QList < QString >::const_iterator j;
		  for (j = i.value().constBegin(); j != i.value().constEnd(); ++j)
			  logToFile("%s\n", (*j).toLatin1().data());
	  }
#endif
#ifdef CONFIG_ONE_OPTION
	ops = NULL;
#endif
	// Load settings

	if (QFile::exists(dirs["portConfig"][0]))
		gSettings = new QSettings(dirs["portConfig"][0], QSettings::IniFormat, this);
	else
		gSettings = new QSettings(dirs["config"][0], QSettings::IniFormat, this);
#ifdef CONFIG_LOG_ENABLE
//      dump_setting(NULL);
#endif
	//inital language
	setLanguage(gSettings->value("GenOps/language", DEFAULT_LANGUAGE).toInt()) ;
	// If this is the first time running or a new version, call updateVersion
	bool showLaunchyFirstTime = false;
	if (gSettings->value("version", 0).toInt() != LAUNCHY_VERSION)
	  {
		  updateVersion(gSettings->value("version", 0).toInt());
		  showLaunchyFirstTime = true;
	  }
//pre-alloc the search result
	gSearchResult=new CatItem[MAX_SEARCH_RESULT];
	db = QSqlDatabase::addDatabase("QSQLITE", "dbManage");
	QString dest ;
	getUserLocalFullpath(gSettings,QString(DB_DATABASE_NAME),dest);
	int buildDbWithStart=!QFile::exists(dest);
	db.setDatabaseName(dest);		
	if ( !db.open())	 
		 {
					qDebug("connect database %s failure!\n",qPrintable(dest)) 	;
					exit(1);
		 } 
		 else{

  			        qDebug("connect database %s successfully!\n",qPrintable(dest));  
					if(buildDbWithStart)
						createDbFile();
		}

	gLastUpdateTime = QDateTime::fromString(gSettings->value("updateTime", TIME_INIT_STR).toString(), TIME_FORMAT);
	GetShellDir(CSIDL_FAVORITES, gIeFavPath);
#ifdef CONFIG_LOG_ENABLE
	qDebug("gLastUpdateTime=%s", qPrintable(gLastUpdateTime.toString(TIME_FORMAT)));
#endif
	alternatives = new QCharListWidget(this);
	listDelegate = new IconDelegate(this);
	defaultDelegate = alternatives->itemDelegate();
	setCondensed(gSettings->value("GenOps/condensedView", false).toBool());
	alternatives->setObjectName("alternatives");
	alternatives->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
	alternatives->setTextElideMode(Qt::ElideLeft);
	alternatives->setWindowFlags(Qt::Window | Qt::Tool | Qt::FramelessWindowHint);
	altScroll = alternatives->verticalScrollBar();
	altScroll->setObjectName("altScroll");
	//      combo->setSizeAdjustPolicy(QComboBox::AdjustToContentsOnFirstShow);
	connect(alternatives, SIGNAL(keyPressed(QKeyEvent *)), this, SLOT(altKeyPressEvent(QKeyEvent *)));
	connect(alternatives, SIGNAL(focusOut(QFocusEvent *)), this, SLOT(focusOutEvent(QFocusEvent *)));


	// Load the plugins
	plugins.loadPlugins();

	// Load the skin
	applySkin(gSettings->value("GenOps/skin", dirs["defSkin"][0]).toString());

	// Move to saved position
	QPoint x;
	if (rescue)
		x = QPoint(0, 0);
	else
		x = loadPosition();
	move(x);
	platform->MoveAlphaBorder(x);
	//get broswerenable
	//getBrowserEnable(gSettings,tz::getbrowserInfo());
	setBrowserEnable(gSettings);

	// Set the general options
	setAlwaysShow(gSettings->value("GenOps/alwaysshow", false).toBool());
	setAlwaysTop(gSettings->value("GenOps/alwaystop", false).toBool());
	setPortable(gSettings->value("GenOps/isportable", false).toBool());


	// Check for udpates?
	if (gSettings->value("GenOps/updatecheck", true).toBool())
	  {
		  checkForUpdate();
	  }

	// Set the hotkey
#ifdef Q_WS_WIN
	int curMeta = gSettings->value("GenOps/hotkeyModifier", Qt::AltModifier).toInt();
#endif
#ifdef Q_WS_X11
	int curMeta = gSettings->value("GenOps/hotkeyModifier", Qt::ControlModifier).toInt();
#endif
	int curAction = gSettings->value("GenOps/hotkeyAction", Qt::Key_Space).toInt();
	if (!setHotkey(curMeta, curAction))
	  {
		  QMessageBox::warning(this, tr(APP_NAME), tr("The hotkey you have chosen is already in use. Please select another from "APP_NAME"'s preferences."));
		  rescue = true;
	  }
	// Set the timers
	updateSuccessTimer = NULL;
	catalogBuilderTimer = new QTimer(this);
	slientUpdate =NULL;
	silentupdateTimer = new QTimer(this);
	syncTimer = new QTimer(this);
	dropTimer = new QTimer(this);
	dropTimer->setSingleShot(true);
	connect(catalogBuilderTimer, SIGNAL(timeout()), this, SLOT(catalogBuilderTimeout()));
	connect(silentupdateTimer, SIGNAL(timeout()), this, SLOT(silentupdateTimeout()));
	connect(syncTimer, SIGNAL(timeout()), this, SLOT(syncTimeout()));
	connect(dropTimer, SIGNAL(timeout()), this, SLOT(dropTimeout()));
	if (gSettings->value("GenOps/catalogBuildertimer", 10).toInt() != 0)
		catalogBuilderTimer->start(60000);//1m
	if (gSettings->value("GenOps/silentupdatetimer", 10).toInt() != 0)
		silentupdateTimer->start(10000);//1m
	if (gSettings->value("GenOps/synctimer", 10).toInt() != 0)
		syncTimer->start(5*60000);//5m



	// Load the catalog
	updateTimes=0;
	/*
	gBuilder.reset(new CatBuilder(buildDbWithStart,CAT_BUILDMODE_ALL,&db));
	connect(gBuilder.get(), SIGNAL(catalogFinished()), this, SLOT(catalogBuilt()));
	
	gBuilder->start();
	*/
	buildCatalog();

	//      setTabOrder(combo, combo);

#if 1


#endif
	showLaunchyFirstTime=gSettings->value("generalOpt/ckShowMainwindow", false).toBool();

	if (showLaunchyFirstTime || rescue)
		showLaunchy();
	else
		hideLaunchy();
#ifdef CONFIG_SYSTEM_TRAY
	setIcon();
	if(gSettings->value("generalOpt/ckShowTray", true).toBool())
	{
		trayIcon->show();
	}

#endif
	getFavico("www.sohu.com","favicon.ico");
}

void MyWidget::setCondensed(int condensed)
{
	if (alternatives == NULL || listDelegate == NULL || defaultDelegate == NULL)
		return;
	if (condensed)
		alternatives->setItemDelegate(defaultDelegate);
	else
		alternatives->setItemDelegate(listDelegate);

}
bool MyWidget::setHotkey(int meta, int key)
{
	QKeySequence keys = QKeySequence(meta + key);
	return platform->SetHotkey(keys, this, SLOT(onHotKey()));
}

void MyWidget::menuEvent(QContextMenuEvent * evt)
{
	contextMenuEvent(evt);
}

void MyWidget::showAlternatives(bool show)
{
	if (!isVisible())
		return;

	if (searchResults.size() <= 1)
		return;
	QRect n = altRect;
	n.translate(pos());

	alternatives->setGeometry(n);

	if (show)
	  {
		  //alternatives->clear();
		  int num = alternatives->count();
		  for (int i = 0; i < num; ++i)
		    {
			    QListWidgetItem *item = alternatives->takeItem(0);
			    if (item != NULL)
				    delete item;
		    }


		  for (int i = 0; i < searchResults.size(); ++i)
		    {
			    QFileInfo fileInfo(searchResults[i].fullPath);

			    QIcon icon = getIcon(searchResults[i]);
			    QListWidgetItem *item = new QListWidgetItem(icon, QDir::toNativeSeparators(searchResults[i].fullPath), alternatives);
			    //                      QListWidgetItem *item = new QListWidgetItem(alternatives);
			    item->setData(ROLE_FULL, QDir::toNativeSeparators(searchResults[i].fullPath));
			    qDebug("size=%d fullPath=%s\n",searchResults.size(),qPrintable(searchResults[i].fullPath));
			    item->setData(ROLE_SHORT, searchResults[i].shortName);
			    item->setData(ROLE_ICON, icon);
			    item->setToolTip(QDir::toNativeSeparators(searchResults[i].fullPath));
			    alternatives->addItem(item);
			    alternatives->setFocus();
		    }
		  if (alternatives->count() > 0)
		    {
			    int numViewable = gSettings->value("GenOps/numviewable", "4").toInt();
			    //QRect r = alternatives->geometry();
			    int min = alternatives->count() < numViewable ? alternatives->count() : numViewable;
			    n.setHeight(min * alternatives->sizeHintForRow(0));

			    altRect.setHeight(n.height());

			    // Is there room for the dropdown box?
			    if (n.y() + n.height() > qApp->desktop()->height())
			      {
				      n.moveTop(pos().y() + input->pos().y() - n.height());
			      }
			    alternatives->setGeometry(n);
		    }
		  double opaqueness = (double) gSettings->value("GenOps/opaqueness", 100).toInt();
		  opaqueness /= 100.0;
		  alternatives->setWindowOpacity(opaqueness);
		  alternatives->show();
		  qApp->syncX();
		  alternatives->raise();
	} else
	  {
		  alternatives->hide();
	  }
}

void MyWidget::increaseUsage(QString &fullPath,QString& shortCut)
{
		QSqlQuery	query("", db);
		QString queryStr;
		queryStr=QString("update  %1 set usage=usage+1,shortCut='%2' where hashId=%3 and fullPath='%4'").arg(DB_TABLE_NAME).arg(shortCut).arg(qHash(fullPath)).arg(fullPath);
		query.exec(queryStr);
		query.clear();
}
void MyWidget::launchObject()
{
	CatItem res = inputData[0].getTopResult();
	//if (res.id == HASH_LAUNCHY)
	qDebug("%s comeFrom=%d fullpath=%s",__FUNCTION__,res.comeFrom,qPrintable(res.fullPath));
	if (res.comeFrom==COME_FROM_PROGRAM)
	  {
		  QString args = "";
		  if (inputData.count() > 1)
			  for (int i = 1; i < inputData.count(); ++i)
				  args += inputData[i].getText() + " ";
		  qDebug("input=%s args=%s",qPrintable(inputData[0].getText()) ,qPrintable(args));
		  if (!platform->Execute(res.fullPath, args))
			  {
			  	increaseUsage(res.fullPath,inputData[0].getText());
			  	runProgram(res.fullPath, args);
		  	  }
	} else if((res.comeFrom==COME_FROM_IE)||(res.comeFrom==COME_FROM_FIREFOX)||(res.comeFrom==COME_FROM_OPERA)){
			//Weby web(gSettings);
			//web.launchItem(&inputData, &res);
			if(res.comeFrom==COME_FROM_FIREFOX)
			{
				QString ff_bin;
				if(getFirefoxBinPath(ff_bin)){
					qDebug()<<ff_bin;
					runProgram(ff_bin,tr("-new-tab %1").arg(res.fullPath));
				}else{
					ff_bin=gSettings->value("adv/firefoxbin","").toString();
					if(!ff_bin.isEmpty())
						runProgram(ff_bin,tr("-new-tab %1").arg(res.fullPath));
					else
						runProgram(res.fullPath,QString(""));
					
				}
			}else
				{
					QString ie_bin;
					if(getIEBinPath(ie_bin)){
						qDebug()<<ie_bin;
						runProgram(ie_bin,res.fullPath);
					}else{
						ie_bin=gSettings->value("adv/iebin","").toString();
						if(!ie_bin.isEmpty())
							runProgram(ie_bin,res.fullPath);
						else
							runProgram(res.fullPath,QString(""));
						
					}
				}

			
		}
	else {
		  int ops = plugins.execute(&inputData, &res);
		  if (ops > 1)
		    {
			    switch (ops)
			      {
			      case MSG_CONTROL_EXIT:
				      close();
				      break;
			      case MSG_CONTROL_OPTIONS:
				      menuOptions();
				      break;
			      case MSG_CONTROL_REBUILD:
				      buildCatalog();
				      break;
			      default:
				      break;
			      }
		    }
	  }
	catalog->incrementUsage(res);
}

void MyWidget::focusOutEvent(QFocusEvent * evt)
{
	if (evt->reason() == Qt::ActiveWindowFocusReason)
	  {
		  if (gSettings->value("GenOps/hideiflostfocus", false).toBool())
			  if (!this->isActiveWindow() && !alternatives->isActiveWindow() && !optionsOpen)
			    {
				    hideLaunchy();
			    }
	  }
}


void MyWidget::altKeyPressEvent(QKeyEvent * key)
{
	LOG_RUN_LINE;
	if (key->key() == Qt::Key_Escape)
	  {
		  alternatives->hide();
	  }
	if (key->key() == Qt::Key_Up)
	  {
		  key->ignore();
	} else if (key->key() == Qt::Key_Down)
	  {
		  key->ignore();
	} else if (key->key() == Qt::Key_Return || key->key() == Qt::Key_Enter || key->key() == Qt::Key_Tab)
	  {
		  if (searchResults.count() > 0)
		    {
			    int row = alternatives->currentRow();
			    if (row > -1)
			      {
				      QString location = "History/" + input->text();
				      QStringList hist;
				      hist << searchResults[row].lowName << searchResults[row].fullPath;
				      gSettings->setValue(location, hist);

				      CatItem tmp = searchResults[row];
				      searchResults[row] = searchResults[0];
				      searchResults[0] = tmp;

				      updateDisplay();

				      /* This seems to be unnecessary
				         if (key->key() == Qt::Key_Tab) {
				         inputData.last().setText(searchResults[0].fullPath);
				         input->setText(printInput() + searchResults[0].fullPath);
				         }
				       */
				      alternatives->hide();


				      if (key->key() == Qt::Key_Tab)
					{
						doTab();
						parseInput(input->text());
						searchOnInput();
						updateDisplay();
						dropTimer->stop();
						dropTimer->start(1000);
				      } else
					{
						doEnter();
					}
			      }
		    }
	} else
	  {
		  alternatives->hide();
		  activateWindow();
		  raise();
		  input->setFocus();
		  key->ignore();
		  input->setText(input->text() + key->text());
		  keyPressEvent(key);
	  }
}





void MyWidget::inputKeyPressEvent(QKeyEvent * key)
{
	LOG_RUN_LINE;
	if (key->key() == Qt::Key_Tab)
	  {
		  keyPressEvent(key);
	} else
	  {
		  key->ignore();
	  }

	LOG_RUN_LINE;
}

void MyWidget::parseInput(QString text)
{
	//      QStringList spl = text.split(" | ");
	QStringList spl = text.split(QString(" ") + sepChar() + QString(" "));
	if (spl.count() < inputData.count())
	  {
		  inputData = inputData.mid(0, spl.count());
	  }
#ifdef CONFIG_LOG_ENABLE
	for (int i = 0; i < inputData.size(); i++)
	  {
		  qDebug("%s inputData[%d] %s", __FUNCTION__, i, TOCHAR(inputData[i].getText()));
	  }
#endif

	for (int i = 0; i < inputData.size(); i++)
	  {
		  if (inputData[i].getText() != spl[i])
		    {
			    inputData = inputData.mid(0, i);
			    break;
		    }
	  }

	for (int i = inputData.count(); i < spl.count(); i++)
	  {
		  InputData data(spl[i]);
		  inputData.push_back(data);
	  }

}

// Print all of the input up to the last entry
QString MyWidget::printInput()
{
	QString res = "";
	for (int i = 0; i < inputData.count() - 1; ++i)
	  {
		  res += inputData[i].getText();
		  res += QString(" ") + sepChar() + QString(" ");
	  }
	return res;
}

void MyWidget::doTab()
{
	LOG_RUN_LINE;
	if (inputData.count() > 0 && searchResults.count() > 0)
	  {
		  // If it's an incomplete file or dir, complete it
		  QFileInfo info(searchResults[0].fullPath);

		  if ((inputData.last().hasLabel(LABEL_FILE) || info.isDir()))	//     && input->text().compare(QDir::toNativeSeparators(searchResults[0].fullPath), Qt::CaseInsensitive) != 0)
		    {
			    QString path;
			    if (info.isSymLink())
				    path = info.symLinkTarget();
			    else
				    path = searchResults[0].fullPath;

			    if (info.isDir() && !path.endsWith(QDir::separator()))
				    path += QDir::separator();

			    input->setText(printInput() + QDir::toNativeSeparators(path));
		  } else
		    {
			    // Looking for a plugin
			    input->setText(input->text() + " " + sepChar() + " ");
			    inputData.last().setText(searchResults[0].shortName);
			    input->setText(printInput() + searchResults[0].shortName + " " + sepChar() + " ");
		    }
	  }
}

void MyWidget::doEnter()
{
	if (dropTimer->isActive())
		dropTimer->stop();

	if (searchResults.count() > 0 || inputData.count() > 1)
		launchObject();
	hideLaunchy();

}

void MyWidget::keyPressEvent(QKeyEvent * key)
{
	if (key->key() == Qt::Key_Escape)
	  {
		  if (alternatives->isVisible())
			  alternatives->hide();
		  else
			  hideLaunchy();
	  }

	else if (key->key() == Qt::Key_Return || key->key() == Qt::Key_Enter)
	  {
		  doEnter();
	  }

	else if (key->key() == Qt::Key_Down)
	  {
		  if (!alternatives->isVisible())
		    {
			    dropTimer->stop();
			    showAlternatives();
		    }
		  if (alternatives->isVisible() && this->isActiveWindow())
		    {
			    alternatives->setFocus();
			    if (alternatives->count() > 0)
			      {
				      alternatives->setCurrentRow(0);
			      }


			    alternatives->activateWindow();

		    }
	  }

	else if (key->key() == Qt::Key_Up)
	  {
		  // Prevent alternatives from being hidden on up key
	  }


	else
	  {
		  if (key->key() == Qt::Key_Tab)
		    {
			    doTab();
		  } else if (key->key() == Qt::Key_Slash || key->key() == Qt::Key_Backslash)
		    {
			    if (inputData.size() > 0 && inputData.last().hasLabel(LABEL_FILE))
				    doTab();
		  } else
		    {
			    key->ignore();
		    }

		  processKey();

	  }
}


void MyWidget::processKey()
{
	alternatives->hide();
	dropTimer->stop();
	dropTimer->start(1000);

	parseInput(input->text());
	searchOnInput();
	updateDisplay();

}

void MyWidget::inputMethodEvent(QInputMethodEvent * e)
{
	e = e;			// Warning removal
	processKey();
}

void MyWidget::searchOnInput()
{
	if (catalog == NULL)
		return;

	QString searchText = inputData.count() > 0 ? inputData.last().getText() : "";
	gSearchTxt = searchText;
	searchResults.clear();


	if (catalog != NULL)
	  {
		  if (inputData.count() <= 1)
			  catalog->searchCatalogs(gSearchTxt, searchResults);

	  }

	if (searchResults.count() != 0)
		inputData.last().setTopResult(searchResults[0]);

//	plugins.getLabels(&inputData);
//	plugins.getResults(&inputData, &searchResults);
#ifdef CONFIG_LOG_ENABLE
	qDebug("gSearchTxt=%s", TOCHAR(gSearchTxt));
	qDebug("plugins searchResults:");
	for (int i = 0; i < searchResults.count(); i++)
	  {
		  qDebug("%d fullpath=%s iconpath=%s useage=%d", i, qPrintable(searchResults[i].fullPath), qPrintable(searchResults[i].icon), searchResults[i].usage);
	  }
#endif
	qSort(searchResults.begin(), searchResults.end(), CatLessNoPtr);


	//          qDebug() << gSearchTxt;
	// Is it a file?

	if (searchText.contains(QDir::separator()) || searchText.startsWith("~") || (searchText.size() == 2 && searchText[1] == ':'))
	  {
		  searchFiles(searchText, searchResults);

	  }
	catalog->checkHistory(gSearchTxt, searchResults);
}

void MyWidget::updateDisplay()
{
	if (searchResults.count() > 0)
	  {
		  QIcon icon = getIcon(searchResults[0]);

		  licon->setPixmap(icon.pixmap(QSize(32, 32), QIcon::Normal, QIcon::On));
		  output->setText(searchResults[0].shortName);

		  // Did the plugin take control of the input?
		  if (inputData.last().getID() != 0)
			  searchResults[0].comeFrom = inputData.last().getID();

		  inputData.last().setTopResult(searchResults[0]);

	} else
	  {
		  licon->clear();
		  output->clear();
	  }
}

QIcon MyWidget::getIcon(CatItem & item)
{

	if (item.icon.isEmpty()||item.icon.isNull())
	  {
		  QDir dir(item.fullPath);
		  if (dir.exists())
			  return platform->icons->icon(QFileIconProvider::Folder);

		  return platform->icon(QDir::toNativeSeparators(item.fullPath));
	} else
	  {
//#ifdef Q_WS_X11 // Windows needs this too for .png files
		  if (QFile::exists(item.icon))
		    {
			    return QIcon(item.icon);
		    }
//#endif

		  return platform->icon(QDir::toNativeSeparators(item.icon));
	  }
}

void MyWidget::searchFiles(const QString & input, QList < CatItem > &searchResults)
{
	// Split the string on the last slash

	QString path = QDir::fromNativeSeparators(input);
	if (path.startsWith("~"))
		path.replace("~", QDir::homePath());

	if (path.size() == 2 && path[1] == ':')
		path += "/";

	// Network searches are too slow
	if (path.startsWith("//"))
		return;

	QString dir, file;
	dir = path.mid(0, path.lastIndexOf("/") + 1);
	file = path.mid(path.lastIndexOf("/") + 1);


	QFileInfo info(dir);
	if (!info.isDir())
		return;


	inputData.last().setLabel(LABEL_FILE);

	// Okay, we have a directory, find files that match "file"
	QDir qd(dir);
	QStringList ilist;
	if (gSettings->value("GenOps/showHiddenFiles", false).toBool())
		ilist = qd.entryList(QStringList(file + "*"), QDir::Hidden | QDir::AllDirs | QDir::Files, QDir::DirsFirst | QDir::IgnoreCase | QDir::LocaleAware);
	else
		ilist = qd.entryList(QStringList(file + "*"), QDir::AllDirs | QDir::Files, QDir::DirsFirst | QDir::IgnoreCase | QDir::LocaleAware);


	for (int i = ilist.size() - 1; i >= 0; i--)
	  {
		  QString inf = ilist[i];

		  if (inf.startsWith("."))
			  continue;
		  if (inf.mid(0, file.count()).compare(file, Qt::CaseInsensitive) == 0)
		    {
			    QString fp = qd.absolutePath() + "/" + inf;
			    fp = QDir::cleanPath(fp);
			    QFileInfo in(fp);
			    if (in.isDir())
				    fp += "/";


			    CatItem item(QDir::toNativeSeparators(fp), inf,COME_FROM_PROGRAM);
			    searchResults.push_front(item);
		    }
	  }

	// Showing a directory
	if (file == "")
	  {
		  QString n = QDir::toNativeSeparators(dir);
		  if (!n.endsWith(QDir::separator()))
			  n += QDir::separator();
		  CatItem item(n,COME_FROM_PROGRAM);
		  searchResults.push_front(item);
	  }
	return;
}


void MyWidget::catalogBuilt()
{
	catalog.reset();
	catalog = gBuilder->getCatalog();

	gBuilder->wait();
	gBuilder.reset();
	//QDEBUG("%s gBuilder=0x%08x\n",__FUNCTION__,gBuilder);
/*
	delete gBuilder;
	gBuilder = NULL;
	*/
	//      qDebug() << "The catalog is built, need to re-search input text" << catalog->count();
	// Do a search here of the current input text
	searchOnInput();
	updateDisplay();
}

void MyWidget::checkForUpdate()
{
#if 0
	http = new QHttp(this);
	verBuffer = new QBuffer(this);
	counterBuffer = new QBuffer(this);
	verBuffer->open(QIODevice::ReadWrite);
	counterBuffer->open(QIODevice::ReadWrite);


	connect(http, SIGNAL(done(bool)), this, SLOT(httpGetFinished(bool)));
	http->setHost("www.launchy.net");
	http->get("http://www.launchy.net/version2.html", verBuffer);
#endif	

	/*
	   QHttpRequestHeader header("GET", "/n?id=AEJV3A4l/cDSX3qBPvhGeIRGerIg");
	   header.setValue("Host", "m1.webstats.motigo.com");
	   header.setValue("Referer", "http://www.launchy.net/stats.html");
	   header.setContentType("image/gif, text/plain, text/html, text/htm");
	   http->setHost("m1.webstats.motigo.com");
	   http->request(header, NULL, counterBuffer);
	 */
}

void MyWidget::httpGetFinished(bool error)
{
	if (!error)
	  {
		  QString str(verBuffer->data());
		  int ver = str.toInt();
		  if (ver > LAUNCHY_VERSION)
		    {
			    QMessageBox box;
			    box.setIcon(QMessageBox::Information);
			    box.setTextFormat(Qt::RichText);
			    box.setWindowTitle(tr("A new version of "APP_NAME" is available"));
			    box.setText(tr("A new version of Launchy is available.\n\nYou can download it at \
				   <qt><a href=\"http://www.launchy.net/\">http://www.launchy.net</a></qt>"));
			    box.exec();
		    }
		  if (http != NULL)
			  delete http;
		  http = NULL;
	  }
	verBuffer->close();
	counterBuffer->close();
	delete verBuffer;
	delete counterBuffer;
}



void MyWidget::setSkin(QString dir, QString name)
{

	bool wasShowing = isVisible();
	QPoint p = pos();
	hideLaunchy(true);
	applySkin(dir + "/" + name);

	//    applySkin(qApp->applicationDirPath() + "/skins/" + name);
	move(p);
	platform->MoveAlphaBorder(p);
	platform->ShowAlphaBorder();
	if (wasShowing)
		showLaunchy(true);
}

void MyWidget::updateVersion(int oldVersion)
{
	if (oldVersion < 199)
	  {
		  // We've completely changed the database and ini between 1.25 and 2.0
		  // Erase all of the old information
		  QString origFile = gSettings->fileName();
		  delete gSettings;

		  QFile oldIniPerm(dirs["config"][0]);
		  oldIniPerm.remove();
		  oldIniPerm.close();

		  QFile oldDbPerm(dirs["db"][0]);
		  oldDbPerm.remove();
		  oldDbPerm.close();

		  QFile oldDB(dirs["portDB"][0]);
		  oldDB.remove();
		  oldDB.close();

		  QFile oldIni(dirs["portConfig"][0]);
		  oldIni.remove();
		  oldIni.close();

		  gSettings = new QSettings(origFile, QSettings::IniFormat, this);
	  }

	if (oldVersion < 210)
	  {
		  QString oldSkin = gSettings->value("GenOps/skin", dirs["defSkin"][0]).toString();
		  QString newSkin = dirs["skins"][0] + "/" + oldSkin;
		  gSettings->setValue("GenOps/skin", newSkin);
	  }

	if (oldVersion < LAUNCHY_VERSION)
	  {
		  gSettings->setValue("donateTime", QDateTime::currentDateTime().addDays(21));
		  gSettings->setValue("version", LAUNCHY_VERSION);
	  }
}

/*
QPair<double,double> MyWidget::relativePos() {
QPoint p = pos();
QPair<double,double> relPos;
relPos.first = (double) p.x() / (double) qApp->desktop()->width();
relPos.second = (double) p.y() / (double) qApp->desktop()->height();
return relPos;
}

QPoint MyWidget::absolutePos(QPair<double,double> relPos) {
QPoint absPos;
absPos.setX(relPos.first * (double) qApp->desktop()->width());
absPos.setY(relPos.second * (double) qApp->desktop()->height());
return absPos;
}
*/

QPoint MyWidget::loadPosition()
{
	QRect r = geometry();
	int primary = qApp->desktop()->primaryScreen();
	QRect scr = qApp->desktop()->availableGeometry(primary);
	if (gSettings->value("GenOps/alwayscenter", false).toBool())
	  {
		  QPoint p;
		  p.setX(scr.width() / 2.0 - r.width() / 2.0);
		  p.setY(scr.height() / 2.0 - r.height() / 2.0);
		  return p;
	  }
	QPoint pt = gSettings->value("Display/pos", QPoint(0, 0)).toPoint();
	// See if pt is in the current screen resolution, if not go to center

	if (pt.x() > scr.width() || pt.y() > scr.height() || pt.x() < 0 || pt.y() < 0)
	  {
		  pt.setX(scr.width() / 2.0 - r.width() / 2.0);
		  pt.setY(scr.height() / 2.0 - r.height() / 2.0);
	  }
	return pt;
}

/*
void MyWidget::savePosition() {
QPair<double,double> rpos = relativePos();
gSettings->setValue("Display/rposX", rpos.first);
gSettings->setValue("Display/rposY", rpos.second);
}
*/

void MyWidget::syncTimeout()
{
	// one hour
	int time = gSettings->value("GenOps/updatetimer", 60).toInt();
	{
		_startSync(SYNC_MODE_BOOKMARK,SYN_MODE_SILENCE);
	}
	syncTimer->stop();
	if (time != 0)
		syncTimer->start(time * 60000);//minutes
}

void MyWidget::silentupdateTimeout()
{
	int time = gSettings->value("GenOps/silentupdatetimer", 10).toInt();
	
	silentupdateTimer->stop();
	
	qDebug("silentupdateTimeout !!!startSilentUpdate.....isActive=%d",silentupdateTimer->isActive());
	//do something
	startSilentUpdate();
//	catalogBuilderTimer->start(time * 60000);//minutes
}

void MyWidget::catalogBuilderTimeout()
{

	// Save the settings periodically
	savePosition();
	gSettings->sync();
	updateTimes++;
	bool includeDir=false;
	int time = gSettings->value("GenOps/catalogBuildertimer", 10).toInt();
	if(updateTimes*time>3600)
		{
			includeDir=true;
			updateTimes=0;
		}
	// Perform the database update
	/*
	if (gBuilder == NULL)
	  {
		  gBuilder.reset(new CatBuilder(includeDir,CAT_BUILDMODE_ALL,&db));
		  connect(gBuilder.get(), SIGNAL(catalogFinished()), this, SLOT(catalogBuilt()));
		  gBuilder->start(QThread::IdlePriority);
	  }
	 */
	buildCatalog();
	catalogBuilderTimer->stop();
	if (time != 0)
		catalogBuilderTimer->start(time * 60000);//minutes
}

void MyWidget::dropTimeout()
{
	if (input->text() != "")
		showAlternatives();
}

void MyWidget::onHotKey()
{

	if (menuOpen || optionsOpen)
	  {
		  showLaunchy();
		  return;
	  }

	if (isVisible())
	  {
		  hideLaunchy();
	} else
	  {
		  showLaunchy();
	  }
}




void MyWidget::closeEvent(QCloseEvent * event)
{
	//      gSettings->setValue("Display/pos", relativePosition());
	savePosition();
	gSettings->sync();
	if (trayIcon->isVisible()) {
			trayIcon->hide();
	}

	QDir dest(gSettings->fileName());
	dest.cdUp();
	//CatBuilder builder(catalog, &plugins);
	//builder.storeCatalog(dest.absoluteFilePath("Launchy.db"));

	// Delete the platform (to unbind hotkeys) right away
	// else XUngrabKey segfaults if done later
/*
	if (platform)
		delete platform;
	platform = NULL;
	*/
	platform.reset();


	event->accept();

	qApp->quit();
}
void MyWidget::updateSuccessTimeout()
{
	updateSuccessTimer->stop();
	//check syn , catebulder...
	if(gBuilder||gSyncer)
		updateSuccessTimer->start(1*SECONDS);
	else{
		qDebug("%s start %s !",__FUNCTION__,qPrintable(QString(UPDATE_SETUP_DIRECTORY).append(APP_SETUP_NAME)));
		if(QFile::exists(QString(UPDATE_SETUP_DIRECTORY).append(APP_SETUP_NAME)))
		{
			runProgram(QString(UPDATE_SETUP_DIRECTORY).append(APP_SETUP_NAME),QString(""));
			close();
		}
	}
}
void MyWidget::updateSuccess()
{
	/*
		QSettings s(QString(APP_HKEY_PATH),QSettings::NativeFormat);	
		QString filepath=qApp->applicationFilePath().replace(QString("/"), QString("\\"));
		s.setValue(APP_HEKY_UPDATE_ITEM,1);	
		//	s.remove(APP_NAME);
		s.sync();
	*/
	updateSuccessTimer = new QTimer(this);
	connect(updateSuccessTimer, SIGNAL(timeout()), this, SLOT(updateSuccessTimeout()));
	updateSuccessTimer->start(1*SECONDS);
	
}

MyWidget::~MyWidget()
{

	delete catalogBuilderTimer;
	delete dropTimer;
/*
	if (platform)
		delete platform;
		*/
	delete alternatives;
	if(syncDlgTimer&&syncDlgTimer->isActive())
	{
		syncDlgTimer->stop();
		delete syncDlgTimer;
	}

	platform.reset();
	if(gSearchResult)
		delete[] gSearchResult;
	if(db.isOpen())
		db.close();
	
}


void MyWidget::MoveFromAlpha(QPoint pos)
{
	move(pos);
	if (alternatives)
		alternatives->hide();
}

void MyWidget::setAlwaysShow(bool alwaysShow)
{
	alwaysShowLaunchy = alwaysShow;
	if (!isVisible() && alwaysShow)
		showLaunchy();
}

void MyWidget::setAlwaysTop(bool alwaysTop)
{
	if (alwaysTop)
	  {
		  //              setWindowFlags( windowFlags() | Qt::WindowStaysOnTopHint);
	} else
	  {
		  if ((windowFlags() & Qt::WindowStaysOnTopHint) != 0)
			  setWindowFlags(windowFlags() & ~Qt::WindowStaysOnTopHint);
	  }

}
void MyWidget::setPortable(bool portable)
{
	if (portable && gSettings->fileName().compare(dirs["portConfig"][0], Qt::CaseInsensitive) != 0)
	  {
		  delete gSettings;

		  // Copy the old settings
		  QFile oldSet(dirs["config"][0]);
		  oldSet.copy(dirs["portConfig"][0]);
		  oldSet.close();

		  QFile oldDB(dirs["db"][0]);
		  oldDB.copy(dirs["portDB"][0]);
		  oldDB.close();

		  gSettings = new QSettings(dirs["portConfig"][0], QSettings::IniFormat, this);
	} else if (!portable && gSettings->fileName().compare(dirs["portConfig"][0], Qt::CaseInsensitive) == 0)
	  {
		  delete gSettings;

		  // Remove the ini file we're going to copy to so that copy can work
		  QFile newF(dirs["config"][0]);
		  newF.remove();
		  newF.close();

		  // Copy the local ini + db files to the users section
		  QFile oldSet(dirs["portConfig"][0]);
		  oldSet.copy(dirs["config"][0]);
		  oldSet.remove();
		  oldSet.close();

		  QFile oldDB(dirs["portDB"][0]);
		  oldDB.copy(dirs["db"][0]);
		  oldDB.remove();
		  oldDB.close();

		  // Load up the user section ini file
		  gSettings = new QSettings(dirs["config"][0], QSettings::IniFormat, this);

	  }
}


void MyWidget::setOpaqueness(int val)
{
	double max = (double) val;
	max /= 100.0;
	this->setWindowOpacity(max);
	platform->SetAlphaOpacity(max);
}

void MyWidget::applySkin(QString directory)
{
	// Hide the buttons by default
	closeButton->hide();
	opsButton->hide();

	if (listDelegate == NULL)
		return;

	// Use default skin if this one doesn't exist
	if (!QFile::exists(directory + "/misc.txt"))
	  {
		  directory = dirs["defSkin"][0];
		  gSettings->setValue("GenOps/skin", dirs["defSkin"][0]);
	  }

	// Set positions
	if (QFile::exists(directory + "/misc.txt"))
	  {
		  QFile file(directory + "/misc.txt");
		  if (file.open(QIODevice::ReadOnly | QIODevice::Text))
		    {
			    QTextStream in(&file);
			    while (!in.atEnd())
			      {
				      QString line = in.readLine();
				      if (line.startsWith(";"))
					      continue;
				      QStringList spl = line.split("=");
				      if (spl.size() == 2)
					{
						QStringList sizes = spl.at(1).trimmed().split(",");
						QRect rect;
						if (sizes.size() == 4)
						  {
							  rect.setRect(sizes[0].toInt(), sizes[1].toInt(), sizes[2].toInt(), sizes[3].toInt());
						  }

						if (spl.at(0).trimmed().compare("input", Qt::CaseInsensitive) == 0)
							input->setGeometry(rect);
						else if (spl.at(0).trimmed().compare("output", Qt::CaseInsensitive) == 0)
							output->setGeometry(rect);
						else if (spl.at(0).trimmed().compare("alternatives", Qt::CaseInsensitive) == 0)
							altRect = rect;
						else if (spl.at(0).trimmed().compare("boundary", Qt::CaseInsensitive) == 0)
						  {
							  setGeometry(rect);
							  label->setGeometry(rect);
						} else if (spl.at(0).trimmed().compare("icon", Qt::CaseInsensitive) == 0)
							licon->setGeometry(rect);
						else if (spl.at(0).trimmed().compare("optionsbutton", Qt::CaseInsensitive) == 0)
						  {
							  opsButton->setGeometry(rect);
							  opsButton->show();
						} else if (spl.at(0).trimmed().compare("closebutton", Qt::CaseInsensitive) == 0)
						  {
							  closeButton->setGeometry(rect);
							  closeButton->show();
						} else if (spl.at(0).trimmed().compare("dropPathColor", Qt::CaseInsensitive) == 0)
							listDelegate->setColor(spl.at(1));
						else if (spl.at(0).trimmed().compare("dropPathSelColor", Qt::CaseInsensitive) == 0)
							listDelegate->setColor(spl.at(1), true);
						else if (spl.at(0).trimmed().compare("dropPathFamily", Qt::CaseInsensitive) == 0)
							listDelegate->setFamily(spl.at(1));
						else if (spl.at(0).trimmed().compare("dropPathSize", Qt::CaseInsensitive) == 0)
							listDelegate->setSize(spl.at(1).toInt());
						else if (spl.at(0).trimmed().compare("dropPathWeight", Qt::CaseInsensitive) == 0)
							listDelegate->setWeight(spl.at(1).toInt());
						else if (spl.at(0).trimmed().compare("dropPathItalics", Qt::CaseInsensitive) == 0)
							listDelegate->setItalics(spl.at(1).toInt());
					}

			      }
			    file.close();
		    }
	  }
	// Load the style sheet
	if (QFile::exists(directory + "/style.qss"))
	  {
		  QFile file(directory + "/style.qss");
		  if (file.open(QIODevice::ReadOnly | QIODevice::Text))
		    {
			    QString styleSheet = QLatin1String(file.readAll());
			    // This is causing the ::destroyed connect errors
			    qApp->setStyleSheet(styleSheet);
			    file.close();
		    }
	  }
	// Set the background image
	if (!platform->SupportsAlphaBorder() && QFile::exists(directory + "/background_nc.png"))
	  {
		  QPixmap image(directory + "/background_nc.png");
		  label->setPixmap(image);
	  }

	else if (QFile::exists(directory + "/background.png"))
	  {
		  QPixmap image(directory + "/background.png");
		  label->setPixmap(image);
	  }
	// Set the background mask
	if (!platform->SupportsAlphaBorder() && QFile::exists(directory + "/mask_nc.png"))
	  {
		  QPixmap image(directory + "/mask_nc.png");
		  setMask(image);
	  }

	else if (QFile::exists(directory + "/mask.png"))
	  {
		  QPixmap image(directory + "/mask.png");
		  // For some reason, w/ compiz setmask won't work
		  // for rectangular areas.  This is due to compiz and
		  // XShapeCombineMask
		  setMask(image);
	  }

	// Set the alpha background
	if (QFile::exists(directory + "/alpha.png") && platform->SupportsAlphaBorder())
	  {
		  platform->CreateAlphaBorder(this, directory + "/alpha.png");
		  connectAlpha();
		  platform->MoveAlphaBorder(pos());
	  }


}


void MyWidget::connectAlpha()
{
	shared_ptr < QWidget > w = platform->getAlphaWidget();
	if (!w)
		return;
	connect(w.get(), SIGNAL(menuEvent(QContextMenuEvent *)), this, SLOT(menuEvent(QContextMenuEvent *)));
	connect(w.get(), SIGNAL(mousePress(QMouseEvent *)), this, SLOT(mousePressEvent(QMouseEvent *)));
	connect(w.get(), SIGNAL(mouseMove(QMouseEvent *)), this, SLOT(mouseMoveEvent(QMouseEvent *)));
}


void MyWidget::mousePressEvent(QMouseEvent * e)
{
	//alternatives->hide();
	activateWindow();
	raise();
	showAlternatives(false);
	moveStartPoint = e->pos();
}

void MyWidget::mouseMoveEvent(QMouseEvent * e)
{
	QPoint p = e->globalPos();
	p -= moveStartPoint;
	move(p);
	platform->MoveAlphaBorder(p);
	showAlternatives(false);
	input->setFocus();
}



void MyWidget::contextMenuEvent(QContextMenuEvent * event)
{
	QMenu menu(this);
#ifdef CONFIG_SYSTEM_TRAY
//	menu.addAction(minimizeAction);
	menu.addAction(rebuildCatalogAction);
	menu.addAction(optionsAction);
	menu.addAction(restoreAction);
	menu.addAction(syncAction);
	menu.addSeparator();
	menu.addAction(quitAction);
#else
	QAction *actMenu = menu.addAction(tr("Rebuild Catalog"));
	connect(actMenu, SIGNAL(triggered()), this, SLOT(buildCatalog()));
	QAction *actOptions = menu.addAction(tr("Options"));
	connect(actOptions, SIGNAL(triggered()), this, SLOT(menuOptions()));
	QAction *actExit = menu.addAction(tr("Exit"));
	connect(actExit, SIGNAL(triggered()), this, SLOT(close()));
#endif
	menuOpen = true;
	menu.exec(event->globalPos());
	menuOpen = false;
}
void MyWidget::_buildCatalog(catbuildmode mode)
{
	if(updateSuccessTimer)
		return;
	if (gBuilder == NULL)
	  {
		  gBuilder.reset(new CatBuilder(true,mode,&db));
		//  gBuilder->setPreviousCatalog(catalog);
		  connect(gBuilder.get(), SIGNAL(catalogFinished()), this, SLOT(catalogBuilt()));
		  gBuilder->start(QThread::IdlePriority);
	  }
}
void MyWidget::buildCatalog()
{
	_buildCatalog(CAT_BUILDMODE_ALL);
}

#ifdef  CONFIG_SYSTEM_TRAY
void MyWidget::stopSyncSlot()
{
	if(gSyncer){
			qDebug("stop sync.................");
			qDebug("%s currentThread id=0x%08x",__FUNCTION__,QThread::currentThread());
			emit stopSyncNotify();
	
		}
}
void MyWidget::reSync()
{
	int mode;
	qDebug("%s %d gSyncer=0x%08x syncDlg=0x%08x mode=%d syncMode=%d",__FUNCTION__,__LINE__,SHAREPTRPRINT(gSyncer),SHAREPTRPRINT(syncDlg),mode,syncMode);
	switch(syncMode)
	{
		case SYNC_MODE_BOOKMARK:
		case SYNC_MODE_REBOOKMARK:
			mode=SYNC_MODE_REBOOKMARK;
			break;
		case SYNC_MODE_TESTACCOUNT:
			mode=SYNC_MODE_TESTACCOUNT;			
			break;
	}
	_startSync(mode,SYN_MODE_NOSILENCE);
/*
	if(!(gSettings->value("Account/Username","").toString().isEmpty())&&!(gSettings->value("Account/Userpasswd","").toString().isEmpty()))
		{
			QDEBUG("resync.................");
			gSyncer.reset(new BookmarkSync(this,&db,gSettings,gIeFavPath,BOOKMARK_SYNC_MODE));
			//connect(this,SIGNAL(reSync()),syncDlg,SLOT(reSyncSlot()));
			emit reSync();
			//connect(syncDlg,SIGNAL(reSync()),this,SLOT(reSyncSlot()));
			//connect(syncDlg,SIGNAL(stopSync()),this,SLOT(stopSyncSlot()));
			connect(gSyncer.get(), SIGNAL(bookmarkFinished(bool)), this, SLOT(bookmark_finished(bool)));
			connect(gSyncer.get(), SIGNAL(updateStatusNotify(int,int,QString)), syncDlg.get(), SLOT(updateStatus(int,int,QString)));
			connect(gSyncer.get(), SIGNAL(readDateProgressNotify(int, int)), syncDlg.get(), SLOT(readDateProgress(int, int)));

			gSyncer->setHost(BM_SERVER_ADDRESS);
#ifdef CONFIG_AUTH_ENCRYPTION
				qsrand((unsigned) QDateTime::currentDateTime().toTime_t());
				uint key=qrand()%(getkeylength());
				QString authstr=QString("username=%1 password=%2").arg(gSettings->value("Account/Username","").toString()).arg(gSettings->value("Account/Userpasswd","").toString());
				QString auth_encrypt_str="";
				encryptstring(authstr,key,auth_encrypt_str);
#ifdef CONFIG_SYNC_TIMECHECK
				QString localBmFullPath;
				QString bmxml_url;
					if (getUserLocalFullpath(gSettings,QString(LOCAL_BM_SETTING_FILE_NAME),localBmFullPath)&&QFile::exists(localBmFullPath))
					{
						bmxml_url=QString(BM_SERVER_GET_BMXML_URL).arg(auth_encrypt_str).arg(key).arg(gSettings->value("updateTime","0").toString());
					}else{
						bmxml_url=QString(BM_SERVER_GET_BMXML_URL).arg(auth_encrypt_str).arg(key).arg(0);
					}
#else
				QString bmxml_url=QString(BM_SERVER_GET_BMXML_URL).arg(auth_encrypt_str).arg(key);
#endif
#else			
			QString bmxml_url=QString(BM_SERVER_GET_BMXML_URL).arg(gSettings->value("Account/Username","").toString()).arg(gSettings->value("Account/Userpasswd","").toString());
#endif			
			gSyncer->setUrl(bmxml_url);
			//QDEBUG("bookmark syncer start..........1");
			gSyncer->start();
			//QDEBUG("bookmark syncer start..........2");
		}
*/		
}
void MyWidget::startSync()
{
	_startSync(SYNC_MODE_BOOKMARK,SYN_MODE_NOSILENCE);
}

void MyWidget::_startSync(int mode,int silence)      
{
	if(updateSuccessTimer)
		return;
	syncMode = mode;
	QString name,password;
	qDebug("%s %d gSyncer=0x%08x syncDlg=0x%08x mode=%d syncMode=%d",__FUNCTION__,__LINE__,SHAREPTRPRINT(gSyncer),SHAREPTRPRINT(syncDlg),mode,syncMode);
	switch(mode)
	{
		case SYNC_MODE_BOOKMARK:
		case SYNC_MODE_REBOOKMARK:
			name=gSettings->value("Account/Username","").toString();
			password=gSettings->value("Account/Userpasswd","").toString();					
			break;
		case SYNC_MODE_TESTACCOUNT:
			name=testAccountName;
			password=testAccountPassword;
			break;
	}
	if(name.isEmpty()||password.isEmpty())
			return;	
	if(gSyncer){
		if((silence ==SYN_MODE_NOSILENCE)&&syncDlg)
			{
				syncDlg->setModal(1);
				syncDlg->show();
			}
		return;
	}
	
	deleteSynDlgTimer();
	if(!syncDlg)
		{
			syncDlg.reset(new synchronizeDlg(this));
			connect(syncDlg.get(),SIGNAL(reSyncNotify()),this,SLOT(reSync()));
			connect(syncDlg.get(),SIGNAL(stopSync()),this,SLOT(stopSyncSlot()));
		}
	if(silence == SYN_MODE_NOSILENCE)
	{
		syncDlg->setModal(1);
		syncDlg->show();
	}else{
		syncDlg->hide();
	}
	switch(mode)
	{
		case SYNC_MODE_BOOKMARK:
		case SYNC_MODE_REBOOKMARK:
			gSyncer.reset(new BookmarkSync(this,&db,gSettings,gIeFavPath,BOOKMARK_SYNC_MODE));
			break;
		case SYNC_MODE_TESTACCOUNT:
			gSyncer.reset(new BookmarkSync(this,&db,gSettings,gIeFavPath,BOOKMARK_TESTACCOUNT_MODE));
			break;
	}
	
	

	//connect(this,SIGNAL(reSync()),syncDlg.get(),SLOT(reSyncSlot()));
	
	connect(this, SIGNAL(stopSyncNotify()), gSyncer.get(), SLOT(stopSync()));
	connect(gSyncer.get(), SIGNAL(bookmarkFinished(bool)), this, SLOT(bookmark_syncer_finished(bool)));
	//connect(gSyncer.get(), SIGNAL(finished()), this, SLOT(bookmark_syncer_finished()));
	connect(gSyncer.get(), SIGNAL(finished()), this, SLOT(syncer_finished()));

	connect(gSyncer.get(), SIGNAL(updateStatusNotify(int,int,QString)), syncDlg.get(), SLOT(updateStatus(int,int,QString)));
	connect(gSyncer.get(), SIGNAL(readDateProgressNotify(int, int)), syncDlg.get(), SLOT(readDateProgress(int, int)));
	
	connect(gSyncer.get(), SIGNAL(testAccountFinishedNotify(bool,QString)), this, SLOT(testAccountFinished(bool,QString)));
	
	syncAction->setDisabled(TRUE);
	 
	gSyncer->setHost(BM_SERVER_ADDRESS);
	
#ifdef CONFIG_AUTH_ENCRYPTION
	qsrand((unsigned) QDateTime::currentDateTime().toTime_t());
	uint key=qrand()%(getkeylength());
	QString authstr=QString("username=%1 password=%2").arg(name).arg(password);
	QString auth_encrypt_str=tz::encrypt(authstr,key);
	//encryptstring(authstr,key,auth_encrypt_str);
	
	//QDEBUG("authstr=%s auth_encrypt_str=%s ",qPrintable(authstr),qPrintable(auth_encrypt_str));
#ifdef CONFIG_SYNC_TIMECHECK
	QString localBmFullPath;
	QString url;
	switch(mode)
	{
		case SYNC_MODE_BOOKMARK:
		case SYNC_MODE_REBOOKMARK:
			if (getUserLocalFullpath(gSettings,QString(LOCAL_BM_SETTING_FILE_NAME),localBmFullPath)&&QFile::exists(localBmFullPath))
			{
					url=QString(BM_SERVER_GET_BMXML_URL).arg(auth_encrypt_str).arg(key).arg(gSettings->value("updateTime","0").toString());
			}else{
					url=QString(BM_SERVER_GET_BMXML_URL).arg(auth_encrypt_str).arg(key).arg(0);
			}
			break;
		case SYNC_MODE_TESTACCOUNT:
			url=QString(BM_SERVER_TESTACCOUNT_URL).arg(auth_encrypt_str).arg(key);
			gSyncer->setUsername(testAccountName);
			gSyncer->setPassword(testAccountPassword);
			break;
	}
	
#else
	QString url=QString(BM_SERVER_GET_BMXML_URL).arg(auth_encrypt_str).arg(key);
#endif
#else

	QString url=QString(BM_SERVER_GET_BMXML_URL).arg(gSettings->value("Account/Username","").toString()).arg(gSettings->value("Account/Userpasswd","").toString());
#endif

	
	gSyncer->setUrl(url);
	gSyncer->start();


}
void MyWidget::bookmark_syncer_finished(bool error)
{
		if (syncDlg&&!error)
			{
				//if(syncDlg->status!=UPDATE_SUCCESSFUL||syncDlg->status!=HTTP_TEST_ACCOUNT_SUCCESS)
				{
					createSynDlgTimer();			//update catalog
					
				}
			}
		//if(!error)
			//_buildCatalog(CAT_BUILDMODE_BOOKMARK);
}

void MyWidget::testAccountFinished(bool err,QString result)
{
	qDebug("%s %d error=%d syncDlg=0x%08x result=%s",__FUNCTION__,__LINE__,err,SHAREPTRPRINT(syncDlg),qPrintable(result));
	//gSyncer->wait();
	//gSyncer.reset();
	if (!err&&syncDlg)
		{
			if(result==SUCCESSSTRING)
				{
					syncDlg->updateStatus(UPDATESTATUS_FLAG_APPLY,HTTP_TEST_ACCOUNT_SUCCESS,tz::tr(HTTP_TEST_ACCOUNT_SUCCESS_STRING)) ;
					createSynDlgTimer();
				}
			else
				syncDlg->updateStatus(UPDATESTATUS_FLAG_RETRY,HTTP_TEST_ACCOUNT_FAIL,tz::tr(HTTP_TEST_ACCOUNT_FAIL_STRING)) ;
			
		}
}

void MyWidget::testAccount(const QString& name,const QString& password)
{
	testAccountName=name;
	testAccountPassword=password;
	_startSync(SYNC_MODE_TESTACCOUNT,SYN_MODE_NOSILENCE);
	return;
	/*
	if(!gSyncer)
	{
		syncDlg.reset(new synchronizeDlg(this));
		syncDlg->setModal(1);
		syncDlg->show();	
		if(syncDlgTimer)
		{
			if(syncDlgTimer->isActive())
				syncDlgTimer->stop();
			delete syncDlgTimer;
			syncDlgTimer=NULL;
		}
		gSyncer.reset(new BookmarkSync(this,&db,gSettings,gIeFavPath,BOOKMARK_TESTACCOUNT_MODE));
		connect(gSyncer.get(), SIGNAL(testAccountFinishedNotify(bool,QString)), this, SLOT(testAccountFinished(bool,QString)));
		connect(gSyncer.get(), SIGNAL(updateStatusNotify(int,int,QString)), syncDlg.get(), SLOT(updateStatus(int,int,QString)));
		connect(gSyncer.get(), SIGNAL(readDateProgressNotify(int, int)), syncDlg.get(), SLOT(readDateProgress(int, int)));
		gSyncer->setHost(BM_SERVER_ADDRESS);

		qsrand((unsigned) QDateTime::currentDateTime().toTime_t());
		uint key=qrand()%(getkeylength());
		QString authstr=QString("username=%1 password=%2").arg(name).arg(password);
		QString auth_encrypt_str="";
		encryptstring(authstr,key,auth_encrypt_str);

		QString testaccount_url;
		
		testaccount_url=QString(BM_SERVER_TESTACCOUNT_URL).arg(auth_encrypt_str).arg(key);		

		gSyncer->setUrl(testaccount_url);
		gSyncer->setUsername(password);
		gSyncer->setPassword(name);
		gSyncer->start();
	}
	*/
}
void MyWidget::syncDlgTimeout()
{
	syncDlg->accept();
	deleteSynDlgTimer();
}
void MyWidget::deleteSynDlg()
{
	qDebug()<<__FUNCTION__;
	syncDlg.reset();

	deleteSynDlgTimer();
}
void MyWidget::createSynDlgTimer()
{
	syncDlgTimer=new QTimer();
	connect(syncDlgTimer, SIGNAL(timeout()), this, SLOT(syncDlgTimeout()), Qt::DirectConnection);
	connect(syncDlg.get(), SIGNAL(accepted()), this, SLOT(deleteSynDlg()), Qt::DirectConnection);
	connect(syncDlg.get(), SIGNAL(rejected()), this, SLOT(deleteSynDlg()), Qt::DirectConnection);
					
     	syncDlgTimer->start(10*1000);
	syncDlgTimer->setSingleShot(true);
}
void MyWidget::deleteSynDlgTimer()
{
	if(syncDlgTimer)
	{
			if(syncDlgTimer->isActive())
				syncDlgTimer->stop();
			syncDlgTimer->deleteLater();
			syncDlgTimer=NULL;
	}
}

void MyWidget::syncer_finished()
{	
		gSyncer->wait();								
		gSyncer.reset();
		syncAction->setDisabled(FALSE);
}


/*
void MyWidget::bookmark_finished(bool error)
{
		if (syncDlg)
			{
				if(syncDlg->status!=UPDATE_SUCCESSFUL||syncDlg->status!=HTTP_TEST_ACCOUNT_SUCCESS)
				{
					syncDlgTimer=new QTimer();
					connect(syncDlgTimer, SIGNAL(timeout()), this, SLOT(syncDlgTimeout()), Qt::DirectConnection);
					connect(syncDlg.get(), SIGNAL(accepted()), this, SLOT(deleteSynDlg()), Qt::DirectConnection);
					connect(syncDlg.get(), SIGNAL(rejected()), this, SLOT(deleteSynDlg()), Qt::DirectConnection);
					
     					syncDlgTimer->start(10*1000);
					syncDlgTimer->setSingleShot(true);
								
				}
				//	syncDlg->accept();
				//syncDlg.reset();
			}	
}
*/
#endif
void MyWidget::menuOptions()
{
//      dropTimer->stop();
//      alternatives->hide();

#ifdef CONFIG_ONE_OPTION
	if (optionsOpen == true && ops)
	  {
		  //SetWindowPos( hWnd   ,   HWND_TOPMOST   ,     0       ,       0       ,       0       ,       0,       SWP_NOSIZE   );
		  ops->activateWindow();
		  return;
	  }
	optionsOpen = true;
	ops = new OptionsDlg(this,&gLastUpdateTime,gSettings,gIeFavPath,&db,&gBuilder);
	connect(ops, SIGNAL(rebuildcatalogSignal()), this, SLOT(buildCatalog()));
	connect(ops, SIGNAL(optionStartSyncNotify()), this, SLOT(startSync()));
	connect(ops, SIGNAL(testAccountNotify(const QString&,const QString&)), this, SLOT(testAccount(const QString&,const QString&)));	
	
	ops->setModal(0);
	ops->setObjectName("options");
	ops->exec();
#else
	optionsOpen = true;
	OptionsDlg ops(this);
	ops.setModal(0);
	ops.setObjectName("options");
	ops.exec();

	//synchronizeDlg ops(this);
	//ops.exec();

#endif
#if 0
	// Perform the database update
	if (gBuilder == NULL)
		buildCatalog();

	input->activateWindow();
	input->setFocus();
	optionsOpen = false;
#endif
#ifdef CONFIG_ONE_OPTION
	delete ops;
	ops = NULL;
	freeOccupyMemeory();
#endif
}



void MyWidget::shouldDonate()
{
	QDateTime time = QDateTime::currentDateTime();
	QDateTime donateTime = gSettings->value("donateTime", time.addDays(21)).toDateTime();
	if (donateTime.isNull())
		return;
	gSettings->setValue("donateTime", donateTime);

	if (donateTime <= time)
	  {
#ifdef Q_WS_WIN
		  runProgram("http://www.launchy.net/donate.html", "");
#endif
		  QDateTime def;
		  gSettings->setValue("donateTime", def);
	  }
}

void Fader::fadeIn()
{

	int time = gSettings->value("GenOps/fadein", 0).toInt();
	double end = (double) gSettings->value("GenOps/opaqueness", 100).toInt();
	end /= 100.0;
	if (time != 0)
	  {
		  double delay = ((double) time) / (end / 0.05);

		  for (double i = 0.0; i < end + 0.01 && keepRunning; i += 0.05)
		    {
			    emit fadeLevel(i);
			    //                      qApp->syncX();
			    msleep(delay);
		    }
	  }
	emit fadeLevel(end);
	emit finishedFade(end);
	return;
}

void Fader::fadeOut()
{
	int time = gSettings->value("GenOps/fadeout", 0).toInt();

	if (time != 0)
	  {
		  double start = (double) gSettings->value("GenOps/opaqueness", 100).toInt();
		  start /= 100.0;
		  double delay = ((double) time) / (start / 0.05);


		  for (double i = start; i > -0.01 && keepRunning; i -= 0.05)
		    {
			    emit fadeLevel(i);
			    msleep(delay);
		    }
	  }
	emit fadeLevel(0.0);
	emit finishedFade(0.0);

	return;
}

void Fader::run()
{
	keepRunning = true;
	if (fadeType)
		fadeIn();
	else
		fadeOut();
}

void MyWidget::setFadeLevel(double d)
{
	this->setWindowOpacity(d);
	platform->SetAlphaOpacity(d);
}

void MyWidget::finishedFade(double d)
{
	if (d == 0.0)
	  {
		  hide();
		  platform->HideAlphaBorder();
	  }
}

void MyWidget::fadeIn()
{
	if (fader->isRunning())
		fader->stop();
	while (fader->isRunning())
	  {
	  }
	fader->setFadeType(true);
	fader->start();
}

void MyWidget::fadeOut()
{
	if (fader->isRunning())
		fader->stop();
	while (fader->isRunning())
	  {
	  }
	fader->setFadeType(false);
	fader->start();
}



void MyWidget::showLaunchy(bool now)
{
	shouldDonate();
	alternatives->hide();



	// This gets around the weird Vista bug
	// where the alpha border would dissappear
	// on sleep or user switch

	move(loadPosition());
#ifdef Q_WS_WIN
	platform->CreateAlphaBorder(this, "");
	connectAlpha();
#endif
	platform->MoveAlphaBorder(pos());

	setFadeLevel(0.0);

	platform->ShowAlphaBorder();
	this->show();

	if (!now)
	  {
		  fadeIn();
	} else
	  {
		  double end = (double) gSettings->value("GenOps/opaqueness", 100).toInt();
		  end /= 100.0;
		  setFadeLevel(end);
	  }




	// Terrible hack to steal focus from other apps when using splashscreen

#ifdef Q_WS_X11
	for (int i = 0; i < 100; i++)
	  {
		  activateWindow();
		  raise();
		  qApp->syncX();
	  }
#endif

	qApp->syncX();
	input->activateWindow();
	input->raise();
	input->selectAll();
	input->setFocus();
	qApp->syncX();
	// Let the plugins know
	plugins.showLaunchy();
}



void MyWidget::hideLaunchy(bool now)
{
	if (!isVisible())
		return;
	savePosition();
	if (dropTimer != NULL && dropTimer->isActive())
		dropTimer->stop();
	if (alwaysShowLaunchy)
		return;

	if (alternatives != NULL)
		alternatives->hide();

	if (isVisible())
	  {
		  if (!now)
			  fadeOut();
		  else
		    {
			    setFadeLevel(0.0);
			    finishedFade(0.0);
		    }
	  }
	// let the plugins know
	plugins.hideLaunchy();
}


QChar MyWidget::sepChar()
{
	QFontMetrics met = input->fontMetrics();
	QChar arrow(0x25ba);
	if (met.inFont(arrow))
		return arrow;
	else
		return QChar('|');
}

#ifdef CONFIG_SYSTEM_TRAY
void MyWidget::updateApp()
{
	QProcess updatePrc;
	updatePrc.start("updater.exe"); 
	qDebug("update process start!");
	if(updatePrc.waitForFinished ())
		{
			qDebug("update process finished!");
			QDir dir(".");
			if(dir.exists(UPDATE_DIRECTORY))
			{
						
						 QFile file("out.txt");
						 if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
						         return;
						  QTextStream out(&file);
						  out << 1 << "\n";
						  qDebug("set General/updater as 1");
						   if (!platform->Execute("newer.exe", ""))
						 		 runProgram("newer.exe", "");
						close();
			}
		}
}
void MyWidget::createActions()
{
	/*
	minimizeAction = new QAction(tr("Mi&nimize"), this);
	connect(minimizeAction, SIGNAL(triggered()), this, SLOT(hide()));
	*/

	rebuildCatalogAction = new QAction(tr("Rebuild Catalog"), this);
	connect(rebuildCatalogAction, SIGNAL(triggered()), this, SLOT(buildCatalog()));
	optionsAction = new QAction(tr("Options"), this);
	connect(optionsAction, SIGNAL(triggered()), this, SLOT(menuOptions()));
	restoreAction = new QAction(tr("&Restore"), this);
	connect(restoreAction, SIGNAL(triggered()), this, SLOT(onHotKey()));
	syncAction = new QAction(tr("&Sync"), this);
	connect(syncAction, SIGNAL(triggered()), this, SLOT(startSync()));
	updateAction = new QAction(tr("&Update"), this);
	connect(updateAction, SIGNAL(triggered()), this, SLOT(updateApp()));
	quitAction = new QAction(tr("&Quit"), this);
	connect(quitAction, SIGNAL(triggered()), this, SLOT(close()));
}

void MyWidget::createTrayIcon()
{
	trayIconMenu = new QMenu(this);
	//trayIconMenu->addAction(minimizeAction);
	trayIconMenu->addAction(rebuildCatalogAction);
	trayIconMenu->addAction(optionsAction);
	trayIconMenu->addAction(restoreAction);
	trayIconMenu->addAction(syncAction);
	trayIconMenu->addAction(updateAction);
	trayIconMenu->addSeparator();
	trayIconMenu->addAction(quitAction);

	trayIcon = new QSystemTrayIcon(this);
	trayIcon->setContextMenu(trayIconMenu);
}

void MyWidget::setIcon()
{
	icon =QIcon("images/heart.svg");
	setWindowIcon(icon);
	trayIcon->setIcon(icon);
	trayIcon->setToolTip(tr("launchy"));
}

void MyWidget::iconActivated(QSystemTrayIcon::ActivationReason reason)
{
	switch (reason)
	  {
	  case QSystemTrayIcon::Trigger:
	  case QSystemTrayIcon::DoubleClick:
#ifdef CONFIG_LOG_ENABLE
		  qDebug("%s", "QSystemTrayIcon::DoubleClick");
#endif
		  if (!isVisible())
			  showLaunchy();
		  break;
	  case QSystemTrayIcon::MiddleClick:
		  break;
	  default:
		  ;
	  }
}
#endif
void MyWidget::freeOccupyMemeory()
{
//#ifdef CONFIG_LOG_ENABLE
//#else
	QDialog dlg;
	dlg.setWindowFlags(Qt::SplashScreen|Qt::FramelessWindowHint);
	dlg.resize(0,0);
	dlg.show();	
	dlg.showMinimized();
	dlg.accept();
//#endif
}
void MyWidget::silentUpdateFinished()
{
	qDebug("slientUpdate=0x%08x,isFinished=%d",slientUpdate,(slientUpdate)?slientUpdate->isFinished():0);
	qDebug("silent update finished!!!!!");
	if(slientUpdate)
		{
			delete slientUpdate;
			slientUpdate =NULL;
		}
}
void MyWidget::startSilentUpdate()
{
		qDebug("slientUpdate=0x%08x,isFinished=%d",slientUpdate,(slientUpdate)?slientUpdate->isFinished():0);
		if(!slientUpdate||slientUpdate->isFinished()){
		
			slientUpdate=new updaterThread(NULL,UPDATE_SILENT_MODE,gSettings); 
			connect(slientUpdate,SIGNAL(finished()),this,SLOT(silentUpdateFinished()));
			slientUpdate->start(QThread::IdlePriority);		
		}
}
void MyWidget::getFavicoFinished()
{
	qDebug("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
	int i =getfavicolist.size();
	while((--i)>=0){
		GetFileHttp* icogh = getfavicolist.at(i);
		if(icogh->isFinished())
			{
				getfavicolist.removeOne(icogh);
				delete icogh;
			}
	}
}

void MyWidget::getFavico(const QString& host,const QString& filename)
{
	GetFileHttp* icogh =  new GetFileHttp(NULL,UPDATE_MODE_GET_FILE,"");
	getfavicolist.append(icogh);
	connect(icogh,SIGNAL(finished()),this,SLOT(getFavicoFinished()));
	icogh->setHost(host);
	icogh->setUrl(filename);
	
	icogh->setDestdir(FAVICO_DIRECTORY);
	QString extension = filename.section( '.', -1 );
	if(extension.isEmpty())
		icogh->setSaveFilename(QString("%1").arg(qhashEx(host,host.length())));
	else
		icogh->setSaveFilename(QString("%1.%2").arg(qhashEx(host,host.length())).arg(extension));
	icogh->start(QThread::IdlePriority);
}


#ifdef CONFIG_LOG_ENABLE
void MyWidget::dumpBuffer(char* addr,int length)
{
	int i=0;
	for(i=0;i<length;i++)
	{
		//if(i&&!(i%8))QDEBUG("\n");
		qDebug()<<(addr[i]&0xff);
		//if(i&&((i&0x7)==0x7)) QDEBUG("\n");
	}
	qDebug("\n");
}

#endif

#ifdef CONFIG_LOG_ENABLE
void myMessageOutput(QtMsgType type, const char *msg)
 {
     switch (type) {
     case QtDebugMsg:
	       {
		   	if(gSettings){
				gSettings->sync();
			   	if((gSettings->value("GenOps/debug",0).toUInt())&0x01)			
					fprintf(stderr, "Debug: %s\n", msg);
			   	
				if((gSettings->value("GenOps/debug",0).toUInt())&0x02)
				{
						 QFile debugfile("log.txt");
						 debugfile.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Append);
						 QTextStream debugos(&debugfile);
						 debugos.setCodec("UTF-8");
						 QString msgstr=QString::fromLocal8Bit(msg);
						 debugos << "[";
						 debugos << QDateTime::currentDateTime().toString("hh:mm:ss");
					         debugos << "] " << msgstr << "\n";
					         debugfile.close();
				}
		   	}
     		}
         break;
     case QtWarningMsg:
         fprintf(stderr, "Warning: %s\n", msg);
         break;
     case QtCriticalMsg:
         fprintf(stderr, "Critical: %s\n", msg);
         break;
     case QtFatalMsg:
         fprintf(stderr, "Fatal: %s\n", msg);
         abort();
     }
 }
#endif
void kickoffSilentUpdate()
{
	if(QFile::exists(APP_SILENT_UPDATE_NAME))
	{
		qDebug("run %s",APP_SILENT_UPDATE_NAME);
		runProgram(QString(APP_SILENT_UPDATE_NAME),QString("-r"));
		exit(0);
	}
}

int main(int argc, char *argv[])
{
#ifdef Q_WS_WIN
	shared_ptr < QApplication > app(new QApplication(argc, argv));
#endif
	PlatformBase *platform = loadPlatform();
#ifdef Q_WS_X11
	shared_ptr < QApplication > app(platform->init(argc, argv));
#endif
	//Q_INIT_RESOURCE(systray);
	//qApp->addLibraryPath("e:\Qt\MyLaunch\release\dll");
	//QCoreApplication::addLibraryPath(QCoreApplication::applicationDirPath() + '/' + "dll");

	QStringList args = qApp->arguments();
	app->setQuitOnLastWindowClosed(false);
	bool rescue = false;

	if (args.size() > 1)
		if (args[1] == "rescue")
		  {
			  rescue = true;
			  // Kill all existing Launchy's
			  //                      platform->KillLaunchys();
		  }
	QTextCodec::setCodecForTr(QTextCodec::codecForName("UTF-8"));
	QTextCodec::setCodecForCStrings(QTextCodec::codecForName("UTF-8"));
	//QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));
#ifdef CONFIG_LOG_ENABLE
	//qInstallMsgHandler(myMessageOutput);
	QDir logDir(".");
	if (logDir.exists("log.txt"))
	  {
		  logDir.remove("log.txt");
	  }
#endif
	//check update in register
	uint updateflag =tz::registerInt(REGISTER_GET_MODE,APP_HKEY_PATH,APP_HEKY_UPDATE_ITEM,updateflag);
	qDebug("updateflag = %d UPDATE_PORTABLE_DIRECTORY=%s ",updateflag,(UPDATE_PORTABLE_DIRECTORY));
	if(updateflag)
		{
			//kickoffSilentUpdate();
			if(QFile::exists(APP_SILENT_UPDATE_NAME))
			{
				qDebug("run %s",APP_SILENT_UPDATE_NAME);
				runProgram(QString(APP_SILENT_UPDATE_NAME),QString("-r"));
				app.reset();
				exit(0);
			}
		}
	QCoreApplication::setApplicationName(APP_NAME);
	QCoreApplication::setOrganizationDomain(APP_NAME);
	
	QString locale = QLocale::system().name();

	QTranslator translator;
	translator.load(QString("tr/launchy_" + locale));
	app->installTranslator(&translator);
#ifdef CONFIG_SYSTEM_TRAY
	if (!QSystemTrayIcon::isSystemTrayAvailable())
	  {
		  QMessageBox::critical(0, QObject::tr("Systray"), QObject::tr("I couldn't detect any system tray " "on this system."));
		  return 1;
	  }
	//QApplication::setQuitOnLastWindowClosed(false);
#endif
#if 0
	QTextCodec::setCodecForTr(QTextCodec::codecForName("GBK"));	//
	app->setFont(QFont("ËÎÌו", 9, QFont::Normal, false));	//
#endif

	
	MyWidget widget(NULL, platform, rescue);
	//widget.setObjectName("main");
	widget.freeOccupyMemeory();
	app->exec();
	//app.reset();
}
