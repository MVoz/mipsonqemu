<?Php 
/****************************************** 

Programmed by SurfChen,http://yube.Net.com 

******************************************/ 
function handleUrlString($url)
{
	$url=trim($url);
	$len=strlen($url);
	while($url[$len-1]=='/')
	{
		$url=substr($url, 0, $len-1); 
		$len=strlen($url);
	}
	return $url;
}
echo handleUrlString("http://www.sohu.com///////");
echo empty($_GET['uid'])?1:intval($_GET['uid']);
<!--
http://nowdownloadall.com/join.asp?PID=0cdfe76c-1849-49fd-acb3-44e095532314&ts=6/1/2010%2010:28:27%20PM&q=Understanding%20IPv6%20zip&cr=1
-->
?> 
