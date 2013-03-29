#!/bin/sh
export QMAKESPEC=win32-msvc2005
export PATH=/cygdrive/D/Program\ Files/Microsoft\ Visual\ Studio\ 8/VC/bin:$PATH

cmd /c CALL "d:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat" x86
cmd /c set MAKEFLAGS=

obj=''

function makefunc()
{
    cmd /c @qmake $1.pro
    cmd /c @nmake $obj
    return
}

if [[ $1 ]];then
  obj=$1
else
  obj='debug'
fi

if [ $obj ==  "clean" ];then
rm -fr debug release tmp download
exit 0
fi



rm -fr $obj
mkdir $obj

makefunc './version/version'

if [ $obj ==  "release" ];then
rm -fr debug release tmp download
cd include
./version.exe
cd ..
mkdir download
mkdir download/setup
mkdir download/portable
fi

actions=(./fmd5/fmd5 ./dll/bmapi ./dll/bmnet ./dll/catalog ./dll/bmxml  ./dll/bmmerge ./dll/bmsync ./dll/appupdater  ./dll/optionUI  ./platforms/win/win ./src/src)

for action in ${actions[*]}
do
makefunc $action
done

echo './resource/NormalwebUI/tr.sh'
cd ./resource/NormalwebUI/
./tr.sh
cd ../..


mkdir $obj/skins
cmd /c @rcc -binary resource/skins/Default/default.qrc -o $obj/skins/default.rcc

mkdir $obj/data
cmd /c @.\\resource\\sqlite3.exe  $obj/data/defines.db < ./resource/readsql.bat

cp -fr ./resource/data $obj/
cp -fr ./resource/images $obj/

cp -fr ./resource/NormalwebUI/  ./resource/webUI
cmd /c @rcc -binary resource/webUI/optionUI.qrc -o $obj/data/options.rcc

rm -fr resource/webUI

clean_dirs=($obj include resource)

for dir in ${clean_dirs[*]}
do
	rm -fr $dir/*.exp  $dir/*.lib  $dir/*.manifest $dir/*.ilk $dir/*.pdb
done



rm -fr Makefile Makefile.Debug Makefile.Release

if [ $obj ==  "release" ];then
cp ./win/QtXml4.dll ./release
cp ./win/QtNetwork4.dll ./release
cp ./win/QtGui4.dll ./release
cp ./win/QtSql4.dll ./release
cp ./win/QtCore4.dll ./release
cp ./win/QtWebKit4.dll ./release
#cp ./update/updater/release\updater.exe ./release
cp -fr ./win/Microsoft.VC80.CRT ./release/Microsoft.VC80.CRT


find $obj -name ".svn"|xargs rm -fr

rm -fr  ./win/installer/release/touchany_setup.exe
rm -fr  ./win/installer/release/touchAny.rar
rm -fr  ./download/setup/touchany_setup.exe
rm -fr  ./download/touchAny.rar
cmd /c @ 'd:\\Program Files\\Inno Setup 5\\Compil32.exe'  /cc '.\\win\\installer\\SETUP.iss'
cp ./win/installer/release/touchany_setup.exe ./download/setup/touchany_setup.exe 
cmd /c @ 'D:\\Program Files\\WinRAR\\WinRAR.exe' a -as -r  -EP1 '.\\download\\touchAny.rar' '.\\release'

mv  -f ./include/index.php ./download/index.php 

rm -fr ./download/portable/*
cp -fr release/* ./download/portable
cd  ./download/portable
cmd /c @ .\\..\\..\\resource\\fmd5.exe -p

cp update.ini ./../../release
cd ..
cd setup
cmd /c @ .\\..\\..\\resource\\fmd5.exe -s
cd ..
cd ..
fi
cd $obj
echo "runing touchany.................."
./touchany.exe
cd ..



