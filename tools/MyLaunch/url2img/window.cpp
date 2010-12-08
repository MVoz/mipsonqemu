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

#include <QtGui>

#include "window.h"
#include <windows.h>

#include <shlobj.h>

#include <tchar.h>

#define IECAPT_PROGRAM   "/cap.exe"
#define IECAPT_PROGRAM_NAME   "cap.exe"



QSqlDatabase local_db;
QSqlDatabase server_db;
QSettings *gSettings;
QPlainTextEdit *logedit;
QMap<int,QString> classmap;
QMap<QString,int> classxmap;
QMap<int,QString> tagmap;
QList<struct class_map> classlist;
uint qhashEx(QString str, int len)
{
	uint h = 0;
	int g=0;
	int i=0;
	while (len--) {
		QChar c=str.at(i++);
		h = ((h) << 4) +c.unicode();
		if ((g = (h & 0xf0000000)) != 0)
			h ^= g >> 23;
		h &= ~g;
	}
	return h;
}
#ifdef WAIT_FOR_SINGLE
BOOL runProgram(QString path, QString args,STARTUPINFO *si,PROCESS_INFORMATION *pi) 
#else
void runProgram(QString path, QString args) 
#endif
{

#ifdef WAIT_FOR_SINGLE
		ZeroMemory( si, sizeof(*si) );
		si->cb = sizeof(*si);
		ZeroMemory( pi, sizeof(*pi) );
		QString patharg=path+" "+args;
	
		// Start the child process. 
		if( !CreateProcess( NULL,	// No module name (use command line)
			 (LPWSTR) patharg.utf16(),		// Command line
			NULL,			// Process handle not inheritable
			NULL,			// Thread handle not inheritable
			FALSE,			// Set handle inheritance to FALSE
			0,				// No creation flags
			NULL,			// Use parent's environment block
			NULL,			// Use parent's starting directory 
			si,			// Pointer to STARTUPINFO structure
			pi )			// Pointer to PROCESS_INFORMATION structure
		) 
		{
			return FALSE;
		}
		return TRUE;
#else
	SHELLEXECUTEINFO ShExecInfo;
	ShExecInfo.cbSize = sizeof(SHELLEXECUTEINFO);
	ShExecInfo.fMask = SEE_MASK_FLAG_NO_UI;
	ShExecInfo.hwnd = NULL;
	ShExecInfo.lpVerb = NULL;
	ShExecInfo.lpFile = (LPCTSTR) (path).utf16();
	if (args != "") {
		ShExecInfo.lpParameters = (LPCTSTR) args.utf16();
	} else {
		ShExecInfo.lpParameters = NULL;
	}

	QDir dir(path);
	QFileInfo info(path);
	if (!info.isDir() && info.isFile())
		dir.cdUp();

	ShExecInfo.lpDirectory = (LPCTSTR)QDir::toNativeSeparators(dir.absolutePath()).utf16();
	ShExecInfo.nShow = SW_NORMAL;
	ShExecInfo.hInstApp = NULL;
	ShellExecuteEx(&ShExecInfo);
#endif
}

DWORD GetSpecifiedProcessById(DWORD processId)
{
	DWORD id=0;
	HANDLE hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0) ;
	PROCESSENTRY32 pInfo; 
	pInfo.dwSize = sizeof(pInfo);
	Process32First(hSnapShot, &pInfo) ; 
	do
	{
		if((pInfo.th32ProcessID ==processId)&&(lstrcmp(_wcslwr(_wcsdup(pInfo.szExeFile)), QString(IECAPT_PROGRAM_NAME).utf16()) == 0))
		{
			id = pInfo.th32ProcessID ;
			break ;
		}
	}while(Process32Next(hSnapShot, &pInfo) != FALSE);
	return id;
} 

/*
void GetWindowCommandLine(QString& buf,DWORD pid)
{
// LPTSTR  *P=::GetCommandLine();
 LPTSTR *pEvn;
 LPTSTR *pAddr;
 LPTSTR  *pFunction;
 pFunction=(LPTSTR *)::GetCommandLine();
 memcpy(&pAddr,pFunction+1,sizeof(LPTSTR *));
 DWORD dwRet;
 HANDLE hProcess=::OpenProcess(PROCESS_ALL_ACCESS, false,pid);
 ::ReadProcessMemory(hProcess, pAddr,&pEvn, sizeof(DWORD),&dwRet);
 char Buff[512];
 ::ReadProcessMemory(hProcess, pEvn, Buff, 512, &dwRet);
 buf=QString("%1").arg(Buff);
 CloseHandle(hProcess);
}
*/
Window::Window()
{
	currenttime = QDateTime::currentDateTime().toString("yyyymmddhhmmss");
	model = NULL;
	ftpmode = 0;
	ftp = NULL;
	ftpfile = NULL;
	thread = NULL;
	successfulNums = 0;
	failedNums = 0;
	totalNums = 0;
	fileflag = 0;
	nowRow = 0;
	installEnvironment();

	getTagDataFromServer(0);

	sourceGroupBox = new QGroupBox(tr("Original Model"));
	midGroupBox = new QGroupBox(tr("mid"));
	bottomGroupBox = new QGroupBox(tr("command"));

	sourceView = new QTreeView;
	sourceView->setRootIsDecorated(false);
	sourceView->setAlternatingRowColors(true);

	getTagBtn=new QPushButton("Get Tag");
	getDataBtn=new QPushButton("Get Data(F2)");
	getDataBtn->setShortcut(tr("F2"));
	snapBtn=new QPushButton("Snap(F3)");
	snapBtn->setShortcut(tr("F3"));
	commitBtn=new QPushButton("Commit(F12)");
	commitBtn->setShortcut(tr("F12"));
	
         tableComboBox = new QComboBox();
	tableComboBox->insertItem(0, "link");
         tableComboBox->insertItem(1, "site");

	trynumLabel = new QLabel(tr("TryNum:"));
	trynumLineEdit_s = new QLineEdit("");
	trynumLabel->setBuddy(trynumLineEdit_s);
	
	trynumlineLabel = new QLabel(tr("-"));
	trynumLineEdit_e = new QLineEdit("");
	trynumlineLabel->setBuddy(trynumLineEdit_e);

	getnumLabel = new QLabel(tr("GetNum:"));
	getnumLineEdit = new QLineEdit("");
	getnumLabel->setBuddy(getnumLineEdit);

	snapnumLabel = new QLabel(tr("SnapNum:"));
	snapnumLineEdit = new QLineEdit("");
	snapnumLabel->setBuddy(snapnumLineEdit);

	
	startIdLabel = new QLabel(tr("ID Start:"));
	startIdLineEdit = new QLineEdit("");
	startIdLabel->setBuddy(startIdLineEdit);

	automode = new QCheckBox("Auto");
	applyparameter = new QPushButton("Apply"); 
	
		 
	quitButton = new QPushButton(tr("Quit"));
	QVBoxLayout *bottomlayout = new QVBoxLayout;
	buttonBox = new QDialogButtonBox;

	buttonBox->addButton(getTagBtn, QDialogButtonBox::ActionRole);
	buttonBox->addButton(getDataBtn, QDialogButtonBox::ActionRole);
	buttonBox->addButton(snapBtn, QDialogButtonBox::ActionRole);
	buttonBox->addButton(commitBtn, QDialogButtonBox::ActionRole);
	buttonBox->addButton(quitButton, QDialogButtonBox::RejectRole);

	QGroupBox *parameterGroupBox=new QGroupBox;
	
	QHBoxLayout *parameterLayout = new QHBoxLayout;
           parameterLayout->addWidget(tableComboBox);

	  parameterLayout->addWidget(startIdLabel);	  
	  parameterLayout->addWidget(startIdLineEdit);	
		   
	  parameterLayout->addWidget(trynumLabel);	  
	  parameterLayout->addWidget(trynumLineEdit_s);	
	  parameterLayout->addWidget(trynumlineLabel);	
	  parameterLayout->addWidget(trynumLineEdit_e);	
	  parameterLayout->addWidget(getnumLabel);		  
	  parameterLayout->addWidget(getnumLineEdit);	
	  parameterLayout->addWidget(snapnumLabel);	
	  parameterLayout->addWidget(snapnumLineEdit);	
	  parameterLayout->addWidget(automode);
	  parameterLayout->addWidget(applyparameter);	
	  connect(applyparameter, SIGNAL(clicked(bool)),this, SLOT(applyParameter(bool)));

	

	  
	  parameterGroupBox->setLayout(parameterLayout);

	  
	bottomlayout->addWidget(buttonBox);
	bottomGroupBox->setLayout(bottomlayout);

	QHBoxLayout *sourceLayout = new QHBoxLayout;
	sourceLayout->addWidget(sourceView);
	sourceGroupBox->setLayout(sourceLayout);

	QHBoxLayout *midLayout = new QHBoxLayout;

	itemGroupBox = new QGroupBox(tr("item"));
	logGroupBox = new QGroupBox(tr("log"));

	midLayout->addWidget(itemGroupBox);

	QVBoxLayout *itemLayout = new QVBoxLayout;

	QGridLayout *itemGridLayout = new QGridLayout;

	uint line=0;
	idLabel = new QLabel(tr("ID:"));
	idLineEdit = new QLineEdit("");
	idLabel->setBuddy(idLineEdit);
	idLineEdit->setReadOnly(true);
	itemGridLayout->addWidget(idLabel,line,0);
	itemGridLayout->addWidget(idLineEdit,line,1,1,1);
	line++;

	classidLabel = new QLabel(tr("ClassID:"));
	classidLineEdit = new QLineEdit("");
	classidLabel->setBuddy(classidLineEdit);
	itemGridLayout->addWidget(classidLabel,line,0);
	itemGridLayout->addWidget(classidLineEdit,line,1,1,1);
	line++;
	classnameGroupBox=new QGroupBox(tr(""));

	QVBoxLayout *classtabLayout = new QVBoxLayout;

	classbtns=new QButtonGroup;	
	classbtns->setExclusive(false);
	QTabWidget* classtab;
	QHBoxLayout *classtabbox;

	uint class_i=0;
	for (int i = 0; i < classlist.size(); ++i) 
	{
		QWidget *w=new QWidget();
		classtabbox=new QHBoxLayout;
		w->setLayout(classtabbox);
		if(!(i%18))
		{
			classtab=new QTabWidget();
			classtablist.push_back(classtab);
			classtabLayout->addWidget(classtab);
		}

		QMap<uint,QString>::const_iterator mapi = classlist[i].map.constBegin();
		while (mapi !=( classlist[i].map.constEnd())) {
			QRadioButton *ab=new QRadioButton(mapi.value());

			classbtns->addButton(ab,mapi.key());
			classtabbox->addWidget(ab);
			++mapi;
		}
		classtab->addTab(w,classlist[i].classname);
	}

	connect(classbtns, SIGNAL(buttonClicked(int)),this, SLOT(classbuttonClicked(int)));

	classnameGroupBox->setLayout(classtabLayout);	
	itemGridLayout->addWidget(classnameGroupBox,line,0,1,2);
	line++;

	nameLabel = new QLabel(tr("Name:"));
	nameLineEdit = new QLineEdit("");
	nameLabel->setBuddy(nameLineEdit);
	itemGridLayout->addWidget(nameLabel,line,0);
	itemGridLayout->addWidget(nameLineEdit,line,1,1,1);
	line++;

	urlLabel = new QLabel(tr("url:"));
	urlLineEdit = new QLineEdit("");
	urlLineEdit->setReadOnly(true);
	urlLabel->setBuddy(urlLineEdit);
	itemGridLayout->addWidget(urlLabel,line,0);
	itemGridLayout->addWidget(urlLineEdit,line,1,1,1);
	line++;

	tagLabel = new QLabel(tr("Tag:"));
	tagLineEdit = new QLineEdit("");
	tagLabel->setBuddy(tagLineEdit);
	itemGridLayout->addWidget(tagLabel,line,0);
	itemGridLayout->addWidget(tagLineEdit,line,1,1,1);
	line++;

	tagnameGroupBox=new QGroupBox(tr(""));

	QHBoxLayout *tagtabLayout = new QHBoxLayout;
	tagtab=new QTabWidget();

	QWidget *wdn=new QWidget();

	QGridLayout *tagLayout = new QGridLayout;
	tagbtns=new QButtonGroup;

	QMapIterator<int,QString> mapj(tagmap);
	uint tag_i=0;
	while (mapj.hasNext()) {
		mapj.next();
		qDebug() << mapj.key() << ": " << mapj.value() ;
		QCheckBox *ab=new QCheckBox(mapj.value());
		//ab->setFlat(true);
		QPalette newPalette = ab->palette();
		newPalette.setColor(QPalette::ButtonText, QColor(16,103,8));
		ab->setPalette(newPalette);

		tagbtns->addButton(ab,mapj.key());
		tagLayout->addWidget(ab,(tag_i%5),(tag_i/5),1,1);
		tag_i++;
	}	
	wdn->setLayout(tagLayout);

	tagtab->addTab(wdn,"music");


	tagtabLayout->addWidget(tagtab);
	tagnameGroupBox->setLayout(tagtabLayout);

	connect(tagbtns, SIGNAL(buttonClicked(int)),this, SLOT(tagbuttonClicked(int)));
	itemGridLayout->addWidget(tagnameGroupBox,line,0,1,2);
	line++;
	imgGroupBox=new QGroupBox(tr(""));
	QVBoxLayout *imgLayout = new QVBoxLayout;
	imgLabel=new QLabel(tr("load image......"));
	imgLayout->addWidget(imgLabel);
	imgGroupBox->setLayout(imgLayout);
	itemGridLayout->addWidget(imgGroupBox,0,2,line,1);
	desLabel = new QLabel(tr("Des:"));
	desTextEdit = new QTextEdit("");
	desLabel->setBuddy(desTextEdit);
	itemGridLayout->addWidget(desLabel,line,0);
	itemGridLayout->addWidget(desTextEdit,line,1,1,2);
	line++;

	itemButtonBox = new QDialogButtonBox;
	itemPrevBtn= new QPushButton("prev");
	itemPrevBtn->setShortcut(QKeySequence::MoveToPreviousChar);
	itemNextBtn= new QPushButton("next");
	itemNextBtn->setShortcut(QKeySequence::MoveToNextChar);
	itemApplyBtn= new QPushButton("apply");
	itemSnapBtn= new QPushButton("snap");

	itemButtonBox->addButton(itemPrevBtn, QDialogButtonBox::ActionRole);
	itemButtonBox->addButton(itemSnapBtn, QDialogButtonBox::ActionRole);
	itemButtonBox->addButton(itemApplyBtn, QDialogButtonBox::ActionRole);
	itemButtonBox->addButton(itemNextBtn, QDialogButtonBox::ActionRole);

	connect(itemPrevBtn, SIGNAL(clicked(bool)),this, SLOT(itemPrevBtnClicked(bool)));
	connect(itemNextBtn, SIGNAL(clicked(bool)),this, SLOT(itemNextBtnClicked(bool)));
	connect(itemApplyBtn, SIGNAL(clicked(bool)),this, SLOT(itemApplyBtnClicked(bool)));
	connect(itemSnapBtn, SIGNAL(clicked(bool)),this, SLOT(itemSnapBtnClicked(bool)));

	itemGridLayout->addWidget(itemButtonBox,line,0,1,3);
	line++;
	itemGroupBox->setLayout(itemGridLayout);
	midLayout->addWidget(logGroupBox);
	QHBoxLayout *logLayout = new QHBoxLayout;
	logGroupBox->setLayout(logLayout);

	logedit = new QPlainTextEdit;
	logedit->setObjectName(QString::fromUtf8("sqlEdit"));
	logedit->setMaximumBlockCount(1024);
	logedit->setReadOnly(TRUE);
	logLayout->addWidget(logedit);
	midGroupBox->setLayout(midLayout);
	connect(getTagBtn, SIGNAL(clicked(bool)),this, SLOT(getTagDataFromServer(bool)));
	connect(getDataBtn, SIGNAL(clicked(bool)),this, SLOT(getUrlDataFromServer(bool)));
	connect(snapBtn, SIGNAL(clicked(bool)),this, SLOT(startUrlSnap(bool)));
	connect(commitBtn, SIGNAL(clicked(bool)),this, SLOT(modelCommit(bool)));
	snapBtn->setEnabled(false);
	commitBtn->setEnabled(true);
	QGridLayout *mainLayout = new QGridLayout;
	mainLayout->addWidget(sourceGroupBox,0,0);
	mainLayout->addWidget(midGroupBox,1,0);
	mainLayout->addWidget(parameterGroupBox,2,0);
	mainLayout->addWidget(bottomGroupBox,3,0);
	setLayout(mainLayout);
	setWindowTitle(tr("url2img"));
	showMaximized();
	successfulNums=0;
	failedNums=0;
	totalNums=0;
	fileflag=0;

	trynumLineEdit_s->setText(QString("%1").arg(gSettings->value("trynum_s",0).toUInt()));
	trynumLineEdit_e->setText(QString("%1").arg(gSettings->value("trynum_e",3).toUInt()));

	getnumLineEdit->setText(QString("%1").arg(gSettings->value("getnum",20).toUInt()));
	snapnumLineEdit->setText(QString("%1").arg(gSettings->value("snapnum",10).toUInt()));

	if(gSettings->value("automode",FALSE).toBool())
	automode->setCheckState(Qt::Checked);

	if(gSettings->value("table","link").toString()=="link")
		tableComboBox->setCurrentIndex(0);
	else
		tableComboBox->setCurrentIndex(1);
	if(tableComboBox->currentIndex()==0){
		startIdLineEdit->setText(QString("%1").arg(gSettings->value("linkid",10).toUInt()));
	}else{
		startIdLineEdit->setText(QString("%1").arg(gSettings->value("siteid",10).toUInt()));
	}

	if(gSettings->value("automode",FALSE).toBool())
	{
		//automode
		getUrlDataFromServer(0);
	}
}
void Window::itemPrevBtnClicked(bool status)
{
	if(nowRow>0)
	{
		nowRow--;
		activatedAction(model->index(nowRow,LINK_TABLE_ID));
	}

}
void Window::itemNextBtnClicked(bool status)
{
	totalNums=model->rowCount();
	if(nowRow<(totalNums-1))
	{
		nowRow++;
		activatedAction(model->index(nowRow,LINK_TABLE_ID));
	}
}

void Window::itemApplyBtnClicked(bool status)
{
	model->setData(model->index(nowRow, LINK_TABLE_ID), idLineEdit->text());
	model->setData(model->index(nowRow, LINK_TABLE_NAME),  nameLineEdit->text());
	model->setData(model->index(nowRow, LINK_TABLE_URL),  urlLineEdit->text());
	model->setData(model->index(nowRow, LINK_TABLE_TAG),  tagLineEdit->text());
	model->setData(model->index(nowRow, LINK_TABLE_DESCRIPTION),  desTextEdit->toPlainText());
}

void Window::itemSnapBtnClicked(bool status)
{

}

void Window::classbuttonClicked(int id)
{
	QString cis=classidLineEdit->text();

	QList<QAbstractButton *> btn_list=classbtns->buttons();
	cis.clear();
	for(int i=0;i<btn_list.size();i++)
	{
		if(btn_list[i]->isChecked())
		{
			if(cis.isEmpty())
			{
				cis=QString("%1").arg(classmap[classbtns->id(btn_list[i])]);
			}else{
				cis=QString("%1,%2").arg(cis).arg(classmap[classbtns->id(btn_list[i])]);
			}
		}
	}

	classidLineEdit->setText(cis);
}
void Window::tagbuttonClicked(int id)
{
	qDebug()<<id;
	QString cis=tagLineEdit->text();
	if(cis.isEmpty())
	{
		cis=QString("%1").arg(tagmap[id]);
	}else{
		cis=QString("%1 %2").arg(cis).arg(tagmap[id]);
	}
	tagLineEdit->setText(cis);
}

void uninstallEnvironment()
{
	if(local_db.isOpen())
		local_db.close();
	if(gSettings)
		delete gSettings;
	//close tag db
	server_db.close();
}
Window::~Window(){
	uninstallEnvironment();
}
bool isPrivateIp(QString s)
{
	QUrl url(s);
	if (!url.isValid() || ((url.scheme().toLower() != QLatin1String("http"))&&(url.scheme().toLower() != QLatin1String("https")))) {
		qDebug()<<"unvalid http format!";
		return true;
	} else {
		qDebug()<<url.host();
		QRegExp private_ipreg("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$");
		if(private_ipreg.exactMatch(url.host())){
			qDebug()<<"match!";
			uint ip1,ip2,ip3,ip4;
			sscanf(url.host().toUtf8(),"%u.%u.%u.%u",&ip1,&ip2,&ip3,&ip4);
			qDebug()<<ip1<<ip2<<ip3<<ip4;
			//multicast
			if(ip1>=224)
				return true;
			if(ip2>255||ip3>255||ip4>255)
				return true;
			//10.0.0.0
			if(ip1==10)
				return true;
			//172.16.0.0～172.31.0.0
			if((ip1==172)&&(ip2>=16&&ip2<=31))
				return true;
			//192.168.0.0～192.168.255.0
			if((ip1==192)&&(ip2==168))
				return true;
			//127.0.0.1
			if((ip1==127)&&(ip2==0)&&(ip3==0)&&(ip4==1))
				return true;
			//0.0.0.0
			if((!ip1)&&(!ip2)&&(!ip3)&&(!ip4))
				return true;			
			return false;
		}else{
			return false;
		}
		return false;
	}
}

void installEnvironment()
{
	//initial gsetting
	gSettings = new QSettings(G_SETTING_NAME, QSettings::IniFormat, NULL);
	//initial db
	local_db = QSqlDatabase::addDatabase("QSQLITE", G_DB_NAME);
	uint createDbFlag=0;
	if(!QFile::exists(G_DB_NAME)) createDbFlag=1;

	//QSqlDatabase::addDatabase("QSQLITE", G_DB_NAME);
	local_db.setDatabaseName(G_DB_NAME);
	if(local_db.open()){
		//qDebug()<<"open the database "<<G_DB_NAME;
		if(createDbFlag){
			QString s;
			s=QString("DROP TABLE %1").arg(G_DB_TABLE_NAME);
			QSqlQuery query(s,local_db);
			query.exec();	
			s=QString("CREATE TABLE %1 ("
				"tagid INTEGER PRIMARY KEY AUTOINCREMENT, "
				"tagname VARCHAR(1024) NOT NULL, "
				"hashname INTEGER NOT NULL, "
				"uid INTEGER NOT NULL, "
				"classid INTEGER NOT NULL, "
				"dateline INTEGER NOT NULL, "
				"totalnum INTEGER NOT NULL)").arg(G_DB_TABLE_NAME);
			query=QSqlQuery(s,local_db);
			query.exec(s);
			query.clear();

			s=QString("DROP TABLE %1").arg(G_DB_LINKCLASSTAG_TABLE_NAME);
			query=QSqlQuery(s,local_db);
			query.exec();	
			s=QString("CREATE TABLE %1 ("
				"classid INTEGER PRIMARY KEY AUTOINCREMENT, "
				"uid VARCHAR(1024) NOT NULL, "
				"classname INTEGER NOT NULL, "
				"groupid INTEGER NOT NULL, "
				"parentid INTEGER NOT NULL) ").arg(G_DB_LINKCLASSTAG_TABLE_NAME);
			query=QSqlQuery(s,local_db);
			query.exec(s);
		}
	}else{
		exit(1);
	}
	//initial tag db
	server_db = QSqlDatabase::addDatabase("QMYSQL");  
	server_db.setHostName(gSettings->value("hostname", "").toString());
	server_db.setDatabaseName(gSettings->value("databasename", "").toString());
	server_db.setUserName(gSettings->value("db_username", "").toString());
	server_db.setPassword(gSettings->value("db_password", "").toString());
	if(server_db.open())
	{
	}else{
		QMessageBox::critical(0, QObject::tr("url2img"), QObject::tr("I couldn't connect the mysql server!"));
		exit(1);
	}

	//inital classmap
	QString queryStr=QString("SELECT classid,classname,groupid FROM %1 where groupid>=2000 and groupid<3000").arg(G_DB_LINKCLASSTAG_TABLE_NAME);
	QSqlQuery query(queryStr,local_db);
	query.exec(queryStr);
	QSqlRecord rec = query.record();							   
	uint classid_id = rec.indexOf("classid"); 
	uint classname_id = rec.indexOf("classname"); 
	uint groupid_id = rec.indexOf("groupid"); 
	while(query.next()) {	
		uint classid=query.value(classid_id).toUInt();
		uint groupid=query.value(groupid_id).toUInt();
		QString classname=query.value(classname_id).toString();
		classmap.insert(classid,classname);
		classxmap.insert(classname,classid);
		struct class_map cm;
		cm.classid=classid;
		cm.classname=classname;
		{ 
			QString s=QString("SELECT classid,classname FROM %1 where parentid=%2").arg(G_DB_LINKCLASSTAG_TABLE_NAME).arg(groupid);
			QSqlQuery q(s,local_db);
			q.exec(s);	
			QSqlRecord r = q.record();
			uint child_classid_id = rec.indexOf("classid"); 
			uint child_classname_id = rec.indexOf("classname"); 
			while(q.next()) {
				uint child_classid=q.value(child_classid_id).toUInt();
				QString child_classname=q.value(child_classname_id).toString();
				cm.map.insert(child_classid,child_classname);
				classmap.insert(child_classid,child_classname);
				classxmap.insert(child_classname,child_classid);
			}
		}

		classlist.push_back(cm);
	}
	query.clear();
}

void Window::setSourceModel(QAbstractItemModel *model)
{
	//   proxyModel->setSourceModel(model);
	//  sourceView->setModel(model);
}
void Window::snapSuccessful(int modelIndex)
{
	successfulNums++;
	QString txtUrlFilename=QString("content/%1.jpg.txt").arg(model->data(model->index(modelIndex, LINK_TABLE_MD5URL)).toString());
	//qDebug()<<txtUrlFilename;
	if(QFile::exists(txtUrlFilename))
	{
		//qDebug()<<"successful "<<txtUrlFilename;
		QFile file(txtUrlFilename);
		if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
		{
			return;
		}
		//qDebug()<<"1 successful "<<txtUrlFilename;
		while (!file.atEnd()) {
			QString line = QString::fromLocal8Bit(file.readLine());
			//qDebug()<<line;
			if(line.startsWith("title=", Qt::CaseInsensitive))
			{
				if(tableComboBox->currentText()=="link"){
					line.remove(0,sizeof("title=")-1);
					line.replace(",", " ");
					line.replace( QString::fromUtf8("，")," ");
					model->setData(model->index(modelIndex, LINK_TABLE_NAME), line);
				}
			}else if(line.startsWith("Keywords=", Qt::CaseInsensitive))
			{
				line.remove(0,sizeof("Keywords=")-1);
				line.replace(",", " ");
				line.replace("|", " ");
				line.replace( QString::fromUtf8("，")," ");
				line.replace( QString::fromAscii("，")," ");
				line.replace( QString::fromLatin1("，")," ");
				line.replace( QString::fromLocal8Bit("，")," ");
				model->setData(model->index(modelIndex, LINK_TABLE_TAG), line);
			}else if(line.startsWith("Description=", Qt::CaseInsensitive))
			{
				line.remove(0,sizeof("Description=")-1);
				model->setData(model->index(modelIndex, LINK_TABLE_DESCRIPTION), line);
			}
		}
		file.close();	
		//QFile::remove(txtUrlFilename);
	}
	//qDebug()<<"fail "<<txtUrlFilename;
	model->setData(model->index(modelIndex, LINK_TABLE_PICFLAG), 1);
	model->setData(model->index(modelIndex, LINK_TABLE_UPDATEFLAG), 1);
	uint trynum=model->data(model->index(modelIndex, LINK_TABLE_TRYNUM)).toUInt();
	model->setData(model->index(modelIndex, LINK_TABLE_TRYNUM), trynum+1);
}
void Window::snapFailed(int modelIndex)
{
	failedNums++;
	uint trynum=model->data(model->index(modelIndex, LINK_TABLE_TRYNUM)).toUInt();
	model->setData(model->index(modelIndex, LINK_TABLE_TRYNUM), trynum+1);
	QDir dir(".");	
	if(!dir.exists("log")) 
			dir.mkdir("log");
	QString logfilename=QString("./log/log").append(currenttime).append(".txt");	
	 QFile debugfile(logfilename);
	 debugfile.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Append);
	 QTextStream debugos(&debugfile);
	 debugos.setCodec("UTF-8");
	 debugos << "[";
	 debugos << QDateTime::currentDateTime().toString("hh:mm:ss");
	 debugos << "] " << tableComboBox->currentText()<<":";
	 debugos <<  " id:"<<model->data(model->index(modelIndex, LINK_TABLE_ID)).toUInt()<<";";
	  debugos <<  " url:"<<model->data(model->index(modelIndex,LINK_TABLE_URL)).toString();
	 debugos << "\n";
	 debugfile.close();
	//dir.cdUp();
	//failedModel->insertRow(0);
	//failedModel->setData(failedModel->index(0, 0), model->data(model->index(modelIndex, 0)).toUInt());
	//failedModel->setData(failedModel->index(0, 1), model->data(model->index(modelIndex, 1)).toString());
	//failedModel->setData(failedModel->index(0, 2), model->data(model->index(modelIndex, 2)).toString());
}
void Window::snapDone()
{
	QString tipstr=QString("Porcess total %1 url.\n<span style=\"color:green\">Successful:%2</span><span style=\"color:red\">  Failed:%3</span>").arg(totalNums).arg(successfulNums).arg(failedNums);
	snapLog(tipstr);	
	autoclass();
	commitBtn->setEnabled(TRUE);
	if(gSettings->value("automode",FALSE).toBool()){
		//automode
		modelCommit(0);
	}
}
void Window::autoclass()
{
#if 0
	uint rows=model->rowCount();
	uint i=0;
	while(i<rows)
	{	
		QString tags=model->data(model->index(i, LINK_TABLE_TAG)).toString();
		//qDebug()<<tags;
		QStringList taglist = tags.split(" ", QString::SkipEmptyParts);
		QString class_string;
		foreach(QString tag,taglist){
			tag=tag.trimmed();
			// qDebug()<<tag;
			uint taghash=qhashEx(tag,tag.length());
			QSqlQuery	query(local_db);
			uint classid=0;

			QString queryStr=QString("SELECT classid FROM linkclasstag where hashname=%1 and tagname='%2' limit 1").arg(taghash).arg(tag);
			qDebug()<<queryStr;
			query.exec(queryStr);
			QSqlRecord rec = query.record();							   
			uint classid_id = rec.indexOf("classid"); 
			while(query.next()) {	
				classid=query.value(classid_id).toUInt();
				query.clear();
				break;	
			}
			if(classid){
				//qDebug()<<classid;
				if(class_string.contains(QString("%1").arg(classid),Qt::CaseInsensitive))
					continue;
				if(class_string.length())
					class_string.append(",");				
				class_string.append(QString("%1").arg(classid));				
			}				
		}
		model->setData(model->index(i, LINK_TABLE_CLASSID), class_string);
		i++;
	}
#endif
}
void Window::modelCommit(bool status)
{
	ftp = new QFtp(this);
	connect(ftp, SIGNAL(commandFinished(int, bool)),
		this, SLOT(ftpCommandFinished(int, bool)));
	connect(ftp, SIGNAL(dataTransferProgress(qint64, qint64)),
		this, SLOT(updateDataTransferProgress(qint64, qint64)));
	//ftp login
	QUrl url(gSettings->value("ftpcmd", "").toString());
	if (!url.isValid() || url.scheme().toLower() != QLatin1String("ftp")) {
		snapLog(tr("Logining to host:%1").arg(url.host()));
		ftp->connectToHost(gSettings->value("ftpcmd", "").toString(), 21);
		ftp->login();
	} else {
		qDebug()<<url.host();
		snapLog(tr("Logining to host:%1").arg(url.host()));
		ftp->connectToHost(url.host(), url.port(21));
		qDebug()<<url.userName()<<url.password()<<url.path();
		if (!url.userName().isEmpty())
			ftp->login(QUrl::fromPercentEncoding(url.userName().toLatin1()), url.password());
		else
			ftp->login();
		if (!url.path().isEmpty())
		{
			QString path=url.path().trimmed();
			if(path.startsWith("/"))
			{
				path.remove(0,1);
				ftp->cd(path);
			}
		}
	}
	fileflag=0;
	startFtp(FTP_MODE_MIDDLE);		
}
void Window::startFtp(int mode)
{
	ftpmode = mode;
	uint rows=model->rowCount();
	if(!rows)
		return;
	uint i=fileflag;	
	if(ftpfile){
			if(ftpfile->isOpen())
				ftpfile->close();
			delete ftpfile;
			ftpfile =NULL;
	}
	snapLog(tr("startFtp"));
	if(i >= (rows-1))
	{
		snapLog(tr("commit  to mysql server"));
		
		if(tableComboBox->currentIndex()==0){
			gSettings->setValue("linkid",model->data(model->index(rows-1, LINK_TABLE_ID)).toUInt());
		}else{
			gSettings->setValue("siteid",model->data(model->index(rows-1, LINK_TABLE_ID)).toUInt());
		}
		startIdLineEdit->setText(QString("%1").arg(model->data(model->index(rows-1, LINK_TABLE_ID)).toUInt()));
		gSettings->sync();
		model->submitAll();
		snapBtn->setEnabled(false);
		commitBtn->setEnabled(false);
		closeftp();	

		if(gSettings->value("automode",FALSE).toBool())
		{
			getUrlDataFromServer(0);
		}
		return;
	}
	
	uint picflag=model->data(model->index(i, LINK_TABLE_PICFLAG)).toUInt();
	if(picflag){
			QString filepath=model->data(model->index(i, LINK_TABLE_PIC)).toString();
			QString filename=model->data(model->index(i, LINK_TABLE_MD5URL)).toString();
			
			QString filetotalpathname;
			QString filetotalname;

			if(mode == FTP_MODE_MIDDLE){
				 filetotalpathname=QString("%1/%2.jpg").arg(filepath).arg(filename);
				 filetotalname=QString("%1.jpg").arg(filename);
			}else if(mode==FTP_MODE_BIG){
			 	filetotalpathname=QString("%1/b_%2.jpg").arg(filepath).arg(filename);
				 filetotalname=QString("b_%1.jpg").arg(filename);
			}
			
			QStringList dirlist=filepath.split("/");
			for (int j = 0; j < dirlist.size(); ++j){
				qDebug()<<dirlist.at(j);
				ftp->cd(dirlist.at(j));
			}
			
			
			ftpfile = new QFile(filetotalpathname);

			if (!ftpfile->open(QIODevice::ReadOnly)) {
				QMessageBox::information(this, tr("FTP"),
					tr("Unable to save the file %1: %2.")
					.arg(filetotalname).arg(ftpfile->errorString()));
				delete ftpfile;
				goto out;
			}

			snapLog(tr("Begin to put %1 to ftp server!").arg(ftpfile->fileName()));
			ftp->put(ftpfile,filetotalname);
//transfer big file			

out:
			for (int j = 0; j < dirlist.size(); ++j){
				ftp->cd("..");
			}
		}else{
			if(mode == FTP_MODE_MIDDLE){
				fileflag++;
				startFtp(mode);				
			}
	}	
}
void Window::updateDataTransferProgress(qint64 readBytes, qint64 totalBytes)
{
	// progressDialog->setMaximum(totalBytes);
	//  progressDialog->setValue(readBytes);

}
void Window::closeftp()
{
	if (ftp) {
		ftp->abort();
		ftp->deleteLater();
		ftp = 0;
	}
}
void Window::ftpCommandFinished(int commandId, bool error)
{
#ifndef QT_NO_CURSOR
	setCursor(Qt::ArrowCursor);
#endif
//	snapLog(tr("finsh %1/%2 ftp->currentCommand()=%3 QFtp::Put=%4") .arg(fileflag).arg(successfulNums).arg(ftp->currentCommand()).arg(QFtp::Put));
	if (ftp->currentCommand() == QFtp::ConnectToHost) {
		if (error) {
			QMessageBox::information(this, tr("FTP"),
				tr("Unable to connect to the FTP server "
				"at %1. Please check that the host "
				"name is correct.")
				.arg(gSettings->value("ftpcmd", "").toString()));
			closeftp();
			return;
		}
		// statusLabel->setText(tr("Logged onto %1.").arg(ftpServerLineEdit->text()));
		return;
	}

	if (ftp->currentCommand() == QFtp::Login)
	{
		if (error) 
			snapLog("Logined ftp server failed.");
		else
			snapLog("Logined ftp server.");

	}
	if (ftp->currentCommand() == QFtp::Put) {

		if (error) {
			snapLog(tr("Canceled upload  <strong> %1</strong>.") .arg(ftpfile->fileName()));
			model->setData(model->index(fileflag, LINK_TABLE_PICFLAG),0);
		} else {
			snapLog(tr("Successfully to  upload  <strong> %1</strong>.") .arg(ftpfile->fileName()));			
		}

		if(error||(ftpmode==FTP_MODE_BIG)){
			fileflag++;			
			startFtp(FTP_MODE_MIDDLE);
		}else
			startFtp(FTP_MODE_BIG);
	}
}
/*
uhome_link database;
*/

void Window::getTagDataFromServer(bool status)
{
	//getTagBtn->setEnabled(false);

	QSqlQuery tag_query;
	//handle the classtag
	QString tag_query_string= "SELECT * FROM uchome_linkclasstag";
	//get maxinum dateline
	QSqlQuery	query(local_db);
	uint tagid_where=0;
	query.exec("SELECT tagid FROM linkclasstag order by tagid DESC limit 1");
	QSqlRecord rec = query.record();

	int tagid_id = rec.indexOf("tagid"); 
	while(query.next()) {	
		tagid_where=query.value(tagid_id).toUInt();
		query.clear();
		break;	
	}				
	tag_query_string.append(QString(" where tagid>%1").arg(tagid_where));
	//qDebug()<<tag_query_string;
	if(tag_query.exec(tag_query_string))
	{
		QSqlRecord rec = tag_query.record();
		uint tagid_id = rec.indexOf("tagid"); 
		uint tagname_id = rec.indexOf("tagname"); 
		uint hashname_id = rec.indexOf("hashname"); 
		uint uid_id = rec.indexOf("uid"); 
		uint classid_id = rec.indexOf("classid"); 
		uint dateline_id = rec.indexOf("dateline");
		uint totalnum_id = rec.indexOf("totalnum");

		QSqlQuery	query(local_db);
		local_db.transaction();
		while(tag_query.next()) {	

			uint tagid=tag_query.value(tagid_id).toUInt();
			QString tagname=tag_query.value(tagname_id).toString();
			uint hashname=tag_query.value(tagname_id).toUInt();
			if(!hashname)
				hashname=qhashEx(tagname,tagname.length());
			uint uid=tag_query.value(uid_id).toUInt();
			uint classid=tag_query.value(classid_id).toUInt();
			uint dateline=tag_query.value(dateline_id).toUInt();
			uint totalnum=tag_query.value(totalnum_id).toUInt();

			QString	s=QString("INSERT INTO %1 (tagid, tagname, hashname,"
				"uid,classid,dateline,totalnum) "
				"VALUES (%2,'%3',%4,%5,%6,%7,%8)").arg(G_DB_TABLE_NAME).arg(tagid) .arg(tagname).arg(hashname)
				.arg(uid).arg(classid).arg(dateline)
				.arg(totalnum);

			//qDebug()<<s<<"\n";
			query.exec(s);

		}
		local_db.commit();
		query.clear();
	}

	//handle class
	tag_query_string= "SELECT * FROM uchome_linkclass";
	//get maxinum classid
	uint classid_where=0;
	query.exec(tr("SELECT classid FROM %1 order by classid DESC limit 1").arg(G_DB_LINKCLASSTAG_TABLE_NAME));
	rec = query.record();

	int classid_id = rec.indexOf("classid"); 
	while(query.next()) {	
		classid_where=query.value(classid_id).toUInt();
		query.clear();
		break;	
	}				
	tag_query_string.append(QString(" where classid>%1").arg(classid_where));
	if(tag_query.exec(tag_query_string))
	{
		QSqlRecord rec = tag_query.record();
		uint classid_id = rec.indexOf("classid"); 
		uint uid_id = rec.indexOf("uid"); 
		uint classname_id = rec.indexOf("classname"); 
		uint groupid_id = rec.indexOf("groupid"); 
		uint parentid_id = rec.indexOf("parentid"); 

		QSqlQuery	query(local_db);
		local_db.transaction();
		while(tag_query.next()) {
			uint classid=tag_query.value(classid_id).toUInt();
			uint uid=tag_query.value(uid_id).toUInt();
			QString classname=tag_query.value(classname_id).toString();
			uint groupid=tag_query.value(groupid_id).toUInt();
			uint parentid=tag_query.value(parentid_id).toUInt();

			QString	s=QString("INSERT INTO %1 (classid, uid, classname,"
				"groupid,parentid) "
				"VALUES (%2,%3,'%4',%5,%6)").arg(G_DB_LINKCLASSTAG_TABLE_NAME).arg(classid) .arg(uid).arg(classname)
				.arg(groupid).arg(parentid);
			query.exec(s);
		}
		local_db.commit();
		query.clear();
	}

	//getTagBtn->setEnabled(true);
}
void Window::getUrlDataFromServer(bool status)
{
	successfulNums=0;
	failedNums=0;
	totalNums=0;
	fileflag=0;
	if(model)
		delete model;
	model=new QSqlTableModel(this,server_db);
	model->setTable(QString("uchome_%1").arg(tableComboBox->currentText()));
	model->setEditStrategy(QSqlTableModel::OnManualSubmit);
	if(tableComboBox->currentText()=="link")
	{
		model->setFilter("siteid=0 and privateflag=0 and picflag = 0 and trynum<3 order by linkid limit 0,50");
	}else if(tableComboBox->currentText()=="site"){
	//	model->setFilter("picflag = 0 and trynum<3 order by id limit 0,20");
	//	model->setFilter("picflag = 0 and trynum<3 and class=653 order by id ");
	//	SELECT * FROM uchome_site WHERE picflag = 0 AND trynum<3 ORDER BY id LIMIT 10
		gSettings->sync();
		//qDebug()<<gSettings->value("sitefilter", "").toString();
		//model->setFilter(gSettings->value("sitefilter", "").toString());
		model->setFilter(QString("picflag = 0 AND trynum<3 AND id >%1 ORDER BY id LIMIT %2").arg(gSettings->value("siteid", 0).toUInt()).arg(gSettings->value("sitenum", 20).toUInt()));		
	}
	if(model->select()){

	if(tableComboBox->currentText()=="link")
	{
		//model->removeColumn(LINK_UPDATEFLAG);
		model->removeColumn(LINK_CLICK5);//groupid
		model->removeColumn(LINK_CLICK4);//groupid
		model->removeColumn(LINK_CLICK3);//groupid	
		model->removeColumn(LINK_CLICK2);//groupid
		model->removeColumn(LINK_AWARD);//groupid
		model->removeColumn(LINK_INITAWARD);//groupid
		model->removeColumn(LINK_DELFLAG);//groupid
		model->removeColumn(LINK_DOWN);//groupid
		model->removeColumn(LINK_UP);//groupid
		model->removeColumn(LINK_HASHURL);//groupid	
		model->removeColumn(LINK_VERIFY);//groupid	
		model->removeColumn(LINK_ORIGIN);//groupid
		model->removeColumn(LINK_PASSWORD);//groupid
		model->removeColumn(LINK_FRIEND);//parentid
		model->removeColumn(LINK_NOREPLAY);//logourl
		model->removeColumn(LINK_TMPPIC);//groupid
		model->removeColumn(LINK_DATELINE);//groupid
		model->removeColumn(LINK_HOT);//groupid
		model->removeColumn(LINK_STORENUM);//groupid
		model->removeColumn(LINK_REPLYNUM);//groupid
		model->removeColumn(LINK_VIEWNUM);//groupid
		model->removeColumn(LINK_CLASSID);//groupid		
		model->removeColumn(LINK_USERNAME);//groupid
		model->removeColumn(LINK_POSTUID);//groupid
		model->removeColumn(LINK_SITEID);//groupid
	}else if(tableComboBox->currentText()=="site"){
		//model->removeColumn(SITE_UPDATEFLAG);
		model->removeColumn(SITE_END);
		model->removeColumn(SITE_DELFLAG);
		model->removeColumn(SITE_INITAWARD);
		model->removeColumn(SITE_AWARD);
		//model->removeColumn(SITE_TRYNUM);
		//model->removeColumn(SITE_PRIVATEFLAG);
		model->removeColumn(SITE_DOWN);
		model->removeColumn(SITE_UP);
		model->removeColumn(SITE_HASHURL);
		//model->removeColumn(SITE_MD5URL);
		model->removeColumn(SITE_TMPIC);
		//model->removeColumn(SITE_PICFLAG);
		//model->removeColumn(SITE_PIC);
		model->removeColumn(SITE_DATELINE);
		model->removeColumn(SITE_TODAYSTORENUM);		
		model->removeColumn(SITE_STORENUM);
		model->removeColumn(SITE_TODAYVIEWNUM);	
		model->removeColumn(SITE_VIEWNUM);	
		//model->removeColumn(SITE_REMARK);
		model->removeColumn(SITE_ENDTIME);
		model->removeColumn(SITE_STARTTIME);
		model->removeColumn(SITE_BYESTREDAY);
		model->removeColumn(SITE_YESTERDAY);
		model->removeColumn(SITE_ADDUSER);
		model->removeColumn(SITE_NAMECOLOR);
		model->removeColumn(SITE_GOODDISPLAYORDER);
		model->removeColumn(SITE_TOTAL);
		model->removeColumn(SITE_MONTH);
		model->removeColumn(SITE_WEEK);
		model->removeColumn(SITE_DAY);
		model->removeColumn(SITE_GOOD2);
		model->removeColumn(SITE_GOOD);
		model->removeColumn(SITE_DISPLAYORDER);
		model->removeColumn(SITE_CLASS);
	//	model->removeColumn(SITE_TAG);
	//	model->removeColumn(SITE_URL);
	//	model->removeColumn(SITE_NAME);
	//	model->removeColumn(SITE_ID);
	}

		model->setHeaderData(LINK_TABLE_ID, Qt::Horizontal, "ID");
	//	model->setHeaderData(LINK_TABLE_CLASSID, Qt::Horizontal, "ClassID");
		model->setHeaderData(LINK_TABLE_NAME, Qt::Horizontal, "Name");
		model->setHeaderData(LINK_TABLE_URL, Qt::Horizontal, "Url"); 
		model->setHeaderData(LINK_TABLE_TAG, Qt::Horizontal, "Tag"); 
		model->setHeaderData(LINK_TABLE_DESCRIPTION, Qt::Horizontal, "description"); 
		model->setHeaderData(LINK_TABLE_PIC, Qt::Horizontal, "Pic"); 
		model->setHeaderData(LINK_TABLE_PICFLAG, Qt::Horizontal, "Picflag"); 
		model->setHeaderData(LINK_TABLE_MD5URL, Qt::Horizontal, "Md5url");
	//	model->setHeaderData(LINK_TABLE_PRIVATEFLAG, Qt::Horizontal, "Private");
		model->setHeaderData(LINK_TABLE_TRYNUM, Qt::Horizontal, "trynum");
		model->setHeaderData(LINK_UPDATEFLAG, Qt::Horizontal, "updateflag");
		sourceView->setModel(model);
		sourceView->show(); 
		connect(sourceView,SIGNAL(clicked(const QModelIndex&)),this,SLOT(activatedAction(const QModelIndex&)));
		connect(sourceView,SIGNAL(activated(const QModelIndex&)),this,SLOT(activatedAction(const QModelIndex&)));
		snapBtn->setEnabled(TRUE);
		if(gSettings->value("automode",FALSE).toBool()){
			//automode
			startUrlSnap(0);
		}
	}
}
void Window::activatedAction(const QModelIndex& index)
{
	nowRow=index.row();
	idLineEdit->setText(model->data(model->index(nowRow,LINK_TABLE_ID)).toString());
	//clear all check state

	QList<QAbstractButton *> btn_list=classbtns->buttons();
	for(int i=0;i<btn_list.size();i++)
	{
		btn_list[i]->setChecked(false);				
	}
	nameLineEdit->setText(model->data(model->index(nowRow,LINK_TABLE_NAME)).toString());
	urlLineEdit->setText(model->data(model->index(nowRow,LINK_TABLE_URL)).toString());
	tagLineEdit->setText(model->data(model->index(nowRow,LINK_TABLE_TAG)).toString());
	desTextEdit->setPlainText(model->data(model->index(nowRow,LINK_TABLE_DESCRIPTION)).toString());
	//load image
	QImage image;
	QString fileName=QString("%1/%2.jpg").arg(model->data(model->index(nowRow,LINK_TABLE_PIC)).toString()).arg(model->data(model->index(nowRow,LINK_TABLE_MD5URL)).toString());
	if (!image.load(fileName)) {
		imgLabel->setText(tr("The image file doesn't exist!"));
	}
	else
		imgLabel->setPixmap(QPixmap::fromImage(image));
	return;    
}
void Window::startUrlSnap(bool status)
{
	totalNums=model->rowCount();
	thread=new snapThread(model,ONCE_GET_URL,MAX_WAIT_SEC);
	if(tableComboBox->currentText()=="link"){
		thread->setMode(LINK_TABLE_MODE);
	}else if(tableComboBox->currentText()=="site"){
		thread->setMode(SITE_TABLE_MODE);
	}
	thread->start();	
	snapLog(QString("Start  snap..."));
	connect(thread,SIGNAL(snapSuccessfulNoitfy(int)),this,SLOT(snapSuccessful(int)));
	connect(thread,SIGNAL(snapFailedNoitfy(int)),this,SLOT(snapFailed(int)));
	connect(thread,SIGNAL(snapDoneNoitfy()),this,SLOT(snapDone()));
	connect(thread,SIGNAL(snapLogNotify(QString)),this,SLOT(snapLog(QString)));
}
void  Window::applyParameter(bool status)
{
		gSettings->setValue("trynum_s",trynumLineEdit_s->text().toUInt());
		gSettings->setValue("trynum_e",trynumLineEdit_e->text().toUInt());
		gSettings->setValue("getnum",getnumLineEdit->text().toUInt());
		gSettings->setValue("snapnum",snapnumLineEdit->text().toUInt());
	
		gSettings->setValue("automode",(automode->checkState()==Qt::Checked)?TRUE:FALSE);

		gSettings->setValue("table",tableComboBox->itemText(tableComboBox->currentIndex()));

		if(tableComboBox->currentIndex()==0){
			gSettings->setValue("linkid",startIdLineEdit->text().toUInt());
		}else{
			gSettings->setValue("siteid",startIdLineEdit->text().toUInt());
		}
		gSettings->sync();
	
}
void Window::snapLog(QString str)
{
	logedit->appendHtml(str);
}

void snapThread::monitorSnapFinished()
{
	int count=getringurlList.count();
	QDir dir(".");
	QString apath=dir.absolutePath();
	for(int i=count-1;i>=0;i--)
	{
		struct MonitorUrl mu=getringurlList.at(i);
		if(GetSpecifiedProcessById(mu.pi.dwProcessId)==0){			
				QString littleFilename=QString("%1/%2/%3.jpg").arg(apath).arg(mu.filepath).arg(mu.filename);
				QString bigFilename=QString("%1/%2/b_%3.jpg").arg(apath).arg(mu.filepath).arg(mu.filename);	
				if(QFile::exists(littleFilename)&&QFile::exists(bigFilename)&&QFile::exists(QString("content/").append(mu.filename).append(".jpg.txt")))
				{
					emit snapLogNotify(QString("<span style=\"color:green\">snap <strong>%1</strong> successfuly</span>").arg(mu.url));
					emit snapSuccessfulNoitfy(mu.index);
				}else{
						emit snapLogNotify(QString("<span style=\"color:red\">snap <strong>%1</strong> failed</span>").arg(mu.url));
						emit snapFailedNoitfy(mu.index);
				}
				
			CloseHandle( mu.pi.hProcess );
			CloseHandle( mu.pi.hThread );
			getringurlList.removeAt(i);
		}
		dir.cd(apath);
	}
}
void snapThread::run()
{
	int i=0;
	int rows=model->rowCount();
	QDir dir(".");
	QString apath=dir.absolutePath();
	QString ieCaptBin=QString(apath).append(IECAPT_PROGRAM);
	while(i<rows)
	{	
		if(getringurlList.count()<onceGet)
		{		
			struct MonitorUrl mu;		
			mu.index=i;
			mu.url=model->data(model->index(i, LINK_TABLE_URL)).toString();
			//fix the url
			mu.url.replace(QString("&amp;"), QString("&"),Qt::CaseInsensitive);
			//如果是site,且name空，则忽略
			QString urlname =model->data(model->index(i, LINK_TABLE_NAME)).toString(); 
			if((mode==SITE_TABLE_MODE)&&(urlname.isEmpty()||!urlname.compare("NULL",Qt::CaseInsensitive)))
			{
				emit snapLogNotify(QString("<span>empty name <strong>%1</strong> skip it!</span>").arg(mu.url));
				model->setData(model->index(i, LINK_TABLE_PRIVATEFLAG),1);
				goto NEXT;
			}
			//private url
			if(isPrivateIp(mu.url))
			{
				emit snapLogNotify(QString("<span>private net <strong>%1</strong> skip it!</span>").arg(mu.url));
				model->setData(model->index(i, LINK_TABLE_PRIVATEFLAG),1);
				goto NEXT;
			}
			
			
			
			mu.filepath=model->data(model->index(i, LINK_TABLE_PIC)).toString();
			mu.filename=model->data(model->index(i, LINK_TABLE_MD5URL)).toString();
			//QDateTime dt=QDateTime::currentDateTime ();
			//mu.startTime= dt.toTime_t();
			
			//create directory
		//	qDebug()<<"url="<<mu.url<<" filepath="<<mu.filepath<<" filename="<<mu.filename;
			dir.mkpath(mu.filepath);
			QString littleFilename=QString("%1/%2/%3.jpg").arg(apath).arg(mu.filepath).arg(mu.filename);
			QString bigFilename=QString("%1/%2/b_%3.jpg").arg(apath).arg(mu.filepath).arg(mu.filename);
			if(!QFile::exists(littleFilename)||!QFile::exists(bigFilename)||!QFile::exists(QString("content/").append(mu.filename).append(".jpg.txt")))
			{
	 			QHostInfo info = QHostInfo::fromName(QUrl(mu.url).host());				
			      if(info.error() != QHostInfo::NoError) {
				         qDebug() << "Lookup failed:" << info.errorString();
					 emit snapLogNotify(QString("<span style=\"color:red\">snap <strong>%1</strong> host not found</span>").arg(mu.url));
					 emit snapFailedNoitfy(mu.index);
			      }else{
				QString runargs=QString("--url=%1 --out=%2/%3.jpg --max-wait=%4").arg(mu.url).arg(mu.filepath).arg(mu.filename).arg(maxWait*1000);
				emit snapLogNotify(QString("<span>start to snap <strong>%1</strong></span>").arg(mu.url));
#ifdef WAIT_FOR_SINGLE
				qDebug()<<"args:"<<runargs;
				if(runProgram(ieCaptBin,runargs,&mu.si,&mu.pi))
						getringurlList.push_back(mu);
#else
				getringurlList.push_back(mu);
#endif
			      	}
			}else{
				//has snapshoted it
				emit snapLogNotify(QString("<span style=\"color:green\">snap <strong>%1</strong> successfuly</span>").arg(mu.url));
				emit snapSuccessfulNoitfy(mu.index);
			}
		}else
		{
			monitorSnapFinished();
			::Sleep(1*100);
			continue;
		}
NEXT:
		i++;
	}
	while(getringurlList.count()){
		monitorSnapFinished();
		::Sleep(1*100);
	}
	emit snapDoneNoitfy();
}
