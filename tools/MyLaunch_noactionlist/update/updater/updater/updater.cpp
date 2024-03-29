// updater.cpp : 定义应用程序的入口点。
//

#include "stdafx.h"
#include "updater.h"
#include <commctrl.h>
#include <Shellapi.h>
#include <stdio.h>
#include <Tlhelp32.h>

#include "../../../lzma/Alloc.h"
#include "../../../lzma/7zFile.h"
#include "../../../lzma/7zVersion.h"
#include "../../../lzma/LzmaDec.h"
#include "../../../lzma/LzmaEnc.h"

const char *kCantReadMessage = "Can not read input file";
const char *kCantWriteMessage = "Can not write output file";
const char *kCantAllocateMessage = "Can not allocate memory";
const char *kDataErrorMessage = "Data error";

#define APP_HKEY_PATH "Software\\zhiqiu\\launchy"
#define APP_HEKY_UPDATE_ITEM "updaterflag"
#define TEMP_PORTABLE_PATH ".\\temp\\portable\\"

static void *SzAlloc(void *p, size_t size) { p = p; return MyAlloc(size); }
static void SzFree(void *p, void *address) { p = p; MyFree(address); }
static ISzAlloc g_Alloc = { SzAlloc, SzFree };
int char2TCHAR(char* src,TCHAR* dst);

#define PROCESS_FILE_SIZE 0
#define PROCESS_FILE_DECODE 1

#define IN_BUF_SIZE (1 << 16)
#define OUT_BUF_SIZE (1 << 16)
#pragma comment(lib, "comctl32.lib")

#define MAX_LOADSTRING 100

#define WM_UPDATE_START WM_USER+100

HWND hMainWnd;//main handle
HWND hwndPB;    // Handle of progress bar 
DWORD totalfilesize = 0;

int totalFileSize(TCHAR* pFilePath,int,DWORD* size);
void StartUpdate(HWND hwndPb,TCHAR* pFilePath);
BOOL DoEvent();

// 全局变量:
HINSTANCE hInst;								// 当前实例
TCHAR szTitle[MAX_LOADSTRING];					// 标题栏文本
TCHAR szWindowClass[MAX_LOADSTRING];			// 主窗口类名

INT_PTR CALLBACK	DlgProc(HWND, UINT, WPARAM, LPARAM);
DWORD GetSpecifiedProcessId(TCHAR *pszProcessName)
{
	DWORD id=0;
	HANDLE hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0) ;
	PROCESSENTRY32 pInfo; 
	pInfo.dwSize = sizeof(pInfo);
	Process32First(hSnapShot, &pInfo) ; 
	do
	{
		if(lstrcmp(_wcslwr(_wcsdup(pInfo.szExeFile)), pszProcessName) == 0)
		{
			id = pInfo.th32ProcessID ;
			break ;
		}
	}while(Process32Next(hSnapShot, &pInfo) != FALSE);
	return id;
} 
void DeleteDir(LPCTSTR lpszDir)
{
	WIN32_FIND_DATA wfd;
	TCHAR szFile[MAX_PATH];
	TCHAR szDelDir[MAX_PATH];

	lstrcpy(szDelDir, lpszDir);
	wsprintf(szFile, TEXT("%s\\*.*"), lpszDir);
	HANDLE hFindFile = FindFirstFile(szFile, &wfd);
	if ( INVALID_HANDLE_VALUE == hFindFile )
		return;
	BOOL bFind = TRUE;
	while ( bFind )
	{
		bFind = FindNextFile(hFindFile, &wfd);
		if ( lstrcmpi(wfd.cFileName, TEXT(".")) == 0 ||
			lstrcmpi(wfd.cFileName, TEXT("..")) == 0 )
			continue;
		wsprintf(szFile, TEXT("%s\\%s"), szDelDir, wfd.cFileName);
		if ( wfd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY )
			DeleteDir(szFile);
		else
			DeleteFile(szFile);
	}
	FindClose(hFindFile);
	RemoveDirectory(szDelDir);
}
INT WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
				   LPSTR lpCmdLine, int nCmdShow)
{
	hInst = hInstance;
	InitCommonControls();
	LoadString(hInstance, IDS_APP_TITLE, szTitle, MAX_LOADSTRING);
	LoadString(hInstance, IDC_UPDATER, szWindowClass, MAX_LOADSTRING);
	int retrynum = 0;
retry:
	if(GetSpecifiedProcessId(TEXT("touchany.exe"))){
		Sleep(100);
		if(retrynum++>10)
			return FALSE;
		goto retry;
	}
	if(strcmp(lpCmdLine,"c0190ce05af9ce7cd818f50d794b8d11"))
		return FALSE;
	hMainWnd=CreateDialog(hInst, MAKEINTRESOURCE(IDD_ABOUTBOX), NULL, (DLGPROC)DlgProc); 
	ShowWindow(hMainWnd, SW_SHOW); 
	int bRet = 0;
	MSG msg;
	while ((bRet = GetMessage(&msg, NULL, 0, 0)) != 0) 
	{ 
		if (bRet == -1)
		{
			// Handle the error and possibly exit
		}
		else if (!IsWindow(hMainWnd) || !IsDialogMessage(hMainWnd, &msg)) 
		{ 
			TranslateMessage(&msg); 
			DispatchMessage(&msg); 
		} 
	} 

	return FALSE;
}

void runProgram(TCHAR* path, TCHAR* args) {
	SHELLEXECUTEINFO ShExecInfo;
	ShExecInfo.cbSize = sizeof(SHELLEXECUTEINFO);
	ShExecInfo.fMask = SEE_MASK_FLAG_NO_UI;
	ShExecInfo.hwnd = NULL;
	ShExecInfo.lpVerb = NULL;
	ShExecInfo.lpFile = (LPCTSTR) path;
	if (args != TEXT("")) {
		ShExecInfo.lpParameters = (LPCTSTR) args;
	} else {
		ShExecInfo.lpParameters = NULL;
	}
	ShExecInfo.lpDirectory = NULL;
	ShExecInfo.nShow = SW_NORMAL;
	ShExecInfo.hInstApp = NULL;
	ShellExecuteEx(&ShExecInfo);	
}
DWORD queryUpdateFlag()
{
	HKEY hKey;
	if(RegOpenKeyEx(HKEY_LOCAL_MACHINE, TEXT(APP_HKEY_PATH), 0,  KEY_ALL_ACCESS,&hKey)==ERROR_SUCCESS)
	{
		DWORD updaterflag=0;
		DWORD dwBufLen=sizeof(DWORD);
		DWORD a=REG_DWORD;
		RegQueryValueEx(hKey, TEXT(APP_HEKY_UPDATE_ITEM), NULL,&a, (LPBYTE)&updaterflag, &dwBufLen);
		if(a==REG_DWORD)
		{
				RegCloseKey(hKey);
				return updaterflag;
		}
		RegCloseKey(hKey);
	}
	return 0;
}
DWORD setUpdateFlag(DWORD v)
{
	HKEY hKey;
	if( RegOpenKeyEx(HKEY_LOCAL_MACHINE, TEXT(APP_HKEY_PATH), 0,  KEY_ALL_ACCESS,&hKey)==ERROR_SUCCESS)
	{
		RegSetValueEx(hKey,TEXT(APP_HEKY_UPDATE_ITEM),0,REG_DWORD,(LPBYTE)&v,4);  
		RegCloseKey(hKey);
	}
	return 0;
}
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
			//	qDebug()<<"wrong size_t";
			return 0;
		}
	}

	if (InFile_Open(&inStream.file, infile) != 0)
	{
		//	qDebug()<<"Can not open input file";
		return 0;
	}

	useOutFile = True;
	if (OutFile_Open(&outStream.file, outfile) != 0)
	{
		//   qDebug()<<"Can not open output file";
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
		/*
		if (res == SZ_ERROR_MEM)
		qDebug()<<kCantAllocateMessage;
		else if (res == SZ_ERROR_DATA)
		qDebug()<<kDataErrorMessage;
		else if (res == SZ_ERROR_WRITE)
		qDebug()<<kCantWriteMessage;
		else if (res == SZ_ERROR_READ)
		qDebug()<<kCantReadMessage;
		qDebug()<<"error number:"<<res;
		*/
	}
	return 0;
}

int TCHAR2char(TCHAR* src,char* dst)
{
	int iLen = 2*wcslen(src);
	return wcstombs(dst,src,iLen+1);
}
int char2TCHAR(char* src,TCHAR* dst)
{
	int iLen = 2*strlen(src);
	return mbstowcs(dst,src,iLen+1);
}
void ProcessFileData(WIN32_FIND_DATA* data,int mode,TCHAR* pFilePath,DWORD* size)
{
	HANDLE hFile;   // Handle of file 
	if ((data->dwFileAttributes&FILE_ATTRIBUTE_DIRECTORY) != FILE_ATTRIBUTE_DIRECTORY )
	{
		DWORD suflen = lstrlen(TEXT(".gz"));
		if(lstrlen(data->cFileName)<=suflen)
			return;
		DWORD tlen = lstrlen(data->cFileName)-suflen;
		if(lstrcmp(&(data->cFileName[tlen]),TEXT(".gz")))
			return;
		TCHAR fPath[MAX_PATH + 1]={0};
		lstrcpy(fPath, pFilePath);
		lstrcat(fPath, TEXT("\\"));
		lstrcat(fPath, data->cFileName);
		hFile = CreateFile(fPath, GENERIC_READ,
			FILE_SHARE_READ, (LPSECURITY_ATTRIBUTES)
			NULL, OPEN_EXISTING,
			FILE_ATTRIBUTE_NORMAL, (HANDLE) NULL); 
		if (hFile == (HANDLE) INVALID_HANDLE_VALUE) 
			return; 
		switch(mode){
				case PROCESS_FILE_SIZE:
					(*size)+= GetFileSize(hFile, (LPDWORD) NULL); 
					break;
				case PROCESS_FILE_DECODE:
					{
						char rs[800]={0};
						char inpath[MAX_PATH + 1]={0};
						char outpath[MAX_PATH + 1]={0};
						TCHAR2char(fPath,inpath);
						strcpy(outpath,".\\");
						strncat(outpath,&inpath[strlen(TEMP_PORTABLE_PATH)],strlen(inpath)-strlen(TEMP_PORTABLE_PATH)-strlen(".gz"));
#if 0
						TCHAR msg[1024]={0};
						wsprintf(msg,TEXT("in=%s out=%s"),inpath,outpath);
						MessageBox(NULL,fPath,TEXT("xx"),MB_OK);
#endif
						lzmaFile(inpath,outpath, rs,0);
						DoEvent();
						(*size)+= GetFileSize(hFile, (LPDWORD) NULL); 
						SendMessage(hwndPB, PBM_SETPOS, ((*size)*100)/totalfilesize, 0); 
						DoEvent();
					}
					break;
		}          
		CloseHandle((HANDLE) hFile); 

	} else if((data->dwFileAttributes&FILE_ATTRIBUTE_DIRECTORY) == FILE_ATTRIBUTE_DIRECTORY
		&& lstrcmp(data->cFileName, TEXT(".")) != 0
		&& lstrcmp(data->cFileName, TEXT("..")) != 0)
	{   
		//找到目录
		TCHAR Dir[MAX_PATH + 1];
		lstrcpy(Dir, pFilePath);
		lstrcat(Dir, TEXT("\\"));
		lstrcat(Dir, data->cFileName);
		//MessageBox(NULL,Dir,TEXT("xx"),MB_OK);

		TCHAR newDir[MAX_PATH + 1]={0};
		lstrcat(newDir, TEXT(".\\"));
		lstrcat(newDir, &Dir[lstrlen(TEXT(TEMP_PORTABLE_PATH))]);
		if (!CreateDirectory(newDir, NULL)) 
		{ 

		} 
		totalFileSize(Dir,mode,size);
	}
}
int totalFileSize(TCHAR* pFilePath,int mode,DWORD* size)
{
	WIN32_FIND_DATA FindFileData;
	HANDLE hFind = INVALID_HANDLE_VALUE;   
	TCHAR DirSpec[MAX_PATH + 1];
	DWORD dwError;

	lstrcpyn (DirSpec, pFilePath, lstrlen(pFilePath) + 1);
	lstrcat (DirSpec, TEXT("\\*"));

	hFind = FindFirstFile(DirSpec, &FindFileData);

	if (hFind == INVALID_HANDLE_VALUE)
	{
		MessageBox (NULL, DirSpec, szTitle, MB_ICONERROR) ;
		return 0;
	}
	else {       
		ProcessFileData(&FindFileData,mode,pFilePath,size);
		while (FindNextFile(hFind, &FindFileData) != 0){
			ProcessFileData(&FindFileData,mode,pFilePath,size);
		}
		dwError = GetLastError();
		FindClose(hFind);
		if (dwError != ERROR_NO_MORE_FILES)
		{
			MessageBox (NULL, TEXT("FindNextFile error."),	szTitle, MB_ICONERROR) ;
			return 0;
		}
	}     
}
BOOL DoEvent()
{
	BOOL bQuit = FALSE;
	MSG msg;
	while( PeekMessage( &msg, NULL, 0, 0, PM_REMOVE ) )
	{
		if( msg.message ==WM_COMMAND)
		{
			if( LOWORD(msg.wParam) == IDCANCEL||LOWORD(msg.wParam) == IDOK)
				return TRUE;
		}
		if( !IsDialogMessage( hMainWnd, &msg ) ) 
		{
			TranslateMessage( &msg );
			DispatchMessage( &msg );
		}
	}
	return bQuit;
} 
void StartUpdate(HWND hwndPb,TCHAR* pFilePath)
{
	DWORD nowsize=0;       // Size of file and count of   
	totalFileSize(pFilePath,PROCESS_FILE_SIZE,&totalfilesize);
	SendMessage(hwndPb, PBM_SETRANGE, 0, MAKELPARAM(0, 100)); 
	//   SendMessage(hwndPb, PBM_SETSTEP, (WPARAM) 1, 0);  
	totalFileSize(pFilePath,PROCESS_FILE_DECODE,&nowsize);
	//copy .\temp\portable\update.ini to .\update.ini
	TCHAR oldupdateini[MAX_PATH+1]={0};
	TCHAR newupdateini[MAX_PATH+1]={0};
	lstrcpy(oldupdateini, TEXT(TEMP_PORTABLE_PATH)); 
	lstrcat(oldupdateini, TEXT("update.ini")); 
	lstrcpy(newupdateini, TEXT(".\\update.ini")); 
  //MessageBox(NULL,newupdateini,oldupdateini,MB_OK);
	CopyFile(oldupdateini, newupdateini, FALSE);
	setUpdateFlag(0);
	DeleteDir(TEXT(TEMP_PORTABLE_PATH));
	runProgram(TEXT(".\\touchany.exe"),TEXT(""));
	PostQuitMessage (0); 
	return;
}

// “关于”框的消息处理程序。
INT_PTR CALLBACK DlgProc(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	switch (message)
	{
	case WM_INITDIALOG:		 
		hMainWnd = hDlg;
		hwndPB=GetDlgItem( hMainWnd, IDC_PROGRESS1);		
		PostMessage(hDlg,WM_UPDATE_START,(WPARAM)hwndPB,(LPARAM)NULL);
		return (INT_PTR)TRUE;
	case WM_COMMAND:
		if (LOWORD(wParam) == IDOK || LOWORD(wParam) == IDCANCEL)
		{
			EndDialog(hDlg, LOWORD(wParam));
			return (INT_PTR)TRUE;
		}
		break;
	case WM_UPDATE_START:
		{
			if(queryUpdateFlag()){
				TCHAR *pFilePath = TEXT(".\\temp\\portable");
				StartUpdate((HWND)wParam,pFilePath);
			}else
			{
				PostQuitMessage (0); 
			}
		}
		break; 
	}
	return (INT_PTR)FALSE;
}
