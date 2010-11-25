/* Creation of a simple Windows API program */

#include <windows.h>
#include <commctrl.h>
#include "resource.h"

#define WM_UPDATE_START WM_USER+10
void StartUpdate(HWND hwndPb,TCHAR* pFilePath);
int totalFileSize(TCHAR* pFilePath,DWORD* size);
HWND hwndPB;    // Handle of progress bar 
HWND texthwnd;
/*  Declare Windows procedure  */
LRESULT CALLBACK WindowProcedure (HWND, UINT, WPARAM, LPARAM);

/*  Make the class name into a global variable  */
char szClassName[ ] = "WindowsApp";

    HWND hwnd;  
int WINAPI
WinMain (HINSTANCE hThisInstance,
         HINSTANCE hPrevInstance,
         LPSTR lpszArgument,
         int nFunsterStil)

{
             /* This is the handle for our window */
    MSG messages;            /* Here messages to the application are saved */
    WNDCLASSEX wincl;        /* Data structure for the windowclass */

    /* The Window structure */
    wincl.hInstance = hThisInstance;
    wincl.lpszClassName = szClassName;
    wincl.lpfnWndProc = WindowProcedure;      /* This function is called by windows */
    wincl.style = CS_DBLCLKS;                 /* Catch double-clicks */
    wincl.cbSize = sizeof (WNDCLASSEX);

    /* Use default icon and mouse-pointer */
    wincl.hIcon = LoadIcon (NULL, IDI_APPLICATION);
    wincl.hIconSm = LoadIcon (NULL, IDI_APPLICATION);
    wincl.hCursor = LoadCursor (NULL, IDC_ARROW);
    wincl.lpszMenuName = NULL;                 /* No menu */
    wincl.cbClsExtra = 0;                      /* No extra bytes after the window class */
    wincl.cbWndExtra = 0;                      /* structure or the window instance */
    /* Use Windows's default color as the background of the window */
    wincl.hbrBackground = (HBRUSH) COLOR_BACKGROUND;

    /* Register the window class, and if it fails quit the program */
    if (!RegisterClassEx (&wincl))
        return 0;

    /* The class is registered, let's create the program*/
    hwnd = CreateWindowEx (
           0,                   /* Extended possibilites for variation */
           szClassName,         /* Classname */
           "Windows App",       /* Title Text */
           WS_OVERLAPPEDWINDOW&(~WS_MAXIMIZEBOX)&(~WS_MINIMIZEBOX), /* default window */
           CW_USEDEFAULT,       /* Windows decides the position */
           CW_USEDEFAULT,       /* where the window ends up on the screen */
           400,                 /* The programs width */
           100,                 /* and height in pixels */
           HWND_DESKTOP,        /* The window is a child-window to desktop */
           NULL,                /* No menu */
           hThisInstance,       /* Program Instance handler */
           NULL                 /* No Window Creation data */
           );
   
           
           InitCommonControls(); 
         

    /* Make the window visible on the screen */
    ShowWindow (hwnd, nFunsterStil);

    /* Run the message loop. It will run until GetMessage() returns 0 */
    while (GetMessage (&messages, NULL, 0, 0))
    {
        /* Translate virtual-key messages into character messages */
        TranslateMessage(&messages);
        /* Send message to WindowProcedure */
        DispatchMessage(&messages);
    }

    /* The program return-value is 0 - The value that PostQuitMessage() gave */
    return messages.wParam;
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
            lstrcat(fPath, "\\");
            lstrcat(fPath, data->cFileName);
            hFile = CreateFile(fPath, GENERIC_READ,
                    FILE_SHARE_READ, (LPSECURITY_ATTRIBUTES)
                    NULL, OPEN_EXISTING,
                    FILE_ATTRIBUTE_NORMAL, (HANDLE) NULL); 
            if (hFile == (HANDLE) INVALID_HANDLE_VALUE) 
                    return; 

            (*size)+= GetFileSize(hFile, (LPDWORD) NULL); 

        } else if(data->dwFileAttributes == FILE_ATTRIBUTE_DIRECTORY
            && lstrcmp(data->cFileName, ".") != 0
            && lstrcmp(data->cFileName, "..") != 0)
        {   
            //找到目录
            TCHAR Dir[MAX_PATH + 1];
            lstrcpy(Dir, pFilePath);
            lstrcat(Dir, "\\");
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
    lstrcat (DirSpec, "\\*");

    hFind = FindFirstFile(DirSpec, &FindFileData);

    if (hFind == INVALID_HANDLE_VALUE)
    {
        MessageBox (NULL, TEXT ("Invalid file handle"), TEXT(szClassName), MB_ICONERROR) ;
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
                      TEXT(szClassName), MB_ICONERROR) ;
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
      if( msg.message == WM_QUIT )
          {

             return TRUE;
          }
      if( !IsDialogMessage( hwnd, &msg ) ) 
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
    while(!bQuit){ 
        SendMessage(hwndPb, PBM_STEPIT, 0, 0); 
        bQuit = DoEvent();
    }  
    PostQuitMessage (0); 
    //wsprintf(totalsizestr,"%ubytes",totalsize);
   // MessageBox (NULL, TEXT(totalsizestr),TEXT(szClassName), MB_ICONERROR) ;
    return;
}

/*  This function is called by the Windows function DispatchMessage()  */

LRESULT CALLBACK
WindowProcedure (HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    RECT rcClient;  // Client area of parent window 
    int iPBHeight = 30;
    switch (message)                  /* handle the messages */
    {
       case WM_CREATE :
           GetClientRect(hwnd, &rcClient);  
                     
           hwndPB = CreateWindowEx(0, PROGRESS_CLASS,
            (LPTSTR) NULL, WS_CHILD | WS_VISIBLE,
            rcClient.left+60, (rcClient.bottom - rcClient.top-iPBHeight)/2, rcClient.right-rcClient.left-100, iPBHeight, 
            hwnd, (HMENU) 0, ((LPCREATESTRUCT) lParam)->hInstance, NULL); 
            /*
            texthwnd = CreateWindow (TEXT("STATIC"), 
            TEXT("bitmap1"),
            WS_CHILD | WS_VISIBLE | SS_BITMAP,//SS_BITMAP表示图片
            rcClient.left, 0,
            60, iPBHeight,
            hwnd, (HMENU) 0,
            ((LPCREATESTRUCT) lParam)->hInstance, NULL) ;
            SendMessage(texthwnd,   
            STM_SETIMAGE, //必须发送STM_SETIMAGE
            (WPARAM) 0, 
            (LPARAM) LoadImage(0,TEXT(".\\1.bmp"), IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE )//获取图片句柄,并转换为(LPARAM)
            );
            */
              


            HWND h = CreateWindowEx(0, WC_STATIC, NULL,
        WS_CHILD | WS_VISIBLE | SS_ICON,
         rcClient.left, 0,
              60, iPBHeight,hwnd, (HMENU)0, ((LPCREATESTRUCT) lParam)->hInstance, NULL);
            SendMessage(h, STM_SETICON,
                (WPARAM)(HICON)LoadImage(NULL, MAKEINTRESOURCE(IDI_ICON1), IMAGE_ICON, 32, 32, LR_SHARED), 0);

             
           PostMessage(hwnd,WM_UPDATE_START,(WPARAM)hwndPB,(LPARAM)NULL);
           break;
       case WM_DESTROY:
            PostQuitMessage (0);       /* send a WM_QUIT to the message queue */
            break;
       case WM_UPDATE_START:
             {
                 TCHAR *pFilePath = ".\\";
                 StartUpdate((HWND)wParam,pFilePath);
             }
            break;            
        default:                      /* for messages that we don't deal with */
            return DefWindowProc (hwnd, message, wParam, lParam);
    }

    return 0;
}


