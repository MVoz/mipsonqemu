cd /d debug
del tanzhi.exe
del options.rcc
del /s /q *.dll
cd ..

cd /d dll
cd /d debug
del /s /q *.obj
cd ..
cd ..

cd /d dll
cd /d release
del /s /q *.obj
cd ..
cd ..

cd /d src
cd /d build
del /s /q *.*
cd ..
cd ..





