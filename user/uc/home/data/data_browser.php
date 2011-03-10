<?php
if(!defined('IN_UCHOME')) exit('Access Denied');
$_SGLOBAL['browser']=Array
	(
	0 => Array
		(
		'browserid' => '0',
		'browsername' => 'network',
		'maxlev' => 5,
		'maxchild' => 128,
		'titlelen' => 512,
		'dirlen' => 256,
		'urllen' => 512,
		'taglen' => 128,
		'deslen' => 512,
		'speicalchar' => 1
		),
	1 => Array
		(
		'browserid' => 1,
		'browsername' => 'ie',
		'maxlev' => 5,
		'maxchild' => 128,
		'titlelen' => 210,
		'dirlen' => 202,
		'urllen' => 512,
		'taglen' => 128,
		'deslen' => 512,
		'speicalchar' => '0'
		),
	2 => Array
		(
		'browserid' => 2,
		'browsername' => 'firefox',
		'maxlev' => 6,
		'maxchild' => 128,
		'titlelen' => 512,
		'dirlen' => 256,
		'urllen' => 512,
		'taglen' => 128,
		'deslen' => 512,
		'speicalchar' => 1
		),
	3 => Array
		(
		'browserid' => 3,
		'browsername' => 'opera',
		'maxlev' => 5,
		'maxchild' => 128,
		'titlelen' => 512,
		'dirlen' => 256,
		'urllen' => 512,
		'taglen' => 128,
		'deslen' => 512,
		'speicalchar' => 1
		)
	)
?>