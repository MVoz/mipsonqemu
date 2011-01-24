/****************************************************************************
**
** This file is part of a Qt Solutions component.
** 
** Copyright (c) 2009 Nokia Corporation and/or its subsidiary(-ies).
** 
** Contact:  Qt Software Information (qt-info@nokia.com)
** 
** Commercial Usage  
** Licensees holding valid Qt Commercial licenses may use this file in
** accordance with the Qt Solutions Commercial License Agreement provided
** with the Software or, alternatively, in accordance with the terms
** contained in a written agreement between you and Nokia.
** 
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
** 
** In addition, as a special exception, Nokia gives you certain
** additional rights. These rights are described in the Nokia Qt LGPL
** Exception version 1.0, included in the file LGPL_EXCEPTION.txt in this
** package.
** 
** GNU General Public License Usage 
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
** 
** Please note Third Party Software included with Qt Solutions may impose
** additional restrictions and it is the user's responsibility to ensure
** that they have met the licensing requirements of the GPL, LGPL, or Qt
** Solutions Commercial license and the relevant license of the Third
** Party Software they are using.
** 
** If you are unsure which license is appropriate for your use, please
** contact the sales department at qt-sales@nokia.com.
** 
****************************************************************************/

#include <QtCore/QCoreApplication>
#include <QtNetwork/QTcpServer>
#include <QtNetwork/QTcpSocket>
#include <QtCore/QTextStream>
#include <QtCore/QDateTime>
#include <QtCore/QStringList>
#include <QtCore/QDir>
#include <QtCore/QSettings>

#include "qtservice.h"
#include <windows.h>
#include <shlobj.h>
#include <tchar.h>
#include <commctrl.h>
#include <Shellapi.h>
#include <stdio.h>
#include <Tlhelp32.h>
#include <QTimer>


#define IE_PROGRAM_NAME "IEXPLORE.EXE"

BOOL KillProcess(DWORD ProcessId)
{
    HANDLE hProcess=OpenProcess(PROCESS_TERMINATE,FALSE,ProcessId);
    if(hProcess==NULL)
        return FALSE;
    if(!TerminateProcess(hProcess,0))
        return FALSE;
    return TRUE;
}

DWORD scanProcess()
{
	HANDLE hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0) ;
	PROCESSENTRY32 pInfo; 
	pInfo.dwSize = sizeof(pInfo);
	Process32First(hSnapShot, &pInfo) ; 
	do
	{
		if((lstrcmp(_wcslwr(_wcsdup(pInfo.szExeFile)), QString(IE_PROGRAM_NAME).utf16()) == 0))
		{
			KillProcess(pInfo.th32ProcessID);
		}
	}while(Process32Next(hSnapShot, &pInfo) != FALSE);
	CloseHandle( hSnapShot );
	return 0;
} 

// HttpDaemon is the the class that implements the simple HTTP server.
class Url2imageDaemon : public QTcpServer
{
    Q_OBJECT
public:
    Url2imageDaemon(QObject* parent = 0)
        : QTcpServer(parent)
    {
    }
    void start()
    {
		timer = new QTimer(NULL);
		connect(timer, SIGNAL(timeout()), this, SLOT(scanProcessdaemon()));
		timer->start(120*1000);//2 minutes
    }

    void pause()
    {
       if(timer){
		  if(timer->isActive())
			  timer->stop();
		}
    }

    void resume()
    {
       if(timer){
		  if(!timer->isActive())
			  timer->start();
		}
    }
	void stop()
    {
       if(timer){
		  if(!timer->isActive())
			  timer->stop();
		  delete timer;
		}
    }

private slots:
    void scanProcessdaemon()
    {
		scanProcess();		        
    }
 private:
	QTimer *timer;
};

class Url2imageService : public QtService<QCoreApplication>
{
public:
    Url2imageService(int argc, char **argv)
	: QtService<QCoreApplication>(argc, argv, "url2image Daemon")
    {
        setServiceDescription("url2image Daemon service implemented with Qt");
        setServiceFlags(QtServiceBase::CanBeSuspended);
    }

protected:
    void start()
    {
        QCoreApplication *app = application();

        daemon = new Url2imageDaemon(app);
		daemon->start();
    }

    void pause()
    {
	daemon->pause();
    }

    void resume()
    {
	daemon->resume();
    }

private:
    Url2imageDaemon *daemon;
};

#include "main.moc"

int main(int argc, char **argv)
{
#if !defined(Q_WS_WIN)
    // QtService stores service settings in SystemScope, which normally require root privileges.
    // To allow testing this example as non-root, we change the directory of the SystemScope settings file.
    QSettings::setPath(QSettings::NativeFormat, QSettings::SystemScope, QDir::tempPath());
    qWarning("(Example uses dummy settings file: %s/QtSoftware.conf)", QDir::tempPath().toLatin1().constData());
#endif
    Url2imageService service(argc, argv);
    return service.exec();
}
