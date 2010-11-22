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


cd /d include
version.exe
cd ..

cd /d dll
for %%i in (bmapi bmnet catalog bmxml  bmpost bmmerge bmsync fileget appupdater  optionUI fileget) do call :makefunc %%i 
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
)

for %%i in (data html skins images) do call :copyfunc %%i ..\%obj%\%%i

del defines.db
del options.rcc
del data\defines.db
cd ..

if "%obj%"=="release" (
cd .\release
del *.exp *.lib *.manifest
..\fmd5\release\fmd5.exe -p
"C:\Program Files\Inno Setup 5\Compil32.exe"  /cc ..\win\installer\SETUP.iss
cd ..

rmdir /Q/S download
mkdir download
mkdir download\portable
mkdir download\setup
call :copyfunc .\release .\download\portable

copy .\win\installer\release\setup.exe .\download\setup\setup.exe 
cd  .\download
cd setup
..\..\\fmd5\release\fmd5.exe -s
cd ..
cd ..
)

if "%obj%"=="debug" (
cd .\%obj%
touchAny.exe
cd ..
)

goto :EOF


:copyfunc    
@ echo off
del /Q/S %2 
rmdir /Q/S %2
mkdir %2
xcopy %1 %2 /s            
@ echo on
goto :EOF    

:makefunc                   
qmake %1%.pro
nmake %obj%
goto :EOF 