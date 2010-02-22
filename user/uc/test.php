<?php
	@define('IN_UCHOME', TRUE);
	@include_once('home/source/function_common.php');
	//printf(preg_replace("/([^\:]+).*/", "&\\1", "123:192.168.115.2"));
	//printf(preg_replace("/(\<[^\<]*\>|\r|\n|\s|\[.+?\])/is", ' ', "<hi>[123]sffsf</hi>"));
	//printf(intval('dgdsfg'));
	echo getstr('h<\'ello', 80, 1, 0, 1);
?>