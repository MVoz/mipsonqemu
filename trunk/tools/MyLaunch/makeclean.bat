cd /d debug
del Launchy.exe
del options.rcc
del /s /q *.dll
cd ..

cd /d dll
cd /d debug
del /s /q *.obj
cd ..
cd ..

cd /d src
cd /d build
del /s /q *.obj
cd ..
cd ..





