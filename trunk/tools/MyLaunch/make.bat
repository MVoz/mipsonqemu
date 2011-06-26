CALL "d:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat" x86
SET obj=%1

cd /d %obj%
del touchAny.exe
del options.rcc

if "%obj%"=="release" (
del /Q/S *
@for /d %%a in (*) do @rd /s/q "%%a" 
)

cd ..

cd /d version
call :makefunc version
nmake release
cd ..

cd /d fmd5
call :makefunc fmd5
cd ..

if "%obj%"=="release" (
cd /d include
version.exe
cd ..
)

cd /d dll
for %%i in (bmapi bmnet catalog bmxml  bmpost bmmerge bmsync diggxml fileget appupdater  optionUI fileget) do call :makefunc %%i 
cd ..

cd /d src
SET SRC=src
call :makefunc %SRC% 
cd ..

cd /d platforms
cd /d win
SET SRC=win
call :makefunc %SRC% 
cd ..
cd ..


cd /d resource
rcc -binary options.qrc -o options.rcc
copy options.rcc ..\%obj%

rcc -binary skin.qrc -o skins/default.rcc


sqlite3.exe defines.db<readsql.bat
copy defines.db data\

if "%obj%"=="release" (
copy ..\win\msvcr80.dll ..\release
copy ..\win\QtXml4.dll ..\release
copy ..\win\QtNetwork4.dll ..\release
copy ..\win\QtGui4.dll ..\release
copy ..\win\QtSql4.dll ..\release
copy ..\win\QtCore4.dll ..\release
copy ..\win\QtWebKit4.dll ..\release
copy ..\update\updater\release\updater.exe ..\release
call :copyfunc ..\win\Microsoft.VC80.CRT ..\%obj%\Microsoft.VC80.CRT
)

for %%i in (data html skins images) do call :copyfunc %%i ..\%obj%\%%i

del defines.db
del options.rcc
del data\defines.db
cd ..

if "%obj%"=="release" (
rmdir /Q/S download
mkdir download
mkdir download\portable
mkdir download\setup

cd .\release
del *.exp *.lib *.manifest
cd ..

call :copyfunc .\release .\download\portable

copy .\include\index.php .\download\index.php 

cd  .\download
cd portable
..\..\resource\fmd5.exe -p
del *.exp *.lib *.manifest *.dll
xcopy update.ini ..\..\release /s 
cd ..
cd setup
..\..\resource\fmd5.exe -s
cd ..
cd ..

cd .\release
del *.lib *.manifest
del ..\win\installer\release\setup.exe
"d:\Program Files\Inno Setup 5\Compil32.exe"  /cc ..\win\installer\SETUP.iss
copy ..\win\installer\release\setup.exe ..\download\setup\setup.exe 
"D:\Program Files\WinRAR\WinRAR.exe" a -as -r  -EP1 "..\download\touchAny.rar" "..\release"
cd ..

)

if "%obj%"=="debug" (
cd .\%obj%
touchAny.exe
cd ..
)

goto :EOF


:copyfunc    
echo off
del /Q/S %2 
rmdir /Q/S %2
mkdir %2
xcopy %1 %2 /s            
echo on
goto :EOF    

:makefunc                   
qmake %1%.pro
nmake %obj%
goto :EOF 