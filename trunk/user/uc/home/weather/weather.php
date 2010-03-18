#!/usr/bin/php
<?php
$a=preg_replace('/^{weatherinfo:{(.*)}}/',"\\1",trim($argv[1]));
$arr=explode(",",$a); 
$weatherarr=array();
$keysarr=array();
foreach($arr as $key=>$value)
{
  $trr=explode(":",$value);
  $keysarr[]= ($trr[0]=='index')?'index_u':$trr[0];
  $weatherarr[]="'".$trr[1]."'";
  
}
include_once('../common.php');
//echo "REPLACE INTO ".tname('weather')." ( ".implode(',', $keysarr)." ) VALUES (".implode(',', $weatherarr)." )";
$_SGLOBAL['db']->query("REPLACE INTO ".tname('weather')."( ".implode(',', $keysarr)." ) VALUES ( ".implode(',', $weatherarr)." )");
?>
