<?php
header("HTTP/1.1 404 Not Found"); 
header("Status: 404 Not Found"); 
include_once('./common.php');
$_TPL['css'] = 'network';
showmessage('view_to_info_did_not_exist');
?>