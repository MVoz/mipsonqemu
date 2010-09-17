/*
SQLyog Enterprise - MySQL GUI v8.14 
MySQL - 5.0.51a-24+lenny4 : Database - uc_db
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`uc_db` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `uc_db`;

/*Table structure for table `cdb_access` */

DROP TABLE IF EXISTS `cdb_access`;

CREATE TABLE `cdb_access` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `fid` smallint(6) unsigned NOT NULL default '0',
  `allowview` tinyint(1) NOT NULL default '0',
  `allowpost` tinyint(1) NOT NULL default '0',
  `allowreply` tinyint(1) NOT NULL default '0',
  `allowgetattach` tinyint(1) NOT NULL default '0',
  `allowpostattach` tinyint(1) NOT NULL default '0',
  `adminuser` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`uid`,`fid`),
  KEY `listorder` (`fid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_access` */

/*Table structure for table `cdb_activities` */

DROP TABLE IF EXISTS `cdb_activities`;

CREATE TABLE `cdb_activities` (
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `cost` mediumint(8) unsigned NOT NULL default '0',
  `starttimefrom` int(10) unsigned NOT NULL default '0',
  `starttimeto` int(10) unsigned NOT NULL default '0',
  `place` char(40) NOT NULL default '',
  `class` char(20) NOT NULL default '',
  `gender` tinyint(1) NOT NULL default '0',
  `number` smallint(5) unsigned NOT NULL default '0',
  `expiration` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`tid`),
  KEY `uid` (`uid`,`starttimefrom`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_activities` */

/*Table structure for table `cdb_activityapplies` */

DROP TABLE IF EXISTS `cdb_activityapplies`;

CREATE TABLE `cdb_activityapplies` (
  `applyid` int(10) unsigned NOT NULL auto_increment,
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(15) NOT NULL default '',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `message` char(200) NOT NULL default '',
  `verified` tinyint(1) NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `payment` mediumint(8) NOT NULL default '0',
  `contact` char(200) NOT NULL,
  PRIMARY KEY  (`applyid`),
  KEY `uid` (`uid`),
  KEY `tid` (`tid`),
  KEY `dateline` (`tid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_activityapplies` */

/*Table structure for table `cdb_adminactions` */

DROP TABLE IF EXISTS `cdb_adminactions`;

CREATE TABLE `cdb_adminactions` (
  `admingid` smallint(6) unsigned NOT NULL default '0',
  `disabledactions` text NOT NULL,
  PRIMARY KEY  (`admingid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_adminactions` */

/*Table structure for table `cdb_admincustom` */

DROP TABLE IF EXISTS `cdb_admincustom`;

CREATE TABLE `cdb_admincustom` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `title` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `sort` tinyint(1) NOT NULL default '0',
  `displayorder` tinyint(3) NOT NULL,
  `clicks` smallint(6) unsigned NOT NULL default '1',
  `uid` mediumint(8) unsigned NOT NULL,
  `dateline` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `uid` (`uid`),
  KEY `displayorder` (`displayorder`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_admincustom` */

/*Table structure for table `cdb_admingroups` */

DROP TABLE IF EXISTS `cdb_admingroups`;

CREATE TABLE `cdb_admingroups` (
  `admingid` smallint(6) unsigned NOT NULL default '0',
  `alloweditpost` tinyint(1) NOT NULL default '0',
  `alloweditpoll` tinyint(1) NOT NULL default '0',
  `allowstickthread` tinyint(1) NOT NULL default '0',
  `allowmodpost` tinyint(1) NOT NULL default '0',
  `allowdelpost` tinyint(1) NOT NULL default '0',
  `allowmassprune` tinyint(1) NOT NULL default '0',
  `allowrefund` tinyint(1) NOT NULL default '0',
  `allowcensorword` tinyint(1) NOT NULL default '0',
  `allowviewip` tinyint(1) NOT NULL default '0',
  `allowbanip` tinyint(1) NOT NULL default '0',
  `allowedituser` tinyint(1) NOT NULL default '0',
  `allowmoduser` tinyint(1) NOT NULL default '0',
  `allowbanuser` tinyint(1) NOT NULL default '0',
  `allowpostannounce` tinyint(1) NOT NULL default '0',
  `allowviewlog` tinyint(1) NOT NULL default '0',
  `allowbanpost` tinyint(1) NOT NULL default '0',
  `disablepostctrl` tinyint(1) NOT NULL default '0',
  `supe_allowpushthread` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`admingid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_admingroups` */

insert  into `cdb_admingroups`(`admingid`,`alloweditpost`,`alloweditpoll`,`allowstickthread`,`allowmodpost`,`allowdelpost`,`allowmassprune`,`allowrefund`,`allowcensorword`,`allowviewip`,`allowbanip`,`allowedituser`,`allowmoduser`,`allowbanuser`,`allowpostannounce`,`allowviewlog`,`allowbanpost`,`disablepostctrl`,`supe_allowpushthread`) values (1,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),(2,1,0,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0),(3,1,0,1,1,1,0,0,0,1,0,0,1,1,0,0,1,1,0);

/*Table structure for table `cdb_adminnotes` */

DROP TABLE IF EXISTS `cdb_adminnotes`;

CREATE TABLE `cdb_adminnotes` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `admin` varchar(15) NOT NULL default '',
  `access` tinyint(3) NOT NULL default '0',
  `adminid` tinyint(3) NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `expiration` int(10) unsigned NOT NULL default '0',
  `message` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_adminnotes` */

/*Table structure for table `cdb_adminsessions` */

DROP TABLE IF EXISTS `cdb_adminsessions`;

CREATE TABLE `cdb_adminsessions` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `adminid` smallint(6) unsigned NOT NULL default '0',
  `panel` tinyint(1) NOT NULL default '0',
  `ip` varchar(15) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `errorcount` tinyint(1) NOT NULL default '0',
  `storage` mediumtext NOT NULL,
  PRIMARY KEY  (`uid`,`panel`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_adminsessions` */

/*Table structure for table `cdb_advcaches` */

DROP TABLE IF EXISTS `cdb_advcaches`;

CREATE TABLE `cdb_advcaches` (
  `advid` mediumint(8) unsigned NOT NULL auto_increment,
  `type` varchar(50) NOT NULL default '0',
  `target` smallint(6) NOT NULL,
  `code` mediumtext NOT NULL,
  PRIMARY KEY  (`advid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_advcaches` */

/*Table structure for table `cdb_advertisements` */

DROP TABLE IF EXISTS `cdb_advertisements`;

CREATE TABLE `cdb_advertisements` (
  `advid` mediumint(8) unsigned NOT NULL auto_increment,
  `available` tinyint(1) NOT NULL default '0',
  `type` varchar(50) NOT NULL default '0',
  `displayorder` tinyint(3) NOT NULL default '0',
  `title` varchar(255) NOT NULL default '',
  `targets` text NOT NULL,
  `parameters` text NOT NULL,
  `code` text NOT NULL,
  `starttime` int(10) unsigned NOT NULL default '0',
  `endtime` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`advid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_advertisements` */

/*Table structure for table `cdb_announcements` */

DROP TABLE IF EXISTS `cdb_announcements`;

CREATE TABLE `cdb_announcements` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `author` varchar(15) NOT NULL default '',
  `subject` varchar(255) NOT NULL default '',
  `type` tinyint(1) NOT NULL default '0',
  `displayorder` tinyint(3) NOT NULL default '0',
  `starttime` int(10) unsigned NOT NULL default '0',
  `endtime` int(10) unsigned NOT NULL default '0',
  `message` text NOT NULL,
  `groups` text NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `timespan` (`starttime`,`endtime`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_announcements` */

/*Table structure for table `cdb_attachments` */

DROP TABLE IF EXISTS `cdb_attachments`;

CREATE TABLE `cdb_attachments` (
  `aid` mediumint(8) unsigned NOT NULL auto_increment,
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `pid` int(10) unsigned NOT NULL default '0',
  `width` smallint(6) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `readperm` tinyint(3) unsigned NOT NULL default '0',
  `price` smallint(6) unsigned NOT NULL default '0',
  `filename` char(100) NOT NULL default '',
  `description` char(100) NOT NULL default '',
  `filetype` char(50) NOT NULL default '',
  `filesize` int(10) unsigned NOT NULL default '0',
  `attachment` char(100) NOT NULL default '',
  `downloads` mediumint(8) NOT NULL default '0',
  `isimage` tinyint(1) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `thumb` tinyint(1) unsigned NOT NULL default '0',
  `remote` tinyint(1) unsigned NOT NULL default '0',
  PRIMARY KEY  (`aid`),
  KEY `tid` (`tid`),
  KEY `pid` (`pid`,`aid`),
  KEY `uid` (`uid`),
  KEY `dateline` (`dateline`,`isimage`,`downloads`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_attachments` */

/*Table structure for table `cdb_attachpaymentlog` */

DROP TABLE IF EXISTS `cdb_attachpaymentlog`;

CREATE TABLE `cdb_attachpaymentlog` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `aid` mediumint(8) unsigned NOT NULL default '0',
  `authorid` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `amount` int(10) unsigned NOT NULL default '0',
  `netamount` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`aid`,`uid`),
  KEY `uid` (`uid`),
  KEY `authorid` (`authorid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_attachpaymentlog` */

/*Table structure for table `cdb_attachtypes` */

DROP TABLE IF EXISTS `cdb_attachtypes`;

CREATE TABLE `cdb_attachtypes` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `extension` char(12) NOT NULL default '',
  `maxsize` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_attachtypes` */

/*Table structure for table `cdb_banned` */

DROP TABLE IF EXISTS `cdb_banned`;

CREATE TABLE `cdb_banned` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `ip1` smallint(3) NOT NULL default '0',
  `ip2` smallint(3) NOT NULL default '0',
  `ip3` smallint(3) NOT NULL default '0',
  `ip4` smallint(3) NOT NULL default '0',
  `admin` varchar(15) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `expiration` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_banned` */

/*Table structure for table `cdb_bbcodes` */

DROP TABLE IF EXISTS `cdb_bbcodes`;

CREATE TABLE `cdb_bbcodes` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `available` tinyint(1) NOT NULL default '0',
  `type` tinyint(1) unsigned NOT NULL default '0',
  `tag` varchar(100) NOT NULL default '',
  `icon` varchar(255) NOT NULL,
  `replacement` text NOT NULL,
  `example` varchar(255) NOT NULL default '',
  `explanation` text NOT NULL,
  `params` tinyint(1) unsigned NOT NULL default '1',
  `prompt` text NOT NULL,
  `nest` tinyint(3) unsigned NOT NULL default '1',
  `displayorder` tinyint(3) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_bbcodes` */

insert  into `cdb_bbcodes`(`id`,`available`,`type`,`tag`,`icon`,`replacement`,`example`,`explanation`,`params`,`prompt`,`nest`,`displayorder`) values (1,2,1,'b i u','popup_simple','','','粗体 斜体 下划线',1,'',1,0),(2,1,1,'font','popup_fontname','','','字体',1,'',1,1),(3,2,1,'size','popup_fontsize','','','大小',1,'',1,2),(4,2,1,'color','popup_forecolor','','','颜色',1,'',1,3),(5,2,1,'align','popup_justify','','','对齐',1,'',1,4),(6,2,1,'url','cmd_createlink','','','链接',1,'',1,5),(7,1,1,'email','cmd_email','','','Email',1,'',1,6),(8,2,1,'img','cmd_insertimage','','','图片',1,'',1,7),(9,2,1,'media','popup_media','','','多媒体',1,'',1,8),(10,2,1,'quote','cmd_quote','','','引用',1,'',1,9),(11,2,1,'code','cmd_code','','','代码',1,'',1,10),(12,2,1,'list','popup_list','','','列表',1,'',1,11),(13,2,1,'indent outdent','popup_dent','','','缩进',1,'',1,12),(14,1,1,'float','popup_float','','','浮动',1,'',1,13),(15,2,1,'table','cmd_table','','','表格',1,'',1,14),(16,1,1,'free','cmd_free','','','免费信息',1,'',1,15),(17,2,1,'hide','cmd_hide','','','隐藏内容',1,'',1,16),(18,2,1,'smilies','popup_smilies','','','表情',1,'',1,17),(19,2,1,'tools','popup_tools','','','工具',1,'',1,99),(20,0,0,'fly','bb_fly.gif','<marquee width=\"90%\" behavior=\"alternate\" scrollamount=\"3\">{1}</marquee>','[fly]This is sample text[/fly]','使内容横向滚动，这个效果类似 HTML 的 marquee 标签，注意：这个效果只在 Internet Explorer 浏览器下有效。',1,'请输入滚动显示的文字:',1,19),(21,0,0,'flash','bb_flash.gif','<object classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" codebase=\"http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0\" width=\"550\" height=\"400\"><param name=\"allowScriptAccess\" value=\"sameDomain\"><param name=\"movie\" value=\"{1}\"><param name=\"quality\" value=\"high\"><param name=\"bgcolor\" value=\"#ffffff\"><embed src=\"{1}\" quality=\"high\" bgcolor=\"#ffffff\" width=\"550\" height=\"400\" allowScriptAccess=\"sameDomain\" type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" wmode=\"transparent\" /></object>','Flash Movie','嵌入 Flash 动画',1,'请输入 Flash 动画的 URL:',1,20),(22,1,0,'qq','bb_qq.gif','<a href=\"http://wpa.qq.com/msgrd?V=1&Uin={1}&amp;Site=[Discuz!]&amp;Menu=yes\" target=\"_blank\"><img src=\"http://wpa.qq.com/pa?p=1:{1}:1\" border=\"0\"></a>','[qq]688888[/qq]','显示 QQ 在线状态，点这个图标可以和他（她）聊天',1,'请输入显示在线状态 QQ 号码:',1,21),(23,0,0,'sup','bb_sup.gif','<sup>{1}</sup>','X[sup]2[/sup]','上标',1,'请输入上标文字：',1,22),(24,0,0,'sub','bb_sub.gif','<sub>{1}</sub>','X[sub]2[/sub]','下标',1,'请输入下标文字：',1,23);

/*Table structure for table `cdb_caches` */

DROP TABLE IF EXISTS `cdb_caches`;

CREATE TABLE `cdb_caches` (
  `cachename` varchar(32) NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `dateline` int(10) unsigned NOT NULL,
  `expiration` int(10) unsigned NOT NULL,
  `data` mediumtext NOT NULL,
  PRIMARY KEY  (`cachename`),
  KEY `expiration` (`type`,`expiration`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_caches` */

insert  into `cdb_caches`(`cachename`,`type`,`dateline`,`expiration`,`data`) values ('settings',1,1256533861,0,'$_DCACHE[\'settings\'] = array (\n  \'accessemail\' => \'\',\n  \'activitytype\' => \'朋友聚会\r\n出外郊游\r\n自驾出行\r\n公益活动\r\n线上活动\',\n  \'adminipaccess\' => \'\',\n  \'admode\' => \'1\',\n  \'allowfloatwin\' => \'1\',\n  \'archiverstatus\' => \'1\',\n  \'attachbanperiods\' => \'\',\n  \'attachdir\' => \'/var/www/uc/bbs/./attachments\',\n  \'attachexpire\' => \'\',\n  \'attachimgpost\' => \'1\',\n  \'attachrefcheck\' => \'0\',\n  \'attachsave\' => \'3\',\n  \'attachurl\' => \'attachments\',\n  \'authkey\' => \'1ccdb57zHMiu5qyR\',\n  \'authoronleft\' => \'0\',\n  \'avatarmethod\' => \'0\',\n  \'baidusitemap\' => \'1\',\n  \'baidusitemap_life\' => \'12\',\n  \'bannedmessages\' => \'1\',\n  \'bbclosed\' => \'\',\n  \'bbname\' => \'Discuz! Board\',\n  \'bdaystatus\' => \'0\',\n  \'boardlicensed\' => \'0\',\n  \'cacheindexlife\' => \'0\',\n  \'cachethreaddir\' => \'forumdata/threadcaches\',\n  \'cachethreadlife\' => \'0\',\n  \'censoremail\' => \'\',\n  \'censoruser\' => \'\',\n  \'creditnotice\' => \'1\',\n  \'creditsformula\' => \'$member[\\\'extcredits1\\\']\',\n  \'creditsformulaexp\' => \'\',\n  \'creditspolicy\' => \n  array (\n    \'post\' => \n    array (\n    ),\n    \'reply\' => \n    array (\n    ),\n    \'digest\' => \n    array (\n      1 => 10,\n    ),\n    \'postattach\' => \n    array (\n    ),\n    \'getattach\' => \n    array (\n    ),\n    \'sendpm\' => \n    array (\n    ),\n    \'search\' => \n    array (\n    ),\n    \'promotion_visit\' => \n    array (\n    ),\n    \'promotion_register\' => \n    array (\n    ),\n    \'tradefinished\' => \n    array (\n    ),\n    \'votepoll\' => \n    array (\n    ),\n    \'lowerlimit\' => \n    array (\n    ),\n  ),\n  \'creditstax\' => \'0.2\',\n  \'creditstrans\' => \'2\',\n  \'dateconvert\' => \'1\',\n  \'dateformat\' => \'Y-n-j\',\n  \'debug\' => \'1\',\n  \'delayviewcount\' => \'0\',\n  \'deletereason\' => \'\',\n  \'doublee\' => \'1\',\n  \'dupkarmarate\' => \'0\',\n  \'ec_account\' => \'\',\n  \'ec_credit\' => \n  array (\n    \'maxcreditspermonth\' => 6,\n    \'rank\' => \n    array (\n      1 => 4,\n      2 => 11,\n      3 => 41,\n      4 => 91,\n      5 => 151,\n      6 => 251,\n      7 => 501,\n      8 => 1001,\n      9 => 2001,\n      10 => 5001,\n      11 => 10001,\n      12 => 20001,\n      13 => 50001,\n      14 => 100001,\n      15 => 200001,\n    ),\n  ),\n  \'ec_maxcredits\' => \'1000\',\n  \'ec_maxcreditspermonth\' => \'0\',\n  \'ec_mincredits\' => \'0\',\n  \'ec_ratio\' => \'0\',\n  \'editedby\' => \'1\',\n  \'editoroptions\' => \'1\',\n  \'edittimelimit\' => \'\',\n  \'exchangemincredits\' => \'100\',\n  \'extcredits\' => \n  array (\n    1 => \n    array (\n      \'title\' => \'威望\',\n      \'showinthread\' => \'\',\n      \'img\' => \'\',\n    ),\n    2 => \n    array (\n      \'title\' => \'金钱\',\n      \'showinthread\' => \'\',\n      \'img\' => \'\',\n    ),\n  ),\n  \'fastpost\' => \'1\',\n  \'floodctrl\' => \'15\',\n  \'forumjump\' => \'0\',\n  \'forumlinkstatus\' => \'1\',\n  \'frameon\' => \'0\',\n  \'framewidth\' => \'180\',\n  \'ftp\' => \n  array (\n    \'on\' => \'0\',\n    \'ssl\' => \'0\',\n    \'host\' => \'\',\n    \'port\' => \'21\',\n    \'username\' => \'\',\n    \'password\' => \'\',\n    \'attachdir\' => \'.\',\n    \'attachurl\' => \'\',\n    \'hideurl\' => \'0\',\n    \'timeout\' => \'0\',\n    \'connid\' => 0,\n  ),\n  \'globalstick\' => \'1\',\n  \'google\' => \'1\',\n  \'gzipcompress\' => \'0\',\n  \'hideprivate\' => \'1\',\n  \'historyposts\' => \'1	1\',\n  \'hottopic\' => \'10\',\n  \'icp\' => \'\',\n  \'imagelib\' => \'0\',\n  \'indexname\' => \'index.php\',\n  \'infosidestatus\' => false,\n  \'initcredits\' => \'0,0,0,0,0,0,0,0,0\',\n  \'insenz\' => \n  array (\n  ),\n  \'ipaccess\' => \'\',\n  \'ipregctrl\' => \'\',\n  \'jscachelife\' => \'1800\',\n  \'jsdateformat\' => \'\',\n  \'jsrefdomains\' => \'\',\n  \'jsstatus\' => \'0\',\n  \'karmaratelimit\' => \'0\',\n  \'loadctrl\' => \'0\',\n  \'losslessdel\' => \'365\',\n  \'magicdiscount\' => \'85\',\n  \'magicmarket\' => \'1\',\n  \'magicstatus\' => \'1\',\n  \'mail\' => \'a:10:{s:8:\"mailsend\";s:1:\"1\";s:6:\"server\";s:13:\"smtp.21cn.com\";s:4:\"port\";s:2:\"25\";s:4:\"auth\";s:1:\"1\";s:4:\"from\";s:26:\"Discuz <username@21cn.com>\";s:13:\"auth_username\";s:17:\"username@21cn.com\";s:13:\"auth_password\";s:8:\"password\";s:13:\"maildelimiter\";s:1:\"0\";s:12:\"mailusername\";s:1:\"1\";s:15:\"sendmail_silent\";s:1:\"1\";}\',\n  \'maxavatarpixel\' => \'120\',\n  \'maxavatarsize\' => \'20000\',\n  \'maxbdays\' => \'0\',\n  \'maxchargespan\' => \'0\',\n  \'maxfavorites\' => \'100\',\n  \'maxincperthread\' => \'0\',\n  \'maxmagicprice\' => \'50\',\n  \'maxmodworksmonths\' => \'3\',\n  \'maxonlinelist\' => \'0\',\n  \'maxpolloptions\' => \'10\',\n  \'maxpostsize\' => \'10000\',\n  \'maxsearchresults\' => \'500\',\n  \'maxsigrows\' => \'100\',\n  \'maxsmilies\' => \'10\',\n  \'maxspm\' => \'0\',\n  \'maxsubscriptions\' => \'100\',\n  \'membermaxpages\' => \'100\',\n  \'memberperpage\' => \'25\',\n  \'memliststatus\' => \'1\',\n  \'minpostsize\' => \'10\',\n  \'moddisplay\' => \'flat\',\n  \'modratelimit\' => \'0\',\n  \'modworkstatus\' => \'0\',\n  \'msgforward\' => \'a:3:{s:11:\"refreshtime\";i:3;s:5:\"quick\";i:1;s:8:\"messages\";a:13:{i:0;s:19:\"thread_poll_succeed\";i:1;s:19:\"thread_rate_succeed\";i:2;s:23:\"usergroups_join_succeed\";i:3;s:23:\"usergroups_exit_succeed\";i:4;s:25:\"usergroups_update_succeed\";i:5;s:20:\"buddy_update_succeed\";i:6;s:17:\"post_edit_succeed\";i:7;s:18:\"post_reply_succeed\";i:8;s:24:\"post_edit_delete_succeed\";i:9;s:22:\"post_newthread_succeed\";i:10;s:13:\"admin_succeed\";i:11;s:17:\"pm_delete_succeed\";i:12;s:15:\"search_redirect\";}}\',\n  \'msn\' => \n  array (\n    \'on\' => 0,\n    \'domain\' => \'discuz.org\',\n  ),\n  \'myrecorddays\' => \'30\',\n  \'newbiespan\' => \'0\',\n  \'newbietask\' => \'\',\n  \'nocacheheaders\' => \'0\',\n  \'oltimespan\' => \'10\',\n  \'onlinehold\' => 900,\n  \'onlinerecord\' => \'1	1040034649\',\n  \'outextcredits\' => \n  array (\n    \'|\' => \n    array (\n      \'title\' => NULL,\n      \'unit\' => NULL,\n      \'ratiosrc\' => \n      array (\n        \'\' => NULL,\n      ),\n      \'ratiodesc\' => \n      array (\n        \'\' => NULL,\n      ),\n      \'creditsrc\' => \n      array (\n        \'\' => NULL,\n      ),\n    ),\n  ),\n  \'postbanperiods\' => \'\',\n  \'postmodperiods\' => \'\',\n  \'postperpage\' => \'10\',\n  \'pvfrequence\' => \'60\',\n  \'pwdsafety\' => \'\',\n  \'qihoo\' => \n  array (\n  ),\n  \'ratelogrecord\' => \'5\',\n  \'regctrl\' => \'0\',\n  \'regfloodctrl\' => \'0\',\n  \'reglinkname\' => \'注册\',\n  \'regname\' => \'register.php\',\n  \'regstatus\' => \'1\',\n  \'regverify\' => \'0\',\n  \'relatedtag\' => false,\n  \'reportpost\' => \'1\',\n  \'rewritecompatible\' => \'\',\n  \'rewritestatus\' => \'0\',\n  \'rssstatus\' => \'1\',\n  \'rssttl\' => \'60\',\n  \'runwizard\' => \'1\',\n  \'searchbanperiods\' => \'\',\n  \'searchctrl\' => \'30\',\n  \'seccodedata\' => \n  array (\n    \'minposts\' => \'\',\n    \'loginfailedcount\' => 0,\n    \'width\' => 150,\n    \'height\' => 60,\n    \'type\' => \'0\',\n    \'background\' => \'1\',\n    \'adulterate\' => \'1\',\n    \'ttf\' => \'0\',\n    \'angle\' => \'0\',\n    \'color\' => \'1\',\n    \'size\' => \'0\',\n    \'shadow\' => \'1\',\n    \'animator\' => \'0\',\n  ),\n  \'seccodestatus\' => \'0\',\n  \'seclevel\' => \'1\',\n  \'secqaa\' => \n  array (\n    \'status\' => \n    array (\n      1 => \'0\',\n      2 => \'0\',\n      3 => \'0\',\n    ),\n  ),\n  \'seodescription\' => \'\',\n  \'seohead\' => \'\',\n  \'seokeywords\' => \'\',\n  \'seotitle\' => \'\',\n  \'showemail\' => \'\',\n  \'showimages\' => \'1\',\n  \'showsettings\' => \'7\',\n  \'sigviewcond\' => \'0\',\n  \'sitemessage\' => \n  array (\n    \'time\' => 0,\n    \'register\' => \'\',\n    \'login\' => \'\',\n    \'newthread\' => \'\',\n    \'reply\' => \'\',\n  ),\n  \'sitename\' => \'Comsenz Inc.\',\n  \'siteurl\' => \'http://www.comsenz.com/\',\n  \'smcols\' => \'8\',\n  \'smrows\' => \'5\',\n  \'smthumb\' => \'20\',\n  \'spacedata\' => \n  array (\n    \'cachelife\' => \'900\',\n    \'limitmythreads\' => \'5\',\n    \'limitmyreplies\' => \'5\',\n    \'limitmyrewards\' => \'5\',\n    \'limitmytrades\' => \'5\',\n    \'limitmyvideos\' => \'0\',\n    \'limitmyblogs\' => \'8\',\n    \'limitmyfriends\' => \'0\',\n    \'limitmyfavforums\' => \'5\',\n    \'limitmyfavthreads\' => \'0\',\n    \'textlength\' => \'300\',\n  ),\n  \'spacestatus\' => \'1\',\n  \'starthreshold\' => \'2\',\n  \'statcode\' => \'\',\n  \'statscachelife\' => \'180\',\n  \'statstatus\' => \'\',\n  \'styleid\' => \'1\',\n  \'stylejump\' => \'1\',\n  \'subforumsindex\' => \'\',\n  \'swfupload\' => \'1\',\n  \'tagstatus\' => \'1\',\n  \'taskon\' => \'0\',\n  \'threadmaxpages\' => \'1000\',\n  \'threadsticky\' => \n  array (\n    0 => \'全局置顶\',\n    1 => \'分类置顶\',\n    2 => \'本版置顶\',\n  ),\n  \'thumbheight\' => \'300\',\n  \'thumbquality\' => \'100\',\n  \'thumbstatus\' => \'0\',\n  \'thumbwidth\' => \'400\',\n  \'timeformat\' => \'H:i\',\n  \'timeoffset\' => \'8\',\n  \'topicperpage\' => \'20\',\n  \'tradetypes\' => \n  array (\n  ),\n  \'transfermincredits\' => \'1000\',\n  \'transsidstatus\' => \'0\',\n  \'uc\' => \n  array (\n    \'addfeed\' => 1,\n  ),\n  \'ucactivation\' => \'1\',\n  \'upgradeurl\' => \'http://localhost/develop/dzhead/develop/upgrade.php\',\n  \'userdateformat\' => \n  array (\n    0 => \'Y-n-j\',\n    1 => \'Y/n/j\',\n    2 => \'j-n-Y\',\n    3 => \'j/n/Y\',\n  ),\n  \'userstatusby\' => \'1\',\n  \'viewthreadtags\' => \'100\',\n  \'visitbanperiods\' => \'\',\n  \'visitedforums\' => \'10\',\n  \'vtonlinestatus\' => \'1\',\n  \'wapcharset\' => \'2\',\n  \'wapdateformat\' => \'n/j\',\n  \'wapmps\' => \'500\',\n  \'wapppp\' => \'5\',\n  \'wapregister\' => \'0\',\n  \'wapstatus\' => \'0\',\n  \'waptpp\' => \'10\',\n  \'warningexpiration\' => \'3\',\n  \'warninglimit\' => \'3\',\n  \'watermarkminheight\' => \'0\',\n  \'watermarkminwidth\' => \'0\',\n  \'watermarkquality\' => \'80\',\n  \'watermarkstatus\' => \'0\',\n  \'watermarktext\' => \n  array (\n  ),\n  \'watermarktrans\' => \'65\',\n  \'watermarktype\' => \'0\',\n  \'welcomemsgtitle\' => \'{username}，您好，感谢您的注册，请阅读以下内容。\',\n  \'whosonlinestatus\' => \'1\',\n  \'whosonline_contract\' => \'0\',\n  \'zoomstatus\' => \'1\',\n  \'tasktypes\' => \'a:3:{s:9:\"promotion\";a:2:{s:4:\"name\";s:18:\"论坛推广任务\";s:7:\"version\";s:3:\"1.0\";}s:4:\"gift\";a:2:{s:4:\"name\";s:15:\"红包类任务\";s:7:\"version\";s:3:\"1.0\";}s:6:\"avatar\";a:2:{s:4:\"name\";s:15:\"头像类任务\";s:7:\"version\";s:3:\"1.0\";}}\',\n  \'version\' => \'7.0.0\',\n  \'totalmembers\' => \'1\',\n  \'lastmember\' => \'admin\',\n  \'cachethreadon\' => 0,\n  \'cronnextrun\' => \'1256537461\',\n  \'styles\' => \n  array (\n    1 => \'默认风格\',\n  ),\n  \'stylejumpstatus\' => false,\n  \'globaladvs\' => \n  array (\n  ),\n  \'redirectadvs\' => \n  array (\n  ),\n  \'invitecredit\' => \'\',\n  \'vsiteurl\' => \'\',\n  \'vkey\' => NULL,\n  \'vsiteid\' => NULL,\n  \'videotype\' => \n  array (\n    0 => \'新闻	军事	音乐	影视	动漫\',\n  ),\n  \'videoopen\' => 0,\n  \'creditnames\' => \'1|威望|,2|金钱|\',\n  \'creditstransextra\' => \n  array (\n    1 => \'2\',\n    2 => \'2\',\n    3 => \'2\',\n    4 => \'2\',\n  ),\n  \'exchangestatus\' => false,\n  \'transferstatus\' => true,\n  \'pluginlinks\' => \n  array (\n  ),\n  \'plugins\' => \n  array (\n  ),\n  \'tradeopen\' => 1,\n  \'hooks\' => \n  array (\n  ),\n  \'navmns\' => \n  array (\n    0 => \'index\',\n    1 => \'index\',\n    2 => \'search\',\n    3 => \'faq\',\n  ),\n  \'subnavs\' => \n  array (\n  ),\n  \'navs\' => \n  array (\n    1 => \n    array (\n      \'nav\' => \'<li class=\"menu_1\"><a href=\"index.php\" hidefocus=\"true\" id=\"mn_index\">论坛</a></li>\',\n      \'level\' => \'0\',\n    ),\n    2 => \n    array (\n      \'nav\' => \'<li class=\"menu_2\"><a href=\"search.php\" hidefocus=\"true\" id=\"mn_search\">搜索</a></li>\',\n      \'level\' => \'0\',\n    ),\n    3 => \n    array (\n      \'nav\' => \'\',\n      \'level\' => \'0\',\n    ),\n    4 => \n    array (\n      \'nav\' => \'<li class=\"menu_4\"><a href=\"faq.php\" hidefocus=\"true\" id=\"mn_faq\">帮助</a></li>\',\n      \'level\' => \'0\',\n    ),\n    5 => \n    array (\n      \'nav\' => \'<li class=\"menu_5\"><a href=\"misc.php?action=nav\" hidefocus=\"true\" onclick=\"floatwin(\\\'open_nav\\\', this.href, 600, 410);return false;\">导航</a></li>\',\n      \'level\' => \'0\',\n    ),\n  ),\n  \'allowsynlogin\' => 1,\n  \'ucappopen\' => \n  array (\n    \'UCHOME\' => 1,\n  ),\n  \'ucapp\' => \n  array (\n    1 => \n    array (\n      \'viewprourl\' => \'http://192.168.115.2/uc/home\',\n    ),\n    2 => \n    array (\n      \'viewprourl\' => \'http://192.168.115.2/uc/bbs\',\n    ),\n  ),\n  \'uchomeurl\' => \'http://192.168.115.2/uc/home\',\n  \'homeshow\' => \'0\',\n  \'medalstatus\' => 0,\n  \'dlang\' => \n  array (\n    \'nextpage\' => \'下一页\',\n    \'date\' => \n    array (\n      0 => \'前\',\n      1 => \'天\',\n      2 => \'昨天\',\n      3 => \'前天\',\n      4 => \'小时\',\n      5 => \'半\',\n      6 => \'分钟\',\n      7 => \'秒\',\n      8 => \'刚才\',\n    ),\n  ),\n);\n\n'),('forums',1,1256533861,0,'$_DCACHE[\'forums\'] = array (\n  1 => \n  array (\n    \'fid\' => \'1\',\n    \'type\' => \'group\',\n    \'name\' => \'Discuz!\',\n    \'fup\' => \'0\',\n    \'viewperm\' => \'\',\n    \'orderby\' => \'lastpost\',\n    \'ascdesc\' => \'DESC\',\n  ),\n  2 => \n  array (\n    \'fid\' => \'2\',\n    \'type\' => \'forum\',\n    \'name\' => \'默认版块\',\n    \'fup\' => \'1\',\n    \'viewperm\' => \'\',\n    \'orderby\' => \'lastpost\',\n    \'ascdesc\' => \'DESC\',\n    \'users\' => NULL,\n  ),\n);\n\n'),('icons',1,1256533861,0,'$_DCACHE[\'icons\'] = array (\n  65 => \'icon1.gif\',\n  66 => \'icon2.gif\',\n  67 => \'icon3.gif\',\n  68 => \'icon4.gif\',\n  69 => \'icon5.gif\',\n  70 => \'icon6.gif\',\n  71 => \'icon7.gif\',\n  72 => \'icon8.gif\',\n  73 => \'icon9.gif\',\n  74 => \'icon10.gif\',\n  75 => \'icon11.gif\',\n  76 => \'icon12.gif\',\n  77 => \'icon13.gif\',\n  78 => \'icon14.gif\',\n  79 => \'icon15.gif\',\n  80 => \'icon16.gif\',\n);\n\n'),('ranks',1,1256533861,0,'$_DCACHE[\'ranks\'] = array (\n);\n\n'),('usergroups',1,1256533861,0,'$_DCACHE[\'usergroups\'] = array (\n  1 => \n  array (\n    \'type\' => \'system\',\n    \'grouptitle\' => \'管理员\',\n    \'stars\' => \'9\',\n    \'groupavatar\' => \'\',\n    \'readaccess\' => \'200\',\n    \'allowcusbbcode\' => \'1\',\n    \'userstatusby\' => 1,\n  ),\n  9 => \n  array (\n    \'type\' => \'member\',\n    \'grouptitle\' => \'乞丐\',\n    \'creditshigher\' => \'-9999999\',\n    \'creditslower\' => \'0\',\n    \'stars\' => \'0\',\n    \'groupavatar\' => \'\',\n    \'readaccess\' => \'0\',\n    \'allowcusbbcode\' => \'0\',\n    \'userstatusby\' => 1,\n  ),\n  8 => \n  array (\n    \'type\' => \'system\',\n    \'grouptitle\' => \'等待验证会员\',\n    \'stars\' => \'0\',\n    \'groupavatar\' => \'\',\n    \'readaccess\' => \'0\',\n    \'allowcusbbcode\' => \'0\',\n    \'userstatusby\' => 1,\n  ),\n  7 => \n  array (\n    \'type\' => \'system\',\n    \'grouptitle\' => \'游客\',\n    \'stars\' => \'0\',\n    \'groupavatar\' => \'\',\n    \'readaccess\' => \'1\',\n    \'allowcusbbcode\' => \'0\',\n    \'userstatusby\' => 1,\n  ),\n  6 => \n  array (\n    \'type\' => \'system\',\n    \'grouptitle\' => \'禁止 IP\',\n    \'stars\' => \'0\',\n    \'groupavatar\' => \'\',\n    \'readaccess\' => \'0\',\n    \'allowcusbbcode\' => \'0\',\n    \'userstatusby\' => 1,\n  ),\n  5 => \n  array (\n    \'type\' => \'system\',\n    \'grouptitle\' => \'禁止访问\',\n    \'stars\' => \'0\',\n    \'groupavatar\' => \'\',\n    \'readaccess\' => \'0\',\n    \'allowcusbbcode\' => \'0\',\n    \'userstatusby\' => 1,\n  ),\n  4 => \n  array (\n    \'type\' => \'system\',\n    \'grouptitle\' => \'禁止发言\',\n    \'stars\' => \'0\',\n    \'groupavatar\' => \'\',\n    \'readaccess\' => \'0\',\n    \'allowcusbbcode\' => \'0\',\n    \'userstatusby\' => 1,\n  ),\n  3 => \n  array (\n    \'type\' => \'system\',\n    \'grouptitle\' => \'版主\',\n    \'stars\' => \'7\',\n    \'groupavatar\' => \'\',\n    \'readaccess\' => \'100\',\n    \'allowcusbbcode\' => \'1\',\n    \'userstatusby\' => 1,\n  ),\n  2 => \n  array (\n    \'type\' => \'system\',\n    \'grouptitle\' => \'超级版主\',\n    \'stars\' => \'8\',\n    \'groupavatar\' => \'\',\n    \'readaccess\' => \'150\',\n    \'allowcusbbcode\' => \'1\',\n    \'userstatusby\' => 1,\n  ),\n  10 => \n  array (\n    \'type\' => \'member\',\n    \'grouptitle\' => \'新手上路\',\n    \'creditshigher\' => \'0\',\n    \'creditslower\' => \'50\',\n    \'stars\' => \'1\',\n    \'groupavatar\' => \'\',\n    \'readaccess\' => \'10\',\n    \'allowcusbbcode\' => \'0\',\n    \'userstatusby\' => 1,\n  ),\n  11 => \n  array (\n    \'type\' => \'member\',\n    \'grouptitle\' => \'注册会员\',\n    \'creditshigher\' => \'50\',\n    \'creditslower\' => \'200\',\n    \'stars\' => \'2\',\n    \'groupavatar\' => \'\',\n    \'readaccess\' => \'20\',\n    \'allowcusbbcode\' => \'0\',\n    \'userstatusby\' => 1,\n  ),\n  12 => \n  array (\n    \'type\' => \'member\',\n    \'grouptitle\' => \'中级会员\',\n    \'creditshigher\' => \'200\',\n    \'creditslower\' => \'500\',\n    \'stars\' => \'3\',\n    \'groupavatar\' => \'\',\n    \'readaccess\' => \'30\',\n    \'allowcusbbcode\' => \'1\',\n    \'userstatusby\' => 1,\n  ),\n  13 => \n  array (\n    \'type\' => \'member\',\n    \'grouptitle\' => \'高级会员\',\n    \'creditshigher\' => \'500\',\n    \'creditslower\' => \'1000\',\n    \'stars\' => \'4\',\n    \'groupavatar\' => \'\',\n    \'readaccess\' => \'50\',\n    \'allowcusbbcode\' => \'1\',\n    \'userstatusby\' => 1,\n  ),\n  14 => \n  array (\n    \'type\' => \'member\',\n    \'grouptitle\' => \'金牌会员\',\n    \'creditshigher\' => \'1000\',\n    \'creditslower\' => \'3000\',\n    \'stars\' => \'6\',\n    \'groupavatar\' => \'\',\n    \'readaccess\' => \'70\',\n    \'allowcusbbcode\' => \'1\',\n    \'userstatusby\' => 1,\n  ),\n  15 => \n  array (\n    \'type\' => \'member\',\n    \'grouptitle\' => \'论坛元老\',\n    \'creditshigher\' => \'3000\',\n    \'creditslower\' => \'9999999\',\n    \'stars\' => \'8\',\n    \'groupavatar\' => \'\',\n    \'readaccess\' => \'90\',\n    \'allowcusbbcode\' => \'1\',\n    \'userstatusby\' => 1,\n  ),\n);\n\n'),('request',1,1256533861,0,'$_DCACHE[\'request\'] = array (\n  \'边栏模块_版块树形列表\' => \n  array (\n    \'url\' => \'function=module&module=forumtree.inc.php&settings=N%3B&jscharset=0&cachelife=864000\',\n    \'type\' => \'5\',\n  ),\n  \'边栏模块_版主排行\' => \n  array (\n    \'url\' => \'function=module&module=modlist.inc.php&settings=N%3B&jscharset=0&cachelife=3600\',\n    \'type\' => \'5\',\n  ),\n  \'聚合模块_版块列表\' => \n  array (\n    \'url\' => \'function=module&module=rowcombine.inc.php&settings=a%3A1%3A%7Bs%3A4%3A%22data%22%3Bs%3A84%3A%22%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E7%89%88%E5%9D%97%E6%8E%92%E8%A1%8C%2C%E7%89%88%E5%9D%97%E6%8E%92%E8%A1%8C%0D%0A%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E7%89%88%E5%9D%97%E6%A0%91%E5%BD%A2%E5%88%97%E8%A1%A8%2C%E7%89%88%E5%9D%97%E5%88%97%E8%A1%A8%22%3B%7D&jscharset=0&cachelife=864000&\',\n    \'type\' => \'5\',\n  ),\n  \'边栏模块_版块排行\' => \n  array (\n    \'url\' => \'function=forums&startrow=0&items=0&newwindow=1&orderby=posts&jscharset=0&cachelife=43200&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E7%89%88%E5%9D%97%E6%8E%92%E8%A1%8C%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22textinfolist%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%3Cimg%20style%3D%5C%22vertical-align%3Amiddle%5C%22%20src%3D%5C%22images%2Fdefault%2Ftree_file.gif%5C%22%20%2F%3E%20%7Bforumname%7D%28%7Bposts%7D%29%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\',\n    \'type\' => \'1\',\n  ),\n  \'聚合模块_热门主题\' => \n  array (\n    \'url\' => \'function=module&module=rowcombine.inc.php&settings=a%3A2%3A%7Bs%3A5%3A%22title%22%3Bs%3A12%3A%22%E7%83%AD%E9%97%A8%E4%B8%BB%E9%A2%98%22%3Bs%3A4%3A%22data%22%3Bs%3A112%3A%22%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E7%83%AD%E9%97%A8%E4%B8%BB%E9%A2%98_%E4%BB%8A%E6%97%A5%2C%E6%97%A5%0D%0A%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E7%83%AD%E9%97%A8%E4%B8%BB%E9%A2%98_%E6%9C%AC%E5%91%A8%2C%E5%91%A8%0D%0A%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E7%83%AD%E9%97%A8%E4%B8%BB%E9%A2%98_%E6%9C%AC%E6%9C%88%2C%E6%9C%88%22%3B%7D&jscharset=0&cachelife=1800&\',\n    \'type\' => \'5\',\n  ),\n  \'边栏模块_热门主题_本月\' => \n  array (\n    \'url\' => \'function=threads&sidestatus=0&maxlength=20&fnamelength=0&messagelength=&startrow=0&picpre=images%2Fcommon%2Fslisticon.gif&items=5&tag=&tids=&special=0&rewardstatus=&digest=0&stick=0&recommend=0&newwindow=1&threadtype=0&highlight=0&orderby=hourviews&hours=720&jscharset=0&cachelife=86400&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%AC%E6%9C%88%E7%83%AD%E9%97%A8%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22textinfolist%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%7Bprefix%7D%7Bsubject%7D%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\',\n    \'type\' => \'0\',\n  ),\n  \'聚合模块_会员排行\' => \n  array (\n    \'url\' => \'function=module&module=rowcombine.inc.php&settings=a%3A2%3A%7Bs%3A5%3A%22title%22%3Bs%3A12%3A%22%E4%BC%9A%E5%91%98%E6%8E%92%E8%A1%8C%22%3Bs%3A4%3A%22data%22%3Bs%3A112%3A%22%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E4%BC%9A%E5%91%98%E6%8E%92%E8%A1%8C_%E4%BB%8A%E6%97%A5%2C%E6%97%A5%0D%0A%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E4%BC%9A%E5%91%98%E6%8E%92%E8%A1%8C_%E6%9C%AC%E5%91%A8%2C%E5%91%A8%0D%0A%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E4%BC%9A%E5%91%98%E6%8E%92%E8%A1%8C_%E6%9C%AC%E6%9C%88%2C%E6%9C%88%22%3B%7D&jscharset=0&cachelife=3600&\',\n    \'type\' => \'5\',\n  ),\n  \'边栏模块_推荐主题\' => \n  array (\n    \'url\' => \'function=threads&sidestatus=0&maxlength=20&fnamelength=0&messagelength=&startrow=0&picpre=images%2Fcommon%2Fslisticon.gif&items=5&tag=&tids=&special=0&rewardstatus=&digest=0&stick=0&recommend=1&newwindow=1&threadtype=0&highlight=0&orderby=lastpost&hours=48&jscharset=0&cachelife=3600&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%8E%A8%E8%8D%90%E4%B8%BB%E9%A2%98%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22textinfolist%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%7Bprefix%7D%7Bsubject%7D%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\',\n    \'type\' => \'0\',\n  ),\n  \'边栏模块_最新图片\' => \n  array (\n    \'url\' => \'function=images&sidestatus=0&isimage=1&threadmethod=1&maxwidth=140&maxheight=140&startrow=0&items=5&orderby=dateline&hours=0&digest=0&newwindow=1&jscharset=0&jstemplate=%3Cdiv%20%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%80%E6%96%B0%E5%9B%BE%E7%89%87%3C%2Fh4%3E%0D%0A%3Cscript%20type%3D%5C%22text%2Fjavascript%5C%22%3E%0D%0Avar%20slideSpeed%20%3D%202500%3B%0D%0Avar%20slideImgsize%20%3D%20%5B140%2C140%5D%3B%0D%0Avar%20slideTextBar%20%3D%200%3B%0D%0Avar%20slideBorderColor%20%3D%20%5C%27%23C8DCEC%5C%27%3B%0D%0Avar%20slideBgColor%20%3D%20%5C%27%23FFF%5C%27%3B%0D%0Avar%20slideImgs%20%3D%20new%20Array%28%29%3B%0D%0Avar%20slideImgLinks%20%3D%20new%20Array%28%29%3B%0D%0Avar%20slideImgTexts%20%3D%20new%20Array%28%29%3B%0D%0Avar%20slideSwitchBar%20%3D%201%3B%0D%0Avar%20slideSwitchColor%20%3D%20%5C%27black%5C%27%3B%0D%0Avar%20slideSwitchbgColor%20%3D%20%5C%27white%5C%27%3B%0D%0Avar%20slideSwitchHiColor%20%3D%20%5C%27%23C8DCEC%5C%27%3B%0D%0A%5Bnode%5D%0D%0AslideImgs%5B%7Border%7D%5D%20%3D%20%5C%22%7Bimgfile%7D%5C%22%3B%0D%0AslideImgLinks%5B%7Border%7D%5D%20%3D%20%5C%22%7Blink%7D%5C%22%3B%0D%0AslideImgTexts%5B%7Border%7D%5D%20%3D%20%5C%22%7Bsubject%7D%5C%22%3B%0D%0A%5B%2Fnode%5D%0D%0A%3C%2Fscript%3E%0D%0A%3Cscript%20language%3D%5C%22javascript%5C%22%20type%3D%5C%22text%2Fjavascript%5C%22%20src%3D%5C%22include%2Fjs%2Fslide.js%5C%22%3E%3C%2Fscript%3E%0D%0A%3C%2Fdiv%3E&\',\n    \'type\' => \'4\',\n  ),\n  \'边栏模块_最新主题\' => \n  array (\n    \'url\' => \'function=threads&sidestatus=0&maxlength=20&fnamelength=0&messagelength=&startrow=0&picpre=images%2Fcommon%2Fslisticon.gif&items=5&tag=&tids=&special=0&rewardstatus=&digest=0&stick=0&recommend=0&newwindow=1&threadtype=0&highlight=0&orderby=dateline&hours=0&jscharset=0&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%80%E6%96%B0%E4%B8%BB%E9%A2%98%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22textinfolist%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%7Bprefix%7D%7Bsubject%7D%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\',\n    \'type\' => \'0\',\n  ),\n  \'边栏模块_活跃会员\' => \n  array (\n    \'url\' => \'function=memberrank&startrow=0&items=12&newwindow=1&extcredit=1&orderby=posts&hours=0&jscharset=0&cachelife=43200&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%B4%BB%E8%B7%83%E4%BC%9A%E5%91%98%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22avt_list%20s_clear%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%7Bavatarsmall%7D%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\',\n    \'type\' => \'2\',\n  ),\n  \'边栏模块_热门主题_本版\' => \n  array (\n    \'url\' => \'function=threads&sidestatus=1&maxlength=20&fnamelength=0&messagelength=&startrow=0&picpre=images%2Fcommon%2Fslisticon.gif&items=5&tag=&tids=&special=0&rewardstatus=&digest=0&stick=0&recommend=0&newwindow=1&threadtype=0&highlight=0&orderby=replies&hours=0&jscharset=0&cachelife=1800&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%AC%E7%89%88%E7%83%AD%E9%97%A8%E4%B8%BB%E9%A2%98%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22textinfolist%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%7Bprefix%7D%7Bsubject%7D%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\',\n    \'type\' => \'0\',\n  ),\n  \'边栏模块_热门主题_今日\' => \n  array (\n    \'url\' => \'function=threads&sidestatus=0&maxlength=20&fnamelength=0&messagelength=&startrow=0&picpre=images%2Fcommon%2Fslisticon.gif&items=5&tag=&tids=&special=0&rewardstatus=&digest=0&stick=0&recommend=0&newwindow=1&threadtype=0&highlight=0&orderby=hourviews&hours=24&jscharset=0&cachelife=1800&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E4%BB%8A%E6%97%A5%E7%83%AD%E9%97%A8%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22textinfolist%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%7Bprefix%7D%7Bsubject%7D%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\',\n    \'type\' => \'0\',\n  ),\n  \'边栏模块_最新回复\' => \n  array (\n    \'url\' => \'function=threads&sidestatus=0&maxlength=20&fnamelength=0&messagelength=&startrow=0&picpre=images%2Fcommon%2Fslisticon.gif&items=5&tag=&tids=&special=0&rewardstatus=&digest=0&stick=0&recommend=0&newwindow=1&threadtype=0&highlight=0&orderby=lastpost&hours=0&jscharset=0&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%80%E6%96%B0%E5%9B%9E%E5%A4%8D%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22textinfolist%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%7Bprefix%7D%7Bsubject%7D%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\',\n    \'type\' => \'0\',\n  ),\n  \'边栏模块_最新图片_本版\' => \n  array (\n    \'url\' => \'function=images&sidestatus=1&isimage=1&threadmethod=1&maxwidth=140&maxheight=140&startrow=0&items=5&orderby=dateline&hours=0&digest=0&newwindow=1&jscharset=0&jstemplate=%3Cdiv%20%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%80%E6%96%B0%E5%9B%BE%E7%89%87%3C%2Fh4%3E%0D%0A%3Cscript%20type%3D%5C%22text%2Fjavascript%5C%22%3E%0D%0Avar%20slideSpeed%20%3D%202500%3B%0D%0Avar%20slideImgsize%20%3D%20%5B140%2C140%5D%3B%0D%0Avar%20slideTextBar%20%3D%200%3B%0D%0Avar%20slideBorderColor%20%3D%20%5C%27%23C8DCEC%5C%27%3B%0D%0Avar%20slideBgColor%20%3D%20%5C%27%23FFF%5C%27%3B%0D%0Avar%20slideImgs%20%3D%20new%20Array%28%29%3B%0D%0Avar%20slideImgLinks%20%3D%20new%20Array%28%29%3B%0D%0Avar%20slideImgTexts%20%3D%20new%20Array%28%29%3B%0D%0Avar%20slideSwitchBar%20%3D%201%3B%0D%0Avar%20slideSwitchColor%20%3D%20%5C%27black%5C%27%3B%0D%0Avar%20slideSwitchbgColor%20%3D%20%5C%27white%5C%27%3B%0D%0Avar%20slideSwitchHiColor%20%3D%20%5C%27%23C8DCEC%5C%27%3B%0D%0A%5Bnode%5D%0D%0AslideImgs%5B%7Border%7D%5D%20%3D%20%5C%22%7Bimgfile%7D%5C%22%3B%0D%0AslideImgLinks%5B%7Border%7D%5D%20%3D%20%5C%22%7Blink%7D%5C%22%3B%0D%0AslideImgTexts%5B%7Border%7D%5D%20%3D%20%5C%22%7Bsubject%7D%5C%22%3B%0D%0A%5B%2Fnode%5D%0D%0A%3C%2Fscript%3E%0D%0A%3Cscript%20language%3D%5C%22javascript%5C%22%20type%3D%5C%22text%2Fjavascript%5C%22%20src%3D%5C%22include%2Fjs%2Fslide.js%5C%22%3E%3C%2Fscript%3E%0D%0A%3C%2Fdiv%3E&\',\n    \'type\' => \'4\',\n  ),\n  \'边栏模块_标签\' => \n  array (\n    \'url\' => \'function=module&module=tag.inc.php&settings=a%3A1%3A%7Bs%3A5%3A%22limit%22%3Bs%3A2%3A%2220%22%3B%7D&jscharset=0&cachelife=900&\',\n    \'type\' => \'5\',\n  ),\n  \'边栏模块_会员排行_本月\' => \n  array (\n    \'url\' => \'function=memberrank&startrow=0&items=5&newwindow=1&extcredit=1&orderby=hourposts&hours=720&jscharset=0&cachelife=86400&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%20s_clear%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%AC%E6%9C%88%E6%8E%92%E8%A1%8C%3C%2Fh4%3E%0D%0A%5Bnode%5D%3Cdiv%20style%3D%5C%22clear%3Aboth%5C%22%3E%3Cdiv%20style%3D%5C%22float%3Aleft%3Bmargin%3A%200%2016px%205px%200%5C%22%3E%7Bavatarsmall%7D%3C%2Fdiv%3E%7Bmember%7D%3Cbr%20%2F%3E%E5%8F%91%E5%B8%96%20%7Bvalue%7D%20%E7%AF%87%3C%2Fdiv%3E%5B%2Fnode%5D%0D%0A%3C%2Fdiv%3E&\',\n    \'type\' => \'2\',\n  ),\n  \'边栏模块_会员排行_本周\' => \n  array (\n    \'url\' => \'function=memberrank&startrow=0&items=5&newwindow=1&extcredit=1&orderby=hourposts&hours=168&jscharset=0&cachelife=43200&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%20s_clear%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%AC%E5%91%A8%E6%8E%92%E8%A1%8C%3C%2Fh4%3E%0D%0A%5Bnode%5D%3Cdiv%20style%3D%5C%22clear%3Aboth%5C%22%3E%3Cdiv%20style%3D%5C%22float%3Aleft%3Bmargin%3A%200%2016px%205px%200%5C%22%3E%7Bavatarsmall%7D%3C%2Fdiv%3E%7Bmember%7D%3Cbr%20%2F%3E%E5%8F%91%E5%B8%96%20%7Bvalue%7D%20%E7%AF%87%3C%2Fdiv%3E%5B%2Fnode%5D%0D%0A%3C%2Fdiv%3E&\',\n    \'type\' => \'2\',\n  ),\n  \'边栏方案_主题列表页默认\' => \n  array (\n    \'url\' => \'function=side&jscharset=&jstemplate=%5Bmodule%5D%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E6%88%91%E7%9A%84%E5%8A%A9%E6%89%8B%5B%2Fmodule%5D%3Chr%20class%3D%22shadowline%22%2F%3E%5Bmodule%5D%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E7%83%AD%E9%97%A8%E4%B8%BB%E9%A2%98_%E6%9C%AC%E7%89%88%5B%2Fmodule%5D%3Chr%20class%3D%22shadowline%22%2F%3E%5Bmodule%5D%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E7%89%88%E5%9D%97%E6%8E%92%E8%A1%8C%5B%2Fmodule%5D&\',\n    \'type\' => \'-2\',\n  ),\n  \'边栏方案_首页默认\' => \n  array (\n    \'url\' => \'function=side&jscharset=&jstemplate=%5Bmodule%5D%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E6%88%91%E7%9A%84%E5%8A%A9%E6%89%8B%5B%2Fmodule%5D%3Chr%20class%3D%22shadowline%22%2F%3E%5Bmodule%5D%E8%81%9A%E5%90%88%E6%A8%A1%E5%9D%97_%E6%96%B0%E5%B8%96%5B%2Fmodule%5D%3Chr%20class%3D%22shadowline%22%2F%3E%5Bmodule%5D%E8%81%9A%E5%90%88%E6%A8%A1%E5%9D%97_%E7%83%AD%E9%97%A8%E4%B8%BB%E9%A2%98%5B%2Fmodule%5D%3Chr%20class%3D%22shadowline%22%2F%3E%5Bmodule%5D%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E6%B4%BB%E8%B7%83%E4%BC%9A%E5%91%98%5B%2Fmodule%5D&\',\n    \'type\' => \'-2\',\n  ),\n  \'聚合模块_新帖\' => \n  array (\n    \'url\' => \'function=module&module=rowcombine.inc.php&settings=a%3A2%3A%7Bs%3A5%3A%22title%22%3Bs%3A12%3A%22%E6%9C%80%E6%96%B0%E5%B8%96%E5%AD%90%22%3Bs%3A4%3A%22data%22%3Bs%3A66%3A%22%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E6%9C%80%E6%96%B0%E4%B8%BB%E9%A2%98%2C%E4%B8%BB%E9%A2%98%0D%0A%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E6%9C%80%E6%96%B0%E5%9B%9E%E5%A4%8D%2C%E5%9B%9E%E5%A4%8D%22%3B%7D&jscharset=0&\',\n    \'type\' => \'5\',\n  ),\n  \'边栏模块_热门主题_本周\' => \n  array (\n    \'url\' => \'function=threads&sidestatus=0&maxlength=20&fnamelength=0&messagelength=&startrow=0&picpre=images%2Fcommon%2Fslisticon.gif&items=5&tag=&tids=&special=0&rewardstatus=&digest=0&stick=0&recommend=0&newwindow=1&threadtype=0&highlight=0&orderby=hourviews&hours=168&jscharset=0&cachelife=43200&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%AC%E5%91%A8%E7%83%AD%E9%97%A8%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22textinfolist%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%7Bprefix%7D%7Bsubject%7D%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\',\n    \'type\' => \'0\',\n  ),\n  \'边栏模块_会员排行_今日\' => \n  array (\n    \'url\' => \'function=memberrank&startrow=0&items=5&newwindow=1&extcredit=1&orderby=hourposts&hours=24&jscharset=0&cachelife=3600&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%20s_clear%5C%22%3E%0D%0A%3Ch4%3E%E4%BB%8A%E6%97%A5%E6%8E%92%E8%A1%8C%3C%2Fh4%3E%0D%0A%5Bnode%5D%3Cdiv%20style%3D%5C%22clear%3Aboth%5C%22%3E%3Cdiv%20style%3D%5C%22float%3Aleft%3Bmargin%3A%200%2016px%205px%200%5C%22%3E%7Bavatarsmall%7D%3C%2Fdiv%3E%7Bmember%7D%3Cbr%20%2F%3E%E5%8F%91%E5%B8%96%20%7Bvalue%7D%20%E7%AF%87%3C%2Fdiv%3E%5B%2Fnode%5D%0D%0A%3C%2Fdiv%3E&\',\n    \'type\' => \'2\',\n  ),\n  \'边栏模块_论坛之星\' => \n  array (\n    \'url\' => \'function=memberrank&startrow=0&items=3&newwindow=1&extcredit=1&orderby=hourposts&hours=168&jscharset=0&cachelife=43200&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%20s_clear%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%AC%E5%91%A8%E4%B9%8B%E6%98%9F%3C%2Fh4%3E%0D%0A%5Bnode%5D%0D%0A%5Bshow%3D1%5D%3Cdiv%20style%3D%5C%22clear%3Aboth%5C%22%3E%3Cdiv%20style%3D%5C%22float%3Aleft%3B%20margin-right%3A%2016px%3B%5C%22%3E%7Bavatarsmall%7D%3C%2Fdiv%3E%5B%2Fshow%5D%7Bmember%7D%20%5Bshow%3D1%5D%3Cbr%20%2F%3E%E5%8F%91%E5%B8%96%20%7Bvalue%7D%20%E7%AF%87%3C%2Fdiv%3E%3Cdiv%20style%3D%5C%22clear%3Aboth%3Bmargin-top%3A2px%5C%22%20%2F%3E%3C%2Fdiv%3E%5B%2Fshow%5D%0D%0A%5B%2Fnode%5D%0D%0A%3C%2Fdiv%3E&\',\n    \'type\' => \'2\',\n  ),\n  \'边栏模块_我的助手\' => \n  array (\n    \'url\' => \'function=module&module=assistant.inc.php&settings=N%3B&jscharset=0&cachelife=0\',\n    \'type\' => \'5\',\n  ),\n  \'边栏模块_Google搜索\' => \n  array (\n    \'url\' => \'function=module&module=google.inc.php&settings=a%3A2%3A%7Bs%3A4%3A%22lang%22%3Bs%3A0%3A%22%22%3Bs%3A7%3A%22default%22%3Bs%3A1%3A%221%22%3B%7D&jscharset=0&cachelife=864000&\',\n    \'type\' => \'5\',\n  ),\n  \'UCHome_最新动态\' => \n  array (\n    \'url\' => \'function=module&module=feed.inc.php&settings=a%3A6%3A%7Bs%3A5%3A%22title%22%3Bs%3A12%3A%22%E6%9C%80%E6%96%B0%E5%8A%A8%E6%80%81%22%3Bs%3A4%3A%22uids%22%3Bs%3A0%3A%22%22%3Bs%3A6%3A%22friend%22%3Bs%3A1%3A%220%22%3Bs%3A5%3A%22start%22%3Bs%3A1%3A%220%22%3Bs%3A5%3A%22limit%22%3Bs%3A2%3A%2210%22%3Bs%3A8%3A%22template%22%3Bs%3A54%3A%22%3Cdiv%20style%3D%5C%22padding-left%3A2px%5C%22%3E%7Btitle_template%7D%3C%2Fdiv%3E%22%3B%7D&jscharset=0&cachelife=0&\',\n    \'type\' => \'5\',\n  ),\n  \'UCHome_最新更新空间\' => \n  array (\n    \'url\' => \'function=module&module=space.inc.php&settings=a%3A17%3A%7Bs%3A5%3A%22title%22%3Bs%3A18%3A%22%E6%9C%80%E6%96%B0%E6%9B%B4%E6%96%B0%E7%A9%BA%E9%97%B4%22%3Bs%3A3%3A%22uid%22%3Bs%3A0%3A%22%22%3Bs%3A14%3A%22startfriendnum%22%3Bs%3A0%3A%22%22%3Bs%3A12%3A%22endfriendnum%22%3Bs%3A0%3A%22%22%3Bs%3A12%3A%22startviewnum%22%3Bs%3A0%3A%22%22%3Bs%3A10%3A%22endviewnum%22%3Bs%3A0%3A%22%22%3Bs%3A11%3A%22startcredit%22%3Bs%3A0%3A%22%22%3Bs%3A9%3A%22endcredit%22%3Bs%3A0%3A%22%22%3Bs%3A6%3A%22avatar%22%3Bs%3A2%3A%22-1%22%3Bs%3A10%3A%22namestatus%22%3Bs%3A2%3A%22-1%22%3Bs%3A8%3A%22dateline%22%3Bs%3A1%3A%220%22%3Bs%3A10%3A%22updatetime%22%3Bs%3A1%3A%220%22%3Bs%3A5%3A%22order%22%3Bs%3A10%3A%22updatetime%22%3Bs%3A2%3A%22sc%22%3Bs%3A4%3A%22DESC%22%3Bs%3A5%3A%22start%22%3Bs%3A1%3A%220%22%3Bs%3A5%3A%22limit%22%3Bs%3A2%3A%2210%22%3Bs%3A8%3A%22template%22%3Bs%3A267%3A%22%3Ctable%3E%0D%0A%3Ctr%3E%0D%0A%3Ctd%20width%3D%5C%2250%5C%22%20rowspan%3D%5C%222%5C%22%3E%3Ca%20href%3D%5C%22%7Buserlink%7D%5C%22%20target%3D%5C%22_blank%5C%22%3E%3Cimg%20src%3D%5C%22%7Bphoto%7D%5C%22%20%2F%3E%3C%2Fa%3E%3C%2Ftd%3E%0D%0A%3Ctd%3E%3Ca%20href%3D%5C%22%7Buserlink%7D%5C%22%20%20target%3D%5C%22_blank%5C%22%20style%3D%5C%22text-decoration%3Anone%3B%5C%22%3E%7Busername%7D%3C%2Fa%3E%3C%2Ftd%3E%0D%0A%3C%2Ftr%3E%0D%0A%3Ctr%3E%3Ctd%3E%7Bupdatetime%7D%3C%2Ftd%3E%3C%2Ftr%3E%0D%0A%3C%2Ftable%3E%22%3B%7D&jscharset=0&cachelife=0&\',\n    \'type\' => \'5\',\n  ),\n  \'UCHome_最新记录\' => \n  array (\n    \'url\' => \'function=module&module=doing.inc.php&settings=a%3A6%3A%7Bs%3A5%3A%22title%22%3Bs%3A12%3A%22%E6%9C%80%E6%96%B0%E8%AE%B0%E5%BD%95%22%3Bs%3A3%3A%22uid%22%3Bs%3A0%3A%22%22%3Bs%3A4%3A%22mood%22%3Bs%3A1%3A%220%22%3Bs%3A5%3A%22start%22%3Bs%3A1%3A%220%22%3Bs%3A5%3A%22limit%22%3Bs%3A2%3A%2210%22%3Bs%3A8%3A%22template%22%3Bs%3A361%3A%22%0D%0A%3Cdiv%20style%3D%5C%22padding%3A0%200%205px%200%3B%5C%22%3E%0D%0A%3Ca%20href%3D%5C%22%7Buserlink%7D%5C%22%20target%3D%5C%22_blank%5C%22%3E%3Cimg%20src%3D%5C%22%7Bphoto%7D%5C%22%20width%3D%5C%2218%5C%22%20height%3D%5C%2218%5C%22%20align%3D%5C%22absmiddle%5C%22%3E%3C%2Fa%3E%20%3Ca%20href%3D%5C%22%7Buserlink%7D%5C%22%20%20target%3D%5C%22_blank%5C%22%3E%7Busername%7D%3C%2Fa%3E%EF%BC%9A%0D%0A%3C%2Fdiv%3E%0D%0A%3Cdiv%20style%3D%5C%22padding%3A0%200%205px%2020px%3B%5C%22%3E%0D%0A%3Ca%20href%3D%5C%22%7Blink%7D%5C%22%20style%3D%5C%22color%3A%23333%3Btext-decoration%3Anone%3B%5C%22%20target%3D%5C%22_blank%5C%22%3E%7Bmessage%7D%3C%2Fa%3E%0D%0A%3C%2Fdiv%3E%22%3B%7D&jscharset=0&cachelife=0&\',\n    \'type\' => \'5\',\n  ),\n  \'UCHome_竞价排名\' => \n  array (\n    \'url\' => \'function=module&module=html.inc.php&settings=a%3A3%3A%7Bs%3A4%3A%22type%22%3Bs%3A1%3A%220%22%3Bs%3A4%3A%22code%22%3Bs%3A27%3A%22%3Cdiv%20id%3D%5C%22sidefeed%5C%22%3E%3C%2Fdiv%3E%22%3Bs%3A4%3A%22side%22%3Bs%3A1%3A%220%22%3B%7D&jscharset=0&cachelife=864000&\',\n    \'type\' => \'5\',\n  ),\n);\n\n'),('medals',1,1256533861,0,'$_DCACHE[\'medals\'] = array (\n);\n\n'),('magics',1,1256533861,0,'$_DCACHE[\'magics\'] = array (\n  1 => \n  array (\n    \'identifier\' => \'CCK\',\n    \'available\' => \'1\',\n    \'name\' => \'变色卡\',\n    \'description\' => \'可以变换主题的颜色,并保存24小时\',\n    \'weight\' => \'20\',\n    \'price\' => \'10\',\n  ),\n  2 => \n  array (\n    \'identifier\' => \'MOK\',\n    \'available\' => \'1\',\n    \'name\' => \'金钱卡\',\n    \'description\' => \'可以随机获得一些金币\',\n    \'weight\' => \'30\',\n    \'price\' => \'10\',\n  ),\n  3 => \n  array (\n    \'identifier\' => \'SEK\',\n    \'available\' => \'1\',\n    \'name\' => \'IP卡\',\n    \'description\' => \'可以查看帖子作者的IP\',\n    \'weight\' => \'30\',\n    \'price\' => \'15\',\n  ),\n  4 => \n  array (\n    \'identifier\' => \'UPK\',\n    \'available\' => \'1\',\n    \'name\' => \'提升卡\',\n    \'description\' => \'可以提升某个主题\',\n    \'weight\' => \'30\',\n    \'price\' => \'10\',\n  ),\n  5 => \n  array (\n    \'identifier\' => \'TOK\',\n    \'available\' => \'1\',\n    \'name\' => \'置顶卡\',\n    \'description\' => \'可以将主题置顶24小时\',\n    \'weight\' => \'40\',\n    \'price\' => \'20\',\n  ),\n  6 => \n  array (\n    \'identifier\' => \'REK\',\n    \'available\' => \'1\',\n    \'name\' => \'悔悟卡\',\n    \'description\' => \'可以删除自己的帖子\',\n    \'weight\' => \'30\',\n    \'price\' => \'10\',\n  ),\n  7 => \n  array (\n    \'identifier\' => \'RTK\',\n    \'available\' => \'1\',\n    \'name\' => \'狗仔卡\',\n    \'description\' => \'查看某个用户是否在线\',\n    \'weight\' => \'30\',\n    \'price\' => \'15\',\n  ),\n  8 => \n  array (\n    \'identifier\' => \'CLK\',\n    \'available\' => \'1\',\n    \'name\' => \'沉默卡\',\n    \'description\' => \'24小时内不能回复\',\n    \'weight\' => \'30\',\n    \'price\' => \'15\',\n  ),\n  9 => \n  array (\n    \'identifier\' => \'OPK\',\n    \'available\' => \'1\',\n    \'name\' => \'喧嚣卡\',\n    \'description\' => \'使贴子可以回复\',\n    \'weight\' => \'30\',\n    \'price\' => \'15\',\n  ),\n  10 => \n  array (\n    \'identifier\' => \'YSK\',\n    \'available\' => \'1\',\n    \'name\' => \'隐身卡\',\n    \'description\' => \'可以将自己的帖子匿名\',\n    \'weight\' => \'30\',\n    \'price\' => \'20\',\n  ),\n  11 => \n  array (\n    \'identifier\' => \'CBK\',\n    \'available\' => \'1\',\n    \'name\' => \'恢复卡\',\n    \'description\' => \'将匿名恢复为正常显示的用户名,匿名终结者\',\n    \'weight\' => \'20\',\n    \'price\' => \'15\',\n  ),\n  12 => \n  array (\n    \'identifier\' => \'MVK\',\n    \'available\' => \'1\',\n    \'name\' => \'移动卡\',\n    \'description\' => \'可将自已的帖子移动到其他版面（隐含、特殊限定版面除外）\',\n    \'weight\' => \'50\',\n    \'price\' => \'50\',\n  ),\n);\n\n'),('modreasons',1,1256533861,0,'$_DCACHE[\'modreasons\'] = array (\n  0 => \'广告/SPAM\',\n  1 => \'恶意灌水\',\n  2 => \'违规内容\',\n  3 => \'文不对题\',\n  4 => \'重复发帖\',\n  5 => \'\',\n  6 => \'我很赞同\',\n  7 => \'精品文章\',\n  8 => \'原创内容\',\n);\n\n'),('advs_archiver',1,1256533861,0,'$_DCACHE[\'advs\'] = array (\n);\n\n'),('advs_register',1,1256533861,0,'$_DCACHE[\'advs\'] = array (\n);\n\n'),('faqs',1,1256533861,0,'$_DCACHE[\'faqs\'] = array (\n  \'login\' => \n  array (\n    \'fpid\' => \'1\',\n    \'id\' => \'3\',\n    \'keyword\' => \'登录帮助\',\n  ),\n  \'discuzcode\' => \n  array (\n    \'fpid\' => \'5\',\n    \'id\' => \'18\',\n    \'keyword\' => \'Discuz!代码\',\n  ),\n  \'smilies\' => \n  array (\n    \'fpid\' => \'5\',\n    \'id\' => \'32\',\n    \'keyword\' => \'表情\',\n  ),\n);\n\n'),('secqaa',1,1256533861,0,'$_DCACHE[\'secqaa\'] = array (\n  1 => NULL,\n  2 => NULL,\n  3 => NULL,\n  4 => NULL,\n  5 => NULL,\n  6 => NULL,\n  7 => NULL,\n  8 => NULL,\n  9 => NULL,\n);\n\n'),('censor',1,1256533861,0,'$_DCACHE[\'censor\'] = array (\n  \'filter\' => \n  array (\n  ),\n  \'banned\' => \'\',\n  \'mod\' => \'\',\n);\n\n'),('ipbanned',1,1256533861,0,'$_DCACHE[\'ipbanned\'] = array (\n);\n\n'),('smilies_js',1,1256533861,0,'$_DCACHE[\'smilies_js\'] = array (\n);\n\n'),('announcements',1,1256533861,0,'$_DCACHE[\'announcements\'] = array (\n);\n\n'),('onlinelist',1,1256533861,0,'$_DCACHE[\'onlinelist\'] = array (\n  \'legend\' => \'<img src=\"images/common/online_admin.gif\" /> 管理员 &nbsp; &nbsp; &nbsp; <img src=\"images/common/online_supermod.gif\" /> 超级版主 &nbsp; &nbsp; &nbsp; <img src=\"images/common/online_moderator.gif\" /> 版主 &nbsp; &nbsp; &nbsp; <img src=\"images/common/online_member.gif\" /> 会员 &nbsp; &nbsp; &nbsp; \',\n  1 => \'online_admin.gif\',\n  2 => \'online_supermod.gif\',\n  3 => \'online_moderator.gif\',\n  0 => \'online_member.gif\',\n);\n\n'),('forumlinks',1,1256533861,0,'$_DCACHE[\'forumlinks\'] = array (\n  0 => \'<li><div class=\"forumlogo\"><img src=\"images/logo.gif\" border=\"0\" alt=\"Discuz! 官方论坛\" /></div><div class=\"forumcontent\"><h5><a href=\"http://www.discuz.net\" target=\"_blank\">Discuz! 官方论坛</a></h5><p>提供最新 Discuz! 产品新闻、软件下载与技术交流</p></div>\',\n  1 => \'\',\n  2 => \'\',\n);\n\n'),('advs_index',1,1256533861,0,'$_DCACHE[\'advs\'] = array (\n);\n\n'),('smilies',1,1256533861,0,'$_DCACHE[\'smilies\'] = array (\n  \'searcharray\' => \n  array (\n    13 => \'/\\\\:loveliness\\\\:/\',\n    23 => \'/\\\\:handshake/\',\n    20 => \'/\\\\:victory\\\\:/\',\n    51 => \'/\\\\{\\\\:3_51\\\\:\\\\}/\',\n    38 => \'/\\\\{\\\\:2_38\\\\:\\\\}/\',\n    55 => \'/\\\\{\\\\:3_55\\\\:\\\\}/\',\n    25 => \'/\\\\{\\\\:2_25\\\\:\\\\}/\',\n    42 => \'/\\\\{\\\\:3_42\\\\:\\\\}/\',\n    59 => \'/\\\\{\\\\:3_59\\\\:\\\\}/\',\n    29 => \'/\\\\{\\\\:2_29\\\\:\\\\}/\',\n    46 => \'/\\\\{\\\\:3_46\\\\:\\\\}/\',\n    63 => \'/\\\\{\\\\:3_63\\\\:\\\\}/\',\n    33 => \'/\\\\{\\\\:2_33\\\\:\\\\}/\',\n    50 => \'/\\\\{\\\\:3_50\\\\:\\\\}/\',\n    37 => \'/\\\\{\\\\:2_37\\\\:\\\\}/\',\n    54 => \'/\\\\{\\\\:3_54\\\\:\\\\}/\',\n    41 => \'/\\\\{\\\\:3_41\\\\:\\\\}/\',\n    58 => \'/\\\\{\\\\:3_58\\\\:\\\\}/\',\n    28 => \'/\\\\{\\\\:2_28\\\\:\\\\}/\',\n    45 => \'/\\\\{\\\\:3_45\\\\:\\\\}/\',\n    62 => \'/\\\\{\\\\:3_62\\\\:\\\\}/\',\n    32 => \'/\\\\{\\\\:2_32\\\\:\\\\}/\',\n    49 => \'/\\\\{\\\\:3_49\\\\:\\\\}/\',\n    36 => \'/\\\\{\\\\:2_36\\\\:\\\\}/\',\n    53 => \'/\\\\{\\\\:3_53\\\\:\\\\}/\',\n    40 => \'/\\\\{\\\\:2_40\\\\:\\\\}/\',\n    57 => \'/\\\\{\\\\:3_57\\\\:\\\\}/\',\n    27 => \'/\\\\{\\\\:2_27\\\\:\\\\}/\',\n    44 => \'/\\\\{\\\\:3_44\\\\:\\\\}/\',\n    61 => \'/\\\\{\\\\:3_61\\\\:\\\\}/\',\n    31 => \'/\\\\{\\\\:2_31\\\\:\\\\}/\',\n    48 => \'/\\\\{\\\\:3_48\\\\:\\\\}/\',\n    18 => \'/\\\\:sleepy\\\\:/\',\n    35 => \'/\\\\{\\\\:2_35\\\\:\\\\}/\',\n    52 => \'/\\\\{\\\\:3_52\\\\:\\\\}/\',\n    39 => \'/\\\\{\\\\:2_39\\\\:\\\\}/\',\n    56 => \'/\\\\{\\\\:3_56\\\\:\\\\}/\',\n    26 => \'/\\\\{\\\\:2_26\\\\:\\\\}/\',\n    43 => \'/\\\\{\\\\:3_43\\\\:\\\\}/\',\n    60 => \'/\\\\{\\\\:3_60\\\\:\\\\}/\',\n    30 => \'/\\\\{\\\\:2_30\\\\:\\\\}/\',\n    47 => \'/\\\\{\\\\:3_47\\\\:\\\\}/\',\n    64 => \'/\\\\{\\\\:3_64\\\\:\\\\}/\',\n    17 => \'/\\\\:shutup\\\\:/\',\n    34 => \'/\\\\{\\\\:2_34\\\\:\\\\}/\',\n    16 => \'/\\\\:dizzy\\\\:/\',\n    15 => \'/\\\\:curse\\\\:/\',\n    21 => \'/\\\\:time\\\\:/\',\n    24 => \'/\\\\:call\\\\:/\',\n    14 => \'/\\\\:funk\\\\:/\',\n    22 => \'/\\\\:kiss\\\\:/\',\n    19 => \'/\\\\:hug\\\\:/\',\n    12 => \'/\\\\:lol/\',\n    4 => \'/\\\\:\\\'\\\\(/\',\n    8 => \'/\\\\:\\\\$/\',\n    3 => \'/\\\\:D/\',\n    7 => \'/\\\\:P/\',\n    11 => \'/\\\\:Q/\',\n    2 => \'/\\\\:\\\\(/\',\n    6 => \'/\\\\:o/\',\n    10 => \'/\\\\:L/\',\n    1 => \'/\\\\:\\\\)/\',\n    5 => \'/\\\\:@/\',\n    9 => \'/;P/\',\n  ),\n  \'replacearray\' => \n  array (\n    13 => \'loveliness.gif\',\n    23 => \'handshake.gif\',\n    20 => \'victory.gif\',\n    51 => \'11.gif\',\n    38 => \'14.gif\',\n    55 => \'15.gif\',\n    25 => \'01.gif\',\n    42 => \'02.gif\',\n    59 => \'19.gif\',\n    29 => \'05.gif\',\n    46 => \'06.gif\',\n    63 => \'23.gif\',\n    33 => \'09.gif\',\n    50 => \'10.gif\',\n    37 => \'13.gif\',\n    54 => \'14.gif\',\n    41 => \'01.gif\',\n    58 => \'18.gif\',\n    28 => \'04.gif\',\n    45 => \'05.gif\',\n    62 => \'22.gif\',\n    32 => \'08.gif\',\n    49 => \'09.gif\',\n    36 => \'12.gif\',\n    53 => \'13.gif\',\n    40 => \'16.gif\',\n    57 => \'17.gif\',\n    27 => \'03.gif\',\n    44 => \'04.gif\',\n    61 => \'21.gif\',\n    31 => \'07.gif\',\n    48 => \'08.gif\',\n    18 => \'sleepy.gif\',\n    35 => \'11.gif\',\n    52 => \'12.gif\',\n    39 => \'15.gif\',\n    56 => \'16.gif\',\n    26 => \'02.gif\',\n    43 => \'03.gif\',\n    60 => \'20.gif\',\n    30 => \'06.gif\',\n    47 => \'07.gif\',\n    64 => \'24.gif\',\n    17 => \'shutup.gif\',\n    34 => \'10.gif\',\n    16 => \'dizzy.gif\',\n    15 => \'curse.gif\',\n    21 => \'time.gif\',\n    24 => \'call.gif\',\n    14 => \'funk.gif\',\n    22 => \'kiss.gif\',\n    19 => \'hug.gif\',\n    12 => \'lol.gif\',\n    4 => \'cry.gif\',\n    8 => \'shy.gif\',\n    3 => \'biggrin.gif\',\n    7 => \'tongue.gif\',\n    11 => \'mad.gif\',\n    2 => \'sad.gif\',\n    6 => \'shocked.gif\',\n    10 => \'sweat.gif\',\n    1 => \'smile.gif\',\n    5 => \'huffy.gif\',\n    9 => \'titter.gif\',\n  ),\n  \'typearray\' => \n  array (\n    13 => \'1\',\n    23 => \'1\',\n    20 => \'1\',\n    51 => \'3\',\n    38 => \'2\',\n    55 => \'3\',\n    25 => \'2\',\n    42 => \'3\',\n    59 => \'3\',\n    29 => \'2\',\n    46 => \'3\',\n    63 => \'3\',\n    33 => \'2\',\n    50 => \'3\',\n    37 => \'2\',\n    54 => \'3\',\n    41 => \'3\',\n    58 => \'3\',\n    28 => \'2\',\n    45 => \'3\',\n    62 => \'3\',\n    32 => \'2\',\n    49 => \'3\',\n    36 => \'2\',\n    53 => \'3\',\n    40 => \'2\',\n    57 => \'3\',\n    27 => \'2\',\n    44 => \'3\',\n    61 => \'3\',\n    31 => \'2\',\n    48 => \'3\',\n    18 => \'1\',\n    35 => \'2\',\n    52 => \'3\',\n    39 => \'2\',\n    56 => \'3\',\n    26 => \'2\',\n    43 => \'3\',\n    60 => \'3\',\n    30 => \'2\',\n    47 => \'3\',\n    64 => \'3\',\n    17 => \'1\',\n    34 => \'2\',\n    16 => \'1\',\n    15 => \'1\',\n    21 => \'1\',\n    24 => \'1\',\n    14 => \'1\',\n    22 => \'1\',\n    19 => \'1\',\n    12 => \'1\',\n    4 => \'1\',\n    8 => \'1\',\n    3 => \'1\',\n    7 => \'1\',\n    11 => \'1\',\n    2 => \'1\',\n    6 => \'1\',\n    10 => \'1\',\n    1 => \'1\',\n    5 => \'1\',\n    9 => \'1\',\n  ),\n);\n\n'),('announcements_forum',1,1256533861,0,'$_DCACHE[\'announcements_forum\'] = array (\n);\n\n'),('globalstick',1,1256533861,0,'$_DCACHE[\'globalstick\'] = array (\n  \'global\' => \n  array (\n    \'tids\' => 0,\n    \'count\' => 0,\n  ),\n);\n\n'),('floatthreads',1,1256533861,0,'$_DCACHE[\'floatthreads\'] = array (\n);\n\n'),('advs_forumdisplay',1,1256533861,0,'$_DCACHE[\'advs\'] = array (\n);\n\n'),('smileytypes',1,1256533861,0,'$_DCACHE[\'smileytypes\'] = array (\n  1 => \n  array (\n    \'name\' => \'默认\',\n    \'directory\' => \'default\',\n  ),\n  2 => \n  array (\n    \'name\' => \'酷猴\',\n    \'directory\' => \'coolmonkey\',\n  ),\n  3 => \n  array (\n    \'name\' => \'呆呆男\',\n    \'directory\' => \'grapeman\',\n  ),\n);\n\n'),('bbcodes',1,1256533861,0,'$_DCACHE[\'bbcodes\'] = array (\n  \'searcharray\' => \n  array (\n    0 => \'/\\\\[qq]([^\"\\\\[]+?)\\\\[\\\\/qq\\\\]/is\',\n  ),\n  \'replacearray\' => \n  array (\n    0 => \'<a href=\"http://wpa.qq.com/msgrd?V=1&Uin=\\\\1&amp;Site=[Discuz!]&amp;Menu=yes\" target=\"_blank\"><img src=\"http://wpa.qq.com/pa?p=1:\\\\1:1\" border=\"0\"></a>\',\n  ),\n);\n\n'),('advs_viewthread',1,1256533861,0,'$_DCACHE[\'advs\'] = array (\n);\n\n'),('tags_viewthread',1,1256533861,0,'$_DCACHE[\'tags\'] = array (\n  1 => \'[\\\'\\\']\',\n  0 => \'[\\\'\\\']\',\n  2 => \'0\',\n);\n\n'),('custominfo',1,1256533861,0,'$_DCACHE[\'custominfo\'] = array (\n  \'customauthorinfo\' => \n  array (\n    2 => \'<dt>UID</dt><dd>$post[uid]&nbsp;</dd><dt>帖子</dt><dd>$post[posts]&nbsp;</dd><dt>精华</dt><dd>$post[digestposts]&nbsp;</dd><dt>积分</dt><dd>$post[credits]&nbsp;</dd><dt>阅读权限</dt><dd>$post[readaccess]&nbsp;</dd>\".($post[location] ? \"<dt>来自</dt><dd>$post[location]&nbsp;</dd>\" : \"\").\"<dt>在线时间</dt><dd>$post[oltime] 小时&nbsp;</dd><dt>注册时间</dt><dd>$post[regdate]&nbsp;</dd><dt>最后登录</dt><dd>$post[lastdate]&nbsp;</dd>\',\n    1 => NULL,\n  ),\n  \'fieldsadd\' => \'\',\n  \'profilefields\' => \n  array (\n  ),\n  \'postminheight\' => 120,\n  \'postno\' => \n  array (\n    0 => \'<sup>#</sup>\',\n  ),\n);\n\n'),('groupicon',1,1256533861,0,'$_DCACHE[\'groupicon\'] = array (\n  1 => \'images/common/online_admin.gif\',\n  2 => \'images/common/online_supermod.gif\',\n  3 => \'images/common/online_moderator.gif\',\n  0 => \'images/common/online_member.gif\',\n);\n\n'),('bbcodes_display',1,1256533861,0,'$_DCACHE[\'bbcodes_display\'] = array (\n  \'b i u\' => \n  array (\n    \'type\' => \'1\',\n    \'icon\' => \'popup_simple\',\n    \'explanation\' => \'粗体 斜体 下划线\',\n    \'params\' => \'1\',\n    \'prompt\' => \'\',\n  ),\n  \'size\' => \n  array (\n    \'type\' => \'1\',\n    \'icon\' => \'popup_fontsize\',\n    \'explanation\' => \'大小\',\n    \'params\' => \'1\',\n    \'prompt\' => \'\',\n  ),\n  \'color\' => \n  array (\n    \'type\' => \'1\',\n    \'icon\' => \'popup_forecolor\',\n    \'explanation\' => \'颜色\',\n    \'params\' => \'1\',\n    \'prompt\' => \'\',\n  ),\n  \'align\' => \n  array (\n    \'type\' => \'1\',\n    \'icon\' => \'popup_justify\',\n    \'explanation\' => \'对齐\',\n    \'params\' => \'1\',\n    \'prompt\' => \'\',\n  ),\n  \'url\' => \n  array (\n    \'type\' => \'1\',\n    \'icon\' => \'cmd_createlink\',\n    \'explanation\' => \'链接\',\n    \'params\' => \'1\',\n    \'prompt\' => \'\',\n  ),\n  \'img\' => \n  array (\n    \'type\' => \'1\',\n    \'icon\' => \'cmd_insertimage\',\n    \'explanation\' => \'图片\',\n    \'params\' => \'1\',\n    \'prompt\' => \'\',\n  ),\n  \'media\' => \n  array (\n    \'type\' => \'1\',\n    \'icon\' => \'popup_media\',\n    \'explanation\' => \'多媒体\',\n    \'params\' => \'1\',\n    \'prompt\' => \'\',\n  ),\n  \'quote\' => \n  array (\n    \'type\' => \'1\',\n    \'icon\' => \'cmd_quote\',\n    \'explanation\' => \'引用\',\n    \'params\' => \'1\',\n    \'prompt\' => \'\',\n  ),\n  \'code\' => \n  array (\n    \'type\' => \'1\',\n    \'icon\' => \'cmd_code\',\n    \'explanation\' => \'代码\',\n    \'params\' => \'1\',\n    \'prompt\' => \'\',\n  ),\n  \'list\' => \n  array (\n    \'type\' => \'1\',\n    \'icon\' => \'popup_list\',\n    \'explanation\' => \'列表\',\n    \'params\' => \'1\',\n    \'prompt\' => \'\',\n  ),\n  \'indent outdent\' => \n  array (\n    \'type\' => \'1\',\n    \'icon\' => \'popup_dent\',\n    \'explanation\' => \'缩进\',\n    \'params\' => \'1\',\n    \'prompt\' => \'\',\n  ),\n  \'table\' => \n  array (\n    \'type\' => \'1\',\n    \'icon\' => \'cmd_table\',\n    \'explanation\' => \'表格\',\n    \'params\' => \'1\',\n    \'prompt\' => \'\',\n  ),\n  \'hide\' => \n  array (\n    \'type\' => \'1\',\n    \'icon\' => \'cmd_hide\',\n    \'explanation\' => \'隐藏内容\',\n    \'params\' => \'1\',\n    \'prompt\' => \'\',\n  ),\n  \'smilies\' => \n  array (\n    \'type\' => \'1\',\n    \'icon\' => \'popup_smilies\',\n    \'explanation\' => \'表情\',\n    \'params\' => \'1\',\n    \'prompt\' => \'\',\n  ),\n  \'tools\' => \n  array (\n    \'type\' => \'1\',\n    \'icon\' => \'popup_tools\',\n    \'explanation\' => \'工具\',\n    \'params\' => \'1\',\n    \'prompt\' => \'\',\n  ),\n);\n\n'),('smileycodes',1,1256533861,0,'$_DCACHE[\'smileycodes\'] = array (\n  1 => \':)\',\n  2 => \':(\',\n  3 => \':D\',\n  4 => \':\\\'(\',\n  5 => \':@\',\n  6 => \':o\',\n  7 => \':P\',\n  8 => \':$\',\n  9 => \';P\',\n  10 => \':L\',\n  11 => \':Q\',\n  12 => \':lol\',\n  13 => \':loveliness:\',\n  14 => \':funk:\',\n  15 => \':curse:\',\n  16 => \':dizzy:\',\n  17 => \':shutup:\',\n  18 => \':sleepy:\',\n  19 => \':hug:\',\n  20 => \':victory:\',\n  21 => \':time:\',\n  22 => \':kiss:\',\n  23 => \':handshake\',\n  24 => \':call:\',\n  25 => \'{:2_25:}\',\n  26 => \'{:2_26:}\',\n  27 => \'{:2_27:}\',\n  28 => \'{:2_28:}\',\n  29 => \'{:2_29:}\',\n  30 => \'{:2_30:}\',\n  31 => \'{:2_31:}\',\n  32 => \'{:2_32:}\',\n  33 => \'{:2_33:}\',\n  34 => \'{:2_34:}\',\n  35 => \'{:2_35:}\',\n  36 => \'{:2_36:}\',\n  37 => \'{:2_37:}\',\n  38 => \'{:2_38:}\',\n  39 => \'{:2_39:}\',\n  40 => \'{:2_40:}\',\n  41 => \'{:3_41:}\',\n  42 => \'{:3_42:}\',\n  43 => \'{:3_43:}\',\n  44 => \'{:3_44:}\',\n  45 => \'{:3_45:}\',\n  46 => \'{:3_46:}\',\n  47 => \'{:3_47:}\',\n  48 => \'{:3_48:}\',\n  49 => \'{:3_49:}\',\n  50 => \'{:3_50:}\',\n  51 => \'{:3_51:}\',\n  52 => \'{:3_52:}\',\n  53 => \'{:3_53:}\',\n  54 => \'{:3_54:}\',\n  55 => \'{:3_55:}\',\n  56 => \'{:3_56:}\',\n  57 => \'{:3_57:}\',\n  58 => \'{:3_58:}\',\n  59 => \'{:3_59:}\',\n  60 => \'{:3_60:}\',\n  61 => \'{:3_61:}\',\n  62 => \'{:3_62:}\',\n  63 => \'{:3_63:}\',\n  64 => \'{:3_64:}\',\n);\n\n'),('fields_required',1,1256533861,0,'$_DCACHE[\'fields_required\'] = array (\n);\n\n'),('fields_optional',1,1256533861,0,'$_DCACHE[\'fields_optional\'] = array (\n);\n\n');

/*Table structure for table `cdb_campaigns` */

DROP TABLE IF EXISTS `cdb_campaigns`;

CREATE TABLE `cdb_campaigns` (
  `id` mediumint(8) unsigned NOT NULL,
  `type` tinyint(1) unsigned NOT NULL,
  `fid` smallint(6) unsigned NOT NULL,
  `tid` mediumint(8) unsigned NOT NULL,
  `status` tinyint(1) NOT NULL default '0',
  `begintime` int(10) unsigned NOT NULL,
  `starttime` int(10) unsigned NOT NULL,
  `endtime` int(10) unsigned NOT NULL,
  `expiration` int(10) unsigned NOT NULL,
  `nextrun` int(10) unsigned NOT NULL,
  `url` char(255) NOT NULL,
  `autoupdate` tinyint(1) unsigned NOT NULL,
  `lastupdated` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`,`type`),
  KEY `tid` (`tid`),
  KEY `nextrun` (`nextrun`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_campaigns` */

/*Table structure for table `cdb_creditslog` */

DROP TABLE IF EXISTS `cdb_creditslog`;

CREATE TABLE `cdb_creditslog` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `fromto` char(15) NOT NULL default '',
  `sendcredits` tinyint(1) NOT NULL default '0',
  `receivecredits` tinyint(1) NOT NULL default '0',
  `send` int(10) unsigned NOT NULL default '0',
  `receive` int(10) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `operation` char(3) NOT NULL default '',
  KEY `uid` (`uid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_creditslog` */

/*Table structure for table `cdb_crons` */

DROP TABLE IF EXISTS `cdb_crons`;

CREATE TABLE `cdb_crons` (
  `cronid` smallint(6) unsigned NOT NULL auto_increment,
  `available` tinyint(1) NOT NULL default '0',
  `type` enum('user','system') NOT NULL default 'user',
  `name` char(50) NOT NULL default '',
  `filename` char(50) NOT NULL default '',
  `lastrun` int(10) unsigned NOT NULL default '0',
  `nextrun` int(10) unsigned NOT NULL default '0',
  `weekday` tinyint(1) NOT NULL default '0',
  `day` tinyint(2) NOT NULL default '0',
  `hour` tinyint(2) NOT NULL default '0',
  `minute` char(36) NOT NULL default '',
  PRIMARY KEY  (`cronid`),
  KEY `nextrun` (`available`,`nextrun`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_crons` */

insert  into `cdb_crons`(`cronid`,`available`,`type`,`name`,`filename`,`lastrun`,`nextrun`,`weekday`,`day`,`hour`,`minute`) values (1,1,'system','清空今日发帖数','todayposts_daily.inc.php',0,1256537461,-1,-1,0,'0'),(2,1,'system','清空本月在线时间','onlinetime_monthly.inc.php',0,1256537461,-1,1,0,'0'),(3,1,'system','每日数据清理','cleanup_daily.inc.php',0,1256537461,-1,-1,5,'30'),(4,1,'system','生日统计与邮件祝福','birthdays_daily.inc.php',0,1256537461,-1,-1,0,'0'),(5,1,'system','主题回复通知','notify_daily.inc.php',0,1256537461,-1,-1,5,'00'),(6,1,'system','每日公告清理','announcements_daily.inc.php',0,1256537461,-1,-1,0,'0'),(7,1,'system','限时操作清理','threadexpiries_hourly.inc.php',0,1256537461,-1,-1,5,'0'),(8,1,'system','论坛推广清理','promotions_hourly.inc.php',0,1256537461,-1,-1,0,'00'),(9,1,'system','每月主题清理','cleanup_monthly.inc.php',0,1256537461,-1,1,6,'00'),(12,1,'system','道具自动补货','magics_daily.inc.php',0,1256537461,-1,-1,0,'0'),(13,1,'system','每日验证问答更新','secqaa_daily.inc.php',0,1256537461,-1,-1,6,'0'),(14,1,'system','每日标签更新','tags_daily.inc.php',0,1256537461,-1,-1,0,'0'),(15,1,'system','每日勋章更新','medals_daily.inc.php',0,1256537461,-1,-1,0,'0');

/*Table structure for table `cdb_debateposts` */

DROP TABLE IF EXISTS `cdb_debateposts`;

CREATE TABLE `cdb_debateposts` (
  `pid` int(10) unsigned NOT NULL default '0',
  `stand` tinyint(1) NOT NULL default '0',
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `voters` mediumint(10) unsigned NOT NULL default '0',
  `voterids` text NOT NULL,
  PRIMARY KEY  (`pid`),
  KEY `pid` (`pid`,`stand`),
  KEY `tid` (`tid`,`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_debateposts` */

/*Table structure for table `cdb_debates` */

DROP TABLE IF EXISTS `cdb_debates`;

CREATE TABLE `cdb_debates` (
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `starttime` int(10) unsigned NOT NULL default '0',
  `endtime` int(10) unsigned NOT NULL default '0',
  `affirmdebaters` mediumint(8) unsigned NOT NULL default '0',
  `negadebaters` mediumint(8) unsigned NOT NULL default '0',
  `affirmvotes` mediumint(8) unsigned NOT NULL default '0',
  `negavotes` mediumint(8) unsigned NOT NULL default '0',
  `umpire` varchar(15) NOT NULL default '',
  `winner` tinyint(1) NOT NULL default '0',
  `bestdebater` varchar(50) NOT NULL default '',
  `affirmpoint` text NOT NULL,
  `negapoint` text NOT NULL,
  `umpirepoint` text NOT NULL,
  `affirmvoterids` text NOT NULL,
  `negavoterids` text NOT NULL,
  `affirmreplies` mediumint(8) unsigned NOT NULL,
  `negareplies` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY  (`tid`),
  KEY `uid` (`uid`,`starttime`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_debates` */

/*Table structure for table `cdb_failedlogins` */

DROP TABLE IF EXISTS `cdb_failedlogins`;

CREATE TABLE `cdb_failedlogins` (
  `ip` char(15) NOT NULL default '',
  `count` tinyint(1) unsigned NOT NULL default '0',
  `lastupdate` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_failedlogins` */

/*Table structure for table `cdb_faqs` */

DROP TABLE IF EXISTS `cdb_faqs`;

CREATE TABLE `cdb_faqs` (
  `id` smallint(6) NOT NULL auto_increment,
  `fpid` smallint(6) unsigned NOT NULL default '0',
  `displayorder` tinyint(3) NOT NULL default '0',
  `identifier` varchar(20) NOT NULL,
  `keyword` varchar(50) NOT NULL,
  `title` varchar(50) NOT NULL,
  `message` text NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `displayplay` (`displayorder`)
) ENGINE=MyISAM AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_faqs` */

insert  into `cdb_faqs`(`id`,`fpid`,`displayorder`,`identifier`,`keyword`,`title`,`message`) values (1,0,1,'','','用户须知',''),(2,1,1,'','','我必须要注册吗？','这取决于管理员如何设置 Discuz! 论坛的用户组权限选项，您甚至有可能必须在注册成正式用户后后才能浏览帖子。当然，在通常情况下，您至少应该是正式用户才能发新帖和回复已有帖子。请 <a href=\"register.php\" target=\"_blank\">点击这里</a> 免费注册成为我们的新用户！\r\n<br /><br />强烈建议您注册，这样会得到很多以游客身份无法实现的功能。'),(3,1,2,'login','登录帮助','我如何登录论坛？','如果您已经注册成为该论坛的会员，哪么您只要通过访问页面右上的<a href=\"logging.php?action=login\" target=\"_blank\">登录</a>，进入登陆界面填写正确的用户名和密码（如果您设有安全提问，请选择正确的安全提问并输入对应的答案），点击“提交”即可完成登陆如果您还未注册请点击这里。<br /><br />\r\n如果需要保持登录，请选择相应的 Cookie 时间，在此时间范围内您可以不必输入密码而保持上次的登录状态。'),(4,1,3,'','','忘记我的登录密码，怎么办？','当您忘记了用户登录的密码，您可以通过注册时填写的电子邮箱重新设置一个新的密码。点击登录页面中的 <a href=\"member.php?action=lostpasswd\" target=\"_blank\">取回密码</a>，按照要求填写您的个人信息，系统将自动发送重置密码的邮件到您注册时填写的 Email 信箱中。如果您的 Email 已失效或无法收到信件，请与论坛管理员联系。'),(5,0,2,'','','帖子相关操作',''),(6,0,3,'','','基本功能操作',''),(7,0,4,'','','其他相关问题',''),(8,1,4,'','','我如何使用个性化头像','在<a href=\"memcp.php\" target=\"_blank\">控制面板</a>中的“编辑个人资料”，有一个“头像”的选项，可以使用论坛自带的头像或者自定义的头像。'),(9,1,5,'','','我如何修改登录密码','在<a href=\"memcp.php\" target=\"_blank\">控制面板</a>中的“编辑个人资料”，填写“原密码”，“新密码”，“确认新密码”。点击“提交”，即可修改。'),(10,1,6,'','','我如何使用个性化签名和昵称','在<a href=\"memcp.php\" target=\"_blank\">控制面板</a>中的“编辑个人资料”，有一个“昵称”和“个人签名”的选项，可以在此设置。'),(11,5,1,'','','我如何发表新主题','在论坛版块中，点“新帖”，如果有权限，您可以看到有“投票，悬赏，活动，交易”，点击即可进入功能齐全的发帖界面。\r\n<br /><br />注意：一般论坛都设置为高级别的用户组才能发布这四类特殊主题。如发布普通主题，直接点击“新帖”，当然您也可以使用版块下面的“快速发帖”发表新帖(如果此选项打开)。一般论坛都设置为需要登录后才能发帖。'),(12,5,2,'','','我如何发表回复','回复有分三种：第一、贴子最下方的快速回复； 第二、在您想回复的楼层点击右下方“回复”； 第三、完整回复页面，点击本页“新帖”旁边的“回复”。'),(13,5,3,'','','我如何编辑自己的帖子','在帖子的右下角，有编辑，回复，报告等选项，点击编辑，就可以对帖子进行编辑。'),(14,5,4,'','','我如何出售购买主题','<li>出售主题：\r\n当您进入发贴界面后，如果您所在的用户组有发买卖贴的权限，在“售价(金钱)”后面填写主题的价格，这样其他用户在查看这个帖子的时候就需要进入交费的过程才可以查看帖子。</li>\r\n<li>购买主题：\r\n浏览你准备购买的帖子，在帖子的相关信息的下面有[查看付款记录] [购买主题] [返回上一页] \r\n等链接，点击“购买主题”进行购买。</li>'),(15,5,5,'','','我如何出售购买附件','<li>上传附件一栏有个售价的输入框，填入出售价格即可实现需要支付才可下载附件的功能。</li>\r\n<li>点击帖子中[购买附件]按钮或点击附件的下载链接会跳转至附件购买页面，确认付款的相关信息后点提交按钮，即可得到附件的下载权限。只需购买一次，就有该附件的永远下载权限。</li>'),(16,5,6,'','','我如何上传附件','<li>发表新主题的时候上传附件，步骤为：写完帖子标题和内容后点上传附件右方的浏览，然后在本地选择要上传附件的具体文件名，最后点击发表话题。</li>\r\n<li>发表回复的时候上传附件，步骤为：写完回复楼主的内容，然后点上传附件右方的浏览，找到需要上传的附件，点击发表回复。</li>'),(17,5,7,'','','我如何实现发帖时图文混排效果','<li>发表新主题的时候点击上传附件左侧的“[插入]”链接把附件标记插入到帖子中适当的位置即可。</li>'),(18,5,8,'discuzcode','Discuz!代码','我如何使用Discuz!代码','<table width=\"99%\" cellpadding=\"2\" cellspacing=\"2\">\r\n  <tr>\r\n    <th width=\"50%\">Discuz!代码</th>\r\n    <th width=\"402\">效果</th>\r\n  </tr>\r\n  <tr>\r\n    <td>[b]粗体文字 Abc[/b]</td>\r\n    <td><strong>粗体文字 Abc</strong></td>\r\n  </tr>\r\n  <tr>\r\n    <td>[i]斜体文字 Abc[/i]</td>\r\n    <td><em>斜体文字 Abc</em></td>\r\n  </tr>\r\n  <tr>\r\n    <td>[u]下划线文字 Abc[/u]</td>\r\n    <td><u>下划线文字 Abc</u></td>\r\n  </tr>\r\n  <tr>\r\n    <td>[color=red]红颜色[/color]</td>\r\n    <td><font color=\"red\">红颜色</font></td>\r\n  </tr>\r\n  <tr>\r\n    <td>[size=3]文字大小为 3[/size] </td>\r\n    <td><font size=\"3\">文字大小为 3</font></td>\r\n  </tr>\r\n  <tr>\r\n    <td>[font=仿宋]字体为仿宋[/font] </td>\r\n    <td><font face=\"仿宋\">字体为仿宋</font></td>\r\n  </tr>\r\n  <tr>\r\n    <td>[align=Center]内容居中[/align] </td>\r\n    <td><div align=\"center\">内容居中</div></td>\r\n  </tr>\r\n  <tr>\r\n    <td>[url]http://www.comsenz.com[/url]</td>\r\n    <td><a href=\"http://www.comsenz.com\" target=\"_blank\">http://www.comsenz.com</a>（超级链接）</td>\r\n  </tr>\r\n  <tr>\r\n    <td>[url=http://www.Discuz.net]Discuz! 论坛[/url]</td>\r\n    <td><a href=\"http://www.Discuz.net\" target=\"_blank\">Discuz! 论坛</a>（超级链接）</td>\r\n  </tr>\r\n  <tr>\r\n    <td>[email]myname@mydomain.com[/email]</td>\r\n    <td><a href=\"mailto:myname@mydomain.com\">myname@mydomain.com</a>（E-mail链接）</td>\r\n  </tr>\r\n  <tr>\r\n    <td>[email=support@discuz.net]Discuz! 技术支持[/email]</td>\r\n    <td><a href=\"mailto:support@discuz.net\">Discuz! 技术支持（E-mail链接）</a></td>\r\n  </tr>\r\n  <tr>\r\n    <td>[quote]Discuz! Board 是由康盛创想（北京）科技有限公司开发的论坛软件[/quote] </td>\r\n    <td><div style=\"font-size: 12px\"><br /><br /><div class=\"quote\"><h5>引用:</h5><blockquote>原帖由 <i>admin</i> 于 2006-12-26 08:45 发表<br />Discuz! Board 是由康盛创想（北京）科技有限公司开发的论坛软件</blockquote></div></td>\r\n  </tr>\r\n   <tr>\r\n    <td>[code]Discuz! Board 是由康盛创想（北京）科技有限公司开发的论坛软件[/code] </td>\r\n    <td><div style=\"font-size: 12px\"><br /><br /><div class=\"blockcode\"><h5>代码:</h5><code id=\"code0\">Discuz! Board 是由康盛创想（北京）科技有限公司开发的论坛软件</code></div></td>\r\n  </tr>\r\n  <tr>\r\n    <td>[hide]隐藏内容 Abc[/hide]</td>\r\n    <td>效果:只有当浏览者回复本帖时，才显示其中的内容，否则显示为“<b>**** 隐藏信息 跟帖后才能显示 *****</b>”</td>\r\n  </tr>\r\n  <tr>\r\n    <td>[hide=20]隐藏内容 Abc[/hide]</td>\r\n    <td>效果:只有当浏览者积分高于 20 点时，才显示其中的内容，否则显示为“<b>**** 隐藏信息 积分高于 20 点才能显示 ****</b>”</td>\r\n  </tr>\r\n  <tr>\r\n    <td>[list][*]列表项 #1[*]列表项 #2[*]列表项 #3[/list]</td>\r\n    <td><ul>\r\n      <li>列表项 ＃1</li>\r\n      <li>列表项 ＃2</li>\r\n      <li>列表项 ＃3 </li>\r\n    </ul></td>\r\n  </tr>\r\n  <tr>\r\n    <td>[img]http://www.discuz.net/images/default/logo.gif[/img] </td>\r\n    <td>帖子内显示为：<img src=\"http://www.discuz.net/images/default/logo.gif\" /></td>\r\n  </tr>\r\n  <tr>\r\n    <td>[img=88,31]http://www.discuz.net/images/logo.gif[/img] </td>\r\n    <td>帖子内显示为：<img src=\"http://www.discuz.net/images/logo.gif\" /></td>\r\n  </tr> <tr>\r\n    <td>[media=400,300,1]多媒体 URL[/media]</td>\r\n    <td>帖子内嵌入多媒体，宽 400 高 300 自动播放</td>\r\n  </tr>\r\n <tr>\r\n    <td>[fly]飞行的效果[/fly]</td>\r\n    <td><marquee scrollamount=\"3\" behavior=\"alternate\" width=\"90%\">飞行的效果</marquee></td>\r\n  </tr>\r\n  <tr>\r\n    <td>[flash]Flash网页地址 [/flash] </td>\r\n    <td>帖子内嵌入 Flash 动画</td>\r\n  </tr>\r\n  <tr>\r\n    <td>[qq]123456789[/qq]</td>\r\n    <td>在帖子内显示 QQ 在线状态，点这个图标可以和他（她）聊天</td>\r\n  </tr>\r\n  <tr>\r\n    <td>X[sup]2[/sup]</td>\r\n    <td>X<sup>2</sup></td>\r\n  </tr>\r\n  <tr>\r\n    <td>X[sub]2[/sub]</td>\r\n    <td>X<sub>2</sub></td>\r\n  </tr>\r\n  \r\n</table>'),(19,6,1,'','','我如何使用短消息功能','您登录后，点击导航栏上的短消息按钮，即可进入短消息管理。\r\n点击[发送短消息]按钮，在\"发送到\"后输入收信人的用户名，填写完标题和内容，点提交(或按 Ctrl+Enter 发送)即可发出短消息。\r\n<br /><br />如果要保存到发件箱，以在提交前勾选\"保存到发件箱中\"前的复选框。\r\n<ul>\r\n<li>点击收件箱可打开您的收件箱查看收到的短消息。</li>\r\n<li>点击发件箱可查看保存在发件箱里的短消息。 </li>\r\n<li>点击已发送来查看对方是否已经阅读您的短消息。 </li>\r\n<li>点击搜索短消息就可通过关键字，发信人，收信人，搜索范围，排序类型等一系列条件设定来找到您需要查找的短消息。 </li>\r\n<li>点击导出短消息可以将自己的短消息导出htm文件保存在自己的电脑里。 </li>\r\n<li>点击忽略列表可以设定忽略人员，当这些被添加的忽略用户给您发送短消息时将不予接收。</li>\r\n</ul>'),(20,6,2,'','','我如何向好友群发短消息','登录论坛后，点击短消息，然后点发送短消息，如果有好友的话，好友群发后面点击全选，可以给所有的好友群发短消息。'),(21,6,3,'','','我如何查看论坛会员数据','点击导航栏上面的会员，然后显示的是此论坛的会员数据。注：需要论坛管理员开启允许你查看会员资料才可看到。'),(22,6,4,'','','我如何使用搜索','点击导航栏上面的搜索，输入搜索的关键字并选择一个范围，就可以检索到您有权限访问论坛中的相关的帖子。'),(23,6,5,'','','我如何使用“我的”功能','<li>会员必须首先<a href=\"logging.php?action=login\" target=\"_blank\">登录</a>，没有用户名的请先<a href=\"register.php\" target=\"_blank\">注册</a>；</li>\r\n<li>登录之后在论坛的左上方会出现一个“我的”的超级链接，点击这个链接之后就可进入到有关于您的信息。</li>'),(24,7,1,'','','我如何向管理员报告帖子','打开一个帖子，在帖子的右下角可以看到：“编辑”、“引用”、“报告”、“评分”、“回复”等等几个按钮，点击其中的“报告”按钮进入报告页面，填写好“我的意见”，单击“报告”按钮即可完成报告某个帖子的操作。'),(25,7,2,'','','我如何“打印”，“推荐”，“订阅”，“收藏”帖子','当你浏览一个帖子时，在它的右上角可以看到：“打印”、“推荐”、“订阅”、“收藏”，点击相对应的文字连接即可完成相关的操作。'),(26,7,3,'','','我如何设置论坛好友','设置论坛好友有3种简单的方法。\r\n<ul>\r\n<li>当您浏览帖子的时候可以点击“发表时间”右侧的“加为好友”设置论坛好友。</li>\r\n<li>当您浏览某用户的个人资料时，可以点击头像下方的“加为好友”设置论坛好友。</li>\r\n<li>您也可以在控制面板中的好友列表增加您的论坛好友。</li>\r\n<ul>'),(27,7,4,'','','我如何使用RSS订阅','在论坛的首页和进入版块的页面的右上角就会出现一个rss订阅的小图标<img src=\"images/common/xml.gif\" border=\"0\">，鼠标点击之后将出现本站点的rss地址，你可以将此rss地址放入到你的rss阅读器中进行订阅。'),(28,7,5,'','','我如何清除Cookies','cookie是由浏览器保存在系统内的，在论坛的右下角提供有\"清除 Cookies\"的功能，点击后即可帮您清除系统内存储的Cookies。 <br /><br />\r\n以下介绍3种常用浏览器的Cookies清除方法(注：此方法为清除全部的Cookies,请谨慎使用)\r\n<ul>\r\n<li>Internet Explorer: 工具（选项）内的Internet选项→常规选项卡内，IE6直接可以看到删除Cookies的按钮点击即可，IE7为“浏 览历史记录”选项内的删除点击即可清空Cookies。对于Maxthon,腾讯TT等IE核心浏览器一样适用。 </li>\r\n<li>FireFox:工具→选项→隐私→Cookies→显示Cookie里可以对Cookie进行对应的删除操作。 </li>\r\n<li>Opera:工具→首选项→高级→Cookies→管理Cookies即可对Cookies进行删除的操作。</li>\r\n</ul>'),(29,7,6,'','','我如何联系管理员','您可以通过论坛底部右下角的“联系我们”链接快速的发送邮件与我们联系。也可以通过管理团队中的用户资料发送短消息给我们。'),(30,7,7,'','','我如何开通个人空间','如果您有权限开通“我的个人空间”，当用户登录论坛以后在论坛首页，用户名的右方点击开通我的个人空间，进入个人空间的申请页面。'),(31,7,8,'','','我如何将自己的主题加入个人空间','如果您有权限开通“我的个人空间”，在您发表的主题上方点击“加入个人空间”，您发表的主题以及回复都会加入到您空间的日志里。'),(32,5,9,'smilies','表情','我如何使用表情代码','表情是一些用字符表示的表情符号，如果打开表情功能，Discuz! 会把一些符号转换成小图像，显示在帖子中，更加美观明了。目前支持下面这些表情：<br /><br />\r\n<table cellspacing=\"0\" cellpadding=\"4\" width=\"30%\" align=\"center\">\r\n<tr><th width=\"25%\" align=\"center\">表情符号</td>\r\n<th width=\"75%\" align=\"center\">对应图像</td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:)</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/smile.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:(</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/sad.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:D</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/biggrin.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:\\\'(</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/cry.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:@</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/huffy.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:o</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/shocked.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:P</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/tongue.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:$</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/shy.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">;P</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/titter.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:L</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/sweat.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:Q</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/mad.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:lol</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/lol.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:hug:</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/hug.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:victory:</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/victory.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:time:</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/time.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:kiss:</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/kiss.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:handshake</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/handshake.gif\" alt=\"\" /></td>\r\n</tr>\r\n<tr>\r\n<td width=\"25%\" align=\"center\">:call:</td>\r\n<td width=\"75%\" align=\"center\"><img src=\"images/smilies/default/call.gif\" alt=\"\" /></td>\r\n</tr>\r\n</table>\r\n</div></div>\r\n<br />'),(33,0,5,'','','论坛高级功能使用',''),(34,33,0,'forwardmessagelist','','论坛快速跳转关键字列表','Discuz! 支持自定义快速跳转页面，当某些操作完成后，可以不显示提示信息，直接跳转到新的页面，从而方便用户进行下一步操作，避免等待。 在实际使用当中，您根据需要，把关键字添加到快速跳转设置里面(后台 -- 基本设置 --  界面与显示方式 -- [<a href=\"admincp.php?action=settings&operation=styles&frames=yes\" target=\"_blank\">提示信息跳转设置</a> ])，让某些信息不显示而实现快速跳转。以下是 Discuz! 当中的一些常用信息的关键字:\r\n</br></br>\r\n\r\n<table width=\"99%\" cellpadding=\"2\" cellspacing=\"2\">\r\n  <tr>\r\n    <td width=\"50%\">关键字</td>\r\n    <td width=\"50%\">提示信息页面或者作用</td>\r\n  </tr>\r\n  <tr>\r\n    <td>login_succeed</td>\r\n    <td>登录成功</td>\r\n  </tr>\r\n  <tr>\r\n    <td>logout_succeed</td>\r\n    <td>退出登录成功</td>\r\n  </tr>\r\n    <tr>\r\n    <td>thread_poll_succeed</td>\r\n    <td>投票成功</td>\r\n  </tr>\r\n    <tr>\r\n    <td>thread_rate_succeed</td>\r\n    <td>评分成功</td>\r\n  </tr>\r\n    <tr>\r\n    <td>register_succeed</td>\r\n    <td>注册成功</td>\r\n  </tr>\r\n    <tr>\r\n    <td>usergroups_join_succeed</td>\r\n    <td>加入扩展组成功</td>\r\n  </tr>\r\n    <tr>\r\n    <td height=\"22\">usergroups_exit_succeed</td>\r\n    <td>退出扩展组成功</td>\r\n  </tr>\r\n  <tr>\r\n    <td>usergroups_update_succeed</td>\r\n    <td>更新扩展组成功</td>\r\n  </tr>\r\n    <tr>\r\n    <td>buddy_update_succeed</td>\r\n    <td>好友更新成功</td>\r\n  </tr>\r\n    <tr>\r\n    <td>post_edit_succeed</td>\r\n    <td>编辑帖子成功</td>\r\n  </tr>\r\n    <tr>\r\n    <td>post_edit_delete_succeed</td>\r\n    <td>删除帖子成功</td>\r\n  </tr>\r\n    <tr>\r\n    <td>post_reply_succeed</td>\r\n    <td>回复成功</td>\r\n  </tr>\r\n    <tr>\r\n    <td>post_newthread_succeed</td>\r\n    <td>发表新主题成功</td>\r\n  </tr>\r\n    <tr>\r\n    <td>post_reply_blog_succeed</td>\r\n    <td>文集评论发表成功</td>\r\n  </tr>\r\n    <tr>\r\n    <td>post_newthread_blog_succeed</td>\r\n    <td>blog 发表成功</td>\r\n  </tr>\r\n    <tr>\r\n    <td>profile_avatar_succeed</td>\r\n    <td>头像设置成功</td>\r\n  </tr>\r\n    <tr>\r\n    <td>profile_succeed</td>\r\n    <td>个人资料更新成功</td>\r\n  </tr>\r\n    <tr>\r\n    <td>pm_send_succeed</td>\r\n    <td>短消息发送成功</td>\r\n  </tr>\r\n  </tr>\r\n    <tr>\r\n    <td>pm_delete_succeed</td>\r\n    <td>短消息删除成功</td>\r\n  </tr>\r\n  </tr>\r\n    <tr>\r\n    <td>pm_ignore_succeed</td>\r\n    <td>短消息忽略列表更新</td>\r\n  </tr>\r\n    <tr>\r\n    <td>admin_succeed</td>\r\n    <td>管理操作成功〔注意：设置此关键字后，所有管理操作完毕都将直接跳转〕</td>\r\n  </tr>\r\n    <tr>\r\n    <td>admin_succeed_next&nbsp;</td>\r\n    <td>管理成功并将跳转到下一个管理动作</td>\r\n  </tr> \r\n    <tr>\r\n    <td>search_redirect</td>\r\n    <td>搜索完成，进入搜索结果列表</td>\r\n  </tr>\r\n</table>');

/*Table structure for table `cdb_favorites` */

DROP TABLE IF EXISTS `cdb_favorites`;

CREATE TABLE `cdb_favorites` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `fid` smallint(6) unsigned NOT NULL default '0',
  KEY `uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_favorites` */

/*Table structure for table `cdb_forumfields` */

DROP TABLE IF EXISTS `cdb_forumfields`;

CREATE TABLE `cdb_forumfields` (
  `fid` smallint(6) unsigned NOT NULL default '0',
  `description` text NOT NULL,
  `password` varchar(12) NOT NULL default '',
  `icon` varchar(255) NOT NULL default '',
  `postcredits` varchar(255) NOT NULL default '',
  `replycredits` varchar(255) NOT NULL default '',
  `getattachcredits` varchar(255) NOT NULL default '',
  `postattachcredits` varchar(255) NOT NULL default '',
  `digestcredits` varchar(255) NOT NULL default '',
  `redirect` varchar(255) NOT NULL default '',
  `attachextensions` varchar(255) NOT NULL default '',
  `formulaperm` text NOT NULL,
  `moderators` text NOT NULL,
  `rules` text NOT NULL,
  `threadtypes` text NOT NULL,
  `threadsorts` text NOT NULL,
  `viewperm` text NOT NULL,
  `postperm` text NOT NULL,
  `replyperm` text NOT NULL,
  `getattachperm` text NOT NULL,
  `postattachperm` text NOT NULL,
  `keywords` text NOT NULL,
  `supe_pushsetting` text NOT NULL,
  `modrecommend` text NOT NULL,
  `tradetypes` text NOT NULL,
  `typemodels` mediumtext NOT NULL,
  PRIMARY KEY  (`fid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_forumfields` */

insert  into `cdb_forumfields`(`fid`,`description`,`password`,`icon`,`postcredits`,`replycredits`,`getattachcredits`,`postattachcredits`,`digestcredits`,`redirect`,`attachextensions`,`formulaperm`,`moderators`,`rules`,`threadtypes`,`threadsorts`,`viewperm`,`postperm`,`replyperm`,`getattachperm`,`postattachperm`,`keywords`,`supe_pushsetting`,`modrecommend`,`tradetypes`,`typemodels`) values (1,'','','','','','','','','','','','','','','','','','','','','','','','',''),(2,'','','','','','','','','','','','','','','','','','','','','','','','','');

/*Table structure for table `cdb_forumlinks` */

DROP TABLE IF EXISTS `cdb_forumlinks`;

CREATE TABLE `cdb_forumlinks` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `displayorder` tinyint(3) NOT NULL default '0',
  `name` varchar(100) NOT NULL default '',
  `url` varchar(255) NOT NULL default '',
  `description` mediumtext NOT NULL,
  `logo` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_forumlinks` */

insert  into `cdb_forumlinks`(`id`,`displayorder`,`name`,`url`,`description`,`logo`) values (1,0,'Discuz! 官方论坛','http://www.discuz.net','提供最新 Discuz! 产品新闻、软件下载与技术交流','images/logo.gif');

/*Table structure for table `cdb_forumrecommend` */

DROP TABLE IF EXISTS `cdb_forumrecommend`;

CREATE TABLE `cdb_forumrecommend` (
  `fid` smallint(6) unsigned NOT NULL,
  `tid` mediumint(8) unsigned NOT NULL,
  `displayorder` tinyint(1) NOT NULL,
  `subject` char(80) NOT NULL,
  `author` char(15) NOT NULL,
  `authorid` mediumint(8) NOT NULL,
  `moderatorid` mediumint(8) NOT NULL,
  `expiration` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`tid`),
  KEY `displayorder` (`fid`,`displayorder`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_forumrecommend` */

/*Table structure for table `cdb_forums` */

DROP TABLE IF EXISTS `cdb_forums`;

CREATE TABLE `cdb_forums` (
  `fid` smallint(6) unsigned NOT NULL auto_increment,
  `fup` smallint(6) unsigned NOT NULL default '0',
  `type` enum('group','forum','sub') NOT NULL default 'forum',
  `name` char(50) NOT NULL default '',
  `status` tinyint(1) NOT NULL default '0',
  `displayorder` smallint(6) NOT NULL default '0',
  `styleid` smallint(6) unsigned NOT NULL default '0',
  `threads` mediumint(8) unsigned NOT NULL default '0',
  `posts` mediumint(8) unsigned NOT NULL default '0',
  `todayposts` mediumint(8) unsigned NOT NULL default '0',
  `lastpost` char(110) NOT NULL default '',
  `allowsmilies` tinyint(1) NOT NULL default '0',
  `allowhtml` tinyint(1) NOT NULL default '0',
  `allowbbcode` tinyint(1) NOT NULL default '0',
  `allowimgcode` tinyint(1) NOT NULL default '0',
  `allowmediacode` tinyint(1) NOT NULL default '0',
  `allowanonymous` tinyint(1) NOT NULL default '0',
  `allowshare` tinyint(1) NOT NULL default '0',
  `allowpostspecial` smallint(6) unsigned NOT NULL default '0',
  `allowspecialonly` tinyint(1) unsigned NOT NULL default '0',
  `alloweditrules` tinyint(1) NOT NULL default '0',
  `allowfeed` tinyint(1) NOT NULL default '1',
  `recyclebin` tinyint(1) NOT NULL default '0',
  `modnewposts` tinyint(1) NOT NULL default '0',
  `jammer` tinyint(1) NOT NULL default '0',
  `disablewatermark` tinyint(1) NOT NULL default '0',
  `inheritedmod` tinyint(1) NOT NULL default '0',
  `autoclose` smallint(6) NOT NULL default '0',
  `forumcolumns` tinyint(3) unsigned NOT NULL default '0',
  `threadcaches` tinyint(1) NOT NULL default '0',
  `alloweditpost` tinyint(1) unsigned NOT NULL default '1',
  `simple` tinyint(1) unsigned NOT NULL,
  `modworks` tinyint(1) unsigned NOT NULL,
  `allowtag` tinyint(1) NOT NULL default '1',
  `allowglobalstick` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`fid`),
  KEY `forum` (`status`,`type`,`displayorder`),
  KEY `fup` (`fup`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_forums` */

insert  into `cdb_forums`(`fid`,`fup`,`type`,`name`,`status`,`displayorder`,`styleid`,`threads`,`posts`,`todayposts`,`lastpost`,`allowsmilies`,`allowhtml`,`allowbbcode`,`allowimgcode`,`allowmediacode`,`allowanonymous`,`allowshare`,`allowpostspecial`,`allowspecialonly`,`alloweditrules`,`allowfeed`,`recyclebin`,`modnewposts`,`jammer`,`disablewatermark`,`inheritedmod`,`autoclose`,`forumcolumns`,`threadcaches`,`alloweditpost`,`simple`,`modworks`,`allowtag`,`allowglobalstick`) values (1,0,'group','Discuz!',1,0,0,0,0,0,'',0,0,1,1,1,0,1,63,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,1),(2,1,'forum','默认版块',1,0,0,0,0,0,'',1,0,1,1,1,0,1,63,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,1);

/*Table structure for table `cdb_imagetypes` */

DROP TABLE IF EXISTS `cdb_imagetypes`;

CREATE TABLE `cdb_imagetypes` (
  `typeid` smallint(6) unsigned NOT NULL auto_increment,
  `available` tinyint(1) NOT NULL default '0',
  `name` char(20) NOT NULL,
  `type` enum('smiley','icon','avatar') NOT NULL default 'smiley',
  `displayorder` tinyint(3) NOT NULL default '0',
  `directory` char(100) NOT NULL,
  PRIMARY KEY  (`typeid`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_imagetypes` */

insert  into `cdb_imagetypes`(`typeid`,`available`,`name`,`type`,`displayorder`,`directory`) values (1,1,'默认','smiley',1,'default'),(2,1,'酷猴','smiley',2,'coolmonkey'),(3,1,'呆呆男','smiley',3,'grapeman');

/*Table structure for table `cdb_invites` */

DROP TABLE IF EXISTS `cdb_invites`;

CREATE TABLE `cdb_invites` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `expiration` int(10) unsigned NOT NULL default '0',
  `inviteip` char(15) NOT NULL,
  `invitecode` char(16) NOT NULL,
  `reguid` mediumint(8) unsigned NOT NULL default '0',
  `regdateline` int(10) unsigned NOT NULL default '0',
  `status` tinyint(1) NOT NULL default '1',
  KEY `uid` (`uid`,`status`),
  KEY `invitecode` (`invitecode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_invites` */

/*Table structure for table `cdb_itempool` */

DROP TABLE IF EXISTS `cdb_itempool`;

CREATE TABLE `cdb_itempool` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `type` tinyint(1) unsigned NOT NULL,
  `question` text NOT NULL,
  `answer` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_itempool` */

/*Table structure for table `cdb_magiclog` */

DROP TABLE IF EXISTS `cdb_magiclog`;

CREATE TABLE `cdb_magiclog` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `magicid` smallint(6) unsigned NOT NULL default '0',
  `action` tinyint(1) NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `amount` smallint(6) unsigned NOT NULL default '0',
  `price` mediumint(8) unsigned NOT NULL default '0',
  `targettid` mediumint(8) unsigned NOT NULL default '0',
  `targetpid` int(10) unsigned NOT NULL default '0',
  `targetuid` mediumint(8) unsigned NOT NULL default '0',
  KEY `uid` (`uid`,`dateline`),
  KEY `targetuid` (`targetuid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_magiclog` */

/*Table structure for table `cdb_magicmarket` */

DROP TABLE IF EXISTS `cdb_magicmarket`;

CREATE TABLE `cdb_magicmarket` (
  `mid` smallint(6) unsigned NOT NULL auto_increment,
  `magicid` smallint(6) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(15) NOT NULL,
  `price` mediumint(8) unsigned NOT NULL default '0',
  `num` smallint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`mid`),
  KEY `num` (`magicid`,`num`),
  KEY `price` (`magicid`,`price`),
  KEY `uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_magicmarket` */

/*Table structure for table `cdb_magics` */

DROP TABLE IF EXISTS `cdb_magics`;

CREATE TABLE `cdb_magics` (
  `magicid` smallint(6) unsigned NOT NULL auto_increment,
  `available` tinyint(1) NOT NULL default '0',
  `type` tinyint(3) NOT NULL default '0',
  `name` varchar(50) NOT NULL,
  `identifier` varchar(40) NOT NULL,
  `description` varchar(255) NOT NULL,
  `displayorder` tinyint(3) NOT NULL default '0',
  `price` mediumint(8) unsigned NOT NULL default '0',
  `num` smallint(6) unsigned NOT NULL default '0',
  `salevolume` smallint(6) unsigned NOT NULL default '0',
  `supplytype` tinyint(1) NOT NULL default '0',
  `supplynum` smallint(6) unsigned NOT NULL default '0',
  `weight` tinyint(3) unsigned NOT NULL default '1',
  `filename` varchar(50) NOT NULL,
  `magicperm` text NOT NULL,
  PRIMARY KEY  (`magicid`),
  UNIQUE KEY `identifier` (`identifier`),
  KEY `displayorder` (`available`,`displayorder`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_magics` */

insert  into `cdb_magics`(`magicid`,`available`,`type`,`name`,`identifier`,`description`,`displayorder`,`price`,`num`,`salevolume`,`supplytype`,`supplynum`,`weight`,`filename`,`magicperm`) values (1,1,1,'变色卡','CCK','可以变换主题的颜色,并保存24小时',0,10,999,0,0,0,20,'magic_color.inc.php',''),(2,1,3,'金钱卡','MOK','可以随机获得一些金币',0,10,999,0,0,0,30,'magic_money.inc.php',''),(3,1,1,'IP卡','SEK','可以查看帖子作者的IP',0,15,999,0,0,0,30,'magic_see.inc.php',''),(4,1,1,'提升卡','UPK','可以提升某个主题',0,10,999,0,0,0,30,'magic_up.inc.php',''),(5,1,1,'置顶卡','TOK','可以将主题置顶24小时',0,20,999,0,0,0,40,'magic_top.inc.php',''),(6,1,1,'悔悟卡','REK','可以删除自己的帖子',0,10,999,0,0,0,30,'magic_del.inc.php',''),(7,1,2,'狗仔卡','RTK','查看某个用户是否在线',0,15,999,0,0,0,30,'magic_reporter.inc.php',''),(8,1,1,'沉默卡','CLK','24小时内不能回复',0,15,999,0,0,0,30,'magic_close.inc.php',''),(9,1,1,'喧嚣卡','OPK','使贴子可以回复',0,15,999,0,0,0,30,'magic_open.inc.php',''),(10,1,1,'隐身卡','YSK','可以将自己的帖子匿名',0,20,999,0,0,0,30,'magic_hidden.inc.php',''),(11,1,1,'恢复卡','CBK','将匿名恢复为正常显示的用户名,匿名终结者',0,15,999,0,0,0,20,'magic_renew.inc.php',''),(12,1,1,'移动卡','MVK','可将自已的帖子移动到其他版面（隐含、特殊限定版面除外）',0,50,989,0,0,0,50,'magic_move.inc.php','');

/*Table structure for table `cdb_medallog` */

DROP TABLE IF EXISTS `cdb_medallog`;

CREATE TABLE `cdb_medallog` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `medalid` smallint(6) unsigned NOT NULL default '0',
  `type` tinyint(1) NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `expiration` int(10) unsigned NOT NULL default '0',
  `status` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `type` (`type`),
  KEY `status` (`status`,`expiration`),
  KEY `uid` (`uid`,`medalid`,`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_medallog` */

/*Table structure for table `cdb_medals` */

DROP TABLE IF EXISTS `cdb_medals`;

CREATE TABLE `cdb_medals` (
  `medalid` smallint(6) unsigned NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `available` tinyint(1) NOT NULL default '0',
  `image` varchar(255) NOT NULL default '',
  `type` tinyint(1) NOT NULL default '0',
  `displayorder` tinyint(3) NOT NULL default '0',
  `description` varchar(255) NOT NULL,
  `expiration` smallint(6) unsigned NOT NULL default '0',
  `permission` mediumtext NOT NULL,
  PRIMARY KEY  (`medalid`),
  KEY `displayorder` (`displayorder`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_medals` */

insert  into `cdb_medals`(`medalid`,`name`,`available`,`image`,`type`,`displayorder`,`description`,`expiration`,`permission`) values (1,'Medal No.1',0,'medal1.gif',0,0,'',0,''),(2,'Medal No.2',0,'medal2.gif',0,0,'',0,''),(3,'Medal No.3',0,'medal3.gif',0,0,'',0,''),(4,'Medal No.4',0,'medal4.gif',0,0,'',0,''),(5,'Medal No.5',0,'medal5.gif',0,0,'',0,''),(6,'Medal No.6',0,'medal6.gif',0,0,'',0,''),(7,'Medal No.7',0,'medal7.gif',0,0,'',0,''),(8,'Medal No.8',0,'medal8.gif',0,0,'',0,''),(9,'Medal No.9',0,'medal9.gif',0,0,'',0,''),(10,'Medal No.10',0,'medal10.gif',0,0,'',0,'');

/*Table structure for table `cdb_memberfields` */

DROP TABLE IF EXISTS `cdb_memberfields`;

CREATE TABLE `cdb_memberfields` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `nickname` varchar(30) NOT NULL default '',
  `site` varchar(75) NOT NULL default '',
  `alipay` varchar(50) NOT NULL default '',
  `icq` varchar(12) NOT NULL default '',
  `qq` varchar(12) NOT NULL default '',
  `yahoo` varchar(40) NOT NULL default '',
  `msn` varchar(100) NOT NULL default '',
  `taobao` varchar(40) NOT NULL default '',
  `location` varchar(30) NOT NULL default '',
  `customstatus` varchar(30) NOT NULL default '',
  `medals` text NOT NULL,
  `avatar` varchar(255) NOT NULL default '',
  `avatarwidth` tinyint(3) unsigned NOT NULL default '0',
  `avatarheight` tinyint(3) unsigned NOT NULL default '0',
  `bio` text NOT NULL,
  `sightml` text NOT NULL,
  `ignorepm` text NOT NULL,
  `groupterms` text NOT NULL,
  `authstr` varchar(20) NOT NULL default '',
  `spacename` varchar(40) NOT NULL,
  `buyercredit` smallint(6) NOT NULL default '0',
  `sellercredit` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_memberfields` */

insert  into `cdb_memberfields`(`uid`,`nickname`,`site`,`alipay`,`icq`,`qq`,`yahoo`,`msn`,`taobao`,`location`,`customstatus`,`medals`,`avatar`,`avatarwidth`,`avatarheight`,`bio`,`sightml`,`ignorepm`,`groupterms`,`authstr`,`spacename`,`buyercredit`,`sellercredit`) values (1,'','','','','','','','','','','','',0,0,'','','','','','',0,0);

/*Table structure for table `cdb_membermagics` */

DROP TABLE IF EXISTS `cdb_membermagics`;

CREATE TABLE `cdb_membermagics` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `magicid` smallint(6) unsigned NOT NULL default '0',
  `num` smallint(6) unsigned NOT NULL default '0',
  KEY `uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_membermagics` */

/*Table structure for table `cdb_members` */

DROP TABLE IF EXISTS `cdb_members`;

CREATE TABLE `cdb_members` (
  `uid` mediumint(8) unsigned NOT NULL auto_increment,
  `username` char(15) NOT NULL default '',
  `password` char(32) NOT NULL default '',
  `secques` char(8) NOT NULL default '',
  `gender` tinyint(1) NOT NULL default '0',
  `adminid` tinyint(1) NOT NULL default '0',
  `groupid` smallint(6) unsigned NOT NULL default '0',
  `groupexpiry` int(10) unsigned NOT NULL default '0',
  `extgroupids` char(20) NOT NULL default '',
  `regip` char(15) NOT NULL default '',
  `regdate` int(10) unsigned NOT NULL default '0',
  `lastip` char(15) NOT NULL default '',
  `lastvisit` int(10) unsigned NOT NULL default '0',
  `lastactivity` int(10) unsigned NOT NULL default '0',
  `lastpost` int(10) unsigned NOT NULL default '0',
  `posts` mediumint(8) unsigned NOT NULL default '0',
  `digestposts` smallint(6) unsigned NOT NULL default '0',
  `oltime` smallint(6) unsigned NOT NULL default '0',
  `pageviews` mediumint(8) unsigned NOT NULL default '0',
  `credits` int(10) NOT NULL default '0',
  `extcredits1` int(10) NOT NULL default '0',
  `extcredits2` int(10) NOT NULL default '0',
  `extcredits3` int(10) NOT NULL default '0',
  `extcredits4` int(10) NOT NULL default '0',
  `extcredits5` int(10) NOT NULL default '0',
  `extcredits6` int(10) NOT NULL default '0',
  `extcredits7` int(10) NOT NULL default '0',
  `extcredits8` int(10) NOT NULL default '0',
  `email` char(40) NOT NULL default '',
  `bday` date NOT NULL default '0000-00-00',
  `sigstatus` tinyint(1) NOT NULL default '0',
  `tpp` tinyint(3) unsigned NOT NULL default '0',
  `ppp` tinyint(3) unsigned NOT NULL default '0',
  `styleid` smallint(6) unsigned NOT NULL default '0',
  `dateformat` tinyint(1) NOT NULL default '0',
  `timeformat` tinyint(1) NOT NULL default '0',
  `pmsound` tinyint(1) NOT NULL default '0',
  `showemail` tinyint(1) NOT NULL default '0',
  `newsletter` tinyint(1) NOT NULL default '0',
  `invisible` tinyint(1) NOT NULL default '0',
  `timeoffset` char(4) NOT NULL default '',
  `prompt` tinyint(1) NOT NULL default '0',
  `accessmasks` tinyint(1) NOT NULL default '0',
  `editormode` tinyint(1) unsigned NOT NULL default '2',
  `customshow` tinyint(1) unsigned NOT NULL default '26',
  `xspacestatus` tinyint(1) NOT NULL default '0',
  `customaddfeed` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `username` (`username`),
  KEY `email` (`email`),
  KEY `groupid` (`groupid`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_members` */

insert  into `cdb_members`(`uid`,`username`,`password`,`secques`,`gender`,`adminid`,`groupid`,`groupexpiry`,`extgroupids`,`regip`,`regdate`,`lastip`,`lastvisit`,`lastactivity`,`lastpost`,`posts`,`digestposts`,`oltime`,`pageviews`,`credits`,`extcredits1`,`extcredits2`,`extcredits3`,`extcredits4`,`extcredits5`,`extcredits6`,`extcredits7`,`extcredits8`,`email`,`bday`,`sigstatus`,`tpp`,`ppp`,`styleid`,`dateformat`,`timeformat`,`pmsound`,`showemail`,`newsletter`,`invisible`,`timeoffset`,`prompt`,`accessmasks`,`editormode`,`customshow`,`xspacestatus`,`customaddfeed`) values (1,'admin','56f0e23499d00c51d7a6d1ec895b3305','',0,1,1,0,'','hidden',1256533861,'',1256533861,0,1256533861,0,0,0,0,0,0,0,0,0,0,0,0,0,'ramen.sh@gmail.com','0000-00-00',0,0,0,0,0,0,0,1,1,0,'9999',0,0,2,26,0,0);

/*Table structure for table `cdb_memberspaces` */

DROP TABLE IF EXISTS `cdb_memberspaces`;

CREATE TABLE `cdb_memberspaces` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `style` char(20) NOT NULL,
  `description` char(100) NOT NULL,
  `layout` char(200) NOT NULL,
  `side` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_memberspaces` */

/*Table structure for table `cdb_moderators` */

DROP TABLE IF EXISTS `cdb_moderators`;

CREATE TABLE `cdb_moderators` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `fid` smallint(6) unsigned NOT NULL default '0',
  `displayorder` tinyint(3) NOT NULL default '0',
  `inherited` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`uid`,`fid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_moderators` */

/*Table structure for table `cdb_modworks` */

DROP TABLE IF EXISTS `cdb_modworks`;

CREATE TABLE `cdb_modworks` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `modaction` char(3) NOT NULL default '',
  `dateline` date NOT NULL default '2006-01-01',
  `count` smallint(6) unsigned NOT NULL default '0',
  `posts` smallint(6) unsigned NOT NULL default '0',
  KEY `uid` (`uid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_modworks` */

/*Table structure for table `cdb_myposts` */

DROP TABLE IF EXISTS `cdb_myposts`;

CREATE TABLE `cdb_myposts` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `pid` int(10) unsigned NOT NULL default '0',
  `position` smallint(6) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `special` tinyint(1) unsigned NOT NULL default '0',
  PRIMARY KEY  (`uid`,`tid`),
  KEY `tid` (`tid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_myposts` */

/*Table structure for table `cdb_mytasks` */

DROP TABLE IF EXISTS `cdb_mytasks`;

CREATE TABLE `cdb_mytasks` (
  `uid` mediumint(8) unsigned NOT NULL,
  `username` char(15) NOT NULL default '',
  `taskid` smallint(6) unsigned NOT NULL,
  `status` tinyint(1) NOT NULL default '0',
  `csc` char(255) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`uid`,`taskid`),
  KEY `parter` (`taskid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_mytasks` */

/*Table structure for table `cdb_mythreads` */

DROP TABLE IF EXISTS `cdb_mythreads`;

CREATE TABLE `cdb_mythreads` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `special` tinyint(1) unsigned NOT NULL default '0',
  `dateline` int(10) NOT NULL default '0',
  PRIMARY KEY  (`uid`,`tid`),
  KEY `tid` (`tid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_mythreads` */

/*Table structure for table `cdb_navs` */

DROP TABLE IF EXISTS `cdb_navs`;

CREATE TABLE `cdb_navs` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `parentid` smallint(6) unsigned NOT NULL default '0',
  `name` char(50) NOT NULL,
  `title` char(255) NOT NULL,
  `url` char(255) NOT NULL,
  `target` tinyint(1) NOT NULL default '0',
  `type` tinyint(1) NOT NULL default '0',
  `available` tinyint(1) NOT NULL default '0',
  `displayorder` tinyint(3) NOT NULL,
  `highlight` tinyint(1) NOT NULL default '0',
  `level` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_navs` */

insert  into `cdb_navs`(`id`,`parentid`,`name`,`title`,`url`,`target`,`type`,`available`,`displayorder`,`highlight`,`level`) values (1,0,'论坛','','#',0,0,1,1,0,0),(2,0,'搜索','','search.php',0,0,1,2,0,0),(3,0,'插件','','#',0,0,1,4,0,0),(4,0,'帮助','','faq.php',0,0,1,5,0,0),(5,0,'导航','','#',0,0,1,6,0,0);

/*Table structure for table `cdb_onlinelist` */

DROP TABLE IF EXISTS `cdb_onlinelist`;

CREATE TABLE `cdb_onlinelist` (
  `groupid` smallint(6) unsigned NOT NULL default '0',
  `displayorder` tinyint(3) NOT NULL default '0',
  `title` varchar(30) NOT NULL default '',
  `url` varchar(30) NOT NULL default ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_onlinelist` */

insert  into `cdb_onlinelist`(`groupid`,`displayorder`,`title`,`url`) values (1,1,'管理员','online_admin.gif'),(2,2,'超级版主','online_supermod.gif'),(3,3,'版主','online_moderator.gif'),(0,4,'会员','online_member.gif');

/*Table structure for table `cdb_onlinetime` */

DROP TABLE IF EXISTS `cdb_onlinetime`;

CREATE TABLE `cdb_onlinetime` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `thismonth` smallint(6) unsigned NOT NULL default '0',
  `total` mediumint(8) unsigned NOT NULL default '0',
  `lastupdate` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_onlinetime` */

insert  into `cdb_onlinetime`(`uid`,`thismonth`,`total`,`lastupdate`) values (1,10,60,1170601084);

/*Table structure for table `cdb_orders` */

DROP TABLE IF EXISTS `cdb_orders`;

CREATE TABLE `cdb_orders` (
  `orderid` char(32) NOT NULL default '',
  `status` char(3) NOT NULL default '',
  `buyer` char(50) NOT NULL default '',
  `admin` char(15) NOT NULL default '',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `amount` int(10) unsigned NOT NULL default '0',
  `price` float(7,2) unsigned NOT NULL default '0.00',
  `submitdate` int(10) unsigned NOT NULL default '0',
  `confirmdate` int(10) unsigned NOT NULL default '0',
  UNIQUE KEY `orderid` (`orderid`),
  KEY `submitdate` (`submitdate`),
  KEY `uid` (`uid`,`submitdate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_orders` */

/*Table structure for table `cdb_paymentlog` */

DROP TABLE IF EXISTS `cdb_paymentlog`;

CREATE TABLE `cdb_paymentlog` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `authorid` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `amount` int(10) unsigned NOT NULL default '0',
  `netamount` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`tid`,`uid`),
  KEY `uid` (`uid`),
  KEY `authorid` (`authorid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_paymentlog` */

/*Table structure for table `cdb_pluginhooks` */

DROP TABLE IF EXISTS `cdb_pluginhooks`;

CREATE TABLE `cdb_pluginhooks` (
  `pluginhookid` mediumint(8) unsigned NOT NULL auto_increment,
  `pluginid` smallint(6) unsigned NOT NULL default '0',
  `available` tinyint(1) NOT NULL default '0',
  `title` varchar(255) NOT NULL default '',
  `description` mediumtext NOT NULL,
  `code` mediumtext NOT NULL,
  PRIMARY KEY  (`pluginhookid`),
  KEY `pluginid` (`pluginid`),
  KEY `available` (`available`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_pluginhooks` */

/*Table structure for table `cdb_plugins` */

DROP TABLE IF EXISTS `cdb_plugins`;

CREATE TABLE `cdb_plugins` (
  `pluginid` smallint(6) unsigned NOT NULL auto_increment,
  `available` tinyint(1) NOT NULL default '0',
  `adminid` tinyint(1) unsigned NOT NULL default '0',
  `name` varchar(40) NOT NULL default '',
  `identifier` varchar(40) NOT NULL default '',
  `description` varchar(255) NOT NULL default '',
  `datatables` varchar(255) NOT NULL default '',
  `directory` varchar(100) NOT NULL default '',
  `copyright` varchar(100) NOT NULL default '',
  `modules` text NOT NULL,
  PRIMARY KEY  (`pluginid`),
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_plugins` */

/*Table structure for table `cdb_pluginvars` */

DROP TABLE IF EXISTS `cdb_pluginvars`;

CREATE TABLE `cdb_pluginvars` (
  `pluginvarid` mediumint(8) unsigned NOT NULL auto_increment,
  `pluginid` smallint(6) unsigned NOT NULL default '0',
  `displayorder` tinyint(3) NOT NULL default '0',
  `title` varchar(100) NOT NULL default '',
  `description` varchar(255) NOT NULL default '',
  `variable` varchar(40) NOT NULL default '',
  `type` varchar(20) NOT NULL default 'text',
  `value` text NOT NULL,
  `extra` text NOT NULL,
  PRIMARY KEY  (`pluginvarid`),
  KEY `pluginid` (`pluginid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_pluginvars` */

/*Table structure for table `cdb_polloptions` */

DROP TABLE IF EXISTS `cdb_polloptions`;

CREATE TABLE `cdb_polloptions` (
  `polloptionid` int(10) unsigned NOT NULL auto_increment,
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `votes` mediumint(8) unsigned NOT NULL default '0',
  `displayorder` tinyint(3) NOT NULL default '0',
  `polloption` varchar(80) NOT NULL default '',
  `voterids` mediumtext NOT NULL,
  PRIMARY KEY  (`polloptionid`),
  KEY `tid` (`tid`,`displayorder`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_polloptions` */

/*Table structure for table `cdb_polls` */

DROP TABLE IF EXISTS `cdb_polls`;

CREATE TABLE `cdb_polls` (
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `overt` tinyint(1) NOT NULL default '0',
  `multiple` tinyint(1) NOT NULL default '0',
  `visible` tinyint(1) NOT NULL default '0',
  `maxchoices` tinyint(3) unsigned NOT NULL default '0',
  `expiration` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`tid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_polls` */

/*Table structure for table `cdb_posts` */

DROP TABLE IF EXISTS `cdb_posts`;

CREATE TABLE `cdb_posts` (
  `pid` int(10) unsigned NOT NULL auto_increment,
  `fid` smallint(6) unsigned NOT NULL default '0',
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `first` tinyint(1) NOT NULL default '0',
  `author` varchar(15) NOT NULL default '',
  `authorid` mediumint(8) unsigned NOT NULL default '0',
  `subject` varchar(80) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `message` mediumtext NOT NULL,
  `useip` varchar(15) NOT NULL default '',
  `invisible` tinyint(1) NOT NULL default '0',
  `anonymous` tinyint(1) NOT NULL default '0',
  `usesig` tinyint(1) NOT NULL default '0',
  `htmlon` tinyint(1) NOT NULL default '0',
  `bbcodeoff` tinyint(1) NOT NULL default '0',
  `smileyoff` tinyint(1) NOT NULL default '0',
  `parseurloff` tinyint(1) NOT NULL default '0',
  `attachment` tinyint(1) NOT NULL default '0',
  `rate` smallint(6) NOT NULL default '0',
  `ratetimes` tinyint(3) unsigned NOT NULL default '0',
  `status` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`pid`),
  KEY `fid` (`fid`),
  KEY `authorid` (`authorid`),
  KEY `dateline` (`dateline`),
  KEY `invisible` (`invisible`),
  KEY `displayorder` (`tid`,`invisible`,`dateline`),
  KEY `first` (`tid`,`first`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_posts` */

/*Table structure for table `cdb_profilefields` */

DROP TABLE IF EXISTS `cdb_profilefields`;

CREATE TABLE `cdb_profilefields` (
  `fieldid` smallint(6) unsigned NOT NULL auto_increment,
  `available` tinyint(1) NOT NULL default '0',
  `invisible` tinyint(1) NOT NULL default '0',
  `title` varchar(50) NOT NULL default '',
  `description` varchar(255) NOT NULL default '',
  `size` tinyint(3) unsigned NOT NULL default '0',
  `displayorder` smallint(6) NOT NULL default '0',
  `required` tinyint(1) NOT NULL default '0',
  `unchangeable` tinyint(1) NOT NULL default '0',
  `showinthread` tinyint(1) NOT NULL default '0',
  `selective` tinyint(1) NOT NULL default '0',
  `choices` text NOT NULL,
  PRIMARY KEY  (`fieldid`),
  KEY `available` (`available`,`required`,`displayorder`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_profilefields` */

/*Table structure for table `cdb_projects` */

DROP TABLE IF EXISTS `cdb_projects`;

CREATE TABLE `cdb_projects` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  `type` varchar(10) NOT NULL,
  `description` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `type` (`type`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_projects` */

insert  into `cdb_projects`(`id`,`name`,`type`,`description`,`value`) values (1,'技术性论坛','extcredit','如果您不希望会员通过灌水、页面访问等方式得到积分，而是需要发布一些技术性的帖子获得积分。','a:4:{s:10:\"savemethod\";a:2:{i:0;s:1:\"1\";i:1;s:1:\"2\";}s:14:\"creditsformula\";s:49:\"posts*0.5+digestposts*5+extcredits1*2+extcredits2\";s:13:\"creditspolicy\";s:299:\"a:12:{s:4:\"post\";a:0:{}s:5:\"reply\";a:0:{}s:6:\"digest\";a:1:{i:1;i:10;}s:10:\"postattach\";a:0:{}s:9:\"getattach\";a:0:{}s:2:\"pm\";a:0:{}s:6:\"search\";a:0:{}s:15:\"promotion_visit\";a:1:{i:3;i:2;}s:18:\"promotion_register\";a:1:{i:3;i:2;}s:13:\"tradefinished\";a:0:{}s:8:\"votepoll\";a:0:{}s:10:\"lowerlimit\";a:0:{}}\";s:10:\"extcredits\";s:1444:\"a:8:{i:1;a:8:{s:5:\"title\";s:4:\"威望\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:2;a:8:{s:5:\"title\";s:4:\"金钱\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:3;a:8:{s:5:\"title\";s:4:\"贡献\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:4;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:5;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:6;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:7;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:8;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}}\";}'),(2,'娱乐性论坛','extcredit','此类型论坛的会员可以通过发布一些评论、回复等获得积分，同时扩大论坛的访问量。更重要的是希望会员发布一些有价值的娱乐新闻等。','a:4:{s:10:\"savemethod\";a:2:{i:0;s:1:\"1\";i:1;s:1:\"2\";}s:14:\"creditsformula\";s:81:\"posts+digestposts*5+oltime*5+pageviews/1000+extcredits1*2+extcredits2+extcredits3\";s:13:\"creditspolicy\";s:315:\"a:12:{s:4:\"post\";a:1:{i:1;i:1;}s:5:\"reply\";a:1:{i:2;i:1;}s:6:\"digest\";a:1:{i:1;i:10;}s:10:\"postattach\";a:0:{}s:9:\"getattach\";a:0:{}s:2:\"pm\";a:0:{}s:6:\"search\";a:0:{}s:15:\"promotion_visit\";a:1:{i:3;i:2;}s:18:\"promotion_register\";a:1:{i:3;i:2;}s:13:\"tradefinished\";a:0:{}s:8:\"votepoll\";a:0:{}s:10:\"lowerlimit\";a:0:{}}\";s:10:\"extcredits\";s:1036:\"a:8:{i:1;a:6:{s:5:\"title\";s:4:\"威望\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;}i:2;a:6:{s:5:\"title\";s:4:\"金钱\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;}i:3;a:6:{s:5:\"title\";s:4:\"贡献\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;}i:4;a:6:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;}i:5;a:6:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;}i:6;a:6:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;}i:7;a:6:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;}i:8;a:6:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;}}\";}'),(3,'动漫、摄影类论坛','extcredit','此类型论坛需要更多的图片附件发布给广大会员，因此增加一项扩展积分：魅力。','a:4:{s:10:\"savemethod\";a:2:{i:0;s:1:\"1\";i:1;s:1:\"2\";}s:14:\"creditsformula\";s:86:\"posts+digestposts*2+pageviews/2000+extcredits1*2+extcredits2+extcredits3+extcredits4*3\";s:13:\"creditspolicy\";s:324:\"a:12:{s:4:\"post\";a:1:{i:2;i:1;}s:5:\"reply\";a:0:{}s:6:\"digest\";a:1:{i:1;i:10;}s:10:\"postattach\";a:1:{i:4;i:3;}s:9:\"getattach\";a:1:{i:2;i:-2;}s:2:\"pm\";a:0:{}s:6:\"search\";a:0:{}s:15:\"promotion_visit\";a:1:{i:3;i:2;}s:18:\"promotion_register\";a:1:{i:3;i:2;}s:13:\"tradefinished\";a:0:{}s:8:\"votepoll\";a:0:{}s:10:\"lowerlimit\";a:0:{}}\";s:10:\"extcredits\";s:1454:\"a:8:{i:1;a:8:{s:5:\"title\";s:4:\"威望\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:2;a:8:{s:5:\"title\";s:4:\"金钱\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:3;a:8:{s:5:\"title\";s:4:\"贡献\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:4;a:8:{s:5:\"title\";s:4:\"魅力\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:5;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:6;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:7;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:8;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}}\";}'),(4,'文章、小说类论坛','extcredit','此类型的论坛更重视会员的原创文章或者是转发的文章，因此增加一项扩展积分：文采。','a:4:{s:10:\"savemethod\";a:2:{i:0;s:1:\"1\";i:1;s:1:\"2\";}s:14:\"creditsformula\";s:57:\"posts+digestposts*8+extcredits2+extcredits3+extcredits4*2\";s:13:\"creditspolicy\";s:307:\"a:12:{s:4:\"post\";a:1:{i:2;i:1;}s:5:\"reply\";a:0:{}s:6:\"digest\";a:1:{i:4;i:10;}s:10:\"postattach\";a:0:{}s:9:\"getattach\";a:0:{}s:2:\"pm\";a:0:{}s:6:\"search\";a:0:{}s:15:\"promotion_visit\";a:1:{i:3;i:2;}s:18:\"promotion_register\";a:1:{i:3;i:2;}s:13:\"tradefinished\";a:0:{}s:8:\"votepoll\";a:0:{}s:10:\"lowerlimit\";a:0:{}}\";s:10:\"extcredits\";s:1454:\"a:8:{i:1;a:8:{s:5:\"title\";s:4:\"威望\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:2;a:8:{s:5:\"title\";s:4:\"金钱\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:3;a:8:{s:5:\"title\";s:4:\"贡献\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:4;a:8:{s:5:\"title\";s:4:\"文采\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:5;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:6;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:7;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:8;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}}\";}'),(5,'调研性论坛','extcredit','此类型论坛更期望的是得到会员的建议和意见，主要是通过投票的方式体现会员的建议，因此增加一项积分策略为：参加投票，增加一项扩展积分为：积极性。','a:4:{s:10:\"savemethod\";a:2:{i:0;s:1:\"1\";i:1;s:1:\"2\";}s:14:\"creditsformula\";s:63:\"posts*0.5+digestposts*2+extcredits1*2+extcredits3+extcredits4*2\";s:13:\"creditspolicy\";s:306:\"a:12:{s:4:\"post\";a:0:{}s:5:\"reply\";a:0:{}s:6:\"digest\";a:1:{i:1;i:8;}s:10:\"postattach\";a:0:{}s:9:\"getattach\";a:0:{}s:2:\"pm\";a:0:{}s:6:\"search\";a:0:{}s:15:\"promotion_visit\";a:1:{i:3;i:2;}s:18:\"promotion_register\";a:1:{i:3;i:2;}s:13:\"tradefinished\";a:0:{}s:8:\"votepoll\";a:1:{i:4;i:5;}s:10:\"lowerlimit\";a:0:{}}\";s:10:\"extcredits\";s:1456:\"a:8:{i:1;a:8:{s:5:\"title\";s:4:\"威望\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:2;a:8:{s:5:\"title\";s:4:\"金钱\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:3;a:8:{s:5:\"title\";s:4:\"贡献\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:4;a:8:{s:5:\"title\";s:6:\"积极性\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:5;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:6;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:7;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:8;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}}\";}'),(6,'贸易性论坛','extcredit','此类型论坛更注重的是会员之间的交易，因此使用积分策略：交易成功，增加一项扩展积分：诚信度。','a:4:{s:10:\"savemethod\";a:2:{i:0;s:1:\"1\";i:1;s:1:\"2\";}s:14:\"creditsformula\";s:55:\"posts+digestposts+extcredits1*2+extcredits3+extcredits4\";s:13:\"creditspolicy\";s:306:\"a:12:{s:4:\"post\";a:0:{}s:5:\"reply\";a:0:{}s:6:\"digest\";a:1:{i:1;i:5;}s:10:\"postattach\";a:0:{}s:9:\"getattach\";a:0:{}s:2:\"pm\";a:0:{}s:6:\"search\";a:0:{}s:15:\"promotion_visit\";a:1:{i:3;i:2;}s:18:\"promotion_register\";a:1:{i:3;i:2;}s:13:\"tradefinished\";a:1:{i:4;i:6;}s:8:\"votepoll\";a:0:{}s:10:\"lowerlimit\";a:0:{}}\";s:10:\"extcredits\";s:1456:\"a:8:{i:1;a:8:{s:5:\"title\";s:4:\"威望\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:2;a:8:{s:5:\"title\";s:4:\"金钱\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:3;a:8:{s:5:\"title\";s:4:\"贡献\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:4;a:8:{s:5:\"title\";s:6:\"诚信度\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";s:1:\"1\";s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:5;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:6;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:7;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}i:8;a:8:{s:5:\"title\";s:0:\"\";s:4:\"unit\";s:0:\"\";s:5:\"ratio\";i:0;s:9:\"available\";N;s:10:\"lowerlimit\";i:0;s:12:\"showinthread\";N;s:15:\"allowexchangein\";N;s:16:\"allowexchangeout\";N;}}\";}'),(7,'坛内事务类版块','forum','该板块设置了不允许其他模块共享，以及设置了需要很高的权限才能浏览该版块。也适合于保密性高版块。','a:33:{s:7:\"styleid\";s:1:\"0\";s:12:\"allowsmilies\";s:1:\"1\";s:9:\"allowhtml\";s:1:\"0\";s:11:\"allowbbcode\";s:1:\"1\";s:12:\"allowimgcode\";s:1:\"1\";s:14:\"allowanonymous\";s:1:\"0\";s:10:\"allowshare\";s:1:\"0\";s:16:\"allowpostspecial\";s:1:\"0\";s:14:\"alloweditrules\";s:1:\"1\";s:10:\"recyclebin\";s:1:\"1\";s:11:\"modnewposts\";s:1:\"0\";s:6:\"jammer\";s:1:\"0\";s:16:\"disablewatermark\";s:1:\"0\";s:12:\"inheritedmod\";s:1:\"0\";s:9:\"autoclose\";s:1:\"0\";s:12:\"forumcolumns\";s:1:\"0\";s:12:\"threadcaches\";s:2:\"40\";s:16:\"allowpaytoauthor\";s:1:\"0\";s:13:\"alloweditpost\";s:1:\"1\";s:6:\"simple\";s:1:\"0\";s:11:\"postcredits\";s:0:\"\";s:12:\"replycredits\";s:0:\"\";s:16:\"getattachcredits\";s:0:\"\";s:17:\"postattachcredits\";s:0:\"\";s:13:\"digestcredits\";s:0:\"\";s:16:\"attachextensions\";s:0:\"\";s:11:\"threadtypes\";s:0:\"\";s:8:\"viewperm\";s:7:\"	1	2	3	\";s:8:\"postperm\";s:7:\"	1	2	3	\";s:9:\"replyperm\";s:7:\"	1	2	3	\";s:13:\"getattachperm\";s:7:\"	1	2	3	\";s:14:\"postattachperm\";s:7:\"	1	2	3	\";s:16:\"supe_pushsetting\";s:0:\"\";}'),(8,'技术交流类版块','forum','该设置开启了主题缓存系数。其他的权限设置级别较低。','a:33:{s:7:\"styleid\";s:1:\"0\";s:12:\"allowsmilies\";s:1:\"1\";s:9:\"allowhtml\";s:1:\"0\";s:11:\"allowbbcode\";s:1:\"1\";s:12:\"allowimgcode\";s:1:\"1\";s:14:\"allowanonymous\";s:1:\"0\";s:10:\"allowshare\";s:1:\"1\";s:16:\"allowpostspecial\";s:1:\"5\";s:14:\"alloweditrules\";s:1:\"0\";s:10:\"recyclebin\";s:1:\"1\";s:11:\"modnewposts\";s:1:\"0\";s:6:\"jammer\";s:1:\"0\";s:16:\"disablewatermark\";s:1:\"0\";s:12:\"inheritedmod\";s:1:\"0\";s:9:\"autoclose\";s:1:\"0\";s:12:\"forumcolumns\";s:1:\"0\";s:12:\"threadcaches\";s:2:\"40\";s:16:\"allowpaytoauthor\";s:1:\"1\";s:13:\"alloweditpost\";s:1:\"1\";s:6:\"simple\";s:1:\"0\";s:11:\"postcredits\";s:0:\"\";s:12:\"replycredits\";s:0:\"\";s:16:\"getattachcredits\";s:0:\"\";s:17:\"postattachcredits\";s:0:\"\";s:13:\"digestcredits\";s:0:\"\";s:16:\"attachextensions\";s:0:\"\";s:11:\"threadtypes\";s:0:\"\";s:8:\"viewperm\";s:0:\"\";s:8:\"postperm\";s:0:\"\";s:9:\"replyperm\";s:0:\"\";s:13:\"getattachperm\";s:0:\"\";s:14:\"postattachperm\";s:0:\"\";s:16:\"supe_pushsetting\";s:0:\"\";}'),(9,'发布公告类版块','forum','该设置开启了发帖审核，限制了允许发帖的用户组。','a:33:{s:7:\"styleid\";s:1:\"0\";s:12:\"allowsmilies\";s:1:\"1\";s:9:\"allowhtml\";s:1:\"0\";s:11:\"allowbbcode\";s:1:\"1\";s:12:\"allowimgcode\";s:1:\"1\";s:14:\"allowanonymous\";s:1:\"0\";s:10:\"allowshare\";s:1:\"1\";s:16:\"allowpostspecial\";s:1:\"1\";s:14:\"alloweditrules\";s:1:\"0\";s:10:\"recyclebin\";s:1:\"1\";s:11:\"modnewposts\";s:1:\"1\";s:6:\"jammer\";s:1:\"1\";s:16:\"disablewatermark\";s:1:\"0\";s:12:\"inheritedmod\";s:1:\"0\";s:9:\"autoclose\";s:1:\"0\";s:12:\"forumcolumns\";s:1:\"0\";s:12:\"threadcaches\";s:1:\"0\";s:16:\"allowpaytoauthor\";s:1:\"1\";s:13:\"alloweditpost\";s:1:\"0\";s:6:\"simple\";s:1:\"0\";s:11:\"postcredits\";s:0:\"\";s:12:\"replycredits\";s:0:\"\";s:16:\"getattachcredits\";s:0:\"\";s:17:\"postattachcredits\";s:0:\"\";s:13:\"digestcredits\";s:0:\"\";s:16:\"attachextensions\";s:0:\"\";s:11:\"threadtypes\";s:0:\"\";s:8:\"viewperm\";s:0:\"\";s:8:\"postperm\";s:7:\"	1	2	3	\";s:9:\"replyperm\";s:0:\"\";s:13:\"getattachperm\";s:0:\"\";s:14:\"postattachperm\";s:0:\"\";s:16:\"supe_pushsetting\";s:0:\"\";}'),(10,'发起活动类版块','forum','该类型设置里发起主题一个月之后会自动关闭主题。','a:33:{s:7:\"styleid\";s:1:\"0\";s:12:\"allowsmilies\";s:1:\"1\";s:9:\"allowhtml\";s:1:\"0\";s:11:\"allowbbcode\";s:1:\"1\";s:12:\"allowimgcode\";s:1:\"1\";s:14:\"allowanonymous\";s:1:\"0\";s:10:\"allowshare\";s:1:\"1\";s:16:\"allowpostspecial\";s:1:\"9\";s:14:\"alloweditrules\";s:1:\"0\";s:10:\"recyclebin\";s:1:\"1\";s:11:\"modnewposts\";s:1:\"0\";s:6:\"jammer\";s:1:\"0\";s:16:\"disablewatermark\";s:1:\"0\";s:12:\"inheritedmod\";s:1:\"1\";s:9:\"autoclose\";s:2:\"30\";s:12:\"forumcolumns\";s:1:\"0\";s:12:\"threadcaches\";s:2:\"40\";s:16:\"allowpaytoauthor\";s:1:\"1\";s:13:\"alloweditpost\";s:1:\"1\";s:6:\"simple\";s:1:\"0\";s:11:\"postcredits\";s:0:\"\";s:12:\"replycredits\";s:0:\"\";s:16:\"getattachcredits\";s:0:\"\";s:17:\"postattachcredits\";s:0:\"\";s:13:\"digestcredits\";s:0:\"\";s:16:\"attachextensions\";s:0:\"\";s:8:\"viewperm\";s:0:\"\";s:8:\"postperm\";s:22:\"	1	2	3	11	12	13	14	15	\";s:9:\"replyperm\";s:0:\"\";s:13:\"getattachperm\";s:0:\"\";s:14:\"postattachperm\";s:0:\"\";s:16:\"supe_pushsetting\";s:0:\"\";}'),(11,'娱乐灌水类版块','forum','该设置了主题缓存系数，开启了所有的特殊主题按钮。','a:33:{s:7:\"styleid\";s:1:\"0\";s:12:\"allowsmilies\";s:1:\"1\";s:9:\"allowhtml\";s:1:\"0\";s:11:\"allowbbcode\";s:1:\"1\";s:12:\"allowimgcode\";s:1:\"1\";s:14:\"allowanonymous\";s:1:\"0\";s:10:\"allowshare\";s:1:\"1\";s:16:\"allowpostspecial\";s:2:\"15\";s:14:\"alloweditrules\";s:1:\"0\";s:10:\"recyclebin\";s:1:\"1\";s:11:\"modnewposts\";s:1:\"0\";s:6:\"jammer\";s:1:\"0\";s:16:\"disablewatermark\";s:1:\"0\";s:12:\"inheritedmod\";s:1:\"0\";s:9:\"autoclose\";s:1:\"0\";s:12:\"forumcolumns\";s:1:\"0\";s:12:\"threadcaches\";s:2:\"40\";s:16:\"allowpaytoauthor\";s:1:\"1\";s:13:\"alloweditpost\";s:1:\"1\";s:6:\"simple\";s:1:\"0\";s:11:\"postcredits\";s:0:\"\";s:12:\"replycredits\";s:0:\"\";s:16:\"getattachcredits\";s:0:\"\";s:17:\"postattachcredits\";s:0:\"\";s:13:\"digestcredits\";s:0:\"\";s:16:\"attachextensions\";s:0:\"\";s:11:\"threadtypes\";s:0:\"\";s:8:\"viewperm\";s:0:\"\";s:8:\"postperm\";s:0:\"\";s:9:\"replyperm\";s:0:\"\";s:13:\"getattachperm\";s:0:\"\";s:14:\"postattachperm\";s:0:\"\";s:16:\"supe_pushsetting\";s:0:\"\";}');

/*Table structure for table `cdb_promotions` */

DROP TABLE IF EXISTS `cdb_promotions`;

CREATE TABLE `cdb_promotions` (
  `ip` char(15) NOT NULL default '',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(15) NOT NULL default '',
  PRIMARY KEY  (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_promotions` */

/*Table structure for table `cdb_ranks` */

DROP TABLE IF EXISTS `cdb_ranks`;

CREATE TABLE `cdb_ranks` (
  `rankid` smallint(6) unsigned NOT NULL auto_increment,
  `ranktitle` varchar(30) NOT NULL default '',
  `postshigher` mediumint(8) unsigned NOT NULL default '0',
  `stars` tinyint(3) NOT NULL default '0',
  `color` varchar(7) NOT NULL default '',
  PRIMARY KEY  (`rankid`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_ranks` */

insert  into `cdb_ranks`(`rankid`,`ranktitle`,`postshigher`,`stars`,`color`) values (1,'新生入学',0,1,''),(2,'小试牛刀',50,2,''),(3,'实习记者',300,5,''),(4,'自由撰稿人',1000,4,''),(5,'特聘作家',3000,5,'');

/*Table structure for table `cdb_ratelog` */

DROP TABLE IF EXISTS `cdb_ratelog`;

CREATE TABLE `cdb_ratelog` (
  `pid` int(10) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(15) NOT NULL default '',
  `extcredits` tinyint(1) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `score` smallint(6) NOT NULL default '0',
  `reason` char(40) NOT NULL default '',
  KEY `pid` (`pid`,`dateline`),
  KEY `dateline` (`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_ratelog` */

/*Table structure for table `cdb_regips` */

DROP TABLE IF EXISTS `cdb_regips`;

CREATE TABLE `cdb_regips` (
  `ip` char(15) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `count` smallint(6) NOT NULL default '0',
  KEY `ip` (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_regips` */

/*Table structure for table `cdb_relatedthreads` */

DROP TABLE IF EXISTS `cdb_relatedthreads`;

CREATE TABLE `cdb_relatedthreads` (
  `tid` mediumint(8) NOT NULL default '0',
  `type` enum('general','trade') NOT NULL default 'general',
  `expiration` int(10) NOT NULL default '0',
  `keywords` varchar(255) NOT NULL default '',
  `relatedthreads` text NOT NULL,
  PRIMARY KEY  (`tid`,`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_relatedthreads` */

/*Table structure for table `cdb_reportlog` */

DROP TABLE IF EXISTS `cdb_reportlog`;

CREATE TABLE `cdb_reportlog` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `fid` smallint(6) unsigned NOT NULL,
  `pid` int(10) unsigned NOT NULL,
  `uid` mediumint(8) unsigned NOT NULL,
  `username` char(15) NOT NULL,
  `status` tinyint(1) unsigned NOT NULL default '1',
  `type` tinyint(1) NOT NULL,
  `reason` char(40) NOT NULL,
  `dateline` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `pid` (`pid`,`uid`),
  KEY `dateline` (`fid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_reportlog` */

/*Table structure for table `cdb_request` */

DROP TABLE IF EXISTS `cdb_request`;

CREATE TABLE `cdb_request` (
  `variable` varchar(32) NOT NULL default '',
  `value` mediumtext NOT NULL,
  `type` tinyint(1) NOT NULL,
  PRIMARY KEY  (`variable`),
  KEY `type` (`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_request` */

insert  into `cdb_request`(`variable`,`value`,`type`) values ('边栏模块_版块树形列表','a:4:{s:3:\"url\";s:83:\"function=module&module=forumtree.inc.php&settings=N%3B&jscharset=0&cachelife=864000\";s:9:\"parameter\";a:3:{s:6:\"module\";s:17:\"forumtree.inc.php\";s:9:\"cachelife\";s:6:\"864000\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:30:\"边栏版块树形列表模块\";s:4:\"type\";s:1:\"5\";}',5),('边栏模块_版主排行','a:4:{s:3:\"url\";s:79:\"function=module&module=modlist.inc.php&settings=N%3B&jscharset=0&cachelife=3600\";s:9:\"parameter\";a:3:{s:6:\"module\";s:15:\"modlist.inc.php\";s:9:\"cachelife\";s:4:\"3600\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:24:\"边栏版主排行模块\";s:4:\"type\";s:1:\"5\";}',5),('聚合模块_版块列表','a:4:{s:3:\"url\";s:382:\"function=module&module=rowcombine.inc.php&settings=a%3A1%3A%7Bs%3A4%3A%22data%22%3Bs%3A84%3A%22%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E7%89%88%E5%9D%97%E6%8E%92%E8%A1%8C%2C%E7%89%88%E5%9D%97%E6%8E%92%E8%A1%8C%0D%0A%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E7%89%88%E5%9D%97%E6%A0%91%E5%BD%A2%E5%88%97%E8%A1%A8%2C%E7%89%88%E5%9D%97%E5%88%97%E8%A1%A8%22%3B%7D&jscharset=0&cachelife=864000&\";s:9:\"parameter\";a:4:{s:6:\"module\";s:18:\"rowcombine.inc.php\";s:9:\"cachelife\";s:6:\"864000\";s:8:\"settings\";a:1:{s:4:\"data\";s:84:\"边栏模块_版块排行,版块排行\r\n边栏模块_版块树形列表,版块列表\";}s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:39:\"热门版块、版块树形聚合模块\";s:4:\"type\";s:1:\"5\";}',5),('边栏模块_版块排行','a:4:{s:3:\"url\";s:482:\"function=forums&startrow=0&items=0&newwindow=1&orderby=posts&jscharset=0&cachelife=43200&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E7%89%88%E5%9D%97%E6%8E%92%E8%A1%8C%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22textinfolist%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%3Cimg%20style%3D%5C%22vertical-align%3Amiddle%5C%22%20src%3D%5C%22images%2Fdefault%2Ftree_file.gif%5C%22%20%2F%3E%20%7Bforumname%7D%28%7Bposts%7D%29%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\";s:9:\"parameter\";a:7:{s:10:\"jstemplate\";s:211:\"<div class=\\\"sidebox\\\">\r\n<h4>版块排行</h4>\r\n<ul class=\\\"textinfolist\\\">\r\n[node]<li><img style=\\\"vertical-align:middle\\\" src=\\\"images/default/tree_file.gif\\\" /> {forumname}({posts})</li>[/node]\r\n</ul>\r\n</div>\";s:9:\"cachelife\";s:5:\"43200\";s:8:\"startrow\";s:1:\"0\";s:5:\"items\";s:1:\"0\";s:9:\"newwindow\";i:1;s:7:\"orderby\";s:5:\"posts\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:24:\"边栏版块排行模块\";s:4:\"type\";s:1:\"1\";}',1),('聚合模块_热门主题','a:4:{s:3:\"url\";s:533:\"function=module&module=rowcombine.inc.php&settings=a%3A2%3A%7Bs%3A5%3A%22title%22%3Bs%3A12%3A%22%E7%83%AD%E9%97%A8%E4%B8%BB%E9%A2%98%22%3Bs%3A4%3A%22data%22%3Bs%3A112%3A%22%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E7%83%AD%E9%97%A8%E4%B8%BB%E9%A2%98_%E4%BB%8A%E6%97%A5%2C%E6%97%A5%0D%0A%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E7%83%AD%E9%97%A8%E4%B8%BB%E9%A2%98_%E6%9C%AC%E5%91%A8%2C%E5%91%A8%0D%0A%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E7%83%AD%E9%97%A8%E4%B8%BB%E9%A2%98_%E6%9C%AC%E6%9C%88%2C%E6%9C%88%22%3B%7D&jscharset=0&cachelife=1800&\";s:9:\"parameter\";a:4:{s:6:\"module\";s:18:\"rowcombine.inc.php\";s:9:\"cachelife\";s:4:\"1800\";s:8:\"settings\";a:2:{s:5:\"title\";s:12:\"热门主题\";s:4:\"data\";s:112:\"边栏模块_热门主题_今日,日\r\n边栏模块_热门主题_本周,周\r\n边栏模块_热门主题_本月,月\";}s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:48:\"今日、本周、本月热门主题聚合模块\";s:4:\"type\";s:1:\"5\";}',5),('边栏模块_热门主题_本月','a:4:{s:3:\"url\";s:556:\"function=threads&sidestatus=0&maxlength=20&fnamelength=0&messagelength=&startrow=0&picpre=images%2Fcommon%2Fslisticon.gif&items=5&tag=&tids=&special=0&rewardstatus=&digest=0&stick=0&recommend=0&newwindow=1&threadtype=0&highlight=0&orderby=hourviews&hours=720&jscharset=0&cachelife=86400&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%AC%E6%9C%88%E7%83%AD%E9%97%A8%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22textinfolist%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%7Bprefix%7D%7Bsubject%7D%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\";s:9:\"parameter\";a:19:{s:10:\"jstemplate\";s:131:\"<div class=\\\"sidebox\\\">\r\n<h4>本月热门</h4>\r\n<ul class=\\\"textinfolist\\\">\r\n[node]<li>{prefix}{subject}</li>[/node]\r\n</ul>\r\n</div>\";s:9:\"cachelife\";s:5:\"86400\";s:10:\"sidestatus\";s:1:\"0\";s:8:\"startrow\";s:1:\"0\";s:5:\"items\";s:1:\"5\";s:9:\"maxlength\";s:2:\"20\";s:11:\"fnamelength\";s:1:\"0\";s:13:\"messagelength\";s:0:\"\";s:6:\"picpre\";s:27:\"images/common/slisticon.gif\";s:4:\"tids\";s:0:\"\";s:7:\"keyword\";s:0:\"\";s:3:\"tag\";s:0:\"\";s:10:\"threadtype\";s:1:\"0\";s:9:\"highlight\";s:1:\"0\";s:9:\"recommend\";s:1:\"0\";s:9:\"newwindow\";i:1;s:7:\"orderby\";s:9:\"hourviews\";s:5:\"hours\";s:3:\"720\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:30:\"边栏本月热门主题模块\";s:4:\"type\";s:1:\"0\";}',0),('聚合模块_会员排行','a:4:{s:3:\"url\";s:533:\"function=module&module=rowcombine.inc.php&settings=a%3A2%3A%7Bs%3A5%3A%22title%22%3Bs%3A12%3A%22%E4%BC%9A%E5%91%98%E6%8E%92%E8%A1%8C%22%3Bs%3A4%3A%22data%22%3Bs%3A112%3A%22%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E4%BC%9A%E5%91%98%E6%8E%92%E8%A1%8C_%E4%BB%8A%E6%97%A5%2C%E6%97%A5%0D%0A%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E4%BC%9A%E5%91%98%E6%8E%92%E8%A1%8C_%E6%9C%AC%E5%91%A8%2C%E5%91%A8%0D%0A%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E4%BC%9A%E5%91%98%E6%8E%92%E8%A1%8C_%E6%9C%AC%E6%9C%88%2C%E6%9C%88%22%3B%7D&jscharset=0&cachelife=3600&\";s:9:\"parameter\";a:4:{s:6:\"module\";s:18:\"rowcombine.inc.php\";s:9:\"cachelife\";s:4:\"3600\";s:8:\"settings\";a:2:{s:5:\"title\";s:12:\"会员排行\";s:4:\"data\";s:112:\"边栏模块_会员排行_今日,日\r\n边栏模块_会员排行_本周,周\r\n边栏模块_会员排行_本月,月\";}s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:48:\"今日、本周、本月会员排行聚合模块\";s:4:\"type\";s:1:\"5\";}',5),('边栏模块_推荐主题','a:4:{s:3:\"url\";s:553:\"function=threads&sidestatus=0&maxlength=20&fnamelength=0&messagelength=&startrow=0&picpre=images%2Fcommon%2Fslisticon.gif&items=5&tag=&tids=&special=0&rewardstatus=&digest=0&stick=0&recommend=1&newwindow=1&threadtype=0&highlight=0&orderby=lastpost&hours=48&jscharset=0&cachelife=3600&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%8E%A8%E8%8D%90%E4%B8%BB%E9%A2%98%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22textinfolist%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%7Bprefix%7D%7Bsubject%7D%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\";s:9:\"parameter\";a:19:{s:10:\"jstemplate\";s:131:\"<div class=\\\"sidebox\\\">\r\n<h4>推荐主题</h4>\r\n<ul class=\\\"textinfolist\\\">\r\n[node]<li>{prefix}{subject}</li>[/node]\r\n</ul>\r\n</div>\";s:9:\"cachelife\";s:4:\"3600\";s:10:\"sidestatus\";s:1:\"0\";s:8:\"startrow\";s:1:\"0\";s:5:\"items\";s:1:\"5\";s:9:\"maxlength\";s:2:\"20\";s:11:\"fnamelength\";s:1:\"0\";s:13:\"messagelength\";s:0:\"\";s:6:\"picpre\";s:27:\"images/common/slisticon.gif\";s:4:\"tids\";s:0:\"\";s:7:\"keyword\";s:0:\"\";s:3:\"tag\";s:0:\"\";s:10:\"threadtype\";s:1:\"0\";s:9:\"highlight\";s:1:\"0\";s:9:\"recommend\";s:1:\"1\";s:9:\"newwindow\";i:1;s:7:\"orderby\";s:8:\"lastpost\";s:5:\"hours\";s:2:\"48\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:24:\"边栏推荐主题模块\";s:4:\"type\";s:1:\"0\";}',0),('边栏模块_最新图片','a:4:{s:3:\"url\";s:1385:\"function=images&sidestatus=0&isimage=1&threadmethod=1&maxwidth=140&maxheight=140&startrow=0&items=5&orderby=dateline&hours=0&digest=0&newwindow=1&jscharset=0&jstemplate=%3Cdiv%20%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%80%E6%96%B0%E5%9B%BE%E7%89%87%3C%2Fh4%3E%0D%0A%3Cscript%20type%3D%5C%22text%2Fjavascript%5C%22%3E%0D%0Avar%20slideSpeed%20%3D%202500%3B%0D%0Avar%20slideImgsize%20%3D%20%5B140%2C140%5D%3B%0D%0Avar%20slideTextBar%20%3D%200%3B%0D%0Avar%20slideBorderColor%20%3D%20%5C%27%23C8DCEC%5C%27%3B%0D%0Avar%20slideBgColor%20%3D%20%5C%27%23FFF%5C%27%3B%0D%0Avar%20slideImgs%20%3D%20new%20Array%28%29%3B%0D%0Avar%20slideImgLinks%20%3D%20new%20Array%28%29%3B%0D%0Avar%20slideImgTexts%20%3D%20new%20Array%28%29%3B%0D%0Avar%20slideSwitchBar%20%3D%201%3B%0D%0Avar%20slideSwitchColor%20%3D%20%5C%27black%5C%27%3B%0D%0Avar%20slideSwitchbgColor%20%3D%20%5C%27white%5C%27%3B%0D%0Avar%20slideSwitchHiColor%20%3D%20%5C%27%23C8DCEC%5C%27%3B%0D%0A%5Bnode%5D%0D%0AslideImgs%5B%7Border%7D%5D%20%3D%20%5C%22%7Bimgfile%7D%5C%22%3B%0D%0AslideImgLinks%5B%7Border%7D%5D%20%3D%20%5C%22%7Blink%7D%5C%22%3B%0D%0AslideImgTexts%5B%7Border%7D%5D%20%3D%20%5C%22%7Bsubject%7D%5C%22%3B%0D%0A%5B%2Fnode%5D%0D%0A%3C%2Fscript%3E%0D%0A%3Cscript%20language%3D%5C%22javascript%5C%22%20type%3D%5C%22text%2Fjavascript%5C%22%20src%3D%5C%22include%2Fjs%2Fslide.js%5C%22%3E%3C%2Fscript%3E%0D%0A%3C%2Fdiv%3E&\";s:9:\"parameter\";a:13:{s:10:\"jstemplate\";s:709:\"<div  class=\\\"sidebox\\\">\r\n<h4>最新图片</h4>\r\n<script type=\\\"text/javascript\\\">\r\nvar slideSpeed = 2500;\r\nvar slideImgsize = [140,140];\r\nvar slideTextBar = 0;\r\nvar slideBorderColor = \\\'#C8DCEC\\\';\r\nvar slideBgColor = \\\'#FFF\\\';\r\nvar slideImgs = new Array();\r\nvar slideImgLinks = new Array();\r\nvar slideImgTexts = new Array();\r\nvar slideSwitchBar = 1;\r\nvar slideSwitchColor = \\\'black\\\';\r\nvar slideSwitchbgColor = \\\'white\\\';\r\nvar slideSwitchHiColor = \\\'#C8DCEC\\\';\r\n[node]\r\nslideImgs[{order}] = \\\"{imgfile}\\\";\r\nslideImgLinks[{order}] = \\\"{link}\\\";\r\nslideImgTexts[{order}] = \\\"{subject}\\\";\r\n[/node]\r\n</script>\r\n<script language=\\\"javascript\\\" type=\\\"text/javascript\\\" src=\\\"include/js/slide.js\\\"></script>\r\n</div>\";s:9:\"cachelife\";s:0:\"\";s:10:\"sidestatus\";s:1:\"0\";s:8:\"startrow\";s:1:\"0\";s:5:\"items\";s:1:\"5\";s:7:\"isimage\";s:1:\"1\";s:8:\"maxwidth\";s:3:\"140\";s:9:\"maxheight\";s:3:\"140\";s:12:\"threadmethod\";s:1:\"1\";s:9:\"newwindow\";i:1;s:7:\"orderby\";s:8:\"dateline\";s:5:\"hours\";s:0:\"\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:30:\"边栏最新图片展示模块\";s:4:\"type\";s:1:\"4\";}',4),('边栏模块_最新主题','a:4:{s:3:\"url\";s:537:\"function=threads&sidestatus=0&maxlength=20&fnamelength=0&messagelength=&startrow=0&picpre=images%2Fcommon%2Fslisticon.gif&items=5&tag=&tids=&special=0&rewardstatus=&digest=0&stick=0&recommend=0&newwindow=1&threadtype=0&highlight=0&orderby=dateline&hours=0&jscharset=0&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%80%E6%96%B0%E4%B8%BB%E9%A2%98%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22textinfolist%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%7Bprefix%7D%7Bsubject%7D%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\";s:9:\"parameter\";a:19:{s:10:\"jstemplate\";s:131:\"<div class=\\\"sidebox\\\">\r\n<h4>最新主题</h4>\r\n<ul class=\\\"textinfolist\\\">\r\n[node]<li>{prefix}{subject}</li>[/node]\r\n</ul>\r\n</div>\";s:9:\"cachelife\";s:0:\"\";s:10:\"sidestatus\";s:1:\"0\";s:8:\"startrow\";s:1:\"0\";s:5:\"items\";s:1:\"5\";s:9:\"maxlength\";s:2:\"20\";s:11:\"fnamelength\";s:1:\"0\";s:13:\"messagelength\";s:0:\"\";s:6:\"picpre\";s:27:\"images/common/slisticon.gif\";s:4:\"tids\";s:0:\"\";s:7:\"keyword\";s:0:\"\";s:3:\"tag\";s:0:\"\";s:10:\"threadtype\";s:1:\"0\";s:9:\"highlight\";s:1:\"0\";s:9:\"recommend\";s:1:\"0\";s:9:\"newwindow\";i:1;s:7:\"orderby\";s:8:\"dateline\";s:5:\"hours\";s:0:\"\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:24:\"边栏最新主题模块\";s:4:\"type\";s:1:\"0\";}',0),('边栏模块_活跃会员','a:4:{s:3:\"url\";s:381:\"function=memberrank&startrow=0&items=12&newwindow=1&extcredit=1&orderby=posts&hours=0&jscharset=0&cachelife=43200&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%B4%BB%E8%B7%83%E4%BC%9A%E5%91%98%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22avt_list%20s_clear%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%7Bavatarsmall%7D%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\";s:9:\"parameter\";a:9:{s:10:\"jstemplate\";s:131:\"<div class=\\\"sidebox\\\">\r\n<h4>活跃会员</h4>\r\n<ul class=\\\"avt_list s_clear\\\">\r\n[node]<li>{avatarsmall}</li>[/node]\r\n</ul>\r\n</div>\";s:9:\"cachelife\";s:5:\"43200\";s:8:\"startrow\";s:1:\"0\";s:5:\"items\";s:2:\"12\";s:9:\"newwindow\";i:1;s:9:\"extcredit\";s:1:\"1\";s:7:\"orderby\";s:5:\"posts\";s:5:\"hours\";s:0:\"\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:24:\"边栏活跃会员模块\";s:4:\"type\";s:1:\"2\";}',2),('边栏模块_热门主题_本版','a:4:{s:3:\"url\";s:569:\"function=threads&sidestatus=1&maxlength=20&fnamelength=0&messagelength=&startrow=0&picpre=images%2Fcommon%2Fslisticon.gif&items=5&tag=&tids=&special=0&rewardstatus=&digest=0&stick=0&recommend=0&newwindow=1&threadtype=0&highlight=0&orderby=replies&hours=0&jscharset=0&cachelife=1800&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%AC%E7%89%88%E7%83%AD%E9%97%A8%E4%B8%BB%E9%A2%98%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22textinfolist%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%7Bprefix%7D%7Bsubject%7D%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\";s:9:\"parameter\";a:19:{s:10:\"jstemplate\";s:137:\"<div class=\\\"sidebox\\\">\r\n<h4>本版热门主题</h4>\r\n<ul class=\\\"textinfolist\\\">\r\n[node]<li>{prefix}{subject}</li>[/node]\r\n</ul>\r\n</div>\";s:9:\"cachelife\";s:4:\"1800\";s:10:\"sidestatus\";s:1:\"1\";s:8:\"startrow\";s:1:\"0\";s:5:\"items\";s:1:\"5\";s:9:\"maxlength\";s:2:\"20\";s:11:\"fnamelength\";s:1:\"0\";s:13:\"messagelength\";s:0:\"\";s:6:\"picpre\";s:27:\"images/common/slisticon.gif\";s:4:\"tids\";s:0:\"\";s:7:\"keyword\";s:0:\"\";s:3:\"tag\";s:0:\"\";s:10:\"threadtype\";s:1:\"0\";s:9:\"highlight\";s:1:\"0\";s:9:\"recommend\";s:1:\"0\";s:9:\"newwindow\";i:1;s:7:\"orderby\";s:7:\"replies\";s:5:\"hours\";s:0:\"\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:30:\"边栏本版热门主题模块\";s:4:\"type\";s:1:\"0\";}',0),('边栏模块_热门主题_今日','a:4:{s:3:\"url\";s:554:\"function=threads&sidestatus=0&maxlength=20&fnamelength=0&messagelength=&startrow=0&picpre=images%2Fcommon%2Fslisticon.gif&items=5&tag=&tids=&special=0&rewardstatus=&digest=0&stick=0&recommend=0&newwindow=1&threadtype=0&highlight=0&orderby=hourviews&hours=24&jscharset=0&cachelife=1800&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E4%BB%8A%E6%97%A5%E7%83%AD%E9%97%A8%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22textinfolist%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%7Bprefix%7D%7Bsubject%7D%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\";s:9:\"parameter\";a:19:{s:10:\"jstemplate\";s:131:\"<div class=\\\"sidebox\\\">\r\n<h4>今日热门</h4>\r\n<ul class=\\\"textinfolist\\\">\r\n[node]<li>{prefix}{subject}</li>[/node]\r\n</ul>\r\n</div>\";s:9:\"cachelife\";s:4:\"1800\";s:10:\"sidestatus\";s:1:\"0\";s:8:\"startrow\";s:1:\"0\";s:5:\"items\";s:1:\"5\";s:9:\"maxlength\";s:2:\"20\";s:11:\"fnamelength\";s:1:\"0\";s:13:\"messagelength\";s:0:\"\";s:6:\"picpre\";s:27:\"images/common/slisticon.gif\";s:4:\"tids\";s:0:\"\";s:7:\"keyword\";s:0:\"\";s:3:\"tag\";s:0:\"\";s:10:\"threadtype\";s:1:\"0\";s:9:\"highlight\";s:1:\"0\";s:9:\"recommend\";s:1:\"0\";s:9:\"newwindow\";i:1;s:7:\"orderby\";s:9:\"hourviews\";s:5:\"hours\";s:2:\"24\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:30:\"边栏今日热门主题模块\";s:4:\"type\";s:1:\"0\";}',0),('边栏模块_最新回复','a:4:{s:3:\"url\";s:537:\"function=threads&sidestatus=0&maxlength=20&fnamelength=0&messagelength=&startrow=0&picpre=images%2Fcommon%2Fslisticon.gif&items=5&tag=&tids=&special=0&rewardstatus=&digest=0&stick=0&recommend=0&newwindow=1&threadtype=0&highlight=0&orderby=lastpost&hours=0&jscharset=0&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%80%E6%96%B0%E5%9B%9E%E5%A4%8D%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22textinfolist%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%7Bprefix%7D%7Bsubject%7D%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\";s:9:\"parameter\";a:19:{s:10:\"jstemplate\";s:131:\"<div class=\\\"sidebox\\\">\r\n<h4>最新回复</h4>\r\n<ul class=\\\"textinfolist\\\">\r\n[node]<li>{prefix}{subject}</li>[/node]\r\n</ul>\r\n</div>\";s:9:\"cachelife\";s:0:\"\";s:10:\"sidestatus\";s:1:\"0\";s:8:\"startrow\";s:1:\"0\";s:5:\"items\";s:1:\"5\";s:9:\"maxlength\";s:2:\"20\";s:11:\"fnamelength\";s:1:\"0\";s:13:\"messagelength\";s:0:\"\";s:6:\"picpre\";s:27:\"images/common/slisticon.gif\";s:4:\"tids\";s:0:\"\";s:7:\"keyword\";s:0:\"\";s:3:\"tag\";s:0:\"\";s:10:\"threadtype\";s:1:\"0\";s:9:\"highlight\";s:1:\"0\";s:9:\"recommend\";s:1:\"0\";s:9:\"newwindow\";i:1;s:7:\"orderby\";s:8:\"lastpost\";s:5:\"hours\";s:0:\"\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:24:\"边栏最新回复模块\";s:4:\"type\";s:1:\"0\";}',0),('边栏模块_最新图片_本版','a:4:{s:3:\"url\";s:1385:\"function=images&sidestatus=1&isimage=1&threadmethod=1&maxwidth=140&maxheight=140&startrow=0&items=5&orderby=dateline&hours=0&digest=0&newwindow=1&jscharset=0&jstemplate=%3Cdiv%20%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%80%E6%96%B0%E5%9B%BE%E7%89%87%3C%2Fh4%3E%0D%0A%3Cscript%20type%3D%5C%22text%2Fjavascript%5C%22%3E%0D%0Avar%20slideSpeed%20%3D%202500%3B%0D%0Avar%20slideImgsize%20%3D%20%5B140%2C140%5D%3B%0D%0Avar%20slideTextBar%20%3D%200%3B%0D%0Avar%20slideBorderColor%20%3D%20%5C%27%23C8DCEC%5C%27%3B%0D%0Avar%20slideBgColor%20%3D%20%5C%27%23FFF%5C%27%3B%0D%0Avar%20slideImgs%20%3D%20new%20Array%28%29%3B%0D%0Avar%20slideImgLinks%20%3D%20new%20Array%28%29%3B%0D%0Avar%20slideImgTexts%20%3D%20new%20Array%28%29%3B%0D%0Avar%20slideSwitchBar%20%3D%201%3B%0D%0Avar%20slideSwitchColor%20%3D%20%5C%27black%5C%27%3B%0D%0Avar%20slideSwitchbgColor%20%3D%20%5C%27white%5C%27%3B%0D%0Avar%20slideSwitchHiColor%20%3D%20%5C%27%23C8DCEC%5C%27%3B%0D%0A%5Bnode%5D%0D%0AslideImgs%5B%7Border%7D%5D%20%3D%20%5C%22%7Bimgfile%7D%5C%22%3B%0D%0AslideImgLinks%5B%7Border%7D%5D%20%3D%20%5C%22%7Blink%7D%5C%22%3B%0D%0AslideImgTexts%5B%7Border%7D%5D%20%3D%20%5C%22%7Bsubject%7D%5C%22%3B%0D%0A%5B%2Fnode%5D%0D%0A%3C%2Fscript%3E%0D%0A%3Cscript%20language%3D%5C%22javascript%5C%22%20type%3D%5C%22text%2Fjavascript%5C%22%20src%3D%5C%22include%2Fjs%2Fslide.js%5C%22%3E%3C%2Fscript%3E%0D%0A%3C%2Fdiv%3E&\";s:9:\"parameter\";a:13:{s:10:\"jstemplate\";s:709:\"<div  class=\\\"sidebox\\\">\r\n<h4>最新图片</h4>\r\n<script type=\\\"text/javascript\\\">\r\nvar slideSpeed = 2500;\r\nvar slideImgsize = [140,140];\r\nvar slideTextBar = 0;\r\nvar slideBorderColor = \\\'#C8DCEC\\\';\r\nvar slideBgColor = \\\'#FFF\\\';\r\nvar slideImgs = new Array();\r\nvar slideImgLinks = new Array();\r\nvar slideImgTexts = new Array();\r\nvar slideSwitchBar = 1;\r\nvar slideSwitchColor = \\\'black\\\';\r\nvar slideSwitchbgColor = \\\'white\\\';\r\nvar slideSwitchHiColor = \\\'#C8DCEC\\\';\r\n[node]\r\nslideImgs[{order}] = \\\"{imgfile}\\\";\r\nslideImgLinks[{order}] = \\\"{link}\\\";\r\nslideImgTexts[{order}] = \\\"{subject}\\\";\r\n[/node]\r\n</script>\r\n<script language=\\\"javascript\\\" type=\\\"text/javascript\\\" src=\\\"include/js/slide.js\\\"></script>\r\n</div>\";s:9:\"cachelife\";s:0:\"\";s:10:\"sidestatus\";s:1:\"1\";s:8:\"startrow\";s:1:\"0\";s:5:\"items\";s:1:\"5\";s:7:\"isimage\";s:1:\"1\";s:8:\"maxwidth\";s:3:\"140\";s:9:\"maxheight\";s:3:\"140\";s:12:\"threadmethod\";s:1:\"1\";s:9:\"newwindow\";i:1;s:7:\"orderby\";s:8:\"dateline\";s:5:\"hours\";s:0:\"\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:36:\"边栏本版最新图片展示模块\";s:4:\"type\";s:1:\"4\";}',4),('边栏模块_标签','a:4:{s:3:\"url\";s:126:\"function=module&module=tag.inc.php&settings=a%3A1%3A%7Bs%3A5%3A%22limit%22%3Bs%3A2%3A%2220%22%3B%7D&jscharset=0&cachelife=900&\";s:9:\"parameter\";a:4:{s:6:\"module\";s:11:\"tag.inc.php\";s:9:\"cachelife\";s:3:\"900\";s:8:\"settings\";a:1:{s:5:\"limit\";s:2:\"20\";}s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:18:\"边栏标签模块\";s:4:\"type\";s:1:\"5\";}',5),('边栏模块_会员排行_本月','a:4:{s:3:\"url\";s:520:\"function=memberrank&startrow=0&items=5&newwindow=1&extcredit=1&orderby=hourposts&hours=720&jscharset=0&cachelife=86400&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%20s_clear%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%AC%E6%9C%88%E6%8E%92%E8%A1%8C%3C%2Fh4%3E%0D%0A%5Bnode%5D%3Cdiv%20style%3D%5C%22clear%3Aboth%5C%22%3E%3Cdiv%20style%3D%5C%22float%3Aleft%3Bmargin%3A%200%2016px%205px%200%5C%22%3E%7Bavatarsmall%7D%3C%2Fdiv%3E%7Bmember%7D%3Cbr%20%2F%3E%E5%8F%91%E5%B8%96%20%7Bvalue%7D%20%E7%AF%87%3C%2Fdiv%3E%5B%2Fnode%5D%0D%0A%3C%2Fdiv%3E&\";s:9:\"parameter\";a:9:{s:10:\"jstemplate\";s:207:\"<div class=\\\"sidebox s_clear\\\">\r\n<h4>本月排行</h4>\r\n[node]<div style=\\\"clear:both\\\"><div style=\\\"float:left;margin: 0 16px 5px 0\\\">{avatarsmall}</div>{member}<br />发帖 {value} 篇</div>[/node]\r\n</div>\";s:9:\"cachelife\";s:5:\"86400\";s:8:\"startrow\";s:1:\"0\";s:5:\"items\";s:1:\"5\";s:9:\"newwindow\";i:1;s:9:\"extcredit\";s:1:\"1\";s:7:\"orderby\";s:9:\"hourposts\";s:5:\"hours\";s:3:\"720\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:36:\"边栏会员本月发帖排行模块\";s:4:\"type\";s:1:\"2\";}',2),('边栏模块_会员排行_本周','a:4:{s:3:\"url\";s:520:\"function=memberrank&startrow=0&items=5&newwindow=1&extcredit=1&orderby=hourposts&hours=168&jscharset=0&cachelife=43200&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%20s_clear%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%AC%E5%91%A8%E6%8E%92%E8%A1%8C%3C%2Fh4%3E%0D%0A%5Bnode%5D%3Cdiv%20style%3D%5C%22clear%3Aboth%5C%22%3E%3Cdiv%20style%3D%5C%22float%3Aleft%3Bmargin%3A%200%2016px%205px%200%5C%22%3E%7Bavatarsmall%7D%3C%2Fdiv%3E%7Bmember%7D%3Cbr%20%2F%3E%E5%8F%91%E5%B8%96%20%7Bvalue%7D%20%E7%AF%87%3C%2Fdiv%3E%5B%2Fnode%5D%0D%0A%3C%2Fdiv%3E&\";s:9:\"parameter\";a:9:{s:10:\"jstemplate\";s:207:\"<div class=\\\"sidebox s_clear\\\">\r\n<h4>本周排行</h4>\r\n[node]<div style=\\\"clear:both\\\"><div style=\\\"float:left;margin: 0 16px 5px 0\\\">{avatarsmall}</div>{member}<br />发帖 {value} 篇</div>[/node]\r\n</div>\";s:9:\"cachelife\";s:5:\"43200\";s:8:\"startrow\";s:1:\"0\";s:5:\"items\";s:1:\"5\";s:9:\"newwindow\";i:1;s:9:\"extcredit\";s:1:\"1\";s:7:\"orderby\";s:9:\"hourposts\";s:5:\"hours\";s:3:\"168\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:36:\"边栏会员本周发帖排行模块\";s:4:\"type\";s:1:\"2\";}',2),('边栏方案_主题列表页默认','a:4:{s:3:\"url\";s:432:\"function=side&jscharset=&jstemplate=%5Bmodule%5D%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E6%88%91%E7%9A%84%E5%8A%A9%E6%89%8B%5B%2Fmodule%5D%3Chr%20class%3D%22shadowline%22%2F%3E%5Bmodule%5D%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E7%83%AD%E9%97%A8%E4%B8%BB%E9%A2%98_%E6%9C%AC%E7%89%88%5B%2Fmodule%5D%3Chr%20class%3D%22shadowline%22%2F%3E%5Bmodule%5D%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E7%89%88%E5%9D%97%E6%8E%92%E8%A1%8C%5B%2Fmodule%5D&\";s:9:\"parameter\";a:3:{s:12:\"selectmodule\";a:3:{i:1;s:25:\"边栏模块_我的助手\";i:2;s:32:\"边栏模块_热门主题_本版\";i:3;s:25:\"边栏模块_版块排行\";}s:9:\"cachelife\";i:0;s:10:\"jstemplate\";s:181:\"[module]边栏模块_我的助手[/module]<hr class=\"shadowline\"/>[module]边栏模块_热门主题_本版[/module]<hr class=\"shadowline\"/>[module]边栏模块_版块排行[/module]\";}s:7:\"comment\";N;s:4:\"type\";s:2:\"-2\";}',-2),('边栏方案_首页默认','a:4:{s:3:\"url\";s:533:\"function=side&jscharset=&jstemplate=%5Bmodule%5D%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E6%88%91%E7%9A%84%E5%8A%A9%E6%89%8B%5B%2Fmodule%5D%3Chr%20class%3D%22shadowline%22%2F%3E%5Bmodule%5D%E8%81%9A%E5%90%88%E6%A8%A1%E5%9D%97_%E6%96%B0%E5%B8%96%5B%2Fmodule%5D%3Chr%20class%3D%22shadowline%22%2F%3E%5Bmodule%5D%E8%81%9A%E5%90%88%E6%A8%A1%E5%9D%97_%E7%83%AD%E9%97%A8%E4%B8%BB%E9%A2%98%5B%2Fmodule%5D%3Chr%20class%3D%22shadowline%22%2F%3E%5Bmodule%5D%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E6%B4%BB%E8%B7%83%E4%BC%9A%E5%91%98%5B%2Fmodule%5D&\";s:9:\"parameter\";a:3:{s:12:\"selectmodule\";a:4:{i:1;s:25:\"边栏模块_我的助手\";i:2;s:19:\"聚合模块_新帖\";i:3;s:25:\"聚合模块_热门主题\";i:4;s:25:\"边栏模块_活跃会员\";}s:9:\"cachelife\";i:0;s:10:\"jstemplate\";s:234:\"[module]边栏模块_我的助手[/module]<hr class=\"shadowline\"/>[module]聚合模块_新帖[/module]<hr class=\"shadowline\"/>[module]聚合模块_热门主题[/module]<hr class=\"shadowline\"/>[module]边栏模块_活跃会员[/module]\";}s:7:\"comment\";N;s:4:\"type\";s:2:\"-2\";}',-2),('聚合模块_新帖','a:4:{s:3:\"url\";s:387:\"function=module&module=rowcombine.inc.php&settings=a%3A2%3A%7Bs%3A5%3A%22title%22%3Bs%3A12%3A%22%E6%9C%80%E6%96%B0%E5%B8%96%E5%AD%90%22%3Bs%3A4%3A%22data%22%3Bs%3A66%3A%22%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E6%9C%80%E6%96%B0%E4%B8%BB%E9%A2%98%2C%E4%B8%BB%E9%A2%98%0D%0A%E8%BE%B9%E6%A0%8F%E6%A8%A1%E5%9D%97_%E6%9C%80%E6%96%B0%E5%9B%9E%E5%A4%8D%2C%E5%9B%9E%E5%A4%8D%22%3B%7D&jscharset=0&\";s:9:\"parameter\";a:4:{s:6:\"module\";s:18:\"rowcombine.inc.php\";s:9:\"cachelife\";s:0:\"\";s:8:\"settings\";a:2:{s:5:\"title\";s:12:\"最新帖子\";s:4:\"data\";s:66:\"边栏模块_最新主题,主题\r\n边栏模块_最新回复,回复\";}s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:39:\"最新主题、最新回复聚合模块\";s:4:\"type\";s:1:\"5\";}',5),('边栏模块_热门主题_本周','a:4:{s:3:\"url\";s:556:\"function=threads&sidestatus=0&maxlength=20&fnamelength=0&messagelength=&startrow=0&picpre=images%2Fcommon%2Fslisticon.gif&items=5&tag=&tids=&special=0&rewardstatus=&digest=0&stick=0&recommend=0&newwindow=1&threadtype=0&highlight=0&orderby=hourviews&hours=168&jscharset=0&cachelife=43200&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%AC%E5%91%A8%E7%83%AD%E9%97%A8%3C%2Fh4%3E%0D%0A%3Cul%20class%3D%5C%22textinfolist%5C%22%3E%0D%0A%5Bnode%5D%3Cli%3E%7Bprefix%7D%7Bsubject%7D%3C%2Fli%3E%5B%2Fnode%5D%0D%0A%3C%2Ful%3E%0D%0A%3C%2Fdiv%3E&\";s:9:\"parameter\";a:19:{s:10:\"jstemplate\";s:131:\"<div class=\\\"sidebox\\\">\r\n<h4>本周热门</h4>\r\n<ul class=\\\"textinfolist\\\">\r\n[node]<li>{prefix}{subject}</li>[/node]\r\n</ul>\r\n</div>\";s:9:\"cachelife\";s:5:\"43200\";s:10:\"sidestatus\";s:1:\"0\";s:8:\"startrow\";s:1:\"0\";s:5:\"items\";s:1:\"5\";s:9:\"maxlength\";s:2:\"20\";s:11:\"fnamelength\";s:1:\"0\";s:13:\"messagelength\";s:0:\"\";s:6:\"picpre\";s:27:\"images/common/slisticon.gif\";s:4:\"tids\";s:0:\"\";s:7:\"keyword\";s:0:\"\";s:3:\"tag\";s:0:\"\";s:10:\"threadtype\";s:1:\"0\";s:9:\"highlight\";s:1:\"0\";s:9:\"recommend\";s:1:\"0\";s:9:\"newwindow\";i:1;s:7:\"orderby\";s:9:\"hourviews\";s:5:\"hours\";s:3:\"168\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:30:\"边栏本周热门主题模块\";s:4:\"type\";s:1:\"0\";}',0),('边栏模块_会员排行_今日','a:4:{s:3:\"url\";s:518:\"function=memberrank&startrow=0&items=5&newwindow=1&extcredit=1&orderby=hourposts&hours=24&jscharset=0&cachelife=3600&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%20s_clear%5C%22%3E%0D%0A%3Ch4%3E%E4%BB%8A%E6%97%A5%E6%8E%92%E8%A1%8C%3C%2Fh4%3E%0D%0A%5Bnode%5D%3Cdiv%20style%3D%5C%22clear%3Aboth%5C%22%3E%3Cdiv%20style%3D%5C%22float%3Aleft%3Bmargin%3A%200%2016px%205px%200%5C%22%3E%7Bavatarsmall%7D%3C%2Fdiv%3E%7Bmember%7D%3Cbr%20%2F%3E%E5%8F%91%E5%B8%96%20%7Bvalue%7D%20%E7%AF%87%3C%2Fdiv%3E%5B%2Fnode%5D%0D%0A%3C%2Fdiv%3E&\";s:9:\"parameter\";a:9:{s:10:\"jstemplate\";s:207:\"<div class=\\\"sidebox s_clear\\\">\r\n<h4>今日排行</h4>\r\n[node]<div style=\\\"clear:both\\\"><div style=\\\"float:left;margin: 0 16px 5px 0\\\">{avatarsmall}</div>{member}<br />发帖 {value} 篇</div>[/node]\r\n</div>\";s:9:\"cachelife\";s:4:\"3600\";s:8:\"startrow\";s:1:\"0\";s:5:\"items\";s:1:\"5\";s:9:\"newwindow\";i:1;s:9:\"extcredit\";s:1:\"1\";s:7:\"orderby\";s:9:\"hourposts\";s:5:\"hours\";s:2:\"24\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:36:\"边栏会员今日发帖排行模块\";s:4:\"type\";s:1:\"2\";}',2),('边栏模块_论坛之星','a:4:{s:3:\"url\";s:668:\"function=memberrank&startrow=0&items=3&newwindow=1&extcredit=1&orderby=hourposts&hours=168&jscharset=0&cachelife=43200&jstemplate=%3Cdiv%20class%3D%5C%22sidebox%20s_clear%5C%22%3E%0D%0A%3Ch4%3E%E6%9C%AC%E5%91%A8%E4%B9%8B%E6%98%9F%3C%2Fh4%3E%0D%0A%5Bnode%5D%0D%0A%5Bshow%3D1%5D%3Cdiv%20style%3D%5C%22clear%3Aboth%5C%22%3E%3Cdiv%20style%3D%5C%22float%3Aleft%3B%20margin-right%3A%2016px%3B%5C%22%3E%7Bavatarsmall%7D%3C%2Fdiv%3E%5B%2Fshow%5D%7Bmember%7D%20%5Bshow%3D1%5D%3Cbr%20%2F%3E%E5%8F%91%E5%B8%96%20%7Bvalue%7D%20%E7%AF%87%3C%2Fdiv%3E%3Cdiv%20style%3D%5C%22clear%3Aboth%3Bmargin-top%3A2px%5C%22%20%2F%3E%3C%2Fdiv%3E%5B%2Fshow%5D%0D%0A%5B%2Fnode%5D%0D%0A%3C%2Fdiv%3E&\";s:9:\"parameter\";a:9:{s:10:\"jstemplate\";s:291:\"<div class=\\\"sidebox s_clear\\\">\r\n<h4>本周之星</h4>\r\n[node]\r\n[show=1]<div style=\\\"clear:both\\\"><div style=\\\"float:left; margin-right: 16px;\\\">{avatarsmall}</div>[/show]{member} [show=1]<br />发帖 {value} 篇</div><div style=\\\"clear:both;margin-top:2px\\\" /></div>[/show]\r\n[/node]\r\n</div>\";s:9:\"cachelife\";s:5:\"43200\";s:8:\"startrow\";s:1:\"0\";s:5:\"items\";s:1:\"3\";s:9:\"newwindow\";i:1;s:9:\"extcredit\";s:1:\"1\";s:7:\"orderby\";s:9:\"hourposts\";s:5:\"hours\";s:3:\"168\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:24:\"边栏论坛之星模块\";s:4:\"type\";s:1:\"2\";}',2),('边栏模块_我的助手','a:4:{s:3:\"url\";s:78:\"function=module&module=assistant.inc.php&settings=N%3B&jscharset=0&cachelife=0\";s:9:\"parameter\";a:3:{s:6:\"module\";s:17:\"assistant.inc.php\";s:9:\"cachelife\";s:1:\"0\";s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:24:\"边栏我的助手模块\";s:4:\"type\";s:1:\"5\";}',5),('边栏模块_Google搜索','a:4:{s:3:\"url\";s:171:\"function=module&module=google.inc.php&settings=a%3A2%3A%7Bs%3A4%3A%22lang%22%3Bs%3A0%3A%22%22%3Bs%3A7%3A%22default%22%3Bs%3A1%3A%221%22%3B%7D&jscharset=0&cachelife=864000&\";s:9:\"parameter\";a:4:{s:6:\"module\";s:14:\"google.inc.php\";s:9:\"cachelife\";s:6:\"864000\";s:8:\"settings\";a:2:{s:4:\"lang\";s:0:\"\";s:7:\"default\";s:1:\"1\";}s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:26:\"边栏 Google 搜索模块\";s:4:\"type\";s:1:\"5\";}',5),('UCHome_最新动态','a:4:{s:3:\"url\";s:445:\"function=module&module=feed.inc.php&settings=a%3A6%3A%7Bs%3A5%3A%22title%22%3Bs%3A12%3A%22%E6%9C%80%E6%96%B0%E5%8A%A8%E6%80%81%22%3Bs%3A4%3A%22uids%22%3Bs%3A0%3A%22%22%3Bs%3A6%3A%22friend%22%3Bs%3A1%3A%220%22%3Bs%3A5%3A%22start%22%3Bs%3A1%3A%220%22%3Bs%3A5%3A%22limit%22%3Bs%3A2%3A%2210%22%3Bs%3A8%3A%22template%22%3Bs%3A54%3A%22%3Cdiv%20style%3D%5C%22padding-left%3A2px%5C%22%3E%7Btitle_template%7D%3C%2Fdiv%3E%22%3B%7D&jscharset=0&cachelife=0&\";s:9:\"parameter\";a:4:{s:6:\"module\";s:12:\"feed.inc.php\";s:9:\"cachelife\";s:1:\"0\";s:8:\"settings\";a:6:{s:5:\"title\";s:12:\"最新动态\";s:4:\"uids\";s:0:\"\";s:6:\"friend\";s:1:\"0\";s:5:\"start\";s:1:\"0\";s:5:\"limit\";s:2:\"10\";s:8:\"template\";s:54:\"<div style=\\\"padding-left:2px\\\">{title_template}</div>\";}s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:27:\"获取UCHome的最新动态\";s:4:\"type\";s:1:\"5\";}',5),('UCHome_最新更新空间','a:4:{s:3:\"url\";s:1388:\"function=module&module=space.inc.php&settings=a%3A17%3A%7Bs%3A5%3A%22title%22%3Bs%3A18%3A%22%E6%9C%80%E6%96%B0%E6%9B%B4%E6%96%B0%E7%A9%BA%E9%97%B4%22%3Bs%3A3%3A%22uid%22%3Bs%3A0%3A%22%22%3Bs%3A14%3A%22startfriendnum%22%3Bs%3A0%3A%22%22%3Bs%3A12%3A%22endfriendnum%22%3Bs%3A0%3A%22%22%3Bs%3A12%3A%22startviewnum%22%3Bs%3A0%3A%22%22%3Bs%3A10%3A%22endviewnum%22%3Bs%3A0%3A%22%22%3Bs%3A11%3A%22startcredit%22%3Bs%3A0%3A%22%22%3Bs%3A9%3A%22endcredit%22%3Bs%3A0%3A%22%22%3Bs%3A6%3A%22avatar%22%3Bs%3A2%3A%22-1%22%3Bs%3A10%3A%22namestatus%22%3Bs%3A2%3A%22-1%22%3Bs%3A8%3A%22dateline%22%3Bs%3A1%3A%220%22%3Bs%3A10%3A%22updatetime%22%3Bs%3A1%3A%220%22%3Bs%3A5%3A%22order%22%3Bs%3A10%3A%22updatetime%22%3Bs%3A2%3A%22sc%22%3Bs%3A4%3A%22DESC%22%3Bs%3A5%3A%22start%22%3Bs%3A1%3A%220%22%3Bs%3A5%3A%22limit%22%3Bs%3A2%3A%2210%22%3Bs%3A8%3A%22template%22%3Bs%3A267%3A%22%3Ctable%3E%0D%0A%3Ctr%3E%0D%0A%3Ctd%20width%3D%5C%2250%5C%22%20rowspan%3D%5C%222%5C%22%3E%3Ca%20href%3D%5C%22%7Buserlink%7D%5C%22%20target%3D%5C%22_blank%5C%22%3E%3Cimg%20src%3D%5C%22%7Bphoto%7D%5C%22%20%2F%3E%3C%2Fa%3E%3C%2Ftd%3E%0D%0A%3Ctd%3E%3Ca%20href%3D%5C%22%7Buserlink%7D%5C%22%20%20target%3D%5C%22_blank%5C%22%20style%3D%5C%22text-decoration%3Anone%3B%5C%22%3E%7Busername%7D%3C%2Fa%3E%3C%2Ftd%3E%0D%0A%3C%2Ftr%3E%0D%0A%3Ctr%3E%3Ctd%3E%7Bupdatetime%7D%3C%2Ftd%3E%3C%2Ftr%3E%0D%0A%3C%2Ftable%3E%22%3B%7D&jscharset=0&cachelife=0&\";s:9:\"parameter\";a:4:{s:6:\"module\";s:13:\"space.inc.php\";s:9:\"cachelife\";s:1:\"0\";s:8:\"settings\";a:17:{s:5:\"title\";s:18:\"最新更新空间\";s:3:\"uid\";s:0:\"\";s:14:\"startfriendnum\";s:0:\"\";s:12:\"endfriendnum\";s:0:\"\";s:12:\"startviewnum\";s:0:\"\";s:10:\"endviewnum\";s:0:\"\";s:11:\"startcredit\";s:0:\"\";s:9:\"endcredit\";s:0:\"\";s:6:\"avatar\";s:2:\"-1\";s:10:\"namestatus\";s:2:\"-1\";s:8:\"dateline\";s:1:\"0\";s:10:\"updatetime\";s:1:\"0\";s:5:\"order\";s:10:\"updatetime\";s:2:\"sc\";s:4:\"DESC\";s:5:\"start\";s:1:\"0\";s:5:\"limit\";s:2:\"10\";s:8:\"template\";s:267:\"<table>\r\n<tr>\r\n<td width=\\\"50\\\" rowspan=\\\"2\\\"><a href=\\\"{userlink}\\\" target=\\\"_blank\\\"><img src=\\\"{photo}\\\" /></a></td>\r\n<td><a href=\\\"{userlink}\\\"  target=\\\"_blank\\\" style=\\\"text-decoration:none;\\\">{username}</a></td>\r\n</tr>\r\n<tr><td>{updatetime}</td></tr>\r\n</table>\";}s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:36:\"获取UCHome最新更新会员空间\";s:4:\"type\";s:1:\"5\";}',5),('UCHome_最新记录','a:4:{s:3:\"url\";s:1021:\"function=module&module=doing.inc.php&settings=a%3A6%3A%7Bs%3A5%3A%22title%22%3Bs%3A12%3A%22%E6%9C%80%E6%96%B0%E8%AE%B0%E5%BD%95%22%3Bs%3A3%3A%22uid%22%3Bs%3A0%3A%22%22%3Bs%3A4%3A%22mood%22%3Bs%3A1%3A%220%22%3Bs%3A5%3A%22start%22%3Bs%3A1%3A%220%22%3Bs%3A5%3A%22limit%22%3Bs%3A2%3A%2210%22%3Bs%3A8%3A%22template%22%3Bs%3A361%3A%22%0D%0A%3Cdiv%20style%3D%5C%22padding%3A0%200%205px%200%3B%5C%22%3E%0D%0A%3Ca%20href%3D%5C%22%7Buserlink%7D%5C%22%20target%3D%5C%22_blank%5C%22%3E%3Cimg%20src%3D%5C%22%7Bphoto%7D%5C%22%20width%3D%5C%2218%5C%22%20height%3D%5C%2218%5C%22%20align%3D%5C%22absmiddle%5C%22%3E%3C%2Fa%3E%20%3Ca%20href%3D%5C%22%7Buserlink%7D%5C%22%20%20target%3D%5C%22_blank%5C%22%3E%7Busername%7D%3C%2Fa%3E%EF%BC%9A%0D%0A%3C%2Fdiv%3E%0D%0A%3Cdiv%20style%3D%5C%22padding%3A0%200%205px%2020px%3B%5C%22%3E%0D%0A%3Ca%20href%3D%5C%22%7Blink%7D%5C%22%20style%3D%5C%22color%3A%23333%3Btext-decoration%3Anone%3B%5C%22%20target%3D%5C%22_blank%5C%22%3E%7Bmessage%7D%3C%2Fa%3E%0D%0A%3C%2Fdiv%3E%22%3B%7D&jscharset=0&cachelife=0&\";s:9:\"parameter\";a:4:{s:6:\"module\";s:13:\"doing.inc.php\";s:9:\"cachelife\";s:1:\"0\";s:8:\"settings\";a:6:{s:5:\"title\";s:12:\"最新记录\";s:3:\"uid\";s:0:\"\";s:4:\"mood\";s:1:\"0\";s:5:\"start\";s:1:\"0\";s:5:\"limit\";s:2:\"10\";s:8:\"template\";s:361:\"\r\n<div style=\\\"padding:0 0 5px 0;\\\">\r\n<a href=\\\"{userlink}\\\" target=\\\"_blank\\\"><img src=\\\"{photo}\\\" width=\\\"18\\\" height=\\\"18\\\" align=\\\"absmiddle\\\"></a> <a href=\\\"{userlink}\\\"  target=\\\"_blank\\\">{username}</a>：\r\n</div>\r\n<div style=\\\"padding:0 0 5px 20px;\\\">\r\n<a href=\\\"{link}\\\" style=\\\"color:#333;text-decoration:none;\\\" target=\\\"_blank\\\">{message}</a>\r\n</div>\";}s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:27:\"获取UCHome的最新记录\";s:4:\"type\";s:1:\"5\";}',5),('UCHome_竞价排名','a:4:{s:3:\"url\";s:255:\"function=module&module=html.inc.php&settings=a%3A3%3A%7Bs%3A4%3A%22type%22%3Bs%3A1%3A%220%22%3Bs%3A4%3A%22code%22%3Bs%3A27%3A%22%3Cdiv%20id%3D%5C%22sidefeed%5C%22%3E%3C%2Fdiv%3E%22%3Bs%3A4%3A%22side%22%3Bs%3A1%3A%220%22%3B%7D&jscharset=0&cachelife=864000&\";s:9:\"parameter\";a:4:{s:6:\"module\";s:12:\"html.inc.php\";s:9:\"cachelife\";s:6:\"864000\";s:8:\"settings\";a:3:{s:4:\"type\";s:1:\"0\";s:4:\"code\";s:27:\"<div id=\\\"sidefeed\\\"></div>\";s:4:\"side\";s:1:\"0\";}s:9:\"jscharset\";s:1:\"0\";}s:7:\"comment\";s:33:\"获取UCHome的竞价排名信息\";s:4:\"type\";s:1:\"5\";}',5);

/*Table structure for table `cdb_rewardlog` */

DROP TABLE IF EXISTS `cdb_rewardlog`;

CREATE TABLE `cdb_rewardlog` (
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `authorid` mediumint(8) unsigned NOT NULL default '0',
  `answererid` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned default '0',
  `netamount` int(10) unsigned NOT NULL default '0',
  KEY `userid` (`authorid`,`answererid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_rewardlog` */

/*Table structure for table `cdb_rsscaches` */

DROP TABLE IF EXISTS `cdb_rsscaches`;

CREATE TABLE `cdb_rsscaches` (
  `lastupdate` int(10) unsigned NOT NULL default '0',
  `fid` smallint(6) unsigned NOT NULL default '0',
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `forum` char(50) NOT NULL default '',
  `author` char(15) NOT NULL default '',
  `subject` char(80) NOT NULL default '',
  `description` char(255) NOT NULL default '',
  UNIQUE KEY `tid` (`tid`),
  KEY `fid` (`fid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_rsscaches` */

/*Table structure for table `cdb_searchindex` */

DROP TABLE IF EXISTS `cdb_searchindex`;

CREATE TABLE `cdb_searchindex` (
  `searchid` int(10) unsigned NOT NULL auto_increment,
  `keywords` varchar(255) NOT NULL default '',
  `searchstring` text NOT NULL,
  `useip` varchar(15) NOT NULL default '',
  `uid` mediumint(10) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `expiration` int(10) unsigned NOT NULL default '0',
  `threadsortid` smallint(6) unsigned NOT NULL default '0',
  `threads` smallint(6) unsigned NOT NULL default '0',
  `tids` text NOT NULL,
  PRIMARY KEY  (`searchid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_searchindex` */

/*Table structure for table `cdb_sessions` */

DROP TABLE IF EXISTS `cdb_sessions`;

CREATE TABLE `cdb_sessions` (
  `sid` char(6) character set utf8 collate utf8_bin NOT NULL default '',
  `ip1` tinyint(3) unsigned NOT NULL default '0',
  `ip2` tinyint(3) unsigned NOT NULL default '0',
  `ip3` tinyint(3) unsigned NOT NULL default '0',
  `ip4` tinyint(3) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(15) NOT NULL default '',
  `groupid` smallint(6) unsigned NOT NULL default '0',
  `styleid` smallint(6) unsigned NOT NULL default '0',
  `invisible` tinyint(1) NOT NULL default '0',
  `action` tinyint(1) unsigned NOT NULL default '0',
  `lastactivity` int(10) unsigned NOT NULL default '0',
  `lastolupdate` int(10) unsigned NOT NULL default '0',
  `pageviews` smallint(6) unsigned NOT NULL default '0',
  `seccode` mediumint(6) unsigned NOT NULL default '0',
  `fid` smallint(6) unsigned NOT NULL default '0',
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `bloguid` mediumint(8) unsigned NOT NULL default '0',
  UNIQUE KEY `sid` (`sid`),
  KEY `uid` (`uid`),
  KEY `bloguid` (`bloguid`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

/*Data for the table `cdb_sessions` */

/*Table structure for table `cdb_settings` */

DROP TABLE IF EXISTS `cdb_settings`;

CREATE TABLE `cdb_settings` (
  `variable` varchar(32) NOT NULL default '',
  `value` text NOT NULL,
  PRIMARY KEY  (`variable`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_settings` */

insert  into `cdb_settings`(`variable`,`value`) values ('accessemail',''),('activitytype','朋友聚会\r\n出外郊游\r\n自驾出行\r\n公益活动\r\n线上活动'),('adminipaccess',''),('admode','1'),('allowfloatwin','1'),('archiverstatus','1'),('attachbanperiods',''),('attachdir','./attachments'),('attachexpire',''),('attachimgpost','1'),('attachrefcheck','0'),('attachsave','3'),('attachurl','attachments'),('authkey','1ccdb57zHMiu5qyR'),('authoronleft','0'),('avatarmethod','0'),('backupdir','b67f43'),('baidusitemap','1'),('baidusitemap_life','12'),('bannedmessages','1'),('bbclosed',''),('bbname','Discuz! Board'),('bbrules','0'),('bbrulestxt',''),('bdaystatus','0'),('boardlicensed','0'),('cacheindexlife','0'),('cachethreaddir','forumdata/threadcaches'),('cachethreadlife','0'),('censoremail',''),('censoruser',''),('closedreason',''),('creditnotice','1'),('creditsformula','extcredits1'),('creditsformulaexp',''),('creditsnotify',''),('creditspolicy','a:12:{s:4:\"post\";a:0:{}s:5:\"reply\";a:0:{}s:6:\"digest\";a:1:{i:1;i:10;}s:10:\"postattach\";a:0:{}s:9:\"getattach\";a:0:{}s:6:\"sendpm\";a:0:{}s:6:\"search\";a:0:{}s:15:\"promotion_visit\";a:0:{}s:18:\"promotion_register\";a:0:{}s:13:\"tradefinished\";a:0:{}s:8:\"votepoll\";a:0:{}s:10:\"lowerlimit\";a:0:{}}'),('creditstax','0.2'),('creditstrans','2'),('customauthorinfo','a:1:{i:0;a:9:{s:3:\"uid\";a:1:{s:4:\"menu\";s:1:\"1\";}s:5:\"posts\";a:1:{s:4:\"menu\";s:1:\"1\";}s:6:\"digest\";a:1:{s:4:\"menu\";s:1:\"1\";}s:7:\"credits\";a:1:{s:4:\"menu\";s:1:\"1\";}s:8:\"readperm\";a:1:{s:4:\"menu\";s:1:\"1\";}s:8:\"location\";a:1:{s:4:\"menu\";s:1:\"1\";}s:6:\"oltime\";a:1:{s:4:\"menu\";s:1:\"1\";}s:7:\"regtime\";a:1:{s:4:\"menu\";s:1:\"1\";}s:8:\"lastdate\";a:1:{s:4:\"menu\";s:1:\"1\";}}}'),('custombackup',''),('dateconvert','1'),('dateformat','Y-n-j'),('debug','1'),('delayviewcount','0'),('deletereason',''),('doublee','1'),('dupkarmarate','0'),('ec_account',''),('ec_credit','a:2:{s:18:\"maxcreditspermonth\";i:6;s:4:\"rank\";a:15:{i:1;i:4;i:2;i:11;i:3;i:41;i:4;i:91;i:5;i:151;i:6;i:251;i:7;i:501;i:8;i:1001;i:9;i:2001;i:10;i:5001;i:11;i:10001;i:12;i:20001;i:13;i:50001;i:14;i:100001;i:15;i:200001;}}'),('ec_maxcredits','1000'),('ec_maxcreditspermonth','0'),('ec_mincredits','0'),('ec_ratio','0'),('editedby','1'),('editoroptions','1'),('edittimelimit',''),('exchangemincredits','100'),('extcredits','a:2:{i:1;a:3:{s:5:\"title\";s:6:\"威望\";s:12:\"showinthread\";s:0:\"\";s:9:\"available\";i:1;}i:2;a:3:{s:5:\"title\";s:6:\"金钱\";s:12:\"showinthread\";s:0:\"\";s:9:\"available\";i:1;}}'),('fastpost','1'),('floodctrl','15'),('forumjump','0'),('forumlinkstatus','1'),('frameon','0'),('framewidth','180'),('ftp','a:10:{s:2:\"on\";s:1:\"0\";s:3:\"ssl\";s:1:\"0\";s:4:\"host\";s:0:\"\";s:4:\"port\";s:2:\"21\";s:8:\"username\";s:0:\"\";s:8:\"password\";s:0:\"\";s:9:\"attachdir\";s:1:\".\";s:9:\"attachurl\";s:0:\"\";s:7:\"hideurl\";s:1:\"0\";s:7:\"timeout\";s:1:\"0\";}'),('globalstick','1'),('google','1'),('gzipcompress','0'),('hideprivate','1'),('historyposts','1	1'),('hottopic','10'),('icp',''),('imageimpath',''),('imagelib','0'),('indexname','index.php'),('infosidestatus',''),('initcredits','0,0,0,0,0,0,0,0,0'),('insenz',''),('inviteconfig',''),('ipaccess',''),('ipregctrl',''),('jscachelife','1800'),('jsdateformat',''),('jsrefdomains',''),('jsstatus','0'),('jswizard',''),('karmaratelimit','0'),('loadctrl','0'),('losslessdel','365'),('magicdiscount','85'),('magicmarket','1'),('magicstatus','1'),('mail','a:10:{s:8:\"mailsend\";s:1:\"1\";s:6:\"server\";s:13:\"smtp.21cn.com\";s:4:\"port\";s:2:\"25\";s:4:\"auth\";s:1:\"1\";s:4:\"from\";s:26:\"Discuz <username@21cn.com>\";s:13:\"auth_username\";s:17:\"username@21cn.com\";s:13:\"auth_password\";s:8:\"password\";s:13:\"maildelimiter\";s:1:\"0\";s:12:\"mailusername\";s:1:\"1\";s:15:\"sendmail_silent\";s:1:\"1\";}'),('maxavatarpixel','120'),('maxavatarsize','20000'),('maxbdays','0'),('maxchargespan','0'),('maxfavorites','100'),('maxincperthread','0'),('maxmagicprice','50'),('maxmodworksmonths','3'),('maxonlinelist','0'),('maxonlines','5000'),('maxpolloptions','10'),('maxpostsize','10000'),('maxsearchresults','500'),('maxsigrows','100'),('maxsmilies','10'),('maxspm','0'),('maxsubscriptions','100'),('membermaxpages','100'),('memberperpage','25'),('memliststatus','1'),('minpostsize','10'),('moddisplay','flat'),('modratelimit','0'),('modreasons','广告/SPAM\r\n恶意灌水\r\n违规内容\r\n文不对题\r\n重复发帖\r\n\r\n我很赞同\r\n精品文章\r\n原创内容'),('modworkstatus','0'),('msgforward','a:3:{s:11:\"refreshtime\";i:3;s:5:\"quick\";i:1;s:8:\"messages\";a:13:{i:0;s:19:\"thread_poll_succeed\";i:1;s:19:\"thread_rate_succeed\";i:2;s:23:\"usergroups_join_succeed\";i:3;s:23:\"usergroups_exit_succeed\";i:4;s:25:\"usergroups_update_succeed\";i:5;s:20:\"buddy_update_succeed\";i:6;s:17:\"post_edit_succeed\";i:7;s:18:\"post_reply_succeed\";i:8;s:24:\"post_edit_delete_succeed\";i:9;s:22:\"post_newthread_succeed\";i:10;s:13:\"admin_succeed\";i:11;s:17:\"pm_delete_succeed\";i:12;s:15:\"search_redirect\";}}'),('msn',''),('myrecorddays','30'),('newbiespan','0'),('newbietask',''),('newsletter',''),('nocacheheaders','0'),('oltimespan','10'),('onlinehold','15'),('onlinerecord','1	1040034649'),('outextcredits',''),('postbanperiods',''),('postmodperiods',''),('postno','#'),('postnocustom',''),('postperpage','10'),('pvfrequence','60'),('pwdsafety',''),('qihoo','a:9:{s:6:\"status\";i:0;s:9:\"searchbox\";i:6;s:7:\"summary\";i:1;s:6:\"jammer\";i:1;s:9:\"maxtopics\";i:10;s:8:\"keywords\";s:0:\"\";s:10:\"adminemail\";s:0:\"\";s:8:\"validity\";i:1;s:14:\"relatedthreads\";a:6:{s:6:\"bbsnum\";i:0;s:6:\"webnum\";i:0;s:4:\"type\";a:3:{s:4:\"blog\";s:4:\"blog\";s:4:\"news\";s:4:\"news\";s:3:\"bbs\";s:3:\"bbs\";}s:6:\"banurl\";s:0:\"\";s:8:\"position\";i:1;s:8:\"validity\";i:1;}}'),('ratelogrecord','5'),('regctrl','0'),('regfloodctrl','0'),('reglinkname','注册'),('regname','register.php'),('regstatus','1'),('regverify','0'),('relatedtag',''),('reportpost','1'),('rewritecompatible',''),('rewritestatus','0'),('rssstatus','1'),('rssttl','60'),('runwizard','1'),('searchbanperiods',''),('searchctrl','30'),('seccodedata','a:13:{s:8:\"minposts\";s:0:\"\";s:16:\"loginfailedcount\";i:0;s:5:\"width\";i:150;s:6:\"height\";i:60;s:4:\"type\";s:1:\"0\";s:10:\"background\";s:1:\"1\";s:10:\"adulterate\";s:1:\"1\";s:3:\"ttf\";s:1:\"0\";s:5:\"angle\";s:1:\"0\";s:5:\"color\";s:1:\"1\";s:4:\"size\";s:1:\"0\";s:6:\"shadow\";s:1:\"1\";s:8:\"animator\";s:1:\"0\";}'),('seccodestatus','0'),('seclevel','1'),('secqaa','a:2:{s:8:\"minposts\";s:1:\"1\";s:6:\"status\";i:0;}'),('seodescription',''),('seohead',''),('seokeywords',''),('seotitle',''),('showemail',''),('showimages','1'),('showsettings','7'),('sigviewcond','0'),('sitemessage',''),('sitename','Comsenz Inc.'),('siteuniqueid','JK0FLB03bepJ7ceh'),('siteurl','http://www.comsenz.com/'),('smcols','8'),('smrows','5'),('smthumb','20'),('spacedata','a:11:{s:9:\"cachelife\";s:3:\"900\";s:14:\"limitmythreads\";s:1:\"5\";s:14:\"limitmyreplies\";s:1:\"5\";s:14:\"limitmyrewards\";s:1:\"5\";s:13:\"limitmytrades\";s:1:\"5\";s:13:\"limitmyvideos\";s:1:\"0\";s:12:\"limitmyblogs\";s:1:\"8\";s:14:\"limitmyfriends\";s:1:\"0\";s:16:\"limitmyfavforums\";s:1:\"5\";s:17:\"limitmyfavthreads\";s:1:\"0\";s:10:\"textlength\";s:3:\"300\";}'),('spacestatus','1'),('starthreshold','2'),('statcode',''),('statscachelife','180'),('statstatus',''),('styleid','1'),('stylejump','1'),('subforumsindex',''),('swfupload','1'),('tagstatus','1'),('taskon','0'),('threadmaxpages','1000'),('threadsticky','全局置顶,分类置顶,本版置顶'),('thumbheight','300'),('thumbquality','100'),('thumbstatus','0'),('thumbwidth','400'),('timeformat','H:i'),('timeoffset','8'),('topicperpage','20'),('tradetypes',''),('transfermincredits','1000'),('transsidstatus','0'),('uc','a:1:{s:7:\"addfeed\";i:1;}'),('ucactivation','1'),('upgradeurl','http://localhost/develop/dzhead/develop/upgrade.php'),('userdateformat','Y-n-j\r\nY/n/j\r\nj-n-Y\r\nj/n/Y'),('userstatusby','1'),('videoinfo','a:12:{s:4:\"open\";i:0;s:5:\"vtype\";s:34:\"新闻	军事	音乐	影视	动漫\";s:6:\"bbname\";s:0:\"\";s:3:\"url\";s:0:\"\";s:5:\"email\";s:0:\"\";s:4:\"logo\";s:0:\"\";s:8:\"sitetype\";s:251:\"新闻	军事	音乐	影视	动漫	游戏	美女	娱乐	交友	教育	艺术	学术	技术	动物	旅游	生活	时尚	电脑	汽车	手机	摄影	戏曲	外语	公益	校园	数码	电脑	历史	天文	地理	财经	地区	人物	体育	健康	综合\";s:7:\"vsiteid\";s:0:\"\";s:9:\"vpassword\";s:0:\"\";s:4:\"vkey\";s:0:\"\";s:8:\"vclasses\";a:22:{i:22;s:6:\"新闻\";i:15;s:6:\"体育\";i:27;s:6:\"教育\";i:28;s:6:\"明星\";i:26;s:6:\"美色\";i:1;s:6:\"搞笑\";i:29;s:6:\"另类\";i:18;s:6:\"影视\";i:12;s:6:\"音乐\";i:8;s:6:\"动漫\";i:7;s:6:\"游戏\";i:24;s:6:\"综艺\";i:11;s:6:\"广告\";i:19;s:6:\"艺术\";i:5;s:6:\"时尚\";i:21;s:6:\"居家\";i:23;s:6:\"旅游\";i:25;s:6:\"动物\";i:14;s:6:\"汽车\";i:30;s:6:\"军事\";i:16;s:6:\"科技\";i:31;s:6:\"其他\";}s:12:\"vclassesable\";a:22:{i:0;i:22;i:1;i:15;i:2;i:27;i:3;i:28;i:4;i:26;i:5;i:1;i:6;i:29;i:7;i:18;i:8;i:12;i:9;i:8;i:10;i:7;i:11;i:24;i:12;i:11;i:13;i:19;i:14;i:5;i:15;i:21;i:16;i:23;i:17;i:25;i:18;i:14;i:19;i:30;i:20;i:16;i:21;i:31;}}'),('viewthreadtags','100'),('visitbanperiods',''),('visitedforums','10'),('vtonlinestatus','1'),('wapcharset','2'),('wapdateformat','n/j'),('wapmps','500'),('wapppp','5'),('wapregister','0'),('wapstatus','0'),('waptpp','10'),('warningexpiration','3'),('warninglimit','3'),('watermarkminheight','0'),('watermarkminwidth','0'),('watermarkquality','80'),('watermarkstatus','0'),('watermarktext',''),('watermarktrans','65'),('watermarktype','0'),('welcomemsg',''),('welcomemsgtitle','{username}，您好，感谢您的注册，请阅读以下内容。'),('welcomemsgtxt','尊敬的{username}，您已经注册成为{sitename}的会员，请您在发表言论时，遵守当地法律法规。\r\n如果您有什么疑问可以联系管理员，Email: {adminemail}。\r\n\r\n\r\n{bbname}\r\n{time}'),('whosonlinestatus','1'),('whosonline_contract','0'),('zoomstatus','1'),('tasktypes','a:3:{s:9:\"promotion\";a:2:{s:4:\"name\";s:18:\"论坛推广任务\";s:7:\"version\";s:3:\"1.0\";}s:4:\"gift\";a:2:{s:4:\"name\";s:15:\"红包类任务\";s:7:\"version\";s:3:\"1.0\";}s:6:\"avatar\";a:2:{s:4:\"name\";s:15:\"头像类任务\";s:7:\"version\";s:3:\"1.0\";}}');

/*Table structure for table `cdb_smilies` */

DROP TABLE IF EXISTS `cdb_smilies`;

CREATE TABLE `cdb_smilies` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `typeid` smallint(6) unsigned NOT NULL,
  `displayorder` tinyint(3) NOT NULL default '0',
  `type` enum('smiley','icon') NOT NULL default 'smiley',
  `code` varchar(30) NOT NULL default '',
  `url` varchar(30) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=81 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_smilies` */

insert  into `cdb_smilies`(`id`,`typeid`,`displayorder`,`type`,`code`,`url`) values (1,1,1,'smiley',':)','smile.gif'),(2,1,2,'smiley',':(','sad.gif'),(3,1,3,'smiley',':D','biggrin.gif'),(4,1,4,'smiley',':\'(','cry.gif'),(5,1,5,'smiley',':@','huffy.gif'),(6,1,6,'smiley',':o','shocked.gif'),(7,1,7,'smiley',':P','tongue.gif'),(8,1,8,'smiley',':$','shy.gif'),(9,1,9,'smiley',';P','titter.gif'),(10,1,10,'smiley',':L','sweat.gif'),(11,1,11,'smiley',':Q','mad.gif'),(12,1,12,'smiley',':lol','lol.gif'),(13,1,13,'smiley',':loveliness:','loveliness.gif'),(14,1,14,'smiley',':funk:','funk.gif'),(15,1,15,'smiley',':curse:','curse.gif'),(16,1,16,'smiley',':dizzy:','dizzy.gif'),(17,1,17,'smiley',':shutup:','shutup.gif'),(18,1,18,'smiley',':sleepy:','sleepy.gif'),(19,1,19,'smiley',':hug:','hug.gif'),(20,1,20,'smiley',':victory:','victory.gif'),(21,1,21,'smiley',':time:','time.gif'),(22,1,22,'smiley',':kiss:','kiss.gif'),(23,1,23,'smiley',':handshake','handshake.gif'),(24,1,24,'smiley',':call:','call.gif'),(25,2,1,'smiley','{:2_25:}','01.gif'),(26,2,2,'smiley','{:2_26:}','02.gif'),(27,2,3,'smiley','{:2_27:}','03.gif'),(28,2,4,'smiley','{:2_28:}','04.gif'),(29,2,5,'smiley','{:2_29:}','05.gif'),(30,2,6,'smiley','{:2_30:}','06.gif'),(31,2,7,'smiley','{:2_31:}','07.gif'),(32,2,8,'smiley','{:2_32:}','08.gif'),(33,2,9,'smiley','{:2_33:}','09.gif'),(34,2,10,'smiley','{:2_34:}','10.gif'),(35,2,11,'smiley','{:2_35:}','11.gif'),(36,2,12,'smiley','{:2_36:}','12.gif'),(37,2,13,'smiley','{:2_37:}','13.gif'),(38,2,14,'smiley','{:2_38:}','14.gif'),(39,2,15,'smiley','{:2_39:}','15.gif'),(40,2,16,'smiley','{:2_40:}','16.gif'),(41,3,1,'smiley','{:3_41:}','01.gif'),(42,3,2,'smiley','{:3_42:}','02.gif'),(43,3,3,'smiley','{:3_43:}','03.gif'),(44,3,4,'smiley','{:3_44:}','04.gif'),(45,3,5,'smiley','{:3_45:}','05.gif'),(46,3,6,'smiley','{:3_46:}','06.gif'),(47,3,7,'smiley','{:3_47:}','07.gif'),(48,3,8,'smiley','{:3_48:}','08.gif'),(49,3,9,'smiley','{:3_49:}','09.gif'),(50,3,10,'smiley','{:3_50:}','10.gif'),(51,3,11,'smiley','{:3_51:}','11.gif'),(52,3,12,'smiley','{:3_52:}','12.gif'),(53,3,13,'smiley','{:3_53:}','13.gif'),(54,3,14,'smiley','{:3_54:}','14.gif'),(55,3,15,'smiley','{:3_55:}','15.gif'),(56,3,16,'smiley','{:3_56:}','16.gif'),(57,3,17,'smiley','{:3_57:}','17.gif'),(58,3,18,'smiley','{:3_58:}','18.gif'),(59,3,19,'smiley','{:3_59:}','19.gif'),(60,3,20,'smiley','{:3_60:}','20.gif'),(61,3,21,'smiley','{:3_61:}','21.gif'),(62,3,22,'smiley','{:3_62:}','22.gif'),(63,3,23,'smiley','{:3_63:}','23.gif'),(64,3,24,'smiley','{:3_64:}','24.gif'),(65,0,1,'icon','','icon1.gif'),(66,0,2,'icon','','icon2.gif'),(67,0,3,'icon','','icon3.gif'),(68,0,4,'icon','','icon4.gif'),(69,0,5,'icon','','icon5.gif'),(70,0,6,'icon','','icon6.gif'),(71,0,7,'icon','','icon7.gif'),(72,0,8,'icon','','icon8.gif'),(73,0,9,'icon','','icon9.gif'),(74,0,10,'icon','','icon10.gif'),(75,0,11,'icon','','icon11.gif'),(76,0,12,'icon','','icon12.gif'),(77,0,13,'icon','','icon13.gif'),(78,0,14,'icon','','icon14.gif'),(79,0,15,'icon','','icon15.gif'),(80,0,16,'icon','','icon16.gif');

/*Table structure for table `cdb_spacecaches` */

DROP TABLE IF EXISTS `cdb_spacecaches`;

CREATE TABLE `cdb_spacecaches` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `variable` varchar(20) NOT NULL,
  `value` text NOT NULL,
  `expiration` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`uid`,`variable`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_spacecaches` */

/*Table structure for table `cdb_stats` */

DROP TABLE IF EXISTS `cdb_stats`;

CREATE TABLE `cdb_stats` (
  `type` char(10) NOT NULL default '',
  `variable` char(10) NOT NULL default '',
  `count` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`type`,`variable`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_stats` */

insert  into `cdb_stats`(`type`,`variable`,`count`) values ('total','hits',1),('total','members',0),('total','guests',1),('os','Windows',1),('os','Mac',0),('os','Linux',0),('os','FreeBSD',0),('os','SunOS',0),('os','OS/2',0),('os','AIX',0),('os','Spiders',0),('os','Other',0),('browser','MSIE',1),('browser','Netscape',0),('browser','Mozilla',0),('browser','Lynx',0),('browser','Opera',0),('browser','Konqueror',0),('browser','Other',0),('week','0',0),('week','1',1),('week','2',0),('week','3',0),('week','4',0),('week','5',0),('week','6',0),('hour','00',0),('hour','01',0),('hour','02',0),('hour','03',0),('hour','04',0),('hour','05',0),('hour','06',0),('hour','07',0),('hour','08',0),('hour','09',0),('hour','10',1),('hour','11',0),('hour','12',0),('hour','13',0),('hour','14',0),('hour','15',0),('hour','16',0),('hour','17',0),('hour','18',0),('hour','19',0),('hour','20',0),('hour','21',0),('hour','22',0),('hour','23',0),('browser','Firefox',0),('browser','Safari',0);

/*Table structure for table `cdb_statvars` */

DROP TABLE IF EXISTS `cdb_statvars`;

CREATE TABLE `cdb_statvars` (
  `type` varchar(20) NOT NULL default '',
  `variable` varchar(20) NOT NULL default '',
  `value` mediumtext NOT NULL,
  PRIMARY KEY  (`type`,`variable`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_statvars` */

/*Table structure for table `cdb_styles` */

DROP TABLE IF EXISTS `cdb_styles`;

CREATE TABLE `cdb_styles` (
  `styleid` smallint(6) unsigned NOT NULL auto_increment,
  `name` varchar(20) NOT NULL default '',
  `available` tinyint(1) NOT NULL default '1',
  `templateid` smallint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`styleid`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_styles` */

insert  into `cdb_styles`(`styleid`,`name`,`available`,`templateid`) values (1,'默认风格',1,1);

/*Table structure for table `cdb_stylevars` */

DROP TABLE IF EXISTS `cdb_stylevars`;

CREATE TABLE `cdb_stylevars` (
  `stylevarid` smallint(6) unsigned NOT NULL auto_increment,
  `styleid` smallint(6) unsigned NOT NULL default '0',
  `variable` text NOT NULL,
  `substitute` text NOT NULL,
  PRIMARY KEY  (`stylevarid`),
  KEY `styleid` (`styleid`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_stylevars` */

insert  into `cdb_stylevars`(`stylevarid`,`styleid`,`variable`,`substitute`) values (1,1,'stypeid','1'),(2,1,'available',''),(3,1,'boardimg','logo.gif'),(4,1,'imgdir',''),(5,1,'styleimgdir',''),(6,1,'font','Verdana, Helvetica, Arial, sans-serif'),(7,1,'fontsize','12px'),(8,1,'smfont','Verdana, Helvetica, Arial, sans-serif'),(9,1,'smfontsize','0.83em'),(10,1,'tabletext','#444'),(11,1,'midtext','#666'),(12,1,'lighttext','#999'),(13,1,'link','#000'),(14,1,'highlightlink','#09C'),(15,1,'noticetext','#F60'),(16,1,'msgfontsize','14px'),(17,1,'msgbigsize','16px'),(18,1,'bgcolor','#0D2345 bodybg.gif repeat-x 0 90px'),(19,1,'sidebgcolor','#FFF sidebg.gif repeat-y 100% 0'),(20,1,'headerborder','1px'),(21,1,'headerbordercolor','#00B2E8'),(22,1,'headerbgcolor','#00A2D2 header.gif repeat-x 0 100%'),(23,1,'headertext','#97F2FF'),(24,1,'footertext','#8691A2'),(25,1,'menuborder','#B0E4EF'),(26,1,'menubgcolor','#EBF4FD mtabbg.gif repeat-x 0 100%'),(27,1,'menutext','#666'),(28,1,'menuhover','#1E4B7E'),(29,1,'menuhovertext','#C3D3E4'),(30,1,'wrapwidth','960px'),(31,1,'wrapbg','#FFF'),(32,1,'wrapborder','0'),(33,1,'wrapbordercolor',''),(34,1,'contentwidth','600px'),(35,1,'contentseparate','#D3E8F2'),(36,1,'inputborder','#CCC'),(37,1,'inputborderdarkcolor','#999'),(38,1,'inputbg','#FFF'),(39,1,'commonborder','#E6E7E1'),(40,1,'commonbg','#F7F7F7'),(41,1,'specialborder','#E3EDF5'),(42,1,'specialbg','#EBF2F8'),(43,1,'interleavecolor','#F5F5F5'),(44,1,'dropmenuborder','#7FCAE2'),(45,1,'dropmenubgcolor','#FEFEFE'),(46,1,'floatmaskbgcolor','#7FCAE2'),(47,1,'floatbgcolor','#F1F5FA');

/*Table structure for table `cdb_subscriptions` */

DROP TABLE IF EXISTS `cdb_subscriptions`;

CREATE TABLE `cdb_subscriptions` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `lastpost` int(10) unsigned NOT NULL default '0',
  `lastnotify` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`tid`,`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_subscriptions` */

/*Table structure for table `cdb_tags` */

DROP TABLE IF EXISTS `cdb_tags`;

CREATE TABLE `cdb_tags` (
  `tagname` char(20) NOT NULL,
  `closed` tinyint(1) NOT NULL default '0',
  `total` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY  (`tagname`),
  KEY `total` (`total`),
  KEY `closed` (`closed`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_tags` */

/*Table structure for table `cdb_tasks` */

DROP TABLE IF EXISTS `cdb_tasks`;

CREATE TABLE `cdb_tasks` (
  `taskid` smallint(6) unsigned NOT NULL auto_increment,
  `relatedtaskid` smallint(6) unsigned NOT NULL default '0',
  `available` tinyint(1) NOT NULL default '0',
  `name` varchar(50) NOT NULL default '',
  `description` text NOT NULL,
  `icon` varchar(150) NOT NULL default '',
  `applicants` mediumint(8) unsigned NOT NULL default '0',
  `achievers` mediumint(8) unsigned NOT NULL default '0',
  `tasklimits` mediumint(8) unsigned NOT NULL default '0',
  `applyperm` text NOT NULL,
  `scriptname` varchar(50) NOT NULL default '',
  `starttime` int(10) unsigned NOT NULL default '0',
  `endtime` int(10) unsigned NOT NULL default '0',
  `period` int(10) unsigned NOT NULL default '0',
  `reward` enum('credit','magic','medal','invite','group') NOT NULL default 'credit',
  `prize` varchar(15) NOT NULL default '',
  `bonus` int(10) NOT NULL default '0',
  `displayorder` smallint(6) unsigned NOT NULL default '0',
  `version` varchar(15) NOT NULL default '',
  PRIMARY KEY  (`taskid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_tasks` */

/*Table structure for table `cdb_taskvars` */

DROP TABLE IF EXISTS `cdb_taskvars`;

CREATE TABLE `cdb_taskvars` (
  `taskvarid` mediumint(8) unsigned NOT NULL auto_increment,
  `taskid` smallint(6) unsigned NOT NULL default '0',
  `sort` enum('apply','complete','setting') NOT NULL default 'complete',
  `name` varchar(100) NOT NULL default '',
  `description` varchar(255) NOT NULL default '',
  `variable` varchar(40) NOT NULL default '',
  `type` varchar(20) NOT NULL default 'text',
  `value` text NOT NULL,
  `extra` text NOT NULL,
  PRIMARY KEY  (`taskvarid`),
  KEY `taskid` (`taskid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_taskvars` */

/*Table structure for table `cdb_templates` */

DROP TABLE IF EXISTS `cdb_templates`;

CREATE TABLE `cdb_templates` (
  `templateid` smallint(6) unsigned NOT NULL auto_increment,
  `name` varchar(30) NOT NULL default '',
  `directory` varchar(100) NOT NULL default '',
  `copyright` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`templateid`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_templates` */

insert  into `cdb_templates`(`templateid`,`name`,`directory`,`copyright`) values (1,'默认模板套系','./templates/default','康盛创想（北京）科技有限公司');

/*Table structure for table `cdb_threads` */

DROP TABLE IF EXISTS `cdb_threads`;

CREATE TABLE `cdb_threads` (
  `tid` mediumint(8) unsigned NOT NULL auto_increment,
  `fid` smallint(6) unsigned NOT NULL default '0',
  `iconid` smallint(6) unsigned NOT NULL default '0',
  `typeid` smallint(6) unsigned NOT NULL default '0',
  `sortid` smallint(6) unsigned NOT NULL default '0',
  `readperm` tinyint(3) unsigned NOT NULL default '0',
  `price` smallint(6) NOT NULL default '0',
  `author` char(15) NOT NULL default '',
  `authorid` mediumint(8) unsigned NOT NULL default '0',
  `subject` char(80) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `lastpost` int(10) unsigned NOT NULL default '0',
  `lastposter` char(15) NOT NULL default '',
  `views` int(10) unsigned NOT NULL default '0',
  `replies` mediumint(8) unsigned NOT NULL default '0',
  `displayorder` tinyint(1) NOT NULL default '0',
  `highlight` tinyint(1) NOT NULL default '0',
  `digest` tinyint(1) NOT NULL default '0',
  `rate` tinyint(1) NOT NULL default '0',
  `special` tinyint(1) NOT NULL default '0',
  `attachment` tinyint(1) NOT NULL default '0',
  `subscribed` tinyint(1) NOT NULL default '0',
  `moderated` tinyint(1) NOT NULL default '0',
  `closed` mediumint(8) unsigned NOT NULL default '0',
  `itemid` mediumint(8) unsigned NOT NULL default '0',
  `supe_pushstatus` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`tid`),
  KEY `digest` (`digest`),
  KEY `sortid` (`sortid`),
  KEY `displayorder` (`fid`,`displayorder`,`lastpost`),
  KEY `typeid` (`fid`,`typeid`,`displayorder`,`lastpost`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_threads` */

/*Table structure for table `cdb_threadsmod` */

DROP TABLE IF EXISTS `cdb_threadsmod`;

CREATE TABLE `cdb_threadsmod` (
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(15) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `expiration` int(10) unsigned NOT NULL default '0',
  `action` char(5) NOT NULL,
  `status` tinyint(1) NOT NULL default '0',
  `magicid` smallint(6) unsigned NOT NULL,
  KEY `tid` (`tid`,`dateline`),
  KEY `expiration` (`expiration`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_threadsmod` */

/*Table structure for table `cdb_threadtags` */

DROP TABLE IF EXISTS `cdb_threadtags`;

CREATE TABLE `cdb_threadtags` (
  `tagname` char(20) NOT NULL,
  `tid` int(10) unsigned NOT NULL,
  KEY `tagname` (`tagname`),
  KEY `tid` (`tid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_threadtags` */

/*Table structure for table `cdb_threadtypes` */

DROP TABLE IF EXISTS `cdb_threadtypes`;

CREATE TABLE `cdb_threadtypes` (
  `typeid` smallint(6) unsigned NOT NULL auto_increment,
  `displayorder` smallint(6) NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `description` varchar(255) NOT NULL default '',
  `special` smallint(6) NOT NULL default '0',
  `modelid` smallint(6) unsigned NOT NULL default '0',
  `expiration` tinyint(1) NOT NULL default '0',
  `template` text NOT NULL,
  PRIMARY KEY  (`typeid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_threadtypes` */

/*Table structure for table `cdb_tradecomments` */

DROP TABLE IF EXISTS `cdb_tradecomments`;

CREATE TABLE `cdb_tradecomments` (
  `id` mediumint(8) NOT NULL auto_increment,
  `orderid` char(32) NOT NULL,
  `pid` int(10) unsigned NOT NULL,
  `type` tinyint(1) NOT NULL,
  `raterid` mediumint(8) unsigned NOT NULL,
  `rater` char(15) NOT NULL,
  `rateeid` mediumint(8) unsigned NOT NULL,
  `ratee` char(15) NOT NULL,
  `message` char(200) NOT NULL,
  `explanation` char(200) NOT NULL,
  `score` tinyint(1) NOT NULL,
  `dateline` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `raterid` (`raterid`,`type`,`dateline`),
  KEY `rateeid` (`rateeid`,`type`,`dateline`),
  KEY `orderid` (`orderid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_tradecomments` */

/*Table structure for table `cdb_tradelog` */

DROP TABLE IF EXISTS `cdb_tradelog`;

CREATE TABLE `cdb_tradelog` (
  `tid` mediumint(8) unsigned NOT NULL,
  `pid` int(10) unsigned NOT NULL,
  `orderid` varchar(32) NOT NULL,
  `tradeno` varchar(32) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `price` decimal(8,2) NOT NULL,
  `quality` tinyint(1) unsigned NOT NULL default '0',
  `itemtype` tinyint(1) NOT NULL default '0',
  `number` smallint(5) unsigned NOT NULL default '0',
  `tax` decimal(6,2) unsigned NOT NULL default '0.00',
  `locus` varchar(100) NOT NULL,
  `sellerid` mediumint(8) unsigned NOT NULL,
  `seller` varchar(15) NOT NULL,
  `selleraccount` varchar(50) NOT NULL,
  `buyerid` mediumint(8) unsigned NOT NULL,
  `buyer` varchar(15) NOT NULL,
  `buyercontact` varchar(50) NOT NULL,
  `buyercredits` smallint(5) unsigned NOT NULL default '0',
  `buyermsg` varchar(200) default NULL,
  `status` tinyint(1) NOT NULL default '0',
  `lastupdate` int(10) unsigned NOT NULL default '0',
  `offline` tinyint(1) NOT NULL default '0',
  `buyername` varchar(50) NOT NULL,
  `buyerzip` varchar(10) NOT NULL,
  `buyerphone` varchar(20) NOT NULL,
  `buyermobile` varchar(20) NOT NULL,
  `transport` tinyint(1) NOT NULL default '0',
  `transportfee` smallint(6) unsigned NOT NULL default '0',
  `baseprice` decimal(8,2) NOT NULL,
  `discount` tinyint(1) NOT NULL default '0',
  `ratestatus` tinyint(1) NOT NULL default '0',
  `message` text NOT NULL,
  UNIQUE KEY `orderid` (`orderid`),
  KEY `sellerid` (`sellerid`),
  KEY `buyerid` (`buyerid`),
  KEY `status` (`status`),
  KEY `buyerlog` (`buyerid`,`status`,`lastupdate`),
  KEY `sellerlog` (`sellerid`,`status`,`lastupdate`),
  KEY `tid` (`tid`,`pid`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_tradelog` */

/*Table structure for table `cdb_tradeoptionvars` */

DROP TABLE IF EXISTS `cdb_tradeoptionvars`;

CREATE TABLE `cdb_tradeoptionvars` (
  `sortid` smallint(6) unsigned NOT NULL default '0',
  `pid` mediumint(8) unsigned NOT NULL default '0',
  `optionid` smallint(6) unsigned NOT NULL default '0',
  `value` mediumtext NOT NULL,
  KEY `sortid` (`sortid`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_tradeoptionvars` */

/*Table structure for table `cdb_trades` */

DROP TABLE IF EXISTS `cdb_trades`;

CREATE TABLE `cdb_trades` (
  `tid` mediumint(8) unsigned NOT NULL,
  `pid` int(10) unsigned NOT NULL,
  `typeid` smallint(6) unsigned NOT NULL,
  `sellerid` mediumint(8) unsigned NOT NULL,
  `seller` char(15) NOT NULL,
  `account` char(50) NOT NULL,
  `subject` char(100) NOT NULL,
  `price` decimal(8,2) NOT NULL,
  `amount` smallint(6) unsigned NOT NULL default '1',
  `quality` tinyint(1) unsigned NOT NULL default '0',
  `locus` char(20) NOT NULL,
  `transport` tinyint(1) NOT NULL default '0',
  `ordinaryfee` smallint(4) unsigned NOT NULL default '0',
  `expressfee` smallint(4) unsigned NOT NULL default '0',
  `emsfee` smallint(4) unsigned NOT NULL default '0',
  `itemtype` tinyint(1) NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `expiration` int(10) unsigned NOT NULL default '0',
  `lastbuyer` char(15) NOT NULL,
  `lastupdate` int(10) unsigned NOT NULL default '0',
  `totalitems` smallint(5) unsigned NOT NULL default '0',
  `tradesum` decimal(8,2) NOT NULL default '0.00',
  `closed` tinyint(1) NOT NULL default '0',
  `aid` mediumint(8) unsigned NOT NULL,
  `displayorder` tinyint(1) NOT NULL,
  `costprice` decimal(8,2) NOT NULL,
  PRIMARY KEY  (`tid`,`pid`),
  KEY `sellerid` (`sellerid`),
  KEY `totalitems` (`totalitems`),
  KEY `tradesum` (`tradesum`),
  KEY `displayorder` (`tid`,`displayorder`),
  KEY `sellertrades` (`sellerid`,`tradesum`,`totalitems`),
  KEY `typeid` (`typeid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_trades` */

/*Table structure for table `cdb_typemodels` */

DROP TABLE IF EXISTS `cdb_typemodels`;

CREATE TABLE `cdb_typemodels` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `name` varchar(20) NOT NULL,
  `displayorder` tinyint(3) NOT NULL default '0',
  `type` tinyint(1) NOT NULL default '0',
  `options` mediumtext NOT NULL,
  `customoptions` mediumtext NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=101 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_typemodels` */

insert  into `cdb_typemodels`(`id`,`name`,`displayorder`,`type`,`options`,`customoptions`) values (1,'房屋交易信息',0,1,'7	10	13	65	66	68',''),(2,'车票交易信息',0,1,'55	56	58	67	7	13	68',''),(3,'兴趣交友信息',0,1,'8	9	31',''),(4,'公司招聘信息',0,1,'34	48	54	51	47	46	44	45	52	53','');

/*Table structure for table `cdb_typeoptions` */

DROP TABLE IF EXISTS `cdb_typeoptions`;

CREATE TABLE `cdb_typeoptions` (
  `optionid` smallint(6) unsigned NOT NULL auto_increment,
  `classid` smallint(6) unsigned NOT NULL default '0',
  `displayorder` tinyint(3) NOT NULL default '0',
  `title` varchar(100) NOT NULL default '',
  `description` varchar(255) NOT NULL default '',
  `identifier` varchar(40) NOT NULL default '',
  `type` varchar(20) NOT NULL default '',
  `rules` mediumtext NOT NULL,
  PRIMARY KEY  (`optionid`),
  KEY `classid` (`classid`)
) ENGINE=MyISAM AUTO_INCREMENT=3001 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_typeoptions` */

insert  into `cdb_typeoptions`(`optionid`,`classid`,`displayorder`,`title`,`description`,`identifier`,`type`,`rules`) values (1,0,0,'通用类','','','',''),(2,0,0,'房产类','','','',''),(3,0,0,'交友类','','','',''),(4,0,0,'求职招聘类','','','',''),(5,0,0,'交易类','','','',''),(6,0,0,'互联网类','','','',''),(7,1,0,'姓名','','name','text',''),(9,1,0,'年龄','','age','number',''),(10,1,0,'地址','','address','text',''),(11,1,0,'QQ','','qq','number',''),(12,1,0,'邮箱','','mail','email',''),(13,1,0,'电话','','phone','text',''),(14,5,0,'培训费用','','teach_pay','text',''),(15,5,0,'培训时间','','teach_time','text',''),(20,2,0,'楼层','','floor','number',''),(21,2,0,'交通状况','','traf','textarea',''),(22,2,0,'地图','','images','image',''),(24,2,0,'价格','','price','text',''),(26,5,0,'培训名称','','teach_name','text',''),(28,3,0,'身高','','heighth','number',''),(29,3,0,'体重','','weighth','number',''),(33,1,0,'照片','','photo','image',''),(35,5,0,'服务方式','','service_type','text',''),(36,5,0,'服务时间','','service_time','text',''),(37,5,0,'服务费用','','service_pay','text',''),(39,6,0,'网址','','site_url','url',''),(40,6,0,'电子邮件','','site_mail','email',''),(42,6,0,'网站名称','','site_name','text',''),(46,4,0,'职位','','recr_intend','text',''),(47,4,0,'工作地点','','recr_palce','text',''),(49,4,0,'有效期至','','recr_end','calendar',''),(51,4,0,'公司名称','','recr_com','text',''),(52,4,0,'年龄要求','','recr_age','text',''),(54,4,0,'专业','','recr_abli','text',''),(55,5,0,'始发','','leaves','text',''),(56,5,0,'终点','','boundfor','text',''),(57,6,0,'Alexa排名','','site_top','number',''),(58,5,0,'车次/航班','','train_no','text',''),(59,5,0,'数量','','trade_num','number',''),(60,5,0,'价格','','trade_price','text',''),(61,5,0,'有效期至','','trade_end','calendar',''),(63,1,0,'详细描述','','detail_content','textarea',''),(64,1,0,'籍贯','','born_place','text',''),(65,2,0,'租金','','money','text',''),(66,2,0,'面积','','acreage','text',''),(67,5,0,'发车时间','','time','calendar','N;'),(68,1,0,'所在地','','now_place','text',''),(8,1,2,'性别','','gender','radio','a:3:{s:8:\"required\";s:1:\"0\";s:12:\"unchangeable\";s:1:\"0\";s:7:\"choices\";s:12:\"1=男\r\n2=女\";}'),(16,2,0,'房屋类型','','property','select','a:1:{s:7:\"choices\";s:64:\"1=写字楼\r\n2=公寓\r\n3=小区\r\n4=平房\r\n5=别墅\r\n6=地下室\";}'),(17,2,0,'座向','','face','radio','a:3:{s:8:\"required\";s:1:\"0\";s:12:\"unchangeable\";s:1:\"0\";s:7:\"choices\";s:38:\"1=南向\r\n2=北向\r\n3=西向\r\n4=东向\";}'),(18,2,0,'装修情况','','makes','radio','a:3:{s:8:\"required\";s:1:\"0\";s:12:\"unchangeable\";s:1:\"0\";s:7:\"choices\";s:40:\"1=无装修\r\n2=简单装修\r\n3=精装修\";}'),(19,2,0,'居室','','mode','select','a:1:{s:7:\"choices\";s:57:\"1=独居\r\n2=两居室\r\n3=三居室\r\n4=四居室\r\n5=别墅\";}'),(23,2,0,'屋内设施','','equipment','checkbox','a:3:{s:8:\"required\";s:1:\"0\";s:12:\"unchangeable\";s:1:\"0\";s:7:\"choices\";s:167:\"1=水电\r\n2=宽带\r\n3=管道气\r\n4=有线电视\r\n5=电梯\r\n6=电话\r\n7=冰箱\r\n8=洗衣机\r\n9=热水器\r\n10=空调\r\n11=暖气\r\n12=微波炉\r\n13=油烟机\r\n14=饮水机\";}'),(25,2,0,'是否中介','','bool','radio','a:3:{s:8:\"required\";s:1:\"0\";s:12:\"unchangeable\";s:1:\"0\";s:7:\"choices\";s:12:\"1=是\r\n2=否\";}'),(27,3,0,'星座','','Horoscope','select','a:1:{s:7:\"choices\";s:157:\"1=白羊座\r\n2=金牛座\r\n3=双子座\r\n4=巨蟹座\r\n5=狮子座\r\n6=处女座\r\n7=天秤座\r\n8=天蝎座\r\n9=射手座\r\n10=摩羯座\r\n11=水瓶座\r\n12=双鱼座\";}'),(30,3,0,'婚姻状况','','marrige','radio','a:1:{s:7:\"choices\";s:18:\"1=已婚\r\n2=未婚\";}'),(31,3,0,'爱好','','hobby','checkbox','a:1:{s:7:\"choices\";s:242:\"1=美食\r\n2=唱歌\r\n3=跳舞\r\n4=电影\r\n5=音乐\r\n6=戏剧\r\n7=聊天\r\n8=拍托\r\n9=电脑\r\n10=网络\r\n11=游戏\r\n12=绘画\r\n13=书法\r\n14=雕塑\r\n15=异性\r\n16=阅读\r\n17=运动\r\n18=旅游\r\n19=八卦\r\n20=购物\r\n21=赚钱\r\n22=汽车\r\n23=摄影\";}'),(32,3,0,'收入范围','','salary','select','a:3:{s:8:\"required\";s:1:\"0\";s:12:\"unchangeable\";s:1:\"0\";s:7:\"choices\";s:109:\"1=保密\r\n2=800元以上\r\n3=1500元以上\r\n4=2000元以上\r\n5=3000元以上\r\n6=5000元以上\r\n7=8000元以上\";}'),(34,1,0,'学历','','education','radio','a:3:{s:8:\"required\";s:1:\"0\";s:12:\"unchangeable\";s:1:\"0\";s:7:\"choices\";s:91:\"1=文盲\r\n2=小学\r\n3=初中\r\n4=高中\r\n5=中专\r\n6=大专\r\n7=本科\r\n8=研究生\r\n9=博士\";}'),(38,5,0,'席别','','seats','select','a:1:{s:7:\"choices\";s:48:\"1=站票\r\n2=硬座\r\n3=软座\r\n4=硬卧\r\n5=软卧\";}'),(44,4,0,'是否应届','','recr_term','radio','a:3:{s:8:\"required\";s:1:\"0\";s:12:\"unchangeable\";s:1:\"0\";s:7:\"choices\";s:21:\"1=应届\r\n2=非应届\";}'),(48,4,0,'薪金','','recr_salary','select','a:1:{s:7:\"choices\";s:114:\"1=面议\r\n2=1000以下\r\n3=1000~1500\r\n4=1500~2000\r\n5=2000~3000\r\n6=3000~4000\r\n7=4000~6000\r\n8=6000~8000\r\n9=8000以上\";}'),(50,4,0,'工作性质','','recr_work','radio','a:3:{s:8:\"required\";s:1:\"0\";s:12:\"unchangeable\";s:1:\"0\";s:7:\"choices\";s:18:\"1=全职\r\n2=兼职\";}'),(53,4,0,'性别要求','','recr_sex','checkbox','a:3:{s:8:\"required\";s:1:\"0\";s:12:\"unchangeable\";s:1:\"0\";s:7:\"choices\";s:12:\"1=男\r\n2=女\";}'),(62,5,0,'付款方式','','pay_type','checkbox','a:3:{s:8:\"required\";s:1:\"0\";s:12:\"unchangeable\";s:1:\"0\";s:7:\"choices\";s:41:\"1=电汇\r\n2=支付宝\r\n3=现金\r\n4=其他\";}');

/*Table structure for table `cdb_typeoptionvars` */

DROP TABLE IF EXISTS `cdb_typeoptionvars`;

CREATE TABLE `cdb_typeoptionvars` (
  `sortid` smallint(6) unsigned NOT NULL default '0',
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `optionid` smallint(6) unsigned NOT NULL default '0',
  `expiration` int(10) unsigned NOT NULL default '0',
  `value` mediumtext NOT NULL,
  KEY `sortid` (`sortid`),
  KEY `tid` (`tid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_typeoptionvars` */

/*Table structure for table `cdb_typevars` */

DROP TABLE IF EXISTS `cdb_typevars`;

CREATE TABLE `cdb_typevars` (
  `sortid` smallint(6) NOT NULL default '0',
  `optionid` smallint(6) NOT NULL default '0',
  `available` tinyint(1) NOT NULL default '0',
  `required` tinyint(1) NOT NULL default '0',
  `unchangeable` tinyint(1) NOT NULL default '0',
  `search` tinyint(1) NOT NULL default '0',
  `displayorder` tinyint(3) NOT NULL default '0',
  UNIQUE KEY `optionid` (`sortid`,`optionid`),
  KEY `sortid` (`sortid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_typevars` */

/*Table structure for table `cdb_usergroups` */

DROP TABLE IF EXISTS `cdb_usergroups`;

CREATE TABLE `cdb_usergroups` (
  `groupid` smallint(6) unsigned NOT NULL auto_increment,
  `radminid` tinyint(3) NOT NULL default '0',
  `type` enum('system','special','member') NOT NULL default 'member',
  `system` char(8) NOT NULL default 'private',
  `grouptitle` char(30) NOT NULL default '',
  `creditshigher` int(10) NOT NULL default '0',
  `creditslower` int(10) NOT NULL default '0',
  `stars` tinyint(3) NOT NULL default '0',
  `color` char(7) NOT NULL default '',
  `groupavatar` char(60) NOT NULL default '',
  `readaccess` tinyint(3) unsigned NOT NULL default '0',
  `allowvisit` tinyint(1) NOT NULL default '0',
  `allowpost` tinyint(1) NOT NULL default '0',
  `allowreply` tinyint(1) NOT NULL default '0',
  `allowpostpoll` tinyint(1) NOT NULL default '0',
  `allowpostreward` tinyint(1) NOT NULL default '0',
  `allowposttrade` tinyint(1) NOT NULL default '0',
  `allowpostactivity` tinyint(1) NOT NULL default '0',
  `allowpostvideo` tinyint(1) NOT NULL default '0',
  `allowdirectpost` tinyint(1) NOT NULL default '0',
  `allowgetattach` tinyint(1) NOT NULL default '0',
  `allowpostattach` tinyint(1) NOT NULL default '0',
  `allowvote` tinyint(1) NOT NULL default '0',
  `allowmultigroups` tinyint(1) NOT NULL default '0',
  `allowsearch` tinyint(1) NOT NULL default '0',
  `allowavatar` tinyint(1) NOT NULL default '0',
  `allowcstatus` tinyint(1) NOT NULL default '0',
  `allowuseblog` tinyint(1) NOT NULL default '0',
  `allowinvisible` tinyint(1) NOT NULL default '0',
  `allowtransfer` tinyint(1) NOT NULL default '0',
  `allowsetreadperm` tinyint(1) NOT NULL default '0',
  `allowsetattachperm` tinyint(1) NOT NULL default '0',
  `allowhidecode` tinyint(1) NOT NULL default '0',
  `allowhtml` tinyint(1) NOT NULL default '0',
  `allowcusbbcode` tinyint(1) NOT NULL default '0',
  `allowanonymous` tinyint(1) NOT NULL default '0',
  `allownickname` tinyint(1) NOT NULL default '0',
  `allowsigbbcode` tinyint(1) NOT NULL default '0',
  `allowsigimgcode` tinyint(1) NOT NULL default '0',
  `allowviewpro` tinyint(1) NOT NULL default '0',
  `allowviewstats` tinyint(1) NOT NULL default '0',
  `disableperiodctrl` tinyint(1) NOT NULL default '0',
  `reasonpm` tinyint(1) NOT NULL default '0',
  `maxprice` smallint(6) unsigned NOT NULL default '0',
  `maxsigsize` smallint(6) unsigned NOT NULL default '0',
  `maxattachsize` mediumint(8) unsigned NOT NULL default '0',
  `maxsizeperday` int(10) unsigned NOT NULL default '0',
  `maxpostsperhour` tinyint(3) unsigned NOT NULL default '0',
  `attachextensions` char(100) NOT NULL default '',
  `raterange` char(150) NOT NULL default '',
  `mintradeprice` smallint(6) unsigned NOT NULL default '1',
  `maxtradeprice` smallint(6) unsigned NOT NULL default '0',
  `minrewardprice` smallint(6) NOT NULL default '1',
  `maxrewardprice` smallint(6) NOT NULL default '0',
  `magicsdiscount` tinyint(1) NOT NULL,
  `allowmagics` tinyint(1) unsigned NOT NULL,
  `maxmagicsweight` smallint(6) unsigned NOT NULL,
  `allowbiobbcode` tinyint(1) unsigned NOT NULL default '0',
  `allowbioimgcode` tinyint(1) unsigned NOT NULL default '0',
  `maxbiosize` smallint(6) unsigned NOT NULL default '0',
  `allowinvite` tinyint(1) NOT NULL default '0',
  `allowmailinvite` tinyint(1) NOT NULL default '0',
  `maxinvitenum` tinyint(3) unsigned NOT NULL default '0',
  `inviteprice` smallint(6) unsigned NOT NULL default '0',
  `maxinviteday` smallint(6) unsigned NOT NULL default '0',
  `allowpostdebate` tinyint(1) NOT NULL default '0',
  `tradestick` tinyint(1) unsigned NOT NULL,
  `exempt` tinyint(1) unsigned NOT NULL,
  `allowsendpm` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`groupid`),
  KEY `creditsrange` (`creditshigher`,`creditslower`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

/*Data for the table `cdb_usergroups` */

insert  into `cdb_usergroups`(`groupid`,`radminid`,`type`,`system`,`grouptitle`,`creditshigher`,`creditslower`,`stars`,`color`,`groupavatar`,`readaccess`,`allowvisit`,`allowpost`,`allowreply`,`allowpostpoll`,`allowpostreward`,`allowposttrade`,`allowpostactivity`,`allowpostvideo`,`allowdirectpost`,`allowgetattach`,`allowpostattach`,`allowvote`,`allowmultigroups`,`allowsearch`,`allowavatar`,`allowcstatus`,`allowuseblog`,`allowinvisible`,`allowtransfer`,`allowsetreadperm`,`allowsetattachperm`,`allowhidecode`,`allowhtml`,`allowcusbbcode`,`allowanonymous`,`allownickname`,`allowsigbbcode`,`allowsigimgcode`,`allowviewpro`,`allowviewstats`,`disableperiodctrl`,`reasonpm`,`maxprice`,`maxsigsize`,`maxattachsize`,`maxsizeperday`,`maxpostsperhour`,`attachextensions`,`raterange`,`mintradeprice`,`maxtradeprice`,`minrewardprice`,`maxrewardprice`,`magicsdiscount`,`allowmagics`,`maxmagicsweight`,`allowbiobbcode`,`allowbioimgcode`,`maxbiosize`,`allowinvite`,`allowmailinvite`,`maxinvitenum`,`inviteprice`,`maxinviteday`,`allowpostdebate`,`tradestick`,`exempt`,`allowsendpm`) values (1,1,'system','private','管理员',0,0,9,'','',200,1,1,1,1,1,1,1,1,3,1,1,1,1,2,3,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,0,30,500,2048000,0,0,'','1	-30	30	500',1,0,1,0,0,2,200,2,2,0,0,0,0,0,0,1,5,255,1),(2,2,'system','private','超级版主',0,0,8,'','',150,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,0,1,0,1,1,1,1,1,1,0,20,300,2048000,0,0,'chm, pdf, zip, rar, tar, gz, bzip2, gif, jpg, jpeg, png','1	-15	15	50',1,0,1,0,0,2,180,2,2,0,0,0,0,0,0,1,5,255,1),(3,3,'system','private','版主',0,0,7,'','',100,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,0,1,1,1,1,0,1,0,1,1,1,1,1,1,0,10,200,2048000,0,0,'chm, pdf, zip, rar, tar, gz, bzip2, gif, jpg, jpeg, png','1	-10	10	30',1,0,1,0,0,2,160,2,2,0,0,0,0,0,0,1,5,224,1),(4,0,'system','private','禁止发言',0,0,0,'','',0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'','',1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,5,0,1),(5,0,'system','private','禁止访问',0,0,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'','',1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,5,0,1),(6,0,'system','private','禁止 IP',0,0,0,'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'','',1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,5,0,1),(7,0,'system','private','游客',0,0,0,'','',1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'gif,jpg,jpeg,png','',1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,5,0,1),(8,0,'system','private','等待验证会员',0,0,0,'','',0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,50,0,0,0,'','',1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,5,0,1),(9,0,'member','private','乞丐',-9999999,0,0,'','',0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'chm,pdf,zip,rar,tar,gz,bzip2,gif,jpg,jpeg,png','',1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,5,0,1),(10,0,'member','private','新手上路',0,50,1,'','',10,1,1,1,0,0,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,80,0,0,0,'chm, pdf, zip, rar, tar, gz, bzip2, gif, jpg, jpeg, png','',1,0,1,0,0,1,40,1,1,0,0,0,0,0,0,1,5,0,1),(11,0,'member','private','注册会员',50,200,2,'','',20,1,1,1,1,1,1,1,1,0,1,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,0,0,0,100,0,0,0,'chm, pdf, zip, rar, tar, gz, bzip2, gif, jpg, jpeg, png','',1,0,1,0,0,1,60,1,1,0,0,0,0,0,0,1,5,0,1),(12,0,'member','private','中级会员',200,500,3,'','',30,1,1,1,1,1,1,1,1,0,1,0,1,0,1,2,0,0,0,0,0,0,0,0,1,0,0,1,0,1,1,0,0,0,150,256000,0,0,'chm, pdf, zip, rar, tar, gz, bzip2, gif, jpg, jpeg, png','',1,0,1,0,0,1,80,1,1,0,0,0,0,0,0,1,5,0,1),(13,0,'member','private','高级会员',500,1000,4,'','',50,1,1,1,1,1,1,1,1,0,1,1,1,1,1,3,1,0,0,0,0,0,0,0,1,0,1,1,0,1,1,0,0,0,200,512000,0,0,'chm, pdf, zip, rar, tar, gz, bzip2, gif, jpg, jpeg, png','1	-10	10	30',1,0,1,0,0,2,100,2,2,0,0,0,0,0,0,1,5,0,1),(14,0,'member','private','金牌会员',1000,3000,6,'','',70,1,1,1,1,1,1,1,1,0,1,1,1,1,1,3,1,0,0,0,1,1,0,0,1,0,1,1,1,1,1,0,0,0,300,1024000,0,0,'chm, pdf, zip, rar, tar, gz, bzip2, gif, jpg, jpeg, png','1	-15	15	40',1,0,1,0,0,2,120,2,2,0,0,0,0,0,0,1,5,0,1),(15,0,'member','private','论坛元老',3000,9999999,8,'','',90,1,1,1,1,1,1,1,1,0,1,1,1,1,1,3,1,0,1,0,1,1,0,0,1,1,1,1,1,1,1,0,0,0,500,2048000,0,0,'chm, pdf, zip, rar, tar, gz, bzip2, gif, jpg, jpeg, png','1	-20	20	50',1,0,1,0,0,2,140,2,2,0,0,0,0,0,0,1,5,0,1);

/*Table structure for table `cdb_validating` */

DROP TABLE IF EXISTS `cdb_validating`;

CREATE TABLE `cdb_validating` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `submitdate` int(10) unsigned NOT NULL default '0',
  `moddate` int(10) unsigned NOT NULL default '0',
  `admin` varchar(15) NOT NULL default '',
  `submittimes` tinyint(3) unsigned NOT NULL default '0',
  `status` tinyint(1) NOT NULL default '0',
  `message` text NOT NULL,
  `remark` text NOT NULL,
  PRIMARY KEY  (`uid`),
  KEY `status` (`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_validating` */

/*Table structure for table `cdb_videos` */

DROP TABLE IF EXISTS `cdb_videos`;

CREATE TABLE `cdb_videos` (
  `vid` varchar(16) NOT NULL default '',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `displayorder` tinyint(3) NOT NULL default '0',
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `pid` int(10) unsigned NOT NULL default '0',
  `vtype` tinyint(1) unsigned NOT NULL default '0',
  `vview` mediumint(8) unsigned NOT NULL default '0',
  `vtime` smallint(6) unsigned NOT NULL default '0',
  `visup` tinyint(1) unsigned NOT NULL default '0',
  `vthumb` varchar(128) NOT NULL default '',
  `vtitle` varchar(64) NOT NULL default '',
  `vclass` varchar(32) NOT NULL default '',
  `vautoplay` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`vid`),
  UNIQUE KEY `uid` (`vid`,`uid`),
  KEY `displayorder` (`displayorder`),
  KEY `dateline` (`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_videos` */

/*Table structure for table `cdb_videotags` */

DROP TABLE IF EXISTS `cdb_videotags`;

CREATE TABLE `cdb_videotags` (
  `tagname` char(10) NOT NULL default '',
  `vid` char(14) NOT NULL default '',
  `tid` mediumint(8) unsigned NOT NULL default '0',
  UNIQUE KEY `tagname` (`tagname`,`vid`),
  KEY `tid` (`tid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_videotags` */

/*Table structure for table `cdb_virtualforums` */

DROP TABLE IF EXISTS `cdb_virtualforums`;

CREATE TABLE `cdb_virtualforums` (
  `fid` smallint(6) unsigned NOT NULL auto_increment,
  `cid` mediumint(8) unsigned NOT NULL,
  `fup` smallint(6) unsigned NOT NULL,
  `type` enum('group','forum') NOT NULL default 'forum',
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `logo` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `threads` mediumint(8) unsigned NOT NULL default '0',
  `posts` mediumint(8) unsigned NOT NULL default '0',
  `lastpost` varchar(255) NOT NULL default '',
  `displayorder` tinyint(3) NOT NULL,
  PRIMARY KEY  (`fid`),
  KEY `forum` (`status`,`type`,`displayorder`),
  KEY `fup` (`fup`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_virtualforums` */

/*Table structure for table `cdb_warnings` */

DROP TABLE IF EXISTS `cdb_warnings`;

CREATE TABLE `cdb_warnings` (
  `wid` smallint(6) unsigned NOT NULL auto_increment,
  `pid` int(10) unsigned NOT NULL,
  `operatorid` mediumint(8) unsigned NOT NULL,
  `operator` char(15) NOT NULL,
  `authorid` mediumint(8) unsigned NOT NULL,
  `author` char(15) NOT NULL,
  `dateline` int(10) unsigned NOT NULL,
  `reason` char(40) NOT NULL,
  PRIMARY KEY  (`wid`),
  UNIQUE KEY `pid` (`pid`),
  KEY `authorid` (`authorid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_warnings` */

/*Table structure for table `cdb_words` */

DROP TABLE IF EXISTS `cdb_words`;

CREATE TABLE `cdb_words` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `admin` varchar(15) NOT NULL default '',
  `find` varchar(255) NOT NULL default '',
  `replacement` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `cdb_words` */

/*Table structure for table `uc_admins` */

DROP TABLE IF EXISTS `uc_admins`;

CREATE TABLE `uc_admins` (
  `uid` mediumint(8) unsigned NOT NULL auto_increment,
  `username` char(15) NOT NULL default '',
  `allowadminsetting` tinyint(1) NOT NULL default '0',
  `allowadminapp` tinyint(1) NOT NULL default '0',
  `allowadminuser` tinyint(1) NOT NULL default '0',
  `allowadminbadword` tinyint(1) NOT NULL default '0',
  `allowadmintag` tinyint(1) NOT NULL default '0',
  `allowadminpm` tinyint(1) NOT NULL default '0',
  `allowadmincredits` tinyint(1) NOT NULL default '0',
  `allowadmindomain` tinyint(1) NOT NULL default '0',
  `allowadmindb` tinyint(1) NOT NULL default '0',
  `allowadminnote` tinyint(1) NOT NULL default '0',
  `allowadmincache` tinyint(1) NOT NULL default '0',
  `allowadminlog` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uc_admins` */

/*Table structure for table `uc_applications` */

DROP TABLE IF EXISTS `uc_applications`;

CREATE TABLE `uc_applications` (
  `appid` smallint(6) unsigned NOT NULL auto_increment,
  `type` char(16) NOT NULL default '',
  `name` char(20) NOT NULL default '',
  `url` char(255) NOT NULL default '',
  `authkey` char(255) NOT NULL default '',
  `ip` char(15) NOT NULL default '',
  `viewprourl` char(255) NOT NULL,
  `apifilename` char(30) NOT NULL default 'uc.php',
  `charset` char(8) NOT NULL default '',
  `dbcharset` char(8) NOT NULL default '',
  `synlogin` tinyint(1) NOT NULL default '0',
  `recvnote` tinyint(1) default '0',
  `extra` mediumtext NOT NULL,
  `tagtemplates` mediumtext NOT NULL,
  PRIMARY KEY  (`appid`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Data for the table `uc_applications` */

insert  into `uc_applications`(`appid`,`type`,`name`,`url`,`authkey`,`ip`,`viewprourl`,`apifilename`,`charset`,`dbcharset`,`synlogin`,`recvnote`,`extra`,`tagtemplates`) values (1,'UCHOME','个人家园','http://192.168.115.2/uc/home','ofI06ezfwfb2GfbbYfecUatdJ6qbP2j2Z7DdIco1O5O6d0B4mcec7cf9bez4P0W1','','','uc.php','utf-8','utf8',1,1,'','<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\r\n<root>\r\n <item id=\"template\"><![CDATA[<a href=\"{url}\" target=\"_blank\">{subject}</a>]]></item>\r\n <item id=\"fields\">\r\n <item id=\"subject\"><![CDATA[日志标题]]></item>\r\n <item id=\"uid\"><![CDATA[用户 ID]]></item>\r\n <item id=\"username\"><![CDATA[用户名]]></item>\r\n <item id=\"dateline\"><![CDATA[日期]]></item>\r\n <item id=\"spaceurl\"><![CDATA[空间地址]]></item>\r\n <item id=\"url\"><![CDATA[日志地址]]></item>\r\n </item>\r\n</root>'),(2,'DISCUZ','Discuz!','http://192.168.115.2/uc/bbs','Ndg0E8vf69N538u9p23cX9i29eu7BceflbM7savdi3v254bdReEco90aO8det0D8','','','uc.php','utf-8','utf8',1,1,'','<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\r\n<root>\r\n <item id=\"template\"><![CDATA[<a href=\"{url}\" target=\"_blank\">{subject}</a>]]></item>\r\n <item id=\"fields\">\r\n <item id=\"subject\"><![CDATA[标题]]></item>\r\n <item id=\"uid\"><![CDATA[用户 ID]]></item>\r\n <item id=\"username\"><![CDATA[发帖者]]></item>\r\n <item id=\"dateline\"><![CDATA[日期]]></item>\r\n <item id=\"url\"><![CDATA[主题地址]]></item>\r\n </item>\r\n</root>');

/*Table structure for table `uc_badwords` */

DROP TABLE IF EXISTS `uc_badwords`;

CREATE TABLE `uc_badwords` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `admin` varchar(15) NOT NULL default '',
  `find` varchar(255) NOT NULL default '',
  `replacement` varchar(255) NOT NULL default '',
  `findpattern` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `find` (`find`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uc_badwords` */

/*Table structure for table `uc_domains` */

DROP TABLE IF EXISTS `uc_domains`;

CREATE TABLE `uc_domains` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `domain` char(40) NOT NULL default '',
  `ip` char(15) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uc_domains` */

/*Table structure for table `uc_failedlogins` */

DROP TABLE IF EXISTS `uc_failedlogins`;

CREATE TABLE `uc_failedlogins` (
  `ip` char(15) NOT NULL default '',
  `count` tinyint(1) unsigned NOT NULL default '0',
  `lastupdate` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uc_failedlogins` */

/*Table structure for table `uc_feeds` */

DROP TABLE IF EXISTS `uc_feeds`;

CREATE TABLE `uc_feeds` (
  `feedid` mediumint(8) unsigned NOT NULL auto_increment,
  `appid` varchar(30) NOT NULL default '',
  `icon` varchar(30) NOT NULL default '',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(32) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `hash_template` varchar(32) NOT NULL default '',
  `hash_data` varchar(32) NOT NULL default '',
  `title_template` text NOT NULL,
  `title_data` text NOT NULL,
  `body_template` text NOT NULL,
  `body_data` text NOT NULL,
  `body_general` text NOT NULL,
  `image_1` varchar(255) NOT NULL default '',
  `image_1_link` varchar(255) NOT NULL default '',
  `image_2` varchar(255) NOT NULL default '',
  `image_2_link` varchar(255) NOT NULL default '',
  `image_3` varchar(255) NOT NULL default '',
  `image_3_link` varchar(255) NOT NULL default '',
  `image_4` varchar(255) NOT NULL default '',
  `image_4_link` varchar(255) NOT NULL default '',
  `target_ids` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`feedid`),
  KEY `uid` (`uid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uc_feeds` */

/*Table structure for table `uc_friends` */

DROP TABLE IF EXISTS `uc_friends`;

CREATE TABLE `uc_friends` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `friendid` mediumint(8) unsigned NOT NULL default '0',
  `direction` tinyint(1) NOT NULL default '0',
  `version` int(10) unsigned NOT NULL auto_increment,
  `delstatus` tinyint(1) NOT NULL default '0',
  `comment` char(255) NOT NULL default '',
  PRIMARY KEY  (`version`),
  KEY `uid` (`uid`),
  KEY `friendid` (`friendid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uc_friends` */

/*Table structure for table `uc_mailqueue` */

DROP TABLE IF EXISTS `uc_mailqueue`;

CREATE TABLE `uc_mailqueue` (
  `mailid` int(10) unsigned NOT NULL auto_increment,
  `touid` mediumint(8) unsigned NOT NULL default '0',
  `tomail` varchar(32) NOT NULL,
  `frommail` varchar(100) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `charset` varchar(15) NOT NULL,
  `htmlon` tinyint(1) NOT NULL default '0',
  `level` tinyint(1) NOT NULL default '1',
  `dateline` int(10) unsigned NOT NULL default '0',
  `failures` tinyint(3) unsigned NOT NULL default '0',
  `appid` smallint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`mailid`),
  KEY `appid` (`appid`),
  KEY `level` (`level`,`failures`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uc_mailqueue` */

/*Table structure for table `uc_memberfields` */

DROP TABLE IF EXISTS `uc_memberfields`;

CREATE TABLE `uc_memberfields` (
  `uid` mediumint(8) unsigned NOT NULL,
  `blacklist` text NOT NULL,
  PRIMARY KEY  (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uc_memberfields` */

insert  into `uc_memberfields`(`uid`,`blacklist`) values (1,''),(2,''),(3,''),(4,''),(5,''),(6,''),(7,''),(8,''),(9,''),(10,'');

/*Table structure for table `uc_members` */

DROP TABLE IF EXISTS `uc_members`;

CREATE TABLE `uc_members` (
  `uid` mediumint(8) unsigned NOT NULL auto_increment,
  `username` char(32) NOT NULL default '',
  `password` char(32) NOT NULL default '',
  `email` char(32) NOT NULL default '',
  `name` char(20) NOT NULL default '',
  `myid` char(30) NOT NULL default '',
  `myidkey` char(16) NOT NULL default '',
  `regip` char(15) NOT NULL default '',
  `regdate` int(10) unsigned NOT NULL default '0',
  `lastloginip` int(10) NOT NULL default '0',
  `lastlogintime` int(10) unsigned NOT NULL default '0',
  `salt` char(6) NOT NULL,
  `secques` char(8) NOT NULL default '',
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

/*Data for the table `uc_members` */

insert  into `uc_members`(`uid`,`username`,`password`,`email`,`name`,`myid`,`myidkey`,`regip`,`regdate`,`lastloginip`,`lastlogintime`,`salt`,`secques`) values (1,'admin','9cdce180990a75ec506c26a49bcbc98a','admin@tanzhi.com','admin','','','192.168.115.1',1256533858,0,0,'2cd44d',''),(2,'ramen','31ad03a0bc9dd84143a101870cdecb97','ramen@123.com','ramen','','','192.168.115.1',1261707439,0,0,'f7cace',''),(3,'lele','8ea0ca6ffeabe449747f3ff264e18fce','lele@123.com','lele','','','192.168.115.1',1262551556,0,0,'4cd276',''),(4,'osk','c7c55cb51e47dca98745e95fe408190b','osk@123.com','osk','','','192.168.115.1',1262551844,0,0,'459f3f',''),(5,'moyiqun','e3f20e52fce38d9012aef38c41dd130c','moyiqun_lele@sina.com','moyiqun','','','192.168.1.110',1268063077,0,0,'5a431a',''),(6,'myqsq@sohu.com','3d107b25d097b14d5297516c6b3ecfeb','myqsq@sohu.com','myqsq','','','192.168.115.1',1274701531,0,0,'bdf733',''),(7,'myq@gmail.com','3a0642f910c5986aaa681db7608b8b8e','myq@gmail.com','myq','','','192.168.115.1',1274709069,0,0,'d7097f',''),(8,'ra@123.com','399a69c1fb3fa5c6efccb9bcb627ff7d','ra@123.com','ra','','','192.168.115.1',1274717119,0,0,'fe6c96',''),(9,'ra1@123.com','1ed345aecd99c6d6199e20d64665bc67','ra1@123.com','ra1','','','192.168.115.1',1274717309,0,0,'d3d5b9',''),(10,'ramen.sh@gmail.com','a954eec79372212079abb5b4c3a281af','ramen.sh@gmail.com','城市森林','','','192.168.115.1',1275429835,0,0,'b03d22','');

/*Table structure for table `uc_mergemembers` */

DROP TABLE IF EXISTS `uc_mergemembers`;

CREATE TABLE `uc_mergemembers` (
  `appid` smallint(6) unsigned NOT NULL,
  `username` char(32) NOT NULL default '',
  PRIMARY KEY  (`appid`,`username`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uc_mergemembers` */

/*Table structure for table `uc_newpm` */

DROP TABLE IF EXISTS `uc_newpm`;

CREATE TABLE `uc_newpm` (
  `uid` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY  (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uc_newpm` */

/*Table structure for table `uc_notelist` */

DROP TABLE IF EXISTS `uc_notelist`;

CREATE TABLE `uc_notelist` (
  `noteid` int(10) unsigned NOT NULL auto_increment,
  `operation` char(32) NOT NULL,
  `closed` tinyint(4) NOT NULL default '0',
  `totalnum` smallint(6) unsigned NOT NULL default '0',
  `succeednum` smallint(6) unsigned NOT NULL default '0',
  `getdata` mediumtext NOT NULL,
  `postdata` mediumtext NOT NULL,
  `dateline` int(10) unsigned NOT NULL default '0',
  `pri` tinyint(3) NOT NULL default '0',
  `app1` tinyint(4) NOT NULL,
  `app2` tinyint(4) NOT NULL,
  PRIMARY KEY  (`noteid`),
  KEY `closed` (`closed`,`pri`,`noteid`),
  KEY `dateline` (`dateline`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Data for the table `uc_notelist` */

insert  into `uc_notelist`(`noteid`,`operation`,`closed`,`totalnum`,`succeednum`,`getdata`,`postdata`,`dateline`,`pri`,`app1`,`app2`) values (1,'updateapps',1,0,0,'','<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\r\n<root>\r\n <item id=\"1\">\r\n <item id=\"appid\"><![CDATA[1]]></item>\r\n <item id=\"type\"><![CDATA[UCHOME]]></item>\r\n <item id=\"name\"><![CDATA[个人家园]]></item>\r\n <item id=\"url\"><![CDATA[http://192.168.115.2/uc/home]]></item>\r\n <item id=\"ip\"><![CDATA[]]></item>\r\n <item id=\"charset\"><![CDATA[utf-8]]></item>\r\n <item id=\"synlogin\"><![CDATA[1]]></item>\r\n <item id=\"extra\"><![CDATA[]]></item>\r\n </item>\r\n <item id=\"UC_API\"><![CDATA[http://192.168.115.2/uc/ucenter]]></item>\r\n</root>',0,0,0,0),(2,'updateapps',1,1,1,'','<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\r\n<root>\r\n <item id=\"1\">\r\n <item id=\"appid\"><![CDATA[1]]></item>\r\n <item id=\"type\"><![CDATA[UCHOME]]></item>\r\n <item id=\"name\"><![CDATA[个人家园]]></item>\r\n <item id=\"url\"><![CDATA[http://192.168.115.2/uc/home]]></item>\r\n <item id=\"ip\"><![CDATA[]]></item>\r\n <item id=\"charset\"><![CDATA[utf-8]]></item>\r\n <item id=\"synlogin\"><![CDATA[1]]></item>\r\n <item id=\"extra\"><![CDATA[]]></item>\r\n </item>\r\n <item id=\"2\">\r\n <item id=\"appid\"><![CDATA[2]]></item>\r\n <item id=\"type\"><![CDATA[DISCUZ]]></item>\r\n <item id=\"name\"><![CDATA[Discuz!]]></item>\r\n <item id=\"url\"><![CDATA[http://192.168.115.2/uc/bbs]]></item>\r\n <item id=\"ip\"><![CDATA[]]></item>\r\n <item id=\"charset\"><![CDATA[utf-8]]></item>\r\n <item id=\"synlogin\"><![CDATA[1]]></item>\r\n <item id=\"extra\"><![CDATA[]]></item>\r\n </item>\r\n <item id=\"UC_API\"><![CDATA[http://192.168.115.2/uc/ucenter]]></item>\r\n</root>',1256533859,0,1,0),(3,'updatepw',1,1,1,'username=admin&password=','',1274439097,0,1,0),(4,'updatepw',1,1,1,'username=admin&password=','',1274439124,0,1,0);

/*Table structure for table `uc_pms` */

DROP TABLE IF EXISTS `uc_pms`;

CREATE TABLE `uc_pms` (
  `pmid` int(10) unsigned NOT NULL auto_increment,
  `msgfrom` varchar(15) NOT NULL default '',
  `msgfromid` mediumint(8) unsigned NOT NULL default '0',
  `msgtoid` mediumint(8) unsigned NOT NULL default '0',
  `folder` enum('inbox','outbox') NOT NULL default 'inbox',
  `new` tinyint(1) NOT NULL default '0',
  `subject` varchar(75) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `message` text NOT NULL,
  `delstatus` tinyint(1) unsigned NOT NULL default '0',
  `related` int(10) unsigned NOT NULL default '0',
  `fromappid` smallint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`pmid`),
  KEY `msgtoid` (`msgtoid`,`folder`,`dateline`),
  KEY `msgfromid` (`msgfromid`,`folder`,`dateline`),
  KEY `related` (`related`),
  KEY `getnum` (`msgtoid`,`folder`,`delstatus`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `uc_pms` */

insert  into `uc_pms`(`pmid`,`msgfrom`,`msgfromid`,`msgtoid`,`folder`,`new`,`subject`,`dateline`,`message`,`delstatus`,`related`,`fromappid`) values (1,'lele',3,1,'inbox',0,'niha0',1264768602,'niha0',0,0,1),(2,'lele',1,3,'inbox',0,'niha0',1264768602,'niha0',0,0,0),(3,'lele',3,1,'inbox',0,'niha0',1264768602,'niha0',0,1,1);

/*Table structure for table `uc_protectedmembers` */

DROP TABLE IF EXISTS `uc_protectedmembers`;

CREATE TABLE `uc_protectedmembers` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(32) NOT NULL default '',
  `appid` tinyint(1) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `admin` char(15) NOT NULL default '0',
  UNIQUE KEY `username` (`username`,`appid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uc_protectedmembers` */

insert  into `uc_protectedmembers`(`uid`,`username`,`appid`,`dateline`,`admin`) values (1,'admin',1,1256533858,'admin'),(1,'admin',0,1256533859,''),(10,'ramen.sh@gmail.com',1,1275430329,'admin'),(8,'ra@123.com',1,1275430755,'admin');

/*Table structure for table `uc_settings` */

DROP TABLE IF EXISTS `uc_settings`;

CREATE TABLE `uc_settings` (
  `k` varchar(32) NOT NULL default '',
  `v` text NOT NULL,
  PRIMARY KEY  (`k`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uc_settings` */

insert  into `uc_settings`(`k`,`v`) values ('accessemail',''),('censoremail',''),('censorusername',''),('dateformat','y-n-j'),('doublee','1'),('nextnotetime','0'),('timeoffset','28800'),('pmlimit1day','100'),('pmfloodctrl','15'),('pmcenter','1'),('sendpmseccode','1'),('pmsendregdays','0'),('maildefault','username@21cn.com'),('mailsend','1'),('mailserver','smtp.21cn.com'),('mailport','25'),('mailauth','1'),('mailfrom','UCenter <username@21cn.com>'),('mailauth_username','username@21cn.com'),('mailauth_password','password'),('maildelimiter','0'),('mailusername','1'),('mailsilent','1'),('version','1.5.0');

/*Table structure for table `uc_sqlcache` */

DROP TABLE IF EXISTS `uc_sqlcache`;

CREATE TABLE `uc_sqlcache` (
  `sqlid` char(6) NOT NULL default '',
  `data` char(100) NOT NULL,
  `expiry` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`sqlid`),
  KEY `expiry` (`expiry`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uc_sqlcache` */

/*Table structure for table `uc_tags` */

DROP TABLE IF EXISTS `uc_tags`;

CREATE TABLE `uc_tags` (
  `tagname` char(20) NOT NULL,
  `appid` smallint(6) unsigned NOT NULL default '0',
  `data` mediumtext,
  `expiration` int(10) unsigned NOT NULL,
  KEY `tagname` (`tagname`,`appid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uc_tags` */

/*Table structure for table `uc_vars` */

DROP TABLE IF EXISTS `uc_vars`;

CREATE TABLE `uc_vars` (
  `name` char(32) NOT NULL default '',
  `value` char(255) NOT NULL default '',
  PRIMARY KEY  (`name`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

/*Data for the table `uc_vars` */

/*Table structure for table `uchome_ad` */

DROP TABLE IF EXISTS `uchome_ad`;

CREATE TABLE `uchome_ad` (
  `adid` smallint(6) unsigned NOT NULL auto_increment,
  `available` tinyint(1) NOT NULL default '1',
  `title` varchar(50) NOT NULL default '',
  `pagetype` varchar(20) NOT NULL default '',
  `adcode` text NOT NULL,
  `system` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`adid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_ad` */

/*Table structure for table `uchome_admin_user` */

DROP TABLE IF EXISTS `uchome_admin_user`;

CREATE TABLE `uchome_admin_user` (
  `name` varchar(32) NOT NULL default '',
  `password` varchar(32) NOT NULL default '',
  `level` int(1) NOT NULL default '0',
  `adminright` text,
  `lastvisit` int(11) NOT NULL default '0',
  `lastip` varchar(15) NOT NULL default '',
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_admin_user` */

insert  into `uchome_admin_user`(`name`,`password`,`level`,`adminright`,`lastvisit`,`lastip`) values ('admin','1bc0dc011477c984e5503484e66402c3',1,'',1284713415,'192.168.115.1');

/*Table structure for table `uchome_adminsession` */

DROP TABLE IF EXISTS `uchome_adminsession`;

CREATE TABLE `uchome_adminsession` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `ip` char(15) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `errorcount` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`uid`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

/*Data for the table `uchome_adminsession` */

/*Table structure for table `uchome_advert` */

DROP TABLE IF EXISTS `uchome_advert`;

CREATE TABLE `uchome_advert` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `targets` varchar(50) NOT NULL default '',
  `varname` varchar(20) NOT NULL default '',
  `state` tinyint(1) NOT NULL default '0',
  `vieworder` tinyint(4) default '0',
  `title` varchar(255) NOT NULL default '',
  `config` mediumtext NOT NULL,
  `day` int(11) NOT NULL,
  `week` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `total` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `vieworder` (`vieworder`),
  KEY `state` (`state`)
) ENGINE=MyISAM AUTO_INCREMENT=246 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_advert` */

insert  into `uchome_advert`(`id`,`targets`,`varname`,`state`,`vieworder`,`title`,`config`,`day`,`week`,`month`,`total`) values (228,'','notice',1,3,'数码欢乐，非常寻宝，每日送Q币！','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:46:\"数码欢乐，非常寻宝，每日送Q币！\";s:4:\"link\";s:50:\"http://digi.tech.qq.com/zt/2009/treasure/index.htm\";s:5:\"color\";s:7:\"#178517\";}',0,0,0,0),(225,'','notice',1,1,'8G超大容量网盘空间','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:26:\"8G超大容量网盘空间\";s:4:\"link\";s:24:\"http://u.115.com/?114v13\";s:5:\"color\";s:0:\"\";}',0,0,0,0),(226,'','notice',1,2,'体验云查杀-免费在线查杀木马','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:40:\"体验云查杀-免费在线查杀木马\";s:4:\"link\";s:23:\"http://aq.115.com/?v113\";s:5:\"color\";s:0:\"\";}',0,0,0,0),(223,'','footer',1,14,'网络硬盘','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:12:\"网络硬盘\";s:4:\"link\";s:17:\"http://u.115.com/\";s:5:\"color\";s:7:\"#000000\";}',0,0,0,0),(222,'','footer',1,13,'手机网址导航','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:18:\"手机网址大全\";s:4:\"link\";s:21:\"http://wap.114la.com/\";s:5:\"color\";s:7:\"#000000\";}',0,0,0,0),(221,'','footer',1,12,'健康导航','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:12:\"健康导航\";s:4:\"link\";s:19:\"http://39.114la.com\";s:5:\"color\";s:7:\"#000000\";}',0,0,0,0),(241,'','footer',1,7,'云查杀','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:12:\"115云查杀\";s:4:\"link\";s:18:\"http://aq.115.com/\";s:5:\"color\";s:7:\"#178517\";}',0,0,0,0),(220,'','footer',1,11,'免费杀毒','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:18:\"免费杀毒软件\";s:4:\"link\";s:49:\"http://www.duba.net/out_iframe/mid/rf/index.shtml\";s:5:\"color\";s:7:\"#000000\";}',0,0,0,0),(218,'','footer',1,8,'QQ导航','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:8:\"QQ导航\";s:4:\"link\";s:20:\"http://qq.114la.com/\";s:5:\"color\";s:7:\"#000000\";}',0,0,0,0),(217,'','footer',1,7,'焦点新闻','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:12:\"焦点新闻\";s:4:\"link\";s:22:\"http://news.114la.com/\";s:5:\"color\";s:7:\"#000000\";}',0,0,0,0),(216,'','footer',1,6,'求职导航','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:12:\"求职导航\";s:4:\"link\";s:21:\"http://job.114la.com/\";s:5:\"color\";s:7:\"#000000\";}',0,0,0,0),(214,'','footer',1,4,'游戏大全','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:12:\"游戏大全\";s:4:\"link\";s:22:\"http://game.114la.com/\";s:5:\"color\";s:7:\"#000000\";}',0,0,0,0),(213,'','footer',1,3,'购物导航','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:12:\"购物导航\";s:4:\"link\";s:22:\"http://shop.114la.com/\";s:5:\"color\";s:7:\"#000000\";}',0,0,0,0),(212,'','footer',1,2,'首页修复','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:12:\"首页修复\";s:4:\"link\";s:28:\"http://www.114la.com/repair/\";s:5:\"color\";s:7:\"#178517\";}',0,0,0,0),(211,'','footer',1,1,'收藏夹','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:9:\"收藏夹\";s:4:\"link\";s:21:\"http://fav.114la.com/\";s:5:\"color\";s:7:\"#000000\";}',0,0,0,0),(242,'','header',1,1,'顶部广告','a:4:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:4:\"code\";s:8:\"htmlcode\";s:563:\"<a href=\"http://spcode.baidu.com/spcode/spClick?tn=uc_sp&ctn=0&styleid=1&tourl=http://www.amazon.cn?source=uapcpa_uc_sp\"><img src=\"static/images/banner/120_60.gif\" alt=\"卓越购书\" / ></a>\r\n<a href=\"http://u.115.com/?13\"><img src=\"http://www.114la.com/image/115-u_1.gif\" alt=\"115网络U盘\" / ></a>\r\n<a href=\"http://spcode.baidu.com/spcode/spClick?tn=uc_sp&ctn=0&styleid=1&tourl=http://union.dangdang.com/transfer/transfer.aspx?from=P-267723-uc_sp&backurl=http://www.dangdang.com\"><img src=\"static/images/banner/dangdang-120.gif\" alt=\"当当网\" / ></a>\";}',0,0,0,0),(243,'','footer',1,12,'淘宝生活','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:12:\"淘宝生活\";s:4:\"link\";s:24:\"http://taobao.114la.com/\";s:5:\"color\";s:7:\"#000000\";}',0,0,0,0),(244,'','footer',1,13,'查询工具','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:12:\"查询工具\";s:4:\"link\";s:20:\"http://tool.115.com/\";s:5:\"color\";s:7:\"#000000\";}',0,0,0,0),(245,'','notice',1,5,'怎样上网更安全？888小时免费杀毒软件','a:6:{s:9:\"starttime\";s:0:\"\";s:7:\"endtime\";s:0:\"\";s:5:\"style\";s:3:\"txt\";s:5:\"title\";s:51:\"怎样上网更安全？888小时免费杀毒软件\";s:4:\"link\";s:49:\"http://www.duba.net/out_iframe/mid/rf/index.shtml\";s:5:\"color\";s:0:\"\";}',0,0,0,0);

/*Table structure for table `uchome_album` */

DROP TABLE IF EXISTS `uchome_album`;

CREATE TABLE `uchome_album` (
  `albumid` mediumint(8) unsigned NOT NULL auto_increment,
  `albumname` varchar(50) NOT NULL default '',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(15) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `updatetime` int(10) unsigned NOT NULL default '0',
  `picnum` smallint(6) unsigned NOT NULL default '0',
  `pic` varchar(60) NOT NULL default '',
  `picflag` tinyint(1) NOT NULL default '0',
  `friend` tinyint(1) NOT NULL default '0',
  `password` varchar(10) NOT NULL default '',
  `target_ids` text NOT NULL,
  PRIMARY KEY  (`albumid`),
  KEY `uid` (`uid`,`updatetime`),
  KEY `updatetime` (`updatetime`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_album` */

insert  into `uchome_album`(`albumid`,`albumname`,`uid`,`username`,`dateline`,`updatetime`,`picnum`,`pic`,`picflag`,`friend`,`password`,`target_ids`) values (1,'我的相册',1,'admin',1258952151,1264944906,5,'201001/31/1_1264944906EvcE.jpg',1,0,'','');

/*Table structure for table `uchome_appcreditlog` */

DROP TABLE IF EXISTS `uchome_appcreditlog`;

CREATE TABLE `uchome_appcreditlog` (
  `logid` mediumint(8) unsigned NOT NULL auto_increment,
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `appid` mediumint(8) unsigned NOT NULL default '0',
  `appname` varchar(60) NOT NULL default '',
  `type` tinyint(1) NOT NULL default '0',
  `credit` mediumint(8) unsigned NOT NULL default '0',
  `note` text NOT NULL,
  `dateline` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`logid`),
  KEY `uid` (`uid`,`dateline`),
  KEY `appid` (`appid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_appcreditlog` */

/*Table structure for table `uchome_blacklist` */

DROP TABLE IF EXISTS `uchome_blacklist`;

CREATE TABLE `uchome_blacklist` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `buid` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`uid`,`buid`),
  KEY `uid` (`uid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_blacklist` */

/*Table structure for table `uchome_block` */

DROP TABLE IF EXISTS `uchome_block`;

CREATE TABLE `uchome_block` (
  `bid` smallint(6) unsigned NOT NULL auto_increment,
  `blockname` varchar(40) NOT NULL default '',
  `blocksql` text NOT NULL,
  `cachename` varchar(30) NOT NULL default '',
  `cachetime` smallint(6) unsigned NOT NULL default '0',
  `startnum` tinyint(3) unsigned NOT NULL default '0',
  `num` tinyint(3) unsigned NOT NULL default '0',
  `perpage` tinyint(3) unsigned NOT NULL default '0',
  `htmlcode` text NOT NULL,
  PRIMARY KEY  (`bid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_block` */

/*Table structure for table `uchome_blog` */

DROP TABLE IF EXISTS `uchome_blog`;

CREATE TABLE `uchome_blog` (
  `blogid` mediumint(8) unsigned NOT NULL auto_increment,
  `topicid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(32) NOT NULL default '',
  `subject` char(80) NOT NULL default '',
  `classid` smallint(6) unsigned NOT NULL default '0',
  `viewnum` mediumint(8) unsigned NOT NULL default '0',
  `replynum` mediumint(8) unsigned NOT NULL default '0',
  `hot` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `pic` char(120) NOT NULL default '',
  `picflag` tinyint(1) NOT NULL default '0',
  `noreply` tinyint(1) NOT NULL default '0',
  `friend` tinyint(1) NOT NULL default '0',
  `password` char(10) NOT NULL default '',
  `click_1` smallint(6) unsigned NOT NULL default '0',
  `click_2` smallint(6) unsigned NOT NULL default '0',
  `click_3` smallint(6) unsigned NOT NULL default '0',
  `click_4` smallint(6) unsigned NOT NULL default '0',
  `click_5` smallint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`blogid`),
  KEY `uid` (`uid`,`dateline`),
  KEY `topicid` (`topicid`,`dateline`),
  KEY `dateline` (`dateline`)
) ENGINE=MyISAM AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_blog` */

/*Table structure for table `uchome_blogfield` */

DROP TABLE IF EXISTS `uchome_blogfield`;

CREATE TABLE `uchome_blogfield` (
  `blogid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `tag` varchar(255) NOT NULL default '',
  `message` mediumtext NOT NULL,
  `postip` varchar(20) NOT NULL default '',
  `related` text NOT NULL,
  `relatedtime` int(10) unsigned NOT NULL default '0',
  `target_ids` text NOT NULL,
  `hotuser` text NOT NULL,
  `magiccolor` tinyint(6) NOT NULL default '0',
  `magicpaper` tinyint(6) NOT NULL default '0',
  `magiccall` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`blogid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_blogfield` */

/*Table structure for table `uchome_bookmark` */

DROP TABLE IF EXISTS `uchome_bookmark`;

CREATE TABLE `uchome_bookmark` (
  `bmid` mediumint(8) unsigned NOT NULL auto_increment,
  `uid` mediumint(8) unsigned NOT NULL,
  `groupid` smallint(8) unsigned NOT NULL default '0',
  `parentid` smallint(8) NOT NULL default '0',
  `linkid` smallint(8) NOT NULL default '0',
  `level` smallint(1) unsigned NOT NULL default '0',
  `subject` text NOT NULL,
  `description` text NOT NULL,
  `tag` text NOT NULL,
  `dateline` int(11) NOT NULL,
  `type` tinyint(1) unsigned NOT NULL default '0',
  `viewnum` mediumint(8) unsigned NOT NULL default '0',
  `lastvisit` int(11) NOT NULL,
  `browserid` mediumint(1) unsigned NOT NULL default '0',
  PRIMARY KEY  (`bmid`)
) ENGINE=MyISAM AUTO_INCREMENT=172 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_bookmark` */

insert  into `uchome_bookmark`(`bmid`,`uid`,`groupid`,`parentid`,`linkid`,`level`,`subject`,`description`,`tag`,`dateline`,`type`,`viewnum`,`lastvisit`,`browserid`) values (1,1,8000,0,0,1,'链接','','',1270197450,1,0,0,1),(2,1,0,0,2,1,'2010-06-04','数万首歌曲音乐在线试听','a:6:{i:101;s:12:\"在线试听\";i:102;s:12:\"音乐下载\";i:103;s:15:\"好听音乐网\";i:15;s:5:\"music\";i:104;s:7:\"haoting\";i:55;s:6:\"搜索\";}',1275595388,0,0,0,1),(3,1,0,0,3,1,'GoalHi','aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa','a:9:{i:17;s:6:\"足球\";i:19;s:6:\"中超\";i:20;s:6:\"英超\";i:21;s:6:\"意甲\";i:22;s:6:\"西甲\";i:23;s:6:\"欧冠\";i:24;s:9:\"冠军杯\";i:25;s:12:\"五大联赛\";i:26;s:12:\"中国足球\";}',1275963204,0,6,1273275399,1),(7,1,0,0,3,1,'GoalHi足球—努力做最好的足球网站','','',1270270571,0,0,0,1),(6,1,0,0,5,1,'新浪首页','','',1270270225,0,0,0,1),(8,1,0,0,6,1,'当当网—网上购物中心：图书、母婴、美妆、家居、数码、家电、服装、鞋包等，正品低价，货到','','',1270454831,0,0,0,1),(9,1,0,0,7,1,'我的空间 - Powered by UCenter Home','','',1270768583,0,0,0,1),(123,1,8004,8001,0,2,'体育','','',1270974115,1,0,0,2),(121,1,0,8002,8,2,'使用火狐中国版','','',1270973915,0,0,0,2),(119,1,8002,0,0,1,'书签工具栏','','',1270973914,1,0,0,2),(118,1,0,8001,9,2,'腾讯首页','','',1270973914,0,0,0,2),(117,1,0,8001,10,2,'网易','','',1270973914,0,0,0,2),(116,1,8001,0,0,1,'书签菜单','','',1270973914,1,0,0,2),(125,1,0,8001,11,2,'分类: 动作 - 电影频道','','',1271334105,0,0,0,2),(126,1,8005,0,0,1,'体育','','',1274240076,1,0,0,1),(127,1,0,8000,2,2,'好听音乐网','数万首歌曲音乐在线试听','a:6:{i:101;s:12:\"在线试听\";i:102;s:12:\"音乐下载\";i:103;s:15:\"好听音乐网\";i:15;s:5:\"music\";i:104;s:7:\"haoting\";i:55;s:6:\"搜索\";}',1274240394,0,0,0,1),(128,1,8006,8005,0,2,'足球','','',1274856048,1,0,0,1),(133,1,8007,8005,0,2,'篮球','','',1274874904,1,0,0,1),(134,1,8008,8006,0,3,'国际足球','','',1274874921,1,0,0,1),(135,1,8009,8008,0,4,'欧洲足球','','',1274876126,1,0,0,1),(136,1,0,8009,4,5,'天下足球网','','',1274902484,0,0,0,1),(137,1,8010,8006,0,3,'亚洲足球','','',1274898001,1,0,0,1),(138,1,0,0,16,1,'球皇网','','',1275167269,0,0,0,1),(139,1,0,0,17,1,'nba','','',1275167334,0,0,0,1),(140,1,0,0,18,1,'和讯股票','','',1275167365,0,0,0,1),(148,10,8001,0,0,1,'Links','','',1280690640,1,0,0,1),(155,10,0,0,21,1,'天涯社区_全球华人网上家园','','',1284442962,0,2,0,1),(143,10,8000,0,0,1,'科幻小说','','',1276169928,1,0,0,1),(162,10,0,8000,6,2,'当当网—网上购物中心：图书、母婴、美妆、家居、数码、家电、服装、鞋包等，正品低价，货到付款','','a:39:{i:107;s:9:\"当当网\";i:108;s:6:\"当当\";i:109;s:12:\"网上购物\";i:110;s:12:\"网上商城\";i:111;s:12:\"网上买书\";i:112;s:12:\"购物中心\";i:113;s:12:\"在线购物\";i:114;s:6:\"图书\";i:115;s:6:\"影视\";i:116;s:6:\"音像\";i:117;s:12:\"教育音像\";i:118;s:3:\"DVD\";i:119;s:6:\"百货\";i:120;s:6:\"母婴\";i:121;s:6:\"家居\";i:122;s:6:\"家纺\";i:123;s:6:\"厨具\";i:124;s:9:\"化妆品\";i:125;s:6:\"美妆\";i:126;s:18:\"个人护理用品\";i:127;s:6:\"数码\";i:98;s:6:\"电脑\";i:128;s:9:\"笔记本\";i:129;s:4:\"u盘\";i:99;s:6:\"手机\";i:130;s:3:\"mp3\";i:131;s:3:\"mp4\";i:132;s:12:\"数码相机\";i:133;s:6:\"摄影\";i:134;s:6:\"摄像\";i:135;s:6:\"家电\";i:136;s:6:\"软件\";i:11;s:6:\"游戏\";i:137;s:6:\"服装\";i:138;s:3:\"鞋\";i:139;s:12:\"礼品箱包\";i:140;s:12:\"钟表首饰\";i:141;s:6:\"玩具\";i:142;s:19:\"运动健康用品\n\";}',1281325773,0,0,0,1),(145,10,0,8000,12,2,'百度','','',1275942381,0,1,0,1),(146,10,0,8000,1,2,'好听音乐网','数万首歌曲音乐在线试听','a:6:{i:101;s:12:\"在线试听\";i:102;s:12:\"音乐下载\";i:103;s:15:\"好听音乐网\";i:15;s:5:\"music\";i:104;s:7:\"haoting\";i:55;s:6:\"搜索\";}',1275943913,0,0,0,1),(158,10,0,0,24,1,'军事－中华网－中国最大的军事网站－男性最喜爱的网站！','','',1280926642,0,0,0,1),(159,10,0,0,25,1,'新浪军事_新浪网','','',1280926817,0,0,0,1),(171,10,0,0,32,1,'晋江','','a:2:{i:1;s:6:\"小说\";i:3;s:6:\"军事\";}',1283828201,0,0,0,1);

/*Table structure for table `uchome_browser` */

DROP TABLE IF EXISTS `uchome_browser`;

CREATE TABLE `uchome_browser` (
  `browserid` mediumint(8) unsigned NOT NULL default '0',
  `browsername` varchar(32) NOT NULL default '',
  `maxlev` smallint(1) unsigned NOT NULL default '0',
  `maxchild` smallint(3) unsigned NOT NULL default '0',
  `titlelen` smallint(3) unsigned NOT NULL default '0',
  `dirlen` smallint(3) unsigned NOT NULL default '0',
  `urllen` smallint(3) unsigned NOT NULL default '0',
  `taglen` smallint(3) unsigned NOT NULL default '128',
  `deslen` smallint(3) unsigned NOT NULL default '0',
  `speicalchar` tinyint(1) unsigned NOT NULL default '0',
  PRIMARY KEY  (`browserid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_browser` */

insert  into `uchome_browser`(`browserid`,`browsername`,`maxlev`,`maxchild`,`titlelen`,`dirlen`,`urllen`,`taglen`,`deslen`,`speicalchar`) values (1,'ie',5,128,210,202,512,128,512,0),(2,'firefox',6,128,512,256,512,128,512,1),(3,'opera',5,128,512,256,512,128,512,1);

/*Table structure for table `uchome_cache` */

DROP TABLE IF EXISTS `uchome_cache`;

CREATE TABLE `uchome_cache` (
  `cachekey` varchar(16) NOT NULL default '',
  `value` mediumtext NOT NULL,
  `mtime` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`cachekey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_cache` */

/*Table structure for table `uchome_cknum` */

DROP TABLE IF EXISTS `uchome_cknum`;

CREATE TABLE `uchome_cknum` (
  `sid` varchar(8) NOT NULL default '',
  `nmsg` varchar(4) NOT NULL default '',
  `time` int(10) NOT NULL default '0',
  PRIMARY KEY  (`sid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_cknum` */

/*Table structure for table `uchome_class` */

DROP TABLE IF EXISTS `uchome_class`;

CREATE TABLE `uchome_class` (
  `classid` mediumint(8) unsigned NOT NULL auto_increment,
  `classname` char(40) NOT NULL default '',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`classid`),
  KEY `uid` (`uid`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_class` */

insert  into `uchome_class`(`classid`,`classname`,`uid`,`dateline`) values (1,'qt',1,1256978318),(2,'tcp',1,1258082657),(3,'mips',1,1258331543),(4,'dslam',1,1258875457),(5,'IC',4,1262971990),(6,'gcc',4,1263058864),(7,'socket',1,1265292397),(8,'hardware',1,1265303632),(9,'php',1,1266218960),(10,'vim',1,1266507335),(11,'javascript',1,1267115630);

/*Table structure for table `uchome_click` */

DROP TABLE IF EXISTS `uchome_click`;

CREATE TABLE `uchome_click` (
  `clickid` smallint(6) unsigned NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `icon` varchar(100) NOT NULL default '',
  `idtype` varchar(15) NOT NULL default '',
  `displayorder` tinyint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`clickid`),
  KEY `idtype` (`idtype`,`displayorder`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_click` */

insert  into `uchome_click`(`clickid`,`name`,`icon`,`idtype`,`displayorder`) values (1,'路过','luguo.gif','blogid',0),(2,'雷人','leiren.gif','blogid',0),(3,'握手','woshou.gif','blogid',0),(4,'鲜花','xianhua.gif','blogid',0),(5,'鸡蛋','jidan.gif','blogid',0),(6,'漂亮','piaoliang.gif','picid',0),(7,'酷毙','kubi.gif','picid',0),(8,'雷人','leiren.gif','picid',0),(9,'鲜花','xianhua.gif','picid',0),(10,'鸡蛋','jidan.gif','picid',0),(11,'搞笑','gaoxiao.gif','tid',0),(12,'迷惑','mihuo.gif','tid',0),(13,'雷人','leiren.gif','tid',0),(14,'鲜花','xianhua.gif','tid',0),(15,'鸡蛋','jidan.gif','tid',0);

/*Table structure for table `uchome_clickuser` */

DROP TABLE IF EXISTS `uchome_clickuser`;

CREATE TABLE `uchome_clickuser` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(32) NOT NULL default '',
  `id` mediumint(8) unsigned NOT NULL default '0',
  `idtype` varchar(15) NOT NULL default '',
  `clickid` smallint(6) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  KEY `id` (`id`,`idtype`,`dateline`),
  KEY `uid` (`uid`,`idtype`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_clickuser` */

/*Table structure for table `uchome_comment` */

DROP TABLE IF EXISTS `uchome_comment`;

CREATE TABLE `uchome_comment` (
  `cid` mediumint(8) unsigned NOT NULL auto_increment,
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `id` mediumint(8) unsigned NOT NULL default '0',
  `idtype` varchar(20) NOT NULL default '',
  `authorid` mediumint(8) unsigned NOT NULL default '0',
  `author` varchar(32) NOT NULL default '',
  `ip` varchar(20) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `message` text NOT NULL,
  `magicflicker` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`cid`),
  KEY `authorid` (`authorid`,`idtype`),
  KEY `id` (`id`,`idtype`,`dateline`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_comment` */

insert  into `uchome_comment`(`cid`,`uid`,`id`,`idtype`,`authorid`,`author`,`ip`,`dateline`,`message`,`magicflicker`) values (1,3,24,'blogid',1,'admin','192.168.115.1',1264768714,'very good',0);

/*Table structure for table `uchome_config` */

DROP TABLE IF EXISTS `uchome_config`;

CREATE TABLE `uchome_config` (
  `var` varchar(30) NOT NULL default '',
  `datavalue` text NOT NULL,
  PRIMARY KEY  (`var`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_config` */

insert  into `uchome_config`(`var`,`datavalue`) values ('sitename','我的空间'),('template','default'),('adminemail','webmaster@192.168.115.2'),('onlinehold','1800'),('timeoffset','8'),('maxpage','100'),('starcredit','100'),('starlevelnum','5'),('cachemode','database'),('cachegrade','0'),('allowcache','1'),('allowdomain','0'),('allowrewrite','0'),('allowwatermark','0'),('allowftp','0'),('holddomain','www|*blog*|*space*|x'),('mtagminnum','5'),('feedday','7'),('feedmaxnum','100'),('feedfilternum','10'),('importnum','100'),('maxreward','10'),('singlesent','50'),('groupnum','8'),('closeregister','0'),('closeinvite','0'),('close','0'),('networkpublic','1'),('networkpage','1'),('seccode_register','1'),('uc_tagrelated','1'),('manualmoderator','1'),('linkguide','1'),('showall','1'),('sendmailday','0'),('realname','0'),('namecheck','0'),('namechange','0'),('name_allowviewspace','1'),('name_allowfriend','1'),('name_allowpoke','1'),('name_allowdoing','1'),('name_allowblog','0'),('name_allowalbum','0'),('name_allowthread','0'),('name_allowshare','0'),('name_allowcomment','0'),('name_allowpost','0'),('showallfriendnum','10'),('feedtargetblank','1'),('feedread','1'),('feedhotnum','3'),('feedhotday','2'),('feedhotmin','3'),('feedhiddenicon','friend,profile,task,wall'),('uc_tagrelatedtime','86400'),('privacy','a:2:{s:4:\"view\";a:12:{s:5:\"index\";i:0;s:7:\"profile\";i:0;s:6:\"friend\";i:0;s:4:\"wall\";i:0;s:4:\"feed\";i:0;s:4:\"mtag\";i:0;s:5:\"event\";i:0;s:5:\"doing\";i:0;s:4:\"blog\";i:0;s:5:\"album\";i:0;s:5:\"share\";i:0;s:4:\"poll\";i:0;}s:4:\"feed\";a:21:{s:5:\"doing\";i:1;s:4:\"blog\";i:1;s:6:\"upload\";i:1;s:5:\"share\";i:1;s:4:\"poll\";i:1;s:8:\"joinpoll\";i:1;s:6:\"thread\";i:1;s:4:\"post\";i:1;s:4:\"mtag\";i:1;s:5:\"event\";i:1;s:4:\"join\";i:1;s:6:\"friend\";i:1;s:7:\"comment\";i:1;s:4:\"show\";i:1;s:9:\"spaceopen\";i:1;s:6:\"credit\";i:1;s:6:\"invite\";i:1;s:4:\"task\";i:1;s:7:\"profile\";i:1;s:5:\"album\";i:1;s:5:\"click\";i:1;}}'),('cronnextrun','1284714420'),('my_status','0'),('uniqueemail','1'),('updatestat','1'),('my_showgift','1'),('topcachetime','60'),('newspacenum','3'),('sitekey','27eaef3UkjDtZ6DD'),('siteallurl',''),('licensed','0'),('debuginfo','0'),('miibeian',''),('headercharset','0'),('avatarreal','0'),('uc_dir',''),('my_ip',''),('closereason',''),('checkemail','0'),('regipdate',''),('my_closecheckupdate','0'),('openxmlrpc','0'),('domainroot',''),('name_allowpoll','0'),('name_allowevent','0'),('name_allowuserapp','0'),('video_allowviewphoto','0'),('video_allowfriend','0'),('video_allowpoke','0'),('video_allowwall','0'),('video_allowcomment','0'),('video_allowdoing','0'),('video_allowblog','0'),('video_allowalbum','0'),('video_allowthread','0'),('video_allowpoll','0'),('video_allowevent','0'),('video_allowshare','0'),('video_allowpost','0'),('video_allowuserapp','0'),('ftpurl',''),('newspaceavatar','0'),('newspacerealname','0'),('newspacevideophoto','0');

/*Table structure for table `uchome_coolclass` */

DROP TABLE IF EXISTS `uchome_coolclass`;

CREATE TABLE `uchome_coolclass` (
  `classid` int(15) NOT NULL auto_increment,
  `siteclassid` mediumint(8) unsigned NOT NULL default '0',
  `classname` char(20) default NULL,
  `displayorder` int(11) NOT NULL default '100',
  `sitenum` int(11) NOT NULL default '0',
  `navigation` tinyint(1) NOT NULL default '0',
  `path` varchar(255) NOT NULL,
  PRIMARY KEY  (`classid`)
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_coolclass` */

insert  into `uchome_coolclass`(`classid`,`siteclassid`,`classname`,`displayorder`,`sitenum`,`navigation`,`path`) values (1,644,'文学',1,7,1,'html/xiaoshuo/'),(2,0,'两性',19,6,0,'html/sex/'),(3,668,'博客',13,6,1,'html/blog/'),(4,0,'论坛',24,6,0,'html/bbs/'),(5,698,'游戏',3,7,1,'html/games/'),(6,2215,'酷玩',5,6,1,'html/xiaoyouxi/'),(7,0,'图片',21,6,0,'html/bizhi/'),(8,715,'音乐',2,6,1,'html/music/'),(9,0,'军事',7,6,0,'html/junshi/'),(10,0,'健康',26,7,0,'html/health/'),(11,0,'手机',15,6,0,'html/shouji/'),(12,0,'交友',20,6,0,'html/love/'),(14,0,'新闻',9,8,0,'html/news/'),(15,0,'财经',10,7,0,'html/caijinggushi/'),(16,0,'购物',12,7,0,'html/gouwu/'),(17,0,'银行',14,7,0,'html/bank/'),(18,0,'旅游',23,8,0,'html/travel/'),(19,0,'体育',22,7,0,'html/tiyu/'),(20,0,'人才',17,6,0,'html/rencai/'),(21,0,'邮箱',8,7,0,'html/mail/'),(22,0,'软件',6,6,0,'html/soft/'),(23,803,'视频',4,7,1,'html/vedio/'),(24,1168,'汽车',16,6,1,'html/car/'),(25,0,'淘宝',11,6,0,'http://go.all4ad.cn/jump.aspx?locid=592'),(26,0,'女性',18,0,0,'html/lady/');

/*Table structure for table `uchome_coolsite` */

DROP TABLE IF EXISTS `uchome_coolsite`;

CREATE TABLE `uchome_coolsite` (
  `id` int(11) NOT NULL auto_increment,
  `name` char(255) NOT NULL default '',
  `url` char(255) NOT NULL default '',
  `class` int(11) NOT NULL default '0',
  `displayorder` int(11) NOT NULL default '100',
  `good` tinyint(1) NOT NULL default '0',
  `day` int(11) NOT NULL,
  `week` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `total` int(11) NOT NULL,
  `namecolor` char(7) NOT NULL,
  `yesterday` int(11) NOT NULL default '0',
  `byesterday` int(11) NOT NULL default '0',
  `starttime` int(11) NOT NULL default '0',
  `endtime` int(11) NOT NULL default '0',
  `remark` text NOT NULL,
  `end` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `url` (`url`),
  KEY `starttime` (`starttime`),
  KEY `endtime` (`endtime`)
) ENGINE=MyISAM AUTO_INCREMENT=171 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_coolsite` */

insert  into `uchome_coolsite`(`id`,`name`,`url`,`class`,`displayorder`,`good`,`day`,`week`,`month`,`total`,`namecolor`,`yesterday`,`byesterday`,`starttime`,`endtime`,`remark`,`end`) values (1,'小说阅读网','http://www.readnovel.com',1,2,0,0,0,0,0,'',0,0,0,0,'',0),(2,'言情小说','http://www.xs8.cn/',1,8,0,0,0,0,0,'',0,0,0,0,'',0),(3,'逐浪小说','http://www.zhulang.com/',1,5,0,0,0,0,0,'',0,0,0,0,'',0),(4,'起点中文','http://www.qidian.com',1,1,0,0,0,0,0,'',0,0,0,0,'',0),(5,'红袖添香','http://www.hongxiu.com/',1,4,0,0,0,0,0,'',0,0,0,0,'',0),(6,'潇湘书院','http://www.xxsy.net/',1,6,0,0,0,0,0,'',0,0,0,0,'',0),(7,'看书小说网','http://book.qukanshu.com/',1,7,0,0,0,0,0,'',0,0,0,0,'',0),(8,'七彩谷商城','http://114la.7cv.com/',2,2,0,0,0,0,0,'',0,0,0,0,'',0),(9,'39健康性爱','http://sex.39.net/',2,1,0,0,0,0,0,'',0,0,0,0,'',0),(10,'瑞丽两性','http://www.rayli.com.cn/sex/',2,4,0,0,0,0,0,'',0,0,0,0,'',0),(11,'桔色两性用品','http://shop8.x.com.cn/index5.php?id=dh&xcom=11',2,3,0,0,0,0,0,'',0,0,0,0,'',0),(12,'爱丽两性','http://www.27.cn/nxjk/index.html',2,5,0,0,0,0,0,'',0,0,0,0,'',0),(13,'性福花园','http://www.7120.com/html/liangxing/',2,6,0,0,0,0,0,'',0,0,0,0,'',0),(14,'新浪博客','http://blog.sina.com.cn/',3,1,0,0,0,0,0,'',0,0,0,0,'',0),(15,'Q-ZONE','http://qzone.qq.com/',3,6,0,0,0,0,0,'',0,0,0,0,'',0),(16,'MSN 空间','http://spaces.msn.com/',3,5,0,0,0,0,0,'',0,0,0,0,'',0),(17,'搜狐博客','http://blog.sohu.com/',3,2,0,0,0,0,0,'',0,0,0,0,'',0),(18,'百度空间','http://hi.baidu.com/',3,4,0,0,0,0,0,'',0,0,0,0,'',0),(19,'和讯博客','http://blog.hexun.com/',3,3,0,0,0,0,0,'',0,0,0,0,'',0),(20,'百度贴吧','http://tieba.baidu.com/',4,1,0,0,0,0,0,'',0,0,0,0,'',0),(21,'凤凰论坛','http://bbs.ifeng.com',4,3,0,0,0,0,0,'',0,0,0,0,'',0),(22,'网易社区','http://club.163.com/',4,5,0,0,0,0,0,'',0,0,0,0,'',0),(23,'中关村论坛','http://bbs.zol.com.cn/',4,6,0,0,0,0,0,'',0,0,0,0,'',0),(24,'天涯社区','http://www.tianya.cn/',4,2,0,0,0,0,0,'',0,0,0,0,'',0),(25,'搜狐圈子','http://q.sohu.com/',4,4,0,0,0,0,0,'',0,0,0,0,'',0),(26,'新浪游戏','http://games.sina.com.cn/',5,3,0,0,0,0,0,'',0,0,0,0,'',0),(27,'小游戏','http://www.game.com.cn/',5,1,0,0,0,0,0,'',0,0,0,0,'',0),(28,'太平洋游戏','http://www.pcgames.com.cn/',5,4,0,0,0,0,0,'',0,0,0,0,'',0),(29,'17173','http://www.17173.com/',5,2,0,0,0,0,0,'',0,0,0,0,'',0),(30,'武林英雄','http://www.91wan.com/hero/',5,7,0,0,0,0,0,'',0,0,0,0,'',0),(31,'腾讯游戏','http://games.qq.com/index.shtml',5,5,0,0,0,0,0,'',0,0,0,0,'',0),(32,'热血三国','http://www.91wan.com/rxsg',5,6,0,0,0,0,0,'',0,0,0,0,'',0),(33,'4399小游戏','http://www.4399.com/',6,1,0,0,0,0,0,'',0,0,0,0,'',0),(34,'武林英雄','http://p.yiqifa.com/c?s=cdfca29e&w=2451&c=3640&i=2605&l=0&e=&t=http://home.3gm.com.cn/do.php?ac=wlyx',6,5,0,0,0,0,0,'',0,0,0,0,'',0),(35,'91wan游戏','http://www.91wan.com/',6,2,0,0,0,0,0,'',0,0,0,0,'',0),(36,'电玩巴士','http://www.tgbus.com/',6,4,0,0,0,0,0,'',0,0,0,0,'',0),(37,'265G游戏','http://www.265g.com/',6,3,0,0,0,0,0,'',0,0,0,0,'',0),(38,'明朝时代','http://www.91wan.com/mcsd/',6,6,0,0,0,0,0,'',0,0,0,0,'',0),(39,'美女图片','http://star.1ting.com/',7,1,0,0,0,0,0,'',0,0,0,0,'',0),(40,'素材中国','http://www.sc-cn.net',7,3,0,0,0,0,0,'',0,0,0,0,'',0),(41,'站长素材','http://sc.chinaz.com/',7,6,0,0,0,0,0,'',0,0,0,0,'',0),(42,'明星写真','http://ent.huanqiu.com/pic/',7,2,0,0,0,0,0,'',0,0,0,0,'',0),(43,'性感美女','http://www.27.cn/jptk/index.html',7,7,0,0,0,0,0,'',0,0,0,0,'',0),(44,'站酷素材','http://www.zcool.com.cn/',7,4,0,0,0,0,0,'',0,0,0,0,'',0),(45,'音乐快车','http://www.yykc.com/',8,2,0,0,0,0,0,'',0,0,0,0,'',0),(46,'yymp3音乐','http://www.yymp3.com/',8,7,0,0,0,0,0,'',0,0,0,0,'',0),(47,'一听音乐网','http://www.1ting.com/',8,1,0,0,0,0,0,'',0,0,0,0,'',0),(48,'爱听音乐网','http://www.aiting.com/',8,5,0,0,0,0,0,'',0,0,0,0,'',0),(49,'百度MP3','http://mp3.ylmf.com/',8,8,0,0,0,0,0,'',0,0,0,0,'',0),(50,'CnMp3音乐','http://www.cnmp3.com/',8,2,0,0,0,0,0,'',0,0,0,0,'',0),(51,'铁血军事','http://www.tiexue.net/',9,2,0,0,0,0,0,'',0,0,0,0,'',0),(52,'凤凰网军事','http://news.ifeng.com/mil/',9,5,0,0,0,0,0,'',0,0,0,0,'',0),(53,'中华网军事','http://military.china.com/',9,1,0,0,0,0,0,'',0,0,0,0,'',0),(54,'新浪军事','http://mil.news.sina.com.cn/',9,4,0,0,0,0,0,'',0,0,0,0,'',0),(55,'环球军事','http://mil.huanqiu.com/',9,3,0,0,0,0,0,'',0,0,0,0,'',0),(56,'中国军网','http://www.chinamil.com.cn/',9,6,0,0,0,0,0,'',0,0,0,0,'',0),(57,'健康服务导航','http://39.114la.com/',10,7,0,0,0,0,0,'',0,0,0,0,'',0),(58,'爱丽健康','http://health.27.cn/',10,1,0,0,0,0,0,'',0,0,0,0,'',0),(59,'美容美发','http://women.sohu.com/liangrongmeifa.shtml',10,3,0,0,0,0,0,'',0,0,0,0,'',0),(60,'美容健康','http://www.yoka.com/beauty/',10,2,0,0,0,0,0,'',0,0,0,0,'',0),(61,'健康食疗','http://www.shiliao.com.cn/',10,5,0,0,0,0,0,'',0,0,0,0,'',0),(62,'纤体瘦身','http://lady.qq.com/diet/diet.htm',10,4,0,0,0,0,0,'',0,0,0,0,'',0),(63,'美容美体','http://lady.tom.com/beauty/',10,6,0,0,0,0,0,'',0,0,0,0,'',0),(64,'手机之家','http://www.imobile.com.cn/',11,3,0,0,0,0,0,'',0,0,0,0,'',0),(65,'太平洋手机','http://mobile.pconline.com.cn/',11,0,0,0,0,0,0,'',0,0,0,0,'',0),(66,'中关村手机','http://mobile.zol.com.cn/',11,2,0,0,0,0,0,'',0,0,0,0,'',0),(67,'腾讯手机','http://digi.tech.qq.com/mobile',11,5,0,0,0,0,0,'',0,0,0,0,'',0),(68,'泡泡网手机','http://mobile.pcpop.com/',11,7,0,0,0,0,0,'',0,0,0,0,'',0),(69,'手机中国','http://www.cnmo.com/',11,4,0,0,0,0,0,'',0,0,0,0,'',0),(70,'星空网','http://www.xingkong.com/',12,6,0,0,0,0,0,'',0,0,0,0,'',0),(71,'丽人帮','http://home.27.cn/',12,1,0,0,0,0,0,'',0,0,0,0,'',0),(72,'爱情公寓','http://www.ipart.cn/a/ipart001205.php?from=emar&channelid=41690',12,2,0,0,0,0,0,'',0,0,0,0,'',0),(73,'聚友网','http://spcode.baidu.com/spcode/spClick?tn=uc_sp&ctn=0&styleid=1608&tourl=http://count.myspace.cn/ag.php?pid=117_0_10003_7_0000BAIDU_ANDadtype=9',12,4,0,0,0,0,0,'',0,0,0,0,'',0),(74,'360圈交友','http://jump.all4ad.cn/jump.aspx?id=319',12,3,0,0,0,0,0,'',0,0,0,0,'',0),(75,'绝对100','http://p.yiqifa.com/servlet/handleClick?sid=effaa3a9a5bdb6f5&pid=831&wid=2498&vid=613&cid=248&lid=0&euid=&turl=http%3A%2F%2Fwww.juedui100.com%2Freg.jsp%3Fsid%3D%3C%252%25%3E%26aid%3D22&vwid=',12,5,0,0,0,0,0,'',0,0,0,0,'',0),(76,'搜狐数码','http://digi.it.sohu.com/',13,4,0,0,0,0,0,'',0,0,0,0,'',0),(77,'新浪数码','http://tech.sina.com.cn/digi',13,5,0,0,0,0,0,'',0,0,0,0,'',0),(78,'太平洋数码','http://digital.pconline.com.cn/',13,1,0,0,0,0,0,'',0,0,0,0,'',0),(79,'中关村数码','http://digi.zol.com.cn/',13,2,0,0,0,0,0,'',0,0,0,0,'',0),(80,'淘宝数码','http://h1.untang.com/jump.vip?zi=5005726',13,7,0,0,0,0,0,'',0,0,0,0,'',0),(81,'腾讯数码','http://digi.qq.com/',13,7,0,0,0,0,0,'',0,0,0,0,'',0),(82,'搜狐新闻','http://news.sohu.com/',14,3,0,0,0,0,0,'',0,0,0,0,'',0),(83,'腾讯新闻','http://news.qq.com/',14,7,0,0,0,0,0,'',0,0,0,0,'',0),(84,'新浪新闻','http://news.sina.com.cn/',14,1,0,0,0,0,0,'',0,0,0,0,'',0),(85,'网易新闻','http://news.163.com/',14,4,0,0,0,0,0,'',0,0,0,0,'',0),(86,'雅虎新闻','http://news.cn.yahoo.com/?id=40020',14,2,0,0,0,0,0,'',0,0,0,0,'',0),(87,'环球新闻','http://world.huanqiu.com/',14,5,0,0,0,0,0,'',0,0,0,0,'',0),(89,'凤凰资讯','http://news.ifeng.com/',14,6,0,0,0,0,0,'',0,0,0,0,'',0),(90,'中金在线','http://www.cnfol.com/',15,6,0,0,0,0,0,'',0,0,0,0,'',0),(91,'东方财富网','http://www.eastmoney.com/',15,1,0,0,0,0,0,'',0,0,0,0,'',0),(92,'证券之星','http://www.stockstar.com/',15,4,0,0,0,0,0,'',0,0,0,0,'',0),(93,'新浪财经','http://finance.sina.com.cn/',15,3,0,0,0,0,0,'',0,0,0,0,'',0),(94,'金融界','http://www.jrj.com.cn/',15,5,0,0,0,0,0,'',0,0,0,0,'',0),(95,'和讯财经','http://www.hexun.com/',15,2,0,0,0,0,0,'',0,0,0,0,'',0),(96,'商业新闻网','http://www.bdchn.com/',15,7,0,0,0,0,0,'',0,0,0,0,'',0),(97,'易趣购物','http://promotion.eachnet.com/09q2ad/?adid=bjmt_mta_01_0_hp_25828',16,3,0,0,0,0,0,'',0,0,0,0,'',0),(99,'当当网','http://spcode.baidu.com/spcode/spClick?tn=uc_sp&ctn=0&styleid=2863&tourl=http://union.dangdang.com/transfer/transfer.aspx?from=P-267723-uc_spBAIDU_ANDbackurl=http://www.dangdang.com',16,1,0,0,0,0,0,'',0,0,0,0,'',0),(100,'麦网购物','http://www.m18.com/market/front.aspx?pno=ap-114la-kz&url=&ozc=28&ozs=5019',16,6,0,0,0,0,0,'',0,0,0,0,'',0),(101,'橡果购物','http://www.chinadrtv.com/do_dat.jsp?sid=11410903&dat=9686&url=/',16,5,0,0,0,0,0,'',0,0,0,0,'',0),(102,'卓越网','http://spcode.baidu.com/spcode/spClick?tn=uc_sp&ctn=0&styleid=1&tourl=http://www.amazon.cn?source=uapcpa_uc_sp',16,2,0,0,0,0,0,'',0,0,0,0,'',0),(103,'逛街网','http://www.togj.com/',16,4,0,0,0,0,0,'',0,0,0,0,'',0),(104,'中国银行','http://www.boc.cn/',17,4,0,0,0,0,0,'',0,0,0,0,'',0),(105,'招商银行','http://www.cmbchina.com/',17,1,0,0,0,0,0,'',0,0,0,0,'',0),(106,'建设银行','http://www.ccb.com/',17,3,0,0,0,0,0,'',0,0,0,0,'',0),(107,'农业银行','http://www.abchina.com/',17,5,0,0,0,0,0,'',0,0,0,0,'',0),(108,'广发银行','http://www.gdb.com.cn/',17,6,0,0,0,0,0,'',0,0,0,0,'',0),(109,'工商银行','http://www.icbc.com.cn/',17,2,0,0,0,0,0,'',0,0,0,0,'',0),(170,'新浪汽车','http://sina.allyes.com/main/adfclick?db=sina&bid=155888,196233,201227&cid=0,0,0&sid=189148&advid=3406&camid=27233&show=ignore&url=http://auto.sina.com.cn/?c=spr_web_sq_114la_auto',24,2,0,0,0,0,0,'',0,0,0,0,'',0),(111,'携程旅行网','http://www.ctrip.com/smartlink/smartlink.asp?c=114la&url=http://www.ctrip.com/',18,1,0,0,0,0,0,'',0,0,0,0,'',0),(112,'e龙旅行网','http://travel.elong.com/hotels/default.aspx?campaign_id=4053869',18,2,0,0,0,0,0,'',0,0,0,0,'',0),(169,'白社会','http://stbnnr.allyes.com/bnnr/114la_baishehui.html',12,7,0,0,0,0,0,'',0,0,0,0,'',0),(114,'同程网','http://www.17u.cn/index1094391.html',18,4,0,0,0,0,0,'',0,0,0,0,'',0),(115,'乐途旅游网','http://www.lotour.com/',18,5,0,0,0,0,0,'',0,0,0,0,'',0),(117,'到到旅游点评网','http://www.daodao.com/?m=12000',18,3,0,0,0,0,0,'',0,0,0,0,'',0),(118,'欣欣旅游网','http://www.cncn.com/',18,6,0,0,0,0,0,'',0,0,0,0,'',0),(119,'新浪体育','http://sports.sina.com.cn/',19,100,0,0,0,0,0,'',0,0,0,0,'',0),(120,'搜狐体育','http://sports.sohu.com/',19,100,0,0,0,0,0,'',0,0,0,0,'',0),(121,'网易体育','http://sports.163.com/',19,100,0,0,0,0,0,'',0,0,0,0,'',0),(122,'鲨威体坛','http://sports.tom.com/',19,100,0,0,0,0,0,'',0,0,0,0,'',0),(123,'NBA中文网','http://china.nba.com/',19,100,0,0,0,0,0,'',0,0,0,0,'',0),(124,'雅虎体育','http://sports.cn.yahoo.com/index.html?f=E114_3_1',19,100,0,0,0,0,0,'',0,0,0,0,'',0),(125,'腾讯体育','http://sports.qq.com/',19,100,0,0,0,0,0,'',0,0,0,0,'',0),(126,'中华英才网','http://jump.all4ad.cn/jump.aspx?id=361',20,5,0,0,0,0,0,'',0,0,0,0,'',0),(127,'中国人才热线','http://www.cjol.com/',20,2,0,0,0,0,0,'',0,0,0,0,'',0),(128,'智联招聘','http://www.zhaopin.com/',20,4,0,0,0,0,0,'',0,0,0,0,'',0),(129,'猪八戒网','http://www.zhubajie.com/',20,6,0,0,0,0,0,'',0,0,0,0,'',0),(130,'前程无忧','http://jump.all4ad.cn/jump.aspx?id=334',20,1,0,0,0,0,0,'',0,0,0,0,'',0),(131,'职酷招聘','http://www.jobkoo.com/?utm_source=114la&utm_medium=text&utm_campaign=url-navigation',20,3,0,0,0,0,0,'',0,0,0,0,'',0),(132,'163邮箱','http://mail.163.com/',21,3,0,0,0,0,0,'',0,0,0,0,'',0),(133,'新浪邮箱','http://mail.sina.com.cn/',21,2,0,0,0,0,0,'',0,0,0,0,'',0),(134,'126邮箱','http://www.126.com/',21,4,0,0,0,0,0,'',0,0,0,0,'',0),(135,'雅虎邮箱','http://mail.cn.yahoo.com/?id=40023',21,1,0,0,0,0,0,'',0,0,0,0,'',0),(136,'搜狐邮件','http://mail.sohu.com/',21,5,0,0,0,0,0,'',0,0,0,0,'',0),(137,'QQ邮箱','http://mail.qq.com/',21,7,0,0,0,0,0,'',0,0,0,0,'',0),(138,'网络硬盘','http://u.115.com',21,6,0,0,0,0,0,'',0,0,0,0,'',0),(139,'绿色下载吧','http://www.xiazaiba.com/',22,1,0,0,0,0,0,'',0,0,0,0,'',0),(140,'天空软件站','http://www.skycn.com/index.html',22,2,0,0,0,0,0,'',0,0,0,0,'',0),(141,'中关村下载','http://xiazai.zol.com.cn/',22,4,0,0,0,0,0,'',0,0,0,0,'',0),(142,'驱动之家','http://www.mydrivers.com/',22,5,0,0,0,0,0,'',0,0,0,0,'',0),(143,'霏凡下载','http://www.crsky.com/',22,3,0,0,0,0,0,'',0,0,0,0,'',0),(144,'太平洋下载','http://dl.pconline.com.cn/',22,6,0,0,0,0,0,'',0,0,0,0,'',0),(145,'优酷网','http://www.youku.com/',23,1,0,0,0,0,0,'',0,0,0,0,'',0),(146,'六间房','http://www.6.cn/',23,4,0,0,0,0,0,'',0,0,0,0,'',0),(147,'TOM365免费电影','http://www.tom365.com',23,6,0,0,0,0,0,'',0,0,0,0,'',0),(148,'凤凰宽频','http://v.ifeng.com/',23,5,0,0,0,0,0,'',0,0,0,0,'',0),(149,'土豆网','http://www.tudou.com/',23,2,0,0,0,0,0,'',0,0,0,0,'',0),(151,'6676风影剧场','http://www.6676.com/',23,7,0,0,0,0,0,'',0,0,0,0,'',0),(152,'搜狐汽车','http://auto.sohu.com/',24,4,0,0,0,0,0,'',0,0,0,0,'',0),(153,'太平洋汽车','http://www.pcauto.com.cn?ad=575',24,1,0,0,0,0,0,'',0,0,0,0,'',0),(154,'网易汽车','http://auto.163.com/',24,5,0,0,0,0,0,'',0,0,0,0,'',0),(155,'汽车之家','http://www.autohome.com.cn/',24,3,0,0,0,0,0,'',0,0,0,0,'',0),(156,'易车网','http://www.bitauto.com/',24,6,0,0,0,0,0,'',0,0,0,0,'',0),(158,'淘宝女人','http://go.all4ad.cn/jump.aspx?locid=594',25,3,0,0,0,0,0,'',0,0,0,0,'',0),(159,'淘宝数码','http://go.all4ad.cn/jump.aspx?locid=596',25,5,0,0,0,0,0,'',0,0,0,0,'',0),(160,'淘宝饰品','http://pindao.huoban.taobao.com/channel/jewelry.htm?pid=mm_11140156_0_0',25,6,0,0,0,0,0,'',0,0,0,0,'',0),(161,'淘宝美容','http://go.all4ad.cn/jump.aspx?locid=595',25,2,0,0,0,0,0,'',0,0,0,0,'',0),(162,'淘宝导购','http://go.all4ad.cn/jump.aspx?locid=592',25,1,0,0,0,0,0,'',0,0,0,0,'',0),(163,'淘宝男人','http://go.all4ad.cn/jump.aspx?locid=593',25,4,0,0,0,0,0,'',0,0,0,0,'',0),(164,'爱丽女性网','http://www.27.cn/',26,1,0,0,0,0,0,'',0,0,0,0,'',0),(165,'搜狐女性','http://women.sohu.com/',26,2,0,0,0,0,0,'',0,0,0,0,'',0),(166,'ELLE女性网','http://www.ellechina.com/(d)/1?s_cid=114',26,3,0,0,0,0,0,'',0,0,0,0,'',0),(167,'TOM她风尚','http://lady.tom.com/',26,5,0,0,0,0,0,'',0,0,0,0,'',0),(168,'新浪女性','http://lady.sina.com.cn/',26,6,0,0,0,0,0,'',0,0,0,0,'',0);

/*Table structure for table `uchome_creditlog` */

DROP TABLE IF EXISTS `uchome_creditlog`;

CREATE TABLE `uchome_creditlog` (
  `clid` mediumint(8) unsigned NOT NULL auto_increment,
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `rid` mediumint(8) unsigned NOT NULL default '0',
  `total` mediumint(8) unsigned NOT NULL default '0',
  `cyclenum` mediumint(8) unsigned NOT NULL default '0',
  `credit` mediumint(8) unsigned NOT NULL default '0',
  `experience` mediumint(8) unsigned NOT NULL default '0',
  `starttime` int(10) unsigned NOT NULL default '0',
  `info` text NOT NULL,
  `user` text NOT NULL,
  `app` text NOT NULL,
  `dateline` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`clid`),
  KEY `uid` (`uid`,`rid`),
  KEY `dateline` (`dateline`)
) ENGINE=MyISAM AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_creditlog` */

insert  into `uchome_creditlog`(`clid`,`uid`,`rid`,`total`,`cyclenum`,`credit`,`experience`,`starttime`,`info`,`user`,`app`,`dateline`) values (1,1,1,1,1,10,0,0,'','','',1256533858),(2,1,10,73,1,15,15,0,'','','',1275962394),(3,1,16,28,1,5,5,0,'','','',1267626956),(4,1,15,1,1,1,1,0,'','','',1258082611),(5,1,17,5,4,2,2,0,'','','',1264944906),(6,1,26,8,1,2,2,0,'','','',1269013828),(7,2,1,1,1,10,0,0,'','','',1261707439),(8,2,10,8,1,15,15,0,'','','',1273015459),(9,2,26,1,1,2,2,0,'','','',1261707463),(10,3,1,1,1,10,0,0,'','','',1262551556),(11,3,10,4,1,15,15,0,'','','',1273015486),(12,3,16,3,1,5,5,0,'','','',1264752700),(13,4,1,1,1,10,0,0,'','','',1262551844),(14,4,10,7,1,15,15,0,'','','',1264768741),(15,4,16,6,1,5,5,0,'','','',1264679950),(16,3,11,2,1,1,1,0,'','4','',1264698319),(17,1,27,1,1,1,1,0,'blogid24','','',1264768714),(18,3,28,1,1,1,0,0,'blogid24','','',1264768714),(19,5,1,1,1,10,0,0,'','','',1268063077),(20,5,10,2,1,15,15,0,'','','',1275599326),(21,1,5,1,1,15,15,0,'','','',1269136704),(22,6,1,1,1,10,0,0,'','','',1274701531),(23,6,10,1,1,15,15,0,'','','',1274701531),(24,7,1,1,1,10,0,0,'','','',1274709069),(25,7,10,1,1,15,15,0,'','','',1274709069),(26,8,1,1,1,10,0,0,'','','',1274717119),(27,8,10,2,1,15,15,0,'','','',1275430715),(28,9,1,1,1,10,0,0,'','','',1274717309),(29,9,10,1,1,15,15,0,'','','',1274717309),(30,10,1,1,1,10,0,0,'','','',1275429834),(31,10,10,22,1,15,15,0,'','','',1284708291),(32,10,26,2,2,2,2,0,'','','',1276290634);

/*Table structure for table `uchome_creditrule` */

DROP TABLE IF EXISTS `uchome_creditrule`;

CREATE TABLE `uchome_creditrule` (
  `rid` mediumint(8) unsigned NOT NULL auto_increment,
  `rulename` char(20) NOT NULL default '',
  `action` char(20) NOT NULL default '',
  `cycletype` tinyint(1) NOT NULL default '0',
  `cycletime` int(10) NOT NULL default '0',
  `rewardnum` tinyint(2) NOT NULL default '1',
  `rewardtype` tinyint(1) NOT NULL default '1',
  `norepeat` tinyint(1) NOT NULL default '0',
  `credit` mediumint(8) unsigned NOT NULL default '0',
  `experience` mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY  (`rid`),
  KEY `action` (`action`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_creditrule` */

insert  into `uchome_creditrule`(`rid`,`rulename`,`action`,`cycletype`,`cycletime`,`rewardnum`,`rewardtype`,`norepeat`,`credit`,`experience`) values (1,'开通空间','register',0,0,1,1,0,10,0),(2,'实名认证','realname',0,0,1,1,0,20,20),(3,'邮箱认证','realemail',0,0,1,1,0,40,40),(4,'成功邀请好友','invitefriend',4,0,20,1,0,10,10),(5,'设置头像','setavatar',0,0,1,1,0,15,15),(6,'视频认证','videophoto',0,0,1,1,0,40,40),(7,'成功举报','report',4,0,0,1,0,2,2),(8,'更新心情','updatemood',1,0,3,1,0,3,3),(9,'热点信息','hotinfo',4,0,0,1,0,10,10),(10,'每天登陆','daylogin',1,0,1,1,0,15,15),(11,'访问别人空间','visit',1,0,10,1,2,1,1),(12,'打招呼','poke',1,0,10,1,2,1,1),(13,'留言','guestbook',1,0,20,1,2,2,2),(14,'被留言','getguestbook',1,0,5,1,2,1,0),(15,'发表记录','doing',1,0,5,1,0,1,1),(16,'发表日志','publishblog',1,0,3,1,0,5,5),(17,'上传图片','uploadimage',1,0,10,1,0,2,2),(18,'拍大头贴','camera',1,0,5,1,0,3,3),(19,'发表话题','publishthread',1,0,5,1,0,5,5),(20,'回复话题','replythread',1,0,10,1,1,1,1),(21,'创建投票','createpoll',1,0,5,1,0,2,2),(22,'参与投票','joinpoll',1,0,10,1,1,1,1),(23,'发起活动','createevent',1,0,1,1,0,3,3),(24,'参与活动','joinevent',1,0,1,1,1,1,1),(25,'推荐活动','recommendevent',4,0,0,1,0,10,10),(26,'发起分享','createshare',1,0,3,1,0,2,2),(27,'评论','comment',1,0,40,1,1,1,1),(28,'被评论','getcomment',1,0,20,1,1,1,0),(29,'安装应用','installapp',4,0,0,1,3,5,5),(30,'使用应用','useapp',1,0,10,1,3,1,1),(31,'信息表态','click',1,0,10,1,1,1,1),(32,'修改实名','editrealname',0,0,1,0,0,5,0),(33,'更改邮箱认证','editrealemail',0,0,1,0,0,5,0),(34,'头像被删除','delavatar',0,0,1,0,0,10,10),(35,'获取邀请码','invitecode',0,0,1,0,0,0,0),(36,'搜索一次','search',0,0,1,0,0,1,0),(37,'日志导入','blogimport',0,0,1,0,0,10,0),(38,'修改域名','modifydomain',0,0,1,0,0,5,0),(39,'日志被删除','delblog',0,0,1,0,0,10,10),(40,'记录被删除','deldoing',0,0,1,0,0,2,2),(41,'图片被删除','delimage',0,0,1,0,0,4,4),(42,'投票被删除','delpoll',0,0,1,0,0,4,4),(43,'话题被删除','delthread',0,0,1,0,0,4,4),(44,'活动被删除','delevent',0,0,1,0,0,6,6),(45,'分享被删除','delshare',0,0,1,0,0,4,4),(46,'留言被删除','delguestbook',0,0,1,0,0,4,4),(47,'评论被删除','delcomment',0,0,1,0,0,2,2);

/*Table structure for table `uchome_cron` */

DROP TABLE IF EXISTS `uchome_cron`;

CREATE TABLE `uchome_cron` (
  `cronid` smallint(6) unsigned NOT NULL auto_increment,
  `available` tinyint(1) NOT NULL default '0',
  `type` enum('user','system') NOT NULL default 'user',
  `name` char(50) NOT NULL default '',
  `filename` char(50) NOT NULL default '',
  `lastrun` int(10) unsigned NOT NULL default '0',
  `nextrun` int(10) unsigned NOT NULL default '0',
  `weekday` tinyint(1) NOT NULL default '0',
  `day` tinyint(2) NOT NULL default '0',
  `hour` tinyint(2) NOT NULL default '0',
  `minute` char(36) NOT NULL default '',
  PRIMARY KEY  (`cronid`),
  KEY `nextrun` (`available`,`nextrun`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_cron` */

insert  into `uchome_cron`(`cronid`,`available`,`type`,`name`,`filename`,`lastrun`,`nextrun`,`weekday`,`day`,`hour`,`minute`) values (1,1,'system','更新浏览数统计','log.php',1284714367,1284714600,-1,-1,-1,'0	5	10	15	20	25	30	35	40	45	50	55'),(2,1,'system','清理过期feed','cleanfeed.php',1284687160,1284750240,-1,-1,3,'4'),(3,1,'system','清理个人通知','cleannotification.php',1284687161,1284757560,-1,-1,5,'6'),(4,1,'system','同步UC的feed','getfeed.php',1284714173,1284714420,-1,-1,-1,'2	7	12	17	22	27	32	37	42	47	52'),(5,1,'system','清理脚印和最新访客','cleantrace.php',1284687158,1284746580,-1,-1,2,'3'),(9,1,'user','每日推荐','everydayhot.php',1284687157,1284742860,-1,-1,1,'1');

/*Table structure for table `uchome_data` */

DROP TABLE IF EXISTS `uchome_data`;

CREATE TABLE `uchome_data` (
  `var` varchar(20) NOT NULL default '',
  `datavalue` text NOT NULL,
  `dateline` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`var`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_data` */

insert  into `uchome_data`(`var`,`datavalue`,`dateline`) values ('mail','a:9:{s:8:\"mailsend\";s:1:\"2\";s:13:\"maildelimiter\";s:1:\"0\";s:12:\"mailusername\";s:1:\"1\";s:6:\"server\";s:13:\"smtp.sohu.com\";s:4:\"port\";s:2:\"25\";s:4:\"auth\";s:1:\"0\";s:4:\"from\";s:14:\"myqsq@sohu.com\";s:13:\"auth_username\";s:5:\"myqsq\";s:13:\"auth_password\";s:8:\"98122130\";}',1272084673),('setting','a:14:{s:10:\"thumbwidth\";s:3:\"100\";s:11:\"thumbheight\";s:3:\"100\";s:13:\"maxthumbwidth\";s:0:\"\";s:14:\"maxthumbheight\";s:0:\"\";s:13:\"watermarkfile\";s:0:\"\";s:12:\"watermarkpos\";s:1:\"4\";s:6:\"ftpssl\";s:1:\"0\";s:7:\"ftphost\";s:0:\"\";s:7:\"ftpport\";s:0:\"\";s:7:\"ftpuser\";s:0:\"\";s:11:\"ftppassword\";s:0:\"\";s:7:\"ftppasv\";s:1:\"0\";s:6:\"ftpdir\";s:0:\"\";s:10:\"ftptimeout\";s:0:\"\";}',1272084673),('network','a:5:{s:4:\"blog\";a:12:{s:6:\"blogid\";s:0:\"\";s:3:\"uid\";s:0:\"\";s:4:\"hot1\";s:1:\"0\";s:4:\"hot2\";s:0:\"\";s:8:\"viewnum1\";s:0:\"\";s:8:\"viewnum2\";s:0:\"\";s:9:\"replynum1\";s:0:\"\";s:9:\"replynum2\";s:0:\"\";s:8:\"dateline\";s:0:\"\";s:5:\"order\";s:8:\"dateline\";s:2:\"sc\";s:4:\"desc\";s:5:\"cache\";s:3:\"600\";}s:3:\"pic\";a:8:{s:5:\"picid\";s:0:\"\";s:3:\"uid\";s:0:\"\";s:4:\"hot1\";s:1:\"0\";s:4:\"hot2\";s:0:\"\";s:8:\"dateline\";s:0:\"\";s:5:\"order\";s:8:\"dateline\";s:2:\"sc\";s:4:\"desc\";s:5:\"cache\";s:3:\"700\";}s:6:\"thread\";a:13:{s:3:\"tid\";s:0:\"\";s:3:\"uid\";s:0:\"\";s:4:\"hot1\";s:1:\"0\";s:4:\"hot2\";s:0:\"\";s:8:\"viewnum1\";s:0:\"\";s:8:\"viewnum2\";s:0:\"\";s:9:\"replynum1\";s:0:\"\";s:9:\"replynum2\";s:0:\"\";s:8:\"dateline\";s:0:\"\";s:8:\"lastpost\";s:0:\"\";s:5:\"order\";s:8:\"dateline\";s:2:\"sc\";s:4:\"desc\";s:5:\"cache\";s:3:\"800\";}s:5:\"event\";a:12:{s:7:\"eventid\";s:0:\"\";s:3:\"uid\";s:0:\"\";s:4:\"hot1\";s:0:\"\";s:4:\"hot2\";s:0:\"\";s:10:\"membernum1\";s:0:\"\";s:10:\"membernum2\";s:0:\"\";s:10:\"follownum1\";s:0:\"\";s:10:\"follownum2\";s:0:\"\";s:8:\"dateline\";s:0:\"\";s:5:\"order\";s:8:\"dateline\";s:2:\"sc\";s:4:\"desc\";s:5:\"cache\";s:3:\"900\";}s:4:\"poll\";a:12:{s:3:\"pid\";s:0:\"\";s:3:\"uid\";s:0:\"\";s:4:\"hot1\";s:0:\"\";s:4:\"hot2\";s:0:\"\";s:9:\"voternum1\";s:0:\"\";s:9:\"voternum2\";s:0:\"\";s:9:\"replynum1\";s:0:\"\";s:9:\"replynum2\";s:0:\"\";s:8:\"dateline\";s:0:\"\";s:5:\"order\";s:8:\"dateline\";s:2:\"sc\";s:4:\"desc\";s:5:\"cache\";s:3:\"500\";}}',1256548275),('newspacelist','a:3:{i:0;a:6:{s:3:\"uid\";s:2:\"10\";s:8:\"username\";s:18:\"ramen.sh@gmail.com\";s:4:\"name\";s:0:\"\";s:10:\"namestatus\";s:1:\"0\";s:11:\"videostatus\";s:1:\"0\";s:8:\"dateline\";s:10:\"1275429834\";}i:1;a:6:{s:3:\"uid\";s:1:\"9\";s:8:\"username\";s:11:\"ra1@123.com\";s:4:\"name\";s:4:\"1234\";s:10:\"namestatus\";s:1:\"0\";s:11:\"videostatus\";s:1:\"0\";s:8:\"dateline\";s:10:\"1274717309\";}i:2;a:6:{s:3:\"uid\";s:1:\"8\";s:8:\"username\";s:10:\"ra@123.com\";s:4:\"name\";s:4:\"1234\";s:10:\"namestatus\";s:1:\"0\";s:11:\"videostatus\";s:1:\"0\";s:8:\"dateline\";s:10:\"1274717119\";}}',1275429834),('backupdir','WmjDu5',1258083538),('reason','',0),('registerrule','',0);

/*Table structure for table `uchome_digg` */

DROP TABLE IF EXISTS `uchome_digg`;

CREATE TABLE `uchome_digg` (
  `diggid` mediumint(8) unsigned NOT NULL auto_increment,
  `postuid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(15) NOT NULL default '',
  `url` text NOT NULL,
  `categoryid` tinyint(4) unsigned NOT NULL default '0',
  `subject` text NOT NULL,
  `description` mediumtext NOT NULL,
  `tag` text NOT NULL,
  `upnum` mediumint(8) NOT NULL default '0',
  `downnum` mediumint(8) NOT NULL default '0',
  `viewnum` mediumint(8) unsigned NOT NULL default '0',
  `replynum` mediumint(8) unsigned NOT NULL default '0',
  `hot` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `pic` char(120) NOT NULL default '',
  `picflag` tinyint(1) NOT NULL default '0',
  `noreply` tinyint(1) NOT NULL default '0',
  `md5url` char(32) NOT NULL default '',
  `hashurl` int(10) unsigned NOT NULL default '0',
  `click_2` smallint(6) unsigned NOT NULL default '0',
  `click_3` smallint(6) unsigned NOT NULL default '0',
  `click_4` smallint(6) unsigned NOT NULL default '0',
  `click_5` smallint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`diggid`),
  KEY `uid` (`postuid`,`dateline`),
  KEY `topicid` (`dateline`),
  KEY `dateline` (`dateline`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_digg` */

insert  into `uchome_digg`(`diggid`,`postuid`,`username`,`url`,`categoryid`,`subject`,`description`,`tag`,`upnum`,`downnum`,`viewnum`,`replynum`,`hot`,`dateline`,`pic`,`picflag`,`noreply`,`md5url`,`hashurl`,`click_2`,`click_3`,`click_4`,`click_5`) values (1,1,'admin','http://www.redbots.cn/sciences/2010/03/02/15903.htm',2,'《福布斯》杂志评出14项史上最怪异发明','美国《福布斯》杂志近日根据美国专利商标局所提供的专利，评出14项最怪异发明，入选的怪异发明包括：干酪过滤嘴香烟、中东冲突游戏、狗类防尘服、掩饰部分秃顶的方法、墓穴潜望镜、利用地心引力促进婴儿出生的助产设备、枕头和头盔混合体、含有','s:6:\"发明\";',21,17,4,0,0,1267272232,'attachment/201002/28/1_12673575797B4v.jpg',1,0,'',0,0,0,0,0),(2,1,'admin','http://ent.sina.com.cn/f/m/09mustsee/index.shtml',1,'2009电影','2008年好莱坞的精彩还历历在目，2009年的新电影又汹涌而至。虽然经济危机席卷全球，可电影这种娱乐方式不但没有受到影响，反而激流勇进续写辉煌，2008年全年票房历史第二就是明证。而在已经开始的2009年里，好莱坞依然奉上了无比丰盛的视听大餐与心','',0,0,0,0,0,1267626553,'',0,0,'',0,0,0,0,0),(5,1,'admin','http://www.sohu.com',2,'2009电影','sf','',0,0,0,0,0,1267633349,'',0,0,'',0,0,0,0,0),(3,1,'admin','http://jandan.net/2010/02/23/jell-o-scape.html',3,'真的猛艺术家能用果冻搞艺术！','看到这组超有爱作品，我被深深地震撼到了。看到配图，你也许还不知道这是什么。正如标题所说，它们是果冻做的，参照的是旧金山的景色。作者是：Liz Hickok。她做了很多的模具来制造这些果冻建筑。','',7,4,1,0,0,1267546148,'',0,0,'',0,0,0,0,0),(4,1,'admin','http://sudasuta.com/?p=1558',4,'春生夏长，我要发芽','花儿花儿为谁开/一年春去春又来/花儿说它为一个人等待；无可奈何花落去/似曾相识燕归来/花园里 小路上 独徘徊；四月的微风轻似梦/吹去了花瓣片片落/怕春花落尽成秋色/无边细雨亲吻我；四月的微风轻似梦/吹去了花瓣片片落/怕春花落尽成秋色/无边','',0,0,0,0,0,1267548484,'',0,0,'',0,0,0,0,0),(6,1,'admin','http://www.google.com',2,'中国','sf','',0,0,0,0,0,1267633441,'',0,0,'',0,0,0,0,0),(7,1,'admin','http://www.x.com',3,'xx','sfsf','',0,0,0,0,0,1267634491,'attachment/201003/3/1_1267634491rv22.jpg',1,0,'',0,0,0,0,0),(8,10,'城市森林','http://www.jxnews.com.cn/jxcomment/system/2010/06/15/011406878.shtml',1,'江南浪子：中国足球何日投胎转世！','东亚双雄开门大吉，酸甜苦辣万般滋味。复杂而矛盾的心态，纠结的让人辗转难眠。曾经的欧洲冠军希腊，多年的非洲老大喀麦隆，一个让棒子敲得晕头转向，一个被小鬼子耍得稀里糊涂，看到人高马大的希腊人被韩国人满场追得气喘嘘嘘，有人戏称，那简直是韩国队','a:2:{i:3;s:6:\"足球\";i:4;s:9:\"世界杯\";}',0,0,0,0,0,1276347197,'',0,0,'',0,0,0,0,0),(9,10,'城市森林','http://www.jxnews.com.cn/jxcomment/system/2010/06/10/011403569.shtml',1,'南非 你是谁的世界杯？','2010年6月11日-7月12日，第十九届世界杯足球赛将在南非打响。这是全世界球迷四年一度的盛大节日。\r\n\r\n　　世界杯的魅力，自然在于结果——谁能最终捧起举世瞩目的大力神杯；同时，亦在于过程——32支球队为亿万拥趸奉献64场','a:2:{i:5;s:6:\"南非\";i:4;s:9:\"世界杯\";}',0,0,0,0,0,1276347424,'',0,0,'',0,0,0,0,0),(10,10,'城市森林','http://money.jrj.com.cn/2010/06/1014227612390.shtml',1,'一个考生的高三账本：家教一项1万 学费不足千元','昨天，2010年高考如期结束。随之而来的，除了一个个高考家庭等待高考成绩的忐忑外，还有关于“高考经济”的新一轮讨论。一个普通的高考考生家庭，到底高三一年会为高考花去多少钱？','a:3:{i:6;s:6:\"高三\";i:7;s:6:\"学费\";i:8;s:6:\"家教\";}',0,0,0,0,0,1276347755,'',0,0,'',0,0,0,0,0),(11,10,'城市森林','http://www.cnbeta.com/articles/110767.htm',1,'美刊评出十大成功辍学生 盖茨居首乔布斯第二','中新社纽约5月10日电(记者 孙宇挺)美国时代周刊网站10日刊出美国最著名的10名从大学辍学的成功人士，其中比尔•盖茨位居榜首。','a:2:{i:9;s:9:\"辍学生\";i:10;s:6:\"盖茨\";}',8,0,0,0,0,1276348098,'',0,0,'',0,0,0,0,0),(12,10,'城市森林','http://news.xinhuanet.com/sports/2010-06/16/c_12225579.htm',1,'上座率堪忧乏味还在继续 南非世界杯魅力衰减','来越多的人在抱怨南非世界杯乏味无聊。斯洛文尼亚队与阿尔及利亚队交手带来的视觉疲劳尚未消除，紧接着登场的新西兰队和斯洛伐克队依然难以提起人们的兴致。又是一场平局，两粒进球均来自异常老套的“高空轰炸”。','a:2:{i:5;s:6:\"南非\";i:4;s:9:\"世界杯\";}',0,0,0,0,0,1276348349,'',0,0,'',0,0,0,0,0),(13,10,'城市森林','http://www.qing6.com/link/view/686597.html',1,'世界杯来临，为资深球迷','南非准备好了！我也准备好了！然而，身为资深球迷的老婆们准备好了没有？因此，为了不打扰、不影响、不干扰、不封杀我们这群资深球迷看球，希望老婆们能够自觉遵守“约法十章”。','a:2:{i:5;s:6:\"南非\";i:4;s:9:\"世界杯\";}',0,0,0,0,0,1276348563,'',0,0,'',0,0,0,0,0),(14,10,'城市森林','http://www.qing69.com/newsContent/60912',1,'靠身体赚钱的性感女明星 -纯娱乐 -青69-藏经阁','靠身体赚钱的性感女明星','a:1:{i:11;s:6:\"世界\";}',3,0,1,0,0,1278040070,'',0,0,'',0,0,0,0,0),(15,10,'城市森林','http://www.qing6.com/link/view/663820.html',1,'上海真的是中国大陆最滥性的城市吗?-七嘴八舌频道-青6网','前几天在看到一篇题为《深圳婚外情泛滥仅次上海》的文章，内容说的全是深圳的事情，没有一件事与上海扯得上，可是文章作者却故意把“上海”二字按到标题上来，我想原因无非有二个：一是为捕捉眼球，滥性于上海显然远比滥性于深圳引人臆想，二是顺手把上','a:1:{i:1;s:6:\"发明\";}',11,6,0,0,0,1278040133,'',0,0,'',0,0,0,0,0);

/*Table structure for table `uchome_diggcategory` */

DROP TABLE IF EXISTS `uchome_diggcategory`;

CREATE TABLE `uchome_diggcategory` (
  `categoryid` mediumint(8) unsigned NOT NULL default '0',
  `categoryname` varchar(32) NOT NULL default '',
  `categoryalias` varchar(32) NOT NULL default '',
  PRIMARY KEY  (`categoryid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_diggcategory` */

insert  into `uchome_diggcategory`(`categoryid`,`categoryname`,`categoryalias`) values (1,'le','乐'),(2,'chao','潮'),(3,'guai','怪'),(4,'xin','新'),(5,'qu','趣');

/*Table structure for table `uchome_diggtag` */

DROP TABLE IF EXISTS `uchome_diggtag`;

CREATE TABLE `uchome_diggtag` (
  `tagid` mediumint(8) unsigned NOT NULL auto_increment,
  `tagname` char(30) NOT NULL default '',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `totalnum` smallint(6) unsigned NOT NULL default '0',
  `close` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`tagid`),
  KEY `tagname` (`tagname`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_diggtag` */

insert  into `uchome_diggtag`(`tagid`,`tagname`,`uid`,`dateline`,`totalnum`,`close`) values (1,'发明',1,1267272232,2,0),(2,'电影',1,1267272353,1,0),(3,'足球',10,1276347197,1,0),(4,'世界杯',10,1276347197,4,0),(5,'南非',10,1276347424,3,0),(6,'高三',10,1276347755,1,0),(7,'学费',10,1276347755,1,0),(8,'家教',10,1276347755,1,0),(9,'辍学生',10,1276348098,1,0),(10,'盖茨',10,1276348098,1,0),(11,'世界',10,1278040070,1,0);

/*Table structure for table `uchome_diggtagdigg` */

DROP TABLE IF EXISTS `uchome_diggtagdigg`;

CREATE TABLE `uchome_diggtagdigg` (
  `tagid` mediumint(8) unsigned NOT NULL default '0',
  `diggid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(9) NOT NULL default '0',
  PRIMARY KEY  (`tagid`,`diggid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_diggtagdigg` */

insert  into `uchome_diggtagdigg`(`tagid`,`diggid`,`uid`) values (1,1,1),(2,2,1),(3,8,10),(4,8,10),(5,9,10),(4,9,10),(6,10,10),(7,10,10),(8,10,10),(9,11,10),(10,11,10),(5,12,10),(4,12,10),(5,13,10),(4,13,10),(11,14,10),(1,15,10);

/*Table structure for table `uchome_docomment` */

DROP TABLE IF EXISTS `uchome_docomment`;

CREATE TABLE `uchome_docomment` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `upid` int(10) unsigned NOT NULL default '0',
  `doid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(15) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `message` text NOT NULL,
  `ip` varchar(20) NOT NULL default '',
  `grade` smallint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `doid` (`doid`,`dateline`),
  KEY `dateline` (`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_docomment` */

/*Table structure for table `uchome_doing` */

DROP TABLE IF EXISTS `uchome_doing`;

CREATE TABLE `uchome_doing` (
  `doid` mediumint(8) unsigned NOT NULL auto_increment,
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(15) NOT NULL default '',
  `from` varchar(20) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `message` text NOT NULL,
  `ip` varchar(20) NOT NULL default '',
  `replynum` int(10) unsigned NOT NULL default '0',
  `mood` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`doid`),
  KEY `uid` (`uid`,`dateline`),
  KEY `dateline` (`dateline`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_doing` */

/*Table structure for table `uchome_event` */

DROP TABLE IF EXISTS `uchome_event`;

CREATE TABLE `uchome_event` (
  `eventid` mediumint(8) unsigned NOT NULL auto_increment,
  `topicid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(15) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `title` varchar(80) NOT NULL default '',
  `classid` smallint(6) unsigned NOT NULL default '0',
  `province` varchar(20) NOT NULL default '',
  `city` varchar(20) NOT NULL default '',
  `location` varchar(80) NOT NULL default '',
  `poster` varchar(60) NOT NULL default '',
  `thumb` tinyint(1) NOT NULL default '0',
  `remote` tinyint(1) NOT NULL default '0',
  `deadline` int(10) unsigned NOT NULL default '0',
  `starttime` int(10) unsigned NOT NULL default '0',
  `endtime` int(10) unsigned NOT NULL default '0',
  `public` tinyint(3) NOT NULL default '0',
  `membernum` mediumint(8) unsigned NOT NULL default '0',
  `follownum` mediumint(8) unsigned NOT NULL default '0',
  `viewnum` mediumint(8) unsigned NOT NULL default '0',
  `grade` tinyint(3) NOT NULL default '0',
  `recommendtime` int(10) unsigned NOT NULL default '0',
  `tagid` mediumint(8) unsigned NOT NULL default '0',
  `picnum` mediumint(8) unsigned NOT NULL default '0',
  `threadnum` mediumint(8) unsigned NOT NULL default '0',
  `updatetime` int(10) unsigned NOT NULL default '0',
  `hot` mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY  (`eventid`),
  KEY `grade` (`grade`,`recommendtime`),
  KEY `membernum` (`membernum`),
  KEY `uid` (`uid`,`eventid`),
  KEY `tagid` (`tagid`,`eventid`),
  KEY `topicid` (`topicid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_event` */

/*Table structure for table `uchome_eventclass` */

DROP TABLE IF EXISTS `uchome_eventclass`;

CREATE TABLE `uchome_eventclass` (
  `classid` smallint(6) unsigned NOT NULL auto_increment,
  `classname` varchar(80) NOT NULL default '',
  `poster` tinyint(1) NOT NULL default '0',
  `template` text NOT NULL,
  `displayorder` mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY  (`classid`),
  UNIQUE KEY `classname` (`classname`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_eventclass` */

insert  into `uchome_eventclass`(`classid`,`classname`,`poster`,`template`,`displayorder`) values (1,'生活/聚会',0,'费用说明：\r\n集合地点：\r\n着装要求：\r\n联系方式：\r\n注意事项：',1),(2,'出行/旅游',0,'路线说明:\r\n费用说明:\r\n装备要求:\r\n交通工具:\r\n集合地点:\r\n联系方式:\r\n注意事项:',2),(3,'比赛/运动',0,'费用说明：\r\n集合地点：\r\n着装要求：\r\n场地介绍：\r\n联系方式：\r\n注意事项：',4),(4,'电影/演出',0,'剧情介绍：\r\n费用说明：\r\n集合地点：\r\n联系方式：\r\n注意事项：',3),(5,'教育/讲座',0,'主办单位：\r\n活动主题：\r\n费用说明：\r\n集合地点：\r\n联系方式：\r\n注意事项：',5),(6,'其它',0,'',6);

/*Table structure for table `uchome_eventfield` */

DROP TABLE IF EXISTS `uchome_eventfield`;

CREATE TABLE `uchome_eventfield` (
  `eventid` mediumint(8) unsigned NOT NULL auto_increment,
  `detail` text NOT NULL,
  `template` varchar(255) NOT NULL default '',
  `limitnum` mediumint(8) unsigned NOT NULL default '0',
  `verify` tinyint(1) NOT NULL default '0',
  `allowpic` tinyint(1) NOT NULL default '0',
  `allowpost` tinyint(1) NOT NULL default '0',
  `allowinvite` tinyint(1) NOT NULL default '0',
  `allowfellow` tinyint(1) NOT NULL default '0',
  `hotuser` text NOT NULL,
  PRIMARY KEY  (`eventid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_eventfield` */

/*Table structure for table `uchome_eventinvite` */

DROP TABLE IF EXISTS `uchome_eventinvite`;

CREATE TABLE `uchome_eventinvite` (
  `eventid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(15) NOT NULL default '',
  `touid` mediumint(8) unsigned NOT NULL default '0',
  `tousername` char(15) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`eventid`,`touid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_eventinvite` */

/*Table structure for table `uchome_eventpic` */

DROP TABLE IF EXISTS `uchome_eventpic`;

CREATE TABLE `uchome_eventpic` (
  `picid` mediumint(8) unsigned NOT NULL default '0',
  `eventid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(15) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`picid`),
  KEY `eventid` (`eventid`,`picid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_eventpic` */

/*Table structure for table `uchome_feed` */

DROP TABLE IF EXISTS `uchome_feed`;

CREATE TABLE `uchome_feed` (
  `feedid` int(10) unsigned NOT NULL auto_increment,
  `appid` smallint(6) unsigned NOT NULL default '0',
  `icon` varchar(30) NOT NULL default '',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(15) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `friend` tinyint(1) NOT NULL default '0',
  `hash_template` varchar(32) NOT NULL default '',
  `hash_data` varchar(32) NOT NULL default '',
  `title_template` text NOT NULL,
  `title_data` text NOT NULL,
  `body_template` text NOT NULL,
  `body_data` text NOT NULL,
  `body_general` text NOT NULL,
  `image_1` varchar(255) NOT NULL default '',
  `image_1_link` varchar(255) NOT NULL default '',
  `image_2` varchar(255) NOT NULL default '',
  `image_2_link` varchar(255) NOT NULL default '',
  `image_3` varchar(255) NOT NULL default '',
  `image_3_link` varchar(255) NOT NULL default '',
  `image_4` varchar(255) NOT NULL default '',
  `image_4_link` varchar(255) NOT NULL default '',
  `target_ids` text NOT NULL,
  `id` mediumint(8) unsigned NOT NULL default '0',
  `idtype` varchar(15) NOT NULL default '',
  `hot` mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY  (`feedid`),
  KEY `uid` (`uid`,`dateline`),
  KEY `dateline` (`dateline`),
  KEY `hot` (`hot`),
  KEY `id` (`id`,`idtype`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_feed` */

insert  into `uchome_feed`(`feedid`,`appid`,`icon`,`uid`,`username`,`dateline`,`friend`,`hash_template`,`hash_data`,`title_template`,`title_data`,`body_template`,`body_data`,`body_general`,`image_1`,`image_1_link`,`image_2`,`image_2_link`,`image_3`,`image_3_link`,`image_4`,`image_4_link`,`target_ids`,`id`,`idtype`,`hot`) values (5,1,'bookmark',10,'城市森林',1284620709,0,'eb9f812a5266b2b4c7b73e47597ea5d0','6e8771bcb730a563d35729df3bbbe874','{actor} 顶一个网址','N;','{bookmark}','a:2:{s:8:\"bookmark\";s:125:\"<a href=\"http://paranimage.com/20-notepad-plus-plugins\" target=\"_blank\">20款Notepad++插件下载和介绍  帕兰映像</a>\";s:4:\"data\";s:45:\"http://paranimage.com/20-notepad-plus-plugins\";}','','','','','','','','','','',157,'bookmark_up',0),(4,1,'site',10,'城市森林',1284617045,0,'a10919844d29d525e83cd4015ef71b4c','88cf3cd05e4bf6ee0d956ab314fcf031','{actor} 顶一个网址','N;','{site}','a:2:{s:4:\"site\";s:68:\"<a href=\"http://www.xxsy.net\" target=\"_blank\">潇湘言情小说</a>\";s:4:\"data\";s:19:\"http://www.xxsy.net\";}','','','','','','','','','','',1,'site_up',0);

/*Table structure for table `uchome_feedback` */

DROP TABLE IF EXISTS `uchome_feedback`;

CREATE TABLE `uchome_feedback` (
  `fid` int(10) unsigned NOT NULL auto_increment,
  `username` varchar(20) NOT NULL default '',
  `email` varchar(30) NOT NULL default '',
  `content` text NOT NULL,
  `add_time` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`fid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_feedback` */

/*Table structure for table `uchome_friend` */

DROP TABLE IF EXISTS `uchome_friend`;

CREATE TABLE `uchome_friend` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `fuid` mediumint(8) unsigned NOT NULL default '0',
  `fusername` varchar(15) NOT NULL default '',
  `status` tinyint(1) NOT NULL default '0',
  `gid` smallint(6) unsigned NOT NULL default '0',
  `note` varchar(50) NOT NULL default '',
  `num` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`uid`,`fuid`),
  KEY `fuid` (`fuid`),
  KEY `status` (`uid`,`status`,`num`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_friend` */

/*Table structure for table `uchome_friendguide` */

DROP TABLE IF EXISTS `uchome_friendguide`;

CREATE TABLE `uchome_friendguide` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `fuid` mediumint(8) unsigned NOT NULL default '0',
  `fusername` char(15) NOT NULL default '',
  `num` smallint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`uid`,`fuid`),
  KEY `uid` (`uid`,`num`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_friendguide` */

/*Table structure for table `uchome_friendlog` */

DROP TABLE IF EXISTS `uchome_friendlog`;

CREATE TABLE `uchome_friendlog` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `fuid` mediumint(8) unsigned NOT NULL default '0',
  `action` varchar(10) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`uid`,`fuid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_friendlog` */

/*Table structure for table `uchome_invite` */

DROP TABLE IF EXISTS `uchome_invite`;

CREATE TABLE `uchome_invite` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `code` varchar(20) NOT NULL default '',
  `fuid` mediumint(8) unsigned NOT NULL default '0',
  `fusername` varchar(15) NOT NULL default '',
  `type` tinyint(1) NOT NULL default '0',
  `email` varchar(100) NOT NULL default '',
  `appid` mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_invite` */

/*Table structure for table `uchome_ipstates` */

DROP TABLE IF EXISTS `uchome_ipstates`;

CREATE TABLE `uchome_ipstates` (
  `day` char(10) NOT NULL default '',
  `month` char(7) NOT NULL default '',
  `nums` int(10) NOT NULL default '0',
  `isp_dx` int(11) NOT NULL default '0',
  `isp_wt` int(11) NOT NULL default '0',
  `qvod` int(11) NOT NULL default '0',
  PRIMARY KEY  (`day`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_ipstates` */

insert  into `uchome_ipstates`(`day`,`month`,`nums`,`isp_dx`,`isp_wt`,`qvod`) values ('2009-6-26','2009-6',8,8,0,8);

/*Table structure for table `uchome_keyword` */

DROP TABLE IF EXISTS `uchome_keyword`;

CREATE TABLE `uchome_keyword` (
  `id` int(11) NOT NULL auto_increment,
  `class` int(11) default '0',
  `name` varchar(10) NOT NULL default '',
  `url` char(255) NOT NULL default '',
  `namecolor` char(7) default NULL,
  `displayorder` int(11) NOT NULL default '0',
  `day` int(11) default '0',
  `week` int(11) default '0',
  `month` int(11) default '0',
  `total` int(11) default '0',
  `yesterday` int(11) NOT NULL default '0',
  `byesterday` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `classid` (`class`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_keyword` */

/*Table structure for table `uchome_link` */

DROP TABLE IF EXISTS `uchome_link`;

CREATE TABLE `uchome_link` (
  `linkid` mediumint(8) unsigned NOT NULL auto_increment,
  `siteid` mediumint(8) NOT NULL default '0',
  `postuid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(32) NOT NULL default '',
  `classid` text NOT NULL,
  `link_subject` text NOT NULL,
  `url` text NOT NULL,
  `link_tag` text NOT NULL,
  `link_description` text NOT NULL,
  `viewnum` mediumint(8) unsigned NOT NULL default '0',
  `replynum` mediumint(8) unsigned NOT NULL default '0',
  `storenum` mediumint(8) NOT NULL default '0',
  `hot` mediumint(8) unsigned NOT NULL default '0',
  `link_dateline` int(10) unsigned NOT NULL default '0',
  `pic` char(120) NOT NULL default '',
  `picflag` tinyint(1) NOT NULL default '0',
  `tmppic` char(120) NOT NULL default '',
  `noreply` tinyint(1) NOT NULL default '0',
  `friend` tinyint(1) NOT NULL default '0',
  `password` char(10) NOT NULL default '',
  `origin` tinyint(1) NOT NULL default '0',
  `verify` tinyint(1) NOT NULL default '0',
  `md5url` char(128) NOT NULL default '',
  `hashurl` int(64) unsigned NOT NULL default '0',
  `privateflag` smallint(6) unsigned NOT NULL default '0',
  `trynum` smallint(6) NOT NULL default '0',
  `up` mediumint(8) unsigned NOT NULL default '0',
  `down` mediumint(8) unsigned NOT NULL default '0',
  `delflag` smallint(6) unsigned NOT NULL default '0',
  `initaward` int(6) unsigned NOT NULL default '7000',
  `award` int(6) unsigned NOT NULL default '0',
  `click_2` smallint(6) unsigned NOT NULL default '0',
  `click_3` smallint(6) unsigned NOT NULL default '0',
  `click_4` smallint(6) unsigned NOT NULL default '0',
  `click_5` smallint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`linkid`),
  KEY `uid` (`postuid`,`link_dateline`),
  KEY `topicid` (`link_dateline`),
  KEY `dateline` (`link_dateline`)
) ENGINE=MyISAM AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_link` */

insert  into `uchome_link`(`linkid`,`siteid`,`postuid`,`username`,`classid`,`link_subject`,`url`,`link_tag`,`link_description`,`viewnum`,`replynum`,`storenum`,`hot`,`link_dateline`,`pic`,`picflag`,`tmppic`,`noreply`,`friend`,`password`,`origin`,`verify`,`md5url`,`hashurl`,`privateflag`,`trynum`,`up`,`down`,`delflag`,`initaward`,`award`,`click_2`,`click_3`,`click_4`,`click_5`) values (1,0,1,'admin','18','好听音乐网','http://search.haoting.com/user/search1.asp?word=%C7%F4%C4%F1&amp;wofrdf=%C7%F4%C4%F1&amp;type=1&amp;more=true','a:1:{i:46;s:5:\"Array\";}','数万首歌曲音乐在线试听',14,0,2,0,1275347991,'snapshot/7/4/1/5',1,'snapshot/random/30.jpg',0,0,'',1,0,'52dda3cf118965987ad84a533706da47',121930165,0,1,33,22,1,8000,8027,0,0,0,0),(2,0,1,'admin','18','好听音乐网 - 听好音乐 有好心情\n','http://search.haoting.com/user/search1.asp?word=%C7%F4%C4%F1&amp;wofrdf=%C7%F4%C4%F1&amp;type=1&amp;more=true','a:6:{i:101;s:12:\"在线试听\";i:102;s:12:\"音乐下载\";i:103;s:15:\"好听音乐网\";i:15;s:5:\"music\";i:104;s:7:\"haoting\";i:105;s:7:\"搜索\n\";}','数万首歌曲音乐在线试听\n',0,0,2,0,1270197450,'snapshot/7/4/1/5',1,'snapshot/random/9.jpg',0,0,'',1,1,'52dda3cf118965987ad84a533706da47',121930165,0,1,5,1,0,7000,7006,0,0,0,0),(3,0,1,'admin','33','GoalHi足球—努力做最好的足球网站\n','http://www.goalhi.com','a:9:{i:17;s:6:\"足球\";i:19;s:6:\"中超\";i:20;s:6:\"英超\";i:21;s:6:\"意甲\";i:22;s:6:\"西甲\";i:23;s:6:\"欧冠\";i:24;s:9:\"冠军杯\";i:25;s:12:\"五大联赛\";i:67;s:13:\"中国足球\n\";}','足球,GoalHi足球是英超,意甲,五大联赛,欧冠,冠军杯,中超,国足,亚冠等足球赛事为主的网站,包含最新足球比赛视频,足球新闻,最全的足球直播,赛程,积分,射手榜,图片,比赛讨论等原创内容,拥有热情理性的足球讨论社区供足球迷交流讨论.\n',6,0,2,0,1270200666,'snapshot/6/3/1/5',1,'snapshot/random/11.jpg',0,0,'',1,1,'580b23629f65c8455cd4baa93b5a0da2',1857266045,0,1,6,0,0,7000,7014,0,0,0,0),(4,0,1,'admin','33','天下足球网 - |最新足球赛事|NBA篮球|体育赛事|球迷论坛|足球博彩|网络直播 - Powered by PHPWind.net\n','http://www.txzqw.com','','\n',0,0,1,0,1270200744,'snapshot/4/4/0/5',1,'snapshot/random/11.jpg',0,0,'',1,1,'9e9ccd263c2c516efd96da226e4556c5',213141597,0,1,0,0,0,7000,7001,0,0,0,0),(5,0,1,'admin','','新浪首页\n','http://www.sina.com.cn','','新浪网为全球用户24小时提供全面及时的中文资讯，内容覆盖国内外突发新闻事件、体坛赛事、娱乐时尚、产业资讯、实用信息等，设有新闻、体育、娱乐、财经、科技、房产、汽车等30多个内容频道，同时开设博客、视频、论坛等自由互动交流空间。\n',0,0,1,0,1270270225,'snapshot/1/7/4/6',1,'snapshot/random/10.jpg',0,0,'',1,1,'4f12a25ee6cc3d6123be77df850e343e',22017182,0,1,0,0,0,7000,0,0,0,0,0),(6,0,1,'admin','18','当当网—网上购物中心：图书、母婴、美妆、家居、数码、家电、服装、鞋包等，正品低价，货到付款\n','http://www.dangdang.com','a:1:{i:46;s:5:\"Array\";}','全球领先的综合性网上购物中心。超过100万种商品在线热销！图书、音像、母婴、美妆、家居、数码3C、服装、鞋包等几十大类，正品行货，低至2折，700多城市货到付款，（全场购物满29元免运费。当当网一贯秉承提升顾客体验的承诺，自助退换货便捷又放心）。\n',11,0,2,0,1270454831,'snapshot/6/5/3/5',1,'snapshot/random/14.jpg',0,0,'',1,1,'8239c5d74a80ad380e7e415cc7356b1b',111506365,0,1,0,0,0,7000,7013,0,0,0,0),(7,0,1,'admin','18','','http://192.168.115.2/uc/home/space.php?do=all','','',0,0,1,0,1270768583,'snapshot/1/3/7/4',0,'snapshot/random/28.jpg',0,0,'',0,0,'2144247327865e53c4019006701151e0',1097025356,1,0,0,0,0,7000,7001,0,0,0,0),(8,0,1,'admin','18','','http://g-fox.cn/chinaedition/userguide','','',0,0,14,0,1270882194,'snapshot/4/5/1/5',0,'snapshot/random/25.jpg',0,0,'',0,0,'59ff797c41ab96999eed8b754e8f022c',71651813,0,0,0,0,0,7000,7014,0,0,0,0),(9,0,1,'admin','18','','http://www.qq.com','','',0,0,14,0,1270882194,'snapshot/0/4/1/5',0,'snapshot/random/28.jpg',0,0,'',0,0,'3872e0b6ee1fd73301ad2cb6365b00a2',542415357,0,0,0,0,0,7000,7014,0,0,0,0),(10,0,1,'admin','18','','http://www.164.com','','',0,0,14,0,1270882195,'snapshot/1/2/4/5',0,'snapshot/random/17.jpg',0,0,'',0,0,'17c9daae94bd72c96aa514701f626996',161117405,0,0,0,0,0,7000,7014,0,0,0,0),(11,0,1,'admin','18','','http://movie.xunlei.com/type分类: 动作 - 电影频道Cgenre/movie分类: 动作 - 电影频道CAction','','',0,0,1,0,1271334105,'snapshot/2/5/1/6',0,'snapshot/random/8.jpg',0,0,'',0,0,'a2ff9b558f0afe34a2462201aad7ab8f',1792872830,0,0,0,0,0,7000,7001,0,0,0,0),(12,0,1,'admin','18','百度','http://www.baidu.com','','',1,0,1,0,1274336125,'snapshot/2/6/4/5',0,'snapshot/random/18.jpg',0,0,'',1,0,'bfa89e563d9509fbc5c6503dd50faf2e',42886333,0,0,0,0,0,7000,7001,0,0,0,0),(13,0,1,'admin','18','','http://sport.sohu.com','','',0,0,0,0,1274862443,'snapshot/4/2/1/5',0,'snapshot/random/15.jpg',0,0,'',0,0,'98a64d7b253f9f9c6eeb315d8c96cd4e',1144185149,0,0,0,0,0,7000,7000,0,0,0,0),(14,0,1,'admin','18','','http://sport.sina.com','','',0,0,0,0,1274862652,'snapshot/5/6/1/5',0,'snapshot/random/27.jpg',0,0,'',0,0,'4b9cc84f65094d0613f5b6dcc69d3f7c',1032249821,0,0,0,0,0,7000,7000,0,0,0,0),(15,0,1,'admin','18','','http://sport.163.com','','',0,0,0,0,1274863092,'snapshot/1/5/3/5',0,'snapshot/random/13.jpg',0,0,'',0,0,'2a4f6635db96316c0f5aed52348300e0',292936605,0,0,0,0,0,7000,7000,0,0,0,0),(16,0,1,'admin','','','http://bbs.qhball.com','','',0,0,5,0,1275166705,'snapshot/6/6/0/5',0,'snapshot/random/9.jpg',0,0,'',0,0,'669b347d5758c0d5adf8f737415cb485',101583005,0,0,0,0,0,7000,0,0,0,0,0),(17,0,1,'admin','','','http://nba.tom.com','','',0,0,1,0,1275167334,'snapshot/6/2/7/5',0,'snapshot/random/3.jpg',0,0,'',0,0,'fde8aba8da48192f15781074b725973f',114970557,0,0,0,0,0,7000,7000,0,0,0,0),(18,0,1,'admin','','','http://stock.hexun.com','','',0,0,1,0,1275167365,'snapshot/4/6/7/5',0,'snapshot/random/17.jpg',0,0,'',0,0,'5a6866ac28f939fd64a2820e284352de',1421745949,0,0,0,0,0,7000,7000,0,0,0,0),(19,0,10,'ramen.sh@gmail.','','','http://www.sohu.com','','',3,0,0,0,1276169654,'snapshot/5/3/2/5',0,'snapshot/random/23.jpg',0,0,'',0,0,'3c29e52969d51cf519409f60619b6d1e',86239805,0,0,6,0,0,7000,7000,0,0,0,0),(20,0,10,'ramen.sh@gmail.','','','http://www.tudou.com','','',0,0,0,0,1276366535,'snapshot/1/1/1/5',0,'snapshot/random/14.jpg',0,0,'',0,0,'2cc9c959a710cba782cfe7f123c007a4',1235335485,0,0,0,0,0,7000,7000,0,0,0,0),(21,0,10,'ramen.sh@gmail.','','','http://www.tianya.cn','','',2,0,1,0,1280773862,'snapshot/6/2/5/6',0,'snapshot/random/30.jpg',0,0,'',0,0,'ab03fa3e3efa5a55e605a00f9c639191',110802302,0,0,0,0,0,7000,7000,0,0,0,0),(22,0,10,'ramen.sh@gmail.','','','http://www.sina.com','','',0,0,0,0,1280776803,'snapshot/0/7/2/5',0,'snapshot/random/24.jpg',0,0,'',0,0,'c9e237b73229517259dd5a83531f541d',9431805,0,0,0,0,0,7000,7000,0,0,0,0),(23,0,10,'城市森林','','','http://paranimage.com/20-notepad-plus-plugins','','',4,0,0,0,1280925873,'snapshot/7/7/6/3',0,'snapshot/random/28.jpg',0,0,'',0,0,'fe05b6e04ef0f1c0f57eb7098fcf6019',124208755,0,0,8,0,0,7000,7000,0,0,0,0),(24,0,10,'ramen.sh@gmail.','','','http://military.china.com/zh_cn','','',0,0,1,0,1280926642,'snapshot/7/6/0/6',0,'snapshot/random/23.jpg',0,0,'',0,0,'50c0ecee1acfb405efa4630e5b2e34f2',1601108190,0,0,0,0,0,7000,7000,0,0,0,0),(25,0,10,'ramen.sh@gmail.','','','http://mil.news.sina.com.cn','','',0,0,1,0,1280926817,'snapshot/1/0/2/6',0,'snapshot/random/11.jpg',0,0,'',0,0,'3fec3efcb7071c1408ddb31bf6e52010',166216350,0,0,0,0,0,7000,7000,0,0,0,0),(26,0,10,'ramen.sh@gmail.','','','http://war.news.163.com','','',0,0,0,0,1280927022,'snapshot/5/4/4/5',0,'snapshot/random/28.jpg',0,0,'',0,0,'c442cd441e60eaabd30d45582b4fb179',95747325,0,0,0,0,0,7000,7000,0,0,0,0),(27,0,10,'ramen.sh@gmail.','','','http://www.example.com','','',0,0,-1,0,1283819580,'snapshot/5/6/1/5',0,'snapshot/random/13.jpg',0,0,'',0,0,'847310eb455f9ae37cb56962213c491d',2097576285,0,0,0,0,0,7000,7000,0,0,0,0),(29,1,10,'ramen.sh@gmail.com','','','','','',0,0,1,0,1283821453,'snapshot/7/7/4/4',0,'snapshot/random/14.jpg',0,0,'',0,0,'02c7503dad29d7d2fe70ba20f02794f4',259519620,0,0,0,0,0,7000,7000,0,0,0,0),(30,3,10,'ramen.sh@gmail.com','','','http://www.readnovel.com','','',0,0,-1,0,1283824084,'snapshot/6/2/5/5',0,'snapshot/random/22.jpg',0,0,'',0,0,'91dba8f15f73f1680fdee19fdb6d5dd9',1714050429,0,0,0,0,0,7000,7000,0,0,0,0),(31,0,10,'ramen.sh@gmail.com','','','http://www.testing.com','','',0,0,0,0,1283828101,'snapshot/1/7/5/5',0,'snapshot/random/26.jpg',0,0,'',0,0,'75b76a311be4856030c80605d719530c',1773651325,0,0,0,0,0,7000,7000,0,0,0,0),(32,6,10,'ramen.sh@gmail.com','','','\r\n','','',0,0,0,0,1283828201,'snapshot/3/0/3/4',0,'snapshot/random/14.jpg',0,0,'',0,0,'1d17db372cb07b3b6cbe9a3d90500d4f',333468420,0,0,0,0,0,7000,7000,0,0,0,0);

/*Table structure for table `uchome_linkclass` */

DROP TABLE IF EXISTS `uchome_linkclass`;

CREATE TABLE `uchome_linkclass` (
  `classid` mediumint(8) unsigned NOT NULL auto_increment,
  `uid` mediumint(8) unsigned NOT NULL,
  `classname` char(30) NOT NULL default '',
  `groupid` mediumint(8) unsigned NOT NULL default '0',
  `parentid` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `totalnum` smallint(6) unsigned NOT NULL default '0',
  `close` tinyint(1) NOT NULL default '0',
  `nav` tinyint(1) unsigned NOT NULL default '0',
  PRIMARY KEY  (`classid`),
  KEY `tagname` (`classname`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linkclass` */

/*Table structure for table `uchome_linkclasstag` */

DROP TABLE IF EXISTS `uchome_linkclasstag`;

CREATE TABLE `uchome_linkclasstag` (
  `tagid` mediumint(8) unsigned NOT NULL auto_increment,
  `tagname` char(30) NOT NULL default '',
  `hashname` int(10) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `classid` mediumint(8) unsigned NOT NULL,
  `dateline` int(10) unsigned NOT NULL default '0',
  `totalnum` smallint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`tagid`),
  KEY `tagname` (`tagname`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linkclasstag` */

/*Table structure for table `uchome_linkerr` */

DROP TABLE IF EXISTS `uchome_linkerr`;

CREATE TABLE `uchome_linkerr` (
  `linkerrid` mediumint(8) unsigned NOT NULL auto_increment,
  `linkid` mediumint(8) NOT NULL,
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `errid` text NOT NULL,
  `dateline` int(10) unsigned NOT NULL default '0',
  `other` varchar(256) NOT NULL default '',
  PRIMARY KEY  (`linkerrid`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linkerr` */

insert  into `uchome_linkerr`(`linkerrid`,`linkid`,`uid`,`errid`,`dateline`,`other`) values (2,2,1,'1,2,3',1274240115,'sfhjksfhjksfnsjkfnsdjkf');

/*Table structure for table `uchome_linkerrtype` */

DROP TABLE IF EXISTS `uchome_linkerrtype`;

CREATE TABLE `uchome_linkerrtype` (
  `errid` mediumint(8) unsigned NOT NULL auto_increment,
  `errname` char(250) NOT NULL default '',
  PRIMARY KEY  (`errid`),
  KEY `tagname` (`errname`)
) ENGINE=MyISAM AUTO_INCREMENT=256 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linkerrtype` */

insert  into `uchome_linkerrtype`(`errid`,`errname`) values (1,'主页不可访问'),(2,'介绍的内容与实际不相符合'),(3,'含有木马，病毒等内容'),(4,'涉及到政治、黄色、暴力等敏感内容'),(255,'其他原因：');

/*Table structure for table `uchome_linkfield` */

DROP TABLE IF EXISTS `uchome_linkfield`;

CREATE TABLE `uchome_linkfield` (
  `linkid` mediumint(8) unsigned NOT NULL default '0',
  `tag` varchar(255) NOT NULL default '',
  `subject` text NOT NULL,
  `description` mediumtext NOT NULL,
  `postip` varchar(20) NOT NULL default '',
  `related` text NOT NULL,
  `relatedtime` int(10) unsigned NOT NULL default '0',
  `target_ids` text NOT NULL,
  `hotuser` text NOT NULL,
  PRIMARY KEY  (`linkid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linkfield` */

/*Table structure for table `uchome_linktag` */

DROP TABLE IF EXISTS `uchome_linktag`;

CREATE TABLE `uchome_linktag` (
  `tagid` mediumint(8) unsigned NOT NULL auto_increment,
  `tagname` char(30) NOT NULL default '',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `totalnum` smallint(6) unsigned NOT NULL default '0',
  `close` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`tagid`),
  KEY `tagname` (`tagname`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linktag` */

/*Table structure for table `uchome_linktagbookmark` */

DROP TABLE IF EXISTS `uchome_linktagbookmark`;

CREATE TABLE `uchome_linktagbookmark` (
  `tagid` mediumint(8) unsigned NOT NULL default '0',
  `bmid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY  (`tagid`,`bmid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linktagbookmark` */

/*Table structure for table `uchome_linktaglink` */

DROP TABLE IF EXISTS `uchome_linktaglink`;

CREATE TABLE `uchome_linktaglink` (
  `tagid` mediumint(8) unsigned NOT NULL default '0',
  `linkid` mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY  (`tagid`,`linkid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linktaglink` */

/*Table structure for table `uchome_linktoolbar` */

DROP TABLE IF EXISTS `uchome_linktoolbar`;

CREATE TABLE `uchome_linktoolbar` (
  `toolbarid` mediumint(8) unsigned NOT NULL auto_increment,
  `postuid` mediumint(8) unsigned NOT NULL default '0',
  `classid` smallint(4) unsigned NOT NULL default '0',
  `subject` text NOT NULL,
  `url` text NOT NULL,
  `description` text NOT NULL,
  `css` varchar(32) NOT NULL default '',
  `viewnum` mediumint(8) unsigned NOT NULL default '0',
  `replynum` mediumint(8) unsigned NOT NULL default '0',
  `storenum` mediumint(8) NOT NULL default '0',
  `hot` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `hashurl` int(32) unsigned NOT NULL default '0',
  PRIMARY KEY  (`toolbarid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linktoolbar` */

/*Table structure for table `uchome_linktoolbartype` */

DROP TABLE IF EXISTS `uchome_linktoolbartype`;

CREATE TABLE `uchome_linktoolbartype` (
  `classid` mediumint(8) unsigned NOT NULL auto_increment,
  `classname` text NOT NULL,
  `displayorder` tinyint(2) NOT NULL,
  `path` char(255) NOT NULL,
  `sitenum` int(11) NOT NULL,
  `rownum` tinyint(2) unsigned NOT NULL default '8',
  `width` tinyint(2) default '83',
  PRIMARY KEY  (`classid`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linktoolbartype` */

insert  into `uchome_linktoolbartype`(`classid`,`classname`,`displayorder`,`path`,`sitenum`,`rownum`,`width`) values (1,'常用类',1,'',0,8,83),(2,'资讯类',2,'',0,8,83),(3,'购物类',3,'',0,8,83),(4,'娱乐类',4,'',0,8,83),(5,'生活类',5,'',0,8,83),(6,'在线工具',6,'',0,7,95),(7,'常用工具',7,'',0,8,83);

/*Table structure for table `uchome_localclass` */

DROP TABLE IF EXISTS `uchome_localclass`;

CREATE TABLE `uchome_localclass` (
  `classid` int(15) NOT NULL auto_increment,
  `parentid` int(15) NOT NULL default '0',
  `classname` char(20) default NULL,
  `displayorder` int(11) NOT NULL default '100',
  `sitenum` int(11) NOT NULL default '0',
  `path` varchar(255) NOT NULL,
  `keywords` text NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY  (`classid`)
) ENGINE=MyISAM AUTO_INCREMENT=367 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_localclass` */

insert  into `uchome_localclass`(`classid`,`parentid`,`classname`,`displayorder`,`sitenum`,`path`,`keywords`,`description`) values (1,0,'北京',1,0,'beijing','',''),(2,0,'天津',2,0,'tianjin','',''),(3,0,'上海',3,0,'shanghai','',''),(4,0,'重庆',4,0,'chongqing','',''),(5,0,'河北',5,0,'hebei','',''),(6,0,'山西',6,0,'shanxi','',''),(7,0,'辽宁',7,0,'liaoning','',''),(8,0,'吉林',8,0,'jilin','',''),(9,0,'黑龙江',9,0,'heilongjiang','',''),(10,0,'江苏',10,0,'jiangsu','',''),(11,0,'浙江',11,0,'zhejiang','',''),(12,0,'安徽',12,0,'anhui','',''),(13,0,'福建',13,0,'fujian','',''),(14,0,'江西',14,0,'jiangxi','',''),(15,0,'山东',15,0,'shandong','',''),(16,0,'河南',16,0,'henan','',''),(17,0,'湖北',17,0,'hubei','',''),(18,0,'湖南',18,0,'hunan','',''),(19,0,'广东',19,0,'guangdong','',''),(20,0,'海南',20,0,'hainan','',''),(21,0,'四川',21,0,'sichuan','',''),(22,0,'贵州',22,0,'guizhou','',''),(23,0,'云南',23,0,'yunnan','',''),(24,0,'陕西',24,0,'shaanxi','',''),(25,0,'甘肃',25,0,'gansu','',''),(26,0,'青海',26,0,'qinghai','',''),(27,0,'广西',27,0,'guangxi','',''),(28,0,'内蒙古',28,0,'neimenggu','',''),(29,0,'西藏',29,0,'xizang','',''),(30,0,'宁夏',30,0,'ningxia','',''),(31,0,'新疆',31,0,'xinjiang','',''),(32,0,'香港',32,0,'hongkong','',''),(33,0,'澳门',33,0,'aomeng','',''),(34,0,'台湾',34,0,'taiwang','',''),(35,1,'北京地方门户',1,7,'','',''),(36,1,'交通信息',2,5,'','',''),(37,1,'论坛社区',3,9,'','',''),(38,1,'手机通信',4,6,'','',''),(39,1,'租房买房',5,6,'','',''),(40,1,'旅游美食',6,20,'','',''),(41,1,'网上购物',7,5,'','',''),(42,1,'休闲娱乐',8,12,'','',''),(43,1,'政府组织',9,17,'','',''),(44,2,'天津地方门户',1,9,'','',''),(45,2,'交通信息',3,2,'','',''),(46,2,'手机通信',4,3,'','',''),(47,2,'人才招聘',5,2,'','',''),(48,2,'租房买房',6,5,'','',''),(49,2,'旅游美食',7,3,'','',''),(50,2,'教育大学',8,6,'','',''),(51,2,'论坛社区',9,8,'','',''),(52,2,'政府组织',10,4,'','',''),(53,3,'交通信息',2,9,'','',''),(54,3,'论坛社区',3,8,'','',''),(55,3,'手机通信',4,4,'','',''),(56,3,'租房买房',5,9,'','',''),(57,3,'旅游美食',6,8,'','',''),(58,3,'网上购物',7,4,'','',''),(59,3,'休闲娱乐',8,8,'','',''),(60,3,'政府组织',9,7,'','',''),(61,3,'上海地方门户',1,10,'','',''),(62,4,'重庆地方门户',1,21,'','',''),(63,4,'彩票证券',2,2,'','',''),(64,4,'交通信息',3,0,'','',''),(65,4,'手机通信',4,3,'','',''),(66,4,'人才招聘',5,5,'','',''),(67,4,'租房买房',6,3,'','',''),(68,4,'教育大学',7,8,'','',''),(69,4,'论坛社区',8,8,'','',''),(70,4,'政府组织',9,2,'','',''),(71,5,'河北地方门户',1,6,'','',''),(72,5,'论坛社区',3,12,'','',''),(73,5,'新闻媒体',2,14,'','',''),(74,5,'彩票证券',4,2,'','',''),(75,5,'交通信息',5,2,'','',''),(76,5,'手机通信',6,3,'','',''),(77,5,'人才招聘',7,3,'','',''),(78,5,'租房买房',8,2,'','',''),(79,5,'教育大学',9,7,'','',''),(80,5,'政府组织',10,15,'','',''),(81,6,'山西地方门户',1,8,'','',''),(82,6,'新闻媒体',2,9,'','',''),(83,6,'彩票证券',3,2,'','',''),(84,6,'交通信息',4,4,'','',''),(85,6,'手机通信',5,7,'','',''),(86,6,'人才招聘',6,3,'','',''),(87,6,'租房买房',7,4,'','',''),(88,6,'教育大学',8,12,'','',''),(89,6,'论坛社区',9,4,'','',''),(90,6,'政府组织',10,14,'','',''),(91,6,'旅游美食',11,5,'','',''),(92,6,'医疗保健',12,5,'','',''),(93,7,'旅游美食',11,2,'','',''),(94,7,'医疗保健',12,4,'','',''),(95,7,'辽宁地方门户',0,17,'','',''),(96,7,'新闻媒体',2,11,'','',''),(97,7,'论坛社区',3,10,'','',''),(98,7,'人才招聘',0,17,'','4',''),(99,7,'租房买房',0,10,'','5',''),(100,7,'交通信息',6,5,'','',''),(101,7,'手机通信',7,3,'','',''),(102,7,'教育大学',8,13,'','',''),(103,7,'彩票证券',9,4,'','',''),(104,7,'政府组织',10,16,'','',''),(105,8,'新闻媒体',10,3,'','',''),(106,8,'旅游美食',11,3,'','',''),(107,8,'生活资讯',12,1,'','',''),(108,8,'吉林地方门户',1,18,'','',''),(109,8,'交通信息',2,4,'','',''),(110,8,'手机通信',3,4,'','',''),(111,8,'人才招聘',4,2,'','',''),(112,8,'租房买房',5,3,'','',''),(113,8,'教育大学',6,5,'','',''),(114,8,'论坛社区',7,4,'','',''),(115,8,'彩票证券',8,2,'','',''),(116,8,'政府组织',9,11,'','',''),(117,9,'黑龙江地方门户',1,8,'','',''),(118,9,'新闻媒体',2,6,'','',''),(119,9,'论坛社区',3,5,'','',''),(120,9,'租房买房',4,3,'','',''),(121,9,'人才招聘',5,3,'','',''),(122,9,'交通信息',6,4,'','',''),(123,9,'手机通信',7,4,'','',''),(124,9,'彩票证劵',8,2,'','',''),(125,9,'教育大学',9,6,'','',''),(126,9,'政府组织',10,18,'','',''),(127,9,'旅游美食',11,7,'','',''),(128,9,'医疗保健',12,1,'','',''),(129,10,'江苏地方门户',1,13,'','',''),(130,10,'论坛社区',2,32,'','',''),(131,10,'新闻媒体',3,24,'','',''),(132,10,'交通信息',4,6,'','',''),(133,10,'手机通信',5,3,'','',''),(134,10,'医疗保健',6,5,'','',''),(135,10,'教育大学',7,14,'','',''),(136,10,'政府组织',8,22,'','',''),(137,11,'浙江地方门户',1,33,'','',''),(138,11,'新闻媒体',2,7,'','',''),(139,11,'论坛社区',3,30,'','',''),(140,11,'交通信息',4,5,'','',''),(141,11,'手机通信',5,3,'','',''),(142,11,'教育大学',6,9,'','',''),(143,11,'政府组织',7,22,'','',''),(144,11,'人才招聘',8,3,'','',''),(145,11,'旅游美食',9,3,'','',''),(146,11,'医疗保健',10,2,'','',''),(147,11,'彩票证劵',11,1,'','',''),(148,12,'手机通信',6,4,'','',''),(149,12,'人才招聘',7,8,'','',''),(150,12,'租房买房',8,7,'','',''),(151,12,'教育大学',9,8,'','',''),(152,12,'政府组织',10,25,'','',''),(153,12,'旅游美食',11,2,'','',''),(154,12,'医疗保健',12,2,'','',''),(155,12,'安徽地方门户',1,14,'','',''),(156,12,'新闻媒体',2,7,'','',''),(157,12,'论坛社区',3,16,'','',''),(158,12,'彩票证券',4,3,'','',''),(159,12,'交通信息',5,6,'','',''),(160,13,'新闻媒体',1,12,'','',''),(161,13,'论坛社区',2,19,'','',''),(162,13,'人才招聘',3,4,'','',''),(163,13,'租房买房',4,2,'','',''),(164,13,'交通信息',5,8,'','',''),(165,13,'手机通信',6,4,'','',''),(166,13,'彩票证劵',7,3,'','',''),(167,13,'教育大学',8,9,'','',''),(168,13,'政府组织',9,12,'','',''),(169,13,'旅游美食',10,2,'','',''),(170,13,'医疗保健',11,4,'','',''),(171,13,'福建地方门户',12,6,'','',''),(172,14,'彩票证券',2,2,'','',''),(173,14,'交通信息',3,6,'','',''),(174,14,'手机通信',4,5,'','',''),(175,14,'人才招聘',5,5,'','',''),(176,14,'新闻媒体',11,2,'','',''),(177,14,'医疗保健',12,4,'','',''),(178,14,'生活资讯',13,1,'','',''),(179,14,'租房买房',6,7,'','',''),(180,14,'江西地方门户',1,24,'','',''),(181,14,'旅游美食',7,4,'','',''),(182,14,'教育大学',8,11,'','',''),(183,14,'论坛社区',9,8,'','',''),(184,14,'政府组织',10,16,'','',''),(185,15,'人才招聘',10,5,'','',''),(186,15,'医疗保健',11,2,'','',''),(187,15,'彩票证券',12,2,'','',''),(188,15,'山东地方门户',0,40,'','',''),(189,15,'新闻媒体',0,12,'','',''),(190,15,'论坛社区',0,20,'','',''),(191,15,'交通信息',0,8,'','',''),(192,15,'手机通信',0,5,'','',''),(193,15,'租房买房',0,7,'','',''),(194,15,'旅游美食',6,6,'','',''),(195,15,'教育大学',7,13,'','',''),(196,15,'政府组织',8,30,'','',''),(197,16,'河南地方门户',1,8,'','',''),(198,16,'论坛社区',2,9,'','',''),(199,16,'新闻媒体',3,15,'','',''),(200,16,'手机通信',4,3,'','',''),(201,16,'交通信息',5,0,'','',''),(202,16,'租房买房',6,3,'','',''),(203,16,'旅游美食',7,4,'','',''),(204,16,'教育大学',8,6,'','',''),(205,16,'政府组织',9,21,'','',''),(206,17,'湖北地方门户',1,12,'','',''),(207,17,'新闻媒体',2,17,'','',''),(208,17,'论坛社区',3,20,'','',''),(209,17,'休闲娱乐',4,1,'','',''),(210,17,'租房买房',5,4,'','',''),(211,17,'交通信息',6,2,'','',''),(212,17,'手机通信',7,4,'','',''),(213,17,'政府组织',8,32,'','',''),(214,17,'旅游美食',9,5,'','',''),(215,17,'医疗保健',10,4,'','',''),(216,17,'教育大学',11,5,'','',''),(217,18,'湖南地方门户',1,17,'','',''),(218,18,'新闻媒体',2,11,'','',''),(219,18,'论坛社区',3,11,'','',''),(220,18,'交通信息',4,3,'','',''),(221,18,'手机通信',5,3,'','',''),(222,18,'买房租房',6,4,'','',''),(223,18,'旅游美食',7,3,'','',''),(224,18,'教育大学',8,7,'','',''),(225,18,'政府组织',9,19,'','',''),(226,18,'人才招聘',10,4,'','',''),(227,18,'医疗保健',11,2,'','',''),(228,19,'广东地方门户',1,14,'','',''),(229,19,'论坛社区',3,31,'','',''),(230,19,'交通信息',4,8,'','',''),(231,19,'手机通信',5,4,'','',''),(232,19,'租房买房',6,6,'','',''),(233,19,'休闲娱乐',7,6,'','',''),(234,19,'新闻媒体',2,17,'','',''),(235,19,'政府组织',8,28,'','',''),(236,20,'海南地方门户',1,19,'','',''),(237,20,'手机通信',3,7,'','',''),(238,20,'人才招聘',4,6,'','',''),(239,20,'租房买房',5,6,'','',''),(240,20,'旅游美食',6,9,'','',''),(241,20,'医疗保健',7,8,'','',''),(242,20,'教育大学',8,7,'','',''),(243,20,'论坛社区',9,8,'','',''),(244,20,'彩票证券',10,4,'','',''),(245,20,'政府组织',11,18,'','',''),(246,20,'交通信息',2,6,'','',''),(247,21,'人才招聘',10,3,'','',''),(248,21,'旅游美食',11,2,'','',''),(249,21,'医疗保健',12,2,'','',''),(250,21,'四川地方门户',1,8,'','',''),(251,21,'新闻媒体',2,10,'','',''),(252,21,'论坛社区',3,11,'','',''),(253,21,'买房租房',4,5,'','',''),(254,21,'生活资讯',5,8,'','',''),(255,21,'交通信息',6,2,'','',''),(256,21,'手机通信',7,4,'','',''),(257,21,'教育大学',8,14,'','',''),(258,21,'政府组织',9,16,'','',''),(259,22,'贵州地方门户',0,9,'','',''),(260,22,'生活资讯',1,8,'','',''),(261,22,'论坛社区',2,7,'','',''),(262,22,'休闲娱乐',4,1,'','',''),(263,23,'政府组织',9,11,'','',''),(264,23,'旅游美食',10,4,'','',''),(265,23,'医疗保健',11,3,'','',''),(266,23,'彩票证券',12,2,'','',''),(267,23,'论坛社区',8,5,'','',''),(268,23,'教育大学',7,12,'','',''),(269,23,'云南地方门户',1,10,'','',''),(270,23,'新闻媒体',2,7,'','',''),(271,23,'交通信息',3,2,'','',''),(272,23,'手机通信',4,3,'','',''),(273,23,'人才招聘',5,6,'','',''),(274,23,'租房买房',6,4,'','',''),(275,24,'陕西地方门户',1,5,'','',''),(276,24,'新闻媒体',2,11,'','',''),(277,24,'彩票证券',3,4,'','',''),(278,24,'交通信息',4,6,'','',''),(279,24,'手机通信',5,5,'','',''),(280,24,'人才招聘',6,4,'','',''),(281,24,'租房买房',7,5,'','',''),(282,24,'旅游美食',8,6,'','',''),(283,24,'医疗保健',9,2,'','',''),(284,24,'教育大学',10,8,'','',''),(285,24,'论坛社区',11,9,'','',''),(286,24,'政府组织',12,14,'','',''),(287,24,'网上购物',13,1,'','',''),(288,25,'甘肃地方门户',1,22,'','',''),(289,25,'交通信息',2,2,'','',''),(290,25,'手机通信',3,4,'','',''),(291,25,'人才招聘',4,4,'','',''),(292,25,'租房买房',5,5,'','',''),(293,25,'旅游美食',6,8,'','',''),(294,25,'医疗保健',6,5,'','',''),(295,25,'论坛社区',7,7,'','',''),(296,25,'彩票证券',8,2,'','',''),(297,25,'政府组织',9,9,'','',''),(298,25,'教育大学',8,9,'','',''),(299,26,'新闻媒体',1,7,'','',''),(300,26,'手机通信',2,5,'','',''),(301,26,'教育大学',3,6,'','',''),(302,26,'彩票证券',4,3,'','',''),(303,26,'政府组织',5,6,'','',''),(304,27,'广西地方门户',8,7,'','',''),(305,27,'人才招聘',9,1,'','',''),(306,27,'旅游美食',10,2,'','',''),(307,27,'医疗保健',11,2,'','',''),(308,27,'彩票证券',12,3,'','',''),(309,27,'新闻媒体',1,15,'','',''),(310,27,'交通信息',2,3,'','',''),(311,27,'手机通信',3,5,'','',''),(312,27,'租房买房',4,4,'','',''),(313,27,'教育大学',5,7,'','',''),(314,27,'论坛社区',6,16,'','',''),(315,27,'政府组织',7,13,'','',''),(316,28,'内蒙古地方门户',1,14,'','',''),(317,28,'交通信息',2,2,'','',''),(318,28,'手机通信',3,3,'','',''),(319,28,'人才招聘',4,4,'','',''),(320,28,'旅游美食',5,4,'','',''),(321,28,'教育大学',6,9,'','',''),(322,28,'论坛社区',7,3,'','',''),(323,28,'彩票证券',8,2,'','',''),(324,28,'政府组织',9,12,'','',''),(325,28,'新闻媒体',10,3,'','',''),(326,28,'租房买房',11,1,'','',''),(327,28,'医疗保健',12,4,'','',''),(328,29,'新闻媒体',1,7,'','',''),(329,29,'生活资讯',2,4,'','',''),(330,29,'旅游美食',3,1,'','',''),(331,29,'交通信息',4,1,'','',''),(332,30,'新闻媒体',1,13,'','',''),(333,30,'手机通信',2,4,'','',''),(334,30,'人才招聘',3,4,'','',''),(335,30,'租房买房',4,4,'','',''),(336,30,'教育大学',5,8,'','',''),(337,30,'论坛社区',8,8,'','',''),(338,30,'政府组织',9,5,'','',''),(339,30,'旅游美食',6,7,'','',''),(340,30,'医疗保健',7,1,'','',''),(341,30,'彩票证券',10,1,'','',''),(342,31,'新疆地方门户',1,2,'','',''),(343,31,'彩票证券',2,2,'','',''),(344,31,'交通信息',3,1,'','',''),(345,31,'手机通信',4,3,'','',''),(346,31,'论坛社区',5,1,'','',''),(347,31,'教育大学',6,11,'','',''),(348,32,'新闻媒体',1,12,'','',''),(349,32,'旅游美食',2,6,'','',''),(350,32,'政府组织',3,3,'','',''),(351,32,'休闲娱乐',4,4,'','',''),(352,32,'彩票证券',5,5,'','',''),(353,32,'教育大学',6,8,'','',''),(354,32,'生活资讯',7,3,'','',''),(355,32,'人才招聘',8,1,'','',''),(356,33,'新闻媒体',1,8,'','',''),(357,33,'交通信息',2,4,'','',''),(358,33,'教育大学',3,6,'','',''),(359,33,'政府组织',4,5,'','4',''),(360,33,'旅游美食',5,3,'','',''),(361,33,'彩票证券',6,1,'','',''),(362,34,'新闻媒体',1,16,'','',''),(363,34,'生活资讯',2,6,'','',''),(364,34,'休闲娱乐',3,4,'','',''),(365,34,'教育大学',5,9,'','',''),(366,34,'旅游美食',5,2,'','','');

/*Table structure for table `uchome_localsite` */

DROP TABLE IF EXISTS `uchome_localsite`;

CREATE TABLE `uchome_localsite` (
  `id` int(11) NOT NULL auto_increment,
  `name` char(255) NOT NULL default '',
  `url` char(255) NOT NULL default '',
  `class` int(11) NOT NULL default '0',
  `displayorder` int(11) NOT NULL default '100',
  `good` tinyint(1) NOT NULL default '0',
  `day` int(11) default '0',
  `week` int(11) default '0',
  `month` int(11) default '0',
  `total` int(11) default '0',
  `namecolor` char(7) NOT NULL,
  `namestyle` char(10) NOT NULL,
  `adduser` varchar(25) NOT NULL,
  `yesterday` int(11) NOT NULL default '0',
  `byesterday` int(11) NOT NULL default '0',
  `starttime` int(11) NOT NULL default '0',
  `endtime` int(11) NOT NULL default '0',
  `remark` text NOT NULL,
  `end` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `class` (`class`),
  KEY `starttime` (`starttime`),
  KEY `endtime` (`endtime`)
) ENGINE=MyISAM AUTO_INCREMENT=2467 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_localsite` */

insert  into `uchome_localsite`(`id`,`name`,`url`,`class`,`displayorder`,`good`,`day`,`week`,`month`,`total`,`namecolor`,`namestyle`,`adduser`,`yesterday`,`byesterday`,`starttime`,`endtime`,`remark`,`end`) values (1,'首都之窗','http://www.beijing.gov.cn/',35,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2,'千龙网','http://www.qianlong.com/',35,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(3,'北京晨报','http://www.morningpost.com.cn/',35,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(4,'新京报','http://www.bjnews.com.cn/',35,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(5,'北青网','http://www.ynet.com/',35,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(6,'京华时报','http://www.jinghua.cn/',35,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(7,'光明网','http://www.gmw.cn/',35,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(8,'北京公交网','http://www.bjbus.com/',36,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(9,'数字北京','http://ditu.beijing.cn/',36,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(10,'首都机场','http://www.bcia.com.cn/',36,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(11,'交通一卡通','http://www.bmac.com.cn/',36,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(12,'违章查询','http://www.bjjtgl.gov.cn/publish/portal0/tab72/',36,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(13,'北京贴吧','http://tieba.baidu.com/f?kw=%B1%B1%BE%A9',37,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(14,'京华论坛','http://bbs.qianlong.com/',37,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(15,'望京网论坛','http://bbs.wangjing.cn/',37,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(16,'望京社区','http://www.wjsq.com/',37,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(17,'回龙观论坛','http://bbs.hlgnet.com/',37,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(18,'八通网','http://www.bato.cn/',37,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(19,'亦庄生活','http://www.yizlife.com/',37,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(20,'爱我大兴社区','http://bbs.25dx.com/',37,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(21,'天通苑社区网','http://www.tty520.com/',37,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(22,'北京移动','http://www.bj.chinamobile.com/',38,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(23,'北京联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=000100010001&id=1001',38,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(24,'北京宽带','http://www.bbn.com.cn/',38,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(25,'北京电信','http://bj.ct10000.com/',38,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(26,'北京歌华','http://www.bgctv.com.cn/',38,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(27,'长城宽带','http://www.bjgwbn.net.cn/',38,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(28,'北京住房公积金网','http://www.bjgjj.gov.cn/',39,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(29,'北京新房二手房','http://beijing.anjuke.com/?utm_source=hao123cs-bj&utm_medium=cpc&pi=hao123cs-bj&rcc_id=3540f1ab8ae5282f87027159fb069d02',39,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(30,'搜房网-北京','http://bj.soufun.com/',39,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(31,'焦点房产-北京','http://house.focus.cn/',39,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(32,'我爱我家','http://bj.5i5j.com/',39,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(33,'北京房产交易管理网','http://www.bjfdc.gov.cn/',39,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(34,'携程北京旅行指南','http://destguides.ctrip.com/china/beijing/district1/',40,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(35,'首都之窗旅游','http://ly.beijing.cn/index.shtml',40,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(36,'颐和园','http://www.summerpalace-china.com/',40,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(37,'故宫博物院','http://www.dpm.org.cn/',40,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(38,'天安门升/降旗时间','http://www.tiananmen.org.cn/flag/index.asp',40,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(39,'北京旅游信息网','http://www.visitbeijing.com.cn/',40,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(40,'北京动物园','http://www.beijingzoo.com/',40,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(41,'北京植物园','http://www.beijingbg.com/',40,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(42,'北京天文馆','http://www.bjp.org.cn/',40,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(43,'欢乐谷','http://bj.happyvalley.com.cn/',40,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(44,'中国科技馆','http://www.cstm.org.cn/',40,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(45,'首都博物馆','http://www.beijingmuseum.org.cn/',40,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(46,'北京展览馆','http://www.bjexpo.com/',40,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(47,'恭王府','http://www.pgm.org.cn/',40,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(48,'红螺寺','http://www.hongluosi.com/',40,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(49,'凤凰岭','http://www.bjfhl.com/',40,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(50,'大众点评','http://www.dianping.com/beijing',40,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(51,'全聚德直营店地图','http://www.quanjude.com.cn/map.html',40,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(52,'北京美食-爱帮网','http://www.aibang.com/hao123/beijing_meishi.html',40,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(53,'味多美','http://www.wdmcake.cn/',40,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(54,'我爱打折','http://www.55bbs.com/',41,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(55,'中关村图书大厦','http://www.zgcbb.com/',41,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(56,'西单图书大厦','http://www.bjbb.com/',41,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(57,'王府井书店','http://www.wfjsd.com/',41,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(58,'家乐福','http://www.carrefour.com.cn/',41,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(59,'六人行','http://www.ifindu.cn/',42,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(60,'798艺术区','http://www.798art.org/',42,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(61,'国家大剧院','http://www.chncpa.org/',42,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(62,'中国票务在线','http://www.piao.com.cn/',42,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(63,'北京影讯','http://data.ent.sina.com.cn/cinema/area.php?&dpc=1',42,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(64,'万达影城','http://www.wandafilm.com/',42,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(65,'大悦城','http://www.xidanjoycity.com/',42,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(66,'美嘉影城','http://www.imegabox.com/',42,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(67,'钱柜','http://www.cn.cashboxparty.com/',42,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(68,'北京酒吧夜时尚','http://www.clubzone.cn/',42,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(69,'北京钓鱼网','http://www.bjdiaoyu.com/',42,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(70,'星美国际影城','http://www.ixingmei.com/',42,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(71,'北京市政府','http://www.beijing.gov.cn/',43,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(72,'北京市工商管理局','http://www.hd315.gov.cn/',43,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(73,'北京市公安局','http://www.bjgaj.gov.cn/',43,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(74,'北京市财政局','http://www.bjcz.gov.cn/',43,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(75,'北京交通管理局','http://www.bjjtgl.gov.cn/',43,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(76,'北京市发改委','http://www.bjpc.gov.cn/',43,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(77,'北京法院网','http://bjgy.chinacourt.org/',43,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(78,'北京市卫生局','http://www.bjhb.gov.cn/',43,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(79,'北京市地方税务局','http://www.tax861.gov.cn/',43,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(80,'北京国税','http://www.bjsat.gov.cn/',43,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(81,'北京市建设委员会','http://www.bjjs.gov.cn/',43,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(82,'北京市商务局','http://www.bjmbc.gov.cn/',43,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(83,'北京市民政局','http://www.bjmzj.gov.cn/',43,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(84,'北京市统计局','http://www.bjstats.gov.cn/',43,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(85,'北京市环保局','http://www.bjepb.gov.cn/',43,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(86,'房山信息网','http://www.bjfsh.gov.cn/',43,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(87,'北京会计网','http://www.kuaiji.com.cn/',43,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(88,'今晚报','http://www.jwb.com.cn/',44,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(89,'天津热线','http://www.online.tj.cn/',44,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(90,'天津日报','http://www.tianjindaily.com.cn/',44,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(91,'天津电视台','http://www.tjtv.com.cn/',44,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(92,'天津人民广播电台','http://www.radiotj.com/',44,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(93,'北方网','http://www.enorth.com.cn/',44,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(94,'塘沽在线','http://www.tanggu.net.cn/',44,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(95,'新华网天津频道','http://www.tj.xinhuanet.com/',44,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(96,'天津政务网','http://www.tj.gov.cn/',44,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(97,'天津天气预报','http://www.weather.com.cn/html/weather/101030100.shtml',45,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(98,'天津卫星地图(google)','http://maps.google.com/maps?f=q&hl=zh-CN&q=tianjin&ie=UTF8&ll=39.130001,117.199996&spn=0.011918,0.026264&t=h&om=1',45,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(99,'天津移动','http://www.tj.chinamobile.com/',46,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(100,'天津联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=000100030001&id=1042',46,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(101,'天津电信','http://tj.ct10000.com/',46,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(102,'北方人才网','http://www.tjrc.com.cn/',47,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(103,'天津劳动保障网','http://www.tj.lss.gov.cn/',47,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(104,'焦点房产天津','http://tj.focus.cn/',48,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(105,'搜房网天津','http://tj.soufun.com/',48,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(106,'天津市房管局','http://www.tjfdc.gov.cn/',48,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(107,'全房网','http://tj.allfang.com/',48,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(108,'天津住房公积金管理中心','http://www.zfgjj.cn/',48,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(109,'天津美食网','http://www.022ms.com/',49,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(110,'酷天津','http://www.kutj.com/',49,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(111,'天津二手网','http://www.tj2shou.com/',49,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(112,'天津招考信息网','http://www.zhaokao.net/',50,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(113,'南开大学','http://www.nankai.edu.cn/',50,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(114,'天津大学','http://www.tju.edu.cn/',50,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(115,'天津工业大学','http://www.tjpu.edu.cn/',50,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(116,'天津人事考试网','http://www.tjkpzx.com/',50,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(117,'中国民航大学','http://www.cauc.edu.cn/',50,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(118,'北方论坛','http://forum.enorth.com.cn/',51,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(119,'天津论坛','http://bbs.kutj.com/',51,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(120,'天涯社区-天津','http://www.tianya.cn/new/TianyaCity/ArticlesList_Culture.asp?idWriter=0&Key=0&idItem=59',51,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(121,'天津贴吧','http://post.baidu.com/f?kw=%CC%EC%BD%F2',51,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(122,'渤海论坛','http://www.bohaibbs.org/',51,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(123,'百丽吧','http://www.belle8.com/',51,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(124,'趣拜网','http://www.qvbuy.com/bbs/',51,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(125,'塘沽论坛','http://www.tgbbs.cn/',51,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(126,'天津政务网','http://www.tj.gov.cn/',52,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(127,'天津国税','http://www.tjsat.gov.cn/',52,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(128,'天津财税网','http://www.tjcs.gov.cn/',52,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(129,'天津滨海新区','http://www.bh.gov.cn/',52,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(130,'丁丁网','http://www.ddmap.com/',53,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(131,'上海交通网','http://www.jt.sh.cn/',53,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(132,'上海机场','http://www.shanghaiairport.com/',53,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(133,'上海地铁','http://www.shmetro.com/',53,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(134,'南站长途客运','http://www.ctnz.net/',53,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(135,'城市吧','http://www.city8.com/',53,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(136,'上海轨道交通俱乐部','http://www.metrofans.sh.cn/',53,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(137,'违章查询','http://www.shjtaq.com/',53,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(138,'上海火车站','http://shz.shrail.com/',53,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(139,'上海热线论坛','http://bbs.online.sh.cn/',54,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(140,'青浦论坛','http://www.qpstar.com/',54,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(141,'上海文玩','http://www.feiqu.com/',54,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(142,'KDS宽带山','http://club.pchome.net/forum_1_15.html',54,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(143,'酷爱上海论坛','http://bbs.kooaoo.com/',54,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(144,'新金山论坛','http://bbs.xinjs.cn/',54,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(145,'南汇生活网论坛','http://bbs.52life.cc/',54,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(146,'上海人谈谈山海经','http://www.shanghaining.com/forum/',54,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(147,'上海移动','http://www.sh.chinamobile.com/',55,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(148,'上海电信','http://sh.ct10000.com/',55,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(149,'上海联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=000100020001&id=1021',55,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(150,'上海邮政','http://www.shpost.com.cn/',55,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(151,'上海住房公积金网','http://www.shgjj.com/',56,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(152,'上海房屋管理局','http://www.shfg.gov.cn/',56,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(153,'搜房网-上海','http://sh.soufun.com/',56,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(154,'焦点上海房地产网','http://sh.focus.cn/',56,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(155,'安家网','http://www.anjia.com/',56,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(156,'房产之窗','http://www.ehomeday.com/',56,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(157,'上海新房二手房','http://shanghai.anjuke.com/?utm_source=hao123cs-sh&utm_medium=cpc&pi=hao123cs-sh&rcc_id=fe7ac2cc3e6a11d5a37d0fada1c1286b',56,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(158,'网上房地产','http://www.fangdi.com.cn/',56,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(159,'搜屋网','http://www.souwoo.com/',56,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(160,'上海热线-旅游','http://tttrip.online.sh.cn/',57,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(161,'上海旅游网','http://www.shanghaitour.net/',57,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(162,'上海野生动物园','http://www.shwzoo.com/',57,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(163,'上海旅游集散中心','http://www.chinassbc.com/',57,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(164,'上海博物馆','http://www.shanghaimuseum.net/',57,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(165,'上海世博会','http://www.expo2010.cn/',57,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(166,'上海国际展览中心','http://www.intex-sh.com/',57,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(167,'上海美术馆','http://www.sh-artmuseum.org.cn/',57,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(168,'上海打折网','http://www.shhbm.com/',58,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(169,'上海团购网','http://www.shtuangou.com/',58,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(170,'篱笆网','http://bbs.sh.liba.com/',58,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(171,'大众点评网','http://www.dianping.com/shanghai',58,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(172,'上海歌城','http://www.shgcktv.com/',59,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(173,'上海大剧院','http://www.shgtheatre.com/',59,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(174,'东方票务','http://www.ticket2010.com/',59,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(175,'上海影城','http://www.filmcenter.com.cn/',59,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(176,'上海欢乐谷','http://sh.happyvalley.com.cn/',59,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(177,'辛香汇','http://www.xinxianghui.com/',59,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(178,'上海图书馆','http://www.libnet.sh.cn/',59,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(179,'胡椒蓓蓓','http://www.hujiaobeibei.net/',59,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(180,'上海市政府','http://www.shanghai.gov.cn/',60,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(181,'上海浦东','http://www.pudong.gov.cn/',60,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(182,'上海市工商局','http://www.sgs.gov.cn/',60,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(183,'上海海关','http://shanghai.customs.gov.cn/',60,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(184,'上海市财税网','http://www.csj.sh.gov.cn/',60,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(185,'上海海事局','http://www.shmsa.gov.cn/',60,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(186,'上海市公安局','http://www.police.sh.cn/',60,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(187,'上海热线','http://www.online.sh.cn/',61,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(188,'中国上海','http://www.shanghai.gov.cn/',61,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(189,'东方网','http://www.eastday.com/',61,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(190,'文汇报','http://whb.news365.com.cn/',61,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(191,'东方早报','http://www.dfdaily.com/',61,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(192,'新民晚报','http://xmwb.news365.com.cn/',61,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(193,'上海东方电视台','http://www.dragontv.cn/',61,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(194,'新民网','http://www.xinmin.cn/',61,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(195,'文广传媒','http://www.smg.cn/',61,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(196,'解放日报','http://epaper.jfdaily.com/',61,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(197,'重庆热线','http://www.online.cq.cn/',62,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(198,'华龙网','http://www.cqnews.net/',62,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(199,'重庆晚报','http://cqwb.cqnews.net/',62,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(200,'重庆广播电视集团','http://www.ccqtv.com/',62,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(201,'重庆政府公众信息网','http://www.cq.gov.cn/',62,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(202,'长寿热线','http://www.cs.cq.cn/',62,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(203,'经典重庆','http://www.classic023.com/',62,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(204,'重庆新闻网','http://www.cqnews.com.cn/',62,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(205,'重庆之窗','http://www.cqwin.com/',62,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(206,'大渝网','http://cq.qq.com/',62,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(207,'三峡之窗','http://www.wz.cq.cn/',62,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(208,'万州信息港','http://www.wz.gov.cn/',62,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(209,'新华网重庆频道','http://www.cq.xinhuanet.com/',62,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(210,'永川热线','http://www.yc.cq.cn/',62,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(211,'黔江信息港','http://www.qianjiang.cq.cn/',62,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(212,'江津在线','http://www.e47.cn/',62,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(213,'阳光在线','http://www.sun116.com/',62,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(214,'重庆商报','http://cqsb.cqnews.net/',62,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(215,'重庆口碑网','http://chongqing.koubei.com/',62,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(216,'涪陵在线','http://www.fuling.com/',62,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(217,'重庆时报','http://ecqsb.hsw.cn/',62,21,0,0,0,0,0,'','','',0,0,0,0,'',0),(218,'重庆彩票网','http://www.cqcp.net/',63,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(219,'重庆体彩网','http://www.cqlottery.gov.cn/',63,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(220,'重庆移动','http://www.cq.chinamobile.com/',65,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(221,'重庆联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=000100100001&id=3571',65,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(222,'重庆电信','http://cq.ct10000.com/',65,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(223,'重庆人才市场','http://www.hrm.cq.cn/',66,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(224,'前程无忧重庆站','http://www.51job.com/default-area.php?area=0600',66,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(225,'重庆人才网','http://www.cqjob.com/',66,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(226,'联英人才网','http://www.hrm.cn/',66,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(227,'重庆市人事局','http://www.cqpa.gov.cn/',66,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(228,'搜房网重庆站','http://cq.soufun.com/',67,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(229,'重庆焦点房产网','http://cq.focus.cn/',67,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(230,'重庆市房管局','http://www.cqgtfw.gov.cn/',67,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(231,'重庆大学','http://www.cqu.edu.cn/',68,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(232,'重庆邮电大学','http://www.cqupt.edu.cn/',68,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(233,'西南政法大学','http://www.swupl.edu.cn/',68,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(234,'西南大学','http://www.swnu.edu.cn/',68,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(235,'重庆医科大学','http://www.cqmu.edu.cn/',68,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(236,'重庆师范大学','http://www.cqnu.edu.cn/',68,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(237,'重庆交通大学','http://www.cqjtu.edu.cn/',68,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(238,'四川外语学院','http://www.sisu.edu.cn/',68,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(239,'重庆论坛','http://bbs.classic023.com/',69,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(240,'天涯社区-重庆','http://bbs.city.tianya.cn/new/tianyacity/articleslist_culture_v3.asp?idWriter=0&Key=0&idItem=45',69,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(241,'重庆购物狂论坛','http://go.cqmmgo.com/',69,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(242,'涪风论坛','http://bbs.fuling.com/',69,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(243,'重庆贴吧','http://post.baidu.com/f?kw=%D6%D8%C7%EC',69,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(244,'重庆钓鱼网','http://www.cqfishing.net/',69,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(245,'两江论坛','http://bbs.cqnews.net/',69,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(246,'重庆妈妈网','http://www.cqmama.net/',69,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(247,'重庆市政府','http://www.cq.gov.cn/',70,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(248,'重庆市公安局','http://www.cqga.gov.cn/',70,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(249,'银河网','http://www.inhe.net/',71,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(250,'河北新闻网','http://www.hebnews.cn/',71,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(251,'燕赵都市报','http://yzdsb.hebnews.cn/',71,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(252,'河北电视台','http://www.hebtv.com/',71,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(253,'石家庄新闻网','http://www.sjzdaily.com.cn/',71,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(254,'河北经济日报','http://www.hbjjrb.com/',71,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(255,'沧州论坛','http://www.czqq.com/',72,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(256,'石家庄二手网','http://www.sehand.com/',72,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(257,'百度贴吧河北','http://tieba.baidu.com/f?kw=河北',72,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(258,'百度贴吧石家庄','http://tieba.baidu.com/f?kw=%CA%AF%BC%D2%D7%AF',72,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(259,'莲池论坛','http://bdbbs.inhe.net/',72,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(260,'永年论坛','http://bbs.ynian.com/',72,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(261,'百度贴吧秦皇岛','http://tieba.baidu.com/f?kw=%C7%D8%BB%CA%B5%BA',72,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(262,'百度贴吧唐山','http://tieba.baidu.com/f?kw=%CC%C6%C9%BD',72,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(263,'廊坊吧','http://tieba.baidu.com/f?kw=%C0%C8%B7%BB',72,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(264,'文安大众论坛','http://bbs.renmin.cc/',72,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(265,'唐山论坛','http://www.5its.com/',72,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(266,'辛集社区','http://www.xinji.org/',72,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(267,'长城在线','http://www.hebei.com.cn/',73,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(268,'邯郸在线','http://www.hdol.cn/',73,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(269,'衡水热线','http://hs.inhe.net/',73,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(270,'保定热线','http://www.bdinfo.net/',73,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(271,'邢台123','http://www.xingtai123.com/',73,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(272,'廊坊热线','http://www.langfang.net/',73,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(273,'邢台信息港','http://xingtai.inhe.net/',73,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(274,'承德信息港','http://www.zisai.com/',73,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(275,'邯郸信息港','http://www.hdt.net.cn/',73,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(276,'秦皇岛信息港','http://www.qhd.com.cn/',73,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(277,'张家口热线','http://zhangjiakou.inhe.net/',73,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(278,'邯郸之窗','http://www.hdzc.net/',73,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(279,'环渤海新闻网','http://www.huanbohainews.com.cn/',73,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(280,'沧州信息港','http://www.cangzhou.net.cn/',73,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(281,'燕赵福彩网','http://www.yzfcw.com/',74,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(282,'河北体彩网','http://www.hbtcw.com/',74,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(283,'河北气象','http://www.weather.he.cninfo.net/',75,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(284,'石家庄公交','http://www.sjzbus.com.cn/',75,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(285,'河北移动','http://www.he.chinamobile.com/',76,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(286,'河北联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010025&id=1461',76,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(287,'河北电信','http://www.hbtele.com/',76,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(288,'河北人才网','http://www.hbrc.com.cn/',77,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(289,'河北劳动保障网','http://www.he.lss.gov.cn/',77,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(290,'银河网人才','http://www.jobinhe.net/',77,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(291,'搜房-石家庄','http://sjz.soufun.com/',78,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(292,'银河网房产','http://house.inhe.net/',78,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(293,'河北教育考试院','http://www.hebeea.edu.cn/',79,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(294,'河北教育厅','http://www.hee.cn/',79,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(295,'河北教师教育网','http://www.hbte.com.cn/',79,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(296,'河北教育网','http://www.hebjy.com/',79,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(297,'河北大学','http://www.hbu.edu.cn/',79,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(298,'燕山大学','http://www.ysu.edu.cn/',79,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(299,'华北电力大学','http://www.ncepu.edu.cn/',79,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(300,'河北省政府','http://www.hebei.gov.cn/',80,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(301,'河北省交通厅','http://www.hbsjtt.gov.cn/',80,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(302,'河北省财政厅','http://www.hebcz.gov.cn/',80,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(303,'河北省地方税务局','http://www.hebds.gov.cn/',80,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(304,'石家庄市政府','http://www.sjz.gov.cn/',80,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(305,'邢台','http://www.xingtai.gov.cn/',80,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(306,'唐山','http://www.tangshan.gov.cn/',80,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(307,'邯郸','http://www.hd.cn/',80,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(308,'承德','http://www.chengde.gov.cn/',80,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(309,'廊坊','http://www.lf.gov.cn/',80,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(310,'河北卫生厅','http://www.hebwst.gov.cn/',80,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(311,'衡水','http://www.hengshui.gov.cn/',80,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(312,'河北省政府采购网','http://www.hebgp.gov.cn/',80,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(313,'石家庄市公安局','http://www.sjzgaj.gov.cn/',80,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(314,'河北省人事厅','http://www.hebrs.gov.cn/',80,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(315,'晋城在线','http://www.jconline.cn/',81,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(316,'阳泉信息港','http://www.yq.sx.cninfo.net/',81,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(317,'汾河信息港','http://www.yz.sx.cn/',81,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(318,'龙城热线','http://www.ty.sx.cn/',81,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(319,'大同热线','http://www.dtrx.cn/',81,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(320,'山西信息港','http://www.sjrx.com/',81,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(321,'山西邮政','http://www.sxpost.com.cn/',81,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(322,'太原道','http://www.tydao.com/',81,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(323,'太原新闻网','http://www.tynews.com.cn/',82,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(324,'山西黄河新闻网','http://www.sxgov.cn/',82,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(325,'新华网山西频道','http://www.sx.xinhuanet.com/',82,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(326,'山西新闻网','http://www.daynews.com.cn/',82,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(327,'山西广播电视总台','http://www.sxrtv.com/',82,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(328,'山西青年报','http://www.sxqnb.com.cn/',82,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(329,'山西晚报','http://www.sxwbs.com/',82,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(330,'黄河新闻网','http://www.huanghenews.com.cn/',82,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(331,'中新社山西新闻','http://www.sx.chinanews.com.cn/',82,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(332,'山西福利彩票','http://www.sxfc.org.cn/sxfc/',83,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(333,'山西体彩网','http://www.sxlottery.net/',83,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(334,'山西气象信息网','http://www.sxqx.gov.cn/',84,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(335,'太原公交','http://www.taiyuanbus.com/',84,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(336,'山西地图','http://map.daynews.com.cn/',84,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(337,'百度地图-太原','http://map.baidu.com/#word=%CC%AB%D4%AD&ct=10',84,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(338,'山西移动','http://www.sx.chinamobile.com/',85,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(339,'山西联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010018&id=2946',85,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(340,'山西电信','http://sx.ct10000.com/',85,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(341,'山西通信','http://www.sjrx.com/4',85,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(342,'山西铁通','http://www.cttsx.com/',85,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(343,'宽带三晋','http://kdsj2.sx.cn/',85,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(344,'互联星空山西','http://www.vnet.cn/sx',85,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(345,'太原人才网','http://www.tyrc.com.cn/',86,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(346,'太原人事考试网','http://www.typta.com.cn/',86,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(347,'山西人才网','http://www.sjrc.com.cn/',86,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(348,'housoo房产资讯','http://www.housoo.com/',87,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(349,'搜房太原','http://taiyuan.soufun.com/',87,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(350,'太原房产管理局','http://www.ty-realestate.com.cn/',87,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(351,'太原住房公积金网','http://www.tygjj.com/',87,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(352,'山西省招生考试网','http://www.sxkszx.cn/',88,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(353,'山西省教育厅','http://www.sxedu.gov.cn/',88,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(354,'山西人事考试网','http://www.sxpta.com/',88,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(355,'山西大学','http://www.sxu.edu.cn/',88,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(356,'太原理工大学','http://www.tyut.edu.cn/',88,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(357,'中北大学','http://www.nuc.edu.cn/',88,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(358,'山西师范大学','http://www.sxnu.edu.cn/',88,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(359,'山西医科大学','http://www.sxmu.edu.cn/',88,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(360,'山西财经大学','http://www.sxufe.edu.cn/',88,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(361,'太原科技大学','http://www.tyust.edu.cn/',88,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(362,'山西省财政税务专科学校','http://www.sxftc.edu.cn/',88,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(363,'山西大学商务学院','http://www.sdsy.sxu.edu.cn/',88,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(364,'空间论坛','http://bbs.longcity.net/',89,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(365,'太原贴吧','http://post.baidu.com/f?kw=%CC%AB%D4%AD',89,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(366,'山西贴吧','http://post.baidu.com/f?kw=%C9%BD%CE%F7',89,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(367,'天涯社区山西','http://www.tianya.cn/new/TianyaCity/ArticlesList_Culture.asp?idWriter=0&Key=0&idItem=88',89,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(368,'太原','http://www.taiyuan.gov.cn/',90,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(369,'山西省建设厅','http://www.sxjs.gov.cn/',90,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(370,'山西省政府','http://www.shanxigov.cn/',90,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(371,'吕梁','http://www.lvliang.gov.cn/',90,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(372,'晋中','http://www.sxjz.gov.cn/',90,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(373,'大同','http://www.dt.gov.cn/',90,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(374,'阳泉','http://www.yq.gov.cn/',90,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(375,'长治','http://www.changzhi.gov.cn/',90,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(376,'晋城','http://www.jconline.cn/',90,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(377,'朔州','http://www.shuozhou.gov.cn/',90,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(378,'临汾','http://www.linfen.gov.cn/',90,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(379,'忻州','http://www.sxxz.gov.cn/',90,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(380,'山西工商','http://www.sxaic.gov.cn/',90,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(381,'山西省发展改革委员会','http://www.sxdrc.gov.cn/',90,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(382,'山西信息港旅游频道','http://sxly.sjrx.com/',91,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(383,'山西新闻网美食','http://www.daynews.com.cn/life/ms/list.html',91,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(384,'太原美食网','http://www.tyeat.com/',91,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(385,'中国面食网','http://www.cnwfn.com/',91,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(386,'大众点评网太原','http://www.dianping.com/taiyuan/food',91,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(387,'三晋健康网','http://www.sjjkw.com/',92,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(388,'山西卫生信息网','http://www.sxws.cn/',92,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(389,'山西省红十字会','http://www.sxredcross.org.cn/',92,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(390,'山西省人民医院','http://sxsrmyy.hos.999120.net/',92,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(391,'山西医科大学第二医院','http://www.sedey.com/',92,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(392,'辽宁旅游信息网','http://www.lntour.gov.cn/',93,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(393,'nen旅游','http://travel.nen.com.cn/',93,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(394,'辽宁省中医院','http://www.lntcm.com.cn/',94,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(395,'辽宁省人民医院','http://www.lnph.com/',94,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(396,'沈阳市妇婴医院','http://www.sy-fyyy.com/',94,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(397,'辽宁省红十字会','http://www.lnredcross.org.cn/',94,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(398,'北国网','http://www.lnd.com.cn/',95,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(399,'丹东信息港','http://www.041599.com/',95,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(400,'海力网','http://www.hilizi.com/',95,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(401,'沈阳网','http://www.syd.com.cn/',95,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(402,'鞍山信息港','http://www.asptt.ln.cn/',95,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(403,'北方时空','http://www.northtimes.com/',95,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(404,'沈阳热线','http://sy.northtimes.com/',95,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(405,'抚顺信息港','http://www.n169.com/',95,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(406,'本溪时空','http://bx.northtimes.com/',95,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(407,'锦州在线','http://www.jzptt.ln.cn/',95,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(408,'铁岭信息港','http://tl.northtimes.com/',95,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(409,'辽阳信息港','http://www.lyip.com.cn/',95,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(410,'朝阳之窗','http://cy.northtimes.com/',95,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(411,'辽宁邮政','http://www.ln183.com/',95,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(412,'沈阳养老保险','http://www.ylbxglzx.cn/',95,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(413,'中国抚顺','http://www.fushun.gov.cn/',95,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(414,'中国锦州','http://www.cnjz.net/',95,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(415,'东北新闻网','http://www.nen.com.cn/',96,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(416,'辽宁电视台','http://www.lntv.cn/',96,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(417,'辽一网','http://www.liao1.com/',96,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(418,'辽宁新闻网','http://www.lnnews.net/',96,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(419,'辽沈晚报','http://newspaper.lndaily.com.cn/lswbn/',96,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(420,'振兴东北网','http://chinaneast.xinhuanet.com/',96,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(421,'沈阳电视台','http://www.csytv.com/',96,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(422,'沈阳广播网','http://www.syradio.cn/',96,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(423,'新华网辽宁频道','http://www.ln.xinhuanet.com/',96,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(424,'nen健康频道','http://health.nen.com.cn/',96,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(425,'搜狐社区辽宁','http://club.travel.sohu.com/list_art_sub.new.php?b=liaoning',96,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(426,'北国论坛','http://bbs.lnd.com.cn/',97,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(427,'新华网社区振兴东北','http://forum.xinhuanet.com/listtopic.jsp?bid=82&catid=56',97,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(428,'大连论坛','http://bbs.runsky.com/bbs/main.html',97,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(429,'营口论坛','http://www.chinayk.com/',97,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(430,'辽宁贴吧','http://post.baidu.com/f?kw=辽宁',97,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(431,'沈阳贴吧','http://post.baidu.com/f?kw=沈阳',97,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(432,'大连贴吧','http://post.baidu.com/f?kw=大连',97,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(433,'时代丹东','http://www.dd365t.com/',97,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(434,'辽宁钓鱼论坛','http://pbbs.lnfisher.com/',97,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(435,'金虎论坛','http://bbs.nen.com.cn/',97,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(436,'大连劳动保障网','http://www.dl12333.gov.cn/',98,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(437,'中国沈阳人才网','http://www.syrc.com.cn/',98,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(438,'辽宁人事人才信息网','http://www.lnrc.com.cn/',98,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(439,'辽沈人才网','http://www.liaoshenrc.com/',98,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(440,'前程无忧-沈阳','http://www.51job.com/default-area.php?area=2302',98,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(441,'葫芦岛人才网','http://www.hldjob.com/',98,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(442,'朝阳人事人才网','http://www.lncyrc.com.cn/',98,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(443,'鞍山人事编制网','http://www.asrs.gov.cn/',98,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(444,'前程无忧-大连','http://www.51job.com/default-area.php?area=2303',98,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(445,'大连人才网','http://www.dl-rc.com/',98,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(446,'大连市人事局','http://www.rsj.dl.gov.cn/',98,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(447,'沈阳人事网','http://www.syrsw.gov.cn/',98,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(448,'抚顺人才网','http://www.fsrc.com.cn/',98,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(449,'锦州人才网','http://www.0416job.com/',98,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(450,'辽宁人才市场','http://www.lnrcsc.com/',98,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(451,'沈阳人才市场','http://www.syrcsc.cn/',98,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(452,'中华英才大连站','http://dalian.chinahr.com/',98,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(453,'购房者网站','http://dl.goufang.com/',99,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(454,'搜房沈阳','http://sy.soufun.com/',99,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(455,'大连住房公积金网','http://www.gjj.dl.gov.cn/',99,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(456,'沈阳住房公积金','http://www.sygjj.com/',99,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(457,'锦州房产网','http://www.jzhome.cn/',99,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(458,'葫芦岛房产网','http://www.hldhouse.com/',99,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(459,'沈阳房产','http://www.syfc.com.cn/',99,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(460,'东北新闻网房产','http://house.nen.com.cn/',99,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(461,'东北房产网','http://www.dbfc.cn/',99,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(462,'大连房产市场','http://www.dl-fangdi.com.cn/',99,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(463,'东北新闻网地图','http://map.nen.com.cn/',100,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(464,'沈阳公交网','http://www.shenyangbus.com/',100,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(465,'沈阳交通违章查询','http://www.sygajj.gov.cn/',100,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(466,'大连机场','http://www.dlairport.com/',100,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(467,'沈阳地铁','http://www.symtc.com/',100,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(468,'辽宁移动','http://www.ln.chinamobile.com/',101,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(469,'辽宁联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010011&id=3613',101,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(470,'辽宁电信','http://www.lntele.com/',101,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(471,'辽宁教育网','http://www.lnen.cn/',102,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(472,'辽宁会计网','http://www.lnkjw.com/',102,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(473,'辽宁招生考试之窗','http://www.lnzsks.com/',102,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(474,'沈阳招生考试网','http://www.syzsks.com/',102,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(475,'辽宁人事考试网','http://www.lnrsks.com/',102,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(476,'大连理工大学','http://www.dlut.edu.cn/',102,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(477,'东北大学','http://www.neu.edu.cn/',102,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(478,'中国医科大学','http://www.cmu.edu.cn/',102,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(479,'东北财经大学','http://www.dufe.edu.cn/',102,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(480,'沈阳药科大学','http://www.syphu.edu.cn/',102,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(481,'辽宁大学','http://www.lnu.edu.cn/',102,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(482,'沈阳农业大学','http://www.syau.edu.cn/',102,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(483,'东北新闻网教育','http://tech.nen.com.cn/',102,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(484,'辽宁福彩','http://www.lnlotto.com/',103,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(485,'辽宁体彩','http://www.lntycp.com/',103,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(486,'北国彩票','http://cp.lnd.cn/',103,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(487,'沈阳诚浩证劵','http://www.chstock.com/',103,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(488,'辽宁省政府','http://www.ln.gov.cn/',104,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(489,'辽宁省国家税务局','http://ln-n-tax.gov.cn/',104,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(490,'劳动社会保障厅','http://www.ln.lss.gov.cn/',104,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(491,'葫芦岛','http://www.hld.gov.cn/',104,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(492,'沈阳','http://www.shenyang.gov.cn/',104,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(493,'大连','http://www.dl.gov.cn/',104,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(494,'鞍山','http://www.anshan.gov.cn/',104,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(495,'盘锦','http://www.panjin.gov.cn/',104,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(496,'朝阳','http://www.zgcy.gov.cn/',104,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(497,'丹东','http://www.dandong.gov.cn/',104,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(498,'锦州','http://www.jz.gov.cn/',104,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(499,'铁岭','http://www.tieling.gov.cn/',104,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(500,'阜新','http://www.fuxin.gov.cn/',104,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(501,'辽阳','http://www.liaoyang.gov.cn/',104,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(502,'辽宁工商局','http://www.lngs.gov.cn/',104,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(503,'本溪政务网','http://www.benxi.gov.cn/',104,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(504,'新华网吉林频道','http://www.jl.xinhua.org/',105,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(505,'人民网吉林视窗','http://unn.people.com.cn/GB/14780/index.html',105,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(506,'云南人民广播电台','http://www.ynrmgbdt.cn/',105,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(507,'吉林市旅游信息网','http://www.gojl.com.cn/',106,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(508,'大众点评网长春','http://www.dianping.com/changchun/food',106,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(509,'新华网吉林美食','http://www.jl.xinhua.org/shangye/food/index.htm',106,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(510,'吉林婚庆网','http://www.jlhqw.com/',107,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(511,'白城热线','http://www.bc0436.com/',108,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(512,'吉林信息港','http://www.jl.cninfo.net/',108,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(513,'中国吉林','http://www.chinajilin.com.cn/',108,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(514,'白山风采','http://www.bs.jl.cn/',108,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(515,'吉林市信息港','http://www.jl.jl.cn/',108,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(516,'长春信息港','http://www.ccgang.cn/',108,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(517,'吉林电视网','http://www.jilintv.cn/',108,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(518,'新文化报','http://www.xwhb.com/',108,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(519,'延边信息港','http://www.yb983.com/',108,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(520,'长视网','http://www.chinactv.com/',108,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(521,'长春163','http://www.cc163.net/',108,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(522,'延边风采','http://www.yb.jl.cn/',108,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(523,'城市晚报','http://cswbszb.chinajilin.com.cn/paperindex.htm',108,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(524,'辽源信息港','http://www.0437.com/',108,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(525,'通化信息港','http://www.th.jl.cn/',108,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(526,'白城信息港','http://www.bc.jl.cn/',108,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(527,'吉林省经济信息网','http://www.jilin.cei.gov.cn/',108,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(528,'松原都市网','http://www.0438cn.com/',108,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(529,'吉林省电子地图','http://www.jl.cninfo.net/html/map/',109,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(530,'吉林气象','http://www.jlqx.gov.cn/',109,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(531,'长春交通信息','http://cczc.cc163.net/travel',109,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(532,'长春交通违章查询','http://www.ccjg.gov.cn/',109,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(533,'吉林移动','http://www.jl.chinamobile.com/',110,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(534,'吉林联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010012&id=3728',110,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(535,'吉林电信','http://jl.ct10000.com/',110,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(536,'吉林铁通','http://www.cttjl.com/',110,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(537,'吉林人才网','http://www.jlrc.com.cn/',111,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(538,'长春人才市场','http://www.ccrc.com.cn/',111,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(539,'搜房长春','http://changchun.soufun.com/',112,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(540,'长春住房公积金网','http://www.cczfgjj.gov.cn/',112,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(541,'长春房产网','http://www.ccfcw.com/',112,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(542,'吉林大学','http://www.jlu.edu.cn/',113,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(543,'东北师范大学','http://www.nenu.edu.cn/',113,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(544,'长春理工大学','http://www.cust.edu.cn/',113,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(545,'吉林公务员考试网','http://www.jlgwy.net/',113,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(546,'吉林农业大学','http://www.jlau.edu.cn/',113,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(547,'吉林帖吧','http://post.baidu.com/f?kw=吉林',114,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(548,'长春帖吧','http://post.baidu.com/f?kw=长春',114,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(549,'东北帖吧','http://post.baidu.com/f?kw=东北',114,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(550,'天涯社区吉林','http://cache.tianya.cn/new/TianyaCity/ArticlesList_Culture.asp?idWriter=0&Key=0&iditem=52',114,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(551,'吉林体彩','http://www.jltcw.net/',115,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(552,'吉林福彩','http://www.jilintz.com/SelfServiceStation/kjgg/kjgg1.jsp',115,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(553,'吉林省政府','http://www.jl.gov.cn/',116,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(554,'长春市政府','http://www.cc.jl.gov.cn/',116,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(555,'吉林省建设厅','http://jst.jl.gov.cn/',116,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(556,'吉林','http://www.jlcity.gov.cn/',116,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(557,'辽源','http://www.0437.gov.cn/',116,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(558,'通化','http://th.jl.gov.cn/',116,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(559,'松原','http://www.jlsy.gov.cn/',116,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(560,'吉林省卫生厅','http://www.jlws.gov.cn/',116,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(561,'吉林省商务厅','http://www.jldofcom.gov.cn/',116,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(562,'吉林省法院','http://courts.jl.gov.cn/',116,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(563,'中国延边','http://www.yanbian.gov.cn/',116,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(564,'牡丹江信息港','http://www.mdj.cn/',117,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(565,'哈尔滨信息港','http://www.96963.com/',117,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(566,'绥化信息港','http://sh.hlj.net/',117,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(567,'黑河信息港','http://www.hh.hl.cn/',117,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(568,'大庆信息港','http://www.daqing.net/',117,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(569,'大庆油田信息港','http://www.dqt.com.cn/',117,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(570,'东北网','http://www.dbw.cn/',117,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(571,'黑龙江农业信息网','http://www.hljagri.gov.cn/',117,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(572,'黑龙江信息港','http://www.hlj.net/',118,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(573,'东北网','http://www.northeast.cn/',118,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(574,'黑龙江新闻网','http://www.hljdaily.com.cn/',118,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(575,'哈尔滨电视台','http://www.hrbtv.net/',118,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(576,'黑龙江电视台','http://www.hljtv.com/',118,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(577,'龙广在线','http://www.hljradio.com/',118,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(578,'齐齐哈尔网民论坛','http://www.0452e.com/',119,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(579,'东北社区','http://forum.northeast.cn/',119,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(580,'龙广论坛','http://bbs.hljradio.com/',119,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(581,'哈尔滨贴吧','http://tieba.baidu.com/f?kw=哈尔滨',119,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(582,'东北贴吧','http://tieba.baidu.com/f?kw=东北',119,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(583,'黑龙江信息港房产','http://house.hlj.net/',120,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(584,'哈尔滨房产住宅局','http://www.hrbfdc.gov.cn/',120,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(585,'哈尔滨房产--搜房网','http://hrb.soufun.com/',120,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(586,'黑龙江就业网','http://www.hljjob.com/',121,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(587,'哈尔滨人才网','http://www.hrbrc.com/',121,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(588,'黑龙江人事编制网','http://www.hljrstbb.gov.cn/',121,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(589,'黑龙江交通','http://www.hljjt.gov.cn/',122,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(590,'黑龙江天气','http://www.hljnw.com/qxj',122,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(591,'哈尔滨公交网','http://haerbin.8684.cn/',122,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(592,'百度地图哈尔滨','http://map.baidu.com/#word=哈尔滨市&ct=10',122,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(593,'黑龙江移动','http://www.hl.chinamobile.com/',123,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(594,'黑龙江联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010013&id=3798',123,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(595,'黑龙江电信','http://hl.ct10000.com/',123,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(596,'黑龙江铁通','http://www.ctthlj.net/',123,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(597,'龙江风采','http://www.lottost.cn/',124,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(598,'黑龙江体彩网','http://www.hljtcp.com/',124,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(599,'黑龙江大学','http://www.hlju.edu.cn/',125,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(600,'黑龙江招生考试信息港','http://www.lzk.hl.cn/lzk/',125,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(601,'东北林业大学','http://www.nefu.edu.cn/',125,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(602,'哈尔滨工业大学','http://www.hit.edu.cn/',125,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(603,'哈尔滨工程大学','http://www.hrbeu.edu.cn/',125,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(604,'黑龙江教育在线','http://www.hljedu.com/',125,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(605,'黑龙江省政府','http://www.hlj.gov.cn/',126,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(606,'黑龙江省财政厅','http://www.hljczt.gov.cn/',126,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(607,'哈尔滨地税局','http://www.hrbtax.gov.cn/',126,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(608,'黑龙江地税局','http://www.hljtax.gov.cn/',126,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(609,'哈尔滨','http://www.harbin.gov.cn/',126,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(610,'齐齐哈尔','http://www.qqhr.gov.cn/',126,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(611,'黑龙江建设网','http://www.hljjs.gov.cn/',126,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(612,'佳木斯','http://www.jms.gov.cn/',126,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(613,'大庆','http://www.daqing.gov.cn/',126,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(614,'鸡西','http://www.jixi.gov.cn/',126,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(615,'黑河','http://www.heihe.gov.cn/',126,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(616,'双鸭山','http://www.shuangyashan.gov.cn/',126,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(617,'七台河','http://www.qth.gov.cn/',126,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(618,'鹤岗','http://www.hegang.gov.cn/',126,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(619,'国土资源厅','http://www.hljlr.gov.cn/',126,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(620,'黑龙江发展和改革委员会','http://www.hljdpc.gov.cn/',126,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(621,'黑龙江国税局','http://www.hl-n-tax.gov.cn/',126,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(622,'黑龙江工商','http://www.hljaic.gov.cn/',126,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(623,'哈尔滨旅游频道','http://tour.northeast.cn/',127,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(624,'黑龙江信息港旅游','http://tour.hlj.net/',127,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(625,'哈港旅游','http://travel.96963.com/',127,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(626,'黑龙江旅游局','http://www.hljtour.gov.cn/',127,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(627,'东北餐饮网','http://meal.northeast.cn/',127,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(628,'大众点评网哈尔滨','http://www.dianping.com/haerbin/food',127,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(629,'黑龙江餐饮网','http://www.hljcyw.com/',127,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(630,'东北健康网','http://health.northeast.cn/',128,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(631,'江苏音符','http://jsinfo.vnet.cn/',129,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(632,'中国江苏网','http://www.jschina.com.cn/',129,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(633,'扬子晚报','http://www.yangtse.com/',129,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(634,'南京报业网','http://www.njnews.cn/',129,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(635,'江苏省政府','http://www.jiangsu.gov.cn/',129,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(636,'南京龙虎网','http://www.longhoo.net/',129,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(637,'金陵晚报','http://jlwb.njnews.cn/',129,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(638,'新华日报','http://www.xhby.net/',129,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(639,'江苏新闻网','http://www.js.chinanews.com.cn/',129,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(640,'现代快报','http://www.kuaibao.net/',129,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(641,'中吴网','http://www.zhong5.cn/',129,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(642,'江苏广播电视网','http://www.jsbc.com/',129,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(643,'中国淮海网','http://www.huaihai.tv/',129,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(644,'江苏贴吧','http://tieba.baidu.com/f?kw=%BD%AD%CB%D5',130,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(645,'陶都论坛','http://bbs.yx.js.cn/',130,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(646,'南京贴吧','http://tieba.baidu.com/f?kw=%C4%CF%BE%A9',130,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(647,'苏州贴吧','http://tieba.baidu.com/f?kw=%CB%D5%D6%DD',130,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(648,'溧阳论坛','http://bbs.jsly01.com/',130,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(649,'涟水论坛','http://bbs.0517w.com/',130,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(650,'暨阳社区','http://bbs.jysq.net/',130,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(651,'连云港在海一方','http://bbs.lyg.jsinfo.net/forum/',130,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(652,'无锡新区家园','http://www.newuxi.com/',130,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(653,'无锡东林书院','http://bbs.thmz.com/index.php',130,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(654,'泰无聊','http://bbs.t56.net/',130,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(655,'丹阳翼网论坛','http://bbs.212300.com/',130,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(656,'化龙巷论坛','http://bbs.hualongxiang.com/',130,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(657,'新沂论坛','http://bbs.0516k.com/',130,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(658,'常熟零距离论坛','http://bbs.wm090.com/',130,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(659,'邳州论坛','http://www.pzzc.net/',130,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(660,'彭城社区','http://bbs.86516.com/',130,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(661,'金湖论坛','http://bbs.211600.com/',130,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(662,'仪征论坛','http://bbs.yizheng.gov.cn/',130,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(663,'东台人论坛','http://bbs.dt123.net/',130,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(664,'8080急速社区','http://bbs.8080.net/',130,21,0,0,0,0,0,'','','',0,0,0,0,'',0),(665,'姑苏生活论坛','http://bbs.512ms.com/',130,22,0,0,0,0,0,'','','',0,0,0,0,'',0),(666,'昆山bbs','http://www.kbcool.com/',130,23,0,0,0,0,0,'','','',0,0,0,0,'',0),(667,'宿迁论坛','http://bbs.sqee.cn/',130,24,0,0,0,0,0,'','','',0,0,0,0,'',0),(668,'昆山论坛','http://bbs.kshot.net/',130,25,0,0,0,0,0,'','','',0,0,0,0,'',0),(669,'中吴论坛','http://bbs.zhong5.cn/',130,26,0,0,0,0,0,'','','',0,0,0,0,'',0),(670,'濠滨论坛','http://bbs.0513.org/',130,27,0,0,0,0,0,'','','',0,0,0,0,'',0),(671,'52kd论坛','http://bbs.52kd.com/',130,28,0,0,0,0,0,'','','',0,0,0,0,'',0),(672,'张家港论坛','http://bbs.zjghot.com/',130,29,0,0,0,0,0,'','','',0,0,0,0,'',0),(673,'羌溪花园','http://www.hybbs.net/',130,30,0,0,0,0,0,'','','',0,0,0,0,'',0),(674,'山水金坛','http://www.3sjt.com/',130,31,0,0,0,0,0,'','','',0,0,0,0,'',0),(675,'鹤鸣亭','http://www.hmting.com/',130,32,0,0,0,0,0,'','','',0,0,0,0,'',0),(676,'南京金陵热线','http://www.jlonline.com/',131,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(677,'江苏都市网','http://www.dsqq.cn/',131,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(678,'无锡太湖明珠','http://www.thmz.com/',131,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(679,'名城苏州','http://www.2500sz.com/',131,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(680,'镇江网友之家','http://www.my0511.com/',131,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(681,'扬州网','http://www.yznews.com.cn/',131,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(682,'无锡阿福台','http://www.wuxi.cn/',131,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(683,'吴江信息港','http://www.wj.js.cn/',131,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(684,'苏州热线','http://www.sz.js.cn/',131,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(685,'扬州热线','http://jsyz.vnet.cn/',131,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(686,'张家港金港热线','http://www.zjg.js.cn/',131,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(687,'常州信息港','http://www.czinfo.net/',131,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(688,'无锡新传媒','http://www.wxrb.com/',131,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(689,'徐州彭城视窗','http://jsxz.vnet.cn/',131,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(690,'太仓视窗','http://www.tc.jsinfo.net/',131,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(691,'南通热线','http://www.ntonline.cn/',131,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(692,'连云港信息港','http://www.jslyg.vnet.cn/',131,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(693,'陶都热线','http://www.yx.js.cn/',131,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(694,'常州网','http://www.cz001.com.cn/',131,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(695,'常熟虞城热线','http://www.cs.js.cn/',131,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(696,'昆山视窗','http://www.ks.js.cn/',131,21,0,0,0,0,0,'','','',0,0,0,0,'',0),(697,'溧阳信息港','http://www.ly.js.cn/',131,22,0,0,0,0,0,'','','',0,0,0,0,'',0),(698,'无锡二泉网','http://www.wst.cn/',131,23,0,0,0,0,0,'','','',0,0,0,0,'',0),(699,'盐城热线','http://jsyc.vnet.cn/',131,24,0,0,0,0,0,'','','',0,0,0,0,'',0),(700,'南京火车站','http://www.njstation.com/',132,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(701,'南京公交','http://nj.ddmap.com/',132,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(702,'南京地铁','http://www.nj-dt.com/',132,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(703,'南京禄口机场','http://www.njiairport.com/',132,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(704,'南京交管在线','http://www.njjg.net/',132,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(705,'无锡3D地图','http://www.3dwuxi.com/',132,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(706,'江苏移动','http://www.js.chinamobile.com/',133,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(707,'江苏联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010008&id=2016',133,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(708,'江苏电信','http://js.ct10000.com/',133,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(709,'江苏省中医院','http://www.jshtcm.com/',134,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(710,'江苏省人民医院','http://www.jsph.net/',134,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(711,'南京儿童医院','http://www.njch.com.cn/',134,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(712,'南京鼓楼医院','http://www.njglyy.com/',134,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(713,'南京市妇幼保健院','http://www.njfybjy.com/',134,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(714,'南京大学','http://www.nju.edu.cn/',135,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(715,'东南大学','http://www.seu.edu.cn/',135,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(716,'江南大学','http://www.sytu.edu.cn/',135,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(717,'河海大学','http://www.hhu.edu.cn/',135,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(718,'中国矿业大学','http://www.cumt.edu.cn/',135,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(719,'淮海工学院','http://www.hhit.edu.cn/',135,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(720,'江苏科技大学','http://www.ecsi.edu.cn/',135,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(721,'南京林业大学','http://www.njfu.edu.cn/',135,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(722,'江苏省教育厅','http://www.ec.js.edu.cn/',135,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(723,'江苏省教育考试院','http://www.jszk.net.cn/',135,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(724,'盐城教育网','http://www.yce.cn/',135,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(725,'苏州自考网','http://www.szzxks.net/',135,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(726,'江苏招生考试网','http://www.js-edu.cn/',135,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(727,'江苏人事考试网','http://www.jsrsks.com.cn/',135,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(728,'江苏省政府','http://www.jiangsu.gov.cn/',136,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(729,'省卫生厅','http://www.jswst.gov.cn/',136,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(730,'江苏省公安厅','http://www.jsga.gov.cn/',136,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(731,'江苏省交通厅','http://www.jscd.gov.cn/',136,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(732,'苏州市国家税务局','http://www.jssz-n-tax.gov.cn/',136,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(733,'江苏省财政厅','http://www.jscz.gov.cn/',136,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(734,'江苏农业网','http://www.jsagri.gov.cn/',136,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(735,'宿迁','http://www.suqian.gov.cn/',136,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(736,'南京','http://www.nanjing.gov.cn/',136,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(737,'无锡','http://www.wuxi.gov.cn/',136,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(738,'徐州','http://www.xz.gov.cn/',136,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(739,'常州','http://www.changzhou.gov.cn/',136,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(740,'苏州','http://www.suzhou.gov.cn/',136,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(741,'南通','http://www.nantong.gov.cn/',136,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(742,'连云港','http://www.lyg.gov.cn/',136,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(743,'淮安','http://www.huaian.gov.cn/',136,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(744,'盐城','http://www.yancheng.gov.cn/',136,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(745,'扬州','http://www.yangzhou.gov.cn/',136,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(746,'镇江','http://www.zhenjiang.gov.cn/',136,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(747,'泰州','http://www.taizhou.gov.cn/',136,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(748,'张家港','http://www.zjg.gov.cn/',136,21,0,0,0,0,0,'','','',0,0,0,0,'',0),(749,'南京房产管理局','http://www.njfcj.gov.cn/',136,22,0,0,0,0,0,'','','',0,0,0,0,'',0),(750,'嵊州信息港','http://www.sz.zj.cn/',137,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(751,'上虞信息港','http://www.sy.net.cn/',137,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(752,'宁海热线','http://www.nhzj.com/',137,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(753,'新昌信息港','http://www.xc.zj.cn/',137,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(754,'温州热线','http://www.wz.zj.cn/',137,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(755,'台州信息港','http://www.tzinfo.net/',137,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(756,'浙北信息港','http://www.hz0572.com/',137,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(757,'嘉善在线','http://www.js0573.com/',137,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(758,'诸暨在线','http://www.zhuji.net/',137,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(759,'金华热线','http://www.0579.cn/',137,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(760,'丽水信息港','http://www.inlishui.com/',137,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(761,'绍兴E网','http://www.e0575.com/',137,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(762,'宁波东方热线','http://www.cnool.net/',137,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(763,'慈溪热线','http://www.zxip.com/',137,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(764,'绍兴信息港','http://www.sx.zj.cn/',137,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(765,'华数在线','http://www.hzcnc.com/',137,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(766,'义乌新闻网','http://www.ywnews.cn/',137,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(767,'金华新闻网','http://www.jhnews.com.cn/',137,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(768,'宁波网','http://www.cnnb.com.cn/',137,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(769,'温州网','http://www.66wz.com/',137,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(770,'湖州在线','http://www.hz66.com/',137,21,0,0,0,0,0,'','','',0,0,0,0,'',0),(771,'嘉兴在线','http://www.cnjxol.com/',137,22,0,0,0,0,0,'','','',0,0,0,0,'',0),(772,'北仑之窗','http://www.bl.gov.cn/',137,23,0,0,0,0,0,'','','',0,0,0,0,'',0),(773,'萧山网','http://www.xsnet.cn/',137,24,0,0,0,0,0,'','','',0,0,0,0,'',0),(774,'绍兴网','http://www.shaoxing.com.cn/',137,25,0,0,0,0,0,'','','',0,0,0,0,'',0),(775,'杭州下沙网','http://www.xiashanet.com/',137,26,0,0,0,0,0,'','','',0,0,0,0,'',0),(776,'舟山网','http://www.zhoushan.cn/',137,27,0,0,0,0,0,'','','',0,0,0,0,'',0),(777,'余姚生活网','http://www.eyuyao.com/',137,28,0,0,0,0,0,'','','',0,0,0,0,'',0),(778,'义乌热线','http://www.cnyw.net/',137,29,0,0,0,0,0,'','','',0,0,0,0,'',0),(779,'温州眼镜网','http://www.wenzhouglasses.com/',137,30,0,0,0,0,0,'','','',0,0,0,0,'',0),(780,'台州物流网','http://www.tz56.com/',137,31,0,0,0,0,0,'','','',0,0,0,0,'',0),(781,'浙江慈溪信息港','http://www.cxcnc.com/',137,32,0,0,0,0,0,'','','',0,0,0,0,'',0),(782,'温岭人网','http://www.wlren.net/',137,33,0,0,0,0,0,'','','',0,0,0,0,'',0),(783,'浙江在线','http://www.zjol.com.cn/',138,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(784,'杭州网','http://www.hangzhou.com.cn/',138,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(785,'浙江卫视','http://www.zjstv.com/',138,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(786,'浙江都市网','http://www.zj.com/',138,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(787,'钱江晚报','http://qjwb.zjol.com.cn/',138,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(788,'都市快报','http://dskb.hangzhou.com.cn/',138,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(789,'浙江日报','http://www.zjdaily.com.cn/',138,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(790,'19楼论坛','http://www.19lou.com/',139,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(791,'浙江在线论坛','http://bbs.zjol.com.cn/',139,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(792,'新金华论坛','http://bbs.jhnews.com.cn/',139,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(793,'嘉兴人论坛','http://www.0573ren.com/',139,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(794,'奉化论坛','http://bbsfh.cn/',139,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(795,'余姚论坛','http://www.0574bbs.com/',139,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(796,'天一论坛','http://bbs.cnnb.com.cn/',139,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(797,'南太湖论坛','http://bbs.nantaihu.com/',139,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(798,'台州论坛','http://bbs.taizhou.com/',139,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(799,'北干听风','http://bbs.xs163.net/',139,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(800,'东方热线论坛','http://forum.cnool.net/',139,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(801,'平湖在线','http://www.ph66.com/',139,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(802,'温州bbs','http://bbs.66wz.com/',139,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(803,'义乌天互论坛','http://www.yw.zj.cn/',139,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(804,'绍兴E网论坛','http://www.e0575.cn/',139,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(805,'703温州论坛','http://bbs.703804.com/',139,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(806,'义乌稠州论坛','http://bbs.cnyw.net/',139,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(807,'新北仑','http://bbs.cnnb.com/',139,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(808,'上虞论坛','http://www.0575bbs.com/',139,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(809,'桐乡论坛','http://www.18lou.net/',139,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(810,'瑞安论坛','http://bbs.ruian.com/',139,21,0,0,0,0,0,'','','',0,0,0,0,'',0),(811,'慈溪论坛','http://bbs.zxip.com/',139,22,0,0,0,0,0,'','','',0,0,0,0,'',0),(812,'千岛论坛','http://bbs.qiandao.net/',139,23,0,0,0,0,0,'','','',0,0,0,0,'',0),(813,'舟山论坛','http://bbs.zhoushan.cn/',139,24,0,0,0,0,0,'','','',0,0,0,0,'',0),(814,'海宁论坛','http://www.haining.com.cn/',139,25,0,0,0,0,0,'','','',0,0,0,0,'',0),(815,'乐清上班族','http://bbs.5iyq.com/',139,26,0,0,0,0,0,'','','',0,0,0,0,'',0),(816,'桐乡生活论坛','http://www.tx365life.com/',139,27,0,0,0,0,0,'','','',0,0,0,0,'',0),(817,'海盐论坛','http://www.hybbs.com/',139,28,0,0,0,0,0,'','','',0,0,0,0,'',0),(818,'宁海论坛','http://bbs.nhzj.com/',139,29,0,0,0,0,0,'','','',0,0,0,0,'',0),(819,'嘉善论坛','http://bbs.jsr.cc/',139,30,0,0,0,0,0,'','','',0,0,0,0,'',0),(820,'杭州市民卡','http://www.96225.com/',140,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(821,'宁波电子地图','http://www.86nb.com/',140,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(822,'杭州公交','http://www.hzbus.com.cn/',140,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(823,'查查吧','http://www.chachaba.com/',140,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(824,'浙江气象','http://www.zjmb.gov.cn/',140,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(825,'浙江移动','http://www.zj.chinamobile.com/',141,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(826,'浙江电信','http://zj.ct10000.com/',141,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(827,'浙江联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010007&id=1914',141,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(828,'浙江大学','http://www.zju.edu.cn/',142,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(829,'宁波大学','http://www.nbu.edu.cn/',142,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(830,'浙江师范大学','http://www.zjnu.edu.cn/',142,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(831,'浙江工业大学','http://www.zjut.edu.cn/',142,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(832,'浙江图书馆','http://www.zjlib.net.cn/',142,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(833,'义乌教育网','http://www.ywec.net/',142,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(834,'宁波考试网','http://www.nbks.net/',142,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(835,'浙江教育网','http://www.zjedu.org/',142,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(836,'成都家政网','http://www.cdjj.com/',142,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(837,'浙江省政府','http://www.zhejiang.gov.cn/',143,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(838,'浙江省卫生厅','http://www.zjwst.gov.cn/',143,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(839,'台州市','http://www.zjtz.gov.cn/',143,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(840,'舟山市','http://www.zhoushan.gov.cn/',143,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(841,'绍兴市','http://www.sx.gov.cn/',143,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(842,'衢州市','http://www.quzhou.gov.cn/',143,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(843,'丽水市','http://www.lishui.gov.cn/',143,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(844,'义乌市','http://www.yw.gov.cn/',143,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(845,'杭州市','http://www.hangzhou.gov.cn/',143,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(846,'宁波市','http://www.ningbo.gov.cn/',143,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(847,'温州市','http://www.wenzhou.gov.cn/',143,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(848,'湖州市','http://www.huzhou.gov.cn/',143,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(849,'嘉兴市','http://www.jiaxing.gov.cn/',143,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(850,'金华','http://www.jinhua.gov.cn/',143,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(851,'杭州人事局','http://www.hzsrsj.gov.cn/',143,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(852,'省发改委','http://www.zjdpc.gov.cn/',143,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(853,'省民政厅','http://www.zjmz.gov.cn/',143,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(854,'省劳动保障厅','http://www.zj.molss.gov.cn/jpm',143,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(855,'省国土资源厅','http://www.zjdlr.gov.cn/',143,21,0,0,0,0,0,'','','',0,0,0,0,'',0),(856,'省法制办','http://www.zjfzb.gov.cn/',143,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(857,'浙江省法院','http://www.zjcourt.cn/',143,22,0,0,0,0,0,'','','',0,0,0,0,'',0),(858,'浙江省公务员','http://gwy.zjrs.gov.cn/',143,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(859,'浙江人才网','http://www.zjrc.com/',144,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(860,'浙江人才在线','http://www.zjjol.com/',144,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(861,'杭州人才网','http://www.hzrc.com/',144,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(862,'浙江旅游网','http://www.tourzj.com/',145,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(863,'浙江旅游新网','http://gotrip.zjol.com.cn/',145,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(864,'浙江省旅游局','http://www.tourzj.gov.cn/',145,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(865,'浙江省人民医院','http://www.hospitalstar.com/',146,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(866,'浙江医院','http://www.zjhospital.com.cn/',146,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(867,'浙江福利彩票','http://fc.zjol.com.cn/',147,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(868,'安徽移动','http://www.ah.chinamobile.com/',148,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(869,'安徽联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010019&id=3077',148,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(870,'安徽电信','http://ah.ct10000.com/',148,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(871,'浙江联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010007&id=1914',148,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(872,'安徽人才网','http://www.ahhr.com.cn/',149,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(873,'新安人才网','http://www.goodjobs.cn/',149,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(874,'51job合肥','http://www.51job.com/default-area.php?area=1502',149,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(875,'安徽人事编制网','http://www.ahsrst.cn/ahrsbzw/',149,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(876,'合肥劳动保障局','http://www.ahhfld.gov.cn/',149,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(877,'合肥人事考试网','http://www.hfrc.net/',149,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(878,'安徽人事考试网','http://www.apta.gov.cn/',149,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(879,'安徽劳动保障网','http://www2.ahldt.gov.cn/',149,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(880,'合肥住房公积金','http://www.hfgjj.com/',150,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(881,'搜房合肥','http://hf.soufun.com/',150,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(882,'合肥房产管理局','http://www.hffd.gov.cn/',150,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(883,'合肥房地产交易网','http://www.hfhouse.com/',150,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(884,'合肥租房网','http://www.0551zf.net/',150,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(885,'合肥家园网','http://www.hfhome.cn/',150,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(886,'中安在线房产','http://house.anhuinews.com/',150,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(887,'安徽教育网','http://www.ahedu.gov.cn/',151,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(888,'合肥工业大学','http://www.hfut.edu.cn/',151,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(889,'中国科学技术大学','http://www.ustc.edu.cn/',151,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(890,'安徽大学','http://www.ahu.edu.cn/',151,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(891,'安徽师范大学','http://www.ahnu.edu.cn/',151,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(892,'安徽工业大学','http://www.ahut.edu.cn/',151,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(893,'安徽医科大学','http://www.ahmu.edu.cn/',151,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(894,'安徽招生考试网','http://www.ahzsks.cn/',151,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(895,'安徽省政府','http://www.ah.gov.cn/',152,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(896,'发展改革委员会','http://www.ahpc.gov.cn/',152,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(897,'安徽省工商局','http://www.ahaic.gov.cn/',152,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(898,'安徽省卫生厅','http://www.ahwst.gov.cn/',152,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(899,'合肥市政府','http://www.hefei.gov.cn/',152,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(900,'亳州','http://www.bozhou.gov.cn/',152,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(901,'阜阳','http://www.fy.gov.cn/',152,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(902,'宿州','http://www.ahsz.gov.cn/',152,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(903,'淮南','http://www.huainan.gov.cn/',152,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(904,'六安','http://www.luan.gov.cn/',152,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(905,'芜湖','http://www.wuhu.gov.cn/',152,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(906,'巢湖','http://www.chaohu.gov.cn/',152,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(907,'滁州','http://www.chuzhou.gov.cn/',152,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(908,'黄山','http://www.huangshan.gov.cn/',152,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(909,'宣城','http://www.xuancheng.gov.cn/',152,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(910,'铜陵','http://www.tl.gov.cn/',152,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(911,'池州','http://www.chizhou.gov.cn/',152,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(912,'马鞍山','http://www.mas.gov.cn/',152,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(913,'蚌埠','http://www.bengbu.gov.cn/',152,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(914,'安庆','http://www.anqing.gov.cn/',152,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(915,'淮北','http://www.huaibei.gov.cn/',152,21,0,0,0,0,0,'','','',0,0,0,0,'',0),(916,'安徽省国税局','http://www.ah-n-tax.gov.cn/',152,22,0,0,0,0,0,'','','',0,0,0,0,'',0),(917,'安徽省财政厅','http://www.ahcz.gov.cn/',152,23,0,0,0,0,0,'','','',0,0,0,0,'',0),(918,'安徽省法院','http://www.ahcourt.gov.cn/',152,24,0,0,0,0,0,'','','',0,0,0,0,'',0),(919,'安全生产监督管理局','http://www.hlsafety.gov.cn/',152,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(920,'安徽旅游资讯网','http://www.ahta.com.cn/',153,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(921,'中安在线旅游频道','http://travel.anhuinews.com/',153,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(922,'安徽省立医院','http://www.ahslyy.com.cn/',154,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(923,'安徽省立友谊医院','http://www.ahyyyy.com/',154,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(924,'合肥热线','http://www.anhuinews.com/',155,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(925,'江淮热线','http://hf.ah163.net/',155,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(926,'阜阳信息港','http://www.fy.ah163.net/',155,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(927,'黄山市民网','http://www.168hs.com/',155,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(928,'马鞍山信息港','http://www.mas.ah163.net/',155,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(929,'蚌埠人','http://www.bbr.cn/',155,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(930,'e滁州','http://www.echuzhou.cn/',155,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(931,'安庆信息港','http://www.aq.ah163.net/',155,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(932,'铜陵铜都时空','http://www.tl.ah163.net/',155,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(933,'宣城信息港','http://www.xc.ah163.net/',155,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(934,'芜湖信息港','http://www.wh.ah163.net/',155,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(935,'亳州信息港','http://www.bz.ah163.net/',155,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(936,'万家热线','http://www.365jia.cn/',155,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(937,'中安在线','http://www.ahrb.com.cn/',155,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(938,'中安在线','http://www.anhuinews.com/',156,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(939,'安徽电视台','http://www.ahtv.cn/',156,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(940,'安徽热线','http://www.ah163.net/',156,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(941,'合肥在线','http://www.hf365.com/',156,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(942,'新安晚报','http://xawb.cn/',156,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(943,'淮南新闻网','http://www.0554news.com/',156,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(944,'芜湖在线-巴巴网','http://www.wuhubaba.com/',156,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(945,'中安论坛','http://bbs.anhuinews.com/',157,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(946,'合肥论坛','http://bbs.hefei.cc/',157,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(947,'宿州论坛','http://bbs.my0557.cn/',157,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(948,'宣城论坛','http://www.xuancheng.org/',157,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(949,'颍上论坛','http://bbs.ahys.gov.cn/',157,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(950,'马鞍山OK论坛','http://www.masok.cn/',157,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(951,'安庆e网','http://www.aqlife.com/',157,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(952,'宁国论坛','http://www.ngbbs.cn/',157,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(953,'蚌埠论坛','http://www.ahbb.cc/',157,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(954,'阜阳论坛','http://www.fy22.com/',157,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(955,'广德论坛','http://bbs.gd163.cn/',157,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(956,'淮北人论坛','http://bbs.hb163.cn/',157,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(957,'查查论坛','http://bbs.0554cc.com/',157,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(958,'安庆牵手网','http://www.aqtogo.com/',157,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(959,'桐城市民论坛','http://bbs.tongcheng.gov.cn/',157,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(960,'六安人论坛','http://bbs.luanren.com/',157,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(961,'安徽福彩','http://www.ahfc.gov.cn/',158,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(962,'安徽体彩网','http://www.ahlottery.com/',158,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(963,'华安证券','http://www.hazq.com/',158,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(964,'安徽气象','http://www.ahqx.gov.cn/',159,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(965,'合肥交通违章查询','http://www.hfjjzd.gov.cn/',159,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(966,'合肥公交','http://www.hfbus.cn/',159,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(967,'安徽地图网','http://www.mapdoc.cn/',159,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(968,'安徽民航机场','http://www.ahjp.com.cn/',159,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(969,'合肥火车站','http://www.hfstation.com/',159,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(970,'福建热线','http://www.fjii.com/',160,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(971,'东南新闻网','http://www.fjsen.com/',160,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(972,'福建电视台','http://www.fjtv.net/',160,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(973,'泉州网','http://www.qzwb.com/',160,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(974,'台海网','http://www.taihainet.com/',160,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(975,'福建新闻网','http://www.fjcns.com/',160,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(976,'福州新闻网','http://www.fznews.com.cn/',160,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(977,'厦门网','http://www.xmnn.cn/',160,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(978,'福建都市生活网','http://www.fm987.com.cn/',160,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(979,'福建之窗','http://www.66163.com/',160,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(980,'海峡导报','http://epaper.taihainet.com/',160,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(981,'东南早报','http://www.dnzb.cn/',160,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(982,'厦门小鱼社区','http://www.xmfish.com/',161,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(983,'福州家园网','http://www.ihome99.com/',161,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(984,'福建论坛','http://bbs.66163.com/',161,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(985,'闽北互动论坛','http://bbs.np163.net/',161,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(986,'福州便民论坛','http://bbs.fzbm.com/',161,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(987,'厦门贴吧','http://tieba.baidu.com/f?kw=厦门',161,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(988,'福州贴吧','http://tieba.baidu.com/f?ct=&tn=&rn=&pn=&lm=&sc=&kw=福州',161,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(989,'龙岩论坛','http://www.0597kk.com/',161,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(990,'百度知道-福建','http://zhidao.baidu.com/browse/253',161,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(991,'莆田小鱼社区','http://ptfish.com/',161,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(992,'厦门小猪社区','http://www.xmpig.com/',161,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(993,'厦门e部落','http://www.ecl.com.cn/',161,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(994,'泉州社区','http://bbs.0595bbs.cn/',161,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(995,'泉州论坛','http://www.qzbbs.com/',161,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(996,'永安论坛','http://bbs.yawin.cn/',161,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(997,'漳州小鱼','http://www.zzfish.cn/index.php',161,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(998,'长乐论坛','http://www.changle.com.cn/',161,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(999,'福州便民网','http://www.fzbm.com/',161,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(1000,'看福清','http://www.fqlook.cn/',161,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(1001,'海峡人才网','http://www.hxrc.com/',162,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1002,'福州人才网','http://www.0591job.com/',162,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1003,'福建人事人才网','http://www.fjrs.gov.cn/',162,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1004,'厦门人才网','http://www.xmrc.com.cn/',162,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1005,'厦门房地产联合网','http://www.xmhouse.com/',163,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1006,'胜利家园','http://fz.v17go.com/',163,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1007,'福建气象','http://www.fjqx.gov.cn/',164,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1008,'福建地图','http://www.richmap.cn/richmap4/vip/fjii/index.jsp',164,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1009,'厦门公交查询','http://bus.mapbar.com/xiamen/',164,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1010,'厦门交警','http://www.xmjj.gov.cn/',164,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1011,'八闽交警','http://www.fjjj.gov.cn/',164,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1012,'福州交警','http://www.fzjj.net/',164,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1013,'福州火车站','http://www.fzhcz.com/',164,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1014,'厦门机场','http://www.xiagc.com.cn/',164,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1015,'福建移动','http://www.fj.chinamobile.com/',165,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1016,'福建电信','http://fj.ct10000.com/',165,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1017,'福建联通','http://info.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010006&id=1820',165,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1018,'湖北铁通','http://www.ctthb.com/',165,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1019,'福建福彩','http://www.fjcp.cn/',166,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1020,'福建体彩','http://www.fjtc.com.cn/',166,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1021,'东兴证券','http://www.dxzq.net/',166,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1022,'福建教育厅','http://www.fjedu.gov.cn/',167,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1023,'福建公务员考试网','http://www.fjkl.gov.cn/',167,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1024,'福建招生考试网','http://www.fjzsksw.com/',167,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1025,'福州大学','http://www.fzu.edu.cn/',167,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1026,'厦门大学','http://www.xmu.edu.cn/',167,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1027,'福建农林大学','http://www.fjau.edu.cn/',167,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1028,'福建自考网','http://www.fjzk.com.cn/',167,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1029,'福建省人事考试网','http://www.fjpta.com/',167,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1030,'福建师范大学','http://www.fjtu.edu.cn/',167,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1031,'福建省政府','http://www.fujian.gov.cn/',168,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1032,'厦门','http://www.xm.gov.cn/',168,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1033,'龙岩','http://www.longyan.gov.cn/',168,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1034,'莆田','http://www.putian.gov.cn/',168,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1035,'福建建设信息网','http://www.fjjs.gov.cn/',168,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1036,'计生委','http://jsw.fjgov.cn/',168,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1037,'发改委','http://www.fjdpc.gov.cn/',168,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1038,'工商局','http://www.fjaic.gov.cn/',168,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1039,'福建省台办','http://www.fjstb.gov.cn/',168,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1040,'物价局','http://www.fjjg.gov.cn/',168,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1041,'海洋渔业局','http://www.fjof.gov.cn/',168,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1042,'地税局','http://www.fj-l-tax.gov.cn/',168,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1043,'福建热线旅游','http://travel.fjii.fj.vnet.cn/',169,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1044,'福建风采','http://www.cwl-fj.com/',169,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(1045,'福建医疗保险管理中心','http://www.fjyb.com.cn/',170,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1046,'福建卫生信息网','http://www.fjphb.gov.cn/',170,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1047,'福建省立医院','http://www.fjsl.com.cn/',170,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1048,'福建第二人民医院','http://www.fjhospital.com/',170,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1049,'徳化网','http://www.dehua.net/',171,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1050,'长汀网','http://www.ctw.cn/',171,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1051,'莆田生活网','http://www.0594sh.com/',171,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1052,'闽南人在线音乐网','http://www.510173.com/',171,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1053,'晋江信息综合网','http://www.jjj8.cn/index.asp',171,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1054,'福清网','http://www.cnfq.com/',171,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1055,'江西福利彩票','http://jxfc.online.jx.cn/',172,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1056,'江西体彩','http://www.jxlottery.com/',172,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1057,'江西气象','http://www.weather.org.cn/',173,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1058,'江西交通信息网','http://www.jxjt.gov.cn/',173,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1059,'江西交警网','http://www.jxhld.gov.cn/',173,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1060,'江西机场','http://www.jxairport.com/',173,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1061,'南昌公交线路查询','http://nanchang.bus84.com/',173,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(1062,'江西车辆违章查询','http://www.114la.com/other/weizhang.htm',173,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(1063,'江西移动','http://www.jx.chinamobile.com/',174,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1064,'江西网络电视','http://www.jxgdw.com/jxgd/ntv/',174,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1065,'江西联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010022&id=1062',174,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1066,'江西电信网上营业厅','http://jx.ct10000.com/',174,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1067,'江西铁通','http://www.cttjx.com/',174,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1068,'江西劳动保障网','http://www.jxldbz.gov.cn/',175,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1069,'江西人事人才网','http://www.jxrencai.com/',175,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1070,'江西人事考试网','http://www.jxpta.com/',175,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1071,'江西省人事厅','http://www.jxrenshi.gov.cn/',175,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1072,'江西人才热线','http://www.rcnc.net/',175,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1073,'新华网江西频道','http://www.jx.xinhuanet.com/',176,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1074,'大众点评网南昌','http://www.dianping.com/nanchang/food',176,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1075,'江西省人民医院','http://www.jxph.com/',177,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1076,'大江网健康频道','http://health.jxnews.com.cn/',177,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1077,'南昌卫生信息网','http://www.ncws.gov.cn/',177,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1078,'江西红十字会','http://www.jxredcross.org.cn/',177,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1079,'南昌手机报价网','http://www.nc138.com/',178,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1080,'南昌搜房网','http://nc.soufun.com/',179,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1081,'南昌住房公积金网','http://www.ncgjj.com.cn/',179,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1082,'南昌房产管理局','http://www.ncfdc.com.cn/',179,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1083,'江西搜房','http://www.jxsoufun.com/',179,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1084,'江西房产交易网','http://www.jtzhiye.com/',179,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1085,'江西房地产信息网','http://www.jxhouse.com/',179,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1086,'南昌房产网','http://www.ncfcw.com/',179,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1087,'江西热线','http://www.jx163.com/',180,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1088,'大江网','http://www.jxnews.com.cn/',180,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1089,'中国江西','http://www.jxcn.cn/',180,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1090,'今视网','http://www.jxgdw.com/',180,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1091,'江南都市报','http://www.jxnews.com.cn/jndsb/',180,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1092,'新余信息港','http://jxxy.vnet.cn/',180,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1093,'南昌新闻网','http://www.ncnews.com.cn/',180,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1094,'江西人民广播电台','http://www.jxgdw.com/jxgd/jxgbdt/',180,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1095,'江西省政府','http://www.jiangxi.gov.cn/',180,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1096,'鹰潭信息港','http://jxyt.vnet.cn/',180,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1097,'吉安信息港','http://www.ja.jx.cn/',180,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1098,'上饶之窗','http://www.srzc.com/',180,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1099,'九江新闻网','http://www.jjxw.cn/',180,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1100,'九江信息港','http://jxjj.vnet.cn/',180,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1101,'上饶热线','http://www.sr.jx.cn/',180,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1102,'抚州热线','http://www.fzline.cn/',180,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1103,'宜春信息港','http://www.yc.jx.cn/',180,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(1104,'南昌地宝网','http://www.tiboo.cn/',180,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(1105,'瓷都信息港','http://www.jdz.jx.cn/',180,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(1106,'赣州信息港','http://www.gz.jx.cn/',180,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(1107,'江西新农村网','http://3n.jxnews.com.cn/',180,21,0,0,0,0,0,'','','',0,0,0,0,'',0),(1108,'庐山','http://www.china-lushan.com/',180,22,0,0,0,0,0,'','','',0,0,0,0,'',0),(1109,'中瓷网','http://www.chinaciqi.com/',180,23,0,0,0,0,0,'','','',0,0,0,0,'',0),(1110,'江西信息港','http://www.hijiangxi.com/',180,24,0,0,0,0,0,'','','',0,0,0,0,'',0),(1111,'江西旅游','http://www.jxta.gov.cn/',181,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1112,'婺源旅游局','http://www.wylyw.cn/',181,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1113,'圈圈网','http://www.0791quanquan.com/',181,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1114,'南昌餐饮网','http://www.nccyw.com/',181,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1115,'江西省教育厅','http://www.jxedu.gov.cn/',182,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1116,'江西会计网','http://acc.jxf.gov.cn/',182,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1117,'江西理工大学','http://www.jxust.cn/',182,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1118,'江西自考网','http://www.jxzk.com.cn/',182,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1119,'南昌大学','http://www.ncu.edu.cn/',182,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1120,'江西师范大学','http://www.jxnu.edu.cn/',182,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1121,'江西财经大学','http://www.jxufe.edu.cn/',182,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1122,'江西农业大学','http://www.jxau.edu.cn/',182,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1123,'华东交通大学','http://www.ecjtu.jx.cn/',182,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1124,'南昌理工学院','http://www.nclg.com.cn/',182,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1125,'南昌航空大学','http://www.nchu.jx.cn/',182,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1126,'小刀论坛','http://bbs.ncdiy.com/',183,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1127,'江西论坛','http://bbs.jxcn.cn/',183,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1128,'江西贴吧','http://post.baidu.com/f?kw=%BD%AD%CE%F7',183,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1129,'大江论坛','http://bbs.jxnews.com.cn/',183,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1130,'犹江社区','http://bbs.shangyou.cn/',183,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1131,'九江论坛','http://bbs.jjxw.cn/',183,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1132,'今视论坛','http://bbs.jxgdw.com/',183,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1133,'江西IT堂','http://www.ittang.com/',183,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1134,'江西省政府','http://www.jiangxi.gov.cn/',184,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1135,'发改委','http://www.jxdpc.gov.cn/',184,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1136,'江西省公安厅','http://www.jxga.gov.cn/',184,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1137,'农业厅','http://www.jxagri.gov.cn/',184,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1138,'江西省财政厅','http://www.jxf.gov.cn/',184,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1139,'景德镇','http://www.jdz.gov.cn/',184,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1140,'南昌','http://www.nc.gov.cn/',184,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1141,'宜春','http://www.yichun.gov.cn/',184,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1142,'江西省卫生厅','http://www.jxwst.gov.cn/',184,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1143,'九江','http://www.jiujiang.gov.cn/',184,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1144,'江西省经贸委','http://www.jxetc.gov.cn/',184,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1145,'江西省国税局','http://www.jx-n-tax.gov.cn/',184,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1146,'江西省地税局','http://www.jxds.gov.cn/',184,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1147,'江西省工商局','http://www.jxaic.gov.cn/',184,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1148,'江西省计生委','http://www.jxjsw.gov.cn/',184,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1149,'江西妇联','http://www.jxwomen.org.cn/',184,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(1150,'山东人才网','http://www.sdrc.com.cn/',185,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1151,'山东人事信息网','http://www.sdrs.gov.cn/',185,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1152,'中华英才网-济南','http://www.chinahr.com/jinan',185,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1153,'51job济南站','http://www.51job.com/default-area.php?area=1202',185,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1154,'山东招生网','http://www.sdzsw.net/',185,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1155,'山东医药价格网','http://www.sdyyjg.gov.cn/',186,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1156,'山东大学齐鲁医院','http://www.qiluhospital.com/',186,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1157,'山东彩票网','http://www.sdcp.com.cn/',187,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1158,'山东体彩网','http://www.sdticai.com/',187,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1159,'济南信息港','http://www.jn.sd.cn/',188,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1160,'鲁中网','http://www.lznews.cn/',188,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1161,'烟台水母网','http://www.shm.com.cn/',188,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1162,'半岛网','http://www.bandao.cn/',188,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1163,'青岛信息港','http://www.qd.sd.cn/',188,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1164,'烟台热线','http://www.ytcnc.net/',188,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1165,'威海信息港','http://www.whinfo.net.cn/',188,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1166,'日照信息港','http://rzinfo.net/',188,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1167,'潍坊信息港','http://www.wfinfo.cn/',188,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1168,'中华泰山网','http://www.my0538.com/',188,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1169,'淄博信息港','http://www.zbinfo.net/',188,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1170,'临沂信息港','http://www.ly169.cn/',188,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1171,'诸城信息港','http://www.zcinfo.net/',188,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1172,'鲁北热线','http://www.dzcnc.com/',188,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1173,'泰安信息港','http://www.tainfo.net/',188,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1174,'菏泽信息港','http://www.heze.cc/',188,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1175,'莱芜信息港','http://www.lwinfo.com/',188,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(1176,'莱西信息港','http://www.laixi.com/',188,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(1177,'东营信息港','http://www.dongying.com.cn/',188,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(1178,'聊城信息港','http://www.lcinfo.cn/',188,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(1179,'胶东在线','http://www.jiaodong.net/',188,21,0,0,0,0,0,'','','',0,0,0,0,'',0),(1180,'日照百事通','http://www.rz168.com/',188,22,0,0,0,0,0,'','','',0,0,0,0,'',0),(1181,'枣庄信息港','http://www.zaozhuang.com.cn/',188,23,0,0,0,0,0,'','','',0,0,0,0,'',0),(1182,'临沂在线','http://www.lywww.com/',188,24,0,0,0,0,0,'','','',0,0,0,0,'',0),(1183,'胶南信息港','http://www.jiaonan.net/',188,25,0,0,0,0,0,'','','',0,0,0,0,'',0),(1184,'黄岛信息港','http://www.hdxxg.com/',188,26,0,0,0,0,0,'','','',0,0,0,0,'',0),(1185,'临朐信息港','http://www.lqinfo.net.cn/',188,27,0,0,0,0,0,'','','',0,0,0,0,'',0),(1186,'蓬莱信息港','http://www.penglai.com.cn/',188,28,0,0,0,0,0,'','','',0,0,0,0,'',0),(1187,'滕州信息港','http://www.tengzhou.com.cn/',188,29,0,0,0,0,0,'','','',0,0,0,0,'',0),(1188,'胶南信息网','http://www.jiaonan.tv/',188,30,0,0,0,0,0,'','','',0,0,0,0,'',0),(1189,'章丘信息港','http://www.zqxxg.cn/',188,31,0,0,0,0,0,'','','',0,0,0,0,'',0),(1190,'莱芜在线','http://www.laiwu.net/',188,32,0,0,0,0,0,'','','',0,0,0,0,'',0),(1191,'滨州信息港','http://www.bz169.com/',188,33,0,0,0,0,0,'','','',0,0,0,0,'',0),(1192,'即墨信息港','http://www.qdjimo.com/',188,34,0,0,0,0,0,'','','',0,0,0,0,'',0),(1193,'潍坊新闻网','http://www.wfnews.com.cn/',188,35,0,0,0,0,0,'','','',0,0,0,0,'',0),(1194,'青岛开发区信息港','http://www.qingkai.com/',188,36,0,0,0,0,0,'','','',0,0,0,0,'',0),(1195,'曲阜123','http://www.qufu123.com/',188,37,0,0,0,0,0,'','','',0,0,0,0,'',0),(1196,'济宁信息港','http://ji-www.sd.cninfo.net/',188,38,0,0,0,0,0,'','','',0,0,0,0,'',0),(1197,'山东省省情资料库','http://www.infobase.gov.cn/',188,39,0,0,0,0,0,'','','',0,0,0,0,'',0),(1198,'山东邮政在线','http://www.sdpost.com.cn/',188,40,0,0,0,0,0,'','','',0,0,0,0,'',0),(1199,'齐鲁热线','http://www.sdinfo.net/',189,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1200,'大众网','http://www.dzwww.com/',189,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1201,'齐鲁晚报','http://www.qlwb.com.cn/',189,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1202,'青岛新闻网','http://www.qingdaonews.com/',189,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1203,'百灵网','http://www.beelink.com/',189,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1204,'山东新闻网','http://www.sdnews.com.cn/',189,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1205,'淄博新闻网','http://www.zbnews.net/',189,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1206,'日照新闻网','http://www.rznews.cn/',189,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1207,'舜网','http://www.e23.cn/',189,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1208,'威海新闻网','http://www.whnews.cn/',189,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1209,'济宁新闻网','http://www.jn001.com/',189,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1210,'新华网山东频道','http://www.sd.xinhuanet.com/',189,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1211,'泰安论坛','http://bbs.0538.com.cn/',190,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1212,'淄博旮旯社区','http://bbs.zbgl.net/',190,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1213,'烟台开发区论坛','http://www.264006.com/',190,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1214,'青青岛社区','http://club.qingdaonews.com/',190,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1215,'大众论坛','http://bbs.dzwww.com/',190,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1216,'胶东社区','http://bbs.jiaodong.net/',190,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1217,'山东贴吧','http://tieba.baidu.com/f?kw=%C9%BD%B6%AB',190,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1218,'济南贴吧','http://tieba.baidu.com/f?kw=%BC%C3%C4%CF',190,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1219,'青岛贴吧','http://tieba.baidu.com/f?kw=%C7%E0%B5%BA',190,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1220,'烟台论坛','http://www.ytbbs.com/',190,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1221,'巨野论坛','http://www.juyebbs.com/bbs/',190,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1222,'百灵社区','http://club.beelink.com/',190,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1223,'舜网论坛','http://bbs.e23.cn/',190,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1224,'无为论坛','http://www.actcn.net/',190,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1225,'爱威海社区','http://www.iweihai.cn/club/',190,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1226,'开心论坛','http://bbs.sgnet.cc/',190,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1227,'人民网-山东视窗','http://sd.people.com.cn/',190,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(1228,'搜狐山东社区','http://club.travel.sohu.com/list_art_sub.php?b=shandong',190,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(1229,'天涯社区-山东','http://www.tianya.cn/new/TianyaCity/ArticlesList_Culture.asp?idWriter=0&Key=0&idItem=42',190,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(1230,'齐鲁论坛','http://www.qilubbs.com/',190,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(1231,'济南公交','http://www.jnbus.com.cn/',191,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1232,'济南铁路局','http://www.jtkyw.com/',191,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1233,'三维济南','http://map.qlcity.com/',191,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1234,'青岛机场','http://www.qdairport.com/',191,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1235,'山东航空集团','http://www.shandongair.com.cn/',191,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1236,'济南长途汽车站','http://www.jnqczz.com.cn/',191,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1237,'山东气象','http://www.sdqx.gov.cn/',191,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1238,'列车时刻查询','http://hcp.kooxoo.com/oem/114La/search.php',191,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1239,'山东移动','http://www.sd.chinamobile.com/',192,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1240,'山东联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010016&id=2651',192,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1241,'宽带中国','http://www.bdchina.com/',192,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1242,'山东电信','http://www.sdtele.com/',192,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1243,'山东铁通','http://www.cttsd.com/',192,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(1244,'搜房网-济南','http://jn.soufun.com/',193,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1245,'搜房网-青岛','http://qd.soufun.com/',193,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1246,'济南房产管理局','http://www.jnfg.gov.cn/',193,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1247,'济南住房公积金网','http://www.gjj.gov.cn/',193,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1248,'青岛房产在线','http://www.house.sd.cn/',193,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1249,'齐鲁热线房产','http://sdfdc.sdinfo.net/',193,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1250,'济南房产网','http://www.jnhouse.com/',193,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1251,'山东旅游超市','http://tour.dzwww.com/',194,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1252,'山东旅游网','http://www.sdta.cn/',194,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1253,'泰山信息网','http://www.mount-tai.com.cn/',194,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1254,'大众点评网(美食)','http://www.dianping.com/jinan',194,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1255,'青岛旅游政务网','http://www.qdta.gov.cn/',194,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1256,'泰安美食网','http://www.tamsw.com/',194,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1257,'山东大学','http://www.sdu.edu.cn/',195,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1258,'山东理工大学','http://www.sdut.edu.cn/',195,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1259,'中国海洋大学','http://www.ouc.edu.cn/',195,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1260,'青岛大学','http://www.qdu.edu.cn/',195,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1261,'山东省教育厅','http://www.sdedu.gov.cn/',195,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1262,'山东招生信息网','http://www.sdzs.gov.cn/',195,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1263,'山东省实验中学','http://www.sdshiyan.sd.cn/',195,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1264,'济南自考网','http://www.jnzk.net/',195,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1265,'济宁教育网','http://www.jnjyw.edu.cn/',195,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1266,'山东公务员网','http://www.sdgwy.org/',195,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1267,'山东专升本考试网','http://www.51ben.cn/',195,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1268,'山东自考网','http://www.sdzkw.com/',195,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1269,'烟台人事考试网','http://www.ytrsks.gov.cn/',195,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1270,'山东省政府','http://www.sd.gov.cn/',196,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1271,'济南建设网','http://www.jncc.gov.cn/',196,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1272,'胶南政务网','http://www.jiaonan.gov.cn/',196,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1273,'山东食品药品管理局','http://www.sdfda.gov.cn/',196,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1274,'济南市政府','http://www.jinan.gov.cn/',196,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1275,'青岛政务网','http://www.qingdao.gov.cn/',196,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1276,'枣庄','http://www.zaozhuang.gov.cn/',196,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1277,'东营','http://www.dongying.gov.cn/',196,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1278,'烟台','http://www.yantai.gov.cn/',196,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1279,'潍坊','http://www.weifang.gov.cn/',196,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1280,'济宁','http://www.jining.gov.cn/',196,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1281,'泰安','http://www.taian.gov.cn/',196,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1282,'威海','http://www.weihai.gov.cn/',196,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1283,'日照','http://www.rizhao.gov.cn/',196,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1284,'莱芜','http://www.laiwu.gov.cn/',196,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1285,'临沂','http://www.linyi.gov.cn/',196,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1286,'德州','http://www.dezhou.gov.cn/',196,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(1287,'聊城','http://www.liaocheng.gov.cn/',196,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(1288,'滨州','http://www.binzhou.gov.cn/',196,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(1289,'菏泽','http://www.heze.gov.cn/',196,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(1290,'山东省卫生厅','http://www.sdws.gov.cn/',196,21,0,0,0,0,0,'','','',0,0,0,0,'',0),(1291,'滕州','http://www.tengzhou.gov.cn/',196,22,0,0,0,0,0,'','','',0,0,0,0,'',0),(1292,'山东省交通厅','http://www.sdjt.gov.cn/',196,23,0,0,0,0,0,'','','',0,0,0,0,'',0),(1293,'山东省地方税务局','http://www.sdds.gov.cn/',196,24,0,0,0,0,0,'','','',0,0,0,0,'',0),(1294,'曲阜','http://www.qufu.gov.cn/',196,25,0,0,0,0,0,'','','',0,0,0,0,'',0),(1295,'济南公安服务在线','http://www.jnga.gov.cn/',196,26,0,0,0,0,0,'','','',0,0,0,0,'',0),(1296,'山东省国家税务局','http://www.sd-n-tax.gov.cn/',196,27,0,0,0,0,0,'','','',0,0,0,0,'',0),(1297,'清远','http://www.gdqy.gov.cn/',196,28,0,0,0,0,0,'','','',0,0,0,0,'',0),(1298,'济南交警网','http://www.jnjj.com/',196,29,0,0,0,0,0,'','','',0,0,0,0,'',0),(1299,'山东省发展改革委员会','http://www.sdjw.gov.cn/',196,30,0,0,0,0,0,'','','',0,0,0,0,'',0),(1300,'商都网','http://www.shangdu.com/',197,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1301,'大河网','http://www.dahe.cn/',197,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1302,'郑州人民广播电台','http://www.zzradio.cn/',197,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1303,'东方今报','http://www.jinbw.com.cn/',197,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1304,'中国新闻网河南','http://news.henannews.com.cn/',197,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1305,'中原网','http://www.zynews.com/',197,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1306,'河南电视台','http://www.hntv.ha.cn/',197,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1307,'河南广播网','http://www.radiohenan.com/',197,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1308,'商都BBS','http://bbs.shangdu.com/',198,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1309,'大河论坛','http://bbs.dahe.cn/',198,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1310,'安阳论坛','http://www.aylt.cn/',198,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1311,'济源论坛','http://www.jy391.com/',198,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1312,'许昌春秋论坛','http://bbs.0374.net.cn/',198,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1313,'宋韵论坛','http://bbs.kfsy.cn/',198,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1314,'洛阳bbs','http://bbs.ly.ha.cn/',198,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1315,'山阳论坛','http://bbs.jztele.com/',198,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1316,'龙都论坛','http://bbs.zhld.com/',198,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1317,'安阳信息港','http://www.ayinfo.ha.cn/',199,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1318,'济源信息港','http://www.jyinfo.ha.cn/',199,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1319,'洛阳信息港','http://www.lyinfo.ha.cn/',199,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1320,'三门峡信息港','http://smx.shangdu.com/',199,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1321,'中华龙都网','http://www.zhld.com/',199,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1322,'南阳信息港','http://www.nyinfo.ha.cn/',199,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1323,'南阳新闻网','http://www.nydaily.com.cn/',199,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1324,'信阳信息港','http://xy.shangdu.com/',199,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1325,'中原油田信息港','http://www.zytx.com.cn/',199,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1326,'鹤壁信息港','http://hb.shangdu.com/',199,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1327,'新乡信息港','http://xx.shangdu.com/',199,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1328,'焦作信息港','http://www.jzinfo.ha.cn/',199,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1329,'濮阳信息港','http://www.pyinfo.ha.cn/',199,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1330,'许昌信息港','http://www.xcinfo.ha.cn/',199,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1331,'漯河信息港','http://www.lhinfo.ha.cn/',199,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1332,'河南移动','http://www.ha.chinamobile.com/',200,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1333,'河南联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010023&id=1173',200,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1334,'河南电信','http://ha.ct10000.com/',200,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1335,'商都房产网','http://house.shangdu.com/',202,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1336,'郑州搜房','http://zz.soufun.com/',202,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1337,'郑州住房公积金网','http://www.zzgjj.com/',202,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1338,'河南户外联盟','http://bbs.hnhw.com/',203,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1339,'河南旅游资讯网','http://www.hnta.cn/',203,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1340,'少林寺','http://www.shaolin.org.cn/',203,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1341,'河南博物院','http://www.chnmus.net/',203,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1342,'河南省教育厅','http://www.hadoe.gov.cn/',204,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1343,'河南教育网','http://www.haedu.cn/',204,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1344,'河南大学','http://www.henu.edu.cn/',204,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1345,'河南招生信息网','http://www.heao.com.cn/',204,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1346,'河南人事考试网','http://www.hnrsks.com/',204,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1347,'郑州大学','http://www.zzu.edu.cn/',204,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1348,'河南省政府','http://www.henan.gov.cn/',205,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1349,'河南省财政厅','http://www.hncz.gov.cn/',205,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1350,'河南省人事厅','http://www.hnrs.gov.cn/',205,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1351,'河南省卫生厅','http://www.hnwst.gov.cn/',205,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1352,'河南法院网','http://hnfy.chinacourt.org/',205,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1353,'河南省政府采购网','http://www.hngp.gov.cn/',205,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1354,'郑州','http://www.zhengzhou.gov.cn/',205,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1355,'洛阳','http://www.ly.gov.cn/',205,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1356,'焦作','http://www.jiaozuo.gov.cn/',205,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1357,'开封','http://www.kaifeng.gov.cn/',205,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1358,'平顶山','http://www.pds.gov.cn/',205,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1359,'新乡','http://www.xinxiang.gov.cn/',205,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1360,'濮阳','http://www.puyang.gov.cn/',205,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1361,'许昌','http://www.xuchang.gov.cn/',205,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1362,'漯河','http://www.luohe.gov.cn/',205,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1363,'三门峡','http://www.smx.gov.cn/',205,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1364,'南阳','http://www.nanyang.gov.cn/',205,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(1365,'商丘','http://www.shangqiu.gov.cn/',205,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(1366,'信阳','http://www.xinyang.gov.cn/',205,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(1367,'周口','http://www.zhoukou.gov.cn/',205,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(1368,'济源','http://www.jiyuan.gov.cn/',205,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(1369,'赤壁热线','http://www.cbrx.com/',206,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1370,'荆州热线','http://www.jzinfo.com/',206,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1371,'孝感热线','http://www.xginfo.com/',206,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1372,'仙桃热线','http://xt.hb.vnet.cn/',206,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1373,'东风热线','http://www.dfminfo.com.cn/',206,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1374,'车城热线','http://www.checheng.net/',206,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1375,'襄樊热线','http://www.xfol.com/',206,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1376,'荆门信息港','http://www.jminfo.net/',206,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1377,'三峡热线','http://www.sanxia.net.cn/',206,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1378,'江汉热线','http://www.jhrx.cn/',206,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1379,'黄石信息港','http://www.435000.com/',206,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1380,'武汉网','http://www.whw.cc/',206,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1381,'武汉热线','http://www.wuhan.net.cn/',207,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1382,'荆楚网','http://cnhubei.com/',207,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1383,'汉网(长江日报)','http://www.cnhan.com/',207,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1384,'腾讯大楚网','http://hb.qq.com/',207,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1385,'十堰秦楚网','http://www.10yan.com/',207,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1386,'楚天都市报','http://ctdsb.cnhubei.com/',207,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1387,'湖北日报','http://hbrb.cnhubei.com/',207,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1388,'黄石声屏网','http://www.hsgd.net.cn/',207,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1389,'孝感网','http://www.xgrb.cn/',207,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1390,'武汉晚报','http://www.cnhan.com/gb/special/node_928.htm',207,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1391,'湖北新闻网','http://www.hb.chinanews.com.cn/',207,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1392,'中国三峡传媒网','http://www.cn3x.com.cn/',207,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1393,'火凤网','http://www.hbtv.com.cn/',207,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1394,'长江网','http://www.cjn.cn/',207,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1395,'恩施新闻网','http://www.enshi.cn/',207,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1396,'应城网','http://www.yingchengnet.com/',207,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1397,'新华网湖北频道','http://www.hb.xinhuanet.com/',207,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(1398,'汉风社区','http://club.wuhan.net.cn/',208,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1399,'汉网论坛','http://bbs.cnhan.com/',208,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1400,'湖北贴吧','http://tieba.baidu.com/f?kw=%BA%FE%B1%B1',208,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1401,'武汉贴吧','http://tieba.baidu.com/f?kw=%CE%E4%BA%BA',208,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1402,'潜江人论坛','http://www.qjren.com/',208,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1403,'枣阳论坛','http://bbs.zaoyang.org/',208,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1404,'荆门社区','http://www.jmbbs.com/',208,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1405,'大武汉论坛','http://www.dawuhan.com/bbs/',208,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1406,'东湖社区','http://bbs.cnhubei.com/',208,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1407,'日光海岸','http://bbs.sunpp.com/',208,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1408,'三峡论坛','http://bbs.sanxia.net.cn/',208,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1409,'谷城社区','http://bbs.xiangfan.org/',208,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1410,'钟祥论坛','http://bbs.zxwindow.com/',208,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1411,'随州论坛','http://www.szbbs.org/',208,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1412,'恩施论坛','http://bbs.enshi.cn/',208,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1413,'广水论坛','http://bbs.zggs.gov.cn/',208,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1414,'随州网','http://www.suizhoushi.com/',208,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(1415,'得意生活','http://www.deyi.com/',208,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(1416,'天涯社区湖北','http://cache.tianya.cn/new/TianyaCity/ArticlesList_Culture.asp?idWriter=0&Key=0&iditem=46',208,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(1417,'荆天论坛','http://bbs.jz135.com/',208,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(1418,'大众点评网','http://www.dianping.com/wuhan',209,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1419,'亿房','http://www.fdc.com.cn/',210,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1420,'湖北住宅与房产信息网','http://www.hbfdcw.com/',210,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1421,'搜房-武汉网','http://wuhan.soufun.com/',210,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1422,'武汉热线房产','http://fdc.wuhan.net.cn/',210,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1423,'汉口火车站','http://www.hankou.cn/',211,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1424,'湖北道路交通安全网','http://www.hb122.org/',211,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1425,'湖北移动','http://www.hb.chinamobile.com/',212,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1426,'湖北联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010024&id=1349',212,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1427,'互联星空湖北','http://hb.vnet.cn/',212,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1428,'湖北电信','http://www.hbtelecom.com.cn/',212,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1429,'湖北省政府','http://www.hubei.gov.cn/',213,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1430,'湖北省发改委','http://www.hbjw.gov.cn/',213,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1431,'湖北人事网','http://www.hbrs.gov.cn/',213,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1432,'湖北省国税局','http://www.hb-n-tax.gov.cn/',213,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1433,'湖北省工商局','http://www.egs.gov.cn/',213,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1434,'湖北政府采购网','http://www.ccgp-hubei.gov.cn/',213,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1435,'湖北省交通厅','http://www.hbjt.gov.cn/',213,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1436,'湖北省财政厅','http://www.ecz.gov.cn/',213,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1437,'湖北省公安厅','http://www.hbgat.gov.cn/',213,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1438,'湖北省建设厅','http://www.hbsjst.gov.cn/',213,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1439,'黄冈','http://www.hg.gov.cn/',213,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1440,'宜昌','http://www.yichang.gov.cn/',213,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1441,'荆州','http://www.jingzhou.gov.cn/',213,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1442,'仙桃','http://www.xiantao.gov.cn/',213,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1443,'襄樊','http://www.xf.gov.cn/',213,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1444,'当阳','http://www.hbdangyang.com/',213,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1445,'恩施','http://www.enshi.gov.cn/',213,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(1446,'老河口','http://www.laohekou.com.cn/',213,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(1447,'宜都','http://www.hbyidu.com/',213,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(1448,'十堰','http://www.shiyan.gov.cn/',213,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(1449,'鄂州','http://www.ezhou.gov.cn/',213,21,0,0,0,0,0,'','','',0,0,0,0,'',0),(1450,'广水','http://www.zggs.gov.cn/',213,22,0,0,0,0,0,'','','',0,0,0,0,'',0),(1451,'赤壁','http://www.chibi.com.cn/',213,23,0,0,0,0,0,'','','',0,0,0,0,'',0),(1452,'荆门','http://www.jingmen.gov.cn/',213,24,0,0,0,0,0,'','','',0,0,0,0,'',0),(1453,'巴东','http://www.cjbd.com.cn/',213,25,0,0,0,0,0,'','','',0,0,0,0,'',0),(1454,'黄石','http://www.huangshi.gov.cn/',213,26,0,0,0,0,0,'','','',0,0,0,0,'',0),(1455,'随州','http://www.suizhou.gov.cn/',213,27,0,0,0,0,0,'','','',0,0,0,0,'',0),(1456,'天门','http://www.tianmen.gov.cn/',213,28,0,0,0,0,0,'','','',0,0,0,0,'',0),(1457,'孝感','http://www.xiaogan.gov.cn/',213,29,0,0,0,0,0,'','','',0,0,0,0,'',0),(1458,'湖北省卫生厅','http://www.hbws.gov.cn/',213,30,0,0,0,0,0,'','','',0,0,0,0,'',0),(1459,'湖北物价局','http://www.hbpic.gov.cn/',213,31,0,0,0,0,0,'','','',0,0,0,0,'',0),(1460,'湖北省文化厅','http://www.hbwh.gov.cn/',213,32,0,0,0,0,0,'','','',0,0,0,0,'',0),(1461,'湖北旅游局','http://www.hubeitour.gov.cn/',214,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1462,'湖北旅游指南','http://www.hubeitour.com/',214,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1463,'荆楚网旅游频道','http://travel.cnhubei.com/',214,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1464,'汉网旅游频道','http://www.cnhan.com/gb/node/node_1185.htm',214,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1465,'湖北美食网','http://www.1797.com.cn/',214,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1466,'湖北省人民医院','http://www.rmhospital.com/',215,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1467,'荆楚网健康','http://health.cnhubei.com/',215,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1468,'汉网健康频道','http://www.cnhan.com/gb/special/node_5.htm',215,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1469,'湖北省新华医院','http://www.xinhuahospital.com/',215,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1470,'湖北教育信息网','http://www.e21.edu.cn/',216,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1471,'湖北教育考试院','http://www.hbea.edu.cn/',216,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1472,'湖北省教育厅','http://www.hbe.gov.cn/',216,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1473,'武汉大学','http://www.whu.edu.cn/',216,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1474,'湖北自考网','http://www.hbzkw.com/',216,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1475,'红网郴州站','http://www.chenzhou.gov.cn/',217,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1476,'湘潭在线','http://www.xtol.cn/',217,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1477,'星辰在线','http://www.changsha.cn/',217,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1478,'永州信息港','http://yz.2118.com.cn/',217,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1479,'红网永州站','http://www.yongzhou.gov.cn/',217,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1480,'株洲在线','http://www.zzz4.com/',217,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1481,'郴州信息港','http://www.0735.com.cn/',217,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1482,'湖南在线','http://www.hnol.net/',217,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1483,'湖南红网','http://rednet.cn/',217,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1484,'金鹰在线','http://www.hifly.tv/',217,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1485,'湖南经济报','http://www.jjbhn.com/',217,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1486,'湖南省情网','http://www.hnsq.cn/',217,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1487,'经视网','http://www.hnetv.com/',217,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1488,'湖南价格在线','http://www.priceonline.gov.cn/',217,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1489,'长沙信息港','http://www.csnis.com/',217,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1490,'长沙信息网','http://www.changshaxx.com/',217,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1491,'株洲网','http://www.zhuzhouwang.com/',217,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(1492,'湖南在线','http://hunan.voc.com.cn/',218,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1493,'华声在线','http://www.voc.com.cn/',218,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1494,'中新湖南网','http://www.hnxw.cn/',218,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1495,'湖南信息港','http://www.2118.com.cn/',218,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1496,'湖南红网','http://www.rednet.cn/',218,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1497,'潇湘晨报','http://www.xxcb.com.cn/',218,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1498,'三湘都市报','http://sxdsb.rednet.cn/',218,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1499,'长沙晚报','http://cswb.csonline.com.cn/CSWB/',218,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1500,'湖南日报','http://epaper.voc.com.cn/hnrb/',218,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1501,'东南快报','http://www.dnkb.com.cn/',218,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1502,'新华网湖南频道','http://www.hn.xinhuanet.com/',218,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1503,'湖南红网论坛','http://bbs.rednet.cn/',219,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1504,'湖南贴吧','http://tieba.baidu.com/f?kw=%BA%FE%C4%CF',219,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1505,'长沙贴吧','http://tieba.baidu.com/f?kw=%B3%A4%C9%B3',219,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1506,'湖南体彩论坛','http://bbs.hnticai.com/',219,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1507,'华声在线论坛','http://bbs.voc.com.cn/',219,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1508,'张家界公众论坛','http://www.bbszjj.com/',219,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1509,'常德论坛','http://bbs.changde.gov.cn/',219,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1510,'搜狐社区--湖南','http://club.travel.sohu.com/list_art_sub.php?b=hunan',219,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1511,'天涯社区--湖南','http://www.tianya.cn/new/TianyaCity/ArticlesList_Culture.asp?idWriter=0&Key=0&idItem=56',219,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1512,'耒阳社区','http://www.lyxxc.cn/',219,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1513,'星城导购网-长沙打折网','http://www.xcdaogou.com/',219,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1514,'长沙公交查询','http://bus.mapbar.com/changsha/',220,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1515,'平安在线','http://www.pazx888.com/',220,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1516,'福建机场','http://www.xiafz.com.cn/',220,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1517,'湖南移动','http://www.hn.chinamobile.com/',221,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1518,'湖南联通','http://www.hn.chinaunicom.com/',221,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1519,'湖南电信','http://hn.ct10000.com/',221,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1520,'好房子','http://www.haofz.com/',222,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1521,'长沙市房产管理局','http://www.csfdc.gov.cn/',222,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1522,'长沙住房公积金网','http://www.csgjj.com.cn/',222,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1523,'搜房--长沙','http://changsha.soufun.com/',222,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(1524,'湖南旅游网（旅游局）','http://www.hnt.gov.cn/',223,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1525,'湖南旅游网','http://www.gotohn.com/',223,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1526,'长沙美食网','http://eat.csonline.com.cn/',223,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1527,'湖南教育网','http://www.hnedu.cn/',224,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1528,'中南大学','http://www.csu.edu.cn/',224,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1529,'湖南大学','http://www.hnu.cn/',224,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1530,'湖南省教育考试院','http://www.hneao.edu.cn/',224,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1531,'湖南科技大学','http://www.hnust.cn/',224,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1532,'长沙考试网','http://www.csks.gov.cn/',224,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1533,'长沙名校家教网','http://csmxjj.cn/',224,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1534,'湖南省政府','http://www.hunan.gov.cn/',225,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1535,'湖南政府采购网','http://www.ccgp-hunan.gov.cn/',225,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1536,'湖南省卫生厅','http://www.21hospital.com/',225,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1537,'湘西州公众信息网','http://www.xxz.gov.cn/',225,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1538,'中国长沙','http://www.changsha.gov.cn/',225,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1539,'湖南公信网','http://www.96305.com/',225,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1540,'湘潭市政府信息网','http://www.xiangtan.gov.cn/',225,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1541,'衡阳市人民政府','http://www.hengyang.gov.cn/',225,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1542,'邵阳市公众信息网','http://www.shaoyang.gov.cn/',225,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1543,'怀化公众信息网','http://www.huaihua.gov.cn/',225,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1544,'益阳市公众信息网','http://www.yiyangcity.gov.cn/',225,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1545,'娄底政府公众信息网','http://www.hnloudi.gov.cn/',225,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1546,'常德市公众信息网','http://www.changde.gov.cn/',225,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1547,'张家界公众信息网','http://www.zjj.gov.cn/',225,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1548,'永州公众信息网','http://www.yzcity.gov.cn/',225,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1549,'湖南省财政厅','http://www.hnczt.gov.cn/',225,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1550,'长沙人事局','http://www.crxx.com/',225,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(1551,'湖南法院网','http://hunanfy.chinacourt.org/',225,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(1552,'湖南省教育厅','http://gov.hnedu.cn/cn/gov/index.jsp',225,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(1553,'长沙人才网','http://www.cshr.com.cn/',226,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1554,'湖南人才网','http://www.hnrcsc.com/',226,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1555,'湖南领导人才网','http://www.hnleader.gov.cn/',226,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1556,'51job长沙站','http://www.51job.com/default-area.php?area=1902',226,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1557,'三湘健康','http://www.sxjk.com/',227,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1558,'大众卫生报','http://dzwsb.hnol.net/',227,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1559,'广州视窗','http://www.gznet.com/',228,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1560,'南方网','http://www.southcn.com/',228,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1561,'深圳之窗','http://www.sz.net.cn/',228,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1562,'金羊网','http://www.ycwb.com/',228,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1563,'大洋网','http://www.dayoo.com/',228,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1564,'南方都市报','http://epaper.nddaily.com/',228,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1565,'深圳新闻网','http://www.sznews.com/',228,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1566,'南方报业网','http://www.nanfangdaily.com.cn/',228,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1567,'南方周末','http://www.infzm.com/',228,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1568,'新快报','http://www.xkb.com.cn/',228,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1569,'奥一网','http://www.oeeee.com/',228,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1570,'广佛都市网','http://www.citygf.com/',228,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1571,'碧海银沙','http://www.yinsha.com/',228,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1572,'21CN','http://www.21cn.com/',228,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1573,'大洋网论坛','http://club.dayoo.com/',229,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1574,'21CN社区','http://free.21cn.com/',229,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1575,'佛山魔盒社区','http://bbs.fsbox.net/',229,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1576,'奥一论坛','http://webbbs.oeeee.com/',229,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1577,'OnCity','http://www.oncity.cc/',229,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1578,'顺德人bbs','http://bbs.shunderen.com/',229,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1579,'深圳贴吧','http://tieba.baidu.com/f?kw=%C9%EE%DB%DA',229,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1580,'广州学生网论坛','http://bbs.gz4u.net/',229,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1581,'河源论坛','http://bbs.076299.com/',229,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1582,'深圳之窗社区','http://club.sz.net.cn/',229,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1583,'深圳论坛','http://szbbs.sznews.com/',229,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1584,'惠州乐乐','http://www.hzyes.com/',229,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1585,'深圳磨房论坛','http://www.doyouhike.net/forum/',229,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1586,'广州天涯户外','http://bbs.outdoors.com.cn/',229,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1587,'西子湖畔论坛','http://www.xizi.com/',229,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1588,'阳光社区','http://bbs.sun0769.com/',229,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1589,'龙川论坛','http://www.lcbbs.cc/',229,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(1590,'潮汕人','http://bbs.chaoshanren.com/',229,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(1591,'蓝色河畔','http://bbs.hepan.net.cn/',229,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(1592,'e京','http://www.ezeem.com/',229,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(1593,'酷广州论坛','http://www.kugz.net/',229,21,0,0,0,0,0,'','','',0,0,0,0,'',0),(1594,'广东发展论坛','http://bbs.gd.gov.cn/',229,22,0,0,0,0,0,'','','',0,0,0,0,'',0),(1595,'渔人之家','http://bbs.yuhome.net/',229,23,0,0,0,0,0,'','','',0,0,0,0,'',0),(1596,'0668论坛','http://bbs.0668.com/',229,24,0,0,0,0,0,'','','',0,0,0,0,'',0),(1597,'西樵论坛','http://www.xq0757.com/',229,25,0,0,0,0,0,'','','',0,0,0,0,'',0),(1598,'茂名在线社区','http://bbs.gdmm.com/',229,26,0,0,0,0,0,'','','',0,0,0,0,'',0),(1599,'番禺社区','http://www.py168.com/',229,27,0,0,0,0,0,'','','',0,0,0,0,'',0),(1600,'小桥流水','http://www.521000.com/',229,28,0,0,0,0,0,'','','',0,0,0,0,'',0),(1601,'c2000','http://www.c2000.cn/',229,29,0,0,0,0,0,'','','',0,0,0,0,'',0),(1602,'佛山天天新','http://ttx.cn/',229,30,0,0,0,0,0,'','','',0,0,0,0,'',0),(1603,'番禺论坛','http://www.pybbs.com/',229,31,0,0,0,0,0,'','','',0,0,0,0,'',0),(1604,'坐车网','http://www.zuoche.com/',230,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1605,'广州公交查询','http://www.gz-bus.com/chaxun/',230,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1606,'广州地铁','http://www.gzmtr.com/ckfw/dtxlt/',230,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1607,'深圳公交、地图查询','http://map.sz.bendibao.com/',230,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1608,'深圳地铁','http://www.szmc.net/index.jsp',230,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1609,'深圳宝安国际机场','http://www.szairport.com/',230,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1610,'查查吧','http://www.chachaba.com/',230,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1611,'深圳通','http://www.shenzhentong.com/',230,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1612,'广东移动','http://www.gd.chinamobile.com/',231,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1613,'广东联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010004&id=1677',231,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1614,'深圳移动','http://www.gd.chinamobile.com/shenzhen/',231,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1615,'广东电信','http://gd.ct10000.com/gz/',231,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1616,'广州市房产管理局','http://www.laho.gov.cn/',232,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1617,'深圳土地资源委员会','http://www.szfdc.gov.cn/',232,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1618,'深圳房地产信息网','http://www.szhome.com/',232,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1619,'搜房网-广州','http://gz.soufun.com/',232,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1620,'搜房网-深圳','http://sz.soufun.com/',232,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1621,'焦点房产-广州','http://gz.focus.cn/',232,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1622,'大众点评','http://www.dianping.com/guangzhou',233,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1623,'星海音乐厅','http://www.concerthall.com.cn/',233,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1624,'深圳世界之窗','http://www.szwwco.com/',233,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1625,'深圳东部华侨城','http://www.octeast.com/',233,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1626,'深圳欢乐谷','http://sz.happyvalley.cn/',233,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1627,'白云山','http://www.baiyunshan.com.cn/',233,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1628,'佛山信息港','http://www.fsecity.com/',234,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1629,'中山网','http://www.zsnews.cn/',234,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1630,'东莞新闻网','http://www.dgnews.com.cn/',234,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1631,'东莞阳光网','http://www.sun0769.com/',234,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1632,'清远视窗','http://www.qy.gd.cn/',234,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1633,'顺德信息网','http://www.shunde.net.cn/',234,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1634,'韶关信息港','http://www.sg163.com/',234,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1635,'惠州信息港','http://www.hzinfo.com/',234,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1636,'中山国际网','http://www.zsnet.com/',234,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1637,'汕头信息港','http://st.gd.vnet.cn/',234,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1638,'珠海视窗','http://www.zhuhai.gd.cn/',234,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1639,'江门国际网','http://jm.gd.vnet.cn/',234,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1640,'韶关家园','http://www.sg169.com/',234,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1641,'茂名在线','http://www.gdmm.com/',234,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1642,'茂名信息港','http://www.maoming.gd.cn/',234,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1643,'梅州视窗','http://mz.gd.vnet.cn/',234,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1644,'肇庆西江明珠','http://zq.gd.vnet.cn/',234,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(1645,'广东省政府','http://www.gd.gov.cn/',235,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1646,'广州市政府','http://www.gz.gov.cn/',235,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1647,'深圳市政府','http://www.sz.gov.cn/',235,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1648,'省交通厅','http://www.gdcd.gov.cn/',235,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1649,'省工商局','http://www.gdgs.gov.cn/',235,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1650,'省卫生厅','http://www.gdwst.gov.cn/',235,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1651,'省财政厅','http://www.gdczt.gov.cn/',235,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1652,'珠海','http://www.zhuhai.gov.cn/',235,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1653,'汕头','http://www.shantou.gov.cn/',235,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1654,'佛山','http://www.foshan.gov.cn/',235,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1655,'韶关','http://www.shaoguan.gov.cn/',235,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1656,'河源','http://www.heyuan.gov.cn/',235,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1657,'梅州','http://www.meizhou.gov.cn/',235,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1658,'惠州','http://www.huizhou.gov.cn/',235,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1659,'汕尾','http://www.shanwei.gov.cn/',235,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1660,'阳江','http://www.yangjiang.gov.cn/',235,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1661,'中山','http://www.zs.gov.cn/',235,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(1662,'江门','http://www.jiangmen.gov.cn/',235,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(1663,'云浮','http://www.yunfu.gov.cn/',235,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(1664,'揭阳','http://www.jieyang.gov.cn/',235,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(1665,'茂名','http://www.maoming.gov.cn/',235,21,0,0,0,0,0,'','','',0,0,0,0,'',0),(1666,'肇庆','http://www.zhaoqing.gov.cn/',235,22,0,0,0,0,0,'','','',0,0,0,0,'',0),(1667,'潮州','http://www.chaozhou.gov.cn/',235,23,0,0,0,0,0,'','','',0,0,0,0,'',0),(1668,'广州市财政局','http://www.gzfinance.gov.cn/',235,24,0,0,0,0,0,'','','',0,0,0,0,'',0),(1669,'省地方税务局','http://www.gdltax.gov.cn/',235,25,0,0,0,0,0,'','','',0,0,0,0,'',0),(1670,'省公安厅出入境管理处','http://crj.gdga.gov.cn/',235,26,0,0,0,0,0,'','','',0,0,0,0,'',0),(1671,'省社会保险基金管理局','http://www.gdsi.gov.cn/',235,27,0,0,0,0,0,'','','',0,0,0,0,'',0),(1672,'广东省公安厅','http://www.gdga.gov.cn/',235,28,0,0,0,0,0,'','','',0,0,0,0,'',0),(1673,'海南在线','http://www.hainan.net/',236,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1674,'南海网','http://www.hinews.cn/',236,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1675,'天涯热线','http://www.tianya.net/',236,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1676,'新华网海南频道','http://www.hq.xinhuanet.com/',236,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1677,'天涯社区','http://www.tianya.cn/',236,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1678,'凯迪网络','http://www.cat898.com/',236,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1679,'视听海南（海南电视台）','http://www.hnwtv.com/',236,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1680,'三亚晨报','http://www.sycb.com.cn/',236,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1681,'海南省政府','http://www.hainan.gov.cn/',236,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1682,'海南广播电视台公共频道','http://www.hainantv.com.cn/',236,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1683,'海口晚报','http://www.hkwb.net/',236,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1684,'海南特区报','http://www.hntqb.com/',236,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1685,'南国都市报','http://ngdsb.hinews.cn/',236,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1686,'海口广播电视台','http://www.haikoutv.com/',236,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1687,'人民网海南视窗','http://hi.people.com.cn/',236,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1688,'蓝色海滨（网通）','http://www.cnc-hn.com/',236,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1689,'蓝网','http://www.bluehn.com/',236,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(1690,'百度地图－三亚','http://map.baidu.com/#word=三亚&ct=10',236,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(1691,'百度地图－海口','http://map.baidu.com/#word=海口市&ct=10',236,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(1692,'海南移动','http://www.hi.chinamobile.com/',237,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1693,'海南联通','http://www.hi.chinaunicom.com/',237,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1694,'海南电信','http://hi.ct10000.com/',237,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1695,'海南邮政局','http://post.hainan.gov.cn/',237,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1696,'海南铁通','http://www.ctthi.com/',237,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1697,'天涯宽频','http://tianya.vnet.cn/',237,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1698,'小灵通','http://www.tianya.net/lingtong/xlt.html',237,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1699,'海南人才在线','http://job.hainan.net/',238,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1700,'海南旅游人才网','http://www.tttsss.com/',238,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1701,'海南人才热线','http://www.0898job.com/',238,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1702,'海口人才网','http://www.haijob.com/',238,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1703,'三亚人才网','http://www.sanyajob.com/',238,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1704,'南海网人才频道','http://job.hinews.cn/',238,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1705,'海南在线房产频道','http://house.hainan.net/',239,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1706,'海口住宅与房产信息网','http://www.hkrealestate.gov.cn/',239,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1707,'三亚房地产信息网','http://www.esanya.net/',239,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1708,'海南住房公积金网','http://www.hngjj.net/',239,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1709,'海南在线装饰频道','http://home.hainan.net/',239,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1710,'新房产','http://house.hinews.cn/',239,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1711,'海南旅游网','http://www.hiholiday.com/',240,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1712,'海南岛度假网','http://www.tohainan.com/',240,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1713,'三亚旅游网','http://www.sanyatour.com/',240,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1714,'热岛假期','http://www.ww10000.com/',240,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1715,'海南省旅游局','http://tourism.hainan.gov.cn/',240,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1716,'新华网海南旅游','http://www.hq.xinhuanet.com/travel/',240,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1717,'城市消费','http://city.hainan.net/',240,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1718,'南海网美食频道','http://food.hinews.cn/',240,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1719,'大众点评网海南美食','http://www.dianping.com/hainan/food',240,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1720,'海南在线健康岛','http://health.hainan.net/',241,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1721,'南海网健康医药','http://120.hinews.cn/',241,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1722,'海南省血液中心','http://www.blood.org.cn/',241,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1723,'海南省人民医院','http://www.phhp.com.cn/',241,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1724,'海南省中医院','http://www.hizyy.com/',241,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1725,'南航医院','http://www.nhyy.net/',241,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1726,'海口市医院','http://www.haikoumh.com.cn/',241,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1727,'海南妇幼保健院','http://www.hnmch.com/',241,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1728,'海南在线教育培训','http://edu.hainan.net/',242,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1729,'海南省教育厅','http://edu.hainan.gov.cn/',242,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1730,'海南省考试局','http://ea.hainan.gov.cn/',242,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1731,'海南大学','http://www.hainu.edu.cn/',242,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1732,'海南师范大学','http://www.hainnu.edu.cn/',242,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1733,'海南医学院','http://www.hainmc.edu.cn/',242,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1734,'海南职业技术学院','http://www.hcvt.cn/',242,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1735,'天涯社区','http://www.tianya.cn/',243,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1736,'海南一家','http://club.hainan.net/cgi-bin/index.asp?vitem=hn',243,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1737,'阳光岛社区','http://club.hinews.cn/',243,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1738,'百度贴吧三亚','http://post.baidu.com/f?kw=%C8%FD%D1%C7',243,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1739,'凯迪社区','http://www.cat898.com/',243,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1740,'百度知道－海南','http://zhidao.baidu.com/browse/254',243,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1741,'百度贴吧海南','http://post.baidu.com/f?ct=&tn=&rn=&pn=&lm=&kw=海南&rs2=0&myselectvalue=1&word=海南&tb=on',243,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1742,'百度贴吧海口','http://post.baidu.com/f?kw=海口&frs=yqtb',243,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1743,'海南经济报','http://www.hnjjb.com/',244,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1744,'海南福彩网','http://www.hnfc.net/',244,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1745,'海南体彩网','http://www.tc.hainan.net/',244,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1746,'南国彩票','http://88.hinews.cn/',244,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1747,'海南省政府','http://www.hainan.gov.cn/',245,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1748,'海口海关','http://haikou.customs.gov.cn/',245,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1749,'海南省海洋渔业厅','http://dof.hainan.gov.cn/',245,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1750,'海南省农业厅','http://www.hiagri.gov.cn/',245,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1751,'海南地方税务局','http://tax.hainan.gov.cn/',245,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1752,'天涯法律网','http://www.hicourt.gov.cn/',245,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1753,'海南省财政厅','http://mof.hainan.gov.cn/',245,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(1754,'海南省教育厅','http://edu.hainan.gov.cn/',245,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(1755,'海南省发展改革厅','http://plan.hainan.gov.cn/',245,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1756,'天涯正义网','http://www.hi.jcy.gov.cn/',245,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1757,'海口市','http://www.haikou.gov.cn/',245,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1758,'三亚市','http://www.sanya.gov.cn/',245,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1759,'琼海市','http://qionghai.hainan.gov.cn/',245,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1760,'文昌市','http://www.wenchang.gov.cn/',245,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1761,'五指山','http://www.wzs.gov.cn/',245,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1762,'儋州','http://www.danzhou.gov.cn/',245,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1763,'东方市','http://dongfang.hainan.gov.cn/',245,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1764,'海南国家税务局','http://www.hitax.gov.cn/',245,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1765,'海南气象','http://mb.hainan.gov.cn/',246,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1766,'海南航空公司','http://www.hnair.com/',246,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1767,'海口美兰国际机场','http://www.mlairport.com/',246,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1768,'海口公交','http://www.hainan.gov.cn/V3/bus/',246,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1769,'海南地图网','http://www.hnemap.com/',246,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1770,'海南交通网','http://www.jt.hi.cn/',246,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1771,'成都人才网','http://www.rc114.com/',247,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1772,'四川人事信息网','http://www.scrs.gov.cn/',247,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1773,'中华英才网-成都','http://www.chinahr.com/chengdu',247,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1774,'四川在线美食','http://cdcd.scol.com.cn/',248,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1775,'新华网四川美食','http://www.sc.xinhuanet.com/service/food',248,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1776,'四川大学华西医院','http://www.cd120.com/',249,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1777,'四川省人民医院','http://www.samsph.com/',249,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1778,'天府热线','http://www.tfol.com/',250,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1779,'西部在线','http://www.xbol.net/',250,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1780,'宜宾新闻网','http://www.ybxww.com/',250,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1781,'广元热线','http://www.gy169.net/',250,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1782,'宜宾泡菜坛','http://www.ybbbs.com/',250,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1783,'自贡在线','http://www.zg163.net/',250,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1784,'天府网','http://www.tyfo.com/',250,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1785,'中国四川','http://www.scsti.ac.cn/',250,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1786,'四川在线','http://www.scol.com.cn/',251,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1787,'四川电视台','http://www.sctv.com/',251,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1788,'四川新闻网','http://www.newssc.org/',251,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1789,'成都电视台','http://www.chengdutv.com/',251,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1790,'新华网四川频道','http://www.sc.xinhuanet.com/',251,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1791,'成都晚报','http://www.cdwb.com.cn/',251,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1792,'大成网','http://cd.qq.com/',251,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1793,'成都商报','http://e.cdqss.com/',251,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1794,'中新网四川频道','http://www.sc.chinanews.com.cn/',251,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1795,'北纬网','http://www.beiww.com/',251,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1796,'天府论坛','http://bbs.scol.com.cn/',252,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1797,'四川贴吧','http://tieba.baidu.com/f?kw=%CB%C4%B4%A8',252,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1798,'西秦会馆','http://bbs.zg163.net/',252,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1799,'凤凰山下','http://bbs.dz169.net/',252,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1800,'麻辣社区','http://club.newssc.org/',252,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1801,'第四城','http://www.028town.com/',252,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1802,'成都贴吧','http://tieba.baidu.com/f?kw=%B3%C9%B6%BC',252,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1803,'最成都','http://bbs.chengtu.com/',252,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1804,'泸州论坛','http://www.0830bbs.com/',252,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1805,'宜宾零距离','http://bbs.ybvv.com/',252,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1806,'雨城论坛','http://bbs.yaanren.net/',252,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1807,'四川在线房产','http://house.scol.com.cn/',253,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1808,'搜房网成都站','http://cd.soufun.com/',253,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1809,'四川房地产','http://www.scfdc.cn/',253,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1810,'成都房管局','http://www.cdfgj.gov.cn/',253,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1811,'成都住房公积金','http://www.cdzfgjj.gov.cn/',253,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1812,'成都吃喝玩乐网','http://www.hxfoods.com/',254,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1813,'成都欢乐谷','http://www.cdhlg.com/',254,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1814,'成都口碑网','http://chengdu.koubei.com/',254,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1815,'大众点评网成都美食','http://www.dianping.com/chengdu/food',254,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1816,'成都全搜索','http://www.cdqss.com/',254,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1817,'四川旅游信息网','http://www.scta.gov.cn/',254,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1818,'四川旅游论坛','http://www.travelbbs.com/',254,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(1819,'搜成都-预定我们的半径生活','http://www.028114.com/',254,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(1820,'成都公交','http://bus.mapbar.com/chengdu/',255,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1821,'四川公安交通管理信息网','http://www.scjj.gov.cn/',255,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1822,'四川移动','http://www.sc.chinamobile.com/',256,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1823,'四川联通','http://info.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010009&id=3368',256,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1824,'四川电信','http://www.sc.ct10000.com/',256,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1825,'四川铁通','http://www.cttsc.com/',256,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1826,'四川教育网','http://www.scedu.net/',257,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1827,'四川招生网','http://www.zk789.net/',257,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1828,'成都人事考试网','http://www.cdpta.com/',257,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1829,'成都教育','http://www.cdedu.gov.cn/',257,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1830,'四川人事考试网','http://www.scpta.gov.cn/',257,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1831,'四川大学','http://www.scu.edu.cn/',257,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1832,'西南交通大学','http://www.swjtu.edu.cn/',257,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1833,'西南财经大学','http://www.swufe.edu.cn/',257,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1834,'四川师范大学','http://www.sicnu.edu.cn/',257,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1835,'四川理工学院','http://www.suse.edu.cn/',257,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1836,'西南科技大学','http://www.swust.edu.cn/',257,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1837,'四川人才网','http://www.scrc168.com/',257,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1838,'学浪教育-成教家教网','http://www.xuegle.com/',257,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1839,'湖北招生考试网','http://www.edu-hb.com/',257,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(1840,'四川省政府','http://www.sc.gov.cn/',258,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1841,'四川工商局','http://www.scaic.gov.cn/',258,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1842,'成都市社保局','http://www.cdldbz.gov.cn/',258,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1843,'四川劳动社会保障厅','http://www.sc.lss.gov.cn/',258,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1844,'成都市政府','http://www.chengdu.gov.cn/',258,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1845,'绵阳','http://www.mianyang.gov.cn/',258,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1846,'南充','http://www.nanchong.gov.cn/',258,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1847,'攀枝花','http://www.pzhs.gov.cn/',258,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1848,'四川省交通厅','http://www.scjt.gov.cn/',258,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1849,'德阳','http://www.deyang.gov.cn/',258,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1850,'四川省建设厅','http://www.scjst.gov.cn/',258,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1851,'达州','http://www.dazhou.gov.cn/',258,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1852,'四川政府采购网','http://www.sczfcg.com/',258,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(1853,'资阳','http://www.ziyang.gov.cn/',258,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(1854,'雅安','http://www.yaan.gov.cn/',258,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(1855,'四川警察网','http://www.scga.gov.cn/',258,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(1856,'贵州信息港','http://www.gz163.cn/',259,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1857,'贵州电视台','http://www.gzstv.com/',259,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1858,'百度新闻—贵州','http://news.baidu.com/n?cmd=6&loc=7230&name=贵州&pn=1',259,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1859,'安顺','http://www.anshun.gov.cn/',259,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1860,'贵州省政府','http://www.gzgov.gov.cn/',259,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1861,'铜仁','http://www.tongren.gov.cn/',259,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1862,'遵义在线','http://www.zyol.gz.cn/',259,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1863,'贵州中国','http://www.chinaguizhou.gov.cn/',259,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1864,'贵州气象','http://www.gzqx.gov.cn/',259,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1865,'贵州人才信息网','http://www.gzrc.gov.cn/',260,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1866,'贵州教育网','http://www.gzsedu.cn/',260,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1867,'贵州旅游在线','http://www.gz-travel.net/',260,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1868,'搜房贵阳站','http://gy.soufun.com/',260,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1869,'贵州移动','http://www.gz.chinamobile.com/',260,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1870,'六盘水','http://www.gzlps.gov.cn/',260,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1871,'贵州省建设厅','http://www.gzjs.gov.cn/',260,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1872,'贵州电信','http://gz.ct10000.com/',260,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1873,'贵州贴吧','http://post.baidu.com/f?kw=%B9%F3%D6%DD',261,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1874,'贵阳贴吧','http://post.baidu.com/f?kw=%B9%F3%D1%F4',261,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1875,'遵义梦网社区','http://bbs.zymnet.com/',261,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1876,'贵州e友社区','http://www.gycity.com/',261,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1877,'百度知道-贵州','http://zhidao.baidu.com/browse/260',261,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1878,'夜郎社区','http://club.gz163.cn/',261,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1879,'贵州家园','http://www.gzcity.com/',261,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1880,'贵州网吧','http://webar.silversand.net/list.php?Province2=贵州',262,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1881,'云南省政府','http://www.yn.gov.cn/',263,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1882,'大理州','http://www.dali.gov.cn/',263,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1883,'红河州','http://www.hh.gov.cn/',263,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1884,'云南省财政厅','http://www.ynf.gov.cn/',263,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1885,'昆明市','http://www.km.gov.cn/',263,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1886,'曲靖市','http://www.qj.gov.cn/',263,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1887,'玉溪市','http://www.yuxi.gov.cn/',263,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1888,'文山州','http://www.ynws.gov.cn/',263,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1889,'吉林省工商局','http://www.jlsgs.gov.cn/',263,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1890,'云南发改委','http://www.yndpc.yn.gov.cn/',263,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1891,'云南省法院','http://www.gy.yn.gov.cn/',263,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1892,'云游网','http://www.traveloyunnan.com.cn/',264,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1893,'云南旅游频道','http://tour.yunnan.cn/',264,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1894,'云南日报旅游频道','http://www.yndaily.com/ihtml/yndaily/TXTP_LY.html',264,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1895,'云南美食网','http://www.yncate.com/',264,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1896,'云南医疗保险网','http://www.ynyb.org.cn/',265,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1897,'云南省中医院','http://www.yn-tcm-hospital.com/',265,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1898,'云大医院','http://www.ydyy.cn/',265,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1899,'云南彩票网','http://www.xinancaipiao.com/',266,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1900,'云南体彩网','http://www.ynticai.cn/',266,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1901,'云之南社区','http://club.yninfo.com/',267,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1902,'百度贴吧西双版纳','http://tieba.baidu.com/f?kw=西双版纳',267,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1903,'百度贴吧云南','http://tieba.baidu.com/f?kw=云南',267,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1904,'百度贴吧昆明','http://tieba.baidu.com/f?kw=昆明',267,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1905,'百度贴吧大理','http://tieba.baidu.com/f?kw=大理',267,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1906,'云南大学','http://www.ynu.edu.cn/',268,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1907,'云南省招考频道','http://www.ynzs.cn/',268,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1908,'云南自考网','http://www.ynzk.com/',268,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1909,'云南师范大学','http://www.ynnu.edu.cn/',268,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1910,'云南培训认证网','http://www.ynpxrz.com/',268,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1911,'昆明理工大学','http://www.kmust.edu.cn/',268,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1912,'云南民族大学','http://www.ynni.edu.cn/',268,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1913,'云南教育网','http://www.ynjy.cn/',268,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1914,'云南财经大学','http://www.ynufe.edu.cn/',268,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1915,'云南农业职业技术学院','http://www.ynavc.com/',268,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1916,'云南医学高等专科学校','http://www.mvc.yn.cn/',268,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1917,'云南交通职业技术学院','http://www.yncs.edu.cn/',268,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(1918,'西双版纳信息港','http://www.bn163.net/',269,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1919,'昆明热线','http://www.km169.net/',269,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1920,'临沧','http://www.lincang.cn/',269,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1921,'曲靖信息港','http://www.eqj.cn/',269,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1922,'文山信息港','http://ws.yninfo.com/',269,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1923,'云南在线','http://www.chntt.com/',269,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1924,'大理信息港','http://www.dali163.com/',269,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1925,'云南民族文化网','http://www.ynmw.org/',269,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1926,'云南信息港交友','http://love.yninfo.com/',269,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1927,'西双版纳商务网','http://www.12bn.net/',269,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1928,'云南网','http://www.yunnan.cn/',270,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1929,'云南信息港','http://www.yninfo.com/',270,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1930,'云南电视网','http://www.yntv.cn/',270,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1931,'云南日报网','http://www.yndaily.com/',270,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1932,'昆明电视台','http://www.kmtv.com.cn/',270,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1933,'云南新闻网','http://www.yn.chinanews.com.cn/',270,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1934,'云南信息报','http://www.ynxxb.com/',270,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1935,'昆明公交','http://www.kmbus.com.cn/',271,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1936,'云南机场','http://www.ynairport.com/',271,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1937,'云南移动','http://www.yn.chinamobile.com/',272,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1938,'云南联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010026&id=4154',272,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1939,'云南电信','http://www.yn.ct10000.com/',272,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1940,'云南人才市场','http://www.ynhr.com/',273,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1941,'云南招聘网','http://www.ynzp.cn/',273,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1942,'云南信息港人才','http://work.yninfo.com/',273,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1943,'云南人事人才网','http://www.ynrs.gov.cn/',273,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1944,'云南劳动保障网','http://www.ynl.gov.cn/',273,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1945,'云南人才热线','http://www.yunnanrc.com/',273,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1946,'昆明住房公积金网','http://www.kmgjj.com/',274,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1947,'云南信息港房网','http://house.yninfo.com/',274,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1948,'搜房昆明','http://km.soufun.com/',274,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1949,'云南房网','http://www.ynhouse.com/',274,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1950,'榆林信息港','http://www.ssfeng.com/',275,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1951,'西部网','http://www.cnwest.com/',275,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1952,'宝鸡日报','http://www.baojidaily.com/',275,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1953,'宝鸡新闻网','http://www.baojinews.com/',275,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1954,'海东','http://www.haidong.gov.cn/',275,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(1955,'古城热线','http://www.269.net/',276,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1956,'三秦都市报','http://www.sanqindaily.com/',276,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1957,'西安新闻网','http://www.xawb.com/',276,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1958,'陕西电视台','http://www.sxtvs.com/',276,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1959,'白鸽网（西安电视台）','http://www.xatvs.com/',276,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1960,'华商网','http://www.hsw.cn/',276,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1961,'陕西日报','http://www.sxdaily.com.cn/',276,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1962,'金号网','http://www.sxradio.com.cn/',276,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1963,'人民网陕西视窗','http://unn.people.com.cn/GB/14793/index.html',276,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(1964,'新华网陕西视窗','http://www.sn.xinhuanet.com/',276,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(1965,'西安热线','http://www.c029.com/',276,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(1966,'陕西风采福利彩票','http://www.sxfc.gov.cn/',277,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1967,'陕西体彩网','http://www.sxtc.com.cn/index.php',277,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1968,'陕西证券','http://www.sei.gov.cn/ShowClass32008.ASP?ClassID=27',277,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1969,'开源证券','http://www.sxkyzq.com/',277,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1970,'陕西气象信息网','http://www.sxmb.gov.cn/',278,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1971,'西安公交查询','http://www1.xbus.cn/',278,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1972,'陕西地图','http://www.shaanxi.cn/sx_into/sxmap/index.htm',278,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1973,'西安咸阳机场','http://www.xxia.com/',278,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1974,'西安公交网','http://www.xbus.cn/',278,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(1975,'西安咸阳机场售票处','http://www.xian-airport.com/',278,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(1976,'陕西移动','http://www.sn.chinamobile.com/',279,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1977,'陕西联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010015&id=2533',279,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1978,'陕西电信','http://sn.ct10000.com/',279,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1979,'陕西互联星空','http://www.vnet.cn/sn/',279,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1980,'陕西铁通','http://www.cttsn.com/',279,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1981,'陕西人才网','http://www.sxrcw.net/',280,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1982,'中国西安人才网','http://www.xajob.com/',280,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1983,'陕西人事人才信息网','http://www.sxrs.gov.cn/',280,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1984,'中华英才西安站','http://xian.chinahr.com/',280,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1985,'搜房网西安','http://xian.soufun.com/',281,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1986,'西安房地产信息网','http://www.800j.com.cn/',281,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1987,'西安房产管理局','http://www.xafgj.gov.cn/',281,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1988,'三秦房产网','http://www.3qhouse.com/',281,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1989,'站台西安','http://xa.zhantai.com/',281,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1990,'西安市旅游局','http://www.xian-tourism.com/',282,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1991,'西线风景','http://www.sncrc.com/',282,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1992,'陕西旅游网','http://www.sxtour.com/',282,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(1993,'陕西历史博物馆','http://www.sxhm.com/',282,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(1994,'秦始皇兵马俑博物馆','http://www.bmy.com.cn/',282,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(1995,'华清池','http://www.hqc.cn/',282,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(1996,'陕西卫生网','http://www.sxhealth.gov.cn/',283,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1997,'陕西省人民医院','http://www.spph-sx.com/index2.asp',283,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(1998,'陕西教育网','http://www.snedu.com/',284,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(1999,'陕西人事考试网','http://www.sxrsks.cn/',284,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2000,'陕西招生考试信息网','http://www.sneac.com/',284,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2001,'西安交通大学','http://www.xjtu.edu.cn/',284,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2002,'西北工业大学','http://www.nwpu.edu.cn/',284,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2003,'西安电子科技大学','http://www.xidian.edu.cn/',284,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2004,'陕西师范大学','http://www.snnu.edu.cn/',284,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2005,'西安人事考试网','http://www.xapta.com.cn/',284,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2006,'古城茶秀','http://forum.xaonline.com/',285,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2007,'腾讯论坛西安','http://xian.qq.com/bbs/bbs.htm',285,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2008,'华商论坛','http://bbs.hsw.cn/',285,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2009,'百度贴吧西安','http://post.baidu.com/f?kw=西安',285,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2010,'百度知道陕西','http://zhidao.baidu.com/browse/261',285,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2011,'荣耀西安论坛','http://www.bestxian.com/',285,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2012,'搜狐论坛陕西','http://club.city.travel.sohu.com/l-shan_xi-0-0-0-0.html',285,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2013,'天涯社区陕西','http://bbs.city.tianya.cn/new/TianyaCity/ArticlesList_Culture.asp?idWriter=0&Key=0&idItem=60',285,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2014,'西安窝-鲜我网','http://www.xianwo.com/',285,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(2015,'陕西省政府','http://www.shaanxi.gov.cn/',286,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2016,'榆林市政府','http://www.yl.gov.cn/',286,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2017,'铜川市政府','http://www.tongchuan.gov.cn/',286,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2018,'中国咸阳','http://www.xianyang.gov.cn/',286,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2019,'西安市政府','http://www.xa.gov.cn/',286,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2020,'汉中市政府','http://www.hanzhong.gov.cn/',286,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2021,'陕西省教育厅','http://www.snedu.gov.cn/',286,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2022,'商洛市政府','http://www.shangluo.gov.cn/',286,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2023,'安康市政府','http://www.ankang.gov.cn/',286,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(2024,'宝鸡市政府','http://www.baoji.gov.cn/',286,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(2025,'延安市政府','http://www.yanan.gov.cn/',286,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(2026,'陕西省交通厅','http://www.sxsjtt.gov.cn/',286,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(2027,'陕西价格信息网','http://www.spic.gov.cn/',286,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(2028,'陕西卫生网','http://www.sxhealth.gov.cn/',286,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(2029,'114团购网','http://www.114tgw.com/',287,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2030,'每日甘肃','http://www.gansudaily.com.cn/',288,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2031,'西部时空','http://www.westcn.com/',288,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2032,'新华网甘肃频道','http://www.gs.xinhua.org/',288,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2033,'西部商报','http://www.xbsb.com.cn/',288,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2034,'甘肃广播电视台','http://www.gstv.com.cn/',288,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2035,'中国甘肃网','http://www.gansu.gov.cn/',288,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2036,'网通星空','http://www.westcnc.com/',288,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2037,'兰州晨报','http://lzcb.gansudaily.com.cn/',288,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2038,'甘肃经济日报','http://www.gsjb.com/',288,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(2039,'兰州电视台','http://www.lztv.tv/',288,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(2040,'兰州新闻网','http://www.lzbs.com.cn/',288,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(2041,'甘肃汽车网','http://www.gscar.cn/',288,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(2042,'兰州广播网','http://www.lzr.com.cn/',288,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(2043,'中国兰州网','http://www.lanzhou.cn/',288,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(2044,'人民网甘肃视窗','http://gs.people.com.cn/',288,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(2045,'甘肃热线','http://www.gansunet.com/',288,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(2046,'天水在线','http://www.tianshui.com.cn/',288,17,0,0,0,0,0,'','','',0,0,0,0,'',0),(2047,'定西宽频网','http://dx.gs.vnet.cn/',288,18,0,0,0,0,0,'','','',0,0,0,0,'',0),(2048,'天马热线','http://ww.gs.vnet.cn/',288,19,0,0,0,0,0,'','','',0,0,0,0,'',0),(2049,'铜城信息港','http://by.gs.vnet.cn/',288,20,0,0,0,0,0,'','','',0,0,0,0,'',0),(2050,'百度地图兰州','http://map.baidu.com/#word=兰州市&ct=10',288,21,0,0,0,0,0,'','','',0,0,0,0,'',0),(2051,'每日甘肃旅游频道','http://tour.gansudaily.com.cn/',288,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(2052,' 甘肃省气象局','http://www.gsma.gov.cn/',289,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2053,'兰州公交集团','http://www.lzbus.com/',289,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2054,'甘肃联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010030&id=2290',290,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2055,'甘肃移动','http://www.gs.chinamobile.com/',290,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2056,'甘肃电信','http://www.gansutelecom.com/',290,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2057,'甘肃宽频','http://m.gs.vnet.cn/',290,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2058,'西北人才网','http://www.xbrc.gov.cn/',291,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2059,'甘肃人事网','http://www.rst.gansu.gov.cn/',291,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2060,'酒泉人事人才网','http://www.jqrc.net/',291,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2061,'通渭人家网','http://www.tongweirenjia.com/',291,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2062,'甘房网','http://www.gshouse.com.cn/',292,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2063,'每日甘肃房产频道','http://house.gansudaily.com.cn/',292,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2064,'兰州住房公积金网','http://www.lzgjj.com/',292,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2065,'兰州房地产网','http://www.bona.net.cn/',292,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2066,'甘肃家装网','http://www.gsjzw.cn/',292,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2067,'每日甘肃房产频道','http://house.gansudaily.com.cn/',293,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2068,'甘肃省旅游局','http://www.chinasilkroad.com/',293,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2069,'酒泉旅游网','http://www.jqta.com/',293,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2070,'敦煌旅游网','http://www.dunhuangtour.com/',293,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2071,'兰州市旅游局','http://www.huanghetour.com/default.asp',293,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2072,'每日甘肃网美食','http://eat.gansudaily.com.cn/',293,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2073,'大众点评兰州美食','http://www.dianping.com/lanzhou',293,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2074,'嘉酒视窗','http://www.0937.net/',293,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2075,'甘肃省中医院','http://www.gszyy.com/',294,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2076,'甘肃省卫生厅','http://www.gshealth.gov.cn/',294,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2077,'甘肃医疗服务网','http://www.gsylfw.com/',294,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2078,'甘肃省人民医院','http://www.gsyy.cn/',294,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2079,'甘肃医院地址电话','http://www.jklife.cn/c124.shtml',294,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2080,'每日甘肃论坛','http://bbs.gansudaily.com.cn/',295,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2081,'甘肃贴吧','http://post.baidu.com/f?kw=甘肃',295,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2082,'兰州贴吧','http://post.baidu.com/f?kw=兰州',295,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2083,'百度知道--甘肃','http://zhidao.baidu.com/browse/262',295,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2084,'西部时空社区','http://club.gs.vnet.cn/',295,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2085,'酒泉在线','http://www.jqcn.com/',295,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2086,'甘肃省卫生厅','http://www.gsws.gov.cn/',295,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2087,'甘肃福彩','http://www.fulicaipiao.cn/gansu/',296,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2088,'甘肃体彩','http://www.gstc.gov.cn/',296,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2089,'甘肃省政府','http://www.gansu.gov.cn/',297,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2090,'甘肃工商行政管理局','http://www.gsaic.gov.cn/',297,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2091,'甘肃省发改委','http://www.gspc.gov.cn/',297,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2092,'甘肃省专利信息网','http://www.ipo.gansu.gov.cn/',297,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2093,'甘肃315维权网','http://www.gs315.org.cn/',297,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2094,'甘肃公安网','http://www.gsgaw.gov.cn/',297,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2095,'兰州市政府','http://www.lz.gansu.gov.cn/',297,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2096,'酒泉市人民政府','http://www.jiuquan.gov.cn/',297,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2097,'甘肃人事编制信息网','http://www.rst.gansu.gov.cn/',297,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(2098,'甘肃教育咨询网','http://www.gssedu.cn/',298,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2099,'甘肃省招生办公室','http://www.gszs.edu.cn/',298,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2100,'兰州大学','http://www.lzu.edu.cn/',298,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2101,'西北师范大学','http://www.nwnu.edu.cn/',298,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2102,'兰州理工大学','http://www.lut.cn/',298,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2103,'兰州交通大学','http://www.lzjtu.edu.cn/',298,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2104,'甘肃农业大学','http://www.gsau.edu.cn/',298,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2105,'甘肃省图书馆','http://www.gslib.com.cn/',298,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2106,'甘肃教育网','http://www.gsedu.com.cn/',298,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(2107,'青海省政府','http://www.qh.gov.cn/',299,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2108,'青海新闻网','http://www.qhnews.com/',299,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2109,'青海电视台','http://www.qhstv.com/',299,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2110,'青海人民广播电台','http://www.qhradio.com/',299,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2111,'青海藏语广播网','http://www.qhtb.cn/',299,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2112,'海南州','http://www.qhhn.gov.cn/',299,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2113,'海北州','http://www.qhhb.gov.cn/',299,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2114,'青海移动','http://www.qh.chinamobile.com/',300,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2115,'青海电信','http://qh.ct10000.com/',300,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2116,'青海联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010020&id=3200',300,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2117,'青海经济信息网','http://www.qhei.gov.cn/',300,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2118,'安全生产信息网','http://www.qhws.chinasafety.gov.cn/',300,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2119,'青海大学','http://www.qhu.edu.cn/',301,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2120,'青海民族大学','http://www.qhmu.edu.cn/',301,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2121,'青海师范大学','http://www.qhnu.edu.cn/',301,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2122,'青海人事考试信息网','http://www.qhpta.com/',301,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2123,'青海民族文化网','http://www.qhwh.gov.cn/',301,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2124,'雪域文化网','http://www.tonguer.net/',301,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2125,'青海体彩','http://lottery.sports.cn/provincesave/qinghai/list.html',302,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2126,'青海福彩','http://www.fulicaipiao.cn/qinghai/',302,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2127,'http://post.baidu.com/f?ct=&amp;tn=&amp;rn=&amp;pn=&amp;lm=&amp;sc=&amp;kw=西宁&amp;rs2=0&amp;myselectvalue=1&amp;word=西宁&amp;tb=on','http://post.baidu.com/f?ct=&tn=&rn=&pn=&lm=&sc=&kw=西宁&rs2=0&myselectvalue=1&word=西宁&tb=on',302,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2128,'西宁市','http://www.xining.gov.cn/',303,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2129,'青海省人事厅','http://www.qhrs.gov.cn/',303,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2130,'格尔木','http://www.gem.gov.cn/',303,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2131,'海西州','http://www.haixi.gov.cn/',303,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2132,'百度地图西宁','http://map.baidu.com/#word=西宁市&ct=10',303,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2133,'青海机场','http://www.8133333.com/',303,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2134,'桂经网','http://www.gxi.gov.cn/',304,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2135,'广西经济信息网','http://www.gx.cei.gov.cn/',304,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2136,'广西邮政','http://www.post.gx.cn/',304,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2137,'桂平在线','http://www.gp136.com/',304,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2138,'百色网址导航','http://www.07760.cn/',304,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2139,'玉林天天网','http://www.yulindayday.com/',304,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2140,'玉林都市网','http://www.0775.cc/',304,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2141,'广西人才网','http://www.gxrc.com/',305,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2142,'广西旅游在线','http://www.gxta.gov.cn/',306,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2143,'新桂网旅游频道','http://travel.gxnews.com.cn/',306,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2144,'广西人民医院','http://www.gxhospital.com/',307,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2145,'广西民族医院','http://www.gxmzyy.com/',307,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2146,'福利彩票发行中心','http://www.gxcaipiao.com.cn/',308,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2147,'广西体彩','http://tiyucaipiao.net/guangxi',308,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2148,'广西证券期货市场','http://www.sagx.org/',308,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2149,'广西新闻网(新桂网)','http://www.gxnews.com.cn/',309,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2150,'南宁日报','http://www.nnrb.com.cn/',309,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2151,'广西电视台','http://www.gxtv.cn/',309,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2152,'南国早报','http://ngzb.gxnews.com.cn/',309,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2153,'河池网','http://www.hcwang.cn/',309,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2154,'时空网','http://www.gxsky.com/',309,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2155,'百色视窗','http://www.bsptt.gx.cn/',309,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2156,'南宁电视台','http://www.nntv.com.cn/',309,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2157,'西南之窗','http://www.qz.gx.cn/',309,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(2158,'广西日报','http://www.gxrb.com.cn/',309,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(2159,'鸳江热线','http://www.wzptt.gx.cn/',309,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(2160,'桂林生活网','http://www.guilinlife.com/',309,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(2161,'柳州新闻网','http://www.lznews.gov.cn/',309,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(2162,'广西新闻网','http://www.newgx.com.cn/',309,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(2163,'新华网广西频道','http://www.gx.xinhuanet.com/',309,100,0,0,0,0,0,'','','',0,0,0,0,'',0),(2164,'广西交警网','http://www.gxjj.gov.cn/',310,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2165,'城市猎人网','http://www.citylr.cn/',310,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2166,'广西气象','http://www.gx121.com/',310,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2167,'广西移动','http://www.gx.chinamobile.com/',311,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2168,'广西联通网上营业厅','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010014&id=2409',311,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2169,'广西电信网上营业厅','http://gx.ct10000.com/',311,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2170,'广西互联星空','http://gx.vnet.cn/',311,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2171,'广西铁通','http://www.cttgx.com/',311,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2172,'广西房产街','http://www.gxhouse.com/',312,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2173,'搜房南宁','http://nn.soufun.com/',312,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2174,'南宁住房公积金网','http://www.nngjj.com/',312,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2175,'广西房产信息网','http://www.gxfdc.com.cn/',312,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2176,'广西大学','http://www.gxu.edu.cn/',313,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2177,'广西民族大学','http://www.gxun.edu.cn/',313,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2178,'广西招生考试院','http://www.gxeea.cn/',313,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2179,'南宁人事考试网','http://www.nnrkz.com/',313,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2180,'广西师范大学','http://www.gxnu.edu.cn/',313,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2181,'广西学生资助网','http://www.gxxszz.cn/',313,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2182,'广西教育网','http://www.gxem.cn/',313,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2183,'红豆社区','http://hongdou.gxnews.com.cn/',314,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2184,'广西贴吧','http://tieba.baidu.com/f?kw=%B9%E3%CE%F7',314,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2185,'南宁贴吧','http://tieba.baidu.com/f?kw=%C4%CF%C4%FE',314,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2186,'河池论坛','http://bbs.hc365.com/',314,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2187,'时空论坛','http://bbs.gxsky.com/',314,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2188,'桂林人论坛','http://bbs.guilinlife.com/',314,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2189,'贵港论坛','http://bbs.gg163.net/',314,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2190,'右江论坛','http://bbs.gxbs.net/',314,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2191,'早报论坛','http://bbs.ngzb.com.cn/',314,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(2192,'桂江社区','http://bbs.zpol.cn/',314,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(2193,'灵水论坛','http://www.gxwmbbs.com/',314,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(2194,'新平果论坛','http://www.xinpg.com/',314,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(2195,'玉林社区','http://bbs.ylyl.net/',314,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(2196,'钦州论坛360','http://bbs.qinzhou360.com/',314,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(2197,'河池发现网','http://www.gxhc.com/',314,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(2198,'左江网','http://www.zuojiang.com/',314,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(2199,'广西壮族自治区政府','http://www.gxzf.gov.cn/',315,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2200,'广西劳动和社会保障厅','http://www.gx.lss.gov.cn/',315,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2201,'贺州市','http://www.gxhz.gov.cn/',315,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2202,'河池市','http://www.gxhc.gov.cn/',315,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2203,'南宁市','http://www.nanning.gov.cn/',315,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2204,'柳州市','http://www.liuzhou.gov.cn/',315,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2205,'玉林市','http://www.yulin.gov.cn/',315,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2206,'广西国税局','http://www.gxgs.gov.cn/',315,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2207,'北海市','http://www.beihai.gov.cn/',315,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(2208,'广西财政厅','http://www.gxcz.gov.cn/',315,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(2209,'钦州市','http://www.qinzhou.gov.cn/',315,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(2210,'广西教育厅','http://www.gxedu.gov.cn/',315,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(2211,'广西发展改革委员会','http://www.gxdrc.gov.cn/',315,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(2212,'内蒙古新闻网','http://www.nmgnews.com.cn/',316,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2213,'通辽信息网','http://www.tlxxw.com/',316,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2214,'内蒙古电视台','http://www.nmtv.cn/',316,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2215,'呼和浩特信息港','http://www.hh.nm.cn/',316,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2216,'中国内蒙古','http://www.nmg.gov.cn/',316,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2217,'包头信息港','http://www.bt163.net/',316,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2218,'河套信息港','http://www.htcnc.net/',316,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2219,'呼伦贝尔日报','http://www.hlbrdaily.com.cn/',316,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2220,'蒙古文化','http://www.mgwhw.com/',316,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(2221,'乌海在线','http://www.ewuhai.com/',316,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(2222,'草原雄鹰网','http://www.burgud.com/',316,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(2223,'通辽信息港','http://www.nmtl.cn/',316,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(2224,'民族宗教网','http://www.nmgmzw.gov.cn/',316,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(2225,'内蒙古信息港','http://www.nmgxinxi.com/',316,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(2226,'呼和浩特天气预报','http://php.weather.sina.com.cn/search.php?city=呼和浩特',317,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2227,'列车时刻查询','http://huhehaote.8684.cn/',317,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2228,'内蒙古移动','http://www.nm.chinamobile.com/',318,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2229,'内蒙古联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010029&id=4042',318,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2230,'内蒙古电信','http://nm.ct10000.com/',318,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2231,'内蒙古人才网','http://www.nmrc.com.cn/',319,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2232,'呼和浩特人才网','http://www.hhhtrc.com/',319,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2233,'包头人才网','http://www.btrc.cn/',319,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2234,'内蒙古人事人才网','http://www.nmgrst.com/',319,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2235,'蒙牛','http://www.mengniu.com.cn/',320,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2236,'伊利','http://www.yili.com/',320,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2237,'内蒙古旅游信息网','http://www.nmtravel.net/',320,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2238,'内蒙古新闻网美食频道','http://eat.nmgnews.com.cn/',320,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2239,'内蒙古医学院','http://www.immc.edu.cn/',321,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2240,'内蒙古人事考试网','http://www.impta.com/',321,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2241,'内蒙古大学','http://www.imu.edu.cn/',321,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2242,'内蒙古师范大学','http://www.imnu.edu.cn/',321,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2243,'内蒙古工业大学','http://www.imut.edu.cn/',321,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2244,'内蒙古科技大学','http://www.imust.cn/',321,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2245,'内蒙古民族大学','http://www.imun.edu.cn/',321,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2246,'内蒙古财经学院','http://www.imfec.edu.cn/',321,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2247,'内蒙古农业大学','http://www.imau.edu.cn/',321,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(2248,'内蒙古贴吧','http://post.baidu.com/f?kw=%C4%DA%C3%C9%B9%C5',322,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2249,'呼和浩特吧','http://post.baidu.com/f?kw=%BA%F4%BA%CD%BA%C6%CC%D8',322,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2250,'内蒙古论坛','http://www.nmgood.cn/',322,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2251,'内蒙古福彩网','http://www.nmlottery.com.cn/',323,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2252,'内蒙古体彩','http://www.nmtc.com.cn/',323,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2253,'呼伦贝尔','http://www.hulunbeier.gov.cn/',324,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2254,'呼和浩特','http://www.huhhot.gov.cn/',324,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2255,'包头','http://www.baotou.gov.cn/',324,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2256,'兴安盟','http://www.xinganmeng.gov.cn/',324,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2257,'满洲里','http://www.manzhouli.gov.cn/',324,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2258,'赤峰','http://www.chifeng.gov.cn/',324,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2259,'锡林郭勒','http://www.xlgl.gov.cn/',324,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2260,'鄂尔多斯在线','http://www.ordos.gov.cn/',324,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2261,'巴彦淖尔','http://www.bynr.gov.cn/',324,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(2262,'乌海','http://www.wuhai.gov.cn/',324,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(2263,'国税局','http://www.nmgsj.gov.cn/',324,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(2264,'发改委','http://www.nmgfgw.gov.cn/',324,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(2265,'内蒙古广播网','http://www.nmrb.com.cn/',325,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2266,'内蒙古电视台','http://www.nmgtv.com.cn/',325,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2267,'内蒙古日报','http://news.nmgnews.com.cn/nmgrb/column/nmgrb',325,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2268,'内蒙古房产网','http://www.nmgfc.cn/',326,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2269,'内蒙古新闻网健康养生','http://news.nmgnews.com.cn/pdeb/column/jkys',327,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2270,'内蒙古自治区医院','http://www.nmgyy.cn/',327,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2271,'内蒙古天骄医院','http://www.nmgtjyy.com/',327,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2272,'医学院第二附属医院','http://www.nyefy.com/',327,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2273,'中国拉萨','http://www.lasa.gov.cn/',328,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2274,'藏人文化网','http://www.tibetcul.com/',328,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2275,'西藏在线','http://www.tibetonline.net/',328,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2276,'中国西藏信息中心','http://www.tibet.cn/',328,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2277,'中国西藏新闻网','http://www.chinatibetnews.com/',328,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2278,'那曲在线','http://www.naqu.net/',328,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2279,'中国藏族民俗网','http://www.tibetanct.com/',328,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2280,'西藏文化','http://www.tibet-web.com/',329,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2281,'百度知道-西藏','http://zhidao.baidu.com/browse/267',329,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2282,'西藏气象','http://www.weather.com.cn/html/province/xizang_list.shtml',329,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2283,'拉萨气象','http://www.cma.gov.cn/tqyb/weatherframe/55591/1.html',329,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2284,'中国西藏旅游','http://www.tibettour.org/',330,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2285,'西藏农牧信息网','http://xznm.agri.gov.cn/',331,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2286,'银川新闻网','http://www.ycen.com.cn/',332,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2287,'新消息报','http://szb.nxnet.cn/index2.aspx',332,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2288,'宁夏广播电视总台','http://www.nxtv.com.cn/',332,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2289,'宁夏日报','http://www.nxnet.net/',332,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2290,'宁夏新闻网','http://www.nxnews.net/',332,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2291,'宁夏信息港','http://www.nx.cninfo.net/',332,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2292,'新华网宁夏频道','http://www.nx.xinhuanet.com/',332,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2293,'人民网宁夏视窗','http://nx.people.com.cn/',332,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2294,'宁夏气象信息网','http://www.qx121.com.cn/',332,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(2295,'百度地图银川','http://map.baidu.com/#word=银川市&ct=10',332,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(2296,'银川机场航班查询','http://www.nxnews.net/fuwu/hangban.htm',332,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(2297,'宁夏互联星空','http://nx.vnet.cn/',332,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(2298,'宁夏新闻网健康频道','http://www.nxnews.net/health',332,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(2299,'宁夏电信','http://www.nx.ct10000.com/',333,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2300,'宁夏移动','http://www.nx.chinamobile.com/',333,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2301,'宁夏联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010028&id=2382',333,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2302,'宁夏铁通','http://www.cttnx.com/',333,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2303,'银川招聘会信息','http://zhidao.baidu.com/q?word=%D2%F8%B4%A8+%D5%D0%C6%B8&ct=17&pn=0&tn=ikaslist&rn=10',334,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2304,'宁夏毕业生就业网','http://www.nxbys.com/',334,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2305,'宁夏英才网','http://www.0951job.com/',334,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2306,'宁夏人才网','http://www.nxrc.com.cn/',334,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2307,'银川市房产管理局','http://www.ycre.gov.cn/',335,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2308,'银川房产网','http://www.ychfc.com/',335,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2309,'银川住房公积金网','http://www.ycgjj.com.cn/',335,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2310,'宁夏房产资讯网','http://www.nxf.cn/',335,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2311,'宁夏医科大学','http://www.nxmu.edu.cn/',336,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2312,'宁夏大学新华学院','http://xinhua.nxu.edu.cn/',336,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2313,'宁夏师范学院','http://www.nxtu.cn/',336,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2314,'中国矿业大学银川学院','http://www.cumtyc.com.cn/',336,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2315,'宁夏大学','http://www.nxu.edu.cn/',336,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2316,'宁夏人事考试中心','http://www.nxpta.gov.cn/',336,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2317,'宁夏教育网','http://www.nxycedu.com/',336,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2318,'宁夏教育考试院','http://www.nxks.nx.edu.cn/',336,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2319,'宁夏网虫','http://www.nx.cn/',337,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2320,'石嘴山贴吧','http://tieba.baidu.com/f?kw=石嘴山',337,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2321,'银川贴吧','http://tieba.baidu.com/f?kw=银川',337,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2322,'吴忠贴吧','http://tieba.baidu.com/f?kw=吴忠',337,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2323,'宁夏贴吧','http://tieba.baidu.com/f?kw=宁夏',337,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2324,'宁报论坛','http://bbs.nxnet.cn/',337,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2325,'蔓草社区','http://bbs.nxnews.net/forum',337,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2326,'宁夏职务犯罪预防网','http://www.nx.yfw.com.cn/',337,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2327,'银川市政府','http://www.yinchuan.gov.cn/',338,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2328,'宁夏工商','http://www.ngsh.gov.cn/',338,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2329,'宁夏回族自治区政府','http://www.nx.gov.cn/',338,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2330,'宁夏卫生网','http://www.nxws.gov.cn/',338,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2331,'宁夏体彩','http://lottery.yc.nx.cn/',338,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2332,'宁夏新闻网旅游频道','http://www.nxnews.net/travel',339,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2333,'宁夏风韵','http://tour.yc.nx.cn/',339,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2334,'宁夏旅游网','http://www.nxtour.com.cn/',339,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2335,'宁夏旅游政务网','http://www.nxta.gov.cn/',339,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2336,'宁夏信息港美食','http://soofan.yc.nx.cn/',339,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2337,'宁夏美食网','http://www.nxeat.com/',339,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2338,'宁夏美食在线','http://www.0951cate.com/',339,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2339,'宁夏医学院附属医院','http://nyfy.com.cn/',340,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2340,'宁夏福利彩票网','http://www.nxflcp.com/',341,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2341,'新疆新闻网','http://www.xjnews.cn/',342,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2342,'兵团新闻网','http://www.btnews.com.cn/',342,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2343,'新疆福利彩票','http://www.xjflcp.com/',343,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2344,'新疆体彩','http://lottery.sports.cn/provincesave/xinjiang/list.html',343,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2345,'乌鲁木齐公交','http://bus.mapbar.com/wulumuqi/',344,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2346,'新疆移动','http://www.xj.chinamobile.com/',345,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2347,'新疆联通','http://info2.10010.com/lt/plugin/portal/arealevel/queryCityInfo.do?arno=00010021&id=3255',345,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2348,'新疆电信','http://xj.ct10000.com/',345,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2349,'百度知道-新疆','http://zhidao.baidu.com/browse/268',346,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2350,'新疆教育网','http://www.xjedunet.com/',347,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2351,'新疆师范大学','http://www.xjnu.edu.cn/',347,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2352,'石河子大学','http://www.shzu.edu.cn/',347,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2353,'新疆财经大学','http://www.xjufe.edu.cn/',347,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2354,'新疆大学','http://www.xju.edu.cn/',347,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2355,'塔里木大学','http://www.taru.edu.cn/',347,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2356,'新疆医科大学','http://www.xjmu.org/',347,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2357,'新疆天山职业技术学院','http://www.xjtsxy.cn/',347,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2358,'新疆农业职业技术学院','http://www.xjnzy.edu.cn/',347,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(2359,'喀什师范学院','http://www.kstc.edu.cn/',347,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(2360,'新疆农业大学','http://www.xjau.edu.cn/',347,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(2361,'翡翠电视台','http://jade.tvb.com/',348,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(2362,'香港商报','http://www.hkcd.com.hk/',348,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(2363,'有线电视台','http://www.wharfcable.com/',348,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2364,'google香港','http://www.google.com.hk/',348,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2365,'TVB香港电视广播公司','http://www.tvb.com/',348,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2366,'MSN香港','http://hk.msn.com/',348,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2367,'香港文汇报','http://www.wenweipo.com/',348,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2368,'华娱卫视','http://www.cetv.com/',348,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2369,'凤凰网','http://www.ifeng.com/',348,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2370,'大公网','http://www.takungpao.com/',348,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2371,'中原地图','http://www.centamap.com/',348,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(2372,'now.com','http://now.com.hk/',348,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(2373,'香港海洋公园','http://www.oceanpark.com.hk/',349,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2374,'香港气象','http://www.weather.com.hk/',349,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2375,'九龙巴士路线搜寻','http://www.kmb.com.hk/chinese.php?page=search',349,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2376,'香港天文台','http://gb.weather.gov.hk/',349,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2377,'香港国际机场','http://www.hongkongairport.com/',349,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2378,'香港卫星地图(google)','http://maps.google.com/maps?f=q&hl=zh-CN&q=hong+kong&ie=UTF8&ll=22.285701,114.150009&spn=0.013462,0.026522&t=k&om=1',349,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2379,'香港特别行政区政府','http://www.gov.hk/',350,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2380,'香港廉政公署','http://www.icac.org.hk/',350,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2381,'香港劳工处','http://www.jobs.gov.hk/',350,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2382,'電訊盈科宽频','http://www.netvigator.com/',351,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2383,'香港迪斯尼乐园','http://www.hongkongdisneyland.com/',351,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2384,'百老汇戏院','http://www.cinema.com.hk/',351,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2385,'香港电影金像奖','http://www.hkfaa.com/',351,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2386,'香港恒生银行','http://www.hangseng.com/',352,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2387,'香港汇丰银行','http://www.hsbc.com.hk/hk/chinese/home/',352,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2388,'财华网','http://www.finet.hk/',352,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2389,'阿斯达克财经网','http://www.aastocks.com/',352,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2390,'香港经济网','http://www.hkfe.hk/',352,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2391,'香港城市大学','http://www.cityu.edu.hk/',353,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2392,'香港大学','http://www.hku.hk/',353,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2393,'香港中文大学','http://www.cuhk.edu.hk/',353,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2394,'香港浸會大學','http://www.hkbu.edu.hk/',353,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2395,'香港理工大学','http://www.polyu.edu.hk/',353,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2396,'香港科技大学','http://www.ust.hk/',353,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2397,'香港教育城','http://www.hkedcity.net/',353,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2398,'香港电影学院','http://www.hkfilm.com/',353,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2399,'ebay香港','http://www.ebay.com.hk/',354,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2400,'香港餐厅','http://www.openrice.com/',354,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2401,'香港自由贸易区','http://www.fta.hk/',354,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2402,'香港人才网','http://www.hkjob.net/',355,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2403,'澳门日报','http://www.macaodaily.com/',356,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2404,'澳门广播电视公司','http://www.tdm.com.mo/',356,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2405,'澳门城市指南','http://gb.cityguide.gov.mo/',356,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2406,'澳门气象','http://www.smg.gov.mo/',356,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2407,'澳门华侨报','http://www.vakiodaily.com/',356,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2408,'澳门互联','http://www.qoos.com/',356,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2409,'澳门黄页','http://www.yp.com.mo/',356,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2410,'极动感','http://www.cyberctm.com/',356,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2411,'澳门卫星地图','http://maps.google.com/maps?f=q&hl=zh-CN&q=macau&ie=UTF8&ll=22.198849,113.544044&spn=0.215519,0.42057&t=h&om=1',357,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2412,'澳门航空','http://www.airmacau.com.mo/',357,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2413,'澳门街资讯网','http://www.macaustreet.com/',357,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2414,'澳门国际银行','http://www.lusobank.com.mo/',357,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2415,'澳门大学','http://www.umac.mo/',358,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2416,'澳门理工学院','http://www.ipm.edu.mo/',358,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2417,'澳门科技大学','http://www.must.edu.mo/',358,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2418,'亚洲国际公开大学','http://www.aiou.edu/',358,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2419,'澳门中央图书馆','http://www.library.gov.mo/',358,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2420,'澳门文化中心','http://www.ccm.gov.mo/',358,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2421,'澳门特别行政区政府','http://www.gov.mo/',359,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2422,'澳门保安部队','http://www.fsm.gov.mo/',359,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2423,'澳门艺术博物馆','http://www.artmuseum.gov.mo/',359,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2424,'澳门法务局','http://www.dsaj.gov.mo/',359,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2425,'澳门卫生局','http://www.ssm.gov.mo/',359,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2426,'澳门旅游网','http://www.macautvl.com/',360,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2427,'澳门海关','http://www.customs.gov.mo/',360,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2428,'澳门赛马会','http://www.macauhorse.com/',360,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2429,'澳门彩票公司','http://www.macauslot.com/',361,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2430,'PChome Online','http://www.pchome.com.tw/',362,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2431,'东森新闻','http://www.nownews.com/',362,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2432,'番薯藤','http://www.yam.com/',362,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2433,'HiNet','http://www.hinet.net/',362,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2434,'TTV台视资讯网','http://www.ttv.com.tw/',362,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2435,'新浪台湾站','http://www.sina.com.tw/',362,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2436,'中国台湾网','http://www.chinataiwan.org/',362,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2437,'中央日报','http://www.cdnews.com.tw/',362,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2438,'中国电视公司','http://www.ctv.com.tw/',362,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(2439,'联合新闻网','http://www.udn.com/',362,10,0,0,0,0,0,'','','',0,0,0,0,'',0),(2440,'TVBS','http://www.tvbs.com.tw/',362,11,0,0,0,0,0,'','','',0,0,0,0,'',0),(2441,'中国时报','http://www.chinatimes.com.tw/',362,12,0,0,0,0,0,'','','',0,0,0,0,'',0),(2442,'CCTV台湾频道','http://www.cctv.com/taiwan',362,13,0,0,0,0,0,'','','',0,0,0,0,'',0),(2443,'你好台湾','http://www.nihaotw.com/',362,14,0,0,0,0,0,'','','',0,0,0,0,'',0),(2444,'黑秀网','http://www.heyshow.com.tw/',362,15,0,0,0,0,0,'','','',0,0,0,0,'',0),(2445,'seed','http://www.seed.net.tw/',362,16,0,0,0,0,0,'','','',0,0,0,0,'',0),(2446,'PChome 像薄','http://photo.pchome.com.tw/',363,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2447,'mobile01','http://www.mobile01.com/',363,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2448,'中国信托商业银行','http://www.chinatrust.com.tw/',363,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2449,'中华职业棒球联盟','http://www.cpbl.com.tw/',363,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2450,'宝贝家庭亲子网','http://www.babyhome.com.tw/',363,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2451,'1111人力银行','http://www.1111.com.tw/',363,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2452,'台湾电子地图','http://www.map.com.tw/',364,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2453,'台湾气象','http://www.cwb.gov.tw/',364,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2454,'台湾卫星地图（google）','http://maps.google.com/?ie=UTF8&ll=23.699865,120.910034&spn=3.409859,4.938354&t=k&om=1',364,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2455,'中华航空公司','http://www.china-airlines.com/',364,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2456,'中央大学','http://www.ncu.edu.tw/',365,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2457,'交通大学','http://www.nctu.edu.tw/',365,2,0,0,0,0,0,'','','',0,0,0,0,'',0),(2458,'台湾大学','http://www.ntu.edu.tw/',365,3,0,0,0,0,0,'','','',0,0,0,0,'',0),(2459,'中山大学','http://www.nsysu.edu.tw/',365,4,0,0,0,0,0,'','','',0,0,0,0,'',0),(2460,'清华大学','http://www.nthu.edu.tw/',365,5,0,0,0,0,0,'','','',0,0,0,0,'',0),(2461,'台湾科技大学','http://www.ntust.edu.tw/',365,6,0,0,0,0,0,'','','',0,0,0,0,'',0),(2462,'东吴大学','http://www.scu.edu.tw/',365,7,0,0,0,0,0,'','','',0,0,0,0,'',0),(2463,'台北市教育入口网','http://www.tp.edu.tw/',365,8,0,0,0,0,0,'','','',0,0,0,0,'',0),(2464,'台湾图书馆','http://www.ncl.edu.tw/',365,9,0,0,0,0,0,'','','',0,0,0,0,'',0),(2465,'雄狮旅游网','http://www.liontravel.com/',366,1,0,0,0,0,0,'','','',0,0,0,0,'',0),(2466,'台湾旅游网','http://www.travel-web.com.tw/',366,2,0,0,0,0,0,'','','',0,0,0,0,'',0);

/*Table structure for table `uchome_log` */

DROP TABLE IF EXISTS `uchome_log`;

CREATE TABLE `uchome_log` (
  `logid` mediumint(8) unsigned NOT NULL auto_increment,
  `id` mediumint(8) unsigned NOT NULL default '0',
  `idtype` char(20) NOT NULL default '',
  PRIMARY KEY  (`logid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_log` */

/*Table structure for table `uchome_magic` */

DROP TABLE IF EXISTS `uchome_magic`;

CREATE TABLE `uchome_magic` (
  `mid` varchar(15) NOT NULL default '',
  `name` varchar(30) NOT NULL default '',
  `description` text NOT NULL,
  `forbiddengid` text NOT NULL,
  `charge` smallint(6) unsigned NOT NULL default '0',
  `experience` smallint(6) unsigned NOT NULL default '0',
  `provideperoid` int(10) unsigned NOT NULL default '0',
  `providecount` smallint(6) unsigned NOT NULL default '0',
  `useperoid` int(10) unsigned NOT NULL default '0',
  `usecount` smallint(6) unsigned NOT NULL default '0',
  `displayorder` smallint(6) unsigned NOT NULL default '0',
  `custom` text NOT NULL,
  `close` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`mid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_magic` */

insert  into `uchome_magic`(`mid`,`name`,`description`,`forbiddengid`,`charge`,`experience`,`provideperoid`,`providecount`,`useperoid`,`usecount`,`displayorder`,`custom`,`close`) values ('invisible','隐身草','让自己隐身登录，不显示在线，24小时内有效','',50,5,86400,10,86400,1,0,'',0),('friendnum','好友增容卡','在允许添加的最多好友数限制外，增加10个好友名额','',30,3,86400,999,0,1,0,'',0),('attachsize','附件增容卡','使用一次，可以给自己增加 10M 的附件空间','',30,3,86400,999,0,1,0,'',0),('thunder','雷鸣之声','发布一条全站信息，让大家知道自己上线了','',500,5,86400,5,86400,1,0,'',0),('updateline','救生圈','把指定对象的发布时间更新为当前时间','',200,5,86400,999,0,1,0,'',0),('downdateline','时空机','把指定对象的发布时间修改为过去的时间','',250,5,86400,999,0,1,0,'',0),('color','彩色灯','把指定对象的标题变成彩色的','',50,5,86400,999,0,1,0,'',0),('hot','热点灯','把指定对象的热度增加站点推荐的热点值','',50,5,86400,999,0,1,0,'',0),('visit','互访卡','随机选择10个好友，向其打招呼、留言或访问空间','',20,2,86400,999,0,1,0,'',0),('icon','彩虹蛋','给指定对象的标题前面增加图标（最多8个图标）','',20,2,86400,999,0,1,0,'',0),('flicker','彩虹炫','让评论、留言的文字闪烁起来','',30,3,86400,999,0,1,0,'',0),('gift','红包卡','在自己的空间埋下积分红包送给来访者','',20,2,86400,999,0,1,0,'',0),('superstar','超级明星','在个人主页，给自己的头像增加超级明星标识','',30,3,86400,999,0,1,0,'',0),('viewmagiclog','八卦镜','查看指定用户最近使用的道具记录','',100,5,86400,999,0,1,0,'',0),('viewmagic','透视镜','查看指定用户当前持有的道具','',100,5,86400,999,0,1,0,'',0),('viewvisitor','偷窥镜','查看指定用户最近访问过的10个空间','',100,5,86400,999,0,1,0,'',0),('call','点名卡','发通知给自己的好友，让他们来查看指定的对象','',50,5,86400,999,0,1,0,'',0),('coupon','代金券','购买道具时折换一定量的积分','',0,0,0,0,0,1,0,'',0),('frame','相框','给自己的照片添上相框','',30,3,86400,999,0,1,0,'',0),('bgimage','信纸','给指定的对象添加信纸背景','',30,3,86400,999,0,1,0,'',0),('doodle','涂鸦板','允许在留言、评论等操作时使用涂鸦板','',30,3,86400,999,0,1,0,'',0),('anonymous','匿名卡','在指定的地方，让自己的名字显示为匿名','',50,5,86400,999,0,1,0,'',0),('reveal','照妖镜','可以查看一次匿名用户的真实身份','',100,5,86400,999,0,1,0,'',0),('license','道具转让许可证','使用许可证，将道具赠送给指定好友','',10,1,3600,999,0,1,0,'',0),('detector','探测器','探测埋了红包的空间','',10,1,86400,999,0,1,0,'',0);

/*Table structure for table `uchome_magicinlog` */

DROP TABLE IF EXISTS `uchome_magicinlog`;

CREATE TABLE `uchome_magicinlog` (
  `logid` mediumint(8) unsigned NOT NULL auto_increment,
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(15) NOT NULL default '',
  `mid` varchar(15) NOT NULL default '',
  `count` smallint(6) unsigned NOT NULL default '0',
  `type` tinyint(3) unsigned NOT NULL default '0',
  `fromid` mediumint(8) unsigned NOT NULL default '0',
  `credit` smallint(6) unsigned NOT NULL default '0',
  `dateline` int(10) NOT NULL default '0',
  PRIMARY KEY  (`logid`),
  KEY `uid` (`uid`,`dateline`),
  KEY `type` (`type`,`fromid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_magicinlog` */

/*Table structure for table `uchome_magicstore` */

DROP TABLE IF EXISTS `uchome_magicstore`;

CREATE TABLE `uchome_magicstore` (
  `mid` varchar(15) NOT NULL default '',
  `storage` smallint(6) unsigned NOT NULL default '0',
  `lastprovide` int(10) unsigned NOT NULL default '0',
  `sellcount` int(8) unsigned NOT NULL default '0',
  `sellcredit` int(8) unsigned NOT NULL default '0',
  PRIMARY KEY  (`mid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_magicstore` */

insert  into `uchome_magicstore`(`mid`,`storage`,`lastprovide`,`sellcount`,`sellcredit`) values ('invisible',10,1264698342,0,0),('friendnum',999,1264698342,0,0),('attachsize',999,1264698342,0,0),('thunder',5,1264698342,0,0),('updateline',999,1264698342,0,0),('downdateline',999,1264698342,0,0),('color',999,1264698342,0,0),('hot',999,1264698342,0,0),('visit',999,1264698342,0,0),('icon',999,1264698342,0,0),('flicker',999,1264698342,0,0),('gift',999,1264698342,0,0),('superstar',999,1264698342,0,0),('viewmagiclog',999,1264698342,0,0),('viewmagic',999,1264698342,0,0),('viewvisitor',999,1264698342,0,0),('call',999,1264698342,0,0),('frame',999,1264698342,0,0),('bgimage',999,1264698342,0,0),('doodle',999,1264698342,0,0),('anonymous',999,1264698342,0,0),('reveal',999,1264698342,0,0),('license',999,1264698342,0,0),('detector',999,1264698342,0,0);

/*Table structure for table `uchome_magicuselog` */

DROP TABLE IF EXISTS `uchome_magicuselog`;

CREATE TABLE `uchome_magicuselog` (
  `logid` mediumint(8) unsigned NOT NULL auto_increment,
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(15) NOT NULL default '',
  `mid` varchar(15) NOT NULL default '',
  `id` mediumint(8) unsigned NOT NULL default '0',
  `idtype` varchar(20) NOT NULL default '',
  `count` mediumint(8) unsigned NOT NULL default '0',
  `data` text NOT NULL,
  `dateline` int(10) unsigned NOT NULL default '0',
  `expire` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`logid`),
  KEY `uid` (`uid`,`mid`),
  KEY `id` (`id`,`idtype`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_magicuselog` */

/*Table structure for table `uchome_mailcron` */

DROP TABLE IF EXISTS `uchome_mailcron`;

CREATE TABLE `uchome_mailcron` (
  `cid` mediumint(8) unsigned NOT NULL auto_increment,
  `touid` mediumint(8) unsigned NOT NULL default '0',
  `email` varchar(100) NOT NULL default '',
  `sendtime` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`cid`),
  KEY `sendtime` (`sendtime`)
) ENGINE=MyISAM AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_mailcron` */

/*Table structure for table `uchome_mailqueue` */

DROP TABLE IF EXISTS `uchome_mailqueue`;

CREATE TABLE `uchome_mailqueue` (
  `qid` mediumint(8) unsigned NOT NULL auto_increment,
  `cid` mediumint(8) unsigned NOT NULL default '0',
  `subject` text NOT NULL,
  `message` text NOT NULL,
  `dateline` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`qid`),
  KEY `mcid` (`cid`,`dateline`)
) ENGINE=MyISAM AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_mailqueue` */

/*Table structure for table `uchome_member` */

DROP TABLE IF EXISTS `uchome_member`;

CREATE TABLE `uchome_member` (
  `uid` mediumint(8) unsigned NOT NULL auto_increment,
  `username` char(32) NOT NULL default '',
  `name` char(15) NOT NULL default '',
  `password` char(32) NOT NULL default '',
  PRIMARY KEY  (`uid`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_member` */

insert  into `uchome_member`(`uid`,`username`,`name`,`password`) values (1,'admin','管理员','3ae32bf5585875741ee5cfff84de8392'),(2,'ramen','','ff1e6b936ed5016cf806c604402ec7f9'),(3,'lele','','6ecf944980d2f3b63c04632ce496c9e5'),(4,'osk','','9ae4216491ae082016dbd7ec34a9663b'),(5,'moyiqun','','8ce7683f4991ba5a70c70af30a0836e3'),(6,'myqsq@sohu.com','','2e0e120c0247ce280436b2bb4c8b4ae1'),(7,'myq@gmail.com','','b7ad493e80d87758456a86a39553e7a3'),(8,'ra@123.com','','c59041763d6bf8d01ad60fed883898dd'),(9,'ra1@123.com','','7d8bbebde5f6eef1963a10a1032b23f1'),(10,'ramen.sh@gmail.com','城市森林','b4f248ca9a48ff6359b60a51111458fc');

/*Table structure for table `uchome_mingzhan` */

DROP TABLE IF EXISTS `uchome_mingzhan`;

CREATE TABLE `uchome_mingzhan` (
  `id` int(11) NOT NULL auto_increment,
  `class` tinyint(2) NOT NULL default '1',
  `name` varchar(50) NOT NULL COMMENT '????',
  `url` varchar(255) NOT NULL COMMENT 'url???',
  `namecolor` char(7) NOT NULL COMMENT '???????',
  `good` tinyint(1) NOT NULL default '0',
  `displayorder` mediumint(8) NOT NULL COMMENT '??????',
  `starttime` int(10) NOT NULL default '0' COMMENT '??????',
  `endtime` int(10) NOT NULL default '0' COMMENT '???????',
  `remark` text NOT NULL COMMENT '???',
  `day` int(11) NOT NULL default '0',
  `yesterday` int(11) NOT NULL default '0',
  `byesterday` int(11) NOT NULL default '0',
  `week` int(11) NOT NULL default '0',
  `month` int(11) NOT NULL default '0',
  `total` int(11) NOT NULL default '0',
  `end` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `name` (`name`),
  KEY `starttime` (`starttime`),
  KEY `endtime` (`endtime`)
) ENGINE=MyISAM AUTO_INCREMENT=76 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_mingzhan` */

insert  into `uchome_mingzhan`(`id`,`class`,`name`,`url`,`namecolor`,`good`,`displayorder`,`starttime`,`endtime`,`remark`,`day`,`yesterday`,`byesterday`,`week`,`month`,`total`,`end`) values (2,1,'Google搜索','http://www.google.cn/webhp?prog=aff&client=pub-0194889602661524','',0,1,0,0,'',0,0,0,0,0,0,0),(3,1,'中国雅虎','http://cn.yahoo.com/?id=40020','#178517',0,3,0,0,'',0,0,0,0,0,0,0),(4,1,'MSN中文网','http://cn.msn.com/','',0,4,0,0,'',0,0,0,0,0,0,0),(5,1,'中国政府网','http://www.gov.cn/','',0,10,0,0,'',0,0,0,0,0,0,0),(6,1,'环球时报','http://www.huanqiu.com/','',0,5,0,0,'',0,0,0,0,0,0,0),(7,1,'凤 凰 网','http://www.ifeng.com/','',0,6,0,0,'',0,0,0,0,0,0,0),(8,1,'115聚合搜索','http://115.com','',0,2,0,0,'',0,0,0,0,0,0,0),(9,1,'新 华 网','http://www.xinhuanet.com/','',0,8,0,0,'',0,0,0,0,0,0,0),(10,1,'人 民 网','http://www.people.com.cn/','',0,9,0,0,'',0,0,0,0,0,0,0),(11,1,'阿里巴巴','http://china.alibaba.com/','',0,11,0,0,'',0,0,0,0,0,0,0),(12,1,'慧 聪 网','http://www.hc360.com/','',0,12,0,0,'',0,0,0,0,0,0,0),(13,1,'淘宝特卖','http://pindao.huoban.taobao.com/channel/channelCode.htm?pid=mm_11140156_0_0','',0,13,0,0,'',0,0,0,0,0,0,0),(14,1,'易趣购物','http://promotion.eachnet.com/09q2ad/?adid=bjmt_mta_01_0_hp_25828','',0,14,0,0,'',0,0,0,0,0,0,0),(15,1,'卓越购物','http://spcode.baidu.com/spcode/spClick?tn=uc_sp&ctn=0&styleid=1&tourl=http://www.amazon.cn?source=uapcpa_uc_sp','',0,15,0,0,'',0,0,0,0,0,0,0),(16,1,'在线杀毒','http://aq.115.com/','',0,42,0,0,'',0,0,0,0,0,0,0),(17,1,'携程旅行','http://www.ctrip.com/smartlink/smartlink.asp?c=114la&url=http://www.ctrip.com/','',0,17,0,0,'',0,0,0,0,0,0,0),(19,1,'搜房网','http://www.soufun.com/','',0,19,0,0,'',0,0,0,0,0,0,0),(21,1,'爱丽女性网','http://www.27.cn/','',0,21,0,0,'',0,0,0,0,0,0,0),(22,1,'东方财富','http://www.eastmoney.com/','#ff6600',0,22,0,0,'',0,0,0,0,0,0,0),(24,1,'金山毒霸','http://www.duba.net/','',0,28,0,0,'',0,0,0,0,0,0,0),(25,1,'太平洋电脑网','http://www.pconline.com.cn/','',0,25,0,0,'',0,0,0,0,0,0,0),(26,1,'绿色下载吧','http://www.xiazaiba.com/','',0,26,0,0,'',0,0,0,0,0,0,0),(27,1,'招商银行','http://www.cmbchina.com/','',0,27,0,0,'',0,0,0,0,0,0,0),(28,1,'焦点房产网','http://house.focus.cn/','',0,33,0,0,'',0,0,0,0,0,0,0),(29,1,'人人网','http://wwv.renren.com/xn.do?ss=17002&rt=50&b=25828','',0,29,0,0,'',0,0,0,0,0,0,0),(30,1,'中国移动','http://www.chinamobile.com/','',0,30,0,0,'',0,0,0,0,0,0,0),(31,1,'天涯社区','http://www.tianya.cn/','',0,32,0,0,'',0,0,0,0,0,0,0),(33,1,'淘 宝 网','http://www.taobao.com/','',0,23,0,0,'',0,0,0,0,0,0,0),(34,1,'NBA中文网','http://china.nba.com/','',0,35,0,0,'',0,0,0,0,0,0,0),(35,1,'当当网购物','http://spcode.baidu.com/spcode/spClick?tn=uc_sp&ctn=0&styleid=1&tourl=http://union.dangdang.com/transfer/transfer.aspx?from=P-267723-uc_sp&backurl=http://www.dangdang.com','',0,20,0,0,'',0,0,0,0,0,0,0),(38,1,'天天基金','http://www.1234567.com.cn/','',0,24,0,0,'',0,0,0,0,0,0,0),(40,1,'中央电视台','http://www.cctv.com/','',0,7,0,0,'',0,0,0,0,0,0,0),(46,1,'逛街网','http://www.togj.com/','',0,41,0,0,'',0,0,0,0,0,0,0),(47,1,'白社会','http://stbnnr.allyes.com/bnnr/114la_baishehui.html','',0,45,0,0,'',0,0,0,0,0,0,0),(48,1,'创业商机网','http://spcode.baidu.com/spcode/spClick?tn=uc_sp&ctn=0&styleid=3338&tourl=http://www.28.com/?comeID=96888','',0,43,0,0,'',0,0,0,0,0,0,0),(49,1,'校内网','http://www.xiaonei.com/','',0,34,0,0,'',0,0,0,0,0,0,0),(52,1,'起点小说网','http://www.qidian.com/newindex.aspx?db=101&adid=1006&type=client','',0,18,0,0,'',0,0,0,0,0,0,0),(54,1,'39健康网','http://www.39.net/','',0,16,0,0,'',0,0,0,0,0,0,0),(59,1,'免费电影','http://www.tom365.com/','',0,44,0,0,'',0,0,0,0,0,0,0),(65,1,'4399小游戏','http://www.4399.com/?114la','',0,32,0,0,'',0,0,0,0,0,0,0),(66,2,'搜狐新闻','http://news.sohu.com','',0,1,0,0,'',0,0,0,0,0,0,0),(67,6,'上网速度测试 ','http://tool.115.com/?ct=live&ac=speed','',0,1,0,0,'',0,0,0,0,0,0,0),(68,6,'手机位置查询 ','http://tool.115.com/?ct=live&ac=mobile','',0,2,0,0,'',0,0,0,0,0,0,0),(69,6,'I P 地址速查 ','http://tool.115.com/?ct=live&ac=ip','',0,3,0,0,'',0,0,0,0,0,0,0),(70,6,'北京时间校对 ','http://bjtime.cn/','',0,4,0,0,'',0,0,0,0,0,0,0),(71,6,'火车时刻查询 ','http://tool.115.com/?ct=traffic&ac=train','',0,5,0,0,'',0,0,0,0,0,0,0),(72,6,'天气预报查询 ','http://weather.114la.com/weather.htm','',0,6,0,0,'',0,0,0,0,0,0,0),(73,6,'万年历查询表 ','http://tool.115.com/?ct=live&ac=calendar','',0,7,0,0,'',0,0,0,0,0,0,0),(74,6,'邮编区号查询 ','http://tool.115.com/?ct=live&ac=zip','',0,8,0,0,'',0,0,0,0,0,0,0),(75,6,'身份证号查询 ','http://tool.115.com/?ct=live&ac=idcard','',0,9,0,0,'',0,0,0,0,0,0,0);

/*Table structure for table `uchome_mtag` */

DROP TABLE IF EXISTS `uchome_mtag`;

CREATE TABLE `uchome_mtag` (
  `tagid` mediumint(8) unsigned NOT NULL auto_increment,
  `tagname` varchar(40) NOT NULL default '',
  `fieldid` smallint(6) NOT NULL default '0',
  `membernum` mediumint(8) unsigned NOT NULL default '0',
  `threadnum` mediumint(8) unsigned NOT NULL default '0',
  `postnum` mediumint(8) unsigned NOT NULL default '0',
  `close` tinyint(1) NOT NULL default '0',
  `announcement` text NOT NULL,
  `pic` varchar(150) NOT NULL default '',
  `closeapply` tinyint(1) NOT NULL default '0',
  `joinperm` tinyint(1) NOT NULL default '0',
  `viewperm` tinyint(1) NOT NULL default '0',
  `threadperm` tinyint(1) NOT NULL default '0',
  `postperm` tinyint(1) NOT NULL default '0',
  `recommend` tinyint(1) NOT NULL default '0',
  `moderator` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`tagid`),
  KEY `tagname` (`tagname`),
  KEY `threadnum` (`threadnum`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_mtag` */

/*Table structure for table `uchome_mtaginvite` */

DROP TABLE IF EXISTS `uchome_mtaginvite`;

CREATE TABLE `uchome_mtaginvite` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `tagid` mediumint(8) unsigned NOT NULL default '0',
  `fromuid` mediumint(8) unsigned NOT NULL default '0',
  `fromusername` char(15) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`uid`,`tagid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_mtaginvite` */

/*Table structure for table `uchome_myapp` */

DROP TABLE IF EXISTS `uchome_myapp`;

CREATE TABLE `uchome_myapp` (
  `appid` mediumint(8) unsigned NOT NULL default '0',
  `appname` varchar(60) NOT NULL default '',
  `narrow` tinyint(1) NOT NULL default '0',
  `flag` tinyint(1) NOT NULL default '0',
  `version` mediumint(8) unsigned NOT NULL default '0',
  `displaymethod` tinyint(1) NOT NULL default '0',
  `displayorder` smallint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`appid`),
  KEY `flag` (`flag`,`displayorder`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_myapp` */

/*Table structure for table `uchome_myinvite` */

DROP TABLE IF EXISTS `uchome_myinvite`;

CREATE TABLE `uchome_myinvite` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `typename` varchar(100) NOT NULL default '',
  `appid` mediumint(8) NOT NULL default '0',
  `type` tinyint(1) NOT NULL default '0',
  `fromuid` mediumint(8) unsigned NOT NULL default '0',
  `touid` mediumint(8) unsigned NOT NULL default '0',
  `myml` text NOT NULL,
  `dateline` int(10) unsigned NOT NULL default '0',
  `hash` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `hash` (`hash`),
  KEY `uid` (`touid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_myinvite` */

/*Table structure for table `uchome_notification` */

DROP TABLE IF EXISTS `uchome_notification`;

CREATE TABLE `uchome_notification` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `type` varchar(20) NOT NULL default '',
  `new` tinyint(1) NOT NULL default '0',
  `authorid` mediumint(8) unsigned NOT NULL default '0',
  `author` varchar(15) NOT NULL default '',
  `note` text NOT NULL,
  `dateline` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `uid` (`uid`,`new`,`dateline`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_notification` */

insert  into `uchome_notification`(`id`,`uid`,`type`,`new`,`authorid`,`author`,`note`,`dateline`) values (1,3,'blogcomment',1,1,'admin','评论了你的日志 <a href=\"space.php?uid=3&do=blog&id=24&cid=1\" target=\"_blank\">用户栈开始内容</a>',1264768714);

/*Table structure for table `uchome_pic` */

DROP TABLE IF EXISTS `uchome_pic`;

CREATE TABLE `uchome_pic` (
  `picid` mediumint(8) NOT NULL auto_increment,
  `albumid` mediumint(8) unsigned NOT NULL default '0',
  `topicid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(15) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `postip` varchar(20) NOT NULL default '',
  `filename` varchar(100) NOT NULL default '',
  `title` varchar(255) NOT NULL default '',
  `type` varchar(20) NOT NULL default '',
  `size` int(10) unsigned NOT NULL default '0',
  `filepath` varchar(60) NOT NULL default '',
  `thumb` tinyint(1) NOT NULL default '0',
  `remote` tinyint(1) NOT NULL default '0',
  `hot` mediumint(8) unsigned NOT NULL default '0',
  `click_6` smallint(6) unsigned NOT NULL default '0',
  `click_7` smallint(6) unsigned NOT NULL default '0',
  `click_8` smallint(6) unsigned NOT NULL default '0',
  `click_9` smallint(6) unsigned NOT NULL default '0',
  `click_10` smallint(6) unsigned NOT NULL default '0',
  `magicframe` tinyint(6) NOT NULL default '0',
  PRIMARY KEY  (`picid`),
  KEY `albumid` (`albumid`,`dateline`),
  KEY `topicid` (`topicid`,`dateline`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_pic` */

insert  into `uchome_pic`(`picid`,`albumid`,`topicid`,`uid`,`username`,`dateline`,`postip`,`filename`,`title`,`type`,`size`,`filepath`,`thumb`,`remote`,`hot`,`click_6`,`click_7`,`click_8`,`click_9`,`click_10`,`magicframe`) values (1,1,0,1,'admin',1258952152,'192.168.115.1','080723092358.jpg','','image/pjpeg',13669,'200911/23/1_12589521521UBz.jpg',0,0,0,0,0,0,0,0,0),(2,1,0,1,'admin',1264944904,'192.168.115.1','185984.jpg','','image/pjpeg',271216,'201001/31/1_1264944904t7CL.jpg',0,0,0,0,0,0,0,0,0),(3,1,0,1,'admin',1264944905,'192.168.115.1','185989.jpg','','image/pjpeg',279804,'201001/31/1_1264944905DC86.jpg',0,0,0,0,0,0,0,0,0),(4,1,0,1,'admin',1264944905,'192.168.115.1','185992.jpg','','image/pjpeg',216073,'201001/31/1_126494490556TT.jpg',0,0,0,0,0,0,0,0,0),(5,1,0,1,'admin',1264944906,'192.168.115.1','185993.jpg','','image/pjpeg',454619,'201001/31/1_1264944906EvcE.jpg',0,0,0,0,0,0,0,0,0),(6,0,0,1,'admin',1267626956,'192.168.115.1','20041126956069-2800.gif','','image/gif',44744,'201003/3/1_1267626956toRT.gif',0,0,0,0,0,0,0,0,0),(7,0,0,1,'admin',1267633349,'192.168.115.1','baidu_logo.gif','','image/gif',1489,'201003/3/1_1267633349GS3Q.gif',0,0,0,0,0,0,0,0,0),(8,0,0,1,'admin',1267633441,'192.168.115.1','200912142237142-1955.jpg','','image/pjpeg',10986,'201003/3/1_1267633441X8rx.jpg',0,0,0,0,0,0,0,0,0),(9,0,0,1,'admin',1267634491,'192.168.115.1','AlbumArtSmall.jpg','','image/pjpeg',2571,'201003/3/1_1267634491rv22.jpg',0,0,0,0,0,0,0,0,0);

/*Table structure for table `uchome_picfield` */

DROP TABLE IF EXISTS `uchome_picfield`;

CREATE TABLE `uchome_picfield` (
  `picid` mediumint(8) unsigned NOT NULL default '0',
  `hotuser` text NOT NULL,
  PRIMARY KEY  (`picid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_picfield` */

/*Table structure for table `uchome_plan` */

DROP TABLE IF EXISTS `uchome_plan`;

CREATE TABLE `uchome_plan` (
  `id` smallint(6) unsigned NOT NULL auto_increment,
  `subject` varchar(80) NOT NULL default '',
  `month` char(2) NOT NULL default '',
  `week` char(1) NOT NULL default '',
  `day` char(2) NOT NULL default '',
  `hour` varchar(80) NOT NULL default '',
  `usetime` int(10) NOT NULL default '0',
  `nexttime` int(10) NOT NULL default '0',
  `ifsave` tinyint(1) NOT NULL default '0',
  `ifopen` tinyint(1) NOT NULL default '0',
  `filename` varchar(80) NOT NULL default '',
  `config` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_plan` */

/*Table structure for table `uchome_poke` */

DROP TABLE IF EXISTS `uchome_poke`;

CREATE TABLE `uchome_poke` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `fromuid` mediumint(8) unsigned NOT NULL default '0',
  `fromusername` varchar(15) NOT NULL default '',
  `note` varchar(255) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `iconid` smallint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`uid`,`fromuid`),
  KEY `uid` (`uid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_poke` */

/*Table structure for table `uchome_poll` */

DROP TABLE IF EXISTS `uchome_poll`;

CREATE TABLE `uchome_poll` (
  `pid` mediumint(8) unsigned NOT NULL auto_increment,
  `topicid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(15) NOT NULL default '',
  `subject` char(80) NOT NULL default '',
  `voternum` mediumint(8) unsigned NOT NULL default '0',
  `replynum` mediumint(8) unsigned NOT NULL default '0',
  `multiple` tinyint(1) NOT NULL default '0',
  `maxchoice` tinyint(3) NOT NULL default '0',
  `sex` tinyint(1) NOT NULL default '0',
  `noreply` tinyint(1) NOT NULL default '0',
  `credit` mediumint(8) unsigned NOT NULL default '0',
  `percredit` mediumint(8) unsigned NOT NULL default '0',
  `expiration` int(10) unsigned NOT NULL default '0',
  `lastvote` int(10) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `hot` mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY  (`pid`),
  KEY `uid` (`uid`,`dateline`),
  KEY `topicid` (`topicid`,`dateline`),
  KEY `voternum` (`voternum`),
  KEY `dateline` (`dateline`),
  KEY `lastvote` (`lastvote`),
  KEY `hot` (`hot`),
  KEY `percredit` (`percredit`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_poll` */

/*Table structure for table `uchome_pollfield` */

DROP TABLE IF EXISTS `uchome_pollfield`;

CREATE TABLE `uchome_pollfield` (
  `pid` mediumint(8) unsigned NOT NULL default '0',
  `notify` tinyint(1) NOT NULL default '0',
  `message` text NOT NULL,
  `summary` text NOT NULL,
  `option` text NOT NULL,
  `invite` text NOT NULL,
  `hotuser` text NOT NULL,
  PRIMARY KEY  (`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_pollfield` */

/*Table structure for table `uchome_polloption` */

DROP TABLE IF EXISTS `uchome_polloption`;

CREATE TABLE `uchome_polloption` (
  `oid` mediumint(8) unsigned NOT NULL auto_increment,
  `pid` mediumint(8) unsigned NOT NULL default '0',
  `votenum` mediumint(8) unsigned NOT NULL default '0',
  `option` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`oid`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_polloption` */

/*Table structure for table `uchome_polluser` */

DROP TABLE IF EXISTS `uchome_polluser`;

CREATE TABLE `uchome_polluser` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(15) NOT NULL default '',
  `pid` mediumint(8) unsigned NOT NULL default '0',
  `option` text NOT NULL,
  `dateline` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`uid`,`pid`),
  KEY `pid` (`pid`,`dateline`),
  KEY `uid` (`uid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_polluser` */

/*Table structure for table `uchome_post` */

DROP TABLE IF EXISTS `uchome_post`;

CREATE TABLE `uchome_post` (
  `pid` int(10) unsigned NOT NULL auto_increment,
  `tagid` mediumint(8) unsigned NOT NULL default '0',
  `tid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(15) NOT NULL default '',
  `ip` varchar(20) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `message` text NOT NULL,
  `pic` varchar(255) NOT NULL default '',
  `isthread` tinyint(1) NOT NULL default '0',
  `hotuser` text NOT NULL,
  PRIMARY KEY  (`pid`),
  KEY `tid` (`tid`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_post` */

/*Table structure for table `uchome_profield` */

DROP TABLE IF EXISTS `uchome_profield`;

CREATE TABLE `uchome_profield` (
  `fieldid` smallint(6) unsigned NOT NULL auto_increment,
  `title` varchar(80) NOT NULL default '',
  `note` varchar(255) NOT NULL default '',
  `formtype` varchar(20) NOT NULL default '0',
  `inputnum` smallint(3) unsigned NOT NULL default '0',
  `choice` text NOT NULL,
  `mtagminnum` smallint(6) unsigned NOT NULL default '0',
  `manualmoderator` tinyint(1) NOT NULL default '0',
  `manualmember` tinyint(1) NOT NULL default '0',
  `displayorder` tinyint(3) unsigned NOT NULL default '0',
  PRIMARY KEY  (`fieldid`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_profield` */

insert  into `uchome_profield`(`fieldid`,`title`,`note`,`formtype`,`inputnum`,`choice`,`mtagminnum`,`manualmoderator`,`manualmember`,`displayorder`) values (1,'自由联盟','','text',100,'',0,0,1,0),(2,'地区联盟','','text',100,'',0,0,1,0),(3,'兴趣联盟','','text',100,'',0,0,1,0);

/*Table structure for table `uchome_profilefield` */

DROP TABLE IF EXISTS `uchome_profilefield`;

CREATE TABLE `uchome_profilefield` (
  `fieldid` smallint(6) unsigned NOT NULL auto_increment,
  `title` varchar(80) NOT NULL default '',
  `note` varchar(255) NOT NULL default '',
  `formtype` varchar(20) NOT NULL default '0',
  `maxsize` tinyint(3) unsigned NOT NULL default '0',
  `required` tinyint(1) NOT NULL default '0',
  `invisible` tinyint(1) NOT NULL default '0',
  `allowsearch` tinyint(1) NOT NULL default '0',
  `choice` text NOT NULL,
  `displayorder` tinyint(3) unsigned NOT NULL default '0',
  PRIMARY KEY  (`fieldid`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_profilefield` */

insert  into `uchome_profilefield`(`fieldid`,`title`,`note`,`formtype`,`maxsize`,`required`,`invisible`,`allowsearch`,`choice`,`displayorder`) values (1,'用户栏目','测试用户栏目','text',50,0,0,0,'',1);

/*Table structure for table `uchome_recycler` */

DROP TABLE IF EXISTS `uchome_recycler`;

CREATE TABLE `uchome_recycler` (
  `id` int(11) NOT NULL auto_increment,
  `table_name` enum('uc_site','uc_indexsite') NOT NULL,
  `sitename` varchar(100) NOT NULL default '',
  `siteurl` varchar(250) NOT NULL default '',
  `oldclass` int(11) NOT NULL default '0',
  `namecolor` char(7) default NULL,
  `adduser` varchar(25) default NULL,
  `displayorder` int(11) NOT NULL default '100',
  `good` tinyint(1) NOT NULL default '0',
  `gooddisplayorder` int(11) NOT NULL default '0',
  `good2` tinyint(1) NOT NULL default '0',
  `remark` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_recycler` */

/*Table structure for table `uchome_report` */

DROP TABLE IF EXISTS `uchome_report`;

CREATE TABLE `uchome_report` (
  `rid` mediumint(8) unsigned NOT NULL auto_increment,
  `id` mediumint(8) unsigned NOT NULL default '0',
  `idtype` varchar(15) NOT NULL default '',
  `new` tinyint(1) NOT NULL default '0',
  `num` smallint(6) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `reason` text NOT NULL,
  `uids` text NOT NULL,
  PRIMARY KEY  (`rid`),
  KEY `id` (`id`,`idtype`,`num`,`dateline`),
  KEY `new` (`new`,`dateline`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_report` */

/*Table structure for table `uchome_session` */

DROP TABLE IF EXISTS `uchome_session`;

CREATE TABLE `uchome_session` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(32) NOT NULL default '',
  `password` char(32) NOT NULL default '',
  `name` char(15) NOT NULL default '',
  `lastactivity` int(10) unsigned NOT NULL default '0',
  `ip` int(10) unsigned NOT NULL default '0',
  `magichidden` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`uid`),
  KEY `lastactivity` (`lastactivity`),
  KEY `ip` (`ip`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

/*Data for the table `uchome_session` */

insert  into `uchome_session`(`uid`,`username`,`password`,`name`,`lastactivity`,`ip`,`magichidden`) values (10,'ramen.sh@gmail.com','b4f248ca9a48ff6359b60a51111458fc','城市森林',1284714378,192168115,0);

/*Table structure for table `uchome_share` */

DROP TABLE IF EXISTS `uchome_share`;

CREATE TABLE `uchome_share` (
  `sid` mediumint(8) unsigned NOT NULL auto_increment,
  `topicid` mediumint(8) unsigned NOT NULL default '0',
  `type` varchar(30) NOT NULL default '',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(15) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `title_template` text NOT NULL,
  `body_template` text NOT NULL,
  `body_data` text NOT NULL,
  `body_general` text NOT NULL,
  `image` varchar(255) NOT NULL default '',
  `image_link` varchar(255) NOT NULL default '',
  `hot` mediumint(8) unsigned NOT NULL default '0',
  `hotuser` text NOT NULL,
  PRIMARY KEY  (`sid`),
  KEY `uid` (`uid`,`dateline`),
  KEY `topicid` (`topicid`,`dateline`),
  KEY `hot` (`hot`),
  KEY `dateline` (`dateline`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_share` */

insert  into `uchome_share`(`sid`,`topicid`,`type`,`uid`,`username`,`dateline`,`title_template`,`body_template`,`body_data`,`body_general`,`image`,`image_link`,`hot`,`hotuser`) values (1,0,'link',1,'admin',1261353727,'分享了一个网址','{link}','a:2:{s:4:\"link\";s:69:\"<a href=\"http://www.sohu.com\" target=\"_blank\">http://www.sohu.com</a>\";s:4:\"data\";s:19:\"http://www.sohu.com\";}','sohu','','',0,''),(2,0,'link',1,'admin',1261353773,'分享了一个网址','{link}','a:2:{s:4:\"link\";s:75:\"<a href=\"http://www.haoting.com\" target=\"_blank\">http://www.haoting.com</a>\";s:4:\"data\";s:22:\"http://www.haoting.com\";}','','','',0,''),(3,0,'music',1,'admin',1261353970,'分享了一个音乐','{link}','a:3:{s:4:\"link\";s:83:\"<a href=\"http://www.123.com/123.mp3\" target=\"_blank\">http://www.123.com/123.mp3</a>\";s:4:\"data\";s:26:\"http://www.123.com/123.mp3\";s:8:\"musicvar\";s:26:\"http://www.123.com/123.mp3\";}','','','',0,''),(4,0,'link',2,'ramen',1261707463,'分享了一个网址','{link}','a:2:{s:4:\"link\";s:67:\"<a href=\"http://www.163.com\" target=\"_blank\">http://www.163.com</a>\";s:4:\"data\";s:18:\"http://www.163.com\";}','','','',0,''),(5,0,'link',1,'admin',1262546512,'分享了一个网址','{link}','a:2:{s:4:\"link\";s:95:\"<a href=\"http://www.1234.com/$%^&amp;*123\" target=\"_blank\">http://www.1234.com/$%^&amp;*123</a>\";s:4:\"data\";s:32:\"http://www.1234.com/$%^&amp;*123\";}','','','',0,''),(6,0,'link',1,'admin',1266425563,'分享了一个网址','{link}','a:2:{s:4:\"link\";s:65:\"<a href=\"mms://www.com.com\" target=\"_blank\">mms://www.com.com</a>\";s:4:\"data\";s:17:\"mms://www.com.com\";}','jQuery是一个快速的，简洁的javaScript库，使用户能更方便地处理HTML documents、events、实现动画效果，并且方便地为网站提供AJAX交互。<br />\r\n　　jQuery还有一个比较大的','','',0,''),(7,0,'link',1,'admin',1268323687,'分享了一个网址','{link}','a:2:{s:4:\"link\";s:75:\"<a href=\"http://www.realtek.com\" target=\"_blank\">http://www.realtek.com</a>\";s:4:\"data\";s:22:\"http://www.realtek.com\";}','sfsf','','',0,''),(8,0,'link',1,'admin',1268367781,'分享了一个网址','{link}','a:2:{s:4:\"link\";s:75:\"<a href=\"http://www.fehuang.com\" target=\"_blank\">http://www.fehuang.com</a>\";s:4:\"data\";s:22:\"http://www.fehuang.com\";}','凤凰','','',0,''),(9,0,'link',1,'admin',1269013828,'分享了一个网址','{link}','a:2:{s:4:\"link\";s:73:\"<a href=\"http://www.ramen.coms\" target=\"_blank\">http://www.ramen.coms</a>\";s:4:\"data\";s:21:\"http://www.ramen.coms\";}','fsfs','','',0,''),(10,0,'link',10,'ramen.sh@gmail.',1276289389,'分享了一个网址','{link}','a:2:{s:4:\"link\";s:180:\"<a href=\"http://search.haoting.com/user/search1.asp?word=%C7%F4%C4%F1&amp;wofrdf=%C7%F4%C4%F1&amp;type=1&amp;more=true\" target=\"_blank\">http://search.haoting. ... 3Bmore%3Dtrue</a>\";s:4:\"data\";s:109:\"http://search.haoting.com/user/search1.asp?word=%C7%F4%C4%F1&amp;wofrdf=%C7%F4%C4%F1&amp;type=1&amp;more=true\";}','','','',0,''),(11,0,'link',10,'ramen.sh@gmail.',1276290634,'分享了一个网址','{link}','a:2:{s:4:\"link\";s:77:\"<a href=\"http://www.dangdang.com\" target=\"_blank\">http://www.dangdang.com</a>\";s:4:\"data\";s:23:\"http://www.dangdang.com\";}','','','',0,''),(12,0,'link',10,'城市森林',1276294025,'分享了一个网址','{link}','a:2:{s:4:\"link\";s:102:\"<a href=\"http://www.dangdang.com\" target=\"_blank\">当当网—网上购物中心：图书、母婴</a>\";s:4:\"data\";s:23:\"http://www.dangdang.com\";}','','','',0,''),(13,0,'link',10,'城市森林',1276294236,'分享了一个网址','{link}','a:2:{s:4:\"link\";s:117:\"<a href=\"http://www.dangdang.com\" target=\"_blank\">当当网','','','',0,''),(14,0,'link',10,'城市森林',1276294397,'分享了一个网址','{link}','a:2:{s:4:\"link\";s:129:\"<a href=\"http://www.dangdang.com\" target=\"_blank\">当当网—网上购','','','',0,''),(15,0,'link',10,'城市森林',1276294447,'分享了一个网址','{link}','a:2:{s:4:\"link\";s:102:\"<a href=\"http://www.dangdang.com\" target=\"_blank\">当当网—网上购物中心：图书、母婴</a>\";s:4:\"data\";s:23:\"http://www.dangdang.com\";}','','','',0,'');

/*Table structure for table `uchome_show` */

DROP TABLE IF EXISTS `uchome_show`;

CREATE TABLE `uchome_show` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(15) NOT NULL default '',
  `credit` int(10) unsigned NOT NULL default '0',
  `note` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`uid`),
  KEY `credit` (`credit`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_show` */

/*Table structure for table `uchome_site` */

DROP TABLE IF EXISTS `uchome_site`;

CREATE TABLE `uchome_site` (
  `id` int(11) NOT NULL auto_increment,
  `name` char(255) NOT NULL default '',
  `url` char(255) NOT NULL default '',
  `tag` text NOT NULL,
  `class` int(11) NOT NULL default '0',
  `displayorder` int(11) NOT NULL default '100',
  `good` tinyint(1) NOT NULL default '0',
  `good2` tinyint(1) NOT NULL default '0',
  `day` int(11) default '0',
  `week` int(11) default '0',
  `month` int(11) default '0',
  `total` int(11) default '0',
  `gooddisplayorder` mediumint(8) NOT NULL default '0',
  `namecolor` char(7) NOT NULL,
  `adduser` varchar(25) NOT NULL,
  `yesterday` int(11) NOT NULL default '0',
  `byesterday` int(11) NOT NULL default '0',
  `starttime` int(11) NOT NULL default '0',
  `endtime` int(11) NOT NULL default '0',
  `remark` text NOT NULL,
  `viewnum` mediumint(8) unsigned NOT NULL default '0',
  `storenum` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `pic` char(255) NOT NULL default '',
  `picflag` tinyint(1) NOT NULL default '0',
  `tmppic` char(255) NOT NULL default '',
  `md5url` char(128) NOT NULL default '',
  `hashurl` int(64) NOT NULL default '0',
  `up` mediumint(8) NOT NULL default '0',
  `down` mediumint(8) NOT NULL default '0',
  `trynum` smallint(6) NOT NULL default '0',
  `award` int(6) NOT NULL default '0',
  `initaward` int(6) NOT NULL default '7000',
  `delflag` tinyint(1) NOT NULL default '0',
  `end` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `class` (`class`),
  KEY `starttime` (`starttime`),
  KEY `endtime` (`endtime`)
) ENGINE=MyISAM AUTO_INCREMENT=41146 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_site` */


/*Table structure for table `uchome_siteclass` */

DROP TABLE IF EXISTS `uchome_siteclass`;

CREATE TABLE `uchome_siteclass` (
  `classid` int(15) NOT NULL auto_increment,
  `parentid` int(15) NOT NULL default '0',
  `classname` char(20) default NULL,
  `displayorder` int(11) NOT NULL default '100',
  `sitenum` int(11) NOT NULL default '0',
  `path` varchar(255) NOT NULL,
  `keywords` varchar(100) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY  (`classid`)
) ENGINE=MyISAM AUTO_INCREMENT=2285 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_siteclass` */

insert  into `uchome_siteclass`(`classid`,`parentid`,`classname`,`displayorder`,`sitenum`,`path`,`keywords`,`description`) values (1,0,'娱乐休闲',1,0,'','',''),(2,0,'生活服务',2,0,'','',''),(3,0,'文化教育',4,0,'','',''),(4,0,'电脑网络',3,0,'','',''),(644,1,'小说',106,0,'xiaoshuo','',''),(645,644,'小说阅读',1,25,'','',''),(647,2209,'小说论坛',4,14,'','',''),(648,644,'作家作品',3,30,'','',''),(649,644,'文化文学',2,15,'','',''),(2101,783,'风水玄学',4,5,'','',''),(2103,1588,'室内设计',3,9,'','',''),(652,1,'摄影',117,0,'sheying','',''),(653,2199,'网络相册',3,15,'','',''),(1923,2172,'明星后援会',5,27,'','',''),(1603,755,'北京电台',1,5,'','',''),(2156,1036,'各学科课件教案',4,0,'','',''),(658,2,'娱乐',123,0,'yule','',''),(659,658,'娱乐综合',1,22,'','',''),(1973,731,'搞笑视频',2,5,'','',''),(1924,2172,'网络红人',6,18,'','',''),(662,2,'两性',115,0,'sex','',''),(663,662,'两性健康',1,20,'','',''),(664,2218,'女性',1,25,'','',''),(665,2218,'男士',4,10,'','',''),(1978,921,'电子优惠券',4,5,'','',''),(2028,1596,'软件游戏',6,9,'','',''),(668,4,'博客',108,0,'blog','',''),(669,668,'博客',1,32,'','',''),(670,668,'博客周边',2,10,'','',''),(1931,2209,'教育论坛',22,9,'','',''),(673,668,'网摘/书签',3,12,'','',''),(674,1,'社区',114,0,'bbs','',''),(675,674,'综合论坛',1,45,'','',''),(1937,1936,'北京论坛',1,7,'','',''),(678,2209,'软件论坛',6,34,'','',''),(1933,2209,'旅游论坛',20,13,'','',''),(680,2209,'安全防毒论坛',7,6,'','',''),(681,2209,'硬件论坛',5,18,'','',''),(2160,974,'科普知识',2,6,'','',''),(684,2209,'贴图论坛',14,9,'','',''),(685,2209,'笑话论坛',15,10,'','',''),(686,2209,'音乐论坛',3,25,'','',''),(2104,1588,'建筑设计',4,4,'','',''),(689,2209,'数码论坛',8,8,'','',''),(690,2209,'手机论坛',9,15,'','',''),(691,2209,'军事论坛',10,8,'','',''),(1936,674,'地方论坛',3,0,'','',''),(693,2209,'股市论坛',11,25,'','',''),(1932,2209,'人生论坛',17,8,'','',''),(2077,2209,'足球论坛',13,17,'','',''),(697,2209,'体育论坛',12,20,'','',''),(698,1,'游戏',103,0,'games','',''),(699,698,'游戏综合',1,25,'','',''),(700,765,'手机游戏/电影',3,10,'','',''),(701,2215,'小游戏',2,19,'','',''),(703,2209,'游戏论坛',16,14,'','',''),(704,698,'游戏下载',6,8,'','',''),(706,698,'单机电玩',8,10,'','',''),(2145,795,'数码影像',100,5,'','',''),(708,1,'美图',110,0,'bizhi','',''),(709,708,'综合图库',1,15,'','',''),(710,708,'明星美女',3,9,'','',''),(711,2219,'桌面壁纸',1,22,'','',''),(712,2219,'桌面主题美化',4,8,'','',''),(2110,1588,'设计竞标',6,4,'','',''),(715,1,'音乐',101,0,'music','',''),(716,715,'在线音乐',1,25,'','',''),(717,715,'音乐周边',4,10,'','',''),(719,2223,'音乐翻唱/原创音乐',6,9,'','',''),(720,715,'DJ舞曲',2,10,'','',''),(725,1,'军事',118,0,'junshi','',''),(726,725,'军事资讯',1,20,'','',''),(727,725,'军事论坛',2,13,'','',''),(728,2168,'军事刊物',3,14,'','',''),(729,2168,'军事史',4,30,'','',''),(730,725,'军人天地',5,8,'','',''),(731,1,'笑话',113,0,'fun','',''),(732,731,'笑话大全',1,14,'','',''),(733,731,'很囧很雷人',3,9,'','',''),(734,2,'时尚',118,0,'fashion','',''),(735,734,'时尚资讯',1,15,'','',''),(736,2218,'美容',2,18,'','',''),(737,2188,'化妆品牌',4,20,'','',''),(738,734,'时尚杂志',4,14,'','',''),(739,921,'饮食综合',1,19,'','',''),(2197,921,'菜谱大全',2,5,'','',''),(741,4,'聊天',109,0,'liaotian_qq','',''),(742,741,'聊天室',2,14,'','',''),(2146,1711,'掌上电脑',100,5,'','',''),(744,741,'聊天工具',1,18,'','',''),(745,741,'QQ相关',5,13,'','',''),(1930,2209,'特色论坛',2,40,'','',''),(748,2226,'电视电台',106,0,'dianshi','',''),(749,2167,'热播电视台',2,24,'','',''),(2051,2050,'亚洲旅游局',1,12,'','',''),(751,748,'地方电视台',4,0,'','',''),(752,748,'电视资讯/节目预告表',1,10,'','',''),(2031,891,'旅游景点',5,7,'','',''),(754,2167,'热门广播电台',5,27,'','',''),(755,748,'地方电台',5,0,'','',''),(756,748,'网络电台',2,9,'','',''),(757,4,'Flash',126,0,'flash-show','',''),(758,757,'Flash欣赏',1,13,'','',''),(759,757,'休闲小游戏',2,15,'','',''),(760,757,'Flash教程',4,10,'','',''),(762,757,'Flash技术',5,5,'','',''),(765,2,'手机',110,0,'shouji','',''),(766,765,'手机综合',1,20,'','',''),(767,765,'手机论坛',4,14,'','',''),(768,765,'手机厂商',7,12,'','',''),(769,765,'手机图铃/短信',6,10,'','',''),(770,765,'手机报价',2,5,'','',''),(1975,803,'网络电视',10,5,'','',''),(774,2091,'通信资讯',1,10,'','',''),(775,2091,'电信运营商',0,4,'','',''),(776,1,'动漫',112,0,'dongman','',''),(777,776,'动漫综合',1,15,'','',''),(778,776,'动漫下载',4,8,'','',''),(779,776,'动漫专题',8,10,'','',''),(783,1,'星相',111,0,'xingzuo','',''),(784,783,'星座',1,15,'','',''),(785,783,'算命占卜',2,20,'','',''),(786,783,'生肖/解梦',3,5,'','',''),(787,783,'心理测试',5,5,'','',''),(2027,1596,'商业财经',7,9,'','',''),(789,1,'交友',115,0,'love','',''),(790,789,'交友综合',1,20,'','',''),(791,789,'婚嫁婚介',3,15,'','',''),(792,789,'情感爱情',2,9,'','',''),(1977,757,'Flash音乐',3,5,'','',''),(795,4,'数码',121,0,'shuma_shishang','',''),(796,795,'数码综合',1,17,'','',''),(799,1711,'MP3/MD',7,9,'','',''),(800,795,'数码论坛',2,8,'','',''),(801,1711,'摄像头厂商',3,25,'','',''),(1713,1076,'特色搜索',6,20,'','',''),(803,1,'视频',102,0,'vedio','',''),(1981,776,'在线漫画',3,8,'','',''),(805,2212,'在线电影',2,8,'','',''),(2068,698,'游戏周边',9,15,'','',''),(813,2,'彩票',109,0,'caipiao','',''),(814,813,'彩票门户',1,13,'','',''),(815,813,'福利彩票',3,32,'','',''),(816,813,'体育彩票',4,38,'','',''),(817,813,'足球彩票',5,10,'','',''),(2059,2193,'地方宠物网',7,10,'','',''),(820,2,'宠物',116,0,'pet','',''),(821,820,'宠物综合',1,15,'','',''),(822,820,'花草花卉',9,9,'','',''),(824,1,'明星',116,0,'star','',''),(825,824,'解读明星',1,11,'','',''),(826,824,'名模写真',2,4,'','',''),(827,2172,'大陆明星',1,22,'','',''),(828,2172,'港台明星',2,26,'','',''),(829,2172,'国外明星',3,37,'','',''),(2155,2034,'球迷天下',100,0,'','',''),(831,1,'新闻',104,0,'news','',''),(832,831,'新闻综合',1,30,'','',''),(835,668,'博客搜索引擎',5,5,'','',''),(837,831,'国内知名报刊',2,25,'','',''),(838,831,'地方报刊',5,0,'','',''),(842,2,'股票',103,0,'gupiao','',''),(843,842,'财经资讯',1,20,'','',''),(844,842,'股票论坛/博客',4,18,'','',''),(845,2148,'热门证券公司',6,47,'','',''),(847,2148,'财经报刊',4,21,'','',''),(848,842,'股评研究',3,10,'','',''),(850,2148,'股票分析软件',3,5,'','',''),(851,2,'购物',105,0,'gouwu','',''),(852,851,'网上购物',1,23,'','',''),(853,851,'图书/音像',8,9,'','',''),(2134,662,'两性用品',2,4,'','',''),(1717,924,'工艺饰品',5,17,'','',''),(856,2,'银行',106,28,'bank','',''),(1688,2204,'外资银行',5,20,'','',''),(858,856,'内地银行',1,19,'','',''),(860,856,'保险资讯',2,12,'','',''),(1721,871,'北京医院',1,35,'','',''),(2049,912,'案例分析',8,9,'','',''),(863,2,'健康',111,0,'health','',''),(864,863,'健康医疗',1,20,'','',''),(2207,2205,'地方法律援助网',100,7,'','',''),(866,2203,'艾滋病防治',9,11,'','',''),(2206,2205,'地方律师网',100,22,'','',''),(869,2203,'医学研究',5,19,'','',''),(870,2203,'医院管理',7,4,'','',''),(871,863,'各地医院',5,2,'','',''),(872,2203,'医药药品',5,33,'','',''),(873,2226,'招商加盟',101,0,'zhaoshang','',''),(2133,2219,'系统美化论坛',5,5,'','',''),(2153,1020,'足球世界',3,13,'','',''),(878,2,'房产',108,0,'house','',''),(879,878,'家居装修',2,18,'','',''),(881,878,'房地产',1,24,'','',''),(883,2,'亲子',113,0,'qinzi','',''),(884,883,'亲子育儿',1,25,'','',''),(2167,748,'热门电视电台',3,0,'','',''),(886,883,'儿童教育',2,11,'','',''),(888,883,'亲子论坛',5,9,'','',''),(889,883,'游戏童谣',6,10,'','',''),(890,883,'素质教育',3,8,'','',''),(891,2,'旅游',117,0,'travel','',''),(892,891,'旅游资讯',1,23,'','',''),(893,891,'各地旅游',7,0,'','',''),(2050,891,'各国旅游局',8,0,'','',''),(895,891,'旅行社/酒店/机票',2,15,'','',''),(2024,2229,'病毒防治',3,20,'','',''),(2039,715,'音乐播放软件',10,5,'','',''),(899,2226,'政府部门',103,0,'zhengfu','',''),(902,899,'地方政府',3,0,'','',''),(903,2179,'国家信息中心',2,23,'','',''),(904,2186,'国际组织',5,52,'','',''),(905,899,'各国政府',5,0,'','',''),(2085,891,'自助户外游',6,5,'','',''),(907,2,'生活',122,0,'life','',''),(908,907,'时尚生活',1,15,'','',''),(912,2,'法律',112,0,'law','',''),(913,912,'法律综合',1,24,'','',''),(914,2205,'地方法院',7,29,'','',''),(915,912,'律师网站',3,10,'','',''),(916,912,'知识产权',5,6,'','',''),(2284,2226,'地方服务',102,0,'html/local/index.htm','',''),(921,2,'美食',119,0,'foods','',''),(2080,921,'食疗养生',3,5,'','',''),(1919,831,'国际知名媒体',4,15,'','',''),(924,2226,'鲜花礼品',110,0,'lipin','',''),(925,924,'礼品',1,10,'','',''),(926,924,'玩具',3,10,'','',''),(927,1,'体育',107,0,'tiyu','',''),(928,927,'体育综合',1,20,'','',''),(929,927,'体育论坛',6,10,'','',''),(930,2034,'NBA专题',1,9,'','',''),(931,2150,'户外运动',13,21,'','',''),(934,2150,'羽毛球',17,10,'','',''),(935,2150,'乒乓球',18,24,'','',''),(937,2150,'网球',9,20,'','',''),(2081,2186,'驻华使馆/领事馆',101,27,'','',''),(940,2150,'高尔夫',16,13,'','',''),(941,2150,'气功养生',25,14,'','',''),(944,2150,'排球',14,14,'','',''),(946,3,'大学',7,0,'xiaoyuan_gaoxiao','',''),(947,2246,'同学录',2,5,'','',''),(2078,2149,'高校BBS论坛',6,55,'','',''),(2055,2050,'大洋洲旅游局',5,4,'','',''),(950,946,'地方高校',9,7,'','',''),(951,2149,'国内名校',4,20,'','',''),(2023,2239,'交通地图',3,10,'','',''),(2158,974,'基础学科',4,0,'','',''),(955,2149,'各大学图书馆',5,77,'','',''),(2054,2050,'美洲旅游局',4,6,'','',''),(957,2,'招聘',121,0,'rencai','',''),(958,957,'人才招聘',1,25,'','',''),(959,957,'地方人才网',6,0,'','',''),(960,957,'简历写作',3,7,'','',''),(961,3,'教育',1,0,'jiaoyu','',''),(962,961,'教育综合',1,20,'','',''),(964,961,'幼儿教育',2,9,'','',''),(2283,873,'招商加盟',0,5,'','',''),(966,961,'基础教育',3,9,'','',''),(967,961,'职业教育',6,4,'','',''),(969,961,'成人教育',5,5,'','',''),(970,961,'特殊教育',8,5,'','',''),(2061,2173,'地方礼品',2,20,'','',''),(2088,961,'高等教育',4,4,'','',''),(974,3,'科技',2,0,'kexue_jishu','',''),(975,974,'科技综合',1,14,'','',''),(976,2158,'生物学',5,15,'','',''),(977,2158,'地理学',8,14,'','',''),(978,2158,'化学',6,15,'','',''),(979,2158,'数学',13,12,'','',''),(980,2158,'物理学',12,15,'','',''),(981,2158,'天文学',11,19,'','',''),(983,2158,'历史学',9,21,'','',''),(984,2158,'经济学',3,25,'','',''),(985,2158,'政治学',7,11,'','',''),(986,2158,'心理学',1,9,'','',''),(987,2158,'哲学',2,14,'','',''),(2105,1588,'服装设计',5,8,'','',''),(989,2159,'重点实验室',17,20,'','',''),(2265,2264,'考研论坛',100,6,'','',''),(991,2161,'考试招生',0,20,'','',''),(992,2161,'自学考试',7,10,'','',''),(993,2264,'考研综合',2,14,'','',''),(994,2161,'司法考试',11,14,'','',''),(995,2161,'财会考试',11,15,'','',''),(996,2161,'公务员考试',1,9,'','',''),(998,2161,'计算机考试',10,8,'','',''),(999,2161,'MBA管理培训',9,7,'','',''),(2087,1011,'纹身',9,2,'','',''),(1001,2263,'高考资讯',3,15,'','',''),(1003,3,'人文',11,0,'shehui_wenhua','',''),(1004,1003,'社会文化',1,20,'','',''),(2164,2224,'道教网址',2,4,'','',''),(1006,2225,'公益网站',6,13,'','',''),(2163,2224,'佛教网址',1,17,'','',''),(2162,1003,'历史名人',100,5,'','',''),(1009,1003,'历史人文',2,5,'','',''),(2239,2,'地图',126,0,'map','',''),(1011,3,'爱好',13,0,'yishu_aihao','',''),(1012,1011,'艺术鉴赏',0,15,'','',''),(1015,1011,'书法艺术',3,10,'','',''),(2149,946,'中国大学',4,0,'','',''),(1017,1011,'美术绘画',2,9,'','',''),(1018,2223,'相声小品评书',1,11,'','',''),(1019,1011,'收藏艺术',1,20,'','',''),(1020,1,'足球',108,0,'football','',''),(1021,1020,'足球综合',1,15,'','',''),(1036,3,'论文',8,0,'kejian_lunwen','',''),(1037,1036,'课件资源',2,11,'','',''),(1038,2156,'数学课件教案',4,4,'','',''),(1039,2156,'英语课件教案',5,9,'','',''),(1040,2156,'语文课件教案',6,9,'','',''),(1699,1682,'网吧联盟',2,36,'','',''),(1698,1682,'网管技术',3,26,'','',''),(1043,1036,'免费论文',1,14,'','',''),(1044,3,'外语',3,0,'waiyu_xuexi','',''),(1045,1044,'英语学习',1,25,'','',''),(2150,927,'各类运动项目',100,0,'','',''),(1047,1044,'在线翻译',2,13,'','',''),(2270,1131,'网页制作辅助',100,10,'','',''),(2165,2224,'基督教网站',3,6,'','',''),(1050,1044,'其他语种学习',5,13,'','',''),(1051,3,'留学',12,0,'chuguo_liuxue','',''),(1052,1051,'出国留学',1,15,'','',''),(1053,1051,'各国移民留学',3,10,'','',''),(1054,1051,'移民',2,5,'','',''),(1696,957,'行业人才',5,42,'','',''),(1695,957,'威客网址',4,8,'','',''),(2034,1,'NBA',109,0,'nba','',''),(1068,2199,'国内免费邮箱',1,15,'','',''),(1689,1711,'MP4相关',3,9,'','',''),(1076,4,'搜索',122,0,'Sousuo_Yinqing','',''),(1077,1076,'搜索',1,10,'','',''),(2159,974,'科学研究',5,0,'','',''),(1686,1711,'MP3/MP4品牌',2,15,'','',''),(1082,2226,'国外网站',105,0,'guowai','',''),(1084,1082,'综合门户',2,42,'','',''),(1085,1082,'国外软件',14,32,'','',''),(1086,1082,'报刊杂志',11,91,'','',''),(1087,1082,'国外免费邮箱',9,10,'','',''),(1088,1082,'海外华人网',3,30,'','',''),(1089,1082,'搜索引擎',1,13,'','',''),(1090,1082,'国外硬件',15,31,'','',''),(1091,1082,'新闻网址',4,25,'','',''),(1092,1082,'体育网址',5,20,'','',''),(1093,1082,'国外电影',9,37,'','',''),(1094,1082,'流行时尚',8,24,'','',''),(1095,4,'硬件',120,0,'Yingjian_Zixun','',''),(1096,1095,'硬件资讯',1,17,'','',''),(1097,2147,'硬件品牌',1,86,'','',''),(1711,795,'数码相关',100,0,'','',''),(1099,2147,'笔记本电脑',3,15,'','',''),(1101,1095,'硬件评测',2,9,'','',''),(1102,1095,'驱动程序',4,8,'','',''),(1103,1095,'硬件论坛',3,10,'','',''),(1104,2147,'服务器资讯',4,15,'','',''),(1105,4,'软件',103,0,'soft','',''),(1106,1105,'软件下载',1,22,'','',''),(1107,1105,'软件论坛',5,9,'','',''),(1109,1105,'装机软件',3,5,'','',''),(1110,1588,'字体下载',8,8,'','',''),(1285,803,'视频播客',1,20,'','',''),(1113,2120,'BT下载',2,14,'','',''),(1114,2120,'P2P软件',8,10,'','',''),(1284,2120,'P2P辅助',9,4,'','',''),(1117,1082,'国外下载',6,18,'','',''),(1118,1105,'驱动下载',2,9,'','',''),(1119,2212,'电影下载',4,10,'','',''),(1121,4,'IT',101,0,'it','',''),(1122,1121,'IT资讯',0,30,'','',''),(1123,2147,'电脑公司',2,20,'','',''),(1124,2198,'电脑教程',3,10,'','',''),(1126,2198,'电脑报刊',4,20,'','',''),(1709,1131,'站长资讯',2,10,'','',''),(2107,1588,'设计素材',1,16,'','',''),(1131,4,'建站',125,0,'Jianzhan_Sheji','',''),(1132,1131,'网页制作',1,16,'','',''),(1133,2220,'域名主机',1,14,'','',''),(2047,2204,'国内地方银行',3,30,'','',''),(1138,4,'黑客',105,0,'Heike_Anquan','',''),(1139,1138,'黑客/安全站点',1,18,'','',''),(1358,1138,'黑客论坛',4,14,'','',''),(2212,1,'电影',105,0,'movie','',''),(1142,2229,'安全防毒论坛',5,7,'','',''),(1143,2226,'免费资源',109,0,'free','',''),(1704,2186,'区域组织',7,13,'','',''),(2142,1143,'免费信息发布',2,5,'','',''),(1146,1143,'免费主页空间',5,5,'','',''),(1147,1143,'免费域名',4,5,'','',''),(1705,1082,'专项体育',6,15,'','',''),(2113,1131,'论坛 CMS',4,10,'','',''),(1150,1143,'免费留言本',8,3,'','',''),(1151,1143,'免费论坛申请',5,7,'','',''),(1152,4,'编程',124,0,'Chengxu_Biancheng','',''),(1153,1152,'编程开发',1,15,'','',''),(2259,2198,'网管技术',100,5,'','',''),(1155,2169,'ASP',4,17,'','',''),(1156,2169,'Java',12,17,'','',''),(1157,2169,'Linux',13,17,'','',''),(1158,2169,'Delphi',11,8,'','',''),(1159,2169,'C/C++/C#',10,8,'','',''),(1160,2169,'PHP',5,15,'','',''),(1161,2169,'Wap',7,5,'','',''),(1162,2169,'VB',9,10,'','',''),(1163,2169,'JSP',6,8,'','',''),(2063,2173,'地方工艺饰品',6,8,'','',''),(1165,2169,'Power Builder',14,7,'','',''),(1166,2169,'数据库编程',0,8,'','',''),(1167,2169,'CGI',8,6,'','',''),(1168,2,'汽车',107,0,'car','',''),(1169,1168,'汽车资讯',1,30,'','',''),(1170,2175,'汽车企业汇总',9,31,'','',''),(1171,1168,'汽车配件',5,20,'','',''),(1642,1251,'投资理财',1,15,'','',''),(2208,2205,'地方知识产权局',100,28,'','',''),(2200,1121,'IT博客',100,9,'','',''),(2188,907,'各类品牌汇总',5,0,'','',''),(2189,907,'衣食住行用',1,24,'','',''),(2205,912,'知法维权',100,0,'','',''),(2202,863,'寻医问药',2,10,'','',''),(2193,820,'宠物相关',100,0,'','',''),(1251,2,'基金',104,0,'jijin','',''),(1253,873,'企业黄页',4,12,'','',''),(2209,674,'各类论坛',2,0,'','',''),(2058,2155,'篮球迷网站',5,18,'','',''),(1270,2220,'网站推广',4,13,'','',''),(1926,873,'电子商务',3,18,'','',''),(2035,891,'天气预报',4,5,'qixiangditu','',''),(2057,2034,'中国篮协CBA',3,9,'','',''),(1282,765,'手机软件/电子书',5,10,'','',''),(1289,950,'北京高校',-3,69,'','',''),(1290,950,'天津高校',-1,24,'','',''),(1291,950,'上海高校',-2,40,'','',''),(1292,950,'江苏高校',2,39,'','',''),(1293,950,'浙江高校',4,35,'','',''),(1294,950,'湖北高校',9,34,'','',''),(1295,950,'广东高校',1,62,'','',''),(1296,950,'陕西高校',18,34,'','',''),(1297,950,'四川高校',8,40,'','',''),(1298,950,'重庆高校',0,13,'','',''),(1299,950,'辽宁高校',7,43,'','',''),(1300,950,'黑龙江高校',12,26,'','',''),(1301,950,'湖南高校',11,31,'','',''),(1302,950,'山东高校',3,35,'','',''),(1303,950,'安徽高校',13,32,'','',''),(1304,950,'山西高校',19,15,'','',''),(1305,950,'吉林高校',16,27,'','',''),(1306,950,'福建高校',10,24,'','',''),(1307,950,'河南高校',5,32,'','',''),(1308,950,'河北高校',6,35,'','',''),(1309,950,'内蒙古高校',20,21,'','',''),(1310,950,'江西高校',14,27,'','',''),(1311,950,'广西高校',15,24,'','',''),(1312,950,'海南高校',24,10,'','',''),(1313,950,'贵州高校',22,16,'','',''),(1314,950,'云南高校',17,17,'','',''),(1315,950,'西藏高校',27,3,'','',''),(1316,950,'甘肃高校',23,21,'','',''),(1317,950,'青海高校',25,9,'','',''),(1318,950,'宁夏高校',26,10,'','',''),(1319,950,'新疆高校',21,16,'','',''),(1320,950,'香港高校',531,15,'','',''),(1321,2149,'211工程高校名单',2,108,'','',''),(1322,946,'各国大学/高校',10,0,'','',''),(1323,950,'澳门高校',532,10,'','',''),(1324,950,'台湾省高校',533,25,'','',''),(1325,1322,'美国高校',1,20,'','',''),(1326,1322,'英国高校',2,8,'','',''),(1327,1322,'加拿大高校',3,6,'','',''),(1328,1322,'日本高校',5,16,'','',''),(1329,1322,'新加坡高校',4,2,'','',''),(1330,1322,'韩国高校',6,10,'','',''),(1331,1322,'澳大利亚高校',7,8,'','',''),(1332,1322,'新西兰高校',8,4,'','',''),(1342,1322,'西班牙高校',11,8,'','',''),(1341,1322,'德国高校',10,12,'','',''),(1335,1322,'比利时高校',12,4,'','',''),(1336,1322,'瑞士高校',13,6,'','',''),(1337,1322,'葡萄牙高校',14,2,'','',''),(1338,1322,'瑞典高校',15,2,'','',''),(1339,1322,'荷兰高校',16,2,'','',''),(1340,1322,'奥地利高校',17,3,'','',''),(1343,1322,'法国高校',9,12,'','',''),(1345,820,'水族爬虫',4,15,'','',''),(1346,820,'动物保护',8,8,'','',''),(1347,820,'猫猫狗狗',3,10,'','',''),(2062,2173,'地方玩具',4,10,'','',''),(2199,4,'邮箱',102,0,'mail','',''),(1350,2193,'地方宠物医院',7,12,'','',''),(1351,820,'宠物鸟',5,3,'','',''),(2135,776,'动漫视频',2,5,'','',''),(1360,1138,'国外黑客组织',6,10,'','',''),(1359,1138,'在线工具',2,19,'','',''),(1361,751,'福建电视台',10,9,'','',''),(1362,751,'北京电视台',-3,4,'','',''),(1363,751,'上海电视台',-2,3,'','',''),(1364,751,'天津电视台',-1,1,'','',''),(1365,751,'河北电视台',6,5,'','',''),(1366,751,'山东电视台',3,10,'','',''),(1367,751,'山西电视台',19,3,'','',''),(1368,751,'内蒙古电视台',20,1,'','',''),(1369,751,'江苏电视台',2,8,'','',''),(1370,751,'浙江电视台',4,9,'','',''),(1371,751,'安徽电视台',13,4,'','',''),(1372,751,'广东电视台',1,18,'','',''),(1373,751,'广西电视台',15,2,'','',''),(1374,751,'海南电视台',24,2,'','',''),(1375,751,'河南电视台',5,10,'','',''),(1376,751,'湖北电视台',9,8,'','',''),(1377,751,'湖南电视台',11,3,'','',''),(1378,751,'江西电视台',14,5,'','',''),(1379,751,'辽宁电视台',7,8,'','',''),(1380,751,'吉林电视台',16,3,'','',''),(1381,751,'黑龙江电视台',12,4,'','',''),(1382,751,'陕西电视台',18,4,'','',''),(1383,751,'宁夏电视台',26,1,'','',''),(1384,751,'甘肃电视台',23,4,'','',''),(1385,751,'青海电视台',25,2,'','',''),(1386,751,'新疆电视台',21,2,'','',''),(1387,751,'重庆电视台',0,2,'','',''),(1388,751,'四川电视台',8,9,'','',''),(1389,751,'贵州电视台',22,6,'','',''),(1390,751,'云南电视台',17,10,'','',''),(1391,751,'西藏电视台',27,1,'','',''),(1392,751,'台湾电视台',28,7,'','',''),(1393,751,'香港电视台',29,6,'','',''),(1394,751,'澳门电视台',30,2,'','',''),(1518,959,'广东人才',1,19,'','',''),(1925,1082,'国外相册',13,6,'','',''),(1519,959,'北京人才',-3,22,'','',''),(1520,959,'四川人才',8,12,'','',''),(1521,959,'青海人才',25,10,'','',''),(1522,959,'新疆人才',21,11,'','',''),(1523,959,'云南人才',17,15,'','',''),(1524,959,'甘肃人才',23,11,'','',''),(1525,959,'黑龙江人才',12,10,'','',''),(1526,959,'山东人才',3,13,'','',''),(1527,959,'江苏人才',2,27,'','',''),(1528,959,'浙江人才',4,21,'','',''),(1529,959,'上海人才',-2,17,'','',''),(1530,959,'江西人才',14,7,'','',''),(1531,959,'福建人才',10,14,'','',''),(1532,959,'内蒙古人才',20,16,'','',''),(1533,959,'西藏人才',27,7,'','',''),(1534,959,'河北人才',6,9,'','',''),(1535,959,'河南人才',5,7,'','',''),(1536,959,'宁夏人才',26,13,'','',''),(1537,959,'陕西人才',18,14,'','',''),(1538,959,'重庆人才',0,9,'','',''),(1539,959,'海南人才',24,11,'','',''),(1540,959,'贵州人才',22,14,'','',''),(1541,959,'辽宁人才',7,11,'','',''),(1542,959,'吉林人才',16,14,'','',''),(1543,959,'安徽人才',13,11,'','',''),(1544,959,'湖南人才',11,12,'','',''),(1545,959,'湖北人才',9,9,'','',''),(1546,959,'山西人才',19,11,'','',''),(1547,959,'天津人才',-1,11,'','',''),(1554,838,'上海报刊',-2,38,'','',''),(1553,838,'北京报刊',-3,17,'','',''),(1555,838,'天津报刊',-1,4,'','',''),(1551,959,'广西人才',15,15,'','',''),(1552,959,'港澳台人才',28,15,'','',''),(1556,838,'重庆报刊',0,7,'','',''),(1557,838,'广东报刊',1,49,'','',''),(1558,838,'江苏报刊',2,11,'','',''),(1559,838,'山东报刊',3,28,'','',''),(1560,838,'浙江报刊',4,30,'','',''),(1561,838,'河南报刊',5,18,'','',''),(1562,838,'河北报刊',6,9,'','',''),(1563,838,'辽宁报刊',7,19,'','',''),(1564,838,'四川报刊',8,23,'','',''),(1565,838,'湖北报刊',9,18,'','',''),(1566,838,'福建报刊',10,25,'','',''),(1567,838,'湖南报刊',11,19,'','',''),(1568,838,'黑龙江报刊',12,5,'','',''),(1569,838,'安徽报刊',13,13,'','',''),(1570,838,'江西报刊',14,8,'','',''),(1571,838,'广西报刊',15,15,'','',''),(1572,838,'吉林报刊',16,9,'','',''),(1573,838,'云南报刊',17,10,'','',''),(1574,838,'陕西报刊',18,9,'','',''),(1575,838,'山西报刊',19,14,'','',''),(1576,838,'内蒙古报刊',20,4,'','',''),(1577,838,'新疆报刊',21,0,'','',''),(1578,838,'贵州报刊',22,6,'','',''),(1579,838,'甘肃报刊',23,3,'','',''),(1580,838,'海南报刊',24,8,'','',''),(1581,838,'青海报刊',25,1,'','',''),(1582,838,'宁夏报刊',26,3,'','',''),(1583,838,'西藏报刊',27,1,'','',''),(1584,838,'香港报刊',28,7,'','',''),(1585,838,'澳门报刊',29,5,'','',''),(1586,838,'台湾报刊',30,6,'','',''),(1938,1936,'天津论坛',3,5,'','',''),(1588,4,'设计',123,0,'design','',''),(2102,1588,'平面设计',2,10,'','',''),(1596,2226,'Wap网址',107,0,'wap','',''),(1597,1596,'WAP搜索',1,5,'','',''),(1598,1596,'综合门户',2,25,'','',''),(1599,1596,'论坛社区',5,19,'','',''),(1600,1596,'图铃娱乐',3,13,'','',''),(1601,1596,'移动书城',4,18,'','',''),(1604,755,'上海电台',3,6,'','',''),(1605,755,'天津电台',2,7,'','',''),(1606,755,'河北电台',100,5,'','',''),(1607,755,'山东电台',100,11,'','',''),(1608,755,'山西电台',100,4,'','',''),(1609,755,'内蒙古电台',104,3,'','',''),(1610,755,'江苏电台',100,9,'','',''),(1611,755,'浙江电台',100,8,'','',''),(1612,755,'安徽电台',100,1,'','',''),(1613,755,'福建电台',100,9,'','',''),(1614,755,'广东电台',100,12,'','',''),(1615,755,'广西电台',100,2,'','',''),(1616,755,'河南电台',100,7,'','',''),(1617,755,'湖北电台',100,7,'','',''),(1618,755,'湖南电台',100,4,'','',''),(1619,755,'江西电台',100,5,'','',''),(1620,755,'辽宁电台',100,7,'','',''),(1621,755,'吉林电台',100,2,'','',''),(1622,755,'黑龙江电台',100,2,'','',''),(1623,755,'陕西电台',100,6,'','',''),(1624,755,'宁夏电台',100,1,'','',''),(1625,755,'甘肃电台',100,1,'','',''),(1626,755,'青海电台',101,1,'','',''),(1627,755,'新疆电台',102,3,'','',''),(1628,755,'重庆电台',100,0,'','',''),(1629,755,'四川电台',100,4,'','',''),(1630,755,'贵州电台',100,2,'','',''),(1631,755,'云南电台',100,2,'','',''),(1632,755,'西藏电台',103,0,'','',''),(1633,755,'台湾电台',100,0,'','',''),(1634,755,'香港电台',100,1,'','',''),(1635,755,'澳门电台',105,1,'','',''),(1645,1251,'基金理财',1,10,'','',''),(1646,1251,'外汇资讯',6,8,'','',''),(1647,1251,'期货资讯',7,4,'','',''),(1648,1251,'黄金资讯',8,5,'','',''),(1649,1251,'证券债券',3,10,'','',''),(1687,2204,'港澳台银行',4,20,'','',''),(1652,1251,'风险投资',9,2,'','',''),(1662,1168,'报价交易',2,9,'','',''),(1663,1168,'二手车',4,8,'','',''),(1664,1168,'汽车论坛',3,10,'','',''),(1665,2175,'各地汽车网',5,26,'','',''),(1666,2175,'汽车品牌',6,50,'','',''),(1670,2150,'武术',12,14,'','',''),(1671,2150,'棋牌',11,21,'','',''),(1672,2223,'舞蹈',2,6,'','',''),(1673,2150,'钓鱼',10,12,'','',''),(1675,2150,'水上运动',23,8,'','',''),(1676,2150,'冰雪运动',22,4,'','',''),(1677,2150,'民间体育',21,7,'','',''),(1678,927,'健美健身',20,5,'','',''),(2152,1020,'足球彩票',2,5,'','',''),(1680,2223,'乐器',3,15,'','',''),(2168,725,'国防教育',100,0,'','',''),(1682,1682,'网吧技术',6,0,'Wangba_Lianmeng','',''),(2092,2091,'中国各地铁通',100,30,'','',''),(1690,946,'中国大学排行榜',3,5,'','',''),(1691,2246,'校园综合',1,13,'','',''),(1700,1682,'网吧综合',1,30,'','',''),(1701,1143,'免费在线翻译',3,14,'','',''),(1702,2199,'免费网络硬盘',2,9,'','',''),(1706,1082,'体育组织',7,29,'','',''),(1707,1082,'软件公司',12,34,'','',''),(1708,2203,'国外医院',5,17,'','',''),(1714,1076,'MP3搜索',2,5,'','',''),(1715,1076,'免费登陆口',4,5,'','',''),(1716,1152,'源码下载',2,14,'','',''),(2138,851,'快递物流',10,10,'','',''),(2053,2050,'非洲旅游局',3,2,'','',''),(1720,851,'网上支付',9,10,'pay_tools','',''),(1722,871,'天津医院',2,11,'','',''),(1723,871,'河北医院',100,12,'','',''),(1724,871,'山西医院',100,6,'','',''),(1725,871,'内蒙古医院',100,3,'','',''),(1726,871,'辽宁医院',100,12,'','',''),(1727,871,'吉林医院',100,9,'','',''),(1728,871,'黑龙江医院',100,12,'','',''),(1729,871,'上海医院',3,32,'','',''),(1730,871,'江苏医院',100,24,'','',''),(1731,871,'浙江医院',100,14,'','',''),(1732,871,'安徽医院',100,7,'','',''),(1733,871,'福建医院',100,21,'','',''),(1734,871,'江西医院',100,11,'','',''),(1735,871,'山东医院',100,10,'','',''),(1736,871,'河南医院',100,10,'','',''),(1737,871,'湖北医院',100,10,'','',''),(1738,871,'湖南医院',100,7,'','',''),(1739,871,'广东医院',100,30,'','',''),(1740,871,'广西医院',100,8,'','',''),(1741,871,'海南医院',100,5,'','',''),(1742,871,'重庆医院',100,5,'','',''),(1743,871,'四川医院',100,2,'','',''),(1744,871,'贵州医院',100,6,'','',''),(1745,871,'云南医院',100,6,'','',''),(1746,871,'西藏医院',100,1,'','',''),(1747,871,'陕西医院',100,4,'','',''),(1748,871,'甘肃医院',100,3,'','',''),(1749,871,'宁夏医院',100,4,'','',''),(1750,871,'新疆医院',100,2,'','',''),(1751,871,'香港医院',101,3,'','',''),(1752,871,'澳门医院',102,4,'','',''),(1753,871,'台湾医院',103,6,'','',''),(1754,871,'青海医院',100,2,'','',''),(2201,734,'奢侈品',3,5,'','',''),(1756,2159,'工程研究中心',16,26,'','',''),(1757,2159,'中外科技网站',18,28,'','',''),(1758,2159,'科学研究机构',15,18,'','',''),(2056,2155,'NBA球队',4,29,'','',''),(2203,863,'医疗相关',6,0,'','',''),(1761,878,'地方房产',3,6,'','',''),(1762,1761,'北京房产',1,8,'','',''),(1763,1761,'天津房产',2,3,'','',''),(1764,1761,'河北房产',99,2,'','',''),(1765,1761,'山西房产',100,1,'','',''),(1766,1761,'内蒙古房产',104,1,'','',''),(1767,1761,'辽宁房产',99,7,'','',''),(1768,1761,'吉林房产',100,1,'','',''),(1769,1761,'黑龙江房产',100,2,'','',''),(1770,1761,'上海房产',3,13,'','',''),(1771,1761,'江苏房产',99,8,'','',''),(1772,1761,'浙江房产',99,7,'','',''),(1773,1761,'安徽房产',100,3,'','',''),(1774,1761,'福建房产',99,12,'','',''),(1775,1761,'江西房产',99,5,'','',''),(1776,1761,'山东房产',99,10,'','',''),(1777,1761,'河南房产',99,4,'','',''),(1778,1761,'湖北房产',99,4,'','',''),(1779,1761,'湖南房产',99,1,'','',''),(1780,1761,'广东房产',99,12,'','',''),(1781,1761,'广西房产',99,6,'','',''),(1782,1761,'海南房产',100,2,'','',''),(1783,1761,'重庆房产',100,2,'','',''),(1784,1761,'四川房产',100,4,'','',''),(1785,1761,'贵州房产',100,1,'','',''),(1786,1761,'云南房产',100,2,'','',''),(1787,1761,'西藏房产',100,1,'','',''),(1788,1761,'陕西房产',99,3,'','',''),(1789,1761,'甘肃房产',100,2,'','',''),(1790,1761,'青海房产',101,2,'','',''),(1791,1761,'宁夏房产',100,1,'','',''),(1792,1761,'新疆房产',102,1,'','',''),(1793,1761,'香港房产',105,0,'','',''),(1794,1761,'台湾房产',106,0,'','',''),(1797,893,'北京旅游',1,23,'','',''),(1798,893,'天津旅游',2,10,'','',''),(1799,893,'河北旅游',100,5,'','',''),(1800,893,'山西旅游',100,8,'','',''),(1801,893,'内蒙古旅游',100,5,'','',''),(1802,893,'辽宁旅游',100,17,'','',''),(1803,893,'吉林旅游',100,8,'','',''),(1804,893,'黑龙江旅游',100,15,'','',''),(1805,893,'上海旅游',3,10,'','',''),(1806,893,'江苏旅游',100,29,'','',''),(1807,893,'浙江旅游',100,20,'','',''),(1808,893,'安徽旅游',100,15,'','',''),(1809,893,'福建旅游',100,19,'','',''),(1810,893,'江西旅游',100,15,'','',''),(1811,893,'山东旅游',100,12,'','',''),(1812,893,'河南旅游',100,18,'','',''),(1813,893,'湖北旅游',100,14,'','',''),(1814,893,'湖南旅游',100,22,'','',''),(1815,893,'广东旅游',100,18,'','',''),(1816,893,'广西旅游',100,21,'','',''),(1817,893,'海南旅游',100,18,'','',''),(1818,893,'重庆旅游',100,13,'','',''),(1819,893,'四川旅游',100,31,'','',''),(1820,893,'贵州旅游',100,14,'','',''),(1821,893,'云南旅游',100,15,'','',''),(1822,893,'西藏旅游',100,11,'','',''),(1823,893,'陕西旅游',100,12,'','',''),(1824,893,'甘肃旅游',100,10,'','',''),(1825,893,'青海旅游',100,8,'','',''),(1826,893,'宁夏旅游',100,9,'','',''),(1827,893,'新疆旅游',100,12,'','',''),(1828,893,'香港旅游',101,11,'','',''),(1829,893,'澳门旅游',102,5,'','',''),(1830,893,'台湾旅游',103,10,'','',''),(1832,905,'亚洲地区',100,20,'','',''),(1833,905,'欧洲地区',100,46,'','',''),(1834,905,'北美地区',100,11,'','',''),(1835,905,'南美地区',100,4,'','',''),(1836,905,'非洲地区',100,3,'','',''),(1837,905,'大洋地区',100,3,'','',''),(1838,902,'北京政府机构',1,19,'','',''),(1839,902,'天津政府机构',2,11,'','',''),(1840,902,'河北政府机构',100,12,'','',''),(1841,902,'山西政府机构',100,11,'','',''),(1842,902,'内蒙古政府机构',103,15,'','',''),(1843,902,'辽宁政府机构',100,12,'','',''),(1844,902,'吉林政府机构',100,9,'','',''),(1845,902,'黑龙江政府机构',100,12,'','',''),(1846,902,'上海政府机构',3,18,'','',''),(1847,902,'江苏政府机构',100,14,'','',''),(1848,902,'浙江政府机构',100,11,'','',''),(1849,902,'安徽政府机构',100,18,'','',''),(1850,902,'福建政府机构',100,10,'','',''),(1851,902,'江西政府机构',100,11,'','',''),(1852,902,'山东政府机构',100,17,'','',''),(1853,902,'河南政府机构',100,19,'','',''),(1854,902,'湖北政府机构',100,16,'','',''),(1855,902,'湖南政府机构',100,9,'','',''),(1856,902,'广东政府机构',100,20,'','',''),(1857,902,'广西政府机构',100,10,'','',''),(1858,902,'海南政府机构',100,7,'','',''),(1859,902,'重庆政府机构',100,16,'','',''),(1860,902,'四川政府机构',100,19,'','',''),(1861,902,'贵州政府机构',100,16,'','',''),(1862,902,'云南政府机构',100,16,'','',''),(1863,902,'西藏政府机构',100,3,'','',''),(1864,902,'陕西政府机构',100,20,'','',''),(1865,902,'甘肃政府机构',100,13,'','',''),(1866,902,'青海政府机构',101,4,'','',''),(1867,902,'宁夏政府机构',100,5,'','',''),(1868,902,'新疆政府机构',102,0,'','',''),(1869,902,'香港特区政府',104,11,'','',''),(1870,902,'澳门特区政府',105,12,'','',''),(1871,2188,'服饰品牌',5,58,'','',''),(1872,2188,'餐饮食品',2,37,'','',''),(1873,2188,'生活日用',3,20,'','',''),(1874,2188,'汽车品牌',7,18,'','',''),(1875,2188,'家电品牌',8,43,'','',''),(1876,2188,'品牌电脑',9,18,'','',''),(1877,2188,'手机品牌',6,14,'','',''),(1878,912,'法律法规',2,15,'','',''),(1879,912,'法律援助',4,12,'','',''),(1880,2205,'商标法',6,17,'','',''),(1884,2225,'网上求助',6,6,'','',''),(2198,4,'电脑',104,0,'computer','',''),(1921,2168,'军事院校',6,9,'','',''),(1934,2209,'女性论坛',18,17,'','',''),(1935,2209,'服饰论坛',19,15,'','',''),(1939,1936,'河北论坛',14,8,'','',''),(1940,1936,'山西论坛',13,8,'','',''),(1941,1936,'内蒙古论坛',31,4,'','',''),(1942,1936,'辽宁论坛',25,7,'','',''),(1943,1936,'吉林论坛',16,3,'','',''),(1944,1936,'黑龙江论坛',5,4,'','',''),(1945,1936,'上海论坛',2,10,'','',''),(1946,1936,'江苏论坛',17,15,'','',''),(1947,1936,'浙江论坛',18,25,'','',''),(1948,1936,'安徽论坛',19,12,'','',''),(1949,1936,'福建论坛',20,17,'','',''),(1950,1936,'江西论坛',21,4,'','',''),(1951,1936,'山东论坛',22,17,'','',''),(1952,1936,'河南论坛',23,9,'','',''),(1953,1936,'湖北论坛',24,12,'','',''),(1954,1936,'湖南论坛',27,7,'','',''),(1955,1936,'广东论坛',8,26,'','',''),(1956,1936,'广西论坛',26,7,'','',''),(1957,1936,'海南论坛',15,5,'','',''),(1958,1936,'重庆论坛',4,6,'','',''),(1959,1936,'四川论坛',6,6,'','',''),(1960,1936,'贵州论坛',7,4,'','',''),(1961,1936,'云南论坛',28,3,'','',''),(1962,1936,'西藏论坛',30,2,'','',''),(1963,1936,'陕西论坛',8,5,'','',''),(1964,1936,'甘肃论坛',9,5,'','',''),(1965,1936,'青海论坛',10,2,'','',''),(1966,1936,'宁夏论坛',11,6,'','',''),(1967,1936,'新疆论坛',29,5,'','',''),(1968,1936,'香港论坛',101,4,'','',''),(1969,1936,'澳门论坛',102,3,'','',''),(1970,1936,'台湾论坛',103,1,'','',''),(1979,2209,'设计论坛',21,25,'','',''),(1980,2212,'影视资讯',5,14,'','',''),(2272,2034,'NBA直播',0,4,'','',''),(1984,1076,'搜索工具及相关',6,5,'','',''),(1985,2091,'中国各地移动',6,34,'','',''),(1986,2091,'中国各地联通',7,28,'','',''),(2169,1152,'各类编程学习',3,0,'','',''),(1988,2091,'中国各地电信',5,29,'','',''),(2276,831,'时事论坛',3,5,'','',''),(1990,851,'导购/打折',2,16,'','',''),(1991,851,'数码/家电',3,8,'','',''),(1992,851,'女性/母婴',5,10,'','',''),(2052,2050,'欧洲旅游局',2,13,'','',''),(1994,2175,'热门车型',8,34,'','',''),(1995,856,'保险公司',3,10,'','',''),(1996,2148,'热门基金公司',9,49,'','',''),(1997,1251,'基金数据',4,10,'','',''),(2204,856,'各地银行',5,0,'','',''),(2000,1044,'英语学习论坛',3,4,'','',''),(2263,3,'高考',5,0,'gaokao','',''),(2003,2161,'专业类考试',12,20,'','',''),(2004,1082,'著名通讯社',10,22,'','',''),(2030,1596,'博客影漫',8,10,'','',''),(2032,851,'两性/保健',4,6,'','',''),(2044,741,'QQ空间代码',3,10,'','',''),(2148,842,'财经相关',100,0,'','',''),(2147,1095,'硬件相关',100,0,'','',''),(2091,2,'通信',120,0,'tongxin','',''),(2094,2149,'中国科研院所',8,14,'','',''),(2114,2220,'流量统计',3,9,'','',''),(2099,2212,'电影字幕',9,5,'','',''),(2106,1588,'设计综合',0,20,'','',''),(2109,2220,'站长工具',2,20,'','',''),(2115,2155,'篮球协会',6,14,'','',''),(2116,2034,'篮球综合',2,4,'','',''),(2120,4,'BT',106,0,'BT','',''),(2121,652,'摄影综合',1,14,'','',''),(2122,652,'摄影论坛',3,9,'','',''),(2144,1711,'数码品牌',1,39,'','',''),(2139,856,'信用卡资讯',4,4,'','',''),(2140,2209,'动漫论坛',16,2,'','',''),(2141,698,'网页游戏',3,10,'','',''),(2161,3,'考试',4,0,'kaoshi','',''),(2166,2224,'伊斯兰教网址',4,4,'','',''),(2171,2169,'Ajax',100,2,'','',''),(2172,824,'明星全接触',3,0,'','',''),(2173,924,'地方礼品/工艺品',100,0,'','',''),(2174,924,'鲜花',2,5,'','',''),(2175,1168,'厂商/品牌/车型',100,0,'','',''),(2176,2175,'各地二手车网',100,20,'','',''),(2177,1168,'驾校学车',6,4,'','',''),(2178,899,'国家机构',0,4,'','',''),(2179,899,'中国政府机构',2,0,'','',''),(2180,899,'国务院组成部门',1,23,'','',''),(2182,2179,'国务院直属机构',100,20,'','',''),(2183,2179,'国务院办事机构',100,4,'','',''),(2184,2179,'国务院事业单位',100,27,'','',''),(2185,2179,'国务院部委管理国家局',100,10,'','',''),(2186,899,'国际/区域组织',4,0,'','',''),(2213,1,'网游',119,0,'http://game.114la.com/','',''),(2215,1,'小游戏',121,0,'xiaoyouxi','',''),(2216,2,'天气',101,0,'http://weather.114la.com/weather.htm','',''),(2217,2,'查询',102,0,'http://tool.114la.com/','',''),(2218,2,'女性',114,0,'lady','',''),(2219,4,'桌面',107,0,'desktop','',''),(2220,2226,'站长工具',125,0,'webtool','',''),(2240,2239,'交通',100,10,'','',''),(2222,4,'非主流',128,0,'http://qq.114la.com/','',''),(2223,3,'曲艺',10,0,'quyi','',''),(2224,3,'宗教',14,0,'zongjiao','',''),(2225,3,'公益',15,0,'gongyi','',''),(2226,0,'其他类别',5,0,'','',''),(2241,2239,'航空',100,10,'','',''),(2228,2226,'行业网站',104,0,'html/trade_sites.htm','',''),(2229,2226,'杀毒防毒',108,0,'shadu','',''),(2234,2218,'减肥',100,8,'','',''),(2235,662,'两性论坛',3,5,'','',''),(2236,662,'男士女性',4,14,'','',''),(2237,2223,'魔术杂技',4,5,'','',''),(2238,2223,'地方戏',5,11,'','',''),(2242,803,'免费电影',2,8,'','',''),(2246,3,'校园',9,0,'xiaoyuan','',''),(2253,698,'小游戏',2,5,'','',''),(2254,2215,'合金弹头',100,8,'','',''),(2255,2215,'火影忍者',100,8,'','',''),(2256,2215,'格斗小游戏',100,8,'','',''),(2258,715,'轻音乐',3,5,'','',''),(2260,1121,'网络编辑',100,3,'','',''),(2261,2226,'奇趣酷站',119,0,'cool','',''),(2262,2261,'搜趣探奇',100,25,'','',''),(2264,3,'考研',6,0,'kaoyan','',''),(2268,2229,'木马/恶意插件查杀',100,10,'','','');

/*Table structure for table `uchome_siteconfig` */

DROP TABLE IF EXISTS `uchome_siteconfig`;

CREATE TABLE `uchome_siteconfig` (
  `yl_name` varchar(30) NOT NULL default '',
  `yl_value` text NOT NULL,
  PRIMARY KEY  (`yl_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_siteconfig` */

insert  into `uchome_siteconfig`(`yl_name`,`yl_value`) values ('yl_admingd','0'),('yl_cc','1'),('yl_ceoconnect','http://www.114la.com'),('yl_ceoemail','OpenSource@ylmf.com'),('yl_ckpath','/'),('yl_clickcount','1'),('yl_cvtime','0'),('yl_datefm','Y-m-j H:i'),('yl_debug','0'),('yl_footertime','1'),('yl_hash','djfdosp^%&^21313ffsdfsd'),('yl_icp',''),('yl_icpurl','http://www.miibeian.gov.cn'),('yl_ifjump','1'),('yl_ipban',''),('yl_ipstat','请在此处输入统计代码！'),('yl_ipstates','1'),('yl_loadavg','2'),('yl_lp','1'),('yl_metadescrip','114La,114La网址导航,114La上网导航,网址之家,网址大全,网址,搜索,音乐,娱乐,图片,小游戏,短信,社区,日记,相册,K歌,通讯簿,BLOG,天气预报,实用工具.最方便,最快捷,最多华人使用的上网导航'),('yl_metakeyword','114,114La,网址导航,上网导航,网址,搜索,音乐,娱乐,图片,社区,BLOG,黄页，企业名录,114查询,网上黄页'),('yl_obstart','1'),('yl_proxy','1'),('yl_refreshtime','0'),('yl_sysname','114啦[Www.114La.Com] -上网就上114啦！'),('yl_sysopen','1'),('yl_sysurl','http://www.114la.com'),('yl_timedf','8'),('yl_isp','1'),('yl_mulindex',''),('yl_enmemcache','0'),('yl_memcacheserver','192.168.1.233'),('yl_memcacheport','11211'),('yl_sendemail','1'),('yl_sendemailtype','0'),('yl_fromemail',''),('yl_smtpserver',''),('yl_smtpport','25'),('yl_smtpssl','0'),('yl_smtpauth','1'),('yl_smtpid',''),('yl_smtppass',''),('yl_display_update_info','1'),('yl_ckdomain',''),('yl_path_html','/html'),('yl_verify_code','0'),('yl_make_html_realtime','0');

/*Table structure for table `uchome_sitefeed` */

DROP TABLE IF EXISTS `uchome_sitefeed`;

CREATE TABLE `uchome_sitefeed` (
  `feedid` int(10) unsigned NOT NULL default '0',
  `appid` smallint(6) unsigned NOT NULL default '0',
  `icon` varchar(30) NOT NULL default '',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(15) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `friend` tinyint(1) NOT NULL default '0',
  `hash_template` varchar(32) NOT NULL default '',
  `hash_data` varchar(32) NOT NULL default '',
  `title_template` text NOT NULL,
  `title_data` text NOT NULL,
  `body_template` text NOT NULL,
  `body_data` text NOT NULL,
  `body_general` text NOT NULL,
  `image_1` varchar(255) NOT NULL default '',
  `image_1_link` varchar(255) NOT NULL default '',
  `image_2` varchar(255) NOT NULL default '',
  `image_2_link` varchar(255) NOT NULL default '',
  `image_3` varchar(255) NOT NULL default '',
  `image_3_link` varchar(255) NOT NULL default '',
  `image_4` varchar(255) NOT NULL default '',
  `image_4_link` varchar(255) NOT NULL default '',
  `target_ids` text NOT NULL,
  `id` mediumint(8) unsigned NOT NULL default '0',
  `idtype` varchar(15) NOT NULL default '',
  `hot` mediumint(8) unsigned NOT NULL default '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_sitefeed` */

insert  into `uchome_sitefeed`(`feedid`,`appid`,`icon`,`uid`,`username`,`dateline`,`friend`,`hash_template`,`hash_data`,`title_template`,`title_data`,`body_template`,`body_data`,`body_general`,`image_1`,`image_1_link`,`image_2`,`image_2_link`,`image_3`,`image_3_link`,`image_4`,`image_4_link`,`target_ids`,`id`,`idtype`,`hot`) values (37,1,'blog',3,'lele',1264752700,0,'2c24ba00fafd81b79f331389e04a26cb','3807b879dc790be9ac78863a4eba880e','{actor} 发表了新日志','N;','<b>{subject}</b><br>{summary}','a:2:{s:7:\"subject\";s:65:\"<a href=\"space.php?uid=3&do=blog&id=24\">用户栈开始内容</a>\";s:7:\"summary\";s:149:\"when the userspace receives control, the stack layout has a fixed format. The rough order is this:    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;lt;ar\";}','','','','','','','','','','',24,'blogid',1),(39,1,'blog',1,'admin',1263497380,2,'2c24ba00fafd81b79f331389e04a26cb','40ee73c7cfdd6863104282021e7504e1','{actor} 发表了新日志','N;','<b>{subject}</b><br>{summary}','a:2:{s:7:\"subject\";s:56:\"<a href=\"space.php?uid=1&do=blog&id=18\">ppp 获取IP</a>\";s:7:\"summary\";s:101:\"osk中PPPoe 获取IP后，调用sys-stub.c 中的sifaddr设置vip，    而其他方式则是setItfIp\";}','','','','','','','','','','3',18,'blogid',50),(66,1,'share',10,'ramen.sh@gmail.',1276289389,0,'a31d0d94b8d0641426a1b149afc7086e','691cb856febfcc31ec4cb1d1f0549de8','{actor} 分享了一个网址','N;','{link}','a:2:{s:4:\"link\";s:180:\"<a href=\"http://search.haoting.com/user/search1.asp?word=%C7%F4%C4%F1&amp;wofrdf=%C7%F4%C4%F1&amp;type=1&amp;more=true\" target=\"_blank\">http://search.haoting. ... 3Bmore%3Dtrue</a>\";s:4:\"data\";s:109:\"http://search.haoting.com/user/search1.asp?word=%C7%F4%C4%F1&amp;wofrdf=%C7%F4%C4%F1&amp;type=1&amp;more=true\";}','','','','','','','','','','',10,'sid',0);

/*Table structure for table `uchome_sitetag` */

DROP TABLE IF EXISTS `uchome_sitetag`;

CREATE TABLE `uchome_sitetag` (
  `tagid` mediumint(8) unsigned NOT NULL auto_increment,
  `tagname` char(30) NOT NULL default '',
  `taghash` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `totalnum` smallint(6) unsigned NOT NULL default '0',
  `close` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`tagid`)
) ENGINE=MyISAM AUTO_INCREMENT=47 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_sitetag` */

insert  into `uchome_sitetag`(`tagid`,`tagname`,`taghash`,`dateline`,`totalnum`,`close`) values (1,'小说',412900,0,5,0),(2,'历史',363602,0,1,0),(3,'军事',354363,1283824136,1,0),(5,'当当网',6670209,1283836200,0,0),(6,'当当',414851,1283836200,0,0),(7,'网上购物',16777215,1283836200,0,0),(8,'网上商城',16777215,1283836200,0,0),(9,'网上买书',16777215,1283836200,0,0),(10,'购物中心',16777215,1283836200,0,0),(11,'在线购物',16777215,1283836200,0,0),(12,'图书',376390,1283836200,0,0),(13,'影视',426198,1283836200,0,0),(14,'音像',643071,1283836200,0,0),(15,'教育音像',16777215,1283836200,0,0),(16,'DVD',18852,1283836200,0,0),(17,'百货',521479,1283836200,0,0),(18,'母婴',464708,1283836200,0,0),(19,'家居',399269,1283836200,0,0),(20,'家纺',408090,1283836200,0,0),(21,'厨具',363511,1283836200,0,0),(22,'化妆品',5833505,1283836200,0,0),(23,'美妆',545382,1283836200,0,0),(24,'个人护理用品',16777215,1283836200,0,0),(25,'数码',446209,1283836200,0,0),(26,'电脑',513121,1283836200,0,0),(27,'笔记本',8664620,1283836200,0,0),(28,'u盘',32296,1283836200,0,0),(29,'手机',429034,1283836200,0,0),(30,'mp3',29747,1283836200,0,0),(31,'mp4',29748,1283836200,0,0),(32,'数码相机',16777215,1283836200,0,0),(33,'摄影',435121,1283836200,0,0),(34,'摄像',431375,1283836200,0,0),(35,'家电',405653,1283836200,0,0),(36,'软件',607718,1283836200,0,0),(37,'游戏',476559,1283836200,0,0),(38,'服装',457109,1283836200,0,0),(39,'鞋',38795,1283836200,0,0),(40,'礼品箱包',16777215,1283836200,0,0),(41,'钟表首饰',16777215,1283836200,0,0),(42,'玩具',494599,1283836200,0,0),(43,'运动健康用品\n',16777215,1283836200,0,0),(44,'言情',590021,1284542063,1,0),(45,'新闻',454907,1284542621,2,0),(46,'Array',4757641,1284639714,46,0);

/*Table structure for table `uchome_sitetagsite` */

DROP TABLE IF EXISTS `uchome_sitetagsite`;

CREATE TABLE `uchome_sitetagsite` (
  `tagid` mediumint(8) unsigned NOT NULL default '0',
  `siteid` mediumint(8) unsigned NOT NULL default '0',
  `linkid` mediumint(8) unsigned NOT NULL default '0',
  `bmid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_sitetagsite` */

insert  into `uchome_sitetagsite`(`tagid`,`siteid`,`linkid`,`bmid`,`uid`) values (1,41145,0,0,0),(45,3107,0,0,0),(2,41145,0,0,0),(46,0,6,0,0),(1,0,0,171,10),(3,0,0,171,10),(1,1,0,0,0),(6,0,0,162,10),(5,0,0,162,10),(7,0,0,162,10),(8,0,0,162,10),(9,0,0,162,10),(10,0,0,162,10),(11,0,0,162,10),(12,0,0,162,10),(13,0,0,162,10),(14,0,0,162,10),(15,0,0,162,10),(16,0,0,162,10),(17,0,0,162,10),(18,0,0,162,10),(19,0,0,162,10),(20,0,0,162,10),(21,0,0,162,10),(22,0,0,162,10),(23,0,0,162,10),(24,0,0,162,10),(25,0,0,162,10),(26,0,0,162,10),(27,0,0,162,10),(28,0,0,162,10),(29,0,0,162,10),(30,0,0,162,10),(31,0,0,162,10),(32,0,0,162,10),(33,0,0,162,10),(34,0,0,162,10),(35,0,0,162,10),(36,0,0,162,10),(37,0,0,162,10),(38,0,0,162,10),(39,0,0,162,10),(40,0,0,162,10),(41,0,0,162,10),(42,0,0,162,10),(43,0,0,162,10),(1,1,0,0,0),(44,1,0,0,0),(1,38983,0,0,0),(45,3106,0,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0),(46,0,6,0,0),(46,0,1,0,0);

/*Table structure for table `uchome_space` */

DROP TABLE IF EXISTS `uchome_space`;

CREATE TABLE `uchome_space` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `groupid` smallint(6) unsigned NOT NULL default '0',
  `credit` int(10) NOT NULL default '0',
  `experience` int(10) NOT NULL default '0',
  `username` char(32) NOT NULL default '',
  `name` char(20) NOT NULL default '',
  `linknum` smallint(6) NOT NULL default '0',
  `bmdirnum` smallint(6) NOT NULL default '0',
  `lastmodified` char(32) NOT NULL default '',
  `namestatus` tinyint(1) NOT NULL default '0',
  `videostatus` tinyint(1) NOT NULL default '0',
  `domain` char(15) NOT NULL default '',
  `friendnum` int(10) unsigned NOT NULL default '0',
  `viewnum` int(10) unsigned NOT NULL default '0',
  `notenum` int(10) unsigned NOT NULL default '0',
  `addfriendnum` smallint(6) unsigned NOT NULL default '0',
  `mtaginvitenum` smallint(6) unsigned NOT NULL default '0',
  `eventinvitenum` smallint(6) unsigned NOT NULL default '0',
  `myinvitenum` smallint(6) unsigned NOT NULL default '0',
  `pokenum` smallint(6) unsigned NOT NULL default '0',
  `doingnum` smallint(6) unsigned NOT NULL default '0',
  `blognum` smallint(6) unsigned NOT NULL default '0',
  `albumnum` smallint(6) unsigned NOT NULL default '0',
  `threadnum` smallint(6) unsigned NOT NULL default '0',
  `pollnum` smallint(6) unsigned NOT NULL default '0',
  `eventnum` smallint(6) unsigned NOT NULL default '0',
  `sharenum` smallint(6) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `updatetime` int(10) unsigned NOT NULL default '0',
  `lastsearch` int(10) unsigned NOT NULL default '0',
  `lastpost` int(10) unsigned NOT NULL default '0',
  `lastlogin` int(10) unsigned NOT NULL default '0',
  `lastsend` int(10) unsigned NOT NULL default '0',
  `attachsize` int(10) unsigned NOT NULL default '0',
  `addsize` int(10) unsigned NOT NULL default '0',
  `addfriend` smallint(6) unsigned NOT NULL default '0',
  `flag` tinyint(1) NOT NULL default '0',
  `newpm` smallint(6) unsigned NOT NULL default '0',
  `avatar` tinyint(1) NOT NULL default '0',
  `regip` char(15) NOT NULL default '',
  `ip` int(10) unsigned NOT NULL default '0',
  `mood` smallint(6) unsigned NOT NULL default '0',
  `style` tinyint(2) unsigned NOT NULL default '0',
  PRIMARY KEY  (`uid`),
  KEY `username` (`username`),
  KEY `domain` (`domain`),
  KEY `ip` (`ip`),
  KEY `updatetime` (`updatetime`),
  KEY `mood` (`mood`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_space` */

insert  into `uchome_space`(`uid`,`groupid`,`credit`,`experience`,`username`,`name`,`linknum`,`bmdirnum`,`lastmodified`,`namestatus`,`videostatus`,`domain`,`friendnum`,`viewnum`,`notenum`,`addfriendnum`,`mtaginvitenum`,`eventinvitenum`,`myinvitenum`,`pokenum`,`doingnum`,`blognum`,`albumnum`,`threadnum`,`pollnum`,`eventnum`,`sharenum`,`dateline`,`updatetime`,`lastsearch`,`lastpost`,`lastlogin`,`lastsend`,`attachsize`,`addsize`,`addfriend`,`flag`,`newpm`,`avatar`,`regip`,`ip`,`mood`,`style`) values (1,1,1288,1278,'admin','admin',150,136,'12759632048978050',1,0,'',0,20,0,0,0,0,0,0,1,28,1,0,0,0,8,1256533858,1275962394,0,1269013828,1275962394,0,1295171,0,0,1,0,1,'192.168.115.1',192168115,0,0),(2,6,132,122,'ramen','',0,0,'0',0,0,'',0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1261707439,1261707463,0,1261707463,1273015459,0,0,0,0,0,0,0,'192.168.115.1',192168115,0,0),(3,5,88,77,'lele','',0,0,'0',0,0,'',0,5,1,0,0,0,0,0,0,3,0,0,0,0,0,1262551556,1264752700,0,1264768602,1273015486,0,0,0,0,0,0,0,'192.168.115.1',192168115,0,0),(4,6,150,135,'osk','',0,0,'0',0,0,'',0,2,0,0,0,0,0,0,0,6,0,0,0,0,0,1262551844,1264679950,0,1264679950,1264768741,0,0,0,0,0,0,0,'192.168.115.1',192168115,0,0),(5,1,40,30,'moyiqun','',0,0,'0',0,0,'',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1268063077,0,0,0,1275599326,0,0,0,0,0,0,0,'192.168.1.110',192168001,0,0),(6,5,25,15,'myqsq@sohu.com','沈大宝',0,0,'',0,0,'',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1274701531,0,0,0,1274702368,0,0,0,0,0,0,0,'192.168.115.1',192168115,0,0),(7,5,25,15,'myq@gmail.com','xiaoxiao',0,0,'',0,0,'',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1274709069,0,0,0,1274709069,0,0,0,0,0,0,0,'192.168.115.1',192168115,0,0),(8,1,40,30,'ra@123.com','1234',0,0,'',0,0,'',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1274717119,0,0,0,1275430782,0,0,0,0,1,0,0,'192.168.115.1',192168115,0,0),(9,5,25,15,'ra1@123.com','1234',0,0,'',0,0,'',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1274717309,0,0,0,1274717309,0,0,0,0,0,0,0,'192.168.115.1',192168115,0,0),(10,1,344,334,'ramen.sh@gmail.com','城市森林',8,2,'12846353656253510',0,0,'',0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,1275429834,1276290634,0,1276290634,1284708291,0,0,0,0,1,0,0,'192.168.115.1',192168115,0,0);

/*Table structure for table `uchome_spacefield` */

DROP TABLE IF EXISTS `uchome_spacefield`;

CREATE TABLE `uchome_spacefield` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `sex` tinyint(1) NOT NULL default '0',
  `email` varchar(100) NOT NULL default '',
  `newemail` varchar(100) NOT NULL default '',
  `emailcheck` tinyint(1) NOT NULL default '0',
  `mobile` varchar(40) NOT NULL default '',
  `qq` varchar(20) NOT NULL default '',
  `msn` varchar(80) NOT NULL default '',
  `msnrobot` varchar(15) NOT NULL default '',
  `msncstatus` tinyint(1) NOT NULL default '0',
  `videopic` varchar(32) NOT NULL default '',
  `birthyear` smallint(6) unsigned NOT NULL default '0',
  `birthmonth` tinyint(3) unsigned NOT NULL default '0',
  `birthday` tinyint(3) unsigned NOT NULL default '0',
  `blood` varchar(5) NOT NULL default '',
  `marry` tinyint(1) NOT NULL default '0',
  `birthprovince` varchar(20) NOT NULL default '',
  `birthcity` varchar(20) NOT NULL default '',
  `resideprovince` varchar(20) NOT NULL default '',
  `residecity` varchar(20) NOT NULL default '',
  `note` text NOT NULL,
  `spacenote` text NOT NULL,
  `authstr` varchar(20) NOT NULL default '',
  `theme` varchar(20) NOT NULL default '',
  `nocss` tinyint(1) NOT NULL default '0',
  `menunum` smallint(6) unsigned NOT NULL default '0',
  `css` text NOT NULL,
  `privacy` text NOT NULL,
  `friend` mediumtext NOT NULL,
  `feedfriend` mediumtext NOT NULL,
  `sendmail` text NOT NULL,
  `magicstar` tinyint(1) NOT NULL default '0',
  `magicexpire` int(10) unsigned NOT NULL default '0',
  `timeoffset` varchar(20) NOT NULL default '',
  `field_1` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_spacefield` */

/*Table structure for table `uchome_spaceinfo` */

DROP TABLE IF EXISTS `uchome_spaceinfo`;

CREATE TABLE `uchome_spaceinfo` (
  `infoid` mediumint(8) unsigned NOT NULL auto_increment,
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `type` varchar(20) NOT NULL default '',
  `subtype` varchar(20) NOT NULL default '',
  `title` text NOT NULL,
  `subtitle` varchar(255) NOT NULL default '',
  `friend` tinyint(1) NOT NULL default '0',
  `startyear` smallint(6) unsigned NOT NULL default '0',
  `endyear` smallint(6) unsigned NOT NULL default '0',
  `startmonth` smallint(6) unsigned NOT NULL default '0',
  `endmonth` smallint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`infoid`),
  KEY `uid` (`uid`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_spaceinfo` */

insert  into `uchome_spaceinfo`(`infoid`,`uid`,`type`,`subtype`,`title`,`subtitle`,`friend`,`startyear`,`endyear`,`startmonth`,`endmonth`) values (14,1,'base','residecity','','',0,0,0,0,0),(13,1,'base','birthcity','','',0,0,0,0,0),(12,1,'base','blood','','',0,0,0,0,0),(11,1,'base','birth','','',0,0,0,0,0),(10,1,'base','marry','','',0,0,0,0,0),(7,1,'contact','mobile','','',0,0,0,0,0),(8,1,'contact','qq','','',0,0,0,0,0),(9,1,'contact','msn','','',0,0,0,0,0),(15,1,'base','field_1','','',0,0,0,0,0);

/*Table structure for table `uchome_spacelog` */

DROP TABLE IF EXISTS `uchome_spacelog`;

CREATE TABLE `uchome_spacelog` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(15) NOT NULL default '',
  `opuid` mediumint(8) unsigned NOT NULL default '0',
  `opusername` char(15) NOT NULL default '',
  `flag` tinyint(1) NOT NULL default '0',
  `expiration` int(10) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`uid`),
  KEY `flag` (`flag`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_spacelog` */

/*Table structure for table `uchome_stat` */

DROP TABLE IF EXISTS `uchome_stat`;

CREATE TABLE `uchome_stat` (
  `daytime` int(10) unsigned NOT NULL default '0',
  `login` smallint(6) unsigned NOT NULL default '0',
  `register` smallint(6) unsigned NOT NULL default '0',
  `invite` smallint(6) unsigned NOT NULL default '0',
  `appinvite` smallint(6) unsigned NOT NULL default '0',
  `doing` smallint(6) unsigned NOT NULL default '0',
  `blog` smallint(6) unsigned NOT NULL default '0',
  `pic` smallint(6) unsigned NOT NULL default '0',
  `poll` smallint(6) unsigned NOT NULL default '0',
  `event` smallint(6) unsigned NOT NULL default '0',
  `share` smallint(6) unsigned NOT NULL default '0',
  `thread` smallint(6) unsigned NOT NULL default '0',
  `docomment` smallint(6) unsigned NOT NULL default '0',
  `blogcomment` smallint(6) unsigned NOT NULL default '0',
  `piccomment` smallint(6) unsigned NOT NULL default '0',
  `pollcomment` smallint(6) unsigned NOT NULL default '0',
  `pollvote` smallint(6) unsigned NOT NULL default '0',
  `eventcomment` smallint(6) unsigned NOT NULL default '0',
  `eventjoin` smallint(6) unsigned NOT NULL default '0',
  `sharecomment` smallint(6) unsigned NOT NULL default '0',
  `post` smallint(6) unsigned NOT NULL default '0',
  `wall` smallint(6) unsigned NOT NULL default '0',
  `poke` smallint(6) unsigned NOT NULL default '0',
  `click` smallint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`daytime`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_stat` */

insert  into `uchome_stat`(`daytime`,`login`,`register`,`invite`,`appinvite`,`doing`,`blog`,`pic`,`poll`,`event`,`share`,`thread`,`docomment`,`blogcomment`,`piccomment`,`pollcomment`,`pollvote`,`eventcomment`,`eventjoin`,`sharecomment`,`post`,`wall`,`poke`,`click`) values (20091026,2,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20091031,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20091102,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20091105,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20091106,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20091113,1,0,0,0,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20091114,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20091116,1,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20091122,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20091123,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20091221,1,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0),(20091225,3,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100104,2,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100109,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100110,3,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100115,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100122,2,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100124,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100127,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100128,2,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100129,2,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0),(20100131,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100203,1,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100204,2,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100205,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100206,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100214,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100218,1,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100215,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100223,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100224,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100226,1,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100227,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100225,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100303,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100304,1,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100308,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100309,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100312,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100319,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100321,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100424,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100505,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100506,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100524,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100525,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100602,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100604,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100608,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100609,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20100612,1,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0);

/*Table structure for table `uchome_statuser` */

DROP TABLE IF EXISTS `uchome_statuser`;

CREATE TABLE `uchome_statuser` (
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `daytime` int(10) unsigned NOT NULL default '0',
  `type` char(20) NOT NULL default '',
  KEY `uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_statuser` */

insert  into `uchome_statuser`(`uid`,`daytime`,`type`) values (10,0,'login');

/*Table structure for table `uchome_tag` */

DROP TABLE IF EXISTS `uchome_tag`;

CREATE TABLE `uchome_tag` (
  `tagid` mediumint(8) unsigned NOT NULL auto_increment,
  `tagname` char(30) NOT NULL default '',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `dateline` int(10) unsigned NOT NULL default '0',
  `blognum` smallint(6) unsigned NOT NULL default '0',
  `close` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`tagid`),
  KEY `tagname` (`tagname`)
) ENGINE=MyISAM AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_tag` */

insert  into `uchome_tag`(`tagid`,`tagname`,`uid`,`dateline`,`blognum`,`close`) values (1,'hello',1,1256548231,2,0),(2,'world',1,1256548231,1,0),(3,'sqlite',1,1257130283,1,0),(4,'速度',1,1257130283,1,0),(5,'LINGER',1,1258082657,1,0),(6,'tcp',1,1258082657,1,0),(7,'algorithm',1,1258101276,1,0),(8,'ack',1,1258101276,1,0),(9,'delayed',1,1258101276,1,0),(10,'窗口',1,1258169251,1,0),(11,'拥塞',1,1258169251,1,0),(12,'rule',1,1258187682,1,0),(13,'upnp',1,1258187682,1,0),(14,'kernel',1,1258330909,1,0),(15,'objdump',1,1258330909,1,0),(16,'igmp',1,1258875457,1,0),(17,'低电平',4,1262971990,1,0),(18,'mips',1,1263074442,1,0),(19,'flag',1,1263074442,1,0),(20,'set',1,1263074442,1,0),(21,'ppp',1,1263497380,1,0),(22,'获取',1,1263497380,1,0),(23,'port',4,1264272367,1,0),(24,'机房',4,1264272367,1,0),(25,'关系',4,1264272367,1,0),(26,'实验',4,1264272367,1,0),(27,'register',4,1264323511,1,0),(28,'clock',1,1265291035,1,0),(29,'sys',1,1265291035,1,0),(30,'uclinux',1,1265291035,1,0),(31,'ACK',1,1265291720,1,0),(32,'TCP',1,1265291720,1,0),(33,'csope',1,1266507335,1,0),(34,'jquery',1,1267115630,1,0),(35,'jQuery',1,1267115739,1,0),(36,'大全',1,1267115739,1,0);

/*Table structure for table `uchome_tagblog` */

DROP TABLE IF EXISTS `uchome_tagblog`;

CREATE TABLE `uchome_tagblog` (
  `tagid` mediumint(8) unsigned NOT NULL default '0',
  `blogid` mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY  (`tagid`,`blogid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_tagblog` */

insert  into `uchome_tagblog`(`tagid`,`blogid`) values (1,1),(1,18),(2,1),(3,3),(4,3),(5,5),(6,5),(7,6),(8,6),(9,6),(10,8),(11,8),(12,9),(13,9),(14,10),(15,10),(16,12),(17,14),(18,17),(19,17),(20,17),(21,18),(22,18),(23,20),(24,20),(25,20),(26,20),(27,21),(28,27),(29,27),(30,27),(31,28),(32,28),(33,33),(34,35),(35,36),(36,36);

/*Table structure for table `uchome_tagspace` */

DROP TABLE IF EXISTS `uchome_tagspace`;

CREATE TABLE `uchome_tagspace` (
  `tagid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(15) NOT NULL default '',
  `grade` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`tagid`,`uid`),
  KEY `grade` (`tagid`,`grade`),
  KEY `uid` (`uid`,`grade`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_tagspace` */

/*Table structure for table `uchome_task` */

DROP TABLE IF EXISTS `uchome_task`;

CREATE TABLE `uchome_task` (
  `taskid` smallint(6) unsigned NOT NULL auto_increment,
  `available` tinyint(1) NOT NULL default '0',
  `name` varchar(50) NOT NULL default '',
  `note` text NOT NULL,
  `num` mediumint(8) unsigned NOT NULL default '0',
  `maxnum` mediumint(8) unsigned NOT NULL default '0',
  `image` varchar(150) NOT NULL default '',
  `filename` varchar(50) NOT NULL default '',
  `starttime` int(10) unsigned NOT NULL default '0',
  `endtime` int(10) unsigned NOT NULL default '0',
  `nexttime` int(10) unsigned NOT NULL default '0',
  `nexttype` varchar(20) NOT NULL default '',
  `credit` smallint(6) NOT NULL default '0',
  `displayorder` smallint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`taskid`),
  KEY `displayorder` (`displayorder`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_task` */

insert  into `uchome_task`(`taskid`,`available`,`name`,`note`,`num`,`maxnum`,`image`,`filename`,`starttime`,`endtime`,`nexttime`,`nexttype`,`credit`,`displayorder`) values (1,1,'更新一下自己的头像','头像就是你在这里的个人形象。<br>设置自己的头像后，会让更多的朋友记住您。',0,0,'image/task/avatar.gif','avatar.php',0,0,0,'',20,1),(2,1,'将个人资料补充完整','把自己的个人资料填写完整吧。<br>这样您会被更多的朋友找到的，系统也会帮您找到朋友。',0,0,'image/task/profile.gif','profile.php',0,0,0,'2',20,0),(3,1,'发表自己的第一篇日志','现在，就写下自己的第一篇日志吧。<br>与大家一起分享自己的生活感悟。',1,0,'image/task/blog.gif','blog.php',0,0,0,'',5,3),(4,1,'寻找并添加五位好友','有了好友，您发的日志、图片等会被好友及时看到并传播出去；<br>您也会在首页方便及时的看到好友的最新动态。',0,0,'image/task/friend.gif','friend.php',0,0,0,'',50,4),(5,1,'验证激活自己的邮箱','填写自己真实的邮箱地址并验证通过。<br>您可以在忘记密码的时候使用该邮箱取回自己的密码；<br>还可以及时接受站内的好友通知等等。',0,0,'image/task/email.gif','email.php',0,0,0,'',10,5),(6,1,'邀请10个新朋友加入','邀请一下自己的QQ好友或者邮箱联系人，让亲朋好友一起来加入我们吧。',0,0,'image/task/friend.gif','invite.php',0,0,0,'',100,6),(7,1,'领取每日访问大礼包','每天登录访问自己的主页，就可领取大礼包。',0,0,'image/task/gift.gif','gift.php',0,0,0,'day',5,99);

/*Table structure for table `uchome_thread` */

DROP TABLE IF EXISTS `uchome_thread`;

CREATE TABLE `uchome_thread` (
  `tid` mediumint(8) unsigned NOT NULL auto_increment,
  `topicid` mediumint(8) unsigned NOT NULL default '0',
  `tagid` mediumint(8) unsigned NOT NULL default '0',
  `eventid` mediumint(8) unsigned NOT NULL default '0',
  `subject` char(80) NOT NULL default '',
  `magiccolor` tinyint(6) unsigned NOT NULL default '0',
  `magicegg` tinyint(6) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(15) NOT NULL default '',
  `dateline` int(10) unsigned NOT NULL default '0',
  `viewnum` mediumint(8) unsigned NOT NULL default '0',
  `replynum` mediumint(8) unsigned NOT NULL default '0',
  `lastpost` int(10) unsigned NOT NULL default '0',
  `lastauthor` char(15) NOT NULL default '',
  `lastauthorid` mediumint(8) unsigned NOT NULL default '0',
  `displayorder` tinyint(1) unsigned NOT NULL default '0',
  `digest` tinyint(1) NOT NULL default '0',
  `hot` mediumint(8) unsigned NOT NULL default '0',
  `click_11` smallint(6) unsigned NOT NULL default '0',
  `click_12` smallint(6) unsigned NOT NULL default '0',
  `click_13` smallint(6) unsigned NOT NULL default '0',
  `click_14` smallint(6) unsigned NOT NULL default '0',
  `click_15` smallint(6) unsigned NOT NULL default '0',
  PRIMARY KEY  (`tid`),
  KEY `tagid` (`tagid`,`displayorder`,`lastpost`),
  KEY `uid` (`uid`,`lastpost`),
  KEY `lastpost` (`lastpost`),
  KEY `topicid` (`topicid`,`dateline`),
  KEY `eventid` (`eventid`,`lastpost`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_thread` */

/*Table structure for table `uchome_tool` */

DROP TABLE IF EXISTS `uchome_tool`;

CREATE TABLE `uchome_tool` (
  `id` int(11) NOT NULL auto_increment,
  `class` int(11) NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `url` varchar(255) default NULL,
  `displayorder` int(11) NOT NULL default '100',
  `inindex` tinyint(1) NOT NULL default '0',
  `day` int(11) default '0',
  `week` int(11) default '0',
  `month` int(11) default '0',
  `total` int(11) default '0',
  `indexdisplayorder` mediumint(8) NOT NULL default '0',
  `yesterday` int(11) NOT NULL default '0',
  `byesterday` int(11) NOT NULL default '0',
  `starttime` int(11) NOT NULL default '0',
  `endtime` int(11) NOT NULL default '0',
  `remark` text NOT NULL,
  `end` tinyint(1) NOT NULL default '0',
  `namecolor` char(7) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `starttime` (`starttime`),
  KEY `endtime` (`endtime`)
) ENGINE=MyISAM AUTO_INCREMENT=2864 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_tool` */

insert  into `uchome_tool`(`id`,`class`,`name`,`url`,`displayorder`,`inindex`,`day`,`week`,`month`,`total`,`indexdisplayorder`,`yesterday`,`byesterday`,`starttime`,`endtime`,`remark`,`end`,`namecolor`) values (359,4,'域名注册查询','http://cp.35.com/chinese/chk_domain.html',4,0,0,0,2,9832,600,0,0,0,0,'',0,''),(356,4,'金山在线杀毒','http://www.114la.com/tool/aq.htm',3,1,0,0,0,108600,16,0,0,0,0,'',0,''),(622,39,'eNet天龙八部专题','http://bbs.tl.sohu.com/',5,0,0,0,0,0,0,0,0,0,0,'',0,''),(346,4,'在线多引擎病毒扫描','http://www.xiazaiba.com/virusscan.html',7,0,0,0,0,11136,38,0,0,0,0,'',0,''),(345,4,'上网速度测试','http://tool.115.com/?ct=live&ac=speed',2,1,0,0,0,1929174,1,0,0,0,0,'http://www1.114la.com/speed.php',0,''),(725,45,'魔女的条件','http://www.game.com.cn/games/6/3/mndtj.html',3,0,0,0,0,0,0,0,0,0,0,'',0,''),(20,11,'魔兽世界官方网站','http://www.wowchina.com',1,0,0,0,85,136171,0,0,12,0,0,'',0,''),(22,11,'魔兽-艾泽拉斯国家地理','http://ngacn.cc/',100,0,0,0,0,28288,0,0,0,0,0,'',0,''),(23,11,'17173-魔兽世界','http://wow.17173.com',100,0,0,0,17,39414,0,0,2,0,0,'',0,''),(26,11,'太平洋游戏—魔兽世界','http://www.pcgames.com.cn/netgames/zhuanti/wow/',100,0,0,0,9,8705,0,0,1,0,0,'',0,''),(27,11,'魔兽世界中国论坛','http://bbs.wowar.com/',3,0,0,0,5,7253,0,0,0,0,0,'',0,''),(28,11,'新浪游戏-魔兽世界','http://games.sina.com.cn/z/wow/indexpage.shtml',100,0,0,0,8,23513,0,0,1,0,0,'',0,''),(29,11,'21CN-魔兽世界专题','http://game.21cn.com/zhuanqu/wow',100,0,0,0,3,3799,0,0,1,0,0,'',0,''),(30,11,'TOM游戏-魔兽世界','http://games.tom.com/zhuanti/wow/',100,0,0,0,6,7952,0,0,2,0,0,'',0,''),(31,11,'硅谷动力-魔兽世界','http://wow.enet.com.cn/',100,0,0,0,2,7145,0,0,0,0,0,'',0,''),(32,11,'腾讯游戏-魔兽世界','http://games.qq.com/z/wow/',100,0,0,0,0,6246,0,0,0,0,0,'',0,''),(33,11,'游牧民族-魔兽世界','http://games.cnool.net/wow/',100,0,0,0,1,3417,0,0,0,0,0,'',0,''),(35,11,'魔兽世界中国','http://www.wowar.com/',100,0,0,0,59,56652,0,0,5,0,0,'',0,''),(36,11,'魔兽世界客户端官方下载','http://www.wowchina.com/download/game/game.htm',2,0,0,0,6,14199,0,0,1,0,0,'',0,''),(41,11,'魔兽精灵下载','http://www.wowshell.com/',100,0,0,0,4,4792,0,0,0,0,0,'',0,''),(42,12,'劲乐团官方网站','http://o2jam.9you.com',100,0,0,0,10,10331,0,0,0,0,0,'',0,''),(43,12,'17173-劲乐团','http://o2jam.17173.com',100,0,0,0,4,1297,0,0,0,0,0,'',0,''),(44,12,'劲乐团-新浪游戏','http://games.sina.com.cn/z/jyt',100,0,0,0,3,1321,0,0,0,0,0,'',0,''),(45,12,'劲乐团-太平洋游戏网','http://www.pcgames.com.cn/netgames/zhuanti/jingyuetuan/',100,0,0,0,2,171,0,0,0,0,0,'',0,''),(46,12,'劲乐团-天极游戏','http://gamedown.yesky.com/game/zhuanqu/o2j/index.html',100,0,0,0,1,432,0,0,0,0,0,'',0,''),(47,12,'劲乐团-eNet','http://games.enet.com.cn/zhuanti/o2jam/index.shtml',100,0,0,0,0,386,0,0,0,0,0,'',0,''),(48,12,'劲乐团-游戏先锋','http://www.1t1t.com/o2jam/',100,0,0,0,0,205,0,0,0,0,0,'',0,''),(49,12,'劲乐团教程-新浪游戏','http://games.sina.com.cn/o/jyt/kb2833.shtml',100,0,0,0,0,236,0,0,0,0,0,'',0,''),(50,12,'劲乐团游戏指南','http://gamezone.qq.com/z/o2/guide/guide.htm',100,0,0,0,0,215,0,0,0,0,0,'',0,''),(51,12,'如何购买歌曲','http://games.sina.com.cn/o/z/jyt/2005-03-25/215571.shtml',100,0,0,0,0,160,0,0,0,0,0,'',0,''),(53,12,'劲乐团客户端下载-17173','http://o2jam.17173.com/download/download.htm',100,0,0,0,4,1542,0,0,0,0,0,'',0,''),(54,12,'《劲乐团》十二乐坊版客户端','http://games.sina.com.cn/downgames/client/netgames/2005/01/2083222.shtml',100,0,0,0,1,501,0,0,0,0,0,'',0,''),(55,12,'7173-劲乐团论坛','http://bbs.17173.com/list.php?id=35&sid=36',100,0,0,0,0,104,0,0,0,0,0,'',0,''),(56,12,'百度劲乐团吧','http://post.baidu.com/f?kw=劲乐团',100,0,0,0,0,395,0,0,0,0,0,'',0,''),(58,12,'久游网销售专区','http://www.9you.com/o2xiaoshou/index.html',100,0,0,0,0,116,0,0,0,0,0,'',0,''),(59,12,'久游休闲点卡','http://ally.u517.com/Game/Search.aspx?Key=久游休闲',100,0,0,0,0,248,0,0,0,0,0,'',0,''),(60,12,'久游休闲游戏卡专卖','http://www.cobuy.com.cn/product/cpd/658.shtml',100,0,0,0,1,262,0,0,0,0,0,'',0,''),(61,12,'劲乐团图片','http://image.baidu.com/i?ct=201326592&cl=2&lm=-1&tn=sitehao123&word=劲乐团',100,0,0,0,4,1182,0,0,0,0,0,'',0,''),(62,13,'泡泡堂官方网站','http://home.bnb.sdo.com/web2006',100,0,0,0,27,59723,0,0,2,0,0,'',0,''),(63,13,'17173-泡泡堂','http://bnb.17173.com/',100,0,0,0,8,21430,0,0,1,0,0,'',0,''),(64,13,'52pk泡泡堂专区','http://games.52pk.net/bnb/',100,0,0,0,3,4969,0,0,1,0,0,'',0,''),(67,13,'泡泡堂-21CN游戏频道','http://game.21cn.com/zhuanqu/bnb/',100,0,0,0,2,4846,0,0,0,0,0,'',0,''),(68,13,'泡泡堂-TOM游戏','http://games.tom.com/zhuanti/ppt/default.html',100,0,0,0,4,13150,0,0,0,0,0,'',0,''),(69,13,'泡泡堂-QQ游戏频道','http://gamezone.qq.com/z/paopt/index.htm',100,0,0,0,4,8471,0,0,0,0,0,'',0,''),(73,13,'泡泡堂新手入门','http://bnb.17173.com/caozuo/caozuo_01.htm',100,0,0,0,5,12048,0,0,0,0,0,'',0,''),(75,13,'泡泡堂论坛-17173','http://bbs.17173.com/list.php?id=439&sid=440',100,0,0,0,0,1270,0,0,0,0,0,'',0,''),(77,13,'百度泡泡堂吧','http://post.baidu.com/f?kw=泡泡堂',100,0,0,0,5,9437,0,0,0,0,0,'',0,''),(79,13,'泡泡堂点券充值区','http://bnb.poptang.com/newbnb/bnb05/pay/index.htm',100,0,0,0,0,1200,0,0,0,0,0,'',0,''),(80,14,'街头篮球官方网站','http://www.fsjoy.com/',1,0,0,0,53,54415,0,0,2,0,0,'',0,''),(81,14,'街头篮球客户端下载','http://www.fsjoy.com/download/game_download.htm',2,0,0,0,13,21928,0,0,1,0,0,'',0,''),(83,14,'17173-街头篮球','http://fs.17173.com',3,0,0,0,1,2631,0,0,0,0,0,'',0,''),(85,14,'街头篮球-太平洋游戏网','http://www.pcgames.com.cn/netgames/zhuanti/fs/',5,0,0,0,0,2443,0,0,0,0,0,'',0,''),(87,14,'新浪游戏-街头篮球','http://games.sina.com.cn/zt/netgames/fs0829/',6,0,0,0,0,1988,0,0,0,0,0,'',0,''),(1212,14,'街头篮球-5617网络游戏网','http://jietou.5617.com/',7,0,0,0,0,274,0,0,0,0,0,'',0,''),(90,14,'街头篮球-硅谷动力专题站','http://games.enet.com.cn/zhuanti/fsjoy/index.shtml',4,0,0,0,3,1095,0,0,0,0,0,'',0,''),(91,14,'百度贴吧_街头篮球吧','http://post.baidu.com/f?kw=%BD%D6%CD%B7%C0%BA%C7%F2',100,0,0,0,3,3322,0,0,0,0,0,'',0,''),(93,15,'梦幻西游官方网站','http://xyq.163.com/',100,0,0,0,96,147652,0,0,9,0,0,'',0,''),(94,15,'梦幻西游客户端下载','http://xyq.163.com/download/khd.html',100,0,0,0,2,41019,0,0,0,0,0,'',0,''),(981,41,'汉堡连连看','http://www.game.com.cn/games/2/0/MahjongBurger.html',1,0,0,0,0,19358,0,0,0,0,0,'',0,''),(982,41,'魔兽连连看','http://www.game.com.cn/games/8/5/wowconnect.html',1,0,0,0,0,18708,0,0,0,0,0,'',0,''),(98,15,'17173梦幻西游专区','http://xyq.17173.com/',100,0,0,0,11,19244,0,0,0,0,0,'',0,''),(99,15,'新浪梦幻西游专区','http://games.sina.com.cn/z/xyq/indexpage.shtml',100,0,0,0,2,5076,0,0,0,0,0,'',0,''),(101,15,'百度梦幻西游吧','http://post.baidu.com/f?kw=%C3%CE%BB%C3%CE%F7%D3%CE',100,0,0,0,2,11197,0,0,0,0,0,'',0,''),(102,15,'由我梦幻西游','http://xyq.youwo.com/',100,0,0,0,1,5510,0,1,0,0,0,'',0,''),(103,15,'《梦幻西游》官方游戏论坛','http://xyq.netease.com/',100,0,0,0,6,8934,0,0,1,0,0,'',0,''),(104,15,'梦幻西游专区-叶子猪','http://www.yezizhu.com/xyq/',100,0,0,0,18,9694,0,0,0,0,0,'',0,''),(116,16,'跑跑卡丁车官方网站','http://popkart.tiancity.com/',100,0,0,0,61,101151,0,2,6,0,0,'',0,''),(117,16,'跑跑卡丁车官方论坛','http://bbspopkart.tiancity.com/',100,0,0,0,2,6335,0,0,0,0,0,'',0,''),(118,16,'跑跑卡丁车客户端下载','http://popkart.tiancity.com/homepage/download/download_game.html',100,0,0,0,0,71814,0,0,0,0,0,'',0,''),(119,16,'跑跑所需驱动下载','http://popkart.tiancity.com/homepage/download/drivers.html',100,0,0,0,0,6399,0,0,0,0,0,'',0,''),(120,16,'17173-跑跑卡丁车','http://popkart.17173.com/',100,0,0,0,0,7169,0,0,0,0,0,'',0,''),(121,16,'硅谷动力-跑跑卡丁车','http://games.enet.com.cn/zhuanti/popkart/index.shtml',100,0,0,0,3,6309,0,0,0,0,0,'',0,''),(122,16,'52PK-跑跑卡丁车','http://games.52pk.net/popkart/',100,0,0,0,2,7087,0,0,0,0,0,'',0,''),(123,16,'太平洋游戏-跑跑卡丁车','http://www.pcgames.com.cn/netgames/zhuanti/popkart/',100,0,0,0,3,7727,0,0,0,0,0,'',0,''),(124,16,'TOM游戏-跑跑卡丁车','http://games.tom.com/zhuanti/popkart/',100,0,0,0,1,4309,0,0,0,0,0,'',0,''),(125,16,'新浪游戏-跑跑卡丁车','http://games.sina.com.cn/o/z/pop/',100,0,0,0,3,9947,0,0,0,0,0,'',0,''),(128,16,'腾讯游戏-跑跑卡丁车','http://gamezone.qq.com/z/popkart/',100,0,0,0,4,10734,0,0,0,0,0,'',0,''),(132,17,'热血传奇官方网站','http://home.mir2.sdo.com/NewWeb/Home/',100,0,0,0,32,28743,0,0,2,0,0,'',0,''),(133,17,'热血传奇客户端下载','http://home.mir2.sdo.com/NewWeb/download/index.aspx',100,0,0,0,0,22235,0,0,0,0,0,'',0,''),(134,17,'传奇-17173专区','http://mir.17173.com/',100,0,0,0,2,5023,0,0,0,0,0,'',0,''),(135,17,'21CN.COM-热血传奇','http://game.21cn.com/zhuanqu/mir/home/',100,0,0,0,1,1258,0,0,0,0,0,'',0,''),(136,17,'传奇_新浪游戏_新浪网','http://games.sina.com.cn/z/cq/indexpage.shtml',100,0,0,0,0,2516,0,0,0,0,0,'',0,''),(137,17,'传奇_QQ游戏频道','http://gamezone.qq.com/z/mir/',100,0,0,0,0,2317,0,0,0,0,0,'',0,''),(138,17,'传奇_TOM游戏','http://games.tom.com/wlzhuanti/mir2.html',100,0,0,0,3,2777,0,0,0,0,0,'',0,''),(139,17,'52PK热血传奇下载','http://down.52pk.net/sort/12_1.htm',100,0,0,0,1,3960,0,0,0,0,0,'',0,''),(140,17,'热血传奇-万宇在线','http://mir2.92wy.com/',100,0,0,0,1,2746,0,0,0,0,0,'',0,''),(147,18,'劲舞团官方网站','http://au.9you.com/index.html',1,0,0,0,0,232568,0,0,0,0,0,'',0,''),(148,18,'新浪游戏-劲舞团','http://games.sina.com.cn/z/jwt/',3,0,0,0,34,37183,0,0,4,0,0,'',0,''),(149,18,'17173-劲舞团','http://ddr.17173.com/',100,0,0,0,18,19216,0,0,1,0,0,'',0,''),(150,18,'52PK-劲舞团专题','http://au.52pk.com/',100,0,0,0,0,5010,0,0,0,0,0,'',0,''),(157,18,'劲舞团官方论坛','http://bbs2.9you.com/viewForum.jsp?id=688',4,0,0,0,2,3112,0,0,0,0,0,'',0,''),(159,18,'百度劲舞团吧','http://post.baidu.com/f?kw=劲舞团',100,0,0,0,12,22681,0,0,2,0,0,'',0,''),(162,18,'由我网劲舞团','http://jwt.youwo.com/',100,0,0,0,1,5816,0,0,0,0,0,'',0,''),(1213,18,'劲舞团客户端下载','http://au.9you.com/',2,0,0,0,171,20673,0,0,19,0,0,'',0,''),(166,19,'QQ幻想官方主页','http://fo.qq.com/',100,0,0,0,15,16545,0,0,1,0,0,'',0,''),(167,19,'腾讯游戏-QQ幻想','http://gamezone.qq.com/tencent/qqfo/',100,0,0,0,4,3532,0,0,0,0,0,'',0,''),(169,19,'QQ幻想官方论坛','http://bbs.qq.com/cgi-bin/bbs/user/user_enter_bbs?g=f&url=/lanmu/149.shtml',100,0,0,0,1,1329,0,0,0,0,0,'',0,''),(171,19,'QQ幻想客户端下载','http://fo.qq.com/download/client.htm',100,0,0,0,7,9539,0,0,1,0,0,'',0,''),(173,19,'QQ幻想-17173专区','http://fo.17173.com/',100,0,0,0,0,1197,0,0,0,0,0,'',0,''),(174,19,'QQ幻想-新浪游戏','http://games.sina.com.cn/o/z/qqhx/',100,0,0,0,1,1572,0,0,1,0,0,'',0,''),(175,19,'1t1t-QQ幻想','http://www.1t1t.com/fo/',100,0,0,0,0,486,0,0,0,0,0,'',0,''),(178,19,'QQ幻想-TOM游戏','http://games.tom.com/zt/qqhx/',100,0,0,0,6,2972,0,0,0,0,0,'',0,''),(181,20,'热血江湖中文官方网站','http://rxjh.17game.com/index.htm',1,0,0,0,0,59417,0,0,0,0,0,'http://rxjh.17game.com/index.htmhttp://www.rxjh.com.cn/',0,''),(182,20,'17173-热血江湖专题','http://rxjh.17173.com/',100,0,0,0,1,4657,0,0,0,0,0,'',0,''),(183,20,'新浪游戏-热血江湖','http://games.sina.com.cn/z/rxjh/',100,0,0,0,1,4419,0,0,0,0,0,'',0,''),(184,20,'热血江湖官方论坛','http://bbs.rxjh.china.com/index.asp',3,0,0,0,0,5469,0,0,0,0,0,'',0,''),(189,20,'热血江湖客户端下载','http://rxjh.17game.com/',2,0,0,0,13,37484,0,1,2,0,0,'',0,''),(192,21,'征途游戏官网','http://zt.ztgame.com/',100,0,0,0,30,42013,0,0,3,0,0,'',0,''),(193,21,'征途官方论坛','http://bbs.ztgame.com.cn/',100,0,0,0,0,5696,0,0,0,0,0,'',0,''),(194,21,'征途吧','http://post.baidu.com/f?kw=%D5%F7%CD%BE',100,0,0,0,1,4696,0,0,0,0,0,'',0,''),(195,21,'征途-17173网络游戏专区','http://zt.17173.com/',100,0,0,0,0,2822,0,0,0,0,0,'',0,''),(196,21,'征途-多玩游戏','http://zt.duowan.com/',100,0,0,0,2,1734,0,0,1,0,0,'',0,''),(197,21,'征途-766游戏网','http://zt.766.com/',100,0,0,0,0,1815,0,0,0,0,0,'',0,''),(199,21,'征途专区-1t1t.com网络游戏','http://www.1t1t.com/zt/',100,0,0,0,0,1052,0,0,0,0,0,'',0,''),(200,21,'征途-新浪游戏','http://games.sina.com.cn/o/z/zt/',100,0,0,0,2,2358,0,0,0,0,0,'',0,''),(201,21,'征途-硅谷动力专题站','http://games.enet.com.cn/zhuanti/zt/index.shtml',100,0,0,0,0,648,0,0,0,0,0,'',0,''),(202,21,'征途-游戏狂阁','http://www.game247.net/zhengtu/',100,0,0,0,2,1024,0,0,1,0,0,'',0,''),(203,22,'浩方红色警戒论坛','http://bbs.cga.com.cn/cboard/cboard_52.asp',1,0,0,0,22,23732,0,1,1,0,0,'',0,''),(204,22,'红色警戒贴吧','http://post.baidu.com/f?kw=%BA%EC%C9%AB%BE%AF%BD%E4',2,0,0,0,9,17049,0,0,0,0,0,'',0,''),(205,22,'红警贴吧','http://post.baidu.com/f?kw=%BA%EC%BE%AF',3,0,0,0,6,8376,0,0,0,0,0,'',0,''),(206,22,'硅谷动力_红色警戒专题','http://games.enet.com.cn/zhuanti/red2gb/Red2gb.htm',4,0,0,0,20,16540,0,1,1,0,0,'',0,''),(207,22,'红色警戒2官方网站（英文）','http://www.ea.com/official/cc/firstdecade/us/index.jsp',5,0,0,0,35,32009,0,1,5,0,0,'',0,''),(208,22,'红色警戒2（繁体）','http://www.xiazaiba.com/html/720.html',6,0,0,0,46,34152,0,0,3,0,0,'',0,''),(209,22,'红色警戒2-游戏下载','http://www.xiazaiba.com/html/862.html',7,0,0,0,0,172590,0,0,0,0,0,'',0,''),(210,22,'红警2之中国的崛起下载','http://www.xiazaiba.com/html/739.html',8,0,0,0,68,97548,0,0,4,0,0,'',0,''),(211,22,'红色警戒2尤里的复仇下载','http://www.xiazaiba.com/html/734.html',9,0,0,0,58,81628,0,0,3,0,0,'',0,''),(213,22,'红色警戒图片','http://image.baidu.com/i?tn=baiduimage&ct=201326592&lm=-1&cl=2&word=%BA%EC%C9%AB%BE%AF%BD%E4',10,0,0,0,15,22865,0,0,1,0,0,'',0,''),(214,23,'惊天动地官方网站','http://cabal.moliyo.com/',100,0,0,0,13,12293,0,0,0,0,0,'',0,''),(215,23,'惊天动地官方论坛','http://bbs.moliyo.com/forumdisplay.php?fid=253',100,0,0,0,0,1337,0,0,0,0,0,'',0,''),(217,23,'17173惊天动地专题','http://cabal.17173.com/',100,0,0,0,1,716,0,0,0,0,0,'',0,''),(219,23,'新浪游戏-惊天动地','http://games.sina.com.cn/o/z/jtdd/',100,0,0,0,1,978,0,0,0,0,0,'',0,''),(221,23,'腾讯游戏-惊天动地','http://gamezone.qq.com/z/jtdd/',100,0,0,0,0,991,0,0,0,0,0,'',0,''),(222,23,'叶子猪－惊天动地专区','http://www.yezizhu.com/cabal/',100,0,0,0,1,718,0,0,0,0,0,'',0,''),(223,23,'17173惊天动地视频','http://media.17173.com/cabal/',100,0,0,0,2,975,0,0,0,0,0,'',0,''),(225,24,'浩方电竞平台','http://www1.cga.com.cn/',100,0,0,0,0,21179,0,0,0,0,0,'',0,''),(226,24,'浩方下载中心','http://download.cga.com.cn/',100,0,0,0,20,32125,0,0,2,0,0,'',0,''),(230,24,'浩方VIP充值','http://vip.cga.com.cn/',100,0,0,0,0,217,0,0,0,0,0,'',0,''),(231,24,'浩方社区','http://bbs.cga.com.cn/',100,0,0,0,2,732,0,0,0,0,0,'',0,''),(234,24,'浩方-魔兽争霸','http://war3.cga.com.cn/',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(235,24,'浩方-星际争霸','http://sc.cga.com.cn/',100,0,0,0,3,983,0,0,1,0,0,'',0,''),(236,24,'浩方-魔兽の世界','http://wrpg.cga.com.cn/',100,0,0,0,0,1529,0,0,0,0,0,'',0,''),(238,25,'太平洋游戏网-CS专区','http://www.pcgames.com.cn/fight/cs/',1,0,0,0,59,67365,0,0,5,0,0,'',0,''),(240,25,'TOM游戏-反恐精英','http://games.tom.com/zhuanti/cs/',3,0,0,0,44,46590,0,0,6,0,0,'',0,''),(241,25,'CS官方主页[英]','http://storefront.steampowered.com/v2/index.php?area=game&AppId=240',4,0,0,0,16,19867,0,0,1,0,0,'',0,''),(242,25,'反恐精英_腾讯游戏频道','http://gamezone.qq.com/z/cs/',5,0,0,0,45,20756,0,1,3,0,0,'',0,''),(243,25,'新浪游戏-反恐精英','http://games.sina.com.cn/z/css/indexpage.shtml',6,0,0,0,57,54072,0,0,3,0,0,'',0,''),(245,25,'中国反恐大联盟','http://www.okgogogo.com/',8,0,0,0,9,13731,0,0,3,0,0,'',0,''),(247,25,'反恐精英-21CN.COM','http://game.21cn.com/zhuanqu/cs/',10,0,0,0,7,14065,0,0,0,0,0,'',0,''),(253,25,'浩方战队系统','http://cs.cga.com.cn/',15,0,0,0,5,13536,0,0,0,0,0,'',0,''),(254,25,'[=Nice=] 战队','http://www.niceplayer.com/',16,0,0,0,2,3801,0,0,1,0,0,'',0,''),(256,25,':: CS 战队联盟 ::','http://www.csteams.net/',17,0,0,0,12,8278,0,0,2,0,0,'',0,''),(258,25,'CS Demo下载集合','http://www.pcgames.com.cn/fight/fightdemo/csdemo/',100,0,0,0,7,6314,0,0,1,0,0,'',0,''),(263,25,'春秋CS部队','http://bbs.cqzg.cn/forumdisplay.php?fid=163',23,0,0,0,5,9543,0,0,1,0,0,'',0,''),(268,26,'魔兽争霸3-冰封王座','http://www.xiazaiba.com/html/845.html',100,0,0,0,131,117180,0,2,15,0,0,'',0,''),(269,26,'浩方对战平台魔兽专区','http://war3.cga.com.cn/',100,0,0,0,13,13504,0,1,1,0,0,'',0,''),(270,26,'TOM游戏频道_魔兽争霸3','http://games.tom.com/zhuanti/war3/',100,0,0,0,4,7467,0,1,0,0,0,'',0,''),(271,26,'太平洋游戏_魔兽争霸3','http://www.pcgames.com.cn/fight/warcraft/',100,0,0,0,16,16323,0,0,3,0,0,'',0,''),(272,26,'百度魔兽争霸贴吧','http://post.baidu.com/f?kw=%C4%A7%CA%DE%D5%F9%B0%D4',100,0,0,0,1,6157,0,0,0,0,0,'',0,''),(273,26,'魔兽争霸论坛_搜狐','http://club.it.sohu.com/itmain.php?b=warcraft',100,0,0,0,0,4290,0,0,0,0,0,'',0,''),(274,26,'魔兽3论坛_新浪','http://games.sina.com.cn/forum/mszb3.shtml',100,0,0,0,1,2990,0,0,0,0,0,'',0,''),(275,26,'硅谷动力_魔兽争霸3','http://games.enet.com.cn/zhuanti/war3/',100,0,0,0,5,4486,0,0,1,0,0,'',0,''),(276,26,'魔兽争霸3中文资讯站','http://www.aomeisoft.com/war3/wc3/',100,0,0,0,11,5829,0,0,4,0,0,'',0,''),(277,26,'21CN游戏_魔兽争霸3','http://game.21cn.com/zhuanqu/war3/',100,0,0,0,2,4391,0,0,0,0,0,'',0,''),(278,26,'魔兽争霸地图下载_太平洋','http://www.pcgames.com.cn/fight/warcraft/msdtxz/',100,0,0,0,7,14256,0,0,2,0,0,'',0,''),(279,26,'魔兽补丁下载_硅谷动力','http://games.enet.com.cn/download/gmd_index.php?key%5B%5D=war3tools',100,0,0,0,3,4464,0,1,0,0,0,'',0,''),(280,26,'魔兽争霸下载','http://down.52pk.com/xiazai/80.shtml',100,0,0,0,0,57758,0,0,0,0,0,'',0,''),(281,26,'冰封王座工具下载_新浪','http://games.sina.com.cn/z/war3/2/qtxz/index.shtml',100,0,0,0,4,7528,0,0,0,0,0,'',0,''),(282,26,'U9魔兽RPG','http://www.uuu9.com/',100,0,0,0,15,17701,0,0,3,0,0,'',0,''),(283,26,'魔兽争霸图片搜索','http://image.baidu.com/i?tn=baiduimage&lm=-1&ct=201326592&cl=2&word=%C4%A7%CA%DE%D5%F9%B0%D4',100,0,0,0,1,5292,0,0,0,0,0,'',0,''),(284,26,'dota中文官方站','http://dota.uuu9.com/',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(285,26,'天地劫-魂之力量','http://tdj.uuu9.com/',100,0,0,0,4,3788,0,0,0,0,0,'',0,''),(286,26,'拳皇 97','http://fengyun2.uuu9.com/',100,0,0,0,17,23858,0,0,1,0,0,'',0,''),(287,26,'降临之夜','http://tstd.uuu9.com/',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(288,26,'澄海 3C','http://tstd.uuu9.com/',100,0,0,0,6,8097,0,0,0,0,0,'',0,''),(289,26,'Hokage Ninja','http://wmx.uuu9.com/',100,0,0,0,0,532,0,0,0,0,0,'',0,''),(290,26,'新金庸群侠传','http://cljshenjian.uuu9.com/',100,0,0,0,3,8634,0,0,0,0,0,'',0,''),(291,26,'圣城守卫战','http://caocao.uuu9.com/',100,0,0,0,3,3457,0,0,0,0,0,'',0,''),(292,26,'屠鸡英雄传','http://kchs.uuu9.com/',100,0,0,0,2,3323,0,0,0,0,0,'',0,''),(293,26,'DOTA','http://dota.uuu9.com/',100,0,0,0,0,5945,0,0,0,0,0,'',0,''),(294,26,'命运之路','http://xiangpi.uuu9.com/',100,0,0,0,2,1722,0,0,0,0,0,'',0,''),(295,26,'神雕侠侣','http://dixietomi.uuu9.com/',100,0,0,0,5,15075,0,0,1,0,0,'',0,''),(296,26,'ETN 楼の传说','http://etn.uuu9.com/',100,0,0,0,0,999,0,0,0,0,0,'',0,''),(297,26,'天刹','http://bbs.uuu9.com/forumdisplay.php?fid=362',100,0,0,0,3,2425,0,0,0,0,0,'',0,''),(298,26,'绝地风云','http://bbs.uuu9.com/forumdisplay.php?fid=310',100,0,0,0,1,3724,0,0,0,0,0,'',0,''),(299,26,'混乱东游','http://dongyou.uuu9.com/',100,0,0,0,3,2233,0,0,0,0,0,'',0,''),(300,26,'木叶外传','http://muye.uuu9.com/',100,0,0,0,7,6064,0,0,1,0,0,'',0,''),(1094,4,'网站Alexa排名查询','http://tool.115.com/?ct=site&ac=alexa',7,0,0,0,0,498,0,0,0,0,0,'',0,''),(304,27,'问道官网','http://www.asktao.com/',100,0,0,0,33,33266,0,0,3,0,0,'',0,''),(305,27,'问道客户端下载','http://www.asktao.com/download/index.htm',100,0,0,0,16,29696,0,2,0,0,0,'',0,''),(306,27,'问道游戏开发论坛','http://bbs.asktao.com/',100,0,0,0,1,1614,0,0,0,0,0,'',0,''),(308,27,'问道官方资料手册','http://wd.gyyx.cn/guide.htm',100,0,0,0,0,2814,0,0,0,0,0,'',0,''),(314,27,'问道17173专区','http://asktao.17173.com/',100,0,0,0,0,3161,0,0,0,0,0,'',0,''),(317,27,'新浪游戏问道','http://games.sina.com.cn/o/z/askdao/',100,0,0,0,1,2650,0,0,0,0,0,'',0,''),(318,27,'腾讯-问道专区','http://gamezone.qq.com/z/asktao/',100,0,0,0,1,1806,0,1,0,0,0,'',0,''),(326,1,'I P 地址速查','http://tool.114la.com/ip.html',1,1,0,0,0,372441,4,0,0,0,0,'',0,'#000000'),(327,1,'万年历查询表','http://tool.115.com/?ct=live&ac=calendar',3,1,0,0,0,276095,6,0,0,0,0,'',0,''),(339,4,'常用装机软件','http://www.xiazaiba.com/diy.html',1,0,0,0,0,32817,0,0,0,0,0,'',0,''),(342,4,'系统DIY优化工具','http://www.xiazaiba.com/downinfo/679.html',13,0,0,0,0,26924,13,0,0,0,0,'',0,''),(343,4,'QQ表情下载','http://www.xiazaiba.com/downinfo/256.html',11,0,0,0,0,40090,160,0,0,0,0,'',0,''),(360,4,'硬件行情报价','http://www.pconline.com.cn/market/',3,0,0,0,5,10054,26,0,0,0,0,'',0,''),(363,4,'I T 术语查询','http://detail.it168.com/',5,0,0,0,2,4510,0,0,0,0,0,'',0,''),(365,4,'中国Web信息博物馆','http://www.infomall.cn/',10,0,0,0,2,2010,0,0,0,0,0,'',0,''),(368,4,'扩展名辞典库','http://www.kuozhanming.com/',9,0,0,0,2,822,0,0,0,0,0,'',0,''),(369,8,'智能计算器','http://tool.114la.com/smart_calculator.html',6,0,0,0,0,20514,0,0,0,0,0,'',0,''),(370,8,'标准体重计算','http://tool.114la.com/weight.html',3,0,0,0,0,41987,0,0,0,0,0,'',0,''),(371,8,'购房计算工具','http://tool.114la.com/buyhouse.html',1,0,0,0,0,12575,0,0,0,0,0,'',0,''),(372,8,'理财计算器','http://tool.114la.com/iframe.html',2,0,0,0,0,9226,0,0,0,0,0,'',0,''),(373,8,'压力计量单位换算','http://tool.114la.com/converter8.html',7,0,0,0,0,8312,52,0,0,0,0,'',0,''),(374,8,'存款利息计算器','http://money.jrj.com.cn/money/FinanceCalc_Saving.aspx',5,0,0,0,0,8237,56,0,0,0,0,'',0,''),(617,39,'天龙八部客户端下载','http://tl.sohu.com/download/client.shtml',1,0,0,0,0,9700,0,0,0,0,0,'',0,''),(376,8,'个人所得税计算器','http://tool.114la.com/finances_tool.html',8,0,0,0,0,13852,50,0,0,0,0,'',0,''),(1297,99,'新浪赤壁专区','http://games.sina.com.cn/o/z/cb/',4,0,0,0,0,69,0,0,0,0,0,'',0,''),(378,8,'预产期自己测','http://tool.114la.com/birthday.html',4,0,0,0,0,9274,60,0,0,0,0,'',0,''),(379,2,'中国城市地图','http://www.114la.com/lvyouchuxing/index.htm#2023',1,1,0,0,0,55920,15,0,0,0,0,'',0,''),(380,2,'各地车牌号码查询','http://tool.114la.com/chepai.html',5,0,0,0,0,25540,0,0,0,0,0,'',0,''),(381,2,'世界地图','http://tool.114la.com/maps.html',4,1,0,0,0,93389,50,0,0,0,0,'',0,''),(383,2,'全国高速公路查询','http://info.jctrans.com/gongju/cx1/20051031176730.shtml',10,0,0,0,0,7182,0,0,0,0,0,'',0,''),(385,2,'公交线路查询','http://www.8684.cn/',3,0,0,0,0,12214,37,0,0,0,0,'',0,''),(386,2,'交通标志查询','http://tool.114la.com/biaozhi.html',12,0,0,0,0,10717,0,0,0,0,0,'',0,''),(387,2,'火车票网','http://huoche.com/',9,0,0,0,1,12274,0,0,0,0,0,'',0,''),(389,2,'航班实时查询','http://travel.elong.com/flights/Default.aspx?Campaign_ID=4053869',11,0,0,0,0,7793,0,0,0,0,0,'',0,''),(391,2,'全国汽车站刻查表','http://www.chelink.com/topic/changtu.htm',8,0,0,0,12,7641,0,0,1,0,0,'',0,''),(392,2,'列车时刻查询','http://tool.115.com/?ct=traffic&ac=train',2,1,0,0,0,265162,3,0,0,0,0,'',0,''),(393,2,'旅游景点查询','http://www.114la.com/lvyouchuxing/index.htm#2031',13,0,0,0,0,4842,40,0,0,0,0,'',0,''),(397,1,'电视节目预告','http://www.tvmao.com/',5,1,0,0,18,25501,48,2,2,0,0,'',0,''),(399,1,'手机号归属地及吉凶','http://tool.115.com/?ct=live&ac=mobile',4,1,0,0,0,667682,2,0,0,0,0,'',0,''),(400,1,'世界节日大全','http://www.114la.com/other/Festival.htm',35,0,0,0,0,11189,0,0,0,0,0,'',0,''),(401,1,'在线老黄历','http://laohuangli.net/',3,0,0,0,0,16889,0,0,0,0,0,'',0,''),(403,1,'邮编区号查询','http://tool.115.com/?ct=live&ac=zip',7,1,0,0,0,42096,12,0,0,0,0,'',0,''),(404,1,'食物热量查询','http://tool.115.com/?ct=health&ac=food',17,0,0,0,0,5067,0,0,0,0,0,'',0,''),(407,1,'国际电话区号','http://www.21page.net/public/code_world.asp',14,0,0,0,0,5840,0,0,0,0,0,'',0,''),(408,1,'每日星座运势','http://astro.114la.com/',15,0,0,0,0,13551,0,0,0,0,0,'',0,''),(409,1,'十二生肖查询','http://tool.115.com/?ct=star&ac=shengxiao',12,0,0,0,0,32413,0,0,0,0,0,'',0,''),(412,1,'女性安全期测算','http://tool.114la.com/womensafe.html',31,1,0,0,0,133250,46,0,0,0,0,'',0,''),(413,1,'标准智商测试','http://www.114la.com/other/sapience.htm',18,0,0,0,0,69357,0,0,0,0,0,'',0,''),(414,1,'世界各地时间','http://www.china.org.cn/worldclock/worldclock.htm',19,0,0,0,2,3143,0,0,0,0,0,'',0,''),(415,3,'行业代码查询','http://tool.114la.com/hangye.html',6,0,0,0,0,10055,0,0,0,0,0,'',0,''),(417,1,'免费在线算命','http://www.buyiju.com/',21,0,0,0,80,119519,0,0,10,0,0,'',0,''),(1296,99,'17173赤壁专区','http://chibi.17173.com/',5,0,0,0,0,65,0,0,0,0,0,'',0,''),(419,1,'邮政资费查询','http://www.post.gov.cn/folder9/folder95/index.html',34,0,0,0,3,3422,0,1,0,0,0,'',0,''),(421,1,'各地医院查询','http://tool.114la.com/hospital.html',25,0,0,0,0,15418,0,0,0,0,0,'',0,''),(422,1,'39疾病查询','http://jbk.39.net/',28,0,0,0,0,8855,0,0,0,0,0,'',0,''),(423,1,'手机真假查询','http://www.tenaa.com.cn/WSFW/FlagValidateImei.aspx',26,1,0,0,23,154686,11,0,3,0,0,'',0,''),(426,1,'生男生女预测','http://tool.114la.com/nannv.html',30,0,0,0,0,65196,0,0,0,0,0,'',0,''),(428,1,'邮票收藏查询','http://tool.114la.com/stamp.html',11,0,0,0,0,6236,0,0,0,0,0,'',0,''),(429,1,'周公解梦大全','http://www.51jiemeng.com/',9,0,0,0,257,314866,27,2,27,0,0,'',0,''),(430,4,'Wap网址导航','http://www.114la.com/catalog/1596.htm',8,0,0,0,0,4199,0,0,0,0,0,'',0,''),(431,1,'星座爱情速配','http://tool.114la.com/xingzuo.html',33,0,0,0,0,40247,0,0,0,0,0,'',0,''),(432,1,'营养成分查询','http://www.fh21.com.cn/ying/new/chengfen.htm',27,0,0,0,20,11192,0,0,1,0,0,'',0,''),(433,1,'中草药查询 ','http://tool.115.com/?ct=health&ac=herb',29,0,0,0,36,36501,0,0,1,0,0,'',0,''),(435,1,'体育彩票查询','http://www.lottery.gov.cn/',16,1,0,0,0,0,41,0,0,0,0,'',0,''),(436,1,'足球彩票查询','http://www.lottery.gov.cn/',20,0,0,0,1175,1012280,45,20,107,0,0,'',0,''),(437,1,'福彩信息查询','http://www.zhcw.com/',10,1,0,0,0,1040278,24,0,0,0,0,'',0,''),(1309,64,'科技','http://it.sohu.com/',8,0,0,0,0,447,0,0,0,1225468800,1225468800,'',0,'#FD2828'),(440,3,'股票行情查询','http://finance.google.cn/finance',7,1,0,0,0,65259,14,0,0,0,0,'',0,''),(441,3,'今日外汇牌价','http://www.boc.cn/sourcedb/whpj/',8,1,0,0,0,124531,8,0,0,0,0,'',0,''),(442,3,'农产品价格查询','http://www.gzny.gov.cn/top_jghq.asp',18,0,0,0,0,3562,57,0,0,0,0,'',0,''),(443,3,'房产楼盘查询','http://newhouse.soufun.com/',11,0,0,0,3,3117,0,0,0,0,0,'',0,''),(445,3,'发票真伪查询','http://tool.114la.com/fapiaochaxun.html',9,0,0,0,0,9278,0,0,0,0,0,'',0,''),(448,3,'进口商的数据查询','http://win.mofcom.gov.cn/',19,0,0,0,2,2941,63,0,0,0,0,'',0,''),(1318,36,'科技','http://it.sohu.com/',8,0,0,0,0,7120,0,0,0,0,0,'',0,''),(450,3,'汽车报价查询','http://www.pcauto.com.cn/qcbj/qcbj_if_gngw.html',21,0,0,0,8,21351,46,0,1,0,0,'',0,''),(454,3,'各行业会展查询','http://fair.mofcom.gov.cn/',12,0,0,0,0,1371,0,0,0,0,0,'',0,''),(1302,100,'新浪-魔域专题','http://games.sina.com.cn/o/z/myol/',5,0,0,0,0,134,0,0,0,0,0,'',0,''),(457,3,'商品防伪码查询','http://www.zfcc.net/chaxun.htm',13,0,0,0,1,1165,58,0,0,0,0,'',0,''),(458,3,'中国商标查询','http://www.86tm.com/tmdatabase/freemarksearch.asp',15,0,0,0,4,1526,0,0,0,0,0,'',0,''),(459,3,'中国专利检索','http://www.sipo.gov.cn/sipo2008/zlsqzn/sqq/',17,0,0,0,0,901,0,0,0,0,0,'',0,''),(460,3,'中国年度人口普查公报','http://www.stats.gov.cn/tjgb/',16,0,0,0,0,6410,0,0,0,0,0,'',0,''),(461,3,'法律条规查询','http://www.law-star.com/html/lawsearch.htm',14,0,0,0,13,11533,0,0,2,0,0,'',0,''),(464,5,'职业资格证书查询','http://cert.osta.org.cn/',7,0,0,0,15,10290,0,1,3,0,0,'',0,''),(466,5,'英语在线词典','http://www.iciba.com/',6,0,0,0,1,6871,47,0,0,0,0,'',0,''),(467,5,'英语语法速查','http://www.sinoya.com/search_1.asp',8,0,0,0,2,4496,0,0,0,0,0,'',0,''),(468,96,'各类字体在线生成','http://www.youmade.com/font/',80,0,0,0,4,4911,0,0,0,0,0,'',0,''),(469,4,'五笔汉字编码查询','http://tool.114la.com/wubi.html',6,0,0,0,0,21275,0,0,0,0,0,'',0,''),(470,5,'全国高校查询','http://www.edu.cn/HomePage/jiao_yu_zi_yuan/college.php',5,0,0,0,7,6875,36,0,1,0,0,'',0,''),(471,5,'学历查询','http://www.chsi.com.cn/xlcx/',4,0,0,0,11,11416,30,0,0,0,0,'',0,''),(472,5,'中国农历知识','http://www.nongli.com/item2/index.html',67,0,0,0,8,4844,0,0,1,0,0,'',0,''),(474,5,'汉典-在线汉语字典','http://www.zdic.net/',9,0,0,0,13,8265,23,0,0,0,0,'',0,''),(478,5,'历史上的今天','http://history.114la.com/',2,0,0,0,0,8751,0,0,0,0,0,'',0,''),(479,5,'机械词汇中英互译','http://www.21-sun.com/ZYHY/default.htm',76,0,0,0,2,3157,0,0,0,0,0,'',0,''),(482,5,'维基百科全书','http://zh.wikipedia.org/',3,0,0,0,0,7592,18,0,0,0,0,'',0,''),(485,96,'在线诗词搜索','http://poem.8dou.net/',60,0,0,0,12,6015,0,0,0,0,0,'',0,''),(486,96,'在线新华字典','http://xh.5156edu.com/',7,0,0,0,8,10214,51,0,1,0,0,'',0,''),(488,5,'英文缩写查询','http://www.acronym.cn',10,0,0,0,3,3728,48,0,0,0,0,'',0,''),(493,3,'各类快递查询','http://tool.114la.com/express.html',1,1,0,0,0,117416,10,0,0,0,0,'',0,''),(494,5,'免费在线翻译','http://tool.115.com/?ct=live&ac=translate',1,1,0,0,0,244110,9,0,0,0,0,'',0,''),(499,1,'北京时间校对','http://www.time.ac.cn/',6,1,0,0,30,16364,47,0,0,0,0,'',0,''),(500,2,'折扣机票预订','http://www.ctrip.com/smartlink/smartlink.asp?c=114la&url=http://flights.ctrip.com/Domestic/SearchFlights.aspx',1,1,0,0,0,17104,49,0,0,0,0,'http://www.ctrip.com/smartlink/smartlink.asp?c=114la&url= http://www.ctrip.com/&lt;br /&gt;8月21分成广告&lt;br /&gt;http://www.6199.com',0,''),(501,1,'常用电话号码','http://tool.114la.com/phonelist.html',8,0,0,0,0,46185,0,0,0,0,0,'',0,''),(502,4,'PPS 网络电视','http://www.xiazaiba.com/html/112.html',15,0,0,0,0,4732,140,0,0,0,0,'',0,''),(1089,76,'搜索引擎收录查询','http://tool.114la.com/record.html',2,0,0,0,0,1064,0,0,0,0,0,'',0,''),(1110,75,'UTF8 转换工具','http://tool.114la.com/2utf8.html',8,0,0,0,0,249,0,0,0,0,0,'',0,''),(582,36,'新浪','http://www.sina.com.cn/',3,0,0,0,44826,48296764,0,921,4349,0,0,'',0,''),(583,36,'新闻','http://news.sina.com.cn/',4,0,0,0,12094,13766765,0,284,1186,0,0,'',0,''),(584,36,'博客','http://blog.sina.com.cn/',5,0,0,0,1770,2056668,0,33,160,0,0,'http://blog.sina.com.cn/&lt;br /&gt;博客&lt;br /&gt;6-6 修改&lt;br /&gt;欧洲杯&lt;br /&gt;http://adfarm.mediaplex.com/ad/ck/10176-61181-2521-7?kw=114la&mpre=http://euro2008.sina.com.cn',0,''),(585,36,'搜狐','http://www.sohu.com/',6,0,0,0,30799,31922027,0,618,2973,0,0,'',0,''),(586,36,'新闻','http://news.sohu.com/',7,0,0,0,6430,6333753,0,136,675,0,0,'',0,''),(588,36,'网易','http://www.163.com/',9,0,0,0,22067,24752689,0,439,2059,0,0,'',0,''),(589,36,'新闻','http://news.163.com/',10,0,0,0,3154,4410520,0,79,346,0,0,'',0,''),(591,36,'百度搜索','http://www.baidu.com/index.php?tn=uc_4_pg',1,0,0,0,46064,37425198,0,734,4373,0,0,'',0,''),(592,36,'Mp3','http://mp3.ylmf.com/',2,0,0,0,5108,4749840,0,84,495,0,0,'',0,''),(597,8,'营业税计算','http://tool.114la.com/business_tax.html',10,0,0,0,0,5728,0,0,0,0,0,'',0,''),(2862,4,'IP地址反向查询 ','http://tool.115.com/?ct=site&ac=ipneighbor',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(624,39,'天龙八部吧','http://post.baidu.com/f?ct=318898176&tn=baiduKeywordSearch&sc=4504&pn=0&rn=50&lm=4&rs3=0&word=%CC%EC%C1%FA%B0%CB%B2%BF',7,0,0,0,13,8622,0,0,1,0,0,'',0,''),(606,2,'宾馆酒店预订','http://www.ctrip.com/smartlink/smartlink.asp?c=114la&url=http://hotels.ctrip.com/Domestic/SearchHotel.aspx',6,1,0,0,0,33226,13,0,0,0,0,'8月21分成广告',0,''),(619,39,'天龙八部补丁下载','http://tl.sohu.com/download/client.shtml',3,0,0,0,8,60537,0,0,0,0,0,'',0,''),(621,39,'天龙八部官方论坛','http://bbs.tl.sohu.com/',4,0,0,0,11,17266,0,0,1,0,0,'',0,''),(620,39,'天龙八部官方网站','http://tl.sohu.com/?rcc_id=5bd6447fe484590312d8c140a246475b%20',4,0,0,0,0,49133,0,0,0,0,0,'',0,''),(623,39,'17173天龙八部专题','http://tl.17173.com/',6,0,0,0,10,8905,0,0,0,0,0,'',0,''),(625,39,'腾讯天龙八部专题','http://games.qq.com/z/tl/',8,0,0,0,0,5297,0,0,0,0,0,'',0,''),(626,39,'新手完全成才手册','http://tl.17173.com/zhuanti/xinshou.html',9,0,0,0,4,7718,0,0,0,0,0,'',0,''),(627,42,'诛仙官方客户端下载','http://zhuxian.wanmei.com/',2,0,0,0,0,25447,0,0,0,0,0,'',0,''),(629,42,'诛仙官方网站','http://zhuxian.wanmei.com/main.htm',1,0,0,0,0,49153,0,0,0,0,0,'',0,''),(633,42,'17173-诛仙','http://newgame.17173.com/content/2007-03-07/20070307111853953.shtml',9,0,0,0,1,5085,0,0,0,0,0,'',0,''),(634,42,'太平洋-诛仙','http://www.pcgames.com.cn/netgames/zhuanti/zhuxian/',10,0,0,0,1,2901,0,0,0,0,0,'',0,''),(635,42,'新浪-诛仙','http://games.sina.com.cn/o/z/zx/',11,0,0,0,4,3831,0,0,0,0,0,'',0,''),(637,42,'TOM游戏-诛仙','http://games.tom.com/zt/zhuxian/',13,0,0,0,6,3960,0,0,0,0,0,'',0,''),(638,41,'宠物连连看','http://www.game.com.cn/games/8/1/pet%20connect.html',1,0,0,0,0,122840,0,0,0,0,0,'',0,''),(639,41,'宠物连连看2.5版','http://www.game.com.cn/games/4/0/chongwullk.html',2,0,0,0,1,98345,0,0,0,0,0,'',0,''),(640,41,'连连看-中国龙','http://www.game.com.cn/games/7/2/jdzgl.html',3,0,0,0,0,19091,0,0,0,0,0,'',0,''),(641,41,'红孩儿连连看','http://www.game.com.cn/games/8/0/hherllk.html',4,0,0,0,0,14809,0,0,0,0,0,'',0,''),(642,41,'小令连连看','http://www.game.com.cn/games/7/1/xlllk.html',5,0,0,0,0,6587,0,0,0,0,0,'',0,''),(643,41,'飞秀连连看','http://www.game.com.cn/games/2/5/feixiullk.html',6,0,0,0,0,10469,0,0,0,0,0,'',0,''),(644,41,'魔力连连看','http://www.game.com.cn/games/6/2/molillk.html',7,0,0,0,0,13248,0,0,0,0,0,'',0,''),(645,41,'星际连连看','http://www.game.com.cn/games/1/2/starllk.html',8,0,0,0,0,11332,0,0,0,0,0,'',0,''),(646,41,'厨房连连看','http://www.game.com.cn/games/5/3/cfllk.html',9,0,0,0,0,18594,0,0,0,0,0,'',0,''),(647,41,'寒筝连连看','http://www.game.com.cn/games/1/7/hzhllkan.html',10,0,0,0,0,3608,0,0,0,0,0,'',0,''),(648,41,'宠物连连看2.6版','http://www.game.com.cn/games/3/1/cwllkan.html',11,0,0,0,0,103463,0,0,0,0,0,'',0,''),(649,41,'果蔬连连看','http://www.game.com.cn/games/2/6/guoshulianliankan.html',12,0,0,0,0,131052,0,0,0,0,0,'',0,''),(650,41,'twins连连看','http://www.game.com.cn/games/3/5/twinslianliankan.html',13,0,0,0,0,11347,0,0,0,0,0,'',0,''),(651,41,'小破孩连连看','http://www.game.com.cn/games/5/5/xphllk.html',14,0,0,0,0,17900,0,0,0,0,0,'',0,''),(652,41,'糯米猪连连看','http://www.game.com.cn/games/1/2/mnmzllk.html',15,0,0,0,0,8061,0,0,0,0,0,'',0,''),(653,41,'全新连连看','http://www.game.com.cn/games/6/2/qxinllk.html',16,0,0,0,0,28151,0,0,0,0,0,'',0,''),(654,41,'亚都连连看','http://www.game.com.cn/games/3/2/mydllk.html',17,0,0,0,0,6486,0,0,0,0,0,'',0,''),(655,41,'加法连连看','http://www.game.com.cn/games/5/2/mjfllk.html',18,0,0,0,0,13169,0,0,0,0,0,'',0,''),(656,41,'标志连连看','http://www.game.com.cn/games/0/3/mbzllk.html',19,0,0,0,0,9571,0,0,0,0,0,'',0,''),(1372,53,'新金币玛丽','http://www.4399.com/flash/9149.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(658,41,'金庸群侠传连连看','http://www.game.com.cn/games/4/3/mjyqxzllk.html',21,0,0,0,0,14485,0,0,0,0,0,'',0,''),(1371,53,'玛丽兄弟3','http://www.4399.com/flash/9499.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(660,41,'竹林麻将连连看','http://www.game.com.cn/games/7/3/mzlmjk.html',23,0,0,0,0,18499,0,0,0,0,0,'',0,''),(661,41,'宠物连连看3.0','http://www.game.com.cn/games/8/5/majiangllk.html',24,0,0,0,0,39049,0,0,0,0,0,'',0,''),(662,41,'精装麻将连连看','http://www.game.com.cn/games/8/5/majiangllk.html',25,0,0,0,0,37312,0,0,0,0,0,'',0,''),(663,41,'天使之恋连连看','http://www.game.com.cn/games/6/8/tszl.html',26,0,0,0,0,16912,0,0,0,0,0,'',0,''),(664,41,'新势力QQ连连看','http://www.game.com.cn/games/1/4/mxslk.html',28,0,0,0,0,9213,0,0,0,0,0,'',0,''),(665,41,'游游连连看','http://www.game.com.cn/games/6/6/yyllk.html',29,0,0,0,0,15586,0,0,0,0,0,'',0,''),(666,41,'新版消消看','http://www.game.com.cn/games/7/3/xinbanxxk.html',30,0,0,0,0,17702,0,0,0,0,0,'',0,''),(667,41,'拼图连连看','http://www.xiaoyouxi.com/down/soft/680/23780.htm',31,0,0,0,25,16764,0,0,0,0,0,'',0,''),(668,41,'可爱宠物连连看','http://www.game.com.cn/games/4/4/mkacwk.html',32,0,0,0,0,30057,0,0,0,0,0,'',0,''),(669,41,'超级连连看','http://www.game.com.cn/games/1/5/cjllkan.html',33,0,0,0,0,33736,0,0,0,0,0,'',0,''),(670,41,'QQ连连看','http://www.game.com.cn/games/7/2/qqllk231.html',34,0,0,0,0,63169,0,0,0,0,0,'',0,''),(671,41,'动物连连看','http://www.game.com.cn/games/9/2/dwllk.html',35,0,0,0,0,44939,0,0,0,0,0,'',0,''),(672,41,'集字消消看','http://www.game.com.cn/games/1/3/jizixiaoxiaokan.html',36,0,0,0,0,17881,0,0,0,0,0,'',0,''),(673,41,'冰糖消消看','http://www.game.com.cn/games/4/5/bingtangxiaoxiaokan.html',37,0,0,0,0,15735,0,0,0,0,0,'',0,''),(674,40,'武林外传官方客户端','http://www.wulin2.com.cn/download/client.htm',2,0,0,0,1,5083,0,0,0,0,0,'',0,''),(675,40,'武林外传官方网站','http://www.wulin2.com.cn/',1,0,0,0,0,0,0,0,0,0,0,'',0,''),(676,40,'武林外传客户端迅雷下载','http://game.xunlei.com/xs00162.htm',3,0,0,0,3,4252,0,0,0,0,0,'',0,''),(677,40,'武林外传补丁下载','http://www.wulin2.com.cn/',4,0,0,0,22,49866,0,0,3,0,0,'',0,''),(678,40,'17173-武林外传','http://wulin2.17173.com/',5,0,0,0,0,2857,0,0,0,0,0,'',0,''),(679,40,'腾讯游戏-武林外传','http://gamezone.qq.com/z/wulin2/',6,0,0,0,2,4548,0,0,0,0,0,'',0,''),(680,40,'新浪游戏-武林外传','http://games.sina.com.cn/o/z/wulin2/',7,0,0,0,3,4762,0,0,0,0,0,'',0,''),(681,40,'武林外传吧','http://post.baidu.com/f?ct=318898176&tn=baiduKeywordSearch&sc=292790&pn=0&rn=50&lm=4&rs3=0&word=%CE%E4%C1%D6%CD%E2%B4%AB',8,0,0,0,1,2969,0,0,0,0,0,'',0,''),(682,40,'武林外传-766游戏网','http://wulin2.766.com/',9,0,0,0,0,2185,0,0,0,0,0,'',0,''),(683,43,'冒险岛官方网站','http://mxd.sdo.com/',1,0,0,0,51,72873,0,1,1,0,0,'',0,''),(684,43,'冒险岛客户端下载','http://mxd.sdo.com/web/home/downloads.asp?a=1',2,0,0,0,8,4082,0,0,0,0,0,'',0,''),(687,43,'17173-冒险岛专区','http://mxd.17173.com/',5,0,0,0,0,4167,0,0,0,0,0,'',0,''),(688,43,'冒险岛主题站','http://www.maoxiandao.com/',6,0,0,0,3,7253,0,0,1,0,0,'',0,''),(689,43,'由我网-冒险岛','http://mxd.youwo.com/',7,0,0,0,1,4862,0,0,0,0,0,'',0,''),(690,43,'冒险岛官方论坛','http://bbs.mxd.sdo.com/',3,0,0,0,1,848,0,0,0,0,0,'',0,''),(691,43,'766冒险岛','http://mxd.766.com/',9,0,0,0,13,16113,0,0,1,0,0,'',0,''),(693,43,'eNET冒险岛','http://games.enet.com.cn/zhuanti/mxd/',11,0,0,0,3,5536,0,0,1,0,0,'',0,''),(694,43,'冒险岛_腾讯游戏','http://gamezone.qq.com/z/mxd/',12,0,0,0,4,9006,0,0,0,0,0,'',0,''),(695,43,'冒险岛_太平洋游戏','http://www.pcgames.com.cn/netgames/zhuanti/mxd/',13,0,0,0,6,4601,0,0,1,0,0,'',0,''),(707,44,'7k7k小游戏','http://www.7k7k.com/',1,0,0,0,842,973748,0,1,52,0,0,'4399 在线游戏&lt;br /&gt;http://www.4399.net/&lt;br /&gt;7月31日撤下.换广告.',0,''),(708,44,'4399小游戏','http://www.4399.com/',2,0,0,0,0,85345,0,0,0,0,0,'',0,''),(710,44,'在线小游戏','http://www.game.com.cn/',4,0,0,0,0,454582,0,0,0,0,0,'',0,'#FF0000'),(712,44,'小游戏007','http://www.yx007.com/',6,0,0,0,301,293452,0,0,21,0,0,'',0,''),(713,44,'456小游戏','http://www.456.net/',7,0,0,0,76,101756,0,1,3,0,0,'',0,''),(714,44,'QQ游戏频道','http://games.qq.com/mini/mini.shtml',8,0,0,0,159,282641,0,1,8,0,0,'',0,''),(715,44,'21CN 小游戏','http://game.21cn.com/mini/',9,0,0,0,75,151066,0,3,4,0,0,'',0,''),(716,44,'牛牛游戏','http://www.niu-niu.com/',10,0,0,0,11,13807,0,0,2,0,0,'',0,''),(718,44,'Gameyes 小游戏','http://www.gameyes.com/',12,0,0,0,7,14246,0,1,4,0,0,'',0,''),(723,45,'超级女生','http://www.game.com.cn/games/2/3/chaojinvsheng.html',1,0,0,0,0,34357,0,0,0,0,0,'',0,''),(724,45,'明天我要嫁给你','http://www.game.com.cn/games/3/3/mingtianwoyaojiageini.html',2,0,0,0,0,39318,0,0,0,0,0,'',0,''),(726,45,'多变女郎','http://www.game.com.cn/games/8/3/dbnl.html',4,0,0,0,0,15529,0,0,0,0,0,'',0,''),(727,45,'美女试衣9','http://www.game.com.cn/games/9/3/meinvshiyi9.html',5,0,0,0,0,21197,0,0,0,0,0,'',0,''),(728,45,'做女人挺好','http://www.game.com.cn/games/2/4/znrth.html',6,0,0,0,0,25370,0,0,0,0,0,'',0,''),(729,45,'精灵美眉','http://www.game.com.cn/games/5/4/jinglmm0206.html',6,0,0,0,0,13485,0,0,0,0,0,'',0,''),(730,45,'美眉去约会','http://www.game.com.cn/games/7/4/mmqyh.html',7,0,0,0,0,28262,0,0,0,0,0,'',0,''),(731,45,'女皇万岁','http://www.game.com.cn/games/8/4/nwwans.html',8,0,0,0,0,13868,0,0,0,0,0,'',0,''),(733,45,'变性美媚','http://www.game.com.cn/games/3/7/bianxingmeimei.html',9,0,0,0,0,18808,0,0,0,0,0,'',0,''),(734,45,'勾魂六件套','http://www.game.com.cn/games/2/2/ghljt.html',10,0,0,0,0,29372,0,0,0,0,0,'',0,''),(735,45,'发廊小姐','http://www.game.com.cn/games/4/2/falangxiaojie.html',11,0,0,0,0,29770,0,0,0,0,0,'',0,''),(738,45,'动感少女之星','http://www.game.com.cn/games/2/1/gssjwt.html',14,0,0,0,0,15703,0,0,0,0,0,'',0,''),(739,45,'美少女战士','http://www.game.com.cn/games/8/2/msnzs.html',15,0,0,0,0,14447,0,0,0,0,0,'',0,''),(740,45,'美丽的公主','http://www.game.com.cn/games/2/7/gzhuhuanyi.html',16,0,0,0,0,11680,0,0,0,0,0,'',0,''),(741,45,'美眉制造机','http://www.game.com.cn/games/1/3/mmzzj.html',17,0,0,0,0,17321,0,0,0,0,0,'',0,''),(742,45,'美女更衣19','http://www.game.com.cn/games/0/4/mngy19.html',18,0,0,0,0,31372,0,0,0,0,0,'',0,''),(743,45,'美女更衣20','http://www.game.com.cn/games/3/4/meinvgengyi20.html',19,0,0,0,0,24495,0,0,0,0,0,'',0,''),(744,45,'公主换衣','http://www.game.com.cn/games/2/7/gzhuhuanyi.html',20,0,0,0,0,35357,0,0,0,0,0,'',0,''),(746,45,'时装秀3','http://www.xiazaiba.com/html/694.html ',21,0,0,0,0,15249,0,0,0,0,0,'',0,''),(747,45,'魔女的条件','http://www.game.com.cn/games/6/3/mndtj.html',22,0,0,0,0,33495,0,0,0,0,0,'',0,''),(748,45,'美女换装14','http://www.game.com.cn/games/9/4/meinvhuanzhuang14.html',23,0,0,0,0,19718,0,0,0,0,0,'',0,''),(749,45,'性感小野猫','http://www.game.com.cn/games/0/5/xgxym.html',24,0,0,0,0,22467,0,0,0,0,0,'',0,''),(750,45,'MM化妆师','http://www.game.com.cn/games/0/1/mmhuazhuangshi.html',25,0,0,0,0,24831,0,0,0,0,0,'',0,''),(751,45,'芭比娃娃化妆','http://www.game.com.cn/games/5/5/babiwawahuazhuang.html',26,0,0,0,0,28668,0,0,0,0,0,'',0,''),(752,45,'发廊美媚3','http://www.xiaoyouxi.com/down/soft/862/24067.htm',26,0,0,0,16,20345,0,1,0,0,0,'',0,''),(753,45,'美女衣橱','http://www.game.com.cn/youxi/2/8/girlfashion.html',27,0,0,0,16,20472,0,0,1,0,0,'',0,''),(754,45,'芙蓉换装','http://www.game.com.cn/youxi/2/7/furonghuanzhuang.html',28,0,0,0,9,19163,0,0,0,0,0,'',0,''),(755,45,'美眉学化妆','http://www.game.com.cn/games/4/4/mmxhuaz.html',29,0,0,0,0,20883,0,0,0,0,0,'',0,''),(756,45,'灰姑娘','http://www.game.com.cn/games/0/5/huiguniang.html',30,0,0,0,0,27261,0,0,0,0,0,'',0,''),(757,45,'营救小猫咪','http://www.game.com.cn/games/2/9/jjxmm.html',31,0,0,0,0,15755,0,0,0,0,0,'',0,''),(758,45,'睡衣美女换装','http://www.game.com.cn/youxi/7/0/shuiyimm.html',32,0,0,0,34,38758,0,0,5,0,0,'',0,''),(759,45,'靓女绚彩美甲秀','http://www.game.com.cn/games/6/4/girlnail.html',33,0,0,0,0,23048,0,0,0,0,0,'',0,''),(760,45,'精灵换装','http://www.game.com.cn/youxi/2/2/spiritcloth.html',34,0,0,0,7,9825,0,0,0,0,0,'',0,''),(761,45,'红发少女','http://www.game.com.cn/youxi/1/9/refhair.html',35,0,0,0,14,11923,0,0,1,0,0,'',0,''),(762,45,'设计漂亮娃娃','http://www.game.com.cn/youxi/8/8/prettydoll.html',36,0,0,0,23,29296,0,1,1,0,0,'',0,''),(763,45,'邻家女孩','http://www.game.com.cn/youxi/8/8/beauty.html',37,0,0,0,16,19947,0,0,0,0,0,'',0,''),(764,45,'莉莉更衣','http://www.game.com.cn/youxi/6/5/lilicloth.html',38,0,0,0,21,34356,0,0,1,0,0,'',0,''),(765,45,'冬日恋歌','http://www.game.com.cn/games/8/4/dongriliange.html',39,0,0,0,0,15717,0,0,0,0,0,'',0,''),(766,45,'搭配秋季服饰','http://www.game.com.cn/games/6/4/qiujifushi.html',40,0,0,0,0,20207,0,0,0,0,0,'',0,''),(767,45,'美眉的化妆间','http://www.game.com.cn/games/7/4/mmhuazhuang.html',41,0,0,0,0,39638,0,0,0,0,0,'',0,''),(768,46,'美女餐厅III','http://www.game.com.cn/games/9/9/MMdiningroomIII.html',1,0,0,0,0,49381,0,0,0,0,0,'',0,''),(769,46,'料理大师panny','http://www.game.com.cn/games/2/0/masterpanny.html',2,0,0,0,0,20443,0,0,0,0,0,'',0,''),(770,46,'小MM蛋糕师傅','http://www.game.com.cn/games/4/0/MMcake.html',3,0,0,0,0,24515,0,0,0,0,0,'',0,''),(771,46,'美眉包饺子','http://www.game.com.cn/games/8/0/MMdumpling.html',4,0,0,0,0,31073,0,0,0,0,0,'',0,''),(772,46,'MM学做早餐','http://www.xiaoyouxi.com/down/soft/1005/23711.htm',5,0,0,0,9,18467,0,0,0,0,0,'',0,''),(773,46,'大头妹做蛋糕','http://www.xiaoyouxi.com/down/soft/1005/23712.htm',6,0,0,0,12,30246,0,0,0,0,0,'',0,''),(774,46,'大头妹汉堡师父','http://www.xiaoyouxi.com/down/soft/1005/23715.htm',7,0,0,0,9,10973,0,0,2,0,0,'',0,''),(775,46,'贝蒂的啤酒吧 ','http://www.xiazaiba.com/html/670.html ',8,0,0,0,18,29463,0,0,1,0,0,'',0,''),(776,46,'能当厨师吗','http://www.xiaoyouxi.com/down/soft/1005/23719.htm',9,0,0,0,8,20316,0,0,1,0,0,'',0,''),(777,46,'煎鸡蛋','http://www.game.com.cn/games/7/4/jianjidan.html',10,0,0,0,0,15562,0,0,0,0,0,'',0,''),(778,46,'中国娃娃做料理','http://www.xiaoyouxi.com/down/soft/1005/23720.htm',11,0,0,0,8,19148,0,0,1,0,0,'',0,''),(779,46,'墨西哥速食店','http://www.xiaoyouxi.com/down/soft/1005/23721.htm',12,0,0,0,6,13157,0,0,0,0,0,'',0,''),(780,46,'夏日早餐','http://www.xiaoyouxi.com/down/soft/1005/23732.htm',13,0,0,0,7,18319,0,0,0,0,0,'',0,''),(781,46,'天使面包坊','http://www.xiaoyouxi.com/down/soft/1005/21752.htm',14,0,0,0,10,17956,0,0,0,0,0,'',0,''),(782,46,'海边烧烤','http://www.game.com.cn/games/0/2/haibianshaokao.html',15,0,0,0,0,16491,0,0,0,0,0,'',0,''),(783,46,'麦当劳快餐厅','http://www.game.com.cn/games/3/0/kuaicanting.html',16,0,0,0,0,26689,0,0,0,0,0,'',0,''),(784,46,'零食加工厂','http://www.game.com.cn/games/6/4/lsjgc.html',17,0,0,0,0,19497,0,0,0,0,0,'',0,''),(785,46,'厨师团队','http://www.xiazaiba.com/html/693.html ',19,0,0,0,8,18995,0,0,0,0,0,'',0,''),(786,46,'梦幻蛋糕屋','http://www.game.com.cn/games/9/0/dangaowu.html',20,0,0,0,0,30482,0,0,0,0,0,'',0,''),(787,46,'活力早餐','http://www.game.com.cn/games/2/1/huolizaocan.html',21,0,0,0,0,12289,0,0,0,0,0,'',0,''),(788,46,'MM汉堡店','http://www.game.com.cn/youxi/7/3/mmhanbaodian.html',22,0,0,0,8,17195,0,0,1,0,0,'',0,''),(789,46,'你是我客人','http://www.game.com.cn/youxi/4/3/zuofan.html',23,0,0,0,1,21186,0,0,0,0,0,'',0,''),(790,46,'烤肉串车','http://www.game.com.cn/youxi/8/8/kebabvan.html',24,0,0,0,11,27622,0,0,2,0,0,'',0,''),(791,46,'煎鸡蛋','http://www.game.com.cn/youxi/7/4/jianjidan.html',25,0,0,0,19,33200,0,0,1,0,0,'',0,''),(792,46,'厨师烧烤店','http://www.game.com.cn/youxi/5/0/shaokaodian.html',26,0,0,0,10,19658,0,0,2,0,0,'',0,''),(1404,45,'华丽新年礼服','http://www.4399.com/flash/10166.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(794,46,'鸡排大王','http://www.game.com.cn/youxi/1/7/jipai.html',28,0,0,0,6,26968,0,0,1,0,0,'',0,''),(795,46,'快餐店服务生','http://www.game.com.cn/youxi/5/1/kcdfws.html',29,0,0,0,7,22475,0,0,0,0,0,'',0,''),(796,47,'掌机地带','http://psp.chinagba.com/',1,0,0,0,10,22709,0,0,1,0,0,'',0,''),(798,47,'太平洋游戏PSP','http://www.pcgames.com.cn/tvgames/topic/psp/',3,0,0,0,6,10148,0,0,1,0,0,'',0,''),(799,47,'TOM PSP','http://games.tom.com/zt/psp/',4,0,0,0,1,2446,0,0,0,0,0,'',0,''),(800,47,'CnGba-PSP讨论论坛','http://www.cngba.com/forum-122-1.html',5,0,0,0,0,0,0,0,0,0,0,'',0,''),(802,47,'21CN PSP','http://game.21cn.com/console/psp/',7,0,0,0,2,2496,0,0,0,0,0,'',0,''),(803,47,'SINA - PSP专区','http://games.sina.com.cn/t/PSP.shtml',8,0,0,0,4,2119,0,0,0,0,0,'',0,''),(804,47,'PSP日本官方网站','http://www.playstation.jp/',9,0,0,0,3,3593,0,0,1,0,0,'',0,''),(805,47,'雷神下载','http://www.pspper.com/',10,0,0,0,2,6631,0,0,0,0,0,'',0,''),(807,47,'PSP中国','http://bbs.pspchina.net/',12,0,0,0,1,6118,0,0,0,0,0,'',0,''),(808,47,'PSP资源BT下载','http://bt.cngba.com/',13,0,0,0,22,39026,0,0,0,0,0,'',0,''),(810,47,'psp常用工具','http://down.cngba.com/psp/pspsoft/tools/',15,0,0,0,0,4034,0,0,0,0,0,'',0,''),(811,47,'PSP常见问题','http://www.hao123.com/zhidao/zhidao_psp.htm',16,0,0,0,1,1341,0,0,0,0,0,'',0,''),(812,47,'PSP游戏之家','http://psp.gamehome.tv/',17,0,0,0,3,8815,0,0,0,0,0,'',0,''),(814,47,'WII美国官方网站','http://us.wii.com/',18,0,0,0,2,1248,0,0,0,0,0,'',0,''),(815,47,'NDS官方网站','http://touch-ds.jp/',20,0,0,0,0,1078,0,0,0,0,0,'',0,''),(816,47,'PS3官方网站','http://www.playbeyond.jp/main.html',21,0,0,0,1,1669,0,0,1,0,0,'',0,''),(817,47,'XBOX官方玩站','http://www.xbox.com/en-US/',22,0,0,0,1,939,0,0,1,0,0,'',0,''),(818,47,'CnGba - Xbox360全方位讨论','http://www.cngba.com/forum-122-1.html',23,0,0,0,3,2137,0,0,2,0,0,'',0,''),(819,47,'xbox-sky','http://www.xbox-sky.com/',24,0,0,0,6,8459,0,0,0,0,0,'',0,''),(820,47,'太平洋电视游戏','http://www.pcgames.com.cn/tvgames/',25,0,0,0,20,24983,0,0,0,0,0,'',0,''),(821,47,'任天堂世界','http://www.nwbbs.com/',26,0,0,0,27,32956,0,0,3,0,0,'',0,''),(822,47,'QQ电子游戏','http://gamezone.qq.com/tvgame/tvgame.shtml',27,0,0,0,4,5083,0,0,1,0,0,'',0,''),(823,47,'pchome游戏站','http://game.pchome.net/tvg/',28,0,0,0,21,31195,0,0,2,0,0,'',0,''),(824,47,'SINA电视游戏','http://games.sina.com.cn/t',29,0,0,0,16,18977,0,0,2,0,0,'',0,''),(825,47,'enet电视游戏','http://games.enet.com.cn/console.shtml',30,0,0,0,16,26409,0,0,1,0,0,'',0,''),(826,47,'WII讨论区','http://www.cngba.com/forum-191-1.html',31,0,0,0,1,382,0,0,0,0,0,'',0,''),(827,47,'21CN电视游戏','http://game.21cn.com/console/',32,0,0,0,1,2326,0,0,0,0,0,'',0,''),(829,47,'levelup','http://www.levelup.cn/',35,0,0,0,0,1001,0,0,0,0,0,'',0,''),(830,47,'IT世界电视游戏','http://it.com.cn/games/tv/',36,0,0,0,0,2115,0,0,0,0,0,'',0,''),(831,47,'TOM电视游戏','http://games.tom.com/tvgame/',37,0,0,0,9,13433,0,0,1,0,0,'',0,''),(832,48,'极品飞车官方站(英)','http://www.eagames.com/redesign/home.jsp',1,0,0,0,40,64273,0,0,4,0,0,'',0,''),(833,48,'极品飞车吧','http://post.baidu.com/f?ct=&tn=&rn=&pn=&lm=&sc=&kw=%BC%AB%C6%B7%B7%C9%B3%B5&rs2=0&myselectvalue=1&word=%BC%AB%C6%B7%B7%C9%B3%B5&tb=on',2,0,0,0,46,84618,0,0,2,0,0,'',0,''),(834,48,'新浪极品飞车','http://games.sina.com.cn/z/nfs/indexpage.shtml',3,0,0,0,22,50044,0,1,6,0,0,'',0,''),(835,48,'enet极品飞车','http://games.enet.com.cn/zhuanti/nfs7ug2/',4,0,0,0,7,18543,0,0,1,0,0,'',0,''),(836,48,'52PK极品飞车下载中心','http://down.52pk.net/sort/194_1.htm',5,0,0,0,60,104410,0,0,2,0,0,'',0,''),(837,48,'21CN极品飞车','http://game.21cn.com/zhuanti/needforspeed8/',6,0,0,0,22,34081,0,0,2,0,0,'',0,''),(838,48,'QQ极品飞车','http://gamezone.qq.com/z/nfs7/',7,0,0,0,41,48845,0,0,3,0,0,'',0,''),(839,49,'暗黑破坏神下载','http://www.gougou.com/search?search=%E6%9A%97%E9%BB%91%E7%A0%B4%E5%9D%8F%E7%A5%9E&restype=-1&id=100002',1,0,0,0,63,62764,0,2,8,0,0,'',0,''),(840,49,'毁灭之王硬盘版','http://www.gougou.com/search?search=%E6%9A%97%E9%BB%91%E7%A0%B4%E5%9D%8F%E7%A5%9E%E6%AF%81%E7%81%AD%E4%B9%8B%E7%8E%8B&restype=-1&id=100002',2,0,0,0,10,16806,0,0,0,0,0,'',0,''),(841,49,'暗黑破坏神视频','http://video.baidu.com/v?word=%B0%B5%BA%DA%C6%C6%BB%B5%C9%F1&ct=301989888&rn=20&pn=0&db=0&s=0',4,0,0,0,15,9182,0,0,1,0,0,'',0,''),(842,49,'暗黑破坏神吧','http://post.baidu.com/f?ct=318898176&tn=baiduKeywordSearch&sc=3311&pn=0&rn=50&lm=4&rs3=0&word=%B0%B5%BA%DA%C6%C6%BB%B5%C9%F1',6,0,0,0,5,5101,0,0,1,0,0,'',0,''),(843,49,'u9暗黑破坏神2专题站','http://d2.uuu9.com/',7,0,0,0,3,4050,0,1,1,0,0,'',0,''),(844,49,'暗黑2_新浪游戏','http://games.sina.com.cn/z/d2x/indexpage.shtml',8,0,0,0,7,10738,0,0,0,0,0,'',0,''),(845,49,'impk战网论坛','http://www.impk.net/',9,0,0,0,0,1896,0,0,0,0,0,'',0,''),(846,49,'暴血官方战网(英)','http://www.battle.net/',10,0,0,0,1,2667,0,0,0,0,0,'',0,''),(847,49,'中国暗黑世界','http://chinabn.xiyou.net/',11,0,0,0,2,7283,0,1,0,0,0,'',0,''),(848,50,'《罪恶都市》硬盘版','http://www.xiazaiba.com/html/864.html',1,0,0,0,156,114199,0,1,9,0,0,'',0,''),(849,50,'《圣安地利斯》硬盘版下载','http://www.gougou.com/search?search=%E4%BE%A0%E7%9B%97%E7%8C%8E%E8%BD%A6%E6%89%8B%E5%9C%A3%E5%AE%89%E5%9C%B0%E5%88%97%E6%96%AF&restype=-1&id=100002',2,0,0,0,35,45895,0,0,2,0,0,'',0,''),(850,50,'侠盗中文网','http://www.xiadaocn.com/',3,0,0,0,38,28282,0,0,1,0,0,'',0,''),(851,50,'侠盗猎车吧','http://post.baidu.com/f?kw=侠盗猎车',4,0,0,0,28,35402,0,0,2,0,0,'',0,''),(852,50,'《罪恶都市》完全作弊码','http://games.sina.com.cn/handbook/2003/08/05144.shtml',5,0,0,0,42,25440,0,1,5,0,0,'',0,''),(853,50,'《圣安地列斯》完全作弊码','http://gta.uuu9.com/2007/200704/79.shtml',6,0,0,0,46,26775,0,0,2,0,0,'',0,''),(854,50,'《罪恶都市》垃圾车秘籍','http://games.sina.com.cn/j/h/2005-01-04/1700.shtml',7,0,0,0,50,21732,0,0,3,0,0,'',0,''),(855,50,'《圣安地列斯》全密技','http://www.southcn.com/it/itgame/tvgames/miji/200501190082.htm',8,0,0,0,16,12340,0,0,1,0,0,'',0,''),(856,50,'《圣安地列斯》21cn专区','http://game.21cn.com/zhuanti/gta4/',9,0,0,0,6,6636,0,0,0,0,0,'',0,''),(857,50,'侠盗飞车相关图片','http://image.baidu.com/i?tn=baiduimage&word=%CF%C0%B5%C1%B7%C9%B3%B5&z=0&lm=-1&ct=201326592&cl=2',10,0,0,0,17,16138,0,0,0,0,0,'',0,''),(858,50,'《罪恶都市》联机介绍','http://gta.uuu9.com/2007/200704/291.shtml',11,0,0,0,16,9926,0,0,2,0,0,'',0,''),(859,50,'《圣安地列斯》联机介绍','http://gta.uuu9.com/2007/200704/288.shtml',12,0,0,0,13,5602,0,0,0,0,0,'',0,''),(863,51,'祖玛的复仇','http://www.xiazaiba.com/html/245.html',1,0,0,0,26,31402,0,0,1,0,0,'',0,''),(862,50,'侠盗sina资料库','http://games.sina.com.cn/j/c/2005-04-30/2119.shtml',15,0,0,0,9,9648,0,0,0,0,0,'',0,''),(870,51,'熊猫祖玛','http://comic.sina.com.cn/f/2005-04-12/201050286.shtml',7,0,0,0,15,11728,0,1,1,0,0,'',0,''),(871,51,'海底祖玛','http://www.456.net/games/1046.htm',8,0,0,0,8,12088,0,0,0,0,0,'',0,''),(873,51,'泡泡龙flash版','http://www.chinaren.com/20050407/n225075682.shtml',10,0,0,0,2,3534,0,0,0,0,0,'',0,''),(875,51,'球类泡泡龙','http://www.xiazaiba.com/html/638.html',12,0,0,0,0,11287,0,0,0,0,0,'',0,''),(876,51,'芭比娃娃泡泡龙','http://cnc.gameyes.com/swf/_8053.htm',13,0,0,0,4,14034,0,0,0,0,0,'',0,''),(877,51,'勇者泡泡龙','http://www.4399.com/flash/1352.htm',15,0,0,0,6,5638,0,0,0,0,0,'',0,''),(879,51,'无敌泡泡龙','http://www.4399.net/flash/6741.htm',17,0,0,0,11,10540,0,0,0,0,0,'',0,''),(880,51,'泡泡龙大作战','http://www.4399.net/flash/1937.htm',18,0,0,0,12,10173,0,0,1,0,0,'',0,''),(881,51,'水果祖玛','http://www.456.net/games/3479.htm',19,0,0,0,10,14854,0,1,0,0,0,'',0,''),(882,51,'寿司祖玛','http://www.456.net/games/3273.htm',20,0,0,0,4,7649,0,0,0,0,0,'',0,''),(883,51,'行星祖玛','http://www.4399.net/flash/6567.htm',21,0,0,0,7,4860,0,0,0,0,0,'',0,''),(1346,51,'祖玛合集','http://www.game.com.cn/searchcache/zuma.html',22,0,0,0,0,0,0,0,0,0,0,'',0,''),(887,52,'FIFA足球游戏下载','http://game.gougou.com/search?search=FIFA2007&restype=1&id=1000000',1,0,0,0,23,34978,0,0,0,0,0,'',0,''),(888,48,'FIFA系列下载(52pk)','http://down.52pk.com/sort/209_1.htm',2,0,0,0,0,0,0,0,0,0,0,'',0,''),(889,52,'FIFA系列下载(52pk)','http://down.52pk.com/sort/209_1.htm',2,0,0,0,16,31054,0,0,1,0,0,'',0,''),(890,52,'FIFA足球游戏视频','http://video.baidu.com/v?word=FIFA&ct=301989888&rn=20&pn=0&db=0&s=0',3,0,0,0,1,3205,0,0,0,0,0,'',0,''),(891,52,'实况足球下载','http://down.52pk.com/sort/42_1.htm',4,0,0,0,25,33993,0,2,2,0,0,'',0,''),(892,52,'实况足球视频','http://video.baidu.com/v?word=%CA%B5%BF%F6%D7%E3%C7%F2&ct=301989888&rn=20&pn=0&db=0&s=0',5,0,0,0,1,3416,0,0,0,0,0,'',0,''),(893,52,'足球经理系列下载','http://game.gougou.com/search?search=%E8%B6%B3%E7%90%83%E7%BB%8F%E7%90%86&restype=1&id=1',6,0,0,0,3,5689,0,0,0,0,0,'',0,''),(894,52,'足球经理视频','http://video.baidu.com/v?word=%D7%E3%C7%F2+%BE%AD%C0%ED&ct=301989888&rn=20&pn=0&db=0&s=0&fbl=1024',7,0,0,0,1,1508,0,0,0,0,0,'',0,''),(895,52,'非凡网','http://www.playfifa.com/',8,0,0,0,0,643,0,0,0,0,0,'',0,''),(896,52,'Fifa吧','http://post.baidu.com/f?ct=&tn=&rn=&pn=&lm=&sc=&kw=fifa&rs2=0&myselectvalue=1&word=fifa&tb=on',9,0,0,0,0,562,0,0,0,0,0,'',0,''),(897,52,'Fifa太平洋站','http://www.pcgames.com.cn/fight/fifa/',10,0,0,0,0,495,0,0,0,0,0,'',0,''),(898,52,'FIFA大联盟论坛','http://bbs.fifachina.net/',11,0,0,0,0,879,0,0,0,0,0,'',0,''),(899,52,'完全实况论坛','http://bbs.winning11cn.com/',12,0,0,0,2,2812,0,0,0,0,0,'',0,''),(900,52,'游侠论坛实况专区','http://game.ali213.net/forum-255-1.html',13,0,0,0,0,1425,0,0,0,0,0,'',0,''),(901,52,'WSI无限足球社区','http://bbs.weshareit.net/',14,0,0,0,0,483,0,0,0,0,0,'',0,''),(902,52,'冠军足球经理之家','http://www.ourcm.net/bbs/',15,0,0,0,2,1648,0,0,0,0,0,'',0,''),(903,52,'足球经理俱乐部论坛','http://www.fmclub.com.cn/bbs/',16,0,0,0,0,951,0,0,0,0,0,'',0,''),(904,52,'游侠论坛足球经理专区','http://game.ali213.net/forum-271-1.html',17,0,0,0,0,898,0,0,0,0,0,'',0,''),(905,52,'FMFans-俱乐部','http://fmfans.cpgl.net/',18,0,0,0,1,718,0,0,0,0,0,'',0,''),(1345,51,'熊宝宝祖玛','http://www.game.com.cn/games/3/7/xbbzuma.html',23,0,0,0,0,0,0,0,0,0,0,'',0,''),(910,53,'超级玛丽玩','http://games.tom.com/download/mini/20031017/cjml2.html',5,0,0,0,16,17132,0,0,1,0,0,'',0,''),(911,53,'新超级玛丽','http://games.qq.com/a/20031112/000240.htm',6,0,0,0,41,53972,0,1,3,0,0,'',0,''),(912,53,'经典超级玛丽','http://www.nen.com.cn/72929506758754304/20041124/1551212.shtml',7,0,0,0,44,88199,0,0,5,0,0,'',0,''),(913,53,'超级玛丽之路易复仇','http://www.456.net/games/608.htm',8,0,0,0,14,21432,0,0,1,0,0,'',0,''),(915,53,'玛丽猎手','http://www.gameyes.com/swf/_4954.htm',10,0,0,0,6,10805,0,0,1,0,0,'',0,''),(916,53,'超级玛丽飞行版','http://www.gameyes.com/swf/9014.htm',11,0,0,0,14,21188,0,0,0,0,0,'',0,''),(917,53,'超级玛丽救公主','http://www.gameyes.com/swf/7994.htm',12,0,0,0,30,43327,0,0,3,0,0,'',0,''),(918,54,'帝国时代硬盘版下载','http://down.52pk.net/sort/49_1.htm',1,0,0,0,28,63603,0,0,1,0,0,'',0,''),(919,54,'帝国时代游戏视频','http://video.baidu.com/v?word=%B5%DB%B9%FA%CA%B1%B4%FA&ct=301989888&rn=20&pn=0&db=0&s=0',2,0,0,0,10,13665,0,0,0,0,0,'',0,''),(920,54,'帝国时代3-新浪专题','http://games.sina.com.cn/zt/pcgames/AOE3/',3,0,0,0,7,11142,0,0,1,0,0,'',0,''),(921,54,'帝国时代吧','http://post.baidu.com/f?ct=318898176&tn=baiduKeywordSearch&sc=13638&pn=0&rn=50&lm=4&rs3=0&word=%B5%DB%B9%FA%CA%B1%B4%FA',4,0,0,0,5,8451,0,0,0,0,0,'',0,''),(922,54,'帝国时代-ZOL游戏库','http://youxi.zol.com.cn/pc/index3738.html',5,0,0,0,2,8454,0,0,0,0,0,'',0,''),(923,54,'帝国时代罗马雄风(英文)','http://www.microsoft.com/games/aoeexpansion/',6,0,0,0,13,10952,0,0,0,0,0,'',0,''),(928,55,'南方航空','http://sale.cs-air.com/ECS/products/QQSD/modules/order/checkTicket.jsp',4,0,0,0,10,3729,0,0,2,0,0,'',0,''),(927,55,'深圳航空','http://www.shenzhenair.com/true/inputET.jsp',7,0,0,0,1,1364,0,0,0,0,0,'',0,''),(926,3,'快递运费查询','http://tool.114la.com/express_cost.html',2,0,0,0,0,8980,0,0,0,0,0,'',0,''),(933,55,'厦门航空','http://ca.travelsky.com/xmair/index.do#',8,0,0,0,2,1339,0,0,0,0,0,'',0,''),(936,55,'金鹿航空','http://et.loyoyo.com/ticket/validation.do?func=validate',5,0,0,0,0,343,0,0,0,0,0,'',0,''),(937,55,'春秋航空','http://www.china-sss.com/validation_et.asp',5,0,0,0,2,1286,0,0,0,0,0,'',0,''),(930,55,'海南航空','http://hnair.travelsky.com/huet/',9,0,0,0,2,1035,0,0,1,0,0,'',0,''),(932,55,'中国国际航空','http://www.travelsky.com/travelsky/static/home/',2,0,0,0,2,2392,0,0,0,0,0,'',0,''),(934,55,'山东航空','http://219.142.127.25/sdair/index.do',11,0,0,0,2,587,0,0,0,0,0,'',0,''),(931,55,'四川航空','http://www.scal.com.cn/ETicket/',10,0,0,0,1,1101,0,0,0,0,0,'',0,''),(943,96,'汉字转换为拼音','http://tool.114la.com/str2py.html',7,0,0,0,0,10401,0,0,0,0,0,'',0,''),(939,1,'2009年黄道吉日表','http://tool.114la.com/hd.html',24,0,0,0,0,28734,0,0,0,0,0,'',0,''),(951,59,'仙剑壁纸','http://image.baidu.com/i?tn=baiduimage&ct=201326592&cl=2&lm=-1&rn=16&word=%CF%C9%BD%A3%C6%E6%CF%C0%B4%AB%20%D3%CE%CF%B7&z=5',4,0,0,0,0,11118,0,0,0,0,0,'',0,''),(949,59,'中国仙剑联盟','http://www.palunion.net/bbs/',2,0,0,0,6,8770,0,0,1,0,0,'',0,''),(948,59,'仙剑奇侠传四博客','http://blog.sina.com.cn/pal4',1,0,0,0,10,12761,0,0,0,0,0,'',0,''),(950,59,'百度仙剑奇侠吧','http://post.baidu.com/f?kw=%CF%C9%BD%A3%C6%E6%CF%C0%B4%AB',3,0,0,0,6,9540,0,0,0,0,0,'',0,''),(952,59,'仙剑4-TOM游戏','http://games.tom.com/zt/pal4/',5,0,0,0,20,17113,0,0,0,0,0,'',0,''),(953,59,'仙剑奇侠传4台湾官方','http://pal.joypark.com.tw/PAL4/index.asp',6,0,0,0,10,12108,0,0,0,0,0,'',0,''),(954,59,'仙剑4存档修改器','http://dl.it.21cn.com/list.php?id=64661',7,0,0,0,2,3085,0,0,0,0,0,'',0,''),(955,59,'仙剑奇侠传4官方网站','http://www.softstar.sh.cn/pal4/pal4/index.htm',8,0,0,0,18,30215,0,0,1,0,0,'',0,''),(956,58,'功夫小子官方','http://kk.sdo.com/web1.0/home/',1,0,0,0,18,24211,0,0,2,0,0,'',0,''),(957,58,'功夫小子客户端下载','http://kk.sdo.com/project/xinshou/',2,0,0,0,4,8732,0,0,0,0,0,'',0,''),(958,58,'17173功夫小子专区','http://kk.17173.com/',3,0,0,0,1,3474,0,0,0,0,0,'',0,''),(959,58,'太平洋功夫小子专区','http://www.pcgames.com.cn/netgames/zhuanti/gfxz/',4,0,0,0,1,1387,0,0,0,0,0,'',0,''),(960,58,'功夫多玩主题站','http://kk.duowan.com/',5,0,0,0,0,841,0,0,0,0,0,'',0,''),(961,60,'疯狂斗地主-联众','http://www.ourgame.com/game/game-intro-new/newgame.html?gameid=lord3$0',1,0,0,0,11,13297,0,0,0,0,0,'',0,''),(963,60,'中国游戏中心-斗地主','http://www.chinagames.net/mygames/cardgames/landlord/',2,0,0,0,12,15279,0,1,1,0,0,'',0,''),(964,60,'新浪-斗地主','http://igame.sina.com.cn/game/doudizhu/',3,0,0,0,5,9143,0,1,0,0,0,'',0,''),(965,60,'海宇QQ斗地主记牌器','http://www.onlinedown.net/soft/36311.htm',4,0,0,0,2,2324,0,0,0,0,0,'',0,''),(966,60,'联众斗地主记牌器','http://www.onlinedown.net/soft/43796.htm',6,0,0,0,0,2692,0,0,0,0,0,'',0,''),(967,60,'成都斗地主','http://www.xiazaiba.com/html/858.html',7,0,0,0,6,8999,0,0,0,0,0,'',0,''),(968,60,'开心斗地主','http://www.xiazaiba.com/html/850.html',8,0,0,0,50,46381,0,3,4,0,0,'',0,''),(969,60,'楚天斗地主','http://www.xiazaiba.com/html/859.html',9,0,0,0,4,4572,0,1,2,0,0,'',0,''),(970,60,'武汉斗地主','http://www.ourgame.com/game/game-intro-new/glgame.html?gameid=20029$0',10,0,0,0,4,5072,0,0,0,0,0,'',0,''),(971,60,'百度斗地主吧','http://post.baidu.com/f?kw=%B6%B7%B5%D8%D6%F7',5,0,0,0,9,9747,0,0,1,0,0,'',0,''),(972,62,'雷神竞技场中文站','http://www.q3acn.com/',1,0,0,0,2,4792,0,0,0,0,0,'',0,''),(973,62,'雷神之锤(quake)','http://games.sina.com.cn/zhuanqu/quake/',2,0,0,0,13,11762,0,0,0,0,0,'',0,''),(974,62,'新浪足球经理在线','http://games.sina.com.cn/z/cmol/',3,0,0,0,0,2712,0,0,0,0,0,'',0,''),(975,62,'香港CM游迷网[港]','http://www.hkcm.com/',4,0,0,0,3,3679,0,0,0,0,0,'',0,''),(976,62,'新浪三角洲专区','http://games.sina.com.cn/zhuanqu/df/',5,0,0,0,9,7917,0,0,0,0,0,'',0,''),(983,41,'宠物宝贝连连看','http://www.game.com.cn/games/1/5/cwbbllk.html',1,0,0,0,0,13246,0,0,0,0,0,'',0,''),(979,25,'net.Fire|CS战队','http://www.netfire.com.cn/',24,0,0,0,0,3699,0,0,0,0,0,'',0,''),(985,52,'爆棚足球网','http://www.ballpure.com/',19,0,0,0,0,1503,0,0,0,0,0,'',0,''),(980,41,'麻将连连看','http://www.game.com.cn/games/0/5/animal%20link.html',0,0,0,0,0,83404,0,0,0,0,0,'',0,''),(984,41,'超女连连看','http://www.game.com.cn/games/1/7/chaonvllk.html',1,0,0,0,0,44775,0,0,0,0,0,'',0,''),(986,97,'中国心百家姓头像','http://tool.114la.com/chinaheart.html',1,0,0,0,0,25106,0,0,0,0,0,'',0,''),(1086,68,'森田疗法','http://bk.baidu.com/w?word=森田疗法&tn=baiduWikiSearch&ct=17&lm=0',100,0,0,0,0,1463,0,0,0,0,0,'',0,''),(994,2,'火车查询网','http://www.huoche.net',17,0,0,0,0,3419,0,0,0,0,0,'',0,''),(993,28,'爱我中华','http://mp3.baidu.com/m?tn=uc_1_pg&tn=uc_1_pg&f=ms&ct=134217728&word=爱我中华',4,0,0,0,114,155614,0,5,15,0,0,'',0,''),(995,96,'英文大小写转换工具','http://www.iamwawa.cn/bigtosmall.asp',9,0,0,0,0,701,0,0,0,0,0,'',0,''),(1009,44,'小游戏','http://www.game.com.cn',100,0,0,0,387,288945,0,1,28,0,0,'',0,''),(1092,76,'模拟蜘蛛抓取页面工具','http://tool.114la.com/robot.html',5,0,0,0,0,690,0,0,0,0,0,'',0,''),(1013,63,'坐在家里赚','http://gb.36578.com/gbook_admin/getgo.php?id=1669',2,0,0,0,6,41103,0,0,0,0,0,'2008创业赚&lt;br /&gt;http://www.sooe.cn?comeID=17824',0,''),(1018,72,'刺激2009','http://mp3.baidu.com/m?word=刺激2009&tn=haokan123&f=ms&ct=134217728',2,0,0,0,1,10122,0,0,0,0,0,'',0,''),(1019,72,'北京欢迎你','http://mp3.baidu.com/m?word=%B1%B1%BE%A9%BB%B6%D3%AD%C4%E3&tn=haokan123&f=ms&ct=134217728',3,0,0,0,2,16970,0,0,1,0,0,'',0,''),(1020,72,'如果没有你的爱','http://mp3.baidu.com/m?word=如果没有你的爱&tn=haokan123&f=ms&ct=134217728',1,0,0,0,2,14162,0,0,1,0,0,'',0,''),(1021,72,'旋转木马','http://mp3.baidu.com/m?word=旋转木马&tn=haokan123&f=ms&ct=134217728',6,0,0,0,0,6968,0,0,0,0,0,'',0,''),(1025,64,'Mp3','http://mp3.ylmf.com/',2,0,0,0,298,207159,0,2,17,0,0,'',0,'#FD2828'),(1026,64,'新浪','http://www.sina.com.cn/',3,0,0,0,504,990561,0,11,46,0,0,'',0,''),(1027,64,'新闻','http://news.sina.com.cn/',4,0,0,0,122,329400,0,1,25,0,0,'',0,'#FD2828'),(1028,64,'博客','http://blog.sina.com.cn/',5,0,0,0,16,53180,0,0,5,0,0,'',0,'#FD2828'),(1029,64,'搜狐','http://www.sohu.com/',6,0,0,0,313,757085,0,7,36,0,0,'',0,''),(1030,64,'新闻','http://news.sohu.com/',7,0,0,0,64,161866,0,0,9,0,0,'',0,'#FD2828'),(1031,64,'体育','http://sports.sohu.com/',8,0,0,0,67,86113,0,0,5,1225468800,1225468800,'',0,'#FD2828'),(1032,64,'网易','http://www.163.com/',9,0,0,0,284,597258,0,7,26,0,0,'',0,''),(1033,64,'新闻','http://news.163.com/',10,0,0,0,20,108836,0,1,2,0,0,'',0,'#FD2828'),(1034,64,'科技','http://tech.163.com/',11,0,0,0,1,23239,0,0,0,0,0,'http://2008.163.com/?from=daohang',0,'#FD2828'),(1035,64,'百度搜索','http://www.baidu.com/index.php?tn=haokan123',1,0,0,0,326,828818,0,4,34,0,0,'',0,''),(1036,71,'孙亚莉','http://image.baidu.com/i?word=孙亚莉&tn=baiduimage&ct=201326592&cl=2&pv=&lm=-1',1,0,0,0,2,8573,0,0,0,0,0,'',0,''),(1037,71,'火亮','http://image.baidu.com/i?word=%BB%F0%C1%C1&tn=baiduimage&ct=201326592&cl=2&pv=&lm=-1',2,0,0,0,0,3827,0,0,0,0,0,'',0,''),(1038,71,'林志玲','http://image.baidu.com/i?word=林志玲&tn=baiduimage&ct=201326592&cl=2&pv=&lm=-1',3,0,0,0,0,5905,0,0,0,0,0,'',0,''),(1040,71,'非主流','http://image.baidu.com/i?word=%B7%C7%D6%F7%C1%F7&tn=baiduimage&ct=201326592&cl=2&pv=&lm=-1',4,0,0,0,6,38648,0,0,2,0,0,'',0,''),(1041,71,'美女图片','http://image.baidu.com/i?word=%C3%C0%C5%AE%CD%BC%C6%AC&tn=baiduimage&ct=201326592&cl=2&pv=&lm=-1',5,0,0,0,8,161206,0,0,0,0,0,'',0,''),(1042,70,'北京奥运会吧','http://tieba.baidu.com/f?kw=%B1%B1%BE%A9%B0%C2%D4%CB%BB%E1',1,0,0,0,3,1890,0,0,0,0,0,'',0,''),(1043,70,'中国男篮吧','http://tieba.baidu.com/f?kw=%D6%D0%B9%FA%C4%D0%C0%BA',2,0,0,0,0,1480,0,0,0,0,0,'',0,''),(1044,70,'NBA吧','http://tieba.baidu.com/f?kw=nba',3,0,0,0,4,3604,0,0,1,0,0,'',0,''),(1045,70,'电影吧','http://tieba.baidu.com/f?kw=%B5%E7%D3%B0',4,0,0,0,0,3892,0,0,0,0,0,'',0,''),(1046,69,'乘坐卧铺要注意哪些问题？','http://zhidao.baidu.com/q?word=乘坐卧铺要注意哪些问题&tn=ikaslist&pt=uc_ik&ct=17',1,0,0,0,0,4043,0,0,0,0,0,'',0,''),(1047,68,'丁蟹效应','http://bk.baidu.com/w?word=丁蟹效应&tn=baiduWikiSearch&ct=17&lm=0',1,0,0,0,1,3942,0,0,0,0,0,'',0,''),(1048,68,'小年','http://bk.baidu.com/w?word=小年&tn=baiduWikiSearch&ct=17&lm=0',2,0,0,0,1,2165,0,0,0,0,0,'',0,''),(1049,68,'趟水效应','http://bk.baidu.com/w?word=趟水效应&tn=baiduWikiSearch&ct=17&lm=0',4,0,0,0,0,2346,0,0,0,0,0,'',0,''),(1050,67,'非诚勿扰','http://video.baidu.com/v?word=非诚勿扰&ct=301989888&rn=20&pn=0&db=0&s=0&ty=10',1,0,0,0,3,19828,0,0,0,0,0,'珠光宝气&lt;br /&gt;http://video.baidu.com/v?word=珠光宝气&ct=301989888&rn=20&pn=0&db=0&s=0&ty=10',0,''),(1051,67,'东邪西毒终极版','http://video.baidu.com/v?word=东邪西毒终极版&ct=301989888&rn=20&pn=0&db=0&s=0&ty=10',2,0,0,0,1,17690,0,0,0,0,0,'',0,''),(1054,73,'新列车运行图','http://www.baidu.com/s?wd=列车运行图调整&tn=haokan123',1,0,0,0,0,0,0,0,0,0,0,'',0,''),(1056,73,'清明假期','http://www.baidu.com/s?wd=清明假期&tn=haokan123',2,0,0,0,0,0,0,0,0,0,0,'',0,''),(1058,65,'工商银行','http://www.baidu.com/s?wd=%B9%A4%C9%CC%D2%F8%D0%D0&tn=haokan123',1,0,0,0,1,5512,0,0,0,0,0,'',0,''),(1059,65,'中国石油','http://www.baidu.com/s?wd=%D6%D0%B9%FA%CA%AF%D3%CD+&tn=haokan123',2,0,0,0,1,7518,0,0,0,0,0,'',0,''),(1060,65,'中信证券','http://www.baidu.com/s?wd=%D6%D0%D0%C5%D6%A4%C8%AF&tn=haokan123',4,0,0,0,0,5777,0,0,0,0,0,'',0,''),(1061,65,'广发聚丰','http://www.baidu.com/s?wd=%B9%E3%B7%A2%BE%DB%B7%E1&tn=haokan123',4,0,0,0,1,2099,0,0,0,0,0,'',0,''),(1319,64,'科技','http://doc.go.sohu.com/200811/5c90becee733beb5f6b500e9f3528005.php',8,0,0,0,0,304,0,0,0,0,0,'',0,'#FD2828'),(1107,96,'火星文转换器','http://tool.114la.com/huoxing.html',10,0,0,0,0,3278,0,0,0,0,0,'',0,''),(1101,4,'论坛超级转帖工具','http://tool.114la.com/zhuantie.html',28,0,0,0,0,454,0,0,0,0,0,'',0,''),(1118,77,'SQL Server精华','http://help.114la.com/SQL%20Server精华',100,0,0,0,0,693,0,0,0,0,0,'',0,''),(1098,75,'网页颜色代码选择器','http://tool.114la.com/color.html',3,0,0,0,0,272,0,0,0,0,0,'',0,''),(1099,75,'JS/HTML格式化工具','http://tool.114la.com/jsformat.html',5,0,0,0,0,198,0,0,0,0,0,'',0,''),(1111,75,'传统中文排版工具','http://tool.114la.com/paiban.html',7,0,0,0,0,283,0,0,0,0,0,'',0,''),(1112,8,'日期相差天数计算','http://tool.114la.com/date_different.html',12,0,0,0,0,649,0,0,0,0,0,'',0,''),(1114,77,'javascript 语言参考手册 中文版','http://help.114la.com/javascript',100,0,0,0,0,467,0,0,0,0,0,'',0,''),(1115,77,'Microsoft Windows 脚本技术','http://help.114la.com/windows_script',100,0,0,0,0,349,0,0,0,0,0,'',0,''),(1116,77,'Apache HTTP Server Version 2.2 文档','http://help.114la.com/Apache2',100,0,0,0,0,75,0,0,0,0,0,'',0,''),(1117,77,'mysql 5.1手册','http://help.114la.com/mysql%205.1',100,0,0,0,0,117,0,0,0,0,0,'',0,''),(1109,75,'HTML特殊符号对照表','http://tool.114la.com/special_htmlchar.html',9,0,0,0,0,232,0,0,0,0,0,'',0,''),(1093,76,'网页Meta信息检测','http://tool.114la.com/meta.html',6,0,0,0,0,171,0,0,0,0,0,'',0,''),(1095,76,'页面关键字密度查询','http://tool.114la.com/density.html',8,0,0,0,0,172,0,0,0,0,0,'',0,''),(1090,76,'网站关键字排名查询','http://tool.114la.com/keyword.html',3,0,0,0,0,434,0,0,0,0,0,'',0,''),(1084,69,'使用电热毯对身体有坏处吗？','http://zhidao.baidu.com/q?word=使用电热毯对身体有坏处吗&tn=ikaslist&pt=uc_ik&ct=17',100,0,0,0,0,1785,0,0,0,0,0,'',0,''),(1128,75,'代码语法高亮工具','http://tool.114la.com/codehightlight.html',12,0,0,0,0,131,0,0,0,0,0,'',0,''),(1113,77,'样式表中文手册','http://help.114la.com/css',100,0,0,0,0,347,0,0,0,0,0,'',0,''),(1085,68,'火车票实名制','http://bk.baidu.com/w?word=火车票实名制&tn=baiduWikiSearch&ct=17&lm=0',100,0,0,0,0,1526,0,0,0,0,0,'',0,''),(1102,75,'HTML转换为JS','http://tool.114la.com/html2js.html',6,0,0,0,0,126,0,0,0,0,0,'',0,''),(1103,75,'HTML与UBB代码互转','http://tool.114la.com/html2ubb.html',1,0,0,0,0,102,0,0,0,0,0,'',0,''),(1104,75,'字符串转换为ASCII','http://tool.114la.com/str2asc.html',10,0,0,0,0,106,0,0,0,0,0,'',0,''),(1100,75,'网页源代码查看','http://tool.114la.com/source.html',2,0,0,0,0,558,0,0,0,0,0,'',0,''),(1108,75,'ASCII字形生成器','http://tool.114la.com/asciigraphemic.html',11,0,0,0,0,273,0,0,0,0,0,'',0,''),(1106,96,'在线简繁体字转换工具','http://tool.114la.com/gb2big.html',4,0,0,0,0,588,0,0,0,0,0,'',0,''),(1091,76,'反向链接查询','http://tool.114la.com/link.html',4,0,0,0,0,214,0,0,0,0,0,'',0,''),(1083,72,'如果爱的不是我','http://mp3.baidu.com/m?word=如果爱的不是我&tn=haokan123&f=ms&ct=134217728',5,0,0,0,2,7326,0,0,0,0,0,'',0,''),(1096,4,'IP/域名Whois查询','http://tool.115.com/?ct=site&ac=whois',10,0,0,0,0,570,0,0,0,0,0,'',0,''),(1130,75,'E-Mail 图标生成器','http://tool.114la.com/email2pic.html',14,0,0,0,0,628,0,0,0,0,0,'',0,''),(1132,67,'倾城之恋','http://video.baidu.com/v?word=倾城之恋&tn=haokan123',100,0,0,0,4,4034,0,0,1,0,0,'',0,''),(1065,11,'魔兽地图吧','http://bbs.wow8.org/',100,0,0,0,0,4080,0,0,0,0,0,'',0,''),(1066,63,'一夜赚80万','http://www.78.cn/haokan123_index1.htm',3,0,0,0,8,52465,0,0,2,0,0,'http://www.28.com?comeID=56827',0,''),(1150,1,'预产期自测','http://tool.114la.com/birthday.html',22,0,0,0,0,1554,0,0,0,0,0,'',0,''),(1173,8,'功、能和热量转换','http://tool.114la.com/converter5.html',13,0,0,0,0,96,0,0,0,0,0,'',0,''),(1157,4,'MD5加密','http://tool.114la.com/md5.html',17,0,0,0,0,439,0,0,0,0,0,'',0,''),(1121,77,'Essential PHP Security -PHP安全基础(中文版)','http://help.114la.com/Essential_PHP_Security',100,0,0,0,0,39,0,0,0,0,0,'',0,''),(1070,74,'千年-17173专题','http://1000y.17173.com/',4,0,0,0,0,319,0,0,0,0,0,'',0,''),(1069,74,'千年3客户端下载','http://1000y.sdo.com/web/download/download.asp',2,0,0,0,0,1066,0,0,0,0,0,'',0,''),(1068,74,'千年3官方网站','http://1000y.sdo.com/',1,0,0,0,0,12607,0,0,0,0,0,'',0,''),(1129,75,'正则表达式检测','http://tool.114la.com/regxtest.html',4,0,0,0,0,149,0,0,0,0,0,'',0,''),(1097,75,'CSS生成器','http://tool.114la.com/css_online.html',3,0,0,0,0,518,0,0,0,0,0,'',0,''),(1071,74,'千年-新浪专题','http://games.sina.com.cn/zhqu/1000y/indexpage.shtml',5,0,0,0,0,194,0,0,0,0,0,'',0,''),(1072,74,'千年官方论坛','http://bbs.1000y.sdo.com/',3,0,0,0,0,575,0,0,0,0,0,'',0,''),(1119,77,'Squid:The Definitive Guide(英文)','http://help.114la.com/Squid%20The%20Definitive%20Guide',100,0,0,0,0,20,0,0,0,0,0,'',0,''),(1123,77,'Pascal 学习指南','http://help.114la.com/Pascal',100,0,0,0,0,224,0,0,0,0,0,'',0,''),(1122,77,'精通正则表达式第3版(英文)','http://help.114la.com/Mastering%20Regular%20Expressions,%203rd%20Edition',100,0,0,0,0,131,0,0,0,0,0,'',0,''),(1194,81,'766-穿越火线','http://cf.766.com/',8,0,0,0,0,1333,0,0,0,0,0,'',0,''),(1211,84,'剑侠世界客户端下载','http://jxsj.xoyo.com/',2,0,0,0,0,930,0,0,0,0,0,'',0,''),(1185,80,'寻仙游戏论坛','http://gamebbs.qq.com/cgi-bin/bbs/user/user_enter_bbs?g=f&url=/lanmu/159.shtml',3,0,0,0,0,523,0,0,0,0,0,'',0,''),(1163,75,'escape加密/解密','http://tool.114la.com/escape.html',18,0,0,0,0,319,0,0,0,0,0,'',0,''),(1209,84,'52PK-剑侠世界','http://games.52pk.com/jxsj/',5,0,0,0,0,171,0,0,0,0,0,'',0,''),(1186,80,'寻仙客户端下载','http://app.xx.qq.com/comm-cgi-bin/login/checklogin.cgi?type=15&url=http://app.xx.qq.com/cgi-bin/nodelkey/CheckLoad.cgi',2,0,0,0,0,1993,0,0,0,0,0,'',0,''),(1166,8,'长度单位换算','http://tool.114la.com/converter1.html',9,0,0,0,0,354,0,0,0,0,0,'',0,''),(1167,8,'面积转换换算','http://tool.114la.com/converter3.html',15,0,0,0,0,392,0,0,0,0,0,'',0,''),(1171,8,'功率计量单位换算','http://tool.114la.com/converter2.html',16,0,0,0,0,161,0,0,0,0,0,'',0,''),(1155,3,'实时汇率转换','http://tool.115.com/?ct=finance&ac=rate',3,0,0,0,0,540,0,0,0,0,0,'',0,''),(1156,3,'黄金价格实时走势','http://tool.114la.com/gold.html',10,0,0,0,0,1109,0,0,0,0,0,'',0,''),(1146,76,'网站反应速度测试','http://tool.114la.com/speedtest.html',12,0,0,0,0,551,0,0,0,0,0,'',0,''),(1154,3,'购房计算工具','http://tool.114la.com/buyhouse.html',5,0,0,0,0,1674,0,0,0,0,0,'',0,''),(1144,4,'在线wap模拟器','http://tool.114la.com/wapview.html',20,0,0,0,0,494,0,0,0,0,0,'',0,''),(1145,76,'友情链接批量检查','http://tool.114la.com/links.html',9,0,0,0,0,102,0,0,0,0,0,'',0,''),(1174,8,'体质指数/理想体重','http://tool.114la.com/weight.html',17,0,0,0,0,2920,0,0,0,0,0,'',0,''),(1168,8,'温度转换换算','http://tool.114la.com/converter6.html',14,0,0,0,0,98,0,0,0,0,0,'',0,''),(1151,1,'身份证号码查询','http://tool.115.com/?ct=live&ac=idcard',13,0,0,0,0,4373,0,0,0,0,0,'',0,''),(1169,8,'重量转换换算器','http://tool.114la.com/converter7.html',11,0,0,0,0,369,0,0,0,0,0,'',0,''),(1172,8,'体积和容量单位换算','http://tool.114la.com/converter4.html',19,0,0,0,0,299,0,0,0,0,0,'',0,''),(1164,4,'收藏夹图标生成器','http://tool.114la.com/pic2icon.html',21,0,0,0,0,417,0,0,0,0,0,'',0,''),(1196,81,'天平洋游戏-穿越火线','http://wangyou.pcgames.com.cn/zhuanti/qqcf/',6,0,0,0,0,1466,0,0,0,0,0,'',0,''),(1210,84,'天平洋网-剑侠世界','http://www.pcgames.com.cn/kzzt/net/jxsjzq/',3,0,0,0,0,228,0,0,0,0,0,'',0,''),(1162,75,'Base64加密/解密','http://tool.114la.com/base64.html',22,0,0,0,0,355,0,0,0,0,0,'',0,''),(1161,75,'URL16进制加密','http://tool.114la.com/url16.html',24,0,0,0,0,120,0,0,0,0,0,'',0,''),(1158,75,'JS加密/解密','http://tool.114la.com/js.html',25,0,0,0,0,322,0,0,0,0,0,'',0,''),(1159,96,'简繁汉字转换','http://tool.114la.com/gb2big.html',16,0,0,0,0,1121,0,0,0,0,0,'',0,''),(1153,3,'个人理财计算工具','http://tool.114la.com/finances_tool.html',4,0,0,0,0,2006,0,0,0,0,0,'',0,''),(1208,84,'剑侠世界-新浪游戏','http://games.sina.com.cn/o/z/jxsj/qianru.shtml',4,0,0,0,0,326,0,0,0,0,0,'',0,''),(1188,80,'太平洋游戏网寻仙专区','http://xx.pcgames.com.cn/',4,0,0,0,0,211,0,0,0,0,0,'',0,''),(1189,81,'穿越火线官方网站','http://cf.qq.com/index.shtml',1,0,0,0,0,9559,0,0,0,0,0,'',0,''),(1190,81,'穿越火线客户端下载','http://cf.qq.com/',2,0,0,0,2,7793,0,0,0,0,0,'',0,''),(1187,80,'玩多多游戏-寻仙专题','http://www.onedodo.com/zq/xun/',5,0,0,0,0,188,0,0,0,0,0,'',0,''),(1183,79,'中华网-热血三国','http://game.china.com/rxsg/jinyan/',100,0,0,0,0,635,0,0,0,0,0,'',0,''),(1184,80,'寻仙官方站点','http://xunxian.qq.com/',1,0,0,0,0,4589,0,0,0,0,0,'',0,''),(1175,78,'地下城与勇士','http://dnf.qq.com/index.shtml',1,0,0,0,0,11649,0,0,0,0,0,'',0,''),(1176,78,'客户端下载','http://dnf.qq.com/',2,0,0,0,0,6041,0,0,0,0,0,'',0,''),(1177,78,'官方论坛','http://gamebbs.qq.com/bbs/dnfhtm/197.htm',3,0,0,0,0,1395,0,0,0,0,0,'',0,''),(1178,78,'17173-地下城与勇士','http://dnf.17173.com/',4,0,0,0,0,1856,0,0,0,0,0,'',0,''),(1179,78,'多玩-地下城与勇士','http://df.duowan.com/',5,0,0,0,0,1329,0,0,0,0,0,'',0,''),(1204,83,'传奇外传客户端下载','http://mirs.sdo.com/web1/index/index.html',2,0,0,0,0,1295,0,0,0,0,0,'',0,''),(1180,79,'91玩-热血三国','http://www.91wan.com/rxsg/',100,0,0,0,0,5603,0,0,0,0,0,'',0,''),(1181,79,'热血三国官方网站','http://sg.wangye173.com/',0,0,0,0,0,2725,0,0,0,0,0,'',0,''),(1182,79,'17173-热血三国','http://web.17173.com/_rxsg/',100,0,0,0,0,517,0,0,0,0,0,'',0,''),(1207,84,'剑侠世界官方网站','http://jxsj.xoyo.com/service/index.shtml',1,0,0,0,0,3041,0,0,0,0,0,'',0,''),(1205,83,'腾讯游戏-传奇外传','http://games.qq.com/z/cqwz/',4,0,0,0,0,515,0,0,0,0,0,'',0,''),(1206,83,'新浪游戏-传奇外传','http://games.sina.com.cn/o/c/2008-09-09/6355.shtml',3,0,0,0,0,635,0,0,0,0,0,'',0,''),(1141,76,'模拟蜘蛛抓取页面','http://tool.114la.com/robot.html',11,0,0,0,0,702,0,0,0,0,0,'',0,''),(1203,83,'传奇外传官网','http://mirs.sdo.com/web2/home/index.asp',1,0,0,0,0,3378,0,0,0,0,0,'',0,''),(1201,82,'太平洋网-DOTA专区','http://www.pcgames.com.cn/fight/warcraft/dota/',5,0,0,0,0,67,0,0,0,0,0,'',0,''),(1191,81,'穿越火线论坛','http://gamebbs.qq.com/bbs/cfhtm/196.htm',3,0,0,0,0,780,0,0,0,0,0,'',0,''),(1192,81,'52pk-穿越火线专题','http://games.52pk.com/cf/',4,0,0,0,0,527,0,0,0,0,0,'',0,''),(1193,81,'17173-穿越火线专题','http://cf.17173.com/',5,0,0,0,0,504,0,0,0,0,0,'',0,''),(1200,82,'超级玩家DOTA专题','http://dota.sgamer.com/',4,0,0,0,0,187,0,0,0,0,0,'',0,''),(1199,82,'DOTA中文资讯网','http://www.dota.cc/',2,0,0,0,0,197,0,0,0,0,0,'',0,''),(1198,82,'Dota中文网','http://www.dotacn.com.cn/',1,0,0,0,0,1442,0,0,0,0,0,'',0,''),(1197,82,'U9网-DOTA专题站','http://dota.uuu9.com/',3,0,0,0,14,1534,0,0,3,0,0,'',0,''),(1218,94,'2009年高考在线估分','http://www.baidu.com/s?tn=6885_pg&wd=2009年高考试题答案及在线估分',2,0,0,0,0,0,0,0,0,0,0,'',0,''),(1219,94,'IPO重启','http://www.baidu.com/s?tn=6885_pg&wd=IPO重启',1,0,0,0,0,0,0,0,0,1243785600,1243785600,'',0,''),(1217,93,'你不是真正的快乐','http://www.baidu.com/s?tn=6885_pg&wd=%C4%E3%B2%BB%CA%C7%D5%E6%D5%FD%B5%C4%BF%EC%C0%D6',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1287,76,'火车采集器','http://www.locoy.com/',100,0,0,0,0,342,0,0,0,0,0,'',0,''),(1221,90,'什么是小产权房?','http://zhidao.baidu.com/q?tn=ikaslist&pt=uc_ik&ct=17&word=%CA%B2%C3%B4%CA%C7%D0%A1%B2%FA%C8%A8%B7%BF',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1321,64,'邮箱','http://mail.163.com/',11,0,0,0,0,264,0,0,0,1225468800,1225468800,'',0,'#FD2828'),(1222,85,'百度搜索','http://www.baidu.com/index.php?tn=6885',1,0,0,0,0,0,0,0,0,0,0,'',0,''),(1223,85,'Mp3','http://mp3.baidu.com/',2,0,0,0,1527,18289,0,18,146,0,0,'',0,''),(1224,85,'新浪','http://www.sina.com.cn/',3,0,0,0,311,4226,0,6,35,0,0,'',0,''),(1225,85,'新闻','http://news.sina.com.cn/',4,0,0,0,257,33218,0,8,22,0,0,'',0,'#FF0000'),(1226,85,'博客','http://blog.sina.com.cn/',5,0,0,0,79,9285,0,0,6,0,0,'',0,'#FF0000'),(1227,85,'搜狐','http://www.sohu.com/',6,0,0,0,147,2328,0,3,21,0,0,'',0,''),(1228,85,'新闻','http://news.sohu.com/',7,0,0,0,105,12840,0,1,9,0,0,'',0,'#FD2828'),(1229,85,'体育','http://sports.sohu.com/',8,0,0,0,78,4413,0,0,8,0,0,'',0,'#FD2828'),(1230,85,'网易','http://www.163.com/',9,0,0,0,85,1442,0,2,12,0,0,'',0,''),(1231,85,'新闻','http://news.163.com/',10,0,0,0,39,5347,0,1,4,0,0,'',0,'#FD2828'),(1232,85,'科技','http://tech.163.com/',11,0,0,0,2,1195,0,0,0,0,0,'',0,'#FD2828'),(1235,86,'上证指数','http://www.baidu.com/baidu?tn=6885_pg&word=%C9%CF%D6%A4%D6%B8%CA%FD',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1236,86,'万科a','http://www.baidu.com/baidu?tn=6885_pg&word=+%CD%F2%BF%C6a',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1237,86,'中国平安','http://www.baidu.com/baidu?tn=6885_pg&word=+%D6%D0%B9%FA%C6%BD%B0%B2+',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1238,86,'中信证券','http://www.baidu.com/baidu?tn=6885_pg&word=+%D6%D0%B9%FA%C6%BD%B0%B2+',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1239,86,'北大荒','http://www.baidu.com/baidu?tn=6885_pg&word=%B1%B1%B4%F3%BB%C4',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1240,86,'中国石油','http://www.baidu.com/baidu?tn=6885_pg&word=%B1%B1%B4%F3%BB%C4',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1242,88,'NBA全明星赛','http://video.baidu.com/v?word=NBA全明星赛&ct=301989888&rn=20&pn=0&db=0&s=0&ty=10',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1267,95,'薄瓜瓜','http://www.baidu.com/s?tn=6885_pg&wd=薄瓜瓜',3,0,0,0,0,0,0,0,0,0,0,'',0,''),(1244,88,'我的团长我的团','http://video.baidu.com/v?tn=6885_pg&word=我的团长我的团',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1245,88,'妻子的诱惑','http://video.baidu.com/v?word=妻子的诱惑&ct=301989888&rn=20&pn=0&db=0&s=0&ty=10',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1246,88,'韩版花样男子','http://video.baidu.com/v?word=韩版花样男子&ct=301989888&rn=20&pn=0&db=0&s=0&ty=10',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1247,88,'神秘拼图','http://video.baidu.com/v?word=神秘拼图&ct=301989888&rn=20&pn=0&db=0&s=0&ty=10',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1248,89,'亚欧首脑会议','http://bk.baidu.com/w?tn=baiduWikiSearch&ct=17&lm=0&word=%D1%C7%C5%B7%CA%D7%C4%D4%BB%E1%D2%E9+',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1249,89,'电脑黑屏','http://bk.baidu.com/w?tn=baiduWikiSearch&ct=17&lm=0&word=%B5%E7%C4%D4%BA%DA%C6%C1',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1250,89,'诺贝尔奖','http://bk.baidu.com/w?tn=baiduWikiSearch&ct=17&lm=0&word=%C5%B5%B1%B4%B6%FB%BD%B1',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1251,89,'柑橘大实蝇','http://bk.baidu.com/w?tn=baiduWikiSearch&ct=17&lm=0&word=%B8%CC%E9%D9%B4%F3%CA%B5%D3%AC',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1252,89,'美国次贷危机','http://bk.baidu.com/w?tn=baiduWikiSearch&ct=17&lm=0&word=+%C3%C0%B9%FA%B4%CE%B4%FB%CE%A3%BB%FA',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1253,90,'金融危机为什么会产生连锁反应？','http://zhidao.baidu.com/question/71479572.html',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1254,91,'捐旧衣服吧','http://tieba.baidu.com/f?kw=%BE%E8%BE%C9%D2%C2%B7%FE&bl=jrhd_02',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1255,91,'红色警戒吧','http://tieba.baidu.com/f?kw=%BA%EC%C9%AB%BE%AF%BD%E4&bl=jrhd_04',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1256,91,'诗歌门外汉吧','http://tieba.baidu.com/f?kw=%CA%AB%B8%E8%C3%C5%CD%E2%BA%BA&bl=jrhd_01',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1257,91,'魔兽世界吧','http://tieba.baidu.com/f?kw=%C4%A7%CA%DE%CA%C0%BD%E7',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1299,100,'魔域客户端下载','http://my.91.com/download/',2,0,0,0,0,1909,0,0,0,0,0,'',0,''),(1258,95,'富家子飙车命案','http://www.baidu.com/s?tn=6885_pg&wd=富家子飙车',1,0,0,0,0,0,0,0,0,0,0,'',0,''),(1259,95,'8000万版权费','http://www.baidu.com/s?tn=6885_pg&wd=8000万版权费',2,0,0,0,0,0,0,0,0,0,0,'',0,''),(1260,92,'非主流','http://image.baidu.com/i?tn=baiduimage&ct=201326592&cl=2&pv=&lm=-1&word=%B7%C7%D6%F7%C1%F7',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1261,92,'酒井法子','http://image.baidu.com/i?tn=baiduimage&ct=201326592&cl=2&pv=&lm=-1&word=酒井法子',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1262,92,'刘亦菲','http://image.baidu.com/i?tn=baiduimage&ct=201326592&cl=2&pv=&lm=-1&word=%C1%F5%D2%E0%B7%C6',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1263,92,'张柏芝','http://image.baidu.com/i?tn=baiduimage&ct=201326592&cl=2&pv=&lm=-1&word=张柏芝',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1264,92,'林志玲','http://image.baidu.com/i?tn=baiduimage&ct=201326592&cl=2&pv=&lm=-1&word=林志玲',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1265,92,'性感美女','http://image.baidu.com/i?tn=baiduimage&ct=201326592&cl=2&pv=&lm=-1&word=%D0%D4%B8%D0%C3%C0%C5%AE',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1266,88,'换子疑云','http://video.baidu.com/v?word=换子疑云&ct=301989888&rn=20&pn=0&db=0&s=0&ty=10',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1268,95,'卡通市长','http://www.baidu.com/s?tn=uc_1_pg&wd=卡通市长',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1270,93,'说好的幸福呢','http://mp3.baidu.com/m?tn=6885_pg&tn=6885_pg&f=ms&ct=134217728&word=%CB%B5%BA%C3%B5%C4%D0%D2%B8%A3%C4%D8',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1271,93,'等一分钟','http://mp3.baidu.com/m?tn=6885_pg&tn=6885_pg&f=ms&ct=134217728&word=%B5%C8%D2%BB%B7%D6%D6%D3',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1272,93,'边做边爱','http://mp3.baidu.com/m?tn=6885_pg&tn=6885_pg&f=ms&ct=134217728&word=%B1%DF%D7%F6%B1%DF%B0%AE',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1290,98,'17173-炫舞专区','http://x5.17173.com/',3,0,0,0,0,699,0,0,0,0,0,'',0,''),(1293,99,'赤壁官方网站','http://chibi.wanmei.com/main.htm',1,0,0,0,0,1538,0,0,0,0,0,'',0,''),(1326,63,'睡觉减肥法','http://www.bobodd.com/loss/index.asp?link=10047',4,0,0,0,0,6,0,0,0,1238515200,1238515200,'',0,''),(1294,99,'赤壁客户端下载','http://chibi.wanmei.com/',2,0,0,0,0,462,0,0,0,0,0,'',0,''),(1288,98,'qq炫舞官方站','http://x5.qq.com/index.shtml',1,0,0,0,0,2524,0,0,0,0,0,'',0,''),(1279,96,'在线汉字编码查询','http://bm.kdd.cc/',6,0,0,0,0,172,0,0,0,0,0,'',0,''),(1343,53,'面具玛丽奥','http://www.game.com.cn/games/7/2/mariomask.html',14,0,0,0,0,0,0,0,0,0,0,'',0,''),(1340,48,'极品飞车flash版','http://www.game.com.cn/games/3/5/jpfc.html',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1344,53,'玛里奥赛车','http://www.game.com.cn/games/7/2/mariomask.html',15,0,0,0,0,0,0,0,0,0,0,'',0,''),(1338,54,'帝国时代真理之剑2','http://www.game.com.cn/games/8/2/zhenlizhijian2.html',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1339,52,'实况足球flash版','http://www.game.com.cn/games/1/1/champions%20field.html',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1337,49,'暗黑破坏神flash版','http://www.game.com.cn//games/2/0/mahphs.html',8,0,0,0,0,0,0,0,0,0,0,'',0,''),(1341,59,'仙剑奇侠传Flash版','http://www.game.com.cn/games/7/2/mxjqxz.html',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1342,53,'超级玛丽小游戏','http://www.game.com.cn/games/3/1/mariominids.html',13,0,0,0,0,1,0,0,0,0,0,'',0,''),(1336,22,'红色警戒flash版','http://www.game.com.cn/games/7/8/redalter.html',12,0,0,0,0,0,0,0,0,0,0,'',0,''),(1301,100,'腾讯-魔域专题','http://games.qq.com/z/moyu/',4,0,0,0,0,218,0,0,0,0,0,'',0,''),(1286,97,'会打字就能弹钢琴','http://tool.114la.com/piano.html',2,0,0,0,0,3005,0,0,0,0,0,'',0,''),(1298,100,'魔域官网','http://my.91.com/index/',1,0,0,0,0,2325,0,0,0,0,0,'',0,''),(1295,99,'太平洋赤壁专题','http://wangyou.pcgames.com.cn/zhuanti/wmchibi/',3,0,0,0,0,71,0,0,0,0,0,'',0,''),(1289,98,'客户端下载','http://x5.qq.com/',2,0,0,0,0,2261,0,0,0,0,0,'',0,''),(1274,96,'在线汉字注音工具','http://py.kdd.cc/',5,0,0,0,0,199,0,0,0,0,0,'',0,''),(1275,96,'在线成语词典','http://cy.kdd.cc/',3,0,0,0,0,551,0,0,0,0,0,'',0,''),(1276,96,'在线书法字典','http://sf.kdd.cc/',1,0,0,0,0,775,0,0,0,0,0,'',0,''),(1277,96,'在线藏头诗生成器','http://ct.kdd.cc/',2,0,0,0,0,839,0,0,0,0,0,'',0,''),(1322,67,'暮色','http://video.baidu.com/v?word=暮色&ct=301989888&rn=20&pn=0&db=0&s=0&ty=10',100,0,0,0,0,362,0,0,0,0,0,'',0,''),(1335,26,'魔兽争霸flash版','http://www.game.com.cn/games/0/9/moshouflash.html',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1291,98,'52PK炫舞专区','http://games.52pk.com/x5/',4,0,0,0,0,323,0,0,0,0,0,'',0,''),(1320,36,'邮箱','http://mail.163.com/',11,0,0,0,1048,69404,0,22,95,0,0,'',0,''),(1364,68,'产褥期抑郁症','http://bk.baidu.com/w?word=产褥期抑郁症&tn=baiduWikiSearch&ct=17&lm=0',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1292,98,'太平洋炫舞专区','http://wangyou.pcgames.com.cn/zhuanti/qqx5/',5,0,0,0,0,192,0,0,0,0,0,'',0,''),(1300,100,'魔域专题-17173','http://moyu.17173.com/',3,0,0,0,0,249,0,0,0,0,0,'',0,''),(1310,22,'红色警戒III属性修改器','http://www.xiazaiba.com/downinfo/1070.html',11,0,0,0,0,1475,0,0,0,0,0,'',0,''),(1327,94,'绿坝·花季护航','http://www.baidu.com/s?tn=6885_pg&wd=绿坝·花季护航',3,0,0,0,0,0,0,0,0,0,0,'',0,''),(1333,101,'永恒之塔-17173','http://aion.17173.com/',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1329,101,'永恒之塔客户端下载','http://aion.sdo.com/web1/guide/index.html',2,0,0,0,0,3,0,0,0,0,0,'',0,''),(1330,101,'永恒之塔官网','http://aion.sdo.com/ ',1,0,0,0,0,0,0,0,0,0,0,'',0,''),(1331,101,'永恒之塔-新浪专题','http://games.sina.com.cn/aion/',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1332,101,'多玩-Aion永恒之塔','http://aion.duowan.com/',100,0,0,0,0,1,0,0,0,0,0,'',0,''),(1359,63,'爱墙','http://holiday.114la.com/valentine/',6,0,0,0,0,0,0,0,0,1235836800,1235836800,'',0,''),(1423,63,'北川副部长自缢','http://www.baidu.com/s?tn=haokan123&wd=北川副部长自缢',5,0,0,0,0,0,0,0,0,0,0,'',0,''),(1354,95,'北川老县城解禁','http://www.baidu.com/s?wd=北川老县城解禁&tn=haokan123',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1351,1,'电话号码查询网','http://www.114best.com',23,0,0,0,0,0,0,0,0,0,0,'',0,''),(1363,67,'游龙戏凤','http://video.baidu.com/v?word=游龙戏凤&ct=301989888&rn=20&pn=0&db=0&s=0&ty=10',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1421,94,'国足惨败','http://www.baidu.com/s?tn=6885_pg&wd=国足惨败',4,0,0,0,0,0,0,0,0,1243785600,1243785600,'',0,''),(1365,41,'3D麻将连连看','http://www.4399.com/flash/4467.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1357,73,'经批准方可怀孕','http://www.baidu.com/s?tn=haokan123&wd=经批准方可怀孕',4,0,0,0,0,0,0,0,0,0,0,'',0,''),(1366,41,'麻将塔','http://www.4399.com/flash/10237.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1367,41,'无敌连连看','http://www.4399.com/flash/7828.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1368,41,'道具连连看','http://www.4399.com/flash/7771.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1369,41,'卡通连连看','http://www.4399.com/flash/4416.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1370,41,'巧克力连连看','http://www.4399.com/flash/8956.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1373,53,'小超级玛丽','http://www.4399.com/flash/8920.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1374,53,'超级小鸡','http://www.4399.com/flash/8764.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1375,53,'超级玛丽完美版','http://www.4399.com/flash/8762.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1376,53,'超级玛里奥','http://www.4399.com/flash/1651.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1377,53,'玛丽之限时取水','http://www.4399.com/flash/4794.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1378,53,'格斗马里奥','http://www.4399.com/flash/9739.htm',100,0,0,0,0,1,0,0,0,0,0,'',0,''),(1379,53,'精美超级玛里奥','http://www.4399.com/flash/3822.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1380,51,'太阳神祖玛登陆','http://www.4399.com/flash/2087.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1381,51,'达达祖玛','http://www.4399.com/flash/9144.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1382,51,'祖玛泡泡龙','http://www.4399.com/flash/8833.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1383,51,'埃及祖玛 ','http://www.xiazaiba.com/html/844.html',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1384,51,'马戏团祖玛','http://www.4399.com/flash/8063.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1385,51,'另类祖玛','http://www.4399.com/flash/7089.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1386,51,'盘蛇祖玛','http://www.4399.com/flash/3791.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1387,51,'PP泡泡龙','http://www.4399.com/flash/1937.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1388,51,'宝石泡泡龙','http://www.4399.com/flash/2966.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1389,51,'百合泡泡龙','http://www.4399.com/flash/8260.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1390,51,'九头怪泡泡龙','http://www.4399.com/flash/5029.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1391,46,'给客人做饭','http://www.4399.com/flash/6354.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1392,46,'经营大排挡','http://www.4399.com/flash/3605.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1393,46,'家里做烤肉','http://www.4399.com/flash/5870.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1394,46,'开家茶餐厅','http://www.4399.com/flash/1639.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1395,46,'日本寿司料理','http://www.4399.com/flash/9128.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1396,46,'学做火锅料理','http://www.4399.com/flash/8980.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1397,46,'夹肉卷饼店','http://www.4399.com/flash/9137.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1398,46,'烧烤王子','http://www.4399.com/flash/9136.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1399,46,'美味鲜鱼寿司','http://www.4399.com/flash/8984.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1400,46,'食神小当家','http://www.4399.com/flash/8522.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1401,46,'SUE做韩国料理','http://www.4399.com/flash/9712.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1402,46,'挑战美味烧烤','http://www.4399.com/flash/4573.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1403,46,'Panny汉堡店','http://www.4399.com/flash/5881.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1405,45,'可爱树精灵','http://www.4399.com/flash/3958.htm',100,0,0,0,0,1,0,0,0,0,0,'',0,''),(1406,45,'海洋公主妮娜','http://www.4399.com/flash/9509.htm',100,0,0,0,0,1,0,0,0,0,0,'',0,''),(1407,45,'情定大饭店','http://www.4399.com/flash/4258.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1408,45,'动感美少女','http://www.4399.com/flash/9677.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1409,45,'幸福婚礼','http://www.4399.com/flash/9656.htm',100,0,0,0,0,2,0,0,0,0,0,'',0,''),(1410,45,'蓝色妖姬','http://www.4399.com/flash/7941.htm',100,0,0,0,0,1,0,0,0,0,0,'',0,''),(1411,45,'秋季时尚装','http://www.4399.com/flash/8090.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1412,45,'学校小情侣','http://www.4399.com/flash/10168.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1413,45,'帮大头妹赢王国','http://www.4399.com/flash/10028.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1414,45,'女海盗换装','http://www.4399.com/flash/9996.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1415,45,'阿SUE去约会','http://www.4399.com/flash/9688.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1416,45,'清纯学生妹','http://www.4399.com/flash/9482.htm',100,0,0,0,0,1,0,0,0,0,0,'',0,''),(1417,45,'DIY彩甲坊','http://www.4399.com/flash/9195.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1418,45,'天使之翼','http://www.4399.com/flash/9034.htm',100,0,0,0,0,1,0,0,0,0,0,'',0,''),(1419,45,'美丽心情','http://www.4399.com/flash/8646.htm',100,0,0,0,0,1,0,0,0,0,0,'',0,''),(1420,45,'夏夜精灵','http://www.4399.com/flash/8650.htm',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(1426,94,'热卖商城','http://goldlink.all4ad.cn/TaoBaoJump.aspx?uid=25828&lid=140',0,0,0,0,0,0,0,0,0,0,0,'',0,''),(1425,4,'迅雷地址转换器','http://tool.114la.com/urlconvert.html',29,0,0,0,0,0,0,0,0,0,0,'',0,''),(2855,10,'实时汇率转换','http://115.com/s?q=100美元',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(2858,9,'115聚合搜索','http://115.com',2,0,0,0,0,0,0,0,0,0,0,'',0,''),(2850,10,'快递智能查询','http://115.com/s?q=快递',1,0,0,0,0,0,0,0,0,0,0,'',0,''),(1430,102,'澳门大学','http://www.umac.mo/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1431,102,'澳门日报','http://www.macaodaily.com/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1432,102,'澳门城市指南','http://gb.cityguide.gov.mo/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1433,102,'澳门气象','http://www.smg.gov.mo/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1434,102,'澳门华侨报','http://www.vakiodaily.com/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1435,102,'澳门互联','http://www.qoos.com/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1436,102,'澳门旅游网','http://www.macautvl.com/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1437,102,'澳门航空','http://www.airmacau.com.mo/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1438,102,'澳门中国旅行社','http://www.ctsmacau.com/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1439,102,'澳门街资讯网','http://www.macaustreet.com/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1440,102,'澳门卫星地图','http://maps.google.com/maps?f=q&hl=zh-CN&q=macau&ie=UTF8&ll=22.198849,113.544044&spn=0.215519,0.42057&t=h&om=1',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1441,102,'澳门理工学院','http://www.ipm.edu.mo/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1442,102,'澳门科技大学','http://www.must.edu.mo/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1443,102,'亚洲国际公开大学','http://www.aiou.edu/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1444,102,'澳门中央图书馆','http://www.library.gov.mo/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1445,102,'澳门特别行政区政府','http://www.gov.mo/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1446,102,'澳门文化中心','http://www.ccm.gov.mo/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1447,102,'澳门海关','http://www.customs.gov.mo/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1448,102,'澳门法务局','http://www.dsaj.gov.mo/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1449,102,'澳门卫生局','http://www.ssm.gov.mo/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1450,102,'澳门国际银行','http://www.lusobank.com.mo/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1451,102,'澳门黄页','http://www.yp.com.mo/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1452,102,'澳门彩票公司','http://www.macauslot.com/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1453,102,'澳门赛马会','http://www.macauhorse.com/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1454,102,'极动感','http://www.cyberctm.com/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(1481,2,'车辆违章查询','http://www.bjjtgl.gov.cn/',100,1,0,0,0,0,0,0,0,0,0,'',0,''),(2861,4,'IP地址查询 ','http://tool.115.com/?ct=live&ac=ip',100,0,0,0,0,0,0,0,0,0,0,'',0,''),(2863,1,'天气预报查询','http://tool.115.com/?ct=live&ac=weather',2,0,0,0,0,0,0,0,0,0,0,'',0,''),(2853,10,'手机归属','http://115.com/s?q=13800138000',5,0,0,0,0,0,0,0,0,0,0,'',0,''),(2852,10,'成语解释','http://115.com/s?q=天下无双',3,0,0,0,0,0,0,0,0,0,0,'',0,''),(2851,10,'明天天气','http://115.com/s?q=明天天气',2,0,0,0,0,0,0,0,0,0,0,'',0,''),(2857,9,'风雨同行 众木成林','http://www.ylmf.com/',1,0,0,0,0,0,0,0,0,0,0,'测试用',0,''),(2859,9,'免费网盘','http://u.115.com',3,0,0,0,0,0,0,0,0,0,0,'',0,''),(2860,9,'114啦开源','http://www.114la.com/114la/',4,0,0,0,0,0,0,0,0,0,0,'',0,'');

/*Table structure for table `uchome_toolclass` */

DROP TABLE IF EXISTS `uchome_toolclass`;

CREATE TABLE `uchome_toolclass` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `displayorder` int(11) NOT NULL default '100',
  `type` varchar(50) NOT NULL default '',
  `inindex` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=102 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_toolclass` */

insert  into `uchome_toolclass`(`id`,`name`,`displayorder`,`type`,`inindex`) values (1,'日常生活工具',0,'tool',0),(2,'交通旅游工具',2,'tool',0),(3,'商业经济工具',3,'tool',0),(4,'电脑网络工具',4,'tool',0),(5,'学习应用工具',6,'tool',0),(8,'计算器工具',8,'tool',0),(9,'网页1',100,'keyword',0),(10,'115聚搜',100,'keyword',0),(11,'魔兽世界',1,'game',1),(13,'泡泡堂',14,'game',0),(14,'街头篮球',15,'game',1),(15,'梦幻西游',4,'game',1),(16,'跑跑卡丁车',11,'game',1),(17,'热血传奇',22,'game',1),(18,'劲舞团',10,'game',1),(19,'QQ幻想',16,'game',1),(20,'热血江湖',9,'game',1),(21,'征途',23,'game',1),(22,'红色警戒',2,'game1',1),(23,'惊天动地',25,'game',1),(24,'浩方对战平台',19,'game',1),(25,'反恐精英CS',13,'game',1),(26,'魔兽争霸',1,'game1',1),(27,'《问道》',7,'game',1),(28,'MP3',100,'keyword',0),(29,'图片',100,'keyword',0),(30,'贴吧',100,'keyword',0),(31,'知道',100,'keyword',0),(32,'百科',100,'keyword',0),(33,'影视',100,'keyword',0),(36,'mztop',100,'mztop',0),(44,'休闲小游戏',15,'game1',1),(39,'天龙八部',2,'game',1),(40,'武林外传',24,'game',1),(41,'连连看',10,'game1',1),(42,'《诛仙》',5,'game',1),(43,'冒险岛',31,'game',1),(45,'化妆游戏',14,'game1',1),(46,'做饭游戏',13,'game1',1),(47,'PSP掌机',9,'game1',1),(48,'极品飞车',6,'game1',1),(49,'暗黑破坏神II',3,'game1',1),(50,'侠盗飞车',8,'game1',1),(51,'祖玛/泡泡龙',12,'game1',1),(52,'足球 FIFA',5,'game1',1),(53,'超级玛丽',11,'game1',1),(54,'帝国时代',4,'game1',1),(58,'功夫小子',26,'game',0),(59,'仙剑奇侠传',7,'game1',0),(60,'斗地主',100,'game1',0),(62,'其它游戏',100,'game1',0),(74,'千年',27,'game',0),(78,'地下城与勇士',3,'game',1),(79,'热血三国',18,'game',1),(80,'寻仙',21,'game',1),(81,'穿越火线',8,'game',1),(82,'DOTA',17,'game',1),(83,'传奇外传',6,'game',1),(84,'剑侠世界',20,'game',1),(96,'语言文字工具',7,'tool',0),(97,'其他工具',12,'tool',0),(98,'QQ炫舞',28,'game',0),(99,'赤壁',29,'game',0),(100,'魔域',30,'game',0),(101,'Aion永恒之塔',12,'game',1);

/*Table structure for table `uchome_topic` */

DROP TABLE IF EXISTS `uchome_topic`;

CREATE TABLE `uchome_topic` (
  `topicid` mediumint(8) unsigned NOT NULL auto_increment,
  `uid` mediumint(8) unsigned NOT NULL default '0',
  `username` varchar(15) NOT NULL default '',
  `subject` varchar(80) NOT NULL default '',
  `message` mediumtext NOT NULL,
  `jointype` varchar(255) NOT NULL default '',
  `joingid` varchar(255) NOT NULL default '',
  `pic` varchar(100) NOT NULL default '',
  `thumb` tinyint(1) NOT NULL default '0',
  `remote` tinyint(1) NOT NULL default '0',
  `joinnum` mediumint(8) unsigned NOT NULL default '0',






