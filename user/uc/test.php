<?php
	@define('IN_UCHOME', TRUE);
	@include_once('home/source/function_common.php');
	//printf(preg_replace("/([^\:]+).*/", "&\\1", "123:192.168.115.2"));
	//printf(preg_replace("/(\<[^\<]*\>|\r|\n|\s|\[.+?\])/is", ' ', "<hi>[123]sffsf</hi>"));
	//printf(intval('dgdsfg'));
	echo getstr('h<\'ello', 80, 1, 0, 1);
	$see=empty($_GET['see'])?'':$_GET['see'];
	if(empty($see))
	echo 'emprty';
	else
	echo 'not empty';
	
	 $browsertype1=array(
            'ie'=>1,
            'firefox'=>2,
            'opera'=>3
        );


function mkbrowsertab1($id)
{
	global $browsertype1;
	foreach ($browsertype1 as $k => $v) {
		echo "\$a[$k] => $v.\n";
	}
	echo 'xx';
}
    
     mkbrowsertab1(1);
$arr=array();
$a=$arr['id'];
echo $a;
if($a)
echo '11';
else
echo '22';

?>