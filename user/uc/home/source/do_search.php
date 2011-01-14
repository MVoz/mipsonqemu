<?php
/*
	[UCenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: do_register.php 13111 2009-08-12 02:39:58Z liguode $
*/

if(!defined('IN_UCHOME')) {
	exit('Access Denied');
}

$type = $_GET['type'] ? trim($_GET['type']) : '';
$q = $_GET['q'] ? trim($_GET['q']) : '';

if($type=='taobao'){
	$url_gb = iconv("UTF-8","GB2312//TRANSLIT",$q);
	$url = "http://search8.taobao.com/browse/search_auction.htm?q=" . $url_gb . "&commend=all&search_type=auction&at_topsearch=1";
	header("Content-Type: text/html; charset=gb2312");
	Header("HTTP/1.1 301 Moved Permanently");
	Header("Location: $url"); 
	exit;
}else if($type=='360buy'){
	$url_gb = iconv("UTF-8","GB2312//TRANSLIT",$q);
	$url = "http://search.360buy.com/Search?keyword=" . $url_gb ;
	header("Content-Type: text/html; charset=gb2312");
	Header("HTTP/1.1 301 Moved Permanently");
	Header("Location: $url"); 
	exit;
}else if($type=="dangdang"){
	$url_gb = iconv("UTF-8","GB2312//TRANSLIT",$q);
	$url = "http://search.dangdang.com/search.aspx?key=" . $url_gb ;
	header("Content-Type: text/html; charset=gb2312");
	Header("HTTP/1.1 301 Moved Permanently");
	Header("Location: $url"); 
	exit;
}
exit;
?>