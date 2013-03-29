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
#include "../lzma/LzmaLib.h"

#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <qDebug>

#include "../lzma/Alloc.h"
#include "../lzma/7zFile.h"
#include "../lzma/7zVersion.h"
#include "../lzma/LzmaDec.h"
#include "../lzma/LzmaEnc.h"

const char *kCantReadMessage = "Can not read input file";
const char *kCantWriteMessage = "Can not write output file";
const char *kCantAllocateMessage = "Can not allocate memory";
const char *kDataErrorMessage = "Data error";

static void *SzAlloc(void *p, size_t size) { p = p; return MyAlloc(size); }
static void SzFree(void *p, void *address) { p = p; MyFree(address); }
static ISzAlloc g_Alloc = { SzAlloc, SzFree };



#define IN_BUF_SIZE (1 << 16)
#define OUT_BUF_SIZE (1 << 16)

static SRes Decode2(CLzmaDec *state, ISeqOutStream *outStream, ISeqInStream *inStream,
    UInt64 unpackSize)
{
  int thereIsSize = (unpackSize != (UInt64)(Int64)-1);
  Byte inBuf[IN_BUF_SIZE];
  Byte outBuf[OUT_BUF_SIZE];
  size_t inPos = 0, inSize = 0, outPos = 0;
  LzmaDec_Init(state);
  for (;;)
  {
    if (inPos == inSize)
    {
      inSize = IN_BUF_SIZE;
      RINOK(inStream->Read(inStream, inBuf, &inSize));
      inPos = 0;
    }
    {
      SRes res;
      SizeT inProcessed = inSize - inPos;
      SizeT outProcessed = OUT_BUF_SIZE - outPos;
      ELzmaFinishMode finishMode = LZMA_FINISH_ANY;
      ELzmaStatus status;
      if (thereIsSize && outProcessed > unpackSize)
      {
        outProcessed = (SizeT)unpackSize;
        finishMode = LZMA_FINISH_END;
      }
      
      res = LzmaDec_DecodeToBuf(state, outBuf + outPos, &outProcessed,
        inBuf + inPos, &inProcessed, finishMode, &status);
      inPos += inProcessed;
      outPos += outProcessed;
      unpackSize -= outProcessed;
      
      if (outStream)
        if (outStream->Write(outStream, outBuf, outPos) != outPos)
          return SZ_ERROR_WRITE;
        
      outPos = 0;
      
      if (res != SZ_OK || thereIsSize && unpackSize == 0)
        return res;
      
      if (inProcessed == 0 && outProcessed == 0)
      {
        if (thereIsSize || status != LZMA_STATUS_FINISHED_WITH_MARK)
          return SZ_ERROR_DATA;
        return res;
      }
    }
  }
}

static SRes Decode(ISeqOutStream *outStream, ISeqInStream *inStream)
{
  UInt64 unpackSize;
  int i;
  SRes res = 0;

  CLzmaDec state;

  /* header: 5 bytes of LZMA properties and 8 bytes of uncompressed size */
  unsigned char header[LZMA_PROPS_SIZE + 8];

  /* Read and parse header */

  RINOK(SeqInStream_Read(inStream, header, sizeof(header)));

  unpackSize = 0;
  for (i = 0; i < 8; i++)
    unpackSize += (UInt64)header[LZMA_PROPS_SIZE + i] << (i * 8);

  LzmaDec_Construct(&state);
  RINOK(LzmaDec_Allocate(&state, header, LZMA_PROPS_SIZE, &g_Alloc));
  res = Decode2(&state, outStream, inStream, unpackSize);
  LzmaDec_Free(&state, &g_Alloc);
  return res;
}

static SRes Encode(ISeqOutStream *outStream, ISeqInStream *inStream, UInt64 fileSize, char *rs)
{
  CLzmaEncHandle enc;
  SRes res;
  CLzmaEncProps props;

  rs = rs;

  enc = LzmaEnc_Create(&g_Alloc);
  if (enc == 0)
    return SZ_ERROR_MEM;

  LzmaEncProps_Init(&props);
  res = LzmaEnc_SetProps(enc, &props);

  if (res == SZ_OK)
  {
    Byte header[LZMA_PROPS_SIZE + 8];
    size_t headerSize = LZMA_PROPS_SIZE;
    int i;

    res = LzmaEnc_WriteProperties(enc, header, &headerSize);
    for (i = 0; i < 8; i++)
      header[headerSize++] = (Byte)(fileSize >> (8 * i));
    if (outStream->Write(outStream, header, headerSize) != headerSize)
      res = SZ_ERROR_WRITE;
    else
    {
      if (res == SZ_OK)
        res = LzmaEnc_Encode(enc, outStream, inStream, NULL, &g_Alloc, &g_Alloc);
    }
  }
  LzmaEnc_Destroy(enc, &g_Alloc, &g_Alloc);
  return res;
}
/*
 mode : 1 -- encode 0--decode
*/
int lzmaFile(const char *infile,const char* outfile, char *rs,int mode)
{
  CFileSeqInStream inStream;
  CFileOutStream outStream;
  int res;
  int encodeMode;
  Bool useOutFile = False;

  FileSeqInStream_CreateVTable(&inStream);
  File_Construct(&inStream.file);

  FileOutStream_CreateVTable(&outStream);
  File_Construct(&outStream.file);


  encodeMode = mode;

  {
    size_t t4 = sizeof(UInt32);
    size_t t8 = sizeof(UInt64);
    if (t4 != 4 || t8 != 8)
	  {
		qDebug()<<"wrong size_t";
		return 0;
	  }
  }

  if (InFile_Open(&inStream.file, infile) != 0)
	{
		qDebug()<<"Can not open input file";
		return 0;
	}


   useOutFile = True;
   if (OutFile_Open(&outStream.file, outfile) != 0)
	{
	   qDebug()<<"Can not open output file";
	   return 0;
	}


  if (encodeMode)
  {
    UInt64 fileSize;
    File_GetLength(&inStream.file, &fileSize);
    res = Encode(&outStream.s, &inStream.s, fileSize, rs);
  }
  else
  {
    res = Decode(&outStream.s, useOutFile ? &inStream.s : NULL);
  }

  if (useOutFile)
    File_Close(&outStream.file);
  File_Close(&inStream.file);

  if (res != SZ_OK)
  {
    if (res == SZ_ERROR_MEM)
      qDebug()<<kCantAllocateMessage;
    else if (res == SZ_ERROR_DATA)
      qDebug()<<kDataErrorMessage;
    else if (res == SZ_ERROR_WRITE)
      qDebug()<<kCantWriteMessage;
    else if (res == SZ_ERROR_READ)
      qDebug()<<kCantReadMessage;
    qDebug()<<"error number:"<<res;
  }
  return 0;
}

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
			if(root&&(files[i]==APP_SILENT_UPDATE_NAME||files[i]==APP_FILEMD5_NAME||files[i]==UPDATE_FILE_NAME||files[i]==TEMP_UPDATE_FILE_NAME))
					continue;
			if((mode==FMD5_MODE_SETUP)&&(QString::compare(files[i],APP_SETUP_NAME,Qt::CaseInsensitive)))
					continue;
			if(mode==FMD5_MODE_PORTABLE)
			{
				s->setArrayIndex(filenums++);
			   	QString infile=root?(files[i]):(path+ "/"+files[i]);
				QString outfile=infile+".gz";
				char rs[800] = { 0 };
				lzmaFile(TOCHAR(infile),TOCHAR(outfile),rs,1);
				QString md5 = fileMd5(outfile);
				s->setValue("name",outfile);
				s->setValue("md5", md5);
				QFile::remove(infile);
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
