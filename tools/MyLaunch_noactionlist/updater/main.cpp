#include <synchronizeDlg>
#include <QSettings>
#include "updaterThread.h"



int main(int argc, char *argv[])
{
		QHttp *http;
		QStringList args = qApp->arguments();
		QApplication *app=new QApplication(argc, argv);
	        app->setQuitOnLastWindowClosed(true);
		
		synchronizeDlg *syncDlg=new synchronizeDlg(NULL);
		updaterThread* updaterthread=new updaterThread(syncDlg);		

	//	qDebug("gSettings=0x%08x.....\n",gSettings);
	//	updaterthread->setHost(UPDATE_SERVER_HOST);
		//updaterthread->setUrl(UPDATE_SERVER_URL);
		updaterthread->start(QThread::IdlePriority);
		//connect(updatethread,);
		syncDlg->setModal(1);
		syncDlg->show();
		app->exec();
}
