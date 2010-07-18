cd /d release
del Launchy.exe
del options.rcc
cd ..

cd /d dll
qmake log.pro
nmake release
qmake bmapi.pro 
nmake release
qmake testserver.pro 
nmake release
rem qmake pinyin.pro 
rem nmake release
qmake catalog.pro
nmake release
qmake weby.pro 
nmake release
qmake runner.pro 
nmake release
qmake xmlreader.pro 
nmake release
qmake updaterThread.pro
nmake release
qmake posthttp.pro 
nmake release
qmake mergethread.pro 
nmake release
qmake bookmark_sync.pro 
nmake release
qmake synchronizeDlg.pro 
nmake release
qmake options.pro
nmake release

qmake icon_delegate.pro 
nmake release
qmake catalog_types.pro 
nmake release
cd ..

cd /d src
qmake src.pro
nmake release
cd ..

cd /d platforms
cd /d win
qmake win.pro
nmake release
cd ..
cd ..

rem cd /d plugins
rem cd /d runner
rem qmake runner.pro
rem nmake release
rem cd ..

rem cd /d weby
rem qmake weby.pro
rem nmake release
rem cd ..

rem cd /d calcy
rem qmake calcy.pro
rem nmake release
rem cd ..
rem cd ..

cd /d resource
rcc -binary options.qrc -o options.rcc
copy options.rcc ..\debug
copy options.rcc ..\release
cd ..

cd .\release
del /s /q *.exp
del /s /q *.lib
tanzhi.exe
cd ..


