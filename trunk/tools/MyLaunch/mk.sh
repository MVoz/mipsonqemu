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
rm -fr debug release tmp
exit 0
fi


rm -fr $obj
mkdir $obj

makefunc './version/version'

if [ $obj ==  "release" ];then
cmd /c include/version.exe
fi

actions=(./fmd5/fmd5 ./dll/bmapi ./dll/bmnet ./dll/catalog ./dll/bmxml  ./dll/bmpost ./dll/bmmerge ./dll/bmsync ./dll/diggxml ./dll/fileget ./dll/appupdater  ./dll/optionUI ./dll/fileget ./platforms/win/win ./src/src)

for action in ${actions[*]}
do
makefunc $action
done

echo './resource/NormalwebUI/tr.sh'
cd ./resource/NormalwebUI/
./tr.sh
cd ../..

cmd /c @rcc -binary resource/webUI/optionUI.qrc -o $obj/options.rcc

rm -fr resource/webUI

mkdir $obj/skins
cmd /c @rcc -binary resource/skins/Default/default.qrc -o $obj/skins/default.rcc

mkdir $obj/data
cmd /c @.\\resource\\sqlite3.exe  $obj/data/defines.db < ./resource/readsql.bat

cp -fr ./resource/data $obj/
cp -fr ./resource/images $obj/

clean_dirs=($obj include resource)

for dir in ${clean_dirs[*]}
do
rm -fr $dir/*.exp  $dir/*.lib  $dir/*.manifest $dir/*.ilk $dir/*.pdb
done

find $obj -name ".svn"|xargs rm -fr

rm -fr Makefile Makefile.Debug Makefile.Release

cd $obj
echo "runing touchany.................."
./touchany.exe
cd ..



