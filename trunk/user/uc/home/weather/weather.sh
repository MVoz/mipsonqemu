#!/bin/bash
url='http://m.weather.com.cn/data/';
citycodes=(101190402 101190403 101190404 101190405);
for i in ${citycodes[*]}
do
  rm -fr  $url$i.html
  wget -q $url$i.html
  cat $i.html|xargs php weather.php 
  rm -fr  $url$i.html 
done

