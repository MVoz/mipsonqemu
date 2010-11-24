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
		QStringList namefiter;
		namefiter<<"*.gz";
		QFileInfoList fl=dir.entryInfoList(namefiter,QDir::AllDirs|QDir::Files|QDir::NoSymLinks|QDir::NoDotAndDotDot,QDir::Name);
		int i=0;
		for(i=0;i<fl.size();i++){
			QFileInfo fi=fl.at(i);
			qDebug("[dir=%d] path=%s name=%s",fi.isDir(),qPrintable(fi.filePath()),qPrintable(fi.fileName()));
			if(fi.isDir())
				{
					QString newdirName=QString("").append(QString(fi.filePath()).remove(0,QString(UPDATE_PORTABLE_DIRECTORY).count()));
					qDebug("newdirName=%s\n",qPrintable(newdirName));
					QDir newdir(".");
					if(!newdir.exists(newdirName))
							newdir.mkdir(newdirName);		
					updateAllFiles(fi.filePath(),QString("./").append(QString(fi.filePath()).remove(0,QString(UPDATE_PORTABLE_DIRECTORY).count())));
				}
			else
			{
				char rs[800]={0};
				//xxxx.dll.gz--->xxx.dll
				QString basename = fi.completeBaseName();
				lzmaFile(TOCHAR(fi.filePath()),TOCHAR(dstDir+"/"+basename),rs,0);
				//copyFile(fi.filePath(),dstDir);
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
				updateAllFiles(UPDATE_PORTABLE_DIRECTORY,"./");
				deleteDirectory(UPDATE_PORTABLE_DIRECTORY);
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
}
