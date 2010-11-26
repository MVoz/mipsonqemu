// updater.cpp : 定义应用程序的入口点。
//

#include "stdafx.h"
#include "updater.h"
#include <commctrl.h>

#pragma comment(lib, "comctl32.lib")

#define MAX_LOADSTRING 100

#define WM_UPDATE_START WM_USER+100

HWND hMainWnd;//main handle
HWND hwndPB;    // Handle of progress bar 


int totalFileSize(TCHAR* pFilePath,DWORD* size);
void StartUpdate(HWND hwndPb,TCHAR* pFilePath);

// 全局变量:
HINSTANCE hInst;								// 当前实例
TCHAR szTitle[MAX_LOADSTRING];					// 标题栏文本
TCHAR szWindowClass[MAX_LOADSTRING];			// 主窗口类名

INT_PTR CALLBACK	DlgProc(HWND, UINT, WPARAM, LPARAM);

INT WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
				   LPSTR lpCmdLine, int nCmdShow)
{
	hInst = hInstance;
    InitCommonControls();
	LoadString(hInstance, IDS_APP_TITLE, szTitle, MAX_LOADSTRING);
	LoadString(hInstance, IDC_UPDATER, szWindowClass, MAX_LOADSTRING);
	//DialogBox(hInst, MAKEINTRESOURCE(IDD_ABOUTBOX),
	//          NULL, reinterpret_cast<DLGPROC>(DlgProc));
	hMainWnd=CreateDialog(hInst, 
                                        MAKEINTRESOURCE(IDD_ABOUTBOX), 
                                        NULL, 
                                        (DLGPROC)DlgProc); 
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


void ProcessFileData(WIN32_FIND_DATA* data,TCHAR* pFilePath,DWORD* size)
{
      HANDLE hFile;   // Handle of file 
      if (data->dwFileAttributes != FILE_ATTRIBUTE_DIRECTORY )
        {
            //找到文件                                
           //  MessageBox (NULL, TEXT( data->cFileName),TEXT(szClassName), MB_ICONERROR) ;
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

            (*size)+= GetFileSize(hFile, (LPDWORD) NULL); 

        } else if(data->dwFileAttributes == FILE_ATTRIBUTE_DIRECTORY
            && lstrcmp(data->cFileName, TEXT(".")) != 0
            && lstrcmp(data->cFileName, TEXT("..")) != 0)
        {   
            //找到目录
            TCHAR Dir[MAX_PATH + 1];
            lstrcpy(Dir, pFilePath);
            lstrcat(Dir, TEXT("\\"));
            lstrcat(Dir, data->cFileName);
            totalFileSize(Dir,size);
        }
}
int totalFileSize(TCHAR* pFilePath,DWORD* size)
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
        MessageBox (NULL, TEXT ("Invalid file handle"), szTitle, MB_ICONERROR) ;
        return 0;
    }
    else {       
          ProcessFileData(&FindFileData,pFilePath,size);
        while (FindNextFile(hFind, &FindFileData) != 0){
           ProcessFileData(&FindFileData,pFilePath,size);
        }
        dwError = GetLastError();
        FindClose(hFind);
        if (dwError != ERROR_NO_MORE_FILES)
       {
             MessageBox (NULL, TEXT("FindNextFile error."),
                      szTitle, MB_ICONERROR) ;
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
    DWORD totalsize;       // Size of file and count of
    TCHAR totalsizestr[32];
    totalFileSize(pFilePath,&totalsize);
    SendMessage(hwndPb, PBM_SETRANGE, 0, MAKELPARAM(0, totalsize / 2048)); 
    SendMessage(hwndPb, PBM_SETSTEP, (WPARAM) 1, 0);     
    BOOL bQuit = FALSE; 
    while(!bQuit)
	{ 
        SendMessage(hwndPb, PBM_STEPIT, 0, 0); 
        bQuit = DoEvent();
    }  
   PostQuitMessage (0); 
   wsprintf(totalsizestr,TEXT("%ubytes"),totalsize);
   MessageBox (NULL, totalsizestr,szTitle, MB_ICONERROR) ;
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
		//	   MessageBox (NULL, szWindowClass,szTitle, MB_ICONERROR) ;
                TCHAR *pFilePath = TEXT(".\\");
              StartUpdate((HWND)wParam,pFilePath);
            }
       break; 
	}
	return (INT_PTR)FALSE;
}
