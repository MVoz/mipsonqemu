#!/bin/sh
rm -f ../webUI/*
cp -fr * ../webUI
cd ../webUI
sed 's/style\//qrc:style\//g' index.html > 1
sed 's/js\//qrc:js\//g' 1 > 2
mv 2 index.html
rm -fr 1

sed 's/style\//qrc:style\//g' net.html > 1
sed 's/js\//qrc:js\//g' 1 > 2
mv 2 net.html
rm -fr 1

sed 's/style\//qrc:style\//g' custom.html > 1
sed 's/js\//qrc:js\//g' 1 > 2
mv 2 custom.html
rm -fr 1


cd style
sed 's/..\/images\//qrc:images\//g' demo.min.css >  2
mv 2 demo.min.css
sed 's/..\/images\//qrc:images\//g' uniform.default.css > 2
mv 2 uniform.default.css
cd ..

cd ../NormalwebUI

