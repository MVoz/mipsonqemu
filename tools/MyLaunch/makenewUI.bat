REM CALL "d:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat" x86
SET obj=%1

if "%obj%"=="" (
  SET obj="debug"	
)


@rmdir /Q/S %obj%

if "%obj%"=="release" (
REM del /Q/S *
REM @for /d %%a in (*) do @rd /s/q "%%a" 
)

@call :makefunc ./version/version
@nmake release

if "%obj%"=="release" (
cd /d include
version.exe
cd ..
)

for %%i in (./fmd5/fmd5 ./dll/bmapi ./dll/bmnet ./dll/catalog ./dll/bmxml  ./dll/bmpost ./dll/bmmerge ./dll/bmsync ./dll/diggxml ./dll/fileget ./dll/appupdater  ./dll/optionUI ./dll/fileget ./platforms/win/win ./src/src) do call :makefunc %%i 


@cd /d resource
@rcc -binary webUI/optionUI.qrc -o options.rcc
@copy options.rcc ..\%obj%

@rcc -binary skins/Default/default.qrc -o skins/default.rcc

@sqlite3.exe defines.db<readsql.bat
@copy defines.db data\

@if "%obj%"=="release" (
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

for %%i in (data images) do call :copyfunc %%i ..\%obj%\%%i

@rmdir /Q/S ..\%obj%\skins
@mkdir ..\%obj%\skins
@xcopy skins\default.rcc ..\%obj%\skins /s  
@del skins\default.rcc

@del defines.db
@del data\defines.db
cd ..

@if "%obj%"=="release" (
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

REM clean somethings
@cd .\%obj%
@del /Q *.exp *.lib *.manifest *.ilk *.pdb
@cd ..

@cd include
@del /Q *.exp *.lib *.manifest *.ilk *.pdb
@cd ..

@cd resource
@del /Q *.lib *.manifest *.ilk *.pdb fmd5.exe
@cd ..

@del /Q Makefile Makefile.Debug Makefile.Release

@if "%obj%"=="debug" (
@cd .\%obj%
touchAny.exe
@cd ..
)
goto :EOF


:copyfunc    
@mkdir %2
@xcopy %1 %2 /s /Q          
@goto :EOF    

:makefunc                   
@qmake %1%.pro
@nmake %obj%
@goto :EOF 