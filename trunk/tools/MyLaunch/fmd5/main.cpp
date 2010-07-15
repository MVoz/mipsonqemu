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

#define UPDATE_FILE_NAME "update.ini"
#define TEMP_UPDATE_FILE_NAME  "update.ini.tmp"
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
		  int count = s->beginReadArray("portable");
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
int dirMd5(QString path,int root,QSettings* s,QSettings* tmps)
{
	path= QDir::toNativeSeparators(path);
	QDir dir(path);
//	QString dirPath = dir.absolutePath();
	if(!dir.exists()) return 0;
	QStringList files = dir.entryList(QDir::Files);
	for(int i=0;i<files.size();i++)
		{
			if(root&&(files[i]=="fmd5.exe"||files[i]==UPDATE_FILE_NAME||files[i]==TEMP_UPDATE_FILE_NAME))
					continue;
			s->setArrayIndex(filenums++);
			QString md5 = fileMd5(path+ "/"+files[i]);
			s->setValue("name",root?(files[i]):(path+ "/"+files[i]));
			s->setValue("md5", md5);	
			s->setValue("version", getVersion(root?(files[i]):(path+ "/"+files[i]),tmps,md5));	
			
		}
	QStringList dirs = dir.entryList(QDir::AllDirs | QDir::NoDotAndDotDot);
	for(int i=0;i<dirs.size();i++)
	{
			dirMd5(root?(dirs[i]):(path+ "/"+dirs[i]),0,s,tmps);
	}
	return 1;	
}


int main(int argc, char* argv[])
{
	if(QFile::exists(UPDATE_FILE_NAME))
		QFile::copy(UPDATE_FILE_NAME,TEMP_UPDATE_FILE_NAME);

	QSettings s(UPDATE_FILE_NAME, QSettings::IniFormat, NULL);

	QSettings tmps(TEMP_UPDATE_FILE_NAME, QSettings::IniFormat, NULL);
	//if(argc!=2)
	//		goto usage;
	s.beginWriteArray("portable");

	dirMd5(".",1,&s,&tmps);

	s.endArray();
	
	if(QFile::exists(TEMP_UPDATE_FILE_NAME))
		QFile::remove(TEMP_UPDATE_FILE_NAME);
//	s.setValue("size", (filenums-1));
	return 0;
//usage:
//	fprintf(stdout,"Usage : bmexport.exe -t [ie|ff|op] -i  xxx -o  xxx.xml\n");
	return 0;
}
