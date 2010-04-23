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

#ifndef WINDOW_H
#define WINDOW_H

#include <QWidget>
#include <QtSql>
#include <QtNetwork>
#include <QtGui>
QT_BEGIN_NAMESPACE
class QAbstractItemModel;
class QCheckBox;
class QComboBox;
class QGroupBox;
class QLabel;
class QLineEdit;
class QSortFilterProxyModel;
class QTreeView;
class QPushButton ;
class QSqlQueryModel;
class QSqlTableModel;
class	QSqlDatabase;
class QStandardItemModel;
QT_END_NAMESPACE
;
enum link_db_struct{
	LINK_LINKID=0,
	LINK_POSTUID,
	LINK_USERNAME,
	LINK_CLASSID,
	LINK_SUBJECT,
	LINK_URL,
	LINK_TAG,
	LINK_DESCRIPTION,
	LINK_VIEWNUM,
	LINK_REPLYNUM,
	LINK_STORENUM,
	LINK_HOT,
	LINK_DATELINE,
	LINK_PIC,
	LINK_PICFLAG,
	LINK_TMPPIC,
	LINK_NOREPLAY,
	LINK_FRIEND,
	LINK_PASSWORD,
	LINK_ORIGIN,
	LINK_VERIFY,
	LINK_MD5URL,
	LINK_HASHURL,
	LINK_PRIVATEFLAG,
	LINK_TRYNUM,
	LINK_CLICK2,
	LINK_CLICK3,
	LINK_CLICK4,
	LINK_CLICK5
};
enum LINK_TABLE_TYPE{
	LINK_TABLE_ID=0,
	LINK_TABLE_CLASSID,
	LINK_TABLE_NAME,
	LINK_TABLE_URL,
	LINK_TABLE_TAG,
	LINK_TABLE_DESCRIPTION,
	LINK_TABLE_PIC,
	LINK_TABLE_PICFLAG,
	LINK_TABLE_MD5URL,
	LINK_TABLE_PRIVATEFLAG,
	LINK_TABLE_TRYNUM
};
struct class_map{
	 uint classid;
	 QString classname;
	 QMap <uint,QString> map;
};
struct MonitorUrl{
	QString url;
	uint index;
	QString filepath;
	QString filename;
	uint startTime;
};
#define ONCE_GET_URL 10
#define MAX_WAIT_SEC 120
class snapThread : public QThread
{
	Q_OBJECT;

public:
	//snapThread(QSqlQueryModel *m,int i,int t):model(m),onceGet(i),maxWait(t){
	//	}
	snapThread(QSqlTableModel *m,int i,int t):model(m),onceGet(i),maxWait(t){
		}
	~snapThread(){
		}
public:
	//QSqlQueryModel *model;
	QSqlTableModel *model;
	uint onceGet;
	uint maxWait;
	QList<struct MonitorUrl>getringurlList;
public:
	void run();
	void monitorSnapFinished();
signals:
		void snapSuccessfulNoitfy(int modelIndex);
		void snapFailedNoitfy(int modelIndex);
		void snapDoneNoitfy();
		void snapLogNotify(QString str);

};

extern QSqlDatabase local_db;
extern QSqlDatabase server_db;
extern QSettings *gSettings;
extern QPlainTextEdit *logedit;
void installEnvironment();
void uninstallEnvironment();
class Window : public QWidget
{
    Q_OBJECT;

public:
    Window();
	~ Window();
    void setSourceModel(QAbstractItemModel *model);

private slots:
//    void filterRegExpChanged();
//    void filterColumnChanged();
//    void sortChanged();
	  void autoclass();
	  void getUrlDataFromServer(bool status);
	  void getTagDataFromServer(bool status);
	  void itemPrevBtnClicked(bool status);
	  void itemNextBtnClicked(bool status);
	  void itemApplyBtnClicked(bool status);
	  void itemSnapBtnClicked(bool status);
	  void startUrlSnap(bool status);
	  void modelCommit(bool status);
	  void snapSuccessful(int modelIndex);
	  void snapFailed(int modelIndex);
	  void snapLog(QString str);
	  void snapDone();
      void ftpCommandFinished(int commandId, bool error);
      void updateDataTransferProgress(qint64 readBytes,qint64 totalBytes);
	  void closeftp();
	  void startFtp();
	  void classbuttonClicked(int id);
	  void tagbuttonClicked(int id);
	  void activatedAction(const QModelIndex& );
public:


private:
 //   QSortFilterProxyModel *proxyModel;

    QGroupBox *sourceGroupBox;
    QGroupBox *midGroupBox;
	QGroupBox *logGroupBox;
	QGroupBox *itemGroupBox;
	QGroupBox *classnameGroupBox;
	QButtonGroup *classbtns;
	QGroupBox *tagnameGroupBox;
	QButtonGroup *tagbtns;
    QTreeView *sourceView;
//	QPlainTextEdit *logedit;
//	QSqlQueryModel *model;
	QSqlTableModel *model;;
	QSqlDatabase db;
	QFtp* ftp;
	QFile* ftpfile;


	QStandardItemModel *failedModel;
    QTreeView *proxyView;
//    QCheckBox *filterCaseSensitivityCheckBox;
//    QCheckBox *sortCaseSensitivityCheckBox;
        QLabel *filterPatternLabel;
	QLabel *idLabel;
	QLabel *classidLabel;
	QLabel *nameLabel;
	QLabel *urlLabel;
	QLabel *tagLabel;
	QLabel *desLabel;

	QGroupBox *imgGroupBox;
	QLabel *imgLabel;

	QLineEdit* idLineEdit;
	QLineEdit* classidLineEdit;
	QLineEdit* nameLineEdit;
	QLineEdit* urlLineEdit;
	QLineEdit* tagLineEdit;
	QTextEdit* desTextEdit;

	QPushButton *itemApplyBtn;
	QPushButton *itemNextBtn;
	QPushButton *itemPrevBtn;
	QPushButton *itemSnapBtn;
	QDialogButtonBox* itemButtonBox;


	QPushButton *getTagBtn;
	QPushButton *getDataBtn;
	QPushButton *snapBtn;
	QPushButton *commitBtn;
	QDialogButtonBox* buttonBox;
	QPushButton *quitButton;
//    QLabel *filterSyntaxLabel;
//    QLabel *filterColumnLabel;
       QLineEdit *filterPatternLineEdit;
	 snapThread* thread;
	 uint successfulNums;
	 uint failedNums;
	 uint totalNums;
	 uint fileflag;
	 uint nowRow;
	 QTabWidget *tagtab;
	 QList<QTabWidget*> classtablist;

};


#define G_SETTING_NAME  "url2img.ini"
#define G_DB_NAME       "url2img.sqlite"
#define G_DB_TABLE_NAME "linkclasstag"
#define G_DB_LINKCLASSTAG_TABLE_NAME "linkclass"
#endif
