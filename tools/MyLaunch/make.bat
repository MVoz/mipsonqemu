cd /d debug
del touchAny.exe
del options.rcc
cd ..

cd /d include
version.exe
cd ..

cd /d dll
SET SRC=log
rem call :makefunc %SRC% 

SET SRC=bmapi
call :makefunc %SRC% 

SET SRC=testserver
call :makefunc %SRC% 

SET SRC=pinyin
rem call :makefunc %SRC% 

SET SRC=catalog
call :makefunc %SRC% 

SET SRC=xmlreader
call :makefunc %SRC% 

SET SRC=updaterThread
call :makefunc %SRC% 

SET SRC=posthttp
call :makefunc %SRC% 

SET SRC=mergethread
call :makefunc %SRC% 

SET SRC=bookmark_sync
call :makefunc %SRC% 

SET SRC=synchronizeDlg
call :makefunc %SRC% 

SET SRC=options
call :makefunc %SRC% 

SET SRC=icon_delegate
call :makefunc %SRC% 

SET SRC=catalog_types
call :makefunc %SRC% 

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

rem cd /d plugins
rem cd /d runner
rem SET SRC=runner
rem call :makefunc %SRC% 
rem cd ..

rem cd /d weby
rem qmake weby.pro
rem nmake debug
rem cd ..

rem cd /d calcy
rem qmake calcy.pro
rem nmake debug
rem cd ..
rem cd ..

cd /d resource
rcc -binary options.qrc -o options.rcc
copy options.rcc ..\debug
copy options.rcc ..\release

sqlite3.exe defines.db<readsql.bat
copy defines.db data\

set SRC=data
call :copyfunc %SRC% ..\debug\%SRC%
call :copyfunc %SRC% ..\release\%SRC%

set SRC=html
call :copyfunc %SRC% ..\debug\%SRC%
call :copyfunc %SRC% ..\release\%SRC%

set SRC=skins
call :copyfunc %SRC% ..\debug\%SRC%
call :copyfunc %SRC% ..\release\%SRC%


del defines.db
del options.rcc
del data\defines.db

cd ..

cd .\release
del *.exp *.lib *.manifest
cd ..

cd .\debug
touchAny.exe
cd ..

goto :EOF

:copyfunc                   
del /Q/S %2
rmdir /Q/S %2
mkdir %2
xcopy %1 %2 /s            
goto :EOF    

:makefunc                   
qmake %1%.pro
nmake debug    
nmake release
goto :EOF  