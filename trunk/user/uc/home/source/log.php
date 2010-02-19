<?php
//Multiline error log class 
// ersin gจนven? 2008 eguvenc@gmail.com 
//For break use "\n" instead '\n' 

Class logdebug { 
  // 
  const USER_ERROR_DIR = './user_errors.log'; 
  const GENERAL_ERROR_DIR = './debug.log'; 

  /* 
   User Errors... 
  */ 
    public function user($msg,$username) 
    { 
    $date = date('d.m.Y h:i:s'); 
    $log = $msg."   |  Date:  ".$date."  |  User:  ".$username."\n"; 
    error_log($log, 3, self::USER_ERROR_DIR); 
    } 
    /* 
   General Errors... 
  */ 
    public function debug($name,$msg) 
    { 
    if(defined('DEBUG_UC'))
    {
    	$date = date('Y-m-d G:i:s'); 
    	if(is_array($msg))
   		  $log=var_export($msg,TRUE); 
   		elseif(is_string($msg))
   		  $log = $msg."\n";
   		elseif(is_integer($msg))
   			$log=sprintf("%d",$msg);
    	error_log("[".$date."]"."jblog:\n".$name."=".$log."\n", 3, self::GENERAL_ERROR_DIR); 
  	}
    } 
} 
?>