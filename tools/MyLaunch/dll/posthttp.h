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

#ifndef POST_HTTP_H
#define POST_HTTP_H

#include <QObject>
#include <xmlreader.h>
#include <QString>
#include <QThread>
#include <QtNetwork/QHttp>
#include <QBuffer>
#include <QString>
#include <QEventLoop>
#include <log.h>
#include <boost/shared_ptr.hpp>

#include <QtNetwork/QHttpResponseHeader>
#include <QtNetwork/QNetworkProxy>

#include <QTimer>
#include <QFile>
#include <config.h>
#include <QSettings>
#include <QTimerEvent>
#include <windows.h>
#include <bmapi.h>
#include <QtCore/qobject.h>
#include "testserver.h"
using namespace boost;
#if defined(POST_HTTP_DLL)
#define POST_HTTP_CLASS_EXPORT __declspec(dllexport)
#else
#define POST_HTTP_CLASS_EXPORT __declspec(dllimport)
#endif

#define POST_HTTP_ACTION_DELETE_URL 0
#define POST_HTTP_ACTION_DELETE_DIR  1

#define POST_HTTP_ACTION_ADD_URL 2
#define POST_HTTP_ACTION_ADD_DIR 3


class  POST_HTTP_CLASS_EXPORT postHttp:public MyThread
{
	Q_OBJECT
      public:
	//explicit postHttp(QObject *parent = 0){}
	 postHttp(QObject * parent = 0,int type=0);
	 ~postHttp();
       public:
	 void run();
	// void setProxy(QNetworkProxy& p);
      public:
	QHttp * posthttp;
	QString postString;
	uint quitFlag;
	QBuffer *resultBuffer;
	int postType;
	uint parentid;
	uint browserid;
	QString username;
	QString password;
	QTimer* postTimer;
	uint bmid;
	uint action;
	//uint proxyEnable;
	//QNetworkProxy proxy;
#if 0
public:
			int terminateFlag;
			QTimer* monitorTimer;
			void setTerminateFlag(int f)
			{
					terminateFlag=f;
			}
public slots:
			void monitorTimerSlot();
#endif
public slots: 
		//void httpRequestFinished(int id, bool error);
		void httpDone(bool error);
		//void httpStateChanged(int state);
		void postTimerSlot();
		void terminateThread();
};

#endif
