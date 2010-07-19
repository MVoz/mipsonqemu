#include <QApplication>
#include <QString>
#include <QDir>
#include <QFileInfo>
#include <QFileInfoList>
#include <QTextStream>
#include <windows.h>
#include <shlobj.h>
#include <QSettings>
#include <qDebug>
#include "../include/config.h"
void copyFile(const QString& filepath,const QString& dstDir)
{

		QString newfileName;
		QString srcfilename=filepath;
		newfileName.append(srcfilename.remove(0,QString(UPDATE_DIRECTORY_SUFFIX).count()));
		qDebug("Copy %s from %s dstDir=%s\n",qPrintable(newfileName),qPrintable(filepath),qPrintable(dstDir));
	
		QFile newf(newfileName);
		if(newf.exists())
			newf.remove();
		QFile f(filepath);
		f.copy(newfileName);	

}
void updateAllFiles(const QString& path,const QString& dstDir)
{
	QDir dir(".");
	if(!dir.exists(path))
			return;
		dir.cd(path);
		QFileInfoList fl=dir.entryInfoList(QDir::AllDirs|QDir::Files|QDir::NoSymLinks|QDir::NoDotAndDotDot,QDir::Name);
		int i=0;
		for(i=0;i<fl.size();i++){
			QFileInfo fi=fl.at(i);
			qDebug("[dir=%d] path=%s name=%s",fi.isDir(),qPrintable(fi.filePath()),qPrintable(fi.fileName()));
			if(fi.isDir())
				{
					QString newdirName=QString("").append(QString(fi.filePath()).remove(0,QString(UPDATE_DIRECTORY_SUFFIX).count()));
					qDebug("newdirName=%s\n",qPrintable(newdirName));
					QDir newdir(".");
					if(!newdir.exists(newdirName))
							newdir.mkdir(newdirName);		
					updateAllFiles(fi.filePath(),QString("./").append(QString(fi.filePath()).remove(0,QString(UPDATE_DIRECTORY_SUFFIX).count())));
				}
			else
			{
				copyFile(fi.filePath(),dstDir);
			}
		}

}

int deleteDirectory(QString path)
{
		path= QDir::toNativeSeparators(path);
		QDir dir(path);
		QString dirPath = dir.absolutePath();
		if(!dir.exists()) return 0;
		QStringList files = dir.entryList(QDir::Files);
		for(int i=0;i<files.size();i++)
			{
				dir.remove(dirPath+ "/"+files[i]);
			}
		QStringList dirs = dir.entryList(QDir::AllDirs | QDir::NoDotAndDotDot);
		for(int i=0;i<dirs.size();i++)
		{
			//	QDEBUG("delete directory %s ",qPrintable(dirs[i]));
				deleteDirectory(dirPath+ "/"+dirs[i]);
		}
		dir.rmdir(dirPath);
		return 1;

}
void runProgram(QString path, QString args) {
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
	if(!info.exists()) return;
	if (!info.isDir() && info.isFile())
		dir.cdUp();
	ShExecInfo.lpDirectory = (LPCTSTR)QDir::toNativeSeparators(dir.absolutePath()).utf16();
	ShExecInfo.nShow = SW_NORMAL;
	ShExecInfo.hInstApp = NULL;

	ShellExecuteEx(&ShExecInfo);	
}
int main(int argc, char *argv[])
{
		
		QApplication *app=new QApplication(argc, argv);
	    	app->setQuitOnLastWindowClosed(true);
		QStringList args = qApp->arguments();

		int retry=0;
		QSettings s(QString(APP_HKEY_PATH),QSettings::NativeFormat);	
		int updateFlag=s.value(APP_HEKY_UPDATE_ITEM,0).toInt();
		if(updateFlag!=1)
					goto out;
refind:
		if(retry>5) 
					goto out;
		HWND   hWnd   = ::FindWindow(NULL, (LPCWSTR) QString(APP_PROGRAM_NAME).utf16());
		if(!hWnd)
		 {
				updateAllFiles(UPDATE_DIRECTORY_SUFFIX,"./");
				deleteDirectory(UPDATE_DIRECTORY_SUFFIX);
				s.setValue(APP_HEKY_UPDATE_ITEM,0);
				s.sync();
				goto out;
		 }else{
				 ::Sleep(500);//500 Milliseconds 
				 retry++;
				 goto refind;
		 }					 
out:
		if (args.size() > 1&&args[1] == "-r")
		  {
			runProgram(QString(APP_PROGRAM_NAME),QString(""));
		  }
			
	//	app->exec();
}
