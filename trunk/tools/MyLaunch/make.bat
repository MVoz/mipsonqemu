cd /d debug
del Launchy.exe
del options.rcc
cd ..

cd /d dll
qmake log.pro
nmake debug
qmake bmapi.pro 
nmake debug
qmake testserver.pro 
nmake debug
rem qmake pinyin.pro 
rem nmake debug
qmake catalog.pro
nmake debug
rem qmake weby.pro 
rem nmake debug
qmake runner.pro 
nmake debug
qmake xmlreader.pro 
nmake debug
qmake updaterThread.pro
nmake debug
qmake posthttp.pro 
nmake debug
qmake mergethread.pro 
nmake debug
qmake bookmark_sync.pro 
nmake debug
qmake synchronizeDlg.pro 
nmake debug
qmake options.pro
nmake debug

qmake icon_delegate.pro 
nmake debug
qmake catalog_types.pro 
nmake debug
cd ..

cd /d src
qmake src.pro
nmake debug
cd ..

cd /d platforms
cd /d win
qmake win.pro
nmake debug
cd ..
cd ..

rem cd /d plugins
rem cd /d runner
rem qmake runner.pro
rem nmake debug
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
cd ..

cd .\debug
tanzhi.exe
cd ..


