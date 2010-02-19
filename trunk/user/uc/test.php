<?php
	//printf(preg_replace("/([^\:]+).*/", "&\\1", "123:192.168.115.2"));
	//printf(preg_replace("/(\<[^\<]*\>|\r|\n|\s|\[.+?\])/is", ' ', "<hi>[123]sffsf</hi>"));
	//printf(intval('dgdsfg'));
	echo $_GET['id'];
	if(isset($_GET['id']))
		echo '1';
	else
		echo '0';
?>