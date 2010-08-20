<?Php 
/****************************************** 

Programmed by SurfChen,http://yube.Net.com 

******************************************/ 
function handleUrlString($url)
{
	$url=trim($url);
	$len=strlen($url);
	echo 'len='.$len.'<br>';
	while($url[$len-1]=='/')
	{
		$url=substr($url, 0, $len-1); 
		$len=strlen($url);
	}
	return $url;
}
echo handleUrlString("s1m//");
echo '<br>';
echo empty($_GET['uid'])?1:intval($_GET['uid']);
echo HELLO;

echo addslashes("123'123");
echo htmlspecialchars("123<123");
echo '<br>';
$txt="你好，中国";

echo mb_strlen($txt,"utf-8");

echo mb_substr($txt,0,4,"UTF-8");
//http://nowdownloadall.com/join.asp?PID=0cdfe76c-1849-49fd-acb3-44e095532314&ts=6/1/2010%2010:28:27%20PM&q=Understanding%20IPv6%20zip&cr=1

//http://quickrpickr.com/ 

//img src="http://lh4.ggpht.com/_QeLyLM_38SU/TAX3i8Jzg9I/AAAAAAAAAGo/r8QD8uaZSZs/s800/1.jpg" />
//http://hi.baidu.com/viste_happy/blog/item/699a07fc72e84849d7887d2a.html
//http://www.bram.us/demo/projects/jsprogressbarhandler/
?> 
