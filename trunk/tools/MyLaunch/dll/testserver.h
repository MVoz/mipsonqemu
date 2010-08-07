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
#include <qDebug>

#if defined(TEST_SERVER_DLL)
#define TEST_SERVER_DLL_CLASS_EXPORT __declspec(dllexport)
#else
#define TEST_SERVER_DLL_CLASS_EXPORT __declspec(dllimport)
#endif
class TEST_SERVER_DLL_CLASS_EXPORT MyThread:public QThread
{
	Q_OBJECT;
public:
	MyThread(QObject * parent = 0);
	~MyThread();
public:
	int terminateFlag;
	QTimer* monitorTimer;
	virtual void setTerminateFlag(int f);
	public slots:
		virtual void monitorTimerSlot()	;
public:
	void run();
	virtual void terminateThread();
};
class  TEST_SERVER_DLL_CLASS_EXPORT testServerThread:public MyThread
{
	Q_OBJECT;
public:
	QNetworkAccessManager *manager;
	QNetworkReply *reply;
	QTimer* testNetTimer;
public:
	testServerThread(QObject * parent = 0);
	~testServerThread();
	void run();
	void clearObject();
	public slots: 
		void testServerFinished(QNetworkReply*);
		void testServerTimeout();
		void terminateThread();
		//void gorun();
};
/*
class  TEST_SERVER_DLL_CLASS_EXPORT testServerThread:public QThread
{
Q_OBJECT;
public:
QNetworkAccessManager *manager;
QNetworkReply *reply;
QTimer* testNetTimer;
public:
int terminateFlag;
QTimer* monitorTimer; 
void setTerminateFlag(int f)
{
terminateFlag=f;
}
public slots:
void monitorTimerSlot();
public:
testServerThread(QObject * parent = 0):QThread(parent)
{
manager = NULL;
reply = NULL;
terminateFlag = 0;
testNetTimer = NULL;
monitorTimer =NULL;
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
if(monitorTimer)
monitorTimer->deleteLater();		

}
void run();
public slots: 
void testNetFinished(QNetworkReply*);
void testNetTimeout();
void terminateThread();

};
*/
#endif