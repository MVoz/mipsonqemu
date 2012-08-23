#include <qdir.h>
#include <qfile.h>
#include <qfileinfo.h>
#include <qstringlist.h>
#include <stdio.h>
#include <QDateTime>
#include <iostream>
#include <QTextStream>
#include <QSettings>
#include <qDebug>
#include "config.h"

//#define APP_VERSION "1.2.12"
//#define APP_BUILD_TIME 1000000
QString app_version;
QString app_build_time;
uint main_version;
uint child_version;
uint section_version;
#define APP_VERSION_KEY "#define APP_VERSION "
#define APP_BUILD_TIME_KEY "#define APP_BUILD_TIME "
void  process_line(QString& l){
     if(l.startsWith(APP_VERSION_KEY)){
		   app_version=l.right(l.length()-QString(APP_VERSION_KEY).length());
		   app_version.remove("\"");
		   sscanf(app_version.toUtf8(),"%u.%u.%u",&main_version,&child_version,&section_version);
		   if((section_version)>=18)
		   {
			   section_version=0;
			   child_version++;
		   }else
			section_version++;
		   if(child_version>8){
			   child_version=0;
			   main_version++;
		   }
		   app_version.sprintf(APP_VERSION_KEY"\"%u.%u.%u\"",main_version,child_version,section_version);
	 }else if(l.startsWith(APP_BUILD_TIME_KEY)){
		   app_build_time=l.right(l.length()-QString(APP_BUILD_TIME_KEY).length());
	 }

}
int main(int argc, char* argv[])
{
	
     QFile file(VERSION_FILE);
     if (!file.open(QIODevice::ReadWrite | QIODevice::Text))
         return 0;

     QTextStream in(&file);
     while (!in.atEnd()) {
         QString line = in.readLine();
         process_line(line);
     }
	 //rewrite version.h
	 file.close();
	 if (!file.open(QIODevice::Truncate|QIODevice::WriteOnly| QIODevice::Text))
         return 0;
	 in<<"#ifndef VERSION_H_"<<"\n";
	 in<<"#define VERSION_H_"<<"\n";
     in<<app_version<<"\n";
	 in<<APP_BUILD_TIME_KEY<<QDateTime::currentDateTime().toTime_t()<<"\n";
	 in<<"#endif"<<"\n";
	 file.close();
//write to /download/index.php
	 QFile filephp(SERVER_VERSION_FILE_PHP);
	 if (!filephp.open(QIODevice::Truncate|QIODevice::WriteOnly| QIODevice::Text))
         return 0;
	 QTextStream inphp(&filephp);
	 inphp<<main_version<<"."<<child_version<<"."<<section_version;
	 filephp.close();
	 return 0;
}
