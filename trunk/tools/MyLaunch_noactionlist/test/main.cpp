#include <QApplication>
#include <QString>
#include <QDir>
#include <QFileInfo>
#include <QFileInfoList>
#include <QTextStream>
#include <windows.h>
#include <shlobj.h>
#include <QThread>
#include <QTimer>
#define BOOKMARK_CATAGORY_FLAG 1
#define BOOKMARK_ITEM_FLAG 2
#define MASK_TYPE 0x03
#include <QPair>
#include <QList>
#include <QUrl>
#include <qDebug>
#include <QTextCodec>
#include <QTime>
#include <QtCore/qobject.h>
#include <QEventLoop>
#include <QRegExp>
QString getDomain(const QString& fullpath)
{
	//IPV4
	QString ipv4="^((?:(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d))$";

	QRegExp  ipv4exp=QRegExp(ipv4,Qt::CaseInsensitive);
	
	if(ipv4exp.indexIn(fullpath)==0)
		return "";
	QStringList slist = fullpath.split(".");
	switch(slist.count()){
		case 0:
		return "";
		case 1:
		return fullpath;
		case 2:
		return slist.at(0);
		default:
		if(slist.at(0)=="www")
			return slist.at(1);
		else{
			QString ret;
			ret.append(slist.at(0));
			ret.append(" ");
			ret.append(slist.at(1));
			return ret;
		}
		
	}
}

int main(int argc, char *argv[])
{
		QTextCodec::setCodecForTr(QTextCodec::codecForName("UTF-8"));
	    QTextCodec::setCodecForCStrings(QTextCodec::codecForName("UTF-8"));
	//	QTextCodec::setCodecForLocale(QTextCodec::codecForName("GB18030"));
		QStringList args = qApp->arguments();
		QApplication *app=new QApplication(argc, argv);
	    app->setQuitOnLastWindowClosed(true);
		
		qDebug()<<argv[1];
		qDebug()<<getDomain(argv[1]);

	return 0;  	
}	
