#include <qdir.h>
#include <qfile.h>
#include <qfileinfo.h>
#include <qstringlist.h>
#include <stdio.h>
#include <QTime>
#include <iostream>
#include <QCryptographicHash>
#include <QDataStream>
#include <QSettings>
#include "../include/config.h"


#define TEMP_UPDATE_FILE_NAME  UPDATE_FILE_NAME".tmp"

#define FMD5_MODE_PORTABLE 0
#define FMD5_MODE_SETUP 1

static int filenums=0;
QString fileMd5(QString filename)
{
	QByteArray  md5res;
	QCryptographicHash md(QCryptographicHash::Md5);
	if(!QFile::exists(filename))
		{
			//fprintf(stdout,"file %s doesn't existed!\n",qPrintable(filename));
			return "";
		}
	QFile infile(filename);
	if (infile.open(QIODevice::ReadOnly)) {
		QDataStream ins(&infile);
		while(!ins.atEnd())
		{
			char tmp[1024]={0};
			int reads=0;
			if((reads=ins.readRawData(tmp,sizeof(tmp)))!=-1)
			{
				md.addData(tmp,reads);
			}else
			{
				//fprintf(stdout,"read file %s error!\n",qPrintable(filename));
				goto end;		
			}
		}
	  md5res = md.result();
	  fprintf(stdout,"file %s's MD5 is %s!\n",qPrintable(filename),qPrintable(QString(md5res.toHex())));
	}
end:
	if(infile.isOpen())
			infile.close();
	return QString(md5res.toHex());
}

uint getVersion(QString name,QSettings* s,QString md5)
{
		  int count = s->beginReadArray(UPDATE_PORTABLE_KEYWORD);
		  uint ret = 0;
		  for (int i = 0; i < count; i++)
			{
					s->setArrayIndex(i);
					QString filename=s->value("name").toString();
					//fprintf(stdout,"name=%s md5=%s smd5=%s",qPrintable(name),qPrintable(md5), qPrintable(s->value("md5").toString()));
					if(name == filename)
					{
						
						if( md5 == s->value("md5").toString())
								ret=s->value("version","0").toUInt(); 
						else
								ret=(s->value("version","0").toUInt()+1); 
						break;
					}
					
			}
		  s->endArray();
	return ret;
}
int dirMd5(QString path,int root,int mode,QSettings* s,QSettings* tmps)
{
//	path= QDir::toNativeSeparators(path);
	QDir dir(path);
//	QString dirPath = dir.absolutePath();
	if(!dir.exists()) return 0;
	QStringList files = dir.entryList(QDir::Files);
	for(int i=0;i<files.size();i++)
		{
			if(root&&(files[i]==APP_FILEMD5_NAME||files[i]==UPDATE_FILE_NAME||files[i]==TEMP_UPDATE_FILE_NAME))
					continue;
			if((mode==FMD5_MODE_SETUP)&&(files[i]!=APP_SETUP_NAME))
					continue;
			if(mode==FMD5_MODE_PORTABLE)
			{
				s->setArrayIndex(filenums++);
				QString md5 = fileMd5(path+ "/"+files[i]);
				s->setValue("name",root?(files[i]):(path+ "/"+files[i]));
				s->setValue("md5", md5);	
			//	s->setValue("version", getVersion(root?(files[i]):(path+ "/"+files[i]),tmps,md5));	
			}else if(mode==FMD5_MODE_SETUP){
				QString md5 = fileMd5(path+ "/"+files[i]);
				s->setValue("setup/name",root?(files[i]):(path+ "/"+files[i]));
				s->setValue("setup/md5", md5);	
			//	s->setValue("setup/version", getVersion(root?(files[i]):(path+ "/"+files[i]),tmps,md5));	
			}
			
		}
	if(mode==FMD5_MODE_PORTABLE){
		QStringList dirs = dir.entryList(QDir::AllDirs | QDir::NoDotAndDotDot);
		for(int i=0;i<dirs.size();i++)
		{		
				fprintf(stdout,"file path=%s dirs[i]=%s\n",qPrintable(path),qPrintable(dirs[i]));
				dirMd5(root?(dirs[i]):(path+ "/"+dirs[i]),0,mode,s,tmps);
		}
	}
	return 1;	
}


int main(int argc, char* argv[])
{
	
	if (argc > 1) {
		if(!strcmp(argv[1],"-p")){
			   if(QFile::exists(UPDATE_FILE_NAME))
				QFile::copy(UPDATE_FILE_NAME,TEMP_UPDATE_FILE_NAME);

				QSettings s(UPDATE_FILE_NAME, QSettings::IniFormat, NULL);

				QSettings tmps(TEMP_UPDATE_FILE_NAME, QSettings::IniFormat, NULL);
				s.beginWriteArray(UPDATE_PORTABLE_KEYWORD);

				dirMd5(".",1,FMD5_MODE_PORTABLE,&s,&tmps);

				s.endArray();
				
				if(QFile::exists(TEMP_UPDATE_FILE_NAME))
					QFile::remove(TEMP_UPDATE_FILE_NAME);
		}else if(!strcmp(argv[1],"-s")) {
				if(QFile::exists(UPDATE_FILE_NAME))
					QFile::copy(UPDATE_FILE_NAME,TEMP_UPDATE_FILE_NAME);

				QSettings s(UPDATE_FILE_NAME, QSettings::IniFormat, NULL);

				QSettings tmps(TEMP_UPDATE_FILE_NAME, QSettings::IniFormat, NULL);
			//	s.beginWriteArray(UPDATE_PORTABLE_KEYWORD);

				dirMd5(".",1,FMD5_MODE_SETUP,&s,&tmps);

			//	s.endArray();
				
				if(QFile::exists(TEMP_UPDATE_FILE_NAME))
					QFile::remove(TEMP_UPDATE_FILE_NAME);
		}
		return 0;
	}
//	s.setValue("size", (filenums-1));
	return 0;
//usage:
//	fprintf(stdout,"Usage : bmexport.exe -t [ie|ff|op] -i  xxx -o  xxx.xml\n");
	return 0;
}
