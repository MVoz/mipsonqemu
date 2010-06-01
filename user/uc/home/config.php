<?php
/*
	[Ucenter Home] (C) 2007-2008 Comsenz Inc.
	$Id: config.new.php 9293 2008-10-30 06:44:42Z liguode $
*/

//Ucenter Home配置参数
$_SC = array();
$_SC['dbhost']  		= '127.0.0.1'; //服务器地址
$_SC['dbuser']  		= 'root'; //用户
$_SC['dbpw'] 	 		= '981221'; //密码
$_SC['dbcharset'] 		= 'utf8'; //字符集
$_SC['pconnect'] 		= 0; //是否持续连接
$_SC['dbname']  		= 'uc_db'; //数据库
$_SC['tablepre'] 		= 'uchome_'; //表名前缀
$_SC['filepre']      = 'bm_';
$_SC['charset'] 		= 'utf-8'; //页面字符集

$_SC['gzipcompress'] 	= 0; //启用gzip

$_SC['cookiepre'] 		= 'uchome_'; //COOKIE前缀
$_SC['cookiedomain'] 	= ''; //COOKIE作用域
$_SC['cookiepath'] 		= '/'; //COOKIE作用路径

$_SC['attachdir']		= './attachment/'; //附件本地保存位置(服务器路径, 属性 777, 必须为 web 可访问到的目录, 相对目录务必以 "./" 开头, 末尾加 "/")
$_SC['attachurl']		= 'attachment/'; //附件本地URL地址(可为当前 URL 下的相对地址或 http:// 开头的绝对地址, 末尾加 "/")

$_SC['siteurl']			= ''; //站点的访问URL地址(http:// 开头的绝对地址, 末尾加 "/")，为空的话，系统会自动识别。

$_SC['tplrefresh']		= 0; //判断模板是否更新的效率等级，数值越大，效率越高; 设置为0则永久不判断

//Ucenter Home安全相关
$_SC['founder'] 		= '1'; //创始人 UID, 可以支持多个创始人，之间使用 “,” 分隔。部分管理功能只有创始人才可操作。
$_SC['allowedittpl']	= 0; //是否允许在线编辑模板。为了服务器安全，强烈建议关闭

$_SC['bookmark_show_maxnum'] =8;
$_SC['bookmark_type_site']=0;
$_SC['bookmark_type_dir']=1;
//Link origin 类型
$_SC['link_origin_bookmark']=0;	  /*添加bookmark而产生的*/
$_SC['link_origin_link']=1;		  /*上榜产生的*/
//link verify 类型
$_SC['link_verify_undo']=0;
$_SC['link_verify_passed']=1;
$_SC['link_verify_failed']=2;
$_SC['link_delete_uid']=11;

//length
$_SC['subject_length']=256;
$_SC['subject_nbox_title_length']=40;
$_SC['subject_todayhot_length']=10;
$_SC['subject_related_length']=10;

$_SC['description_length']=512;
$_SC['description_nbox_title_length']=80;
$_SC['description_todayhot_length']=80;
$_SC['description_related_length']=98;

//link 图像目录
$_SC['link_image_path']='snapshot/';
$_SC['link_image_suffix']='.jpg';

$_SC['unknown_description']='暂没有对此网站描述，请等待服务器更新';
$_SC['unknown_tag']='什么也没留下...';

$_SC['digg_name']='掘客';

$_SC['related_site_num']=8;

$_SC['favorite_tag_maxnum']=30;

/*
	计算link的award
*/
$_SC['link_award_initial_value']=7000;
$_SC['link_award_store_weight']=1;
$_SC['link_award_view_weight']=1;
$_SC['link_award_up_weight']=1;
$_SC['link_award_down_weight']=1;
$_SC['link_award_div']=1000;
$_SC['link_award_max']=10;
$_SC['link_award_min']=5;

//应用的UCenter配置信息(可以到UCenter后台->应用管理->查看本应用->复制里面对应的配置信息进行替换)
define('UC_CONNECT', 'mysql'); // 连接 UCenter 的方式: mysql/NULL, 默认为空时为 fscoketopen(), mysql 是直接连接的数据库, 为了效率, 建议采用 mysql
define('UC_DBHOST', '192.168.115.2'); // UCenter 数据库主机
define('UC_DBUSER', 'root'); // UCenter 数据库用户名
define('UC_DBPW', '981221'); // UCenter 数据库密码
define('UC_DBNAME', 'uc_db'); // UCenter 数据库名称
define('UC_DBCHARSET', 'utf8'); // UCenter 数据库字符集
define('UC_DBTABLEPRE', '`uc_db`.uc_'); // UCenter 数据库表前缀
define('UC_DBCONNECT', '0'); // UCenter 数据库持久连接 0=关闭, 1=打开
define('UC_KEY', 'ofI06ezfwfb2GfbbYfecUatdJ6qbP2j2Z7DdIco1O5O6d0B4mcec7cf9bez4P0W1'); // 与 UCenter 的通信密钥, 要与 UCenter 保持一致
define('UC_API', 'http://192.168.115.2/uc/ucenter'); // UCenter 的 URL 地址, 在调用头像时依赖此常量
define('UC_CHARSET', 'utf8'); // UCenter 的字符集
define('UC_IP', '127.0.0.1'); // UCenter 的 IP, 当 UC_CONNECT 为非 mysql 方式时, 并且当前应用服务器解析域名有问题时, 请设置此值
define('UC_APPID', '1'); // 当前应用的 ID
define('UC_PPP', 20);

?>
