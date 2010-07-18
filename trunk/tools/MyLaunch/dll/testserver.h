#ifndef TEST_SERVER_H
#define TEST_SERVER_H

#include <QThread>
#include <QtNetwork/QHttp>
#include <QBuffer>
#include <QString>
#include <QEventLoop>

#include <boost/shared_ptr.hpp>


#include <QtNetwork/QHttpResponseHeader>
#include <QTimer>
#include <QFile>
#include <QtNetwork/QHttp>
#include <QSettings>
#include <QTimerEvent>
#include <config.h>
#include <QtCore/qobject.h>
//#include <QSemaphore>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkAccessManager>


#if defined(TEST_SERVER_DLL)
#define TEST_SERVER_DLL_CLASS_EXPORT __declspec(dllexport)
#else
#define TEST_SERVER_DLL_CLASS_EXPORT __declspec(dllimport)
#endif

class  TEST_SERVER_DLL_CLASS_EXPORT testServerThread:public QThread
{
	Q_OBJECT;
public:
	QNetworkAccessManager *manager;
	QNetworkReply *reply;
	QTimer* testNetTimer;
public:
	 testServerThread(QObject * parent = 0):QThread(parent)
	 {
	 	manager = NULL;
		reply = NULL;
	 	testNetTimer = NULL;
	 }
	 ~testServerThread()
	 {
	 	qDebug("~testServerThread");
	
	 	if(manager)
			manager->deleteLater();
		if(reply)
			reply->deleteLater();
	 	if(testNetTimer)
			testNetTimer->deleteLater();		
	
	 }
	 void run();
public slots: 
	void testNetFinished(QNetworkReply*);
	void testNetTimeout();
	
};
#endif