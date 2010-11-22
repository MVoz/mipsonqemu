CALL "d:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat" x86
SET obj=%1


cd /d %obj%
del touchAny.exe
del options.rcc
cd ..

cd /d include
version.exe
cd ..

cd /d dll
for %%i in (bmapi bmnet catalog bmxml  bmpost bmmerge bmsync  optionUI appupdater icon_delegate catalog_types) do call :makefunc %%i 
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

for %%i in (data html skins images) do call :copyfunc %%i ..\%obj%\%%i

del defines.db
del options.rcc
del data\defines.db
cd ..

cd .\release
 del *.exp *.lib *.manifest
cd ..

cd .\%obj%
touchAny.exe
cd ..

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