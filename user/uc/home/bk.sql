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

insert  into `uchome_adminsession`(`uid`,`ip`,`dateline`,`errorcount`) values (10,'192.168.115.1',1284102951,-1);

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

insert  into `uchome_blog`(`blogid`,`topicid`,`uid`,`username`,`subject`,`classid`,`viewnum`,`replynum`,`hot`,`dateline`,`pic`,`picflag`,`noreply`,`friend`,`password`,`click_1`,`click_2`,`click_3`,`click_4`,`click_5`) values (1,0,1,'admin','hello,world 1',0,0,0,0,1256548231,'',0,0,0,'',0,0,0,0,0),(2,0,1,'admin','如果在窗体关闭前自行判断是否可关闭',1,0,0,0,1256978318,'',0,0,0,'',0,0,0,0,0),(3,0,1,'admin','Qt中提高sqlite的读写速度',0,0,0,0,1257130283,'',0,0,0,'',0,0,0,0,0),(4,0,1,'admin','C语言运行符优先级',0,0,0,0,1257404965,'',0,0,0,'',0,0,0,0,0),(5,0,1,'admin','SO_LINGER的作用',2,0,0,0,1258082657,'',0,0,0,'',0,0,0,0,0),(6,0,1,'admin','什么是delayed ack algorithm',2,1,0,0,1258101276,'',0,0,0,'',0,0,0,0,0),(7,0,1,'admin','stevens的sock程序帮助',2,1,0,0,1258169040,'',0,0,0,'',0,0,0,0,0),(8,0,1,'admin','拥塞窗口  通告窗口',2,2,0,0,1258169251,'',0,0,0,'',0,0,0,0,0),(9,0,1,'admin','upnp 增加一条rule',0,1,0,0,1258187682,'',0,0,0,'',0,0,0,0,0),(10,0,1,'admin','objdump 看kernel',0,4,0,0,1258330909,'',0,0,0,'',0,0,0,0,0),(11,0,1,'admin','深入浅出MIPS 二 MIPS的内存映射',3,1,0,0,1258331543,'',0,0,0,'',0,0,0,0,0),(12,0,1,'admin','配置igmp',4,2,0,0,1258875457,'',0,0,0,'',0,0,0,0,0),(13,0,3,'lele','osk中的interface',0,0,0,0,1262551749,'',0,0,0,'',0,0,0,0,0),(14,0,4,'osk','低电平有效',5,0,0,0,1262971990,'',0,0,1,'',0,0,0,0,0),(15,0,4,'osk','volatile的用法',6,0,0,0,1263058864,'',0,0,1,'',0,0,0,0,0),(16,0,1,'admin','MIPS汇编小贴示',3,1,0,0,1263071300,'',0,0,0,'',0,0,0,0,0),(17,0,1,'admin','mips set flag',3,0,0,0,1263074442,'',0,0,0,'',0,0,0,0,0),(18,0,1,'admin','ppp 获取IP',0,0,0,50,1263497380,'',0,0,2,'',0,0,0,0,0),(19,0,4,'osk','ccb',0,0,0,0,1264175119,'',0,0,0,'',0,0,0,0,0),(20,0,4,'osk','实验机房port对应关系',5,0,0,0,1264272367,'',0,0,0,'',0,0,0,0,0),(21,0,4,'osk','0315 register',0,1,0,0,1264323511,'',0,0,0,'',0,0,0,0,0),(22,0,4,'osk','内联汇编代表',0,0,0,0,1264679950,'',0,0,0,'',0,0,0,0,0),(23,0,3,'lele','Linux 上下文切换分析笔记 (MIPS)',0,2,0,0,1264693925,'',0,0,0,'',0,0,0,0,0),(24,0,3,'lele','用户栈开始内容',0,3,1,1,1264752700,'',0,0,0,'',0,0,0,0,0),(25,0,1,'admin','dsp 参数',0,1,0,0,1265191056,'',0,0,0,'',0,0,0,0,0),(26,0,1,'admin','osk svn',0,0,0,0,1265191095,'',0,0,0,'',0,0,0,0,0),(27,0,1,'admin','uclinux中修改sys clock',0,0,0,0,1265291035,'',0,0,0,'',0,0,0,0,0),(28,0,1,'admin','TCP ACK',2,0,0,0,1265291720,'',0,0,0,'',0,0,0,0,0),(29,0,1,'admin','sock记录',7,0,0,0,1265292397,'',0,0,0,'',0,0,0,0,0),(30,0,1,'admin','fiber mode',8,0,0,0,1265303632,'',0,0,0,'',0,0,0,0,0),(31,0,1,'admin','计算checksum',2,1,0,0,1265468994,'',0,0,0,'',0,0,0,0,0),(32,0,1,'admin','正则表达式的修饰符',9,1,0,0,1266218960,'',0,0,0,'',0,0,0,0,0),(33,0,1,'admin','csope',10,0,0,0,1266507335,'',0,0,0,'',0,0,0,0,0),(34,0,1,'admin','/\\~!@#$%^&amp;*()_+|&lt;&gt;?:&quot;;;\'',1,0,0,0,1266886618,'',0,0,0,'',0,0,0,0,0),(35,0,1,'admin','jquery常用方法',11,0,0,0,1267115630,'http://images.cnblogs.com/OutliningIndicators/ContractedBlock.gif',0,0,0,'',0,0,0,0,0),(36,0,1,'admin','jQuery使用大全',11,0,0,0,1267115739,'http://www.cnblogs.com/Images/OutliningIndicators/None.gif',0,0,0,'',0,0,0,0,0),(37,0,1,'admin','测试图片',0,0,0,0,1267626956,'attachment/201003/3/1_1267626956toRT.gif',0,0,0,'',0,0,0,0,0);

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

insert  into `uchome_blogfield`(`blogid`,`uid`,`tag`,`message`,`postip`,`related`,`relatedtime`,`target_ids`,`hotuser`,`magiccolor`,`magicpaper`,`magiccall`) values (1,1,'a:2:{i:1;s:5:\"hello\";i:2;s:5:\"world\";}','<DIV>hello,world 1 for test</DIV>','192.168.115.1','a:0:{}',1264939994,'','',0,0,0),(2,1,'','１、如果在窗体关闭前自行判断是否可关闭<BR>答：重新实现这个窗体的closeEvent()函数，加入判断操作<BR>\r\n<H6 class=quote>Quote:</H6>\r\n<BLOCKQUOTE><BR>void MainWindow::closeEvent(QCloseEvent *event)<BR>{<BR>&nbsp; &nbsp; &nbsp; if (maybeSave())<BR>&nbsp; &nbsp; &nbsp; {<BR>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; writeSettings();<BR>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <SPAN style=\"COLOR: blue\">event-&gt;accept();</SPAN><BR>&nbsp; &nbsp; &nbsp; }<BR>&nbsp; &nbsp; &nbsp; else<BR>&nbsp; &nbsp; &nbsp; {<BR>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <SPAN style=\"COLOR: blue\">event-&gt;ignore();</SPAN><BR>&nbsp; &nbsp; &nbsp; }<BR>}<BR></BLOCKQUOTE>\r\n','192.168.115.1','',0,'','',0,0,0),(3,1,'a:2:{i:3;s:6:\"sqlite\";i:4;s:6:\"速度\";}','<DIV>\r\n<DIV class=tit>&nbsp;</DIV>\r\n<TABLE style=\"TABLE-LAYOUT: fixed; WIDTH: 100%\">\r\n<TBODY>\r\n<TR>\r\n<TD>\r\n<DIV class=cnt id=blog_text>\r\n<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SQLite数据库本质上来讲就是一个磁盘上的文件，所以一切的数据库操作其实都会转化为对文件的操作，而频繁的文件操作将会是一个很好时的过程，会极大地影响数据库存取的速度。例如：向数据库中插入100万条数据，在默认的情况下如果仅仅是执行query.exec(\"insert into DataBase(......) values(......)\");就会打开和关闭文件100万次，所以速度当然会很慢。SQLite数据库是支持事务操作的，于是我们就可以通过事务来提高数据库的读写速度。事务的基本原理是：数据库管理系统首先会把要执行的sql语句存储到内存当中，只有当commit()的时候才一次性全部执行所有内存中的数据库。下面是一个简单的QT sqlite数据库事务的例子：</P>\r\n<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #include &lt;QtCore/QCoreApplication&gt;<BR>#include &lt;QtSql&gt;<BR>#include &lt;iostream&gt;</P>\r\n<P>using namespace std;</P>\r\n<P>int main(int argc, char *argv[])<BR>{<BR>QCoreApplication a(argc, argv);</P>\r\n<P>QSqlDatabase&nbsp;&nbsp;&nbsp; db_sqlite = QSqlDatabase::addDatabase(\"QSQLITE\", \"connSQLite\");<BR>db_sqlite.setDatabaseName(\"SQLiteDB.db3\");<BR>db_sqlite.open();</P>\r\n<P>QSqlQuery&nbsp;&nbsp; query(\"\", db_sqlite);<BR>bool&nbsp;&nbsp;&nbsp; bsuccess = false;<BR>QTime&nbsp;&nbsp;&nbsp; tmpTime;</P>\r\n<P>// 开始启动事务<BR><FONT color=#0000ff>db_sqlite.transaction();</FONT><BR>tmpTime.start();<BR>for(int i = 0; i&lt;100000; i++)<BR>{<BR>&nbsp;&nbsp; bsuccess = query.exec(\"insert into DataBase(D_1,D_2,D_3,D_4,D_5) values(\'TT\',\'TT\',\'TT\',\'TT\',\'TT\')\");<BR>&nbsp;&nbsp; if (!bsuccess)<BR>&nbsp;&nbsp; {<BR>&nbsp;&nbsp;&nbsp; cout&lt;&lt;\"Error occur\"&lt;&lt;endl;<BR>&nbsp;&nbsp;&nbsp; break;<BR>&nbsp;&nbsp; }<BR>&nbsp;&nbsp;<BR>}</P>\r\n<P>// 提交事务，这个时候才是真正打开文件执行SQL语句的时候<BR><FONT color=#0000ff>db_sqlite.commit();</FONT> <BR>cout&lt;&lt;\"10000条数据耗时：\"&lt;&lt;tmpTime.elapsed()&lt;&lt;\"ms\"&lt;&lt;endl;</P>\r\n<P>}</P>\r\n<P>其实QT 操作sqlite数据库增加事务的功能就是上面例子中蓝色字体标出的两句话，如果去掉这两句话，程序又会还原为：打开文件——执行query.exec(...)——关闭文件。大家可以试一下，添加这两句即增加事务以后数据插入的速度明显提高很多。</P>\r\n<P></P>\r\n<P class=MsoNormal style=\"MARGIN: 0cm 0cm 0pt; TEXT-INDENT: 21pt\"><SPAN>在入库和更新过程中按照数据库事务的思想进行设计：</SPAN><SPAN><FONT face=\"Times New Roman\">SQLite</FONT></SPAN><SPAN>执行入库、更新操作的方式是，</SPAN><SPAN><FONT face=\"Times New Roman\">sql</FONT></SPAN><SPAN>语句执行对象句柄调用库函数打开文件、调用函数执行</SPAN><SPAN><FONT face=\"Times New Roman\">sql</FONT></SPAN><SPAN>语句、关闭文件。这样的执行方式对于数量级别超大的文件的弊端就是每次执行</SPAN><SPAN><FONT face=\"Times New Roman\">sql</FONT></SPAN><SPAN>语句的时候都要打开文件（假设百万级数量级的数据，就要打开和关闭文件百万次），对于数据库的入库和更新操作时间主要都浪费到了文件的打开和关闭操作上，所以这里增加事务以解决该问题</SPAN></P></DIV></TD></TR></TBODY></TABLE></DIV>','192.168.115.1','a:0:{}',1257130284,'','',0,0,0),(4,1,'','<DIV>&nbsp;&nbsp;++(后缀) --(后缀) ( )(调用函数) [] {} (组合文字) . -&gt;&nbsp;从左到右<BR>&nbsp;&nbsp;++(前缀) --(前缀) -+～！ sizeof * (取值) &amp;（地址） (type) (都是一元运算)&nbsp;从右到左<BR>&nbsp;&nbsp;(type name)&nbsp;从右到左<BR>&nbsp;&nbsp;* / %&nbsp;从左到右<BR>&nbsp;&nbsp;+ -(二者都是二元运算)&nbsp;从左到右<BR>&nbsp;&nbsp;&lt;&lt; &gt;&gt;&nbsp;从左到右<BR>&nbsp;&nbsp;&lt; &gt; &lt;= &gt;=&nbsp;从左到右<BR>&nbsp;&nbsp;== !=&nbsp;从左到右<BR>&nbsp;&nbsp;&amp;&nbsp;从左到右<BR>&nbsp;&nbsp;^&nbsp;从左到右<BR>&nbsp;&nbsp;|&nbsp;从左到右<BR>&nbsp;&nbsp;&amp;&amp;&nbsp;从左到右<BR>&nbsp;&nbsp;||&nbsp;从左到右<BR>&nbsp;&nbsp;?:(条件表达式)&nbsp;从右到左<BR>&nbsp;&nbsp;= *= /= %= += -= &lt;&lt;= &gt;&gt;= &amp;= |= ^=&nbsp;从右到左<BR>&nbsp;&nbsp;,(逗号运算符)&nbsp;从左到右</DIV>','192.168.115.1','',0,'','',0,0,0),(5,1,'a:2:{i:5;s:6:\"LINGER\";i:6;s:3:\"tcp\";}','<DIV>\r\n<P class=MsoPlainText style=\"MARGIN: 0cm 0cm 0pt\"><SPAN><FONT face=宋体 color=#0000ff>SO_LINGER</FONT></SPAN></P>\r\n<P class=MsoPlainText style=\"MARGIN: 0cm 0cm 0pt\"><FONT face=宋体><FONT color=#0000ff><SPAN><SPAN style=\"mso-spacerun: yes\">&nbsp;&nbsp; </SPAN></SPAN>此选项指定函数<SPAN>close</SPAN>对面向连接的协议如何操作（如<SPAN>TCP</SPAN>）。缺省<SPAN>close</SPAN>操作是立即返回，如果有数据残留在套接口缓冲区中则系统将试着将这些数据发送给对方。</FONT></FONT></P>\r\n<P class=MsoPlainText style=\"MARGIN: 0cm 0cm 0pt\"></P>\r\n<P class=MsoPlainText style=\"MARGIN: 0cm 0cm 0pt\"><FONT face=宋体><FONT color=#0000ff><SPAN>SO_LINGER</SPAN>选项用来改变此缺省设置。使用如下结构：</FONT></FONT></P>\r\n<P class=MsoPlainText style=\"MARGIN: 0cm 0cm 0pt\"><SPAN><FONT face=宋体 color=#0000ff>struct linger {</FONT></SPAN></P>\r\n<P class=MsoPlainText style=\"MARGIN: 0cm 0cm 0pt\"><SPAN><FONT face=宋体><FONT color=#0000ff><SPAN style=\"mso-spacerun: yes\">&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>int l_onoff; /* 0 = off, nozero = on */</FONT></FONT></SPAN></P>\r\n<P class=MsoPlainText style=\"MARGIN: 0cm 0cm 0pt\"><SPAN><FONT face=宋体><FONT color=#0000ff><SPAN style=\"mso-spacerun: yes\">&nbsp;&nbsp;&nbsp;&nbsp; </SPAN>int l_linger; /* linger time */</FONT></FONT></SPAN></P>\r\n<P class=MsoPlainText style=\"MARGIN: 0cm 0cm 0pt\"><SPAN><FONT face=宋体 color=#0000ff>};</FONT></SPAN></P>\r\n<P class=MsoPlainText style=\"MARGIN: 0cm 0cm 0pt\"></P>\r\n<P class=MsoPlainText style=\"MARGIN: 0cm 0cm 0pt\"><FONT face=宋体><FONT color=#0000ff>有下列三种情况：</FONT></FONT></P>\r\n<P class=MsoPlainText style=\"MARGIN: 0cm 0cm 0pt\"><FONT face=宋体><FONT color=#0000ff><SPAN>l_onoff</SPAN>为<SPAN>0</SPAN>，则该选项关闭，<SPAN>l_linger</SPAN>的值被忽略，等于缺省情况，<SPAN>close</SPAN>立即返回； </FONT></FONT></P>\r\n<P class=MsoPlainText style=\"MARGIN: 0cm 0cm 0pt\"><FONT face=宋体><FONT color=#0000ff><SPAN>l_onoff</SPAN>为非<SPAN>0</SPAN>，<SPAN>l_linger</SPAN>为<SPAN>0</SPAN>，则套接口关闭时<SPAN>TCP</SPAN>夭折连接，<SPAN>TCP</SPAN>将丢弃保留在套接口发送缓冲区中的任何数据并发送一个<SPAN>RST</SPAN>给对方，而不是通常的四分组终止序列，这避免了<SPAN>TIME_WAIT</SPAN>状态； </FONT></FONT></P>\r\n<P class=MsoPlainText style=\"MARGIN: 0cm 0cm 0pt\"><FONT face=宋体><FONT color=#0000ff><SPAN>l_onoff </SPAN>为非<SPAN>0</SPAN>，<SPAN>l_linger</SPAN>为非<SPAN>0</SPAN>，当套接口关闭时内核将拖延一段时间（由<SPAN>l_linger</SPAN>决定）。如果套接口缓冲区中仍残留数据，进程将处于睡眠状态，直 到（<SPAN>a</SPAN>）所有数据发送完且被对方确认，之后进行正常的终止序列（描述字访问计数为<SPAN>0</SPAN>）或（<SPAN>b</SPAN>）延迟时间到。<FONT color=#800000><SPAN style=\"COLOR: blue\"><FONT color=#800000>此种情况下，应用程序检查<SPAN>close</SPAN>的返回值是非常重要的，如果在数据发送完并被确认前时间到，<SPAN>close</SPAN>将返回<SPAN>EWOULDBLOCK</SPAN>错误且套接口发送缓冲区中的任何数据都丢失</FONT></SPAN>。</FONT><SPAN>close</SPAN>的成功返回仅告诉我们发送的数据（和<SPAN>FIN</SPAN>）已由对方<SPAN>TCP</SPAN>确认，它并不能告诉我们对方应用进程是否已读了数据。如果套接口设为非阻塞的，它将不等待<SPAN>close</SPAN>完 成。 </FONT></FONT></P>\r\n<P class=MsoPlainText style=\"MARGIN: 0cm 0cm 0pt\"></P>\r\n<P class=MsoPlainText style=\"MARGIN: 0cm 0cm 0pt\"><FONT face=宋体><FONT color=#0000ff><SPAN>l_linger</SPAN>的单位依赖于实现，<SPAN>4.4BSD</SPAN>假设其单位是时钟滴答（百分之一秒），但<SPAN>Posix<?XML:NAMESPACE PREFIX = ST1 /><ST1:CHMETCNV unitname=\"g\" sourcevalue=\".1\" hasspace=\"False\" negative=\"False\" numbertype=\"1\" tcsc=\"0\">.1g</ST1:CHMETCNV></SPAN>规定单位为秒。</FONT></FONT></P></DIV>','192.168.115.1','a:0:{}',1258082658,'','',0,0,0),(6,1,'a:3:{i:7;s:9:\"algorithm\";i:8;s:3:\"ack\";i:9;s:7:\"delayed\";}','<DIV>\r\n<H2>&nbsp;</H2>\r\n<DIV class=t_msgfont id=postmessage_3943715>\r\n<DIV id=firstpost><BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; delayed ack algorithm也就是&lt;TCP/IP详解&gt;中所谓的\"经受时延的确认\"(翻译得真饶舌 = =||)。在RFC1122中提到delayed ack<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 的概念：<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \"<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; A host that is receiving a stream of TCP data segments can<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; increase efficiency in both the Internet and the hosts by<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sending fewer than one ACK (acknowledgment) segment per data<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; segment received; this is known as a \"delayed ACK\" [TCP:5].<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \"<BR><BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 我在之前提到过，TCP在收到每一个数据包时，都会发送一个ACK报文给对方，用以告诉对方\"我接收到你刚才发送的数据了\"。并<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 且会在报文的确认号字段中标志希望接收到的数据包。<BR><BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 但是，如你所想，如果为每一个接收到的报文都发送一个ACK报文，那将会增加<SPAN class=t_tag onclick=tagshow(event) href=\"tag.php?name=%CD%F8%C2%E7\">网络</SPAN>的负担。于是，为了<SPAN class=t_tag onclick=tagshow(event) href=\"tag.php?name=%BD%E2%BE%F6\">解决</SPAN>这个问题，delayed<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ack被提出。也就是说，实现了delayed ack的TCP，并不见得会对每一个接收到的数据包发送ACK确认报文。<BR><BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 实际情况是，TCP延迟发送这个ACK。延迟多久？&lt;TCP/IP详解&gt;中说的是200ms，在RFC1122中说的则是500ms。delayed ack有时候<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 还会附加到数据报文段一起发送，如果在延迟时间内有报文段要发送的话，如果没有，那么当延迟时间到时，就单独发送ACK。<BR><BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在另一份文档中，作者讲到delayed ack的好处：<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; a) to avoid the silly window syndrome;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; b) to allow ACKs to piggyback on a reply frame if one is ready to go when the stack decides to do the ACK;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; c) to allow the stack to send one ACK for several frames, if those frames arrive within the delay period.<BR><BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; a) 所谓的糊涂窗口综合症(别人都这样翻译的，似乎有点搞笑:D)<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; b) 将ACK与将要发送的数据报文一起发送<BR></DIV></DIV></DIV>','192.168.115.1','a:0:{}',1258781352,'','',0,0,0),(7,1,'','<DIV>./sock<BR>使用: sock [ options ] &lt;host&gt; &lt;port&gt;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;(for client; default)<BR>&nbsp; &nbsp;&nbsp; &nbsp; sock [ options ] -s [ &lt;IPaddr&gt; ] &lt;port&gt;&nbsp; &nbsp;&nbsp;&nbsp;(for server)<BR>&nbsp; &nbsp;&nbsp; &nbsp; sock [ options ] -i &lt;host&gt; &lt;port&gt;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;(for \"source\" client)<BR>&nbsp; &nbsp;&nbsp; &nbsp; sock [ options ] -i -s [ &lt;IPaddr&gt; ] &lt;port&gt;&nbsp;&nbsp;(for \"sink\" server)<BR>options: -b n 将n绑定为客户的本地端口号(在默认情况下,系统给客户分配一个临时的端口号).<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-c&nbsp;&nbsp;将从标准输入读入的新行字符转换为一个回车符和一个换行符,类似地,当从网络中读数据时,将&lt;回车,换行&gt;序列转换为新行字 符。很多因特网应用需要 NVT ASCII,它使用回车和换行来终止每一行.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-f&nbsp; &nbsp; a.b.c.d.port为一个UDP端点指明远端的IP地址(a.b.c.d)和远端的端口号(port).<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-h&nbsp; &nbsp;实现TCP的半关闭机制,当在标准输入中读到一个文件结束符时并不终止.而是在TCP连接上发送一个半关闭报文,继续从网络中 读报文直到对方关闭连接.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-i&nbsp; &nbsp;源客户或接收器服务器.向网络写数据(默认),或者如果和-s选项一起用,从网络读数据.-n选项可以指明写(或读)的缓存的数目,-w选项可以指明每次写的大小， -r 选项可以指明每次读的大小.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-n n&nbsp;&nbsp;当和-i选项一起使用时,n指明了读或写的缓存的数目.n的默认值是1024.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-p n&nbsp;&nbsp;指明每个读或写之间暂停的秒数.这个选项可以和源客户(-i)或接收器服务器(-is)一起使用作为每次对网络读写时的延迟.参考-P选项,实现在第1次读或写之前暂停.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-q n&nbsp;&nbsp;为TCP服务器指明挂起的连接队列的大小:TCP将为之进行排队的已经接受的连接的数目.默认值是5.<BR><BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-r n&nbsp;&nbsp;和-is选项一起使用,n指明每次从网络中读数据的大小.默认是每次读1024字节.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-s&nbsp; &nbsp; 作为一个服务器启动,而不是一个客户.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-u&nbsp; &nbsp; 使用UDP,而不是TCP.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-v&nbsp; &nbsp; 详细模式.在标准差错上打印附加的细节信息(如客户和服务器的临时端口号)<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-w n&nbsp;&nbsp;和-i选项一起使用,n指明每次从网络中写数据的大小.默认值是每次写1024字节.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-A&nbsp; &nbsp; SO_REUSEADDR接口选项.对于TCP,这个选项允许进程给自己分配一个处于2MSL等待的连接的端口号.对于UDP,这个选项支持多 播,它允许多个进程使用同一个本地端口来接收广播或多播的数据报.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-B&nbsp; &nbsp; SO_BROADCAST接口选项,允许向一个广播IP地址发送UDP数据报.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-C&nbsp; &nbsp; 设置终端为cbreak模式.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-D&nbsp; &nbsp; SO_DEBUG接口选项.这个选项使得内核为这个TCP连接维护另外的调试信息.以后可以运行trpt(8)程序输出这个信息.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-E&nbsp; &nbsp; 如果实现支持,使能IP_RECVDSTADDR接口选项.这个选项用于UDP服务器,用来打印接收到的UDP数据报的目的IP地址.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-F&nbsp; &nbsp; 指明一个并发的TCP服务器.即,服务器使用fork函数为每一个客户连接创建一个新的进程.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-K&nbsp; &nbsp; SO_KEEPALIVE 接口选项<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-L n&nbsp;&nbsp;SO_LINGER 选项把一个TCP端点的拖延时间 (linger time)(SO_LINGER)设置为 n.一个为0的拖延时间意味着当网络连接关闭 时，正在排队等着发送的任何数据都被丢弃，向对方发送一个重置报文.一个正的拖延时间（百分之一秒）是关闭网络连接必须等待的将所有 正在排队等着发送的数据发送完并收到确认的时间。关闭网络连接时，如果这个拖延定时器超时，挂起的数据没有全部发送完并收到确认，关闭操作将返回一个差错信息.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-N&nbsp; &nbsp; 设置TCP_NODELAY接口选项来禁止Nagle算法<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-O n&nbsp;&nbsp;指明一个TCP服务器在接受第一个客户连接之前暂停的秒数.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-P n&nbsp;&nbsp;指明在第一次对网络进行读或写之前暂停的秒数。这个选项可以和接收器服务器(-is)一起使用,完成在接受了客户的连接请 求之后但在执行从网络中第一次读之前的延迟。和接收源(-i)一起使用时,完成连接建立之后但第一次向网络写之前的延迟.参看-p选项,实现 在接下来的每一次读或写之间进行暂停.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-Q n&nbsp;&nbsp;指明当一个TCP客户或服务器收到了另一端发来的一个文件结束符,在它关闭自己这一端的连接之前需要暂停的秒数.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-R n&nbsp;&nbsp;把接口的接收缓存(SO_RCVBUF接口选项)设置为n.这可以直接影响TCP通告的接收窗口的大小.对于UDP,这个选项指明了可以接收的最大的UDP数据报.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-S n&nbsp;&nbsp;把接口的发送缓存(SO_SNDBUF接口选项)设置为n.对于UDP,这个选项指明了可以发送的最大的 UDP数据报.<BR>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;-U n&nbsp;&nbsp;在向网络写了数字n后进入TCP的紧急模式.写一个字节的数据以启动紧急模式.<BR></DIV>','192.168.115.1','',0,'','',0,0,0),(8,1,'a:2:{i:10;s:6:\"窗口\";i:11;s:6:\"拥塞\";}','<P>发送方去拥塞窗口与通告窗口的最小值作为发送上限。拥塞窗口是发送方的使用的流量控制，通告窗口是接收方的流量控制</P>','192.168.115.1','a:0:{}',1265291662,'','',0,0,0),(9,1,'a:2:{i:12;s:4:\"rule\";i:13;s:4:\"upnp\";}','<P>POST /control/WANIPConnection HTTP/1.1</P>\r\n<P>Content-Type: text/xml; charset=\"utf-8\"</P>\r\n<P>SOAPAction: \"urn:schemas-upnp-org:service:WANIPConnection:1#AddPortMapping\"</P>\r\n<P>User-Agent: Mozilla/4.0 (compatible; UPnP/1.0; Windows 9x)</P>\r\n<P>Host: 192.168.1.1:5431</P>\r\n<P>Content-Length: 1112</P>\r\n<P>Connection: Keep-Alive</P>\r\n<P>Cache-Control: no-cache</P>\r\n<P>Pragma: no-cache</P>\r\n<P>&nbsp;</P>\r\n<P>&lt;?xml version=\"1.0\"?&gt;</P>\r\n<P>&lt;SOAP-ENV:Envelope xmlns:SOAP-ENV=\"<A href=\"http://schemas.xmlsoap.org/soap/envelope/\" target=_blank>http://schemas.xmlsoap.org/soap/envelope/</A>\" SOAP-ENV:encodingStyle=\"<A href=\'http://schemas.xmlsoap.org/soap/encoding/\">\'>http://schemas.xmlsoap.org/soap/encoding/\"&gt;</A></P>\r\n<P>&lt;SOAP-ENV:Body&gt;</P>\r\n<P>&lt;m:AddPortMapping xmlns:m=\"urn:schemas-upnp-org:service:WANIPConnection:1\"&gt;</P>\r\n<P>&lt;NewRemoteHost xmlns:dt=\"urn:schemas-microsoft-com:datatypes\" dt:dt=\"string\"&gt;</P>\r\n<P>&lt;/NewRemoteHost&gt;</P>\r\n<P>&lt;NewExternalPort xmlns:dt=\"urn:schemas-microsoft-com:datatypes\" dt:dt=\"ui2\"&gt;21</P>\r\n<P>&lt;/NewExternalPort&gt;</P>\r\n<P>&lt;NewProtocol xmlns:dt=\"urn:schemas-microsoft-com:datatypes\" dt:dt=\"string\"&gt;TCP&lt;/NewProtocol&gt;</P>\r\n<P>&lt;NewInternalPort xmlns:dt=\"urn:schemas-microsoft-com:datatypes\" dt:dt=\"ui2\"&gt;21&lt;/NewInternalPort&gt;</P>\r\n<P>&lt;NewInternalClient xmlns:dt=\"urn:schemas-microsoft-com:datatypes\" dt:dt=\"string\"&gt;192.168.1.115&lt;/NewInternalClient&gt;</P>\r\n<P>&lt;NewEnabled xmlns:dt=\"urn:schemas-microsoft-com:datatypes\" dt:dt=\"boolean\"&gt;1&lt;/NewEnabled&gt;</P>\r\n<P>&lt;NewPortMappingDescription xmlns:dt=\"urn:schemas-microsoft-com:datatypes\" dt:dt=\"string\"&gt;ftp&lt;/NewPortMappingDescription&gt;</P>\r\n<P>&lt;NewLeaseDuration xmlns:dt=\"urn:schemas-microsoft-com:datatypes\" dt:dt=\"ui4\"&gt;0&lt;/NewLeaseDuration&gt;</P>\r\n<P>&lt;/m:AddPortMapping&gt;</P>\r\n<P>&lt;/SOAP-ENV:Body&gt;&lt;/SOAP-ENV:Envelope&gt;</P>\r\n<P>HTTP/1.1 200 OK</P>\r\n<P>Content-Type: text/xml; charset=\"utf-8\"</P>\r\n<P>Connection: close</P>\r\n<P>Content-Length: 298</P>\r\n<P>Server: UPnP/1.0 BLR-TX4S/1.0</P>\r\n<P>Ext:</P>\r\n<P>&nbsp;</P>\r\n<P>&lt;?xml version=\"1.0\"?&gt;<BR>&lt;s:Envelope xmlns:s=\"<A href=\"http://schemas.xmlsoap.org/soap/envelope/\" target=_blank>http://schemas.xmlsoap.org/soap/envelope/</A>\" s:encodingStyle=\"<A href=\'http://schemas.xmlsoap.org/soap/encoding/\"><s:Body\'>http://schemas.xmlsoap.org/soap/encoding/\"&gt;&lt;s:Body</A>&gt;&nbsp;&nbsp;&nbsp; &lt;u:AddPortMappingResponse xmlns:u=\"urn:schemas-upnp-org:service:WANIPConnection:1\"&gt;</P>\r\n<P>&nbsp;&nbsp;&nbsp; &lt;/u:AddPortMappingResponse&gt;</P>\r\n<P>&lt;/s:Body&gt;&lt;/s:Envelope&gt;</P>','192.168.115.1','a:0:{}',1258781351,'','',0,0,0),(10,1,'a:2:{i:14;s:6:\"kernel\";i:15;s:7:\"objdump\";}','1.  修改源代码的顶层  Makefile<BR>      CC =$(CROSSCOM_PILE)gcc            为<BR>      CC =$(CROSSCOM_PILE)gcc   -g<BR>    使成生的vmlinux中含有debug信息<BR>2.  所有生成   .o  的  rule  中再加一条     /*其他参数除了-c外抄生成.o文件用的参数*/<BR>    CC   -E  -dD -C $&lt; &gt; /preprocessing/$(shell pwd)/$&lt;<BR>    生成预处理文件从这个文件里面能很容易找到  c  源文件的宏定义<BR>3.  objdump -h vmlinux   &gt; vmlinux.txt<BR>    显示  linux 内核段信息，如段的开始虚拟地址，段的长度<BR>4.  objdump -S -l -z vmlinux &gt; vmlinux.txt<BR>     反汇编  vmlinux  到vmlinux.txt， vmlinux.txt  含有汇编和  c 源文件的混合代码，看起来很方<BR>     便。而且能一步步看linux怎么一步步运行的。<BR>5.   objdump -S -l -z  -j xxxx(section name)  vmlinux  &gt; vmlinux.txt<BR>    反汇编  linux 内核段 xxxx  到文件  vmlinux.txt  中。<BR>6.   objdump -x vmlinux &gt; x.txt<BR>     vmliux中所有段的头信息，其中包口vmlinux的入口地址等<BR>7.  objdump --debugging vmlinux &gt; debugging.txt<BR>    很多有用的debug信息，如函数名，结构体定义等<BR>    我觉的用根据以上信息，ultraedit看很方便。尤其在vmlinux.txt中选中文件名，<BR>    用ultraedit右键的open能马上打开文件，很方便。<BR>','192.168.115.1','a:0:{}',1261700049,'','',0,0,0),(11,1,'','二 MIPS的内存映射<BR>　　在32位MIPS体系结构下，最多可寻址4GB地址空间。这4GB空间的分配是怎样的呢？让我们看下面这张图：<BR><BR>　　　　　　+----------------------------------------------+<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　| 0xFFFFFFFF<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|<BR>　　　　　　|　Kernel Space Mapped Cached　　　　　　　　　|<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|<BR>0xC0000000 |　　　　　　　　　　　　　　　　　　　　　　　|<BR>　　　　　　+----------------------------------------------+<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　| 0xBFFFFFFF<BR>　　　　　　| Kernel Space Unmapped unCached 　　　　|<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|<BR>0xA0000000 +----------------------------------------------+<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　| 0x9FFFFFFF<BR>　　　　　　| Kernel Space Unmapped cached　　　　|<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|<BR>0x80000000 +----------------------------------------------+<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　| 0x7FFFFFFF<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|<BR>　　　　　　|　　　　User Space　　　　　　　　　　　　　　|<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|<BR>　　　　　　|　　　　　　　　　　　　　　　　　　　　　　　|<BR>0x00000000 +----------------------------------------------+<BR><BR>Figure 2-1 MIPS Logical Addressing Space<BR><BR>　　上图是MIPS处理器的逻辑寻址空间分布图。我们看到，2GB以下的地址空间，也就是从0x00000000到0x7FFFFFFF的这一段空间，为User Space，可以在User Mode下访问，当然，在Kernel Mode下也是可以访问的。程序在访问User Space的内存时，会通过MMU的TLB，映射到实际的物理地址上。也就是说，这一段逻辑地址空间和物理地址空间的对应关系，是由MMU中的TLB表项决定的。<BR>　　从0x80000000到0xFFFFFFFF的一段为Kernel Space，仅限于Kernel Mode访问。如果在User Mode下试图访问这一段内存，将会引发系统的一个Exception。MIPS的　　Kernel Space又可以划分为三部分。首先是通过MMU映射到物理地址的1GB空间，地址范围从0xC0000000到0xFFFFFFFF。这1GB空间可以用来访问实际的DRAM内存，可以为操作系统的内核所用。<BR>　　MIPS的Kernel Space中，还有两段特殊的地址空间，分别是从0x80000000到0x9FFFFFFF的Kernel Space Unmapped Uncached和0xA0000000到0xBFFFFFFF的Kernel Space Unmapped Cached。之所以说它们特殊，是因为这两段逻辑地址到物理地址的映射关系是硬件直接确定的，不通过MMU，而且两段实际上是重叠的，均对应0x00000000到0x20000000的物理地址。那么，为什么一段同样的物理地址有两个逻辑地址对应呢？它们的区别又在哪里呢？<BR>　　原来，这是MIPS的设计特色之一。软件在访问Kernel Space Unmapped Uncached这段地址空间的时候，不经过MIPS的Cache。这样，虽然速度会比较慢，但是，对于硬件I/O寄存器来说，就不存在所谓的Cache一致性问题。Cache一致性问题，是指硬件将某个地址的内容跳过软件而改变了，Cache中的内容尚未同步。这样，如果软件读取该地址，有可能从Cache中获取到错误的内容。将硬件I/O寄存器设定在这段地址空间，就可以避免Cache一致性带来的问题。MIPS的程序上电启动地址0xBFC00000，也落在这段地址空间内。——上电时，MMU和Cache均未初始化，因此，只有这段地址空间可以正常读取并处理。<BR>　　另一段特殊的地址Kernel Space Unapped Cached，与前者类似，直接映射到0x00000000到0x20000000，与Kernel Space Unmapped Uncached重叠。因为通过Cache，这段地址空间的访问速度比前者为快。一般地，这段内存空间用于内核代码段，或者内核中的堆栈。<BR>　　显然地，当工程师们换算Kernel Space中的这两段的物理地址和逻辑地址时，只需要改变地址的高3bit就可以了。<BR>　　那么，什么时候需要使用物理地址，什么时候需要使用逻辑地址呢？我们知道，逻辑地址是程序中访问的内存地址，譬如，下面的这条指令：<BR>　　lw a0, 128(t2)<BR>　　这条指令的内容是从t2寄存器内的地址 + 偏移128字节处，读取一个word (4Byte)到寄存器a0内。如果t2的值为0x88200100，则最终访问的物理地址为0x88200180。<BR>　　而物理地址，从工程上可以理解为，将逻辑分析仪连接到内存总线(Memory Bus)上，逻辑分析仪指示的地址，就是物理地址。假如，在上一个例子中，我们把逻辑分析仪接到处理器的前端内存总线，我们就可以看到，执行该指令时，系统访问的物理地址为0x08200180。物理地址和逻辑地址的换算，不仅限于电子工程师在设计硬件线路时需要。在内核工程师编写支持DMA的外部设备驱动时，需要将向操作系统申请到的数据缓冲区地址（当然，这是一个逻辑地址）转换为物理地址，并“告诉”相关外设。这样，外设就可以在收到数据后，使用DMA模式储存在系统的主存中，并向系统发起一个IRQ。操作系统在IRQ的handler中，从外设的相应IO寄存器读取到这段内存的地址（当然，是物理地址）并转换为逻辑地址并处理之。这个过程中，如果没有正确使用和分辨物理地址和逻辑地址，驱动程序便会导致内核的一个panic错误。<BR>　　物理地址到逻辑地址的映射关系是由什么决定的呢？除了上面提到的两段Unmapped的地址空间，其余都是由TLB确定的，由MMU来执行。这是后话。<BR>','192.168.115.1','',0,'','',0,0,0),(12,1,'a:1:{i:16;s:4:\"igmp\";}','<DIV>1:user/password:root/admin</DIV>\r\n<DIV>2:enable</DIV>\r\n<DIV>3:config terminial</DIV>\r\n<DIV>4:ntv config mode igmp</DIV>\r\n<DIV>5:ntv config vpi 0 vci 35</DIV>\r\n<DIV>6:show ntv config</DIV>\r\n<DIV>7:igmp program add 224.1.2.3 xxx 0xffffffff </DIV>\r\n<DIV>8:show igmp program</DIV>\r\n<DIV>9:igmp user add port 0/1/2 no auth 8</DIV>','192.168.115.1','a:0:{}',1263058972,'','',0,0,0),(13,3,'','<DIV>1：当创建一个WAN接口的时候，同时VIPTABLE就有相应的信息，而icirc要等到这个端口真正起来，才会有。所以当见一条pppoe pvc时，viptable已经含有这个信息，并且phyport已经确定。等到这个pppoe真正拨上号，则icirc才会存在，并且分配对应的cid。</DIV>','192.168.115.1','',0,'','',0,0,0),(14,4,'a:1:{i:17;s:9:\"低电平\";}','<DIV>正常的MCU，不管是低电平有效还是高电平有效，加在GPIO上的电平为高，读回来就是1，为低读回来就是0</DIV>\r\n<DIV>关于低电平有效是什么概念：<BR><BR>低电平有效的意思是：在引脚上施加低电平的时候，这个功能触发了（当然要把引脚功能选择为对应的功能。） <BR>例如你说的这个引脚，选择为C\\T\\S\\功能时，在引脚上施加低电平时，CTS功能被触发，CPU内部做出反应（好像是开始发送串口数据，具体要查CPU手册了）。施加高电平时没有反应。<BR><BR>再给个例子：例如74ls373的LE信号是高电平有效，加在LE上为高电平时，就可以把数据锁存，加低电平时就没有反应了。就是高电平的时候，锁存功能有效。<BR><BR>简单的说，低电平有效，就是施加低电平的时候，对应功能被触发（有效）。</DIV>\r\n<DIV>其实使用低电平时电路往往相比高电平时拥有更低的阻抗，而低的阻抗就是说抗干扰能力将会更强，所以一般要控制一种操作的时候尽量使用低电平，而不会去用高电平，除非有2种操作，才会去选用高电平！<BR></DIV>','192.168.115.1','a:0:{}',1264171814,'','',0,0,0),(15,4,'','<DIV>volatile的本意是“易变的” <BR>由于访问寄存器的速度要快过RAM,所以编译器一般都会作减少存取外部RAM的优化。比如：<BR>static int i=0;<BR>int main(void)<BR>{<BR>...<BR>while (1)<BR>{<BR>if (i) dosomething();<BR>}<BR>}<BR><BR>/* Interrupt service routine. */<BR>void ISR_2(void)<BR>{<BR>i=1;<BR>}<BR><BR>程序的本意是希望ISR_2中断产生时,在main当中调用dosomething函数,但是,由于编译器判断在main函数里面没有修改过i,因此可能只执行一次对从i到某寄存器的读操作,然后每次if判断都只使用这个寄存器里面的“i副本”,导致dosomething永远也不会被调用。如果将将变量加上volatile修饰,则编译器保证对此变量的读写操作都不会被优化（肯定执行）。此例中i也应该如此说明。<BR><BR>一般说来,volatile用在如下的几个地方：<BR><BR>1、中断服务程序中修改的供其它程序检测的变量需要加volatile;<BR><BR>2、多任务环境下各任务间共享的标志应该加volatile;<BR><BR>3、存储器映射的硬件寄存器通常也要加volatile说明,因为每次对它的读写都可能由不同意义;<BR><BR>另外,以上这几种情况经常还要同时考虑数据的完整性（相互关联的几个标志读了一半被打断了重写）,在1中可以通过关中断来实现,2中可以禁止任务调度,3中则只能依靠硬件的良好设计了。 </DIV>','192.168.115.1','',0,'','',0,0,0),(16,1,'','<DIV>\r\n<P>指令长度和寄存器个数 <BR>MIPS的所有指令都是32位的，指令格式简单。不像x86那样，x86的指令长度不是固定的，以80386为例，其指令长度可从1字节（例如PUSH)到17字节，这样的好处代码密度高，所以MIPS的二进制文件要比x86的大大约20%~30%。而定长指令和格式简单的好处是易于译码和更符合流水线操作，由于指令中指定的寄存器位置是固定的，使得译码过程和读指令的过程可以同时进行，即固定字段译码。<BR>32个通用寄存器，寄存器数量跟编译器的的要求有关。寄存器分配在编译优化中是最重要的优化之一（也许是做重要的）。现在的寄存器分配算法都是基于图着色的技术。其基本思想是构造一个图，用以代表分配寄存器的各个方案，然后用此图来分配寄存器。粗略说来就是使用有限的颜色使图中相临的节点着以不同的颜色，图着色问题是个图大小的指数函数，有些启发式算法产生近乎线形时间运行的分配。全局分配中如果有16个通用寄存器用于整型变量，同时另有额外的寄存器用于浮点数，那么图着色会很好的工作。在寄存器数教少时候图着色并不能很好的工作。<BR>&nbsp;&nbsp; 问： 既然不能少于16个，那为什么不用64个呢？<BR>答： 使用64个或更多寄存器不但需要更大的指令空间来对寄存器编码，还会增加上下文切换的负担。除了那些很大不能感非常复杂的函数，32个寄存器就已足够保存经常使用的数据。使用更多的寄存器并不必要，同时计算机设计有个原则叫“越小越快”，但是也不是说使用31个寄存器会比32个性能更好，32个通用寄存器是流行的做法。<BR>&nbsp;&nbsp; 指令格式<BR>所有MIPS指令长度相同，都是32位，但为了让指令的格式刚好合适，于是设计者做了一个折衷：所有指令定长，但是不同的指令有不同的格式。MIPS指令有三种格式：R格式，I格式，J格式。每种格式都由若干字段（filed)组成，图示如下：<BR>I型指令<BR>&nbsp;&nbsp; &nbsp;&nbsp; 6 &nbsp;&nbsp; 5 &nbsp;&nbsp;&nbsp; 5 &nbsp;&nbsp;&nbsp; 16<BR>　　　------|-----|-----|------------------|<BR>&nbsp;&nbsp; | op | rs | rt&nbsp;&nbsp; | 立即数操作 |<BR>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; ------|-----|-----|------------------|<BR>加载/存储字节，半字，字，双字<BR>条件分支，跳转，跳转并链接寄存器<BR>R型指令<BR>&nbsp;&nbsp; &nbsp;&nbsp; 6 &nbsp;&nbsp; 5 &nbsp;&nbsp;&nbsp; 5 &nbsp;&nbsp;&nbsp; 5 &nbsp;&nbsp;&nbsp; 5 &nbsp;&nbsp;&nbsp; 6 <BR>　　　------|-----|-----|-----|-----|------－－|<BR>&nbsp;&nbsp; |op | rs&nbsp;&nbsp; | rt&nbsp;&nbsp; | rd |shamt|funct　|<BR>　　　------|-----|-----|-----|-----|------－－－|<BR>寄存器-寄存器ALU操作<BR>读写专用寄存器<BR>J型指令<BR>&nbsp;&nbsp; &nbsp;&nbsp; 6 &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; 26<BR>&nbsp;&nbsp; ------|------------------------------|<BR>&nbsp;&nbsp; |op&nbsp;&nbsp; |　　跳转地址 &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; |<BR>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; ------|------------------------------| <BR>跳转，跳转并链接<BR>陷阱和从异常中返回 <BR>&nbsp;&nbsp; 各字段含义：<BR><FONT color=#ff0000>op:指令基本操作，称为操作码。<BR>rs:第一个源操作数寄存器。<BR>rt:第二个源操作数寄存器。<BR>rd:存放操作结果的目的操作数。<BR>shamt:位移量<BR>funct:函数，这个字段选择op操作的某个特定变体。</FONT>&nbsp;&nbsp;<BR>所有指令都按照着三种类型之一来编码，通用字段在每种格式中的位置都是相同的。<BR>&nbsp;&nbsp;&nbsp; 这种定长和简单格式的指令编码很规则，很容易看出其机器码，例如：<BR>add $t0,$s0,$s1<BR>&nbsp;&nbsp;&nbsp; 表示$t0=$s0+$s1,即16号寄存器（s0)的内容和17号寄存器(s1)的内容相加，结果放到8号寄存器(t0)。<BR>&nbsp;&nbsp;&nbsp; 指令各字段的十进制表示为<BR>　　　------|-----|-----|-----|-----|------|<BR>&nbsp;&nbsp; |&nbsp;&nbsp; 0 | 16 | 17 |&nbsp;&nbsp; 8 |&nbsp;&nbsp; 0 |&nbsp;&nbsp; 32 |<BR>　　　------|-----|-----|-----|-----|------|<BR>op=0和funct=32表示这是加法，16=$s0表示第一个源操作数(rs)在16号寄存器里，17=$s1表示第二个源操作数(rt)在17号寄存器里，8=$t0表示目的操作数(rd)在8号寄存器里。<BR>把各字段写成二进制，为<BR>------|-----|-----|-----|-----|------|<BR>&nbsp;&nbsp; |000000|10000|10001|01000|00000|100000|<BR>------|-----|-----|-----|-----|------|<BR>这就是上述指令的机器码（machine code),可以看出是很有规则性的。<BR>&nbsp;&nbsp; 通用寄存器(GPR) <BR>有32个通用寄存器，$0到$31：<BR>$0:即$zero,该寄存器总是返回零，为0这个有用常数提供了一个简洁的编码形式。MIPS编译器使用slt,beq,bne等指令和由寄存器$0获得的0来 产生所有的比较条件：相等，不等，小于，小于等于，大于，大于等于。还可以用add指令创建move伪指令，即<BR>move $t0,$t1<BR>实际为<BR>add $t0,$0,$t1<BR>焦林前辈提到他移植fpc时move指令出错，转而使用add代替的。<BR>&nbsp;&nbsp; 使用伪指令可以简化任务，汇编程序提供了比硬件更丰富的指令集。<BR><FONT style=\"BACKGROUND-COLOR: #ffffff\" color=#ff0000>$1:即$at，该寄存器为汇编保留</FONT>，刚才说到使用伪指令可以简化任务，但是代价就是要为汇编程序保留一个寄存器，就是$at。<BR>由于I型指令的立即数字段只有16位，在加载大常数时，编译器或汇编程序需要把大常数拆开，然后重新组合到寄存器里。比如加载一个32位立即数需要lui（装入高位立即数）和addi两条指令。像MIPS程序拆散和重装大常数由汇编程序来完成，汇编程序必需一个临时寄存器来重组大常数，这也是为汇编保留$at的原因之一。<BR><FONT color=#ff0000>$2..$3:($v0-$v1)用于子程序的非浮点结果或返回值，</FONT>对于子程序如何传递参数及如何返回，MIPS范围有一套约定，堆栈中少数几个位置处的内容装入CPU寄存器，其相应内存位置保留未做定义，当这两个寄存器不够存放返回值时，编译器通过内存来完成。<BR><FONT color=#ff0000>$4..$7:($a0-$a3)用来传递前四个参数给子程序，不够的用堆栈</FONT>。<FONT color=#0000ff>a0-a3和v0-v1以及ra一起</FONT>来支持子程序／过程调用，分别用以传递参数，返回结果和存放返回地址。当需要使用更多的寄存器时，就需要堆栈（stack)了,MIPS编译器总是为参数在堆栈中留有空间以防有参数需要存储。<BR><FONT color=#ff0000>$8..$15:($t0-$t7)临时寄存器，</FONT>子程序可以使用它们而不用保留。<BR><FONT color=#ff0000>$16..$23:(<FONT color=#0000ff>$s0-$s7</FONT>)保存寄存器，在过程调用过程中需要保</FONT><FONT color=#ff0000>留（被调用者保存和恢复，还包括</FONT><FONT color=#0000ff>$fp和$ra</FONT>），MIPS提供了临时寄存器和保存寄存器，这样就减少了寄存器溢出（spilling,即将不常用的变量放到存储器的过程),编译器在编译一个叶（leaf)过程（不调用其它过程的过程）的时候，总是在临时寄存器分配完了才使用需要保存的寄存器。<BR><FONT color=#ff0000>$24..$25:($t8-$t9)同($t0-$t7)<BR></FONT><FONT color=#ff0000>$26..$27:($k0,$k1)为操作系统／异常处理保留，至少要预留一个</FONT>。异常（或中断）是一种不需要在程序中显示调用的过程。MIPS有个叫异常程序计数器（exception program counter,EPC)的寄存器，属于CP0寄存器，用于保存造成异常的那条指令的地址。查看控制寄存器的唯一方法是把它复制到通用寄存器里，指令<FONT color=#ff00ff>mfc0(move from system control)可以将EPC中的地址复制到某个通用寄存器中</FONT><FONT color=#ff0000>，通过跳转语句（jr)，程序可以返回到造成异常的那条指令处继续执行</FONT>。仔细分析一下会发现个有意思的事情：<BR>为了查看控制寄存器EPC的值并跳转到造成异常的那条指令（使用jr),必须把EPC的值到某个通用寄存器里，这样的话，程序返回到中断处时就无法将所有的寄存器恢复原值。如果先恢复所有的寄存器，那么从EPC复制过来的值就会丢失，jr就无法返回中断处；如果我们只是恢复除有从EPC复制过来的返回地址外的寄存器，但这意味着程序在异常情况后某个寄存器被无端改变了，这是不行的。为了摆脱这个两难境地，<FONT color=#00ff00>MIPS程序员都必须保留两个寄存器$k0和$k1</FONT>，供操作系统使用。发生异常时，这两个寄存器的值不会被恢复，编译器也不使用k0和k1,<FONT color=#00ff00>异常处理函数可以将返回地址放到这两个中的任何一个，然后使用jr跳转到造成异常的指令处继续执行</FONT>。<BR><FONT color=#ff0000>$28:($gp)C语言中有两种存储类型，自动型和静态型，</FONT>自动变量是一个过程中的局部变量。静态变量是进入和退出一个过程时都是存在的。为了简化静态数据的访问，MIPS软件保留了一个寄存器：全局指针gp(global pointer,$gp)，如果没有全局指针，从静态数据去装入数据需要两条指令：一条有编译器和连接器计算的32位地址常量中的有效位；令一条才真正装入数据。全局指针只想静态数据区中的运行时决定的地址，在存取位于gp值上下32KB范围内的数据时，只需要一条以gp为基指针的指令即可。在编译时，数据须在以gp为基指针的64KB范围内。<BR><FONT color=#ff0000>$29:($sp)MIPS硬件并不直接支持堆栈</FONT>，例如，它没有x86的SS,SP,BP寄存器，MIPS虽然定义$29为栈指针，它还是通用寄存器，只是用于特殊目的而已，你可以把它用于别的目的，但为了使用别人的程序或让别人使用你的程序，还是要遵守这个约定的，但这和硬件没有关系。x86有单独的PUSH和POP指令，而MIPS没有，但这并不影响MIPS使用堆栈。在发生过程调用时，调用者把过程调用过后要用的寄存器压入堆栈，被调用者把返回地址寄存器$ra和保留寄存器压入堆栈。同时调整堆栈指针，当返回时，从堆栈中恢复寄存器，同时调整堆栈指针。<BR>$<FONT color=#ff0000>30:($fp)GNU MIPS C编译器使用了侦指针(frame pointer),</FONT>而SGI的C编译器没有使用，<FONT color=#ff0000>而把这个寄存器当作保存寄存器使用（$s8),</FONT>这节省了调用和返回开销，但增加了代码生成的复杂性。<BR><FONT color=#ff0000>$31:($ra)存放返回地址，</FONT>MIPS有个jal(jump-and-link,跳转并链接)指令，在跳转到某个地址时，把下一条指令的地址放到$ra中。用于支持子程序，例如调用程序把参数放到$a0~$a3,然后jal X跳到X过程，被调过程完成后把结果放到$v0,$v1,然后使用jr $ra返回。<BR><FONT color=#00ff00>在调用时需要保存的寄存器为$a0~$a3,$s0~$s7,$gp,$sp,$fp,$ra。<BR></FONT>跳转范围<BR>J指令的地址字段为26位，用于跳转目标。指令在内存中以4字节对齐，最低两个有效位不需要存储。在MIPS中，每个地址的最低两位指定了字的一个字节，cache映射的下标是不使用这两位的，这样能表示28位的字节编址，允许的地址空间为256M。PC是32位的，那其它4位从何而来呢？MIPS的跳转指令只替换PC的低28位，而高4位保留原值。因此，加载和链接程序必须避免跨越256MB,在256M的段内，分支跳转地址当作一个绝对地址，和PC无关，如果超过256M（段外跳转）就要用跳转寄存器指令了。<BR>同样，条件分支指令中的16位立即数如果不够用，可以使用PC相对寻址，即用分支指令中的分支地址与(PC+4)的和做分支目标。由于一般的循环和if语句都小于2^16个字（2的16次方），这样的方法是很理想的。</P>\r\n<P></P>\r\n<P><FONT color=#ff0000>0 zero 永远返回值为0 <BR>1 at 用做汇编器的暂时变量 <BR>2-3 v0, v1 子函数调用返回结果 <BR>4-7 a0-a3 子函数调用的参数 <BR>8-15 t0-t7 暂时变量，子函数使用时不需要保存与恢复 <BR>24-25 t8-t9 <BR>16-25 s0-s7 子函数寄存器变量。子函数必须保存和恢复使用过的变量在函数返回之前，从而调用函数知道这些寄存器的值没有变化。 <BR>26,27 k0,k1 通常被中断或异常处理程序使用作为保存一些系统参数 <BR>28 gp 全局指针。一些运行系统维护这个指针来更方便的存取“static“和”extern\"变量。 <BR>29 sp 堆栈指针 <BR>30 s8/fp 第9个寄存器变量。子函数可以用来做桢指针 <BR>31 ra 子函数的返回地□</FONT></P>\r\n<P>这些寄存器的用法都遵循一系列约定。这些约定与硬件确实无关，但如果你想使用别人的代码，编译器和操作系统，你最好是遵循这些约定。</P>\r\n<P>寄存器名约定与使用 <BR><BR>*at: 这个寄存器被汇编的一些合成指令使用。如果你要显示的使用这个寄存器(比如在异常处理程序中保存和恢复寄存器)，有一个汇编directive可被用来禁止汇编器在directive之后再使用at寄存器(但是汇编的一些宏指令将因此不能再可用)。 <BR><BR>*v0, v1: 用来存放一个子程序(函数)的非浮点运算的结果或返回值。如果这两个寄存器不够存放需要返回的值，编译器将会通过内存来完成。详细细节可见10.1节。 <BR><BR><BR>*a0-a3: 用来传递子函数调用时前4个非浮点参数。在有些情况下，这是不对的。请参考10.1细节。 <BR><BR>* t0-t9: 依照约定，一个子函数可以不用保存并随便的使用这些寄存器。在作表达式计算时，这些寄存器是非常好的暂时变量。编译器/程序员必须注意的是，当调用一个子函数时，这些寄存器中的值有可能被子函数破坏掉。 <BR><BR>*s0-s8: 依照约定，子函数必须保证当函数返回时这些寄存器的内容必须恢复到函数调用以前的值，或者在子函数里不用这些寄存器或把它们保存在堆栈上并在函数退出时恢复。这种约定使得这些寄存器非常适合作为寄存器变量或存放一些在函数调用期间必须保存原来值。 <BR><BR>* k0, k1: 被OS的异常或中断处理程序使用。被使用后将不会恢复原来的值。因此它们很少在别的地方被使用。 <BR><BR>* gp: 如果存在一个全局指针，它将指向运行时决定的，你的静态数据(static data)区域的一个位置。这意味着，利用gp作基指针，在gp指针32K左右的数据存取，系统只需要一条指令就可完成。如果没有全局指针，存取一个静态数据区域的值需要两条指令：一条是获取有编译器和loader决定好的32位的地址常量。另外一条是对数据的真正存取。为了使用gp, 编译器在编译时刻必须知道一个数据是否在gp的64K范围之内。通常这是不可能的，只能靠猜测。一般的做法是把small global data (小的全局数据)放在gp覆盖的范围内(比如一个变量是8字节或更小)，并且让linker报警如果小的全局数据仍然太大从而超过gp作为一个基指针所能存取的范围。 <BR><BR>并不是所有的编译和运行系统支持gp的使用。 <BR><BR>*sp: 堆栈指针的上下需要显示的通过指令来实现。因此<A class=contentlabel href=\"http://www.eepw.com.cn/news/listbylabel/label/MIPS\"><FONT color=#000000 size=2>MIPS</FONT></A>通常只在子函数进入和退出的时刻才调整堆栈的指针。这通过被调用的子函数来实现。sp通常被调整到这个被调用的子函数需要的堆栈的最低的地方，从而编译器可以通过相对於sp的偏移量来存取堆栈上的堆栈变量。详细可参阅10.1节堆栈使用。 <BR><BR>* fp: fp的另外的约定名是s8。如果子函数想要在运行时动态扩展堆栈大小，fp作为桢指针可以被子函数用来记录堆栈的情况。一些编程语言显示的支持这一点。汇编编程员经常会利用fp的这个用法。C语言的库函数alloca()就是利用了fp来动态调整堆栈的。 <BR><BR>如果堆栈的底部在编译时刻不能被决定，你就不能通过sp来存取堆栈变量，因此fp被初始化为一个相对与该函数堆栈的一个常量的位置。这种用法对其他函数是不可见的。 <BR><BR>* ra: 当调用任何一个子函数时，返回地址存放在ra寄存器中，因此通常一个子程序的最后一个指令是jr ra. <BR><BR>子函数如果还要调用其他的子函数，必须保存ra的值，通常通过堆栈。 <BR><BR>对於浮点寄存器的用法，也有一个相应的标准的约定。我们将在7.5节。在这里，我们已经介绍了<A class=contentlabel href=\"http://www.eepw.com.cn/news/listbylabel/label/MIPS\"><FONT color=#000000 size=2>MIPS</FONT></A>引入的寄存</P>\r\n<P></P>\r\n<P>1、MIPS指令集的确很RISC，数据类的仅有load、store和move，当然按操作数的长短分许多lw、lh等等，但实际上就这三个。运算类的也仅仅完成基本功能，也根据操作数长短分了许多子指令。跳转类更少，要么无条件跳转，要么根据操作数跳转。这些指令确实属于最常用的80%的。相比Intel的LEA等指令，由于个人习惯，很少用，而AAD、AAA等指令，我几乎没用过。</P>\r\n<P>2、MIPS指令较少，但汇编器为了方便使用，定义了许多伪指令，如li、ror等。最终会被扩展成多条实际指令。这样一来，好处就是能省力，但坏处就是对汇编器要求较高，而且对机器指令反汇编后难以还原为伪指令（反汇编器面对lui $at, 0xABCD和ori r, $at, 0xEF00似乎不能自作主张的将其视作li, r, 0xABCDEF00）；反汇编出来的指令条数多，不利于hack（或许又是好事）。</P>\r\n<P>3、MIPS的寻址方式最简单，仅有寄存器加偏移寻址方式（内嵌16位立即数寻址不算在内），这对于饱受Intel的八种寻址方式折磨的人来说是天大的好事。</P>\r\n<P>4、MIPS没有栈操作指令，虽然有约定俗称的$sp。在做递归调用时必须手工管理栈，调用子程序时没有自动压栈的call指令，只能用jal。这对于用惯了intel的PUSH和POP的人又会是一场噩梦。</P>\r\n<P>5、MIPS的内存映射、中断等功能都做到了协处理器0中，浮点运算做到了协处理器1 中。</P>\r\n<P>6、MIPS寄存器非常多，对于表达式求值很有利，不过调度算法就复杂了。而且寄存器虽然有约定俗成的用法，但实际上并没有限制。</P>\r\n<P>7、MIPS指令为定长的，很统一，给我的“感觉”非常好。</P>\r\n<P>&nbsp;&nbsp;&nbsp; 最终，个人体会，在MIPS体系下思考又是另一种感觉，由于栈是全手工管理，就不用考虑push、pop是否匹配以及操作数大小，但手工管理栈要求头脑非常清晰；由于寄存器多了，就更多的考虑寄存器调度，如何发挥出所有寄存器的潜力；也不用去费心思选择寻址方式。MIPS在寄存器使用、栈、存储方面提供了更高的灵活性，设计程序可以更加自由，但同时也增大了交流、学习的难度，这点与Intel严格的体系结构完全相反。</P>\r\n<P>&nbsp;&nbsp;&nbsp; 从MIPS的特性看来，由于MIPS指令集简单，容易设计和实现，尺寸可以做小，因此MIPS的方向除了嵌入式外，应该是多核心，提高并行度，主要面向并发性高的应用，如服务器。而在桌面应用方面，目前没有x86的优势明显。速度是一方面，MIPS的应用少，指令集太精简、对程序员的友好程度不够好也是一个原因</P></DIV>','192.168.115.1','',0,'','',0,0,0),(17,1,'a:3:{i:18;s:4:\"mips\";i:19;s:4:\"flag\";i:20;s:3:\"set\";}','<DIV>set &lt;flag&gt;<BR>Sets (and clears) various flags that affect generated code. The following table may not be a complete list.<BR>Flag<BR><STRONG>noreorder</STRONG><BR>&nbsp; &nbsp; &nbsp; &nbsp; Turns off reordering of instructions. When on, t.i. when the assembler is reordering, it will put the last instruction before j or jr after the jump so it\'ll be in the branch delay slot. When off, you\'ll have to do it yourself.<BR><BR><STRONG>mips3</STRONG><BR>&nbsp; &nbsp; &nbsp; &nbsp; Tells the assembler that it can use the MIPS III instructions. Withouth it as simulates 64 bit instructions, and believe me, that\'s something you don\'t want.<BR><BR><STRONG>reorder</STRONG><BR>&nbsp; &nbsp; &nbsp; &nbsp; Allows the assembler to reorder instructions; see noreorder<BR><BR><STRONG>pop</STRONG><BR>&nbsp; &nbsp; &nbsp; &nbsp; Not really a flag but restores the state of the flags to what it was before the last .set push; see push.<BR><BR><STRONG>push</STRONG><BR>&nbsp; &nbsp; &nbsp; &nbsp; Nor really a flag but saves the status of the flags so it can be restored with .set pop. Not really useful (I think) outside inline assembly. Use in pairs with .set pop.<BR></DIV>','192.168.115.1','a:0:{}',1263162782,'','',0,0,0),(18,1,'a:3:{i:21;s:3:\"ppp\";i:22;s:6:\"获取\";i:1;s:5:\"hello\";}','<DIV>osk中PPPoe 获取IP后，调用sys-stub.c 中的sifaddr设置vip，</DIV>\r\n<DIV>而其他方式则是setItfIp</DIV>','192.168.115.1','a:0:{}',1269401242,'3','',0,0,0),(19,4,'','<DIV>ccbptr中的portnum在发送的时候为发送port的port 号</DIV>','192.168.115.1','',0,'','',0,0,0),(20,4,'a:4:{i:23;s:4:\"port\";i:24;s:6:\"机房\";i:25;s:6:\"关系\";i:26;s:6:\"实验\";}','<DIV>实验室的5---13</DIV>\r\n<DIV>实验室的7---15</DIV>\r\n<DIV>应该是差8的关系</DIV>','192.168.115.1','a:0:{}',1264272368,'','',0,0,0),(21,4,'a:1:{i:27;s:8:\"register\";}','<DIV><FONT face=Verdana>&lt;RTL867X&gt;r 0xb8003334<BR>0034a104&nbsp; //enalbe clock spectrum spread(适于与sdram，不适用DDR)<BR>&lt;RTL867X&gt;r 0xb8003200<BR>ffdf0d07&nbsp; //OCP 340MHz, LX 175MHz, SDRAM 133MHz</FONT></DIV>','192.168.115.1','a:0:{}',1264674254,'','',0,0,0),(22,4,'','<DIV>定符 </DIV>\r\n<DIV>&nbsp;意义 </DIV>\r\n<DIV>&nbsp;<BR>\"m\"、\"v\"、\"o\" </DIV>\r\n<DIV>&nbsp;内存单元 </DIV>\r\n<DIV>&nbsp;<BR>\"r\" </DIV>\r\n<DIV>&nbsp;任何寄存器 </DIV>\r\n<DIV>&nbsp;<BR>\"q\" </DIV>\r\n<DIV>&nbsp;寄存器eax、ebx、ecx、edx之一 </DIV>\r\n<DIV>&nbsp;<BR>\"i\"、\"h\" </DIV>\r\n<DIV>&nbsp;直接操作数 </DIV>\r\n<DIV>&nbsp;<BR>\"E\"和\"F\" </DIV>\r\n<DIV>&nbsp;浮点数 </DIV>\r\n<DIV>&nbsp;<BR>\"g\" </DIV>\r\n<DIV>&nbsp;任意 </DIV>\r\n<DIV>&nbsp;<BR>\"a\"、\"b\"、\"c\"、\"d\" </DIV>\r\n<DIV>&nbsp;分别表示寄存器eax、ebx、ecx和edx </DIV>\r\n<DIV>&nbsp;<BR>\"S\"和\"D\" </DIV>\r\n<DIV>&nbsp;寄存器esi、edi </DIV>\r\n<DIV>&nbsp;<BR>\"I\" </DIV>\r\n<DIV>&nbsp;常数（0至31） <BR>&nbsp;</DIV>\r\n<DIV>本文来自: (<a href=\"http://www.91linux.com\" target=\"_blank\">www.91linux.com</A>) 详细出处参考：<a href=\"http://www.91linux.com/html/article/program/20071017/7605_2.html\" target=\"_blank\">http://www.91linux.com/html/article/program/20071017/7605_2.html</A></DIV>','192.168.115.1','',0,'','',0,0,0),(23,3,'','<DIV>\r\n<DIV class=subject style=\"TABLE-LAYOUT: fixed; WORD-WRAP: break-word\">&nbsp;</DIV>\r\n<DIV align=center>&nbsp;</DIV>\r\n<DIV class=content style=\"TABLE-LAYOUT: fixed; WORD-WRAP: break-word\"><BR><BR><SPAN class=content><B>1. 内核栈切换 (MIPS)</B><BR><BR>调度切换至一个进程时，根据 task_struct-&gt;thread_info 的值设置 *kernelsp（当前正在运行进程之内核栈栈底），其值为 thread_info + THREAD_SIZE - 32（MIPS 下，使用 set_saved_sp 宏）。<BR><BR><BR><B>2. 异常、中断寄存器的保存 (MIPS)</B><BR><BR>使用SAVE_SOME 保存上下文时，如发现从用户态切入核心态，则首先用 get_saved_sp 宏，将*kernelsp 置入sp。然后在内核栈上分配 PT_SIZE（=sizeof(struct pt_regs)） 大小的空间，作为上下文的保存空间。保存时所有数据精心组织，最后就是一个 struct pt_regs 结构。<BR><BR>若是用户态 --&gt; 内核态，则 k0 = sp, sp = *kernelsp - PT_SIZE，store k0, PT_R29(sp)，保存其它寄存器。<BR><BR>若是内核态 --&gt; 内核态，直接 k0 = sp, sp = sp - PT_SIZE，store k0, PT_R29(sp)，然后保存其它寄存器。<BR><BR><BR><B>3. 任务切换上下文的保存 (MIPS)</B><BR><BR>时钟中断后使用 SAVE_SOME 在内核栈/用户栈（取决于当时所在模式）上保存 $0, $2, $3, $4~$7, $8~$9(64bit), $25, $28, $29, $31, STATUS, CAUSE, EPC。<BR><BR>后在 switch_to 中保存正在运行任务的上下文：<BR><BR>保存 STATUS，使用 cpu_save_nonscratch 保存$16~$23, $29(sp), $30，以及 $31, 有FPU还要 fpu_save_double 保存FPU的寄存器。所有都保存于thread_struct 结构中，该结构为 task_struct 的一部分。<BR><BR>这些保存的是 switch_to 前后的上下文<BR><BR><BR>然后将将要运行的任务上下文加载：<BR><BR>$28 &lt;---- &amp;thread_info<BR>cpu_restore_nonscratch 恢复 $16~$23, $29(sp), $30<BR>*(kernelsp) &lt;---- &amp;thread_info + THREAD_SIZE - 32<BR>恢复 thread_struct 中保存的 STATUS（bit 0, bit 8~15 用当前STATUS值替换）<BR><BR>现在恢复时也在 switch_to 前后，神不知鬼不觉的替换了，所有操作都是由switch_to调用叶函数resume完成。<BR><BR>do_IRQ 返回后，sp恢复（减多少，对称的加多少，因此与初值无关，最终指向新进程的 pt_regs 结构）ref_from_irq 则时钟中断返回（当时被中断时的环境），然后 eret 跳回到用户态（或者被时钟中断的核心态）继续运行。<BR><BR><BR><B>4. switch_to 为何不需保存$0~$15 $24~$27 (MIPS)</B><BR><BR>假如内核要从进程A切换到进程B，流程大概是这样：<BR><BR>进程A --&gt; 时钟中断 --&gt; schedule --&gt; switch_to(resume) --&gt; schedule 返回 --&gt; ret_from_irq --&gt; 进程B<BR><BR>switch_to 保存于 A task_struct-&gt;thread_struct 中的状态是整个调用链中的 switch_to 宏附近的处理器状态<BR><BR>因此将 sp 指向保存于 B task_struct-&gt;thread_struct 中的 sp 时，实际上就相当于恢复到当时进程B在switch_to前后的状态：<BR><BR>进程B --&gt; 时钟中断 --&gt; schedule --&gt; switch_to <BR><BR>switch_to 是一个宏，其中调用了，位于 arch/mips/kernel/r4k_switch.S 中的一个叶函数（不改变静态寄存器的值，不用压栈、出栈）resume，因此进入 resume 前，ABI 规定的一些非静态寄存器的值就再也不用了，故这些非静态值无需保存。<BR><BR>至于静态寄存器的值，函数用之前都会保存于栈上，最后恢复之，子函数调用不会改变其值。因此静态寄存器保存的是当时运行状态的一部分。如这种情况：<BR><BR>schedule 中编译器用 s0 保存一个重要的状态变量，因此进入schedule首先保存s0的值，使用 s0 参与运算，switch_to 后，又要根据 s0 判断进一步的动作。<BR><BR>这个时候就要将 s0 恢复为进程B当时在此点的值。总之注意，switch_to 后所有操作延续的是进程B的：<BR><BR>schedule 返回 --&gt; ret_from_irq --&gt; 进程B <BR><BR><BR><B>5. 中断处理时可否睡眠问题</B><BR><BR>Linux 设计中，中断处理时不能睡眠，这个内核中有很多保护措施，一旦检测到内核会异常。<BR><BR>当一个进程A因为中断被打断时，中断处理程序会使用 A 的内核栈来保存上下文，因为是“抢”的 A 的CPU，而且用了 A 的内核栈，因此中断应该尽可能快的结束。如果 do_IRQ 时又被时钟中断打断，则继续在 A 的内核栈上保存中断上下文，如果发生调度，则 schedule 进 switch_to，又会在 A 的 task_struct-&gt;thread_struct 里保存此时时种中断的上下文。<BR><BR>假如其是在睡眠时被时钟中断打断，并 schedule 的话，假如选中了进程 A，并 switch_to 过去，时钟中断返回后则又是位于原中断睡眠时的状态，抛开其扰乱了与其无关的进程A的运行不说，这里的问题就是：该如何唤醒之呢？？<BR><BR>另外，和该中断共享中断号的中断也会受到影响。<BR></SPAN></DIV></DIV>','192.168.115.1','',0,'','',0,0,0),(24,3,'','<DIV>when the userspace receives control, the stack layout has a fixed format.<BR>The rough order is this:</DIV>\r\n<DIV>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &lt;arguments&gt; &lt;environ&gt; &lt;auxv&gt; &lt;string data&gt;</DIV>\r\n<DIV>The detailed layout, assuming IA32 architecture, is this (Linux kernel<BR>series 2.2/2.4):</DIV>\r\n<DIV>&nbsp; position&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; content&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size (bytes) + comment<BR>&nbsp; ------------------------------------------------------------------------<BR>&nbsp; stack pointer -&gt;&nbsp; [ argc = number of args ]&nbsp;&nbsp;&nbsp;&nbsp; 4<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ argv[0] (pointer) ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp; (program name)<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ argv[1] (pointer) ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ argv[..] (pointer) ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4 * x<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ argv[n - 1] (pointer) ]&nbsp;&nbsp;&nbsp;&nbsp; 4<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ argv[n] (pointer) ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp; (= NULL)</DIV>\r\n<DIV>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ envp[0] (pointer) ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ envp[1] (pointer) ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ envp[..] (pointer) ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ envp[term] (pointer) ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp; (= NULL)</DIV>\r\n<DIV>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ auxv[0] (Elf32_auxv_t) ]&nbsp;&nbsp;&nbsp; 8<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ auxv[1] (Elf32_auxv_t) ]&nbsp;&nbsp;&nbsp; 8<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ auxv[..] (Elf32_auxv_t) ]&nbsp;&nbsp; 8<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ auxv[term] (Elf32_auxv_t) ] 8&nbsp;&nbsp; (= AT_NULL vector)</DIV>\r\n<DIV>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ padding ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 - 16</DIV>\r\n<DIV>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ argument ASCIIZ strings ]&nbsp;&nbsp; &gt;= 0<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ environment ASCIIZ str. ]&nbsp;&nbsp; &gt;= 0</DIV>\r\n<DIV>&nbsp; (0xbffffffc)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [ end marker ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp; (= NULL)</DIV>\r\n<DIV>&nbsp; (0xc0000000)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &lt; top of stack &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; (virtual)<BR>&nbsp; ------------------------------------------------------------------------<BR></DIV>','192.168.115.1','',0,'','1',0,0,0),(25,1,'','<DIV>\r\n<DIV><FONT size=2>1. Latency Type: GetChannelMode(int *data): 1-fats,2-interleave</FONT></DIV>\r\n<DIV><FONT size=2>2. Line coding: ReadCfg(int *data):取data[6]的值，0：ON，1：Off</FONT></DIV>\r\n<DIV><FONT size=2>3.Noise Margin：下/上行(dB)：GetSNRMargin(int *data): data[0]/10:下行, data[1]/10:上行</FONT></DIV>\r\n<DIV><FONT size=2>4.Line Attenuation：环路衰减 下/上行(dB)： GetLoopAtt(unsigned short *data):data[0]/2:上行, data[1]/2:下行</FONT></DIV>\r\n<DIV><FONT size=2>5.Output Power:下/上行(dBm):</FONT></DIV>\r\n<DIV><FONT size=2>&nbsp;1) 下行Output Power:FarEndLineData(T_AMSW_NT_FarEndLineOperData *FarEndLineOperData):&nbsp;&nbsp; FarEndLineOperData-&gt;outputPowerDnstr/2</FONT></DIV>\r\n<DIV><FONT size=2>typedef struct {<BR>&nbsp; unsigned short relCapacityOccupationUpstr;<BR>&nbsp; signed short&nbsp; noiseMarginUpstr;<BR>&nbsp; signed char&nbsp; outputPowerDnstr;<BR>&nbsp; unsigned char&nbsp; attenuationUpstr;<BR>&nbsp; unsigned char&nbsp; carrierLoad[TONE_RANGE&gt;&gt;1];<BR>} T_AMSW_NT_FarEndLineOperData;</FONT></DIV>\r\n<DIV><FONT size=2>T_AMSW_NT_FarEndLineOperData *FarEndLineOperData</FONT></DIV>\r\n<DIV><FONT size=2>2）上行Output Power: NearEndLineData（T_AMSW_NT_NearEndLineOperData *NearEndLineOperData）：*NearEndLineOperData－&gt;outputPowerUpstr/2</FONT></DIV>\r\n<DIV><FONT size=2>typedef struct {<BR>&nbsp; unsigned short relCapacityOccupationDnstr;<BR>&nbsp; signed short&nbsp; noiseMarginDnstr;<BR>&nbsp; signed char&nbsp;&nbsp;&nbsp; outputPowerUpstr;<BR>&nbsp; unsigned char&nbsp; attenuationDnstr;<BR>&nbsp; unsigned long operationalMode;<BR>} T_AMSW_NT_NearEndLineOperData;</FONT></DIV>\r\n<DIV><FONT size=2>T_AMSW_NT_NearEndLineOperData *NearEndLineOperData</FONT></DIV>\r\n<DIV><FONT size=2></FONT>&nbsp;</DIV>\r\n<DIV><FONT size=2>6.Attainable Line rate：</FONT><FONT size=3>GetAttainableRate (short *data): data[0]: 上行, data[1]:下行</FONT></DIV>\r\n<DIV><FONT size=2></FONT>&nbsp;</DIV>\r\n<DIV><FONT size=2>7.Line Up Count：GetReHSKCount（long *data）</FONT></DIV>\r\n<DIV><FONT size=2></FONT>&nbsp;</DIV>\r\n<DIV><FONT size=2>8. Status:ReportModemStates(char *data): </FONT></DIV>\r\n<DIV><FONT size=2></FONT>&nbsp;</DIV>\r\n<DIV><FONT size=2>9.K/R/S/D: </FONT></DIV>\r\n<DIV><FONT size=2>1) 下行： GetDsPMSParam1（unsigned short *data）:data[0]:K, data[1]:R,data[2]:D,data[5]:S*100</FONT></DIV>\r\n<DIV><FONT size=2>2) 上行： GetUsPMSParam1（unsigned short *data）:data[0]:K, data[1]:R,data[2]:D,data[5]:S*100</FONT></DIV>\r\n<DIV><FONT size=2></FONT>&nbsp;</DIV>\r\n<DIV><FONT size=2>10. GetAdslStatistic(AdslStatsData *data): </FONT></DIV>\r\n<DIV><FONT size=2>&nbsp;&nbsp;&nbsp; SFCount[0]:上行Super Frames，SFCount[1]:下行Super Frames</FONT></DIV>\r\n<DIV><FONT size=2>&nbsp;&nbsp;&nbsp; SFErr[0]:上行Super Frames Errors，SFErr[1]:下行Super Frames Errors</FONT></DIV>\r\n<DIV><FONT size=2>&nbsp;&nbsp;&nbsp; RSCount[0]: 上行RSwords，RSCount[1]: 下行RSwords</FONT></DIV>\r\n<DIV><FONT size=2>&nbsp;&nbsp;&nbsp; RSCorr[0]：上行RS Correctable Errors，RSCorr[1]：下行RS Correctable Errors，</FONT></DIV>\r\n<DIV><FONT size=2>&nbsp;&nbsp;&nbsp; RSUnCorr[0]：上行RS UnCorrectable Errors，RSUnCorr[1]：下行RS UnCorrectable Errors</FONT></DIV>\r\n<DIV><FONT size=2></FONT>&nbsp;</DIV>\r\n<DIV><FONT size=2>typedef struct {<BR>&nbsp;unsigned long SFCount[2];<BR>&nbsp;unsigned long SFErr[2];<BR>&nbsp;unsigned long RSCount[2];<BR>&nbsp;unsigned short RSCorr[2];<BR>&nbsp;unsigned short RSUnCorr[2];&nbsp;<BR>} AdslStatsData;</FONT></DIV>\r\n<DIV><FONT size=2>AdslStatsData *data；</FONT></DIV>\r\n<DIV><FONT size=2></FONT>&nbsp;</DIV>\r\n<DIV><FONT size=2></FONT>&nbsp;</DIV>\r\n<DIV><FONT size=2></FONT>&nbsp;</DIV>\r\n<DIV><FONT size=2>11.HECErrors: GetDSLConfigStatusShowtime(unsigned int *data): data[11]: 下行HEC， data[12]:上行HEC</FONT></DIV>\r\n<DIV><FONT size=2></FONT>&nbsp;</DIV>\r\n<DIV><FONT size=2>12.LCD Errors: 上行：gFarEndLcdCounter_f 下行：gNearEndLcdCounter_f</FONT></DIV>\r\n<DIV><FONT size=2></FONT>&nbsp;</DIV>\r\n<DIV><FONT size=2>&nbsp;&nbsp; 变量定义：unsigned long gFarEndLcdCounter_f;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;unsigned long gNearEndLcdCounter_f;</FONT></DIV></DIV>','192.168.115.1','',0,'','',0,0,0),(26,1,'','<DIV>\r\n<DIV><FONT size=2><FONT face=宋体>Dear all,</FONT></FONT></DIV>\r\n<DIV><FONT face=宋体 size=2>&nbsp;&nbsp;&nbsp;&nbsp;为了方便乌龟客户端软件的操作，调整一下</FONT>&nbsp;ADSL_Release_Version_Control.xls 在SVN上的存储路径</DIV>\r\n<DIV><U><FONT color=#0000ff><a href=\"http://cadinfo.realtek.com.tw/svn/CN/cnsd6/trunk/adsl/version_control/ADSL_Release_Version_Control.xls\" target=\"_blank\">http://cadinfo.realtek.com.tw/svn/CN/cnsd6/trunk/adsl/<FONT color=#ff0000><STRONG>version_control</STRONG></FONT>/ADSL_Release_Version_Control.xls</A></FONT></U></DIV>\r\n<DIV>&nbsp;</DIV>\r\n<DIV><FONT face=宋体 size=2>　　</FONT></DIV>\r\n<DIV>&nbsp;</DIV>\r\n<DIV><FONT face=宋体 size=2>======== 2010-01-25&nbsp;16:53:03&nbsp;您在来信中写道： ========</FONT></DIV>\r\n<DIV>&nbsp;</DIV>\r\n<DIV><FONT size=2>\r\n<TABLE width=\"100%\">\r\n<TBODY>\r\n<TR>\r\n<TD width=\"100%\">\r\n<BLOCKQUOTE style=\"PADDING-RIGHT: 0px; PADDING-LEFT: 5px; MARGIN-LEFT: 5px; BORDER-LEFT: #000000 2px solid; MARGIN-RIGHT: 0px\"><FONT face=宋体>\r\n<DIV>\r\n<TABLE height=\"100%\" cellSpacing=0 cellPadding=0 width=\"90%\" border=0>\r\n<TBODY>\r\n<TR>\r\n<TD vAlign=top align=left>\r\n<DIV>\r\n<DIV>\r\n<TABLE height=\"96%\" cellSpacing=0 cellPadding=0 width=\"96%\" border=0>\r\n<TBODY>\r\n<TR>\r\n<TD vAlign=top align=left height=30><FONT face=宋体>\r\n<TABLE style=\"WIDTH: 458px; HEIGHT: 389px\" height=\"100%\" cellSpacing=0 cellPadding=0 width=\"90%\" border=0>\r\n<TBODY>\r\n<TR>\r\n<TD vAlign=top align=left>\r\n<DIV><FONT size=2><FONT face=宋体>Dear </FONT><FONT face=\"Comic Sans MS\">&nbsp;all</FONT></FONT></DIV>\r\n<DIV><FONT face=\"Comic Sans MS\" size=2>&nbsp;&nbsp; 之前我在local维护一份ADSL_Release_Version_Control.xls (immigrated from SWITH team)，用来跟踪每次版本发布的信息，现在案子越来越多，所以我有把这个档案commit到svn了，</FONT></DIV>\r\n<DIV><a href=\"http://cadinfo.realtek.com.tw/svn/CN/cnsd6/trunk/adsl/ADSL_Release_Version_Control.xls\" target=\"_blank\">http://cadinfo.realtek.com.tw/svn/CN/cnsd6/trunk/adsl/ADSL_Release_Version_Control.xls</A></DIV>\r\n<DIV>&nbsp;</DIV>\r\n<DIV><FONT face=\"Comic Sans MS\">&nbsp;&nbsp;&nbsp; <FONT size=2>以后请每位具体版本发布的伙伴在完成版本发布的时候额外执行如下动作：</FONT></FONT></DIV>\r\n<DIV><FONT face=\"Comic Sans MS\" size=2>1.&nbsp;&nbsp; 在http://cadinfo.realtek.com.tw/svn/CN/cnsd6/trunk/adsl/vendor/ 下SVN创建对应客户的目录</FONT></DIV>\r\n<DIV><FONT face=\"Comic Sans MS\" size=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 目前已经有的客户目录有Baudtec，huawei，...，已经有的就不用另外创建了，如下所示</FONT></DIV>\r\n<DIV>&nbsp;</DIV>\r\n<DIV><FONT face=\"Comic Sans MS\">&nbsp; </FONT></DIV>\r\n<DIV><FONT face=\"Comic Sans MS\" size=2>2. 在<a href=\"http://cadinfo.realtek.com.tw/svn/CN/cnsd6/trunk/adsl/vendor/customervendor/\" target=\"_blank\">http://cadinfo.realtek.com.tw/svn/CN/cnsd6/trunk/adsl/vendor/<FONT color=#0000ff>customervendor</FONT>/</A> 目录下面创建案子名称，比如目前Huawei目录下面有MT880D和MT800D，已经有的就不用另外创建了</FONT></DIV>\r\n<DIV><FONT face=\"Comic Sans MS\" size=2>3. 在<a href=\"http://cadinfo.realtek.com.tw/svn/CN/cnsd6/trunk/adsl/vendor/customervendor/customerproject/\" target=\"_blank\">http://cadinfo.realtek.com.tw/svn/CN/cnsd6/trunk/adsl/vendor/customervendor/customerproject/</A> 目录下面打所发布版本的对应sourcecode的tag，比如：</FONT></DIV>\r\n<DIV><FONT face=\"Comic Sans MS\" size=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<FONT size=1> svn copy -m \"tag for Huawei MT880D release at 20100125\"&nbsp;&nbsp;</FONT><a href=\"http://cadinfo.realtek.com.tw/svn/CN/cnsd6/trunk/adsl/osk_router/\" target=\"_blank\"><FONT size=1>http://cadinfo.realtek.com.tw/svn/CN/cnsd6/trunk/adsl/osk_router/</FONT></A><FONT size=1>&nbsp; <a href=\"http://cadinfo.realtek.com.tw/svn/CN/cnsd6/trunk/adsl/vendor/huawei/mt880d/20100125/\" target=\"_blank\">http://cadinfo.realtek.com.tw/svn/CN/cnsd6/trunk/adsl/vendor/huawei/mt880d/20100125/</A> </FONT></FONT></DIV>\r\n<DIV><FONT face=\"Comic Sans MS\" size=1></FONT>&nbsp;</DIV>\r\n<DIV><FONT face=\"Comic Sans MS\" size=2>4. 在所打的tag的root directory加入所发布的image files和其它需要保存的文件</FONT></DIV>\r\n<DIV><FONT face=\"Comic Sans MS\" size=2>5. checkout <a href=\"http://cadinfo.realtek.com.tw/svn/CN/cnsd6/trunk/adsl/ADSL_Release_Version_Control.xls\" target=\"_blank\"><FONT size=3>ADSL_Release_Version_Control.xls</FONT></A>&nbsp;文件，把此次的版本发布信息记录其中并commit到SVN。</FONT></DIV>\r\n<DIV><FONT face=宋体 size=2>　　</FONT></DIV></TD></TR></TBODY></TABLE></FONT></TD></TR></TBODY></TABLE></DIV></DIV></TD></TR></TBODY></TABLE></DIV></FONT></BLOCKQUOTE></TD></TR></TBODY></TABLE></FONT></DIV></DIV>','192.168.115.1','',0,'','',0,0,0),(27,1,'a:3:{i:28;s:5:\"clock\";i:29;s:3:\"sys\";i:30;s:7:\"uclinux\";}','<DIV>在uClinux-dist\\linux-2.6.x\\include\\asm\\mach-realtek\\rtl8672\\platform.h裡把MHZ改成所需的值</DIV>\r\n<DIV>sys clock，CPU clock，sdram clock都是由boot决定的，也就是boot一起来，这些值就定下来了，而image中</DIV>\r\n<DIV>sys clock如果与boot中的sys clock不同的话，系统可以正常跑起来，唯一的异常是uart表现为乱码</DIV>','192.168.115.1','a:0:{}',1266337101,'','',0,0,0),(28,1,'a:2:{i:31;s:3:\"ACK\";i:32;s:3:\"TCP\";}','<div>1:A <i>TCP</i> receiver should send an immediate <i>duplicate ACK</i> when an <i>out-of-order</i> segment arrives</div>\r\n<div>当一个主机收到一个错序的包，主机会立即发送一个ack包。<br>2: In addition, a <i>TCP</i> receiver should send an immediate <i>ACK</i> when the \r\nincoming segment <u>fills in all or part</u> of a gap in the sequence space<br>当主机收到一个填充squence gap的包时，主机也应该立即发送一个ack包<br></div>','192.168.115.1','a:0:{}',1265291721,'','',0,0,0),(29,1,'','syn--&gt;sonewconn[alloc socket,]--&gt;pru_attach()---&gt;tcp_usr_attach--&gt;tcp_attach(alloc inpcb&amp;tcpcb,put inpcb in the sktNode list)<br>--&gt;syn received--&gt;soisconnected()--&gt;sowakeup--&gt;httpServerNotify--&gt;new_conn-&gt;accept<br>--&gt;ssaccept(obtain socket from SS_COMP list)--&gt;soUsrAddSock(alloc socket_usr and put into sktNode list)<br>---&gt;soaccept--&gt;tcp_usr_accept<br><br>free inpcb的动作在in_pcbdetach中<br><br>2:tcp_disconnect与tcp_drop的区别<br>tcp_disconnect：<br>static struct tcpcb *<br>tcp_disconnect(tp)<br>&nbsp;&nbsp; &nbsp;register struct tcpcb *tp;<br>{<br>&nbsp;&nbsp; &nbsp;struct socket *so = tp-&gt;t_inpcb-&gt;inp_socket;<br><br>&nbsp;&nbsp; &nbsp;if (tp-&gt;t_state &lt; TCPS_ESTABLISHED)<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;tp = tcp_close(tp,0);<br>&nbsp;&nbsp; &nbsp;else if ((so-&gt;so_options &amp; SO_LINGER) &amp;&amp; so-&gt;so_linger == 0)<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;tp = tcp_drop(tp, 0);<br>&nbsp;&nbsp; &nbsp;else {<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;soisdisconnecting(so);<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sbflush(&amp;so-&gt;so_rcv);<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;tp = tcp_usrclosed(tp);<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if (tp)<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(void) tcp_output(tp);<br>&nbsp;&nbsp; &nbsp;}<br>&nbsp;&nbsp; &nbsp;return (tp);<br>}<br>可以看出：<br>a:当TCP状态小于TCPS_ESTABLISHED的时候，直接将调用tcp_close释放掉资源(queun,timer,inpcb,socket,tcpcb)<br>b:如果设置了SO_LINGER且so-&gt;so_linger==0，则发送RST并释放资源(避免)<br>c:如果不是上面两种情况，则正常路程<br>3:soabort跟sodisconnect的区别？<br>soabort直接调用:<br>static int<br>tcp_usr_abort(struct socket *so)<br>{<br>&nbsp;&nbsp; &nbsp;int error = 0;<br>&nbsp;&nbsp; &nbsp;struct inpcb *inp = sotoinpcb(so);<br>&nbsp;&nbsp; &nbsp;struct tcpcb *tp;<br><br>&nbsp;&nbsp; &nbsp;COMMON_START();<br>&nbsp;&nbsp; &nbsp;tp = tcp_drop(tp, ECONNABORTED);<br>&nbsp;&nbsp; &nbsp;COMMON_END(PRU_ABORT);<br>}<br>sodisconnect:<br>static struct tcpcb *<br>tcp_disconnect(tp)<br>&nbsp;&nbsp; &nbsp;register struct tcpcb *tp;<br>{<br>&nbsp;&nbsp; &nbsp;struct socket *so = tp-&gt;t_inpcb-&gt;inp_socket;<br><br>&nbsp;&nbsp; &nbsp;if (tp-&gt;t_state &lt; TCPS_ESTABLISHED)<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;tp = tcp_close(tp,0);<br>&nbsp;&nbsp; &nbsp;else if ((so-&gt;so_options &amp; SO_LINGER) &amp;&amp; so-&gt;so_linger == 0)<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;tp = tcp_drop(tp, 0);<br>&nbsp;&nbsp; &nbsp;else {<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;soisdisconnecting(so);<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sbflush(&amp;so-&gt;so_rcv);<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;tp = tcp_usrclosed(tp);<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if (tp)<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(void) tcp_output(tp);<br>&nbsp;&nbsp; &nbsp;}<br>&nbsp;&nbsp; &nbsp;return (tp);<br>}<br>3:<br>tcp_close:<br>a:释放掉分片使用的queue<br>b:释放掉所有的定时器<br>C:调用in_pcbdetach释放inpcb和socket<br>d:tcpTCBFree释放tcpcb<br>struct tcpcb *<br>tcp_drop(tp, errno)<br>&nbsp;&nbsp; &nbsp;struct tcpcb *tp;<br>&nbsp;&nbsp; &nbsp;int errno;<br>{<br><br>&nbsp;&nbsp; &nbsp;if (TCPS_HAVERCVDSYN(tp-&gt;t_state)) {<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;tp-&gt;t_state = TCPS_CLOSED;<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(void) tcp_output(tp);<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;tcpstat.tcps_drops++;<br>&nbsp;&nbsp; &nbsp;} else<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;tcpstat.tcps_conndrops++;<br>&nbsp;&nbsp; &nbsp;if (errno == ETIMEDOUT &amp;&amp; tp-&gt;t_softerror)<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;errno = tp-&gt;t_softerror;<br>&nbsp;&nbsp; &nbsp;return (tcp_close(tp,errno));<br>}<br>也就是说tcp_drop可能会发包，而tcp_close只是释放的动作<br><br>4：一个packet从底层上来如何找到对于的socket？<br>会在tcp_input的时候根据<br>inp = in_pcblookup_hash(&amp;tcbinfo, sipa, ti-&gt;ti_sport,<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; dipa, ti-&gt;ti_dport, 1);<br>找到对应的inpcb，在将收到的数据<br>sbappend(&amp;so-&gt;so_rcv, bd);挂到so-&gt;so_rcv队列中。在通过sowakeup-&gt;(*so-&gt;so_sigio)(so-&gt;so_id)--&gt;httpServerNotify唤醒接受者<br><br>5：socket的isconnnected状态：<br>&nbsp;&nbsp; a:作为client发送syn并受到对应的syn+ackb包后<br>&nbsp;&nbsp; b:作为server端收到对方对自已syn+ack包的ack后<br>6：socket的isconnecting状态:<br>&nbsp;&nbsp;&nbsp; 只有调用connect函数是，也就是client发送syn时<br>7：socket的isdisconnecting状态:<br>&nbsp;&nbsp;&nbsp; 只有调用tcp_disconnect函数时<br>8：socket的isdisconnected状态：<br>&nbsp;&nbsp;&nbsp; 1：自己主动close,<br>&nbsp;&nbsp;&nbsp; 2:&nbsp; FIN_WAIT_1--&gt;FIN_WAIT_2<br>&nbsp;&nbsp;&nbsp; 3:CLOSING---&gt;TIME_WAIT<br>&nbsp;&nbsp;&nbsp; 4:TCPS_FIN_WAIT_2---&gt;TIME_WAIT','192.168.115.1','',0,'','',0,0,0),(30,1,'','//SDRAM 166MHZ<br>sarctl w 0xb8003200 0xffdf1c60<br><br><br>//200M fiber<br><br>ethctl w 0 16 0FFA<br>ethctl w 4 23 0010<br>ethctl w 5 16 0001<br>ethctl w 0 31 0000<br>ethctl w 0 23 1003<br>ethctl w 5 16 0000<br>sarctl w 0xb801805c 0x841cc0e0<br><br><br>//Force 100M Full both<br>ethctl w 0 0 2100<br>sarctl w 0xb801805c 0x84002100&nbsp;&nbsp; &nbsp;<br><br><br>//default, UTP<br>sarctl w 0xb801805c 0x841c40c6 <br><br>//reset switch<br>ethctl w 0 0 2900<br>ethctl w 0 0 2100<br><br><br><br>===========================================<br>//Detail info<br><br>2900<br>00101001 00000000<br><br>2100<br>00100001 00000000<br><br><br>w phy0_reg16=0x0FFA<br>w phy4_reg23=0x0010<br>w phy5_reg16=0x0001<br>w phy0_reg31=0x0000<br>w phy0_reg23=0x1003<br>w phy5_reg16=0x0000','192.168.115.1','',0,'','',0,0,0),(31,1,'','#define n2u16(add) ((((*(unsigned char *)(add)) &lt;&lt;8)&amp;0xff00) |(*((unsigned char *)(add) +1)))<br><br>unsigned short ipcsum(unsigned short *ptr, int len, unsigned short resid)<br>{<br>&nbsp;&nbsp; &nbsp;register unsigned int csum = resid;<br>&nbsp;&nbsp; &nbsp;int odd = 0;<br><br>&nbsp;&nbsp; &nbsp;if(len &amp; 1) odd = 1;<br>&nbsp;&nbsp; &nbsp;len = len &gt;&gt; 1;<br><br>&nbsp;&nbsp; &nbsp;for(;len &gt; 0 ; len--,ptr++){<br><br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;csum += n2u16(ptr);<br>&nbsp;&nbsp; &nbsp;}<br>&nbsp;&nbsp; &nbsp;if(odd){<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;csum += (*((unsigned char *)ptr) &lt;&lt;8) &amp; 0xff00;<br>&nbsp;&nbsp; &nbsp;}<br><br>&nbsp;&nbsp; &nbsp;/* take care of 1\'s complement */<br>&nbsp;&nbsp; &nbsp;csum = (csum &amp; 0xffff) + (csum &gt;&gt; 16);<br>&nbsp;&nbsp; &nbsp;csum = (csum &amp; 0xffff) + (csum &gt;&gt; 16);<br>&nbsp;&nbsp; &nbsp;if(csum == 0xffff)csum = 0;<br>&nbsp;&nbsp; &nbsp;return((unsigned short)csum);<br>}<br><br>u16 tcp_v4_check_sum(struct tcphdr *th,struct iphdr* ih)<br>{<br>&nbsp;&nbsp;&nbsp; unsigned short len=ih-&gt;tot_len-(ih-&gt;ihl&lt;&lt;2);<br>&nbsp;&nbsp; &nbsp;unsigned char&nbsp; phdr[12]={0};<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; memcpy(&amp;phdr[0],&nbsp; &amp;ih-&gt;saddr, 4);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; memcpy(&amp;phdr[4], &amp;ih-&gt;daddr, 4);<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;phdr[8] = 0;<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;phdr[9] =0x06;<br>&nbsp;&nbsp; &nbsp;memcpy(&amp;phdr[10], &amp;len, 2);<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;th-&gt;check=0;<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;unsigned short csum = ipcsum((unsigned short&nbsp; *)phdr, 12, 0);<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;csum = ipcsum((unsigned short&nbsp; *)th, len, csum);<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;return&nbsp; ~csum;<br>}<br>','192.168.115.1','',0,'','',0,0,0),(32,1,'','下面是当前规则表达式里可用的修饰. 括号内的名字是那些修饰符的内部 PCRE 名字. <BR><BR>i (PCRE_CASELESS)<BR>如果设置了这个修饰符, 则表达式不区分大小写. <BR><BR>m (PCRE_MULTILINE)<BR>默认的, PCRE 认为目标字符串值是单行字符串 (即使他确实包含多行). 行开始标记 (^) 只匹配字符串的开始部分, 而行结束标记 ($) 只匹配字符串的尾部,或者一个结束行(除非指定 E 修饰符). 这个和 Perl 里面一样. <BR><BR>如果设定了这个修饰符, 行开始和行结束结构分别匹配在目标字符串任何新行的当前位置后面的或者以前的, 和每一个开始和结束一样. 这个等于 Perl 里面的 /m 修饰符. 如果目标字符串没有 \"n\" 字符, 或者模式里没有 ^ 或 $ ,这个修饰符不起作用. <BR><BR>s (PCRE_DOTALL)<BR>如果设置这个修饰符, 模式里的一个\"点\"将匹配所有字符, 包括换行. 没有他, 换行将被排除在外. 这个修饰符等同于 Perl 里面的 /s 修饰符. 一个相反的类型，例如 [^a] 将总是匹配换行字符，而不管这个修饰符的限制. <BR><BR>x (PCRE_EXTENDED)<BR>如果设置这个修饰符, 模式里面的空格数句将会被全部忽略，除非用转义符或者一个字符的内部类型,还有所有字符类型外的未转义的 # 号之间的也被忽略. 这个等同于 Perl 里面的 /x 修饰符, 这样可以复杂的模式里面加入注释. 注意,只适用于数据字符. 空格字符将不会在指定的模式字符指定顺序中出现。<BR><BR>e<BR>如果设置这个修饰符, preg_replace() 将在替换值里进行正常的涉及到 \\ 的替换, 等同于在 PHP 代码里面一样, 然后用于替换搜索到的字符串. <BR><BR>只在 preg_replace() 里使用这个修饰符; 其它 PCRE 函数忽略他. <BR><BR>A (PCRE_ANCHORED)<BR>如果设置这个修饰符, 模式被强制为锚（anchored）, 也就是说, 他将值匹配搜索字符串的开始. 这个效果可以通过恰当的模式结构自身来实现,那是在 Perl 里面的唯一途径. <BR><BR>D (PCRE_DOLLAR_ENDONLY)<BR>如果设置这个修饰符,则模式里的 $ 修饰符将仅匹配目标字符串里的尾部. 没有这个修饰符, $ 字符也匹配新行的尾部 (但是不再新行的前面). 如果设置了 m 修饰符则忽略这个修饰符. 在 Perl 里面没有类似的. <BR><BR>S<BR>如果一个模式将被使用多次, 使用长些时间分析他来来提高匹配的速度. 如果使用这个修饰符，则进行额外的分析. 目前, 研究模式仅用于非锚模式，没有一个固定的开始字符. <BR><BR>U (PCRE_UNGREEDY)<BR>这个修饰符翻转数量的 \"greediness\" ，使得默认不被 greedy，但是如果你紧跟问号（?)，则可以 greedy. 这个和 Perl 不兼容. 这个也可以通过在模式里面的(?U) 修饰符得到. <BR><BR>X (PCRE_EXTRA)<BR>这个修饰符打开额外的功能，这些和 Perl 不兼容. 任何模式里面的后面带字符但没有特殊意义的反斜杠将引起错误, 从而储备这些联合用于将来的扩充. 默认的, 在 Perl 里面, 反斜杠后面有无意义的字符被当成正常的 literal. 目前还没有其他的控制特征','192.168.115.1','',0,'','',0,0,0),(33,1,'a:1:{i:33;s:5:\"csope\";}','<DIV>\r\n<P>我们假设我们要阅读的代码放在 D:\\src\\myproject 下。然后打开命令行，进入源代码所在的目录，为 cscope 建立搜索文件列表。在命令行中执行以下命令：</P>\r\n<P>dir /s /b *.c *.h&nbsp; &gt; cscope.files</P>\r\n<P>然后执行以下命令：</P><PRE>cscope -b</PRE>\r\n<P>执行结束后你可以在当前目录下发现 cscope.out 文件，这就是 cscope 建立的符号数据库。</P>\r\n<H3 id=content_1_6>浏览源代码 <A class=anchor_super id=cfd8c77a title=cfd8c77a href=\"http://www.idv2.com/vimwiki/index.php?cscope#cfd8c77a\"><FONT color=#800080>†</FONT></A></H3>\r\n<P>使用 gvim 打开你的源代码目录中任意一个C程序文件。然后在gvim中执行如下命令：</P><PRE>:cscope add D:\\src\\myproject\\cscope.out</PRE>\r\n<P>由于在 gvim 中可以使用命令缩写，因此上面的命令可以写成：</P><PRE>:cs a D:\\src\\myproject\\cscope.out</PRE>\r\n<P>这样就打开了刚刚建立的符号数据库。通过下面的命令可以检查数据库连接的存在。</P><PRE>:cscope show</PRE>\r\n<P>该命令可以缩写为</P><PRE>:cs s</PRE>\r\n<P>现在将光标移动到源代码中的某个函数名上，依次按下一下组合键：</P><PRE>&lt;C-\\&gt;s</PRE>\r\n<P>稍等片刻之后你会在屏幕下放看到如下的字样<A class=note_super id=notetext_1 title=如果光标处的标识符在整个工程中恰好只出现了一次，则不会显示该列表，而是直接跳转到对应的地方 href=\"http://www.idv2.com/vimwiki/index.php?cscope#notefoot_1\"><FONT color=#800080>*1</FONT></A>：</P><PRE>Cscope tag: display\r\n   #   line  filename / context / line\r\n   1    342  D:\\src\\myproject\\src\\global.h &lt;&lt;GLOBAL&gt;&gt;\r\n             void display(void );\r\n   2    616  D:\\src\\myproject\\src\\command.c &lt;&lt;changestring&gt;&gt;\r\n             display();\r\n   3    138  D:\\src\\myproject\\src\\display.c &lt;&lt;display&gt;&gt;\r\n             display(void )\r\n   4    385  D:\\src\\myproject\\src\\main.c &lt;&lt;main.c&gt;&gt;\r\n             display();\r\n   5    652  D:\\src\\myproject\\src\\main.c &lt;&lt;main.c&gt;&gt;\r\n             display();\r\n   6    663  D:\\src\\myproject\\src\\main.c &lt;&lt;main.c&gt;&gt;\r\n             display();\r\nEnter nr or choice (&lt;CR&gt; to abort):</PRE>\r\n<P>这里显示出的就是整个工程中使用到了 display 这个标识符的位置。此时输入 4，回车，即可跳转到 main.c 的 385 行调用 display() 函数的地方进行浏览。浏览结束后按 &lt;C-T&gt; 或者 &lt;C-O&gt; 可以回到跳转前的位置。</P>\r\n<P>然后将光标移动到源代码某个函数名上，迅速地依次安下面的组合键：</P><PRE>&lt;C-@&gt;s</PRE>\r\n<P>其中 &lt;C-@&gt; 按 Ctrl-2 即可输入。同样，屏幕上出现了一排结果，选择之后你会发现，跳转到的文件将在水平方向的新窗口中打开。</P>\r\n<P>然后将光标移动到源代码某个函数名上，迅速地依次安下面的组合键：</P><PRE>&lt;C-@&gt;&lt;C-@&gt;s</PRE>\r\n<P>选择之后你会发现，跳转到的文件将在垂直方向的新窗口中打开。</P>\r\n<P>以上我们简单介绍了cscope的使用方法，其中我们只用到了一个 s 命令，即跟在 &lt;C-\\&gt; 和 &lt;C-@&gt; 后面的 s 键。同样，我们可以使用以下的功能键实现不同的跳转功能。</P>\r\n<UL class=list1 style=\"PADDING-LEFT: 16px; MARGIN-LEFT: 16px\">\r\n<LI><STRONG>c</STRONG>: 查找该函数被调用的位置 \r\n<LI><STRONG>d</STRONG>: 查找该函数调用了哪些函数 \r\n<LI><STRONG>e</STRONG>: 查找指定的正规表达式 \r\n<LI><STRONG>f</STRONG>: 查找指定的文件 \r\n<LI><STRONG>g</STRONG>: 查找指定标识符的定义位置 \r\n<LI><STRONG>i</STRONG>: 查找该文件在哪些地方被包含 \r\n<LI><STRONG>s</STRONG>: 查找指定标识符的使用位置 \r\n<LI><STRONG>t</STRONG>: 查找指定的文本字符串</LI></UL>\r\n<DIV class=jumpmenu><a href=\"http://www.idv2.com/vimwiki/index.php?cscope#navigator\" target=\"_blank\"><FONT color=#800080>↑</FONT></A></DIV>\r\n<H3 id=content_1_7>命令行使用说明 <A class=anchor_super id=a6258797 title=a6258797 href=\"http://www.idv2.com/vimwiki/index.php?cscope#a6258797\"><FONT color=#800080>†</FONT></A></H3>\r\n<P>除了上述通过快捷键映射的方式使用cscope之外，也可以直接在gvim命令行中使用cscope。这样就可以随意定义查找字符串，而不必局限于源代码中已有的标识符。命令格式如下：</P><PRE>:cscope find &lt;c|d|e|f|g|i|s|t&gt; &lt;关键字&gt;</PRE>\r\n<P>该命令可以缩写为</P><PRE>:cs f &lt;c|d|e|f|g|i|s|t&gt; &lt;关键字&gt;</PRE>\r\n<P>一个比较实用的技巧是使用cscope打开文件。使用以下命令即可直接打开名为display.c的文件，而不必先切换到display.c所在的目录。</P><PRE>:cs f f display.c</PRE>\r\n<P>cscope也支持正规表达式。如果记不清某个函数的名称，可以用下面的方式来找到该函数的定义位置。</P><PRE>:cs f g .*SetConfiguration.*</PRE><PRE><UL class=list1 style=\"PADDING-LEFT: 16px; MARGIN-LEFT: 16px\"><LI>Cscope官方主页, <A href=\"http://cscope.sourceforge.net/\" rel=nofollow><FONT color=#800080>http://cscope.sourceforge.net/</FONT></A> <LI>The Vim/Cscope tutorial, <A href=\"http://cscope.sourceforge.net/cscope_vim_tutorial.html\" rel=nofollow><FONT color=#0000ff>http://cscope.sourceforge.net/cscope_vim_tutorial.html</FONT></A> <LI>Cscope on Win32, <A href=\"http://iamphet.nm.ru/cscope/\" rel=nofollow><FONT color=#0000ff>http://iamphet.nm.ru/cscope/</FONT></A> <LI>Vim中关于 cscope 的帮助，使用 :help cscope 命令查看</LI></UL></PRE></DIV>','192.168.115.1','a:0:{}',1266886633,'','',0,0,0),(34,1,'','<DIV>/\\~!@#$%^&amp;*()_+|&lt;&gt;?:\";;\'</DIV>','192.168.115.1','',0,'','',0,0,0),(35,1,'a:1:{i:34;s:6:\"jquery\";}','<DIV><SPAN style=\"COLOR: #000000\">Attribute：<BR>$(”p”).addClass(css中定义的样式类型);&nbsp;给某个元素添加样式<BR>$(”img”).attr({src:”test.jpg”,alt:”test&nbsp;Image”});&nbsp;给某个元素添加属性</SPAN><SPAN style=\"COLOR: #000000\">/</SPAN><SPAN style=\"COLOR: #000000\">值，参数是map</SPAN><SPAN style=\"COLOR: #000000\"><BR></SPAN><SPAN style=\"COLOR: #000000\">$(”img”).attr(”src”,”test.jpg”);&nbsp;给某个元素添加属性</SPAN><SPAN style=\"COLOR: #000000\">/</SPAN><SPAN style=\"COLOR: #000000\">值</SPAN><SPAN style=\"COLOR: #000000\"><BR></SPAN><SPAN style=\"COLOR: #000000\">$(”img”).attr(”title”,&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">()&nbsp;{&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">return</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">this</SPAN><SPAN style=\"COLOR: #000000\">.src&nbsp;});&nbsp;给某个元素添加属性</SPAN><SPAN style=\"COLOR: #000000\">/</SPAN><SPAN style=\"COLOR: #000000\">值</SPAN><SPAN style=\"COLOR: #000000\"><BR></SPAN><SPAN style=\"COLOR: #000000\">$(”元素名称”).html();&nbsp;获得该元素内的内容（元素，文本等）<BR>$(”元素名称”).html(”</SPAN><SPAN style=\"COLOR: #000000\">&lt;</SPAN><SPAN style=\"COLOR: #000000\">b</SPAN><SPAN style=\"COLOR: #000000\">&gt;</SPAN><SPAN style=\"COLOR: #0000ff\">new</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;stuff</SPAN><SPAN style=\"COLOR: #000000\">&lt;</SPAN><SPAN style=\"COLOR: #000000\">/</SPAN><SPAN style=\"COLOR: #000000\">b&gt;”);&nbsp;给某元素设置内容</SPAN><SPAN style=\"COLOR: #000000\"><BR></SPAN><SPAN style=\"COLOR: #000000\">$(”元素名称”).removeAttr(”属性名称”)&nbsp;给某元素删除指定的属性以及该属性的值<BR>$(”元素名称”).removeClass(”class”)&nbsp;给某元素删除指定的样式<BR>$(”元素名称”).text();&nbsp;获得该元素的文本<BR>$(”元素名称”).text(value);&nbsp;设置该元素的文本值为value<BR>$(”元素名称”).toggleClass(class)&nbsp;当元素存在参数中的样式的时候取消,如果不存在就设置此样式<BR>$(”input元素名称”).val();&nbsp;获取input元素的值<BR>$(”input元素名称”).val(value);&nbsp;设置input元素的值为value<BR>Manipulation：<BR>$(”元素名称”).after(content);&nbsp;在匹配元素后面添加内容<BR>$(”元素名称”).append(content);&nbsp;将content作为元素的内容插入到该元素的后面<BR>$(”元素名称”).appendTo(content);&nbsp;在content后接元素<BR>$(”元素名称”).before(content);&nbsp;与after方法相反<BR>$(”元素名称”).clone(布尔表达式)&nbsp;当布尔表达式为真时，克隆元素（无参时，当作true处理）<BR>$(”元素名称”).empty()&nbsp;将该元素的内容设置为空<BR>$(”元素名称”).insertAfter(content);&nbsp;将该元素插入到content之后<BR>$(”元素名称”).insertBefore(content);&nbsp;将该元素插入到content之前<BR>$(”元素”).prepend(content);&nbsp;将content作为该元素的一部分，放到该元素的最前面<BR>$(”元素”).prependTo(content);&nbsp;将该元素作为content的一部分，放content的最前面<BR>$(”元素”).remove();&nbsp;删除所有的指定元素<BR>$(”元素”).remove(”exp”);&nbsp;删除所有含有exp的元素<BR>$(”元素”).wrap(”html”);&nbsp;用html来包围该元素<BR>$(”元素”).wrap(element);&nbsp;用element来包围该元素<BR>Traversing：<BR>add(expr)<BR>add(html)<BR>add(elements)<BR>children(expr)<BR>contains(str)<BR>end()<BR>filter(expression)<BR>filter(filter)<BR>find(expr)<BR>is(expr)<BR>next(expr)<BR>not(el)<BR>not(expr)<BR>not(elems)<BR>parent(expr)<BR>parents(expr)<BR>prev(expr)<BR>siblings(expr)<BR><BR>Core：<BR>$(html).appendTo(”body”)&nbsp;相当于在body中写了一段html代码<BR>$(elems)&nbsp;获得DOM上的某个元素<BR>$(</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(){……..});&nbsp;执行一个函数<BR>$(”div&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">&gt;</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;p”).css(”border”,&nbsp;“1px&nbsp;solid&nbsp;gray”);&nbsp;查找所有div的子节点p，添加样式<BR>$(”input:radio”,&nbsp;document.forms[</SPAN><SPAN style=\"COLOR: #000000\">0</SPAN><SPAN style=\"COLOR: #000000\">])&nbsp;在当前页面的第一个表单中查找所有的单选按钮<BR>$.extend(prop)&nbsp;prop是一个jquery对象，<BR>举例：<BR>jQuery.extend({<BR>min:&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(a,&nbsp;b)&nbsp;{&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">return</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;a&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">&lt;</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;b&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">?</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;a&nbsp;:&nbsp;b;&nbsp;},<BR>max:&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(a,&nbsp;b)&nbsp;{&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">return</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;a&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">&gt;</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;b&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">?</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;a&nbsp;:&nbsp;b;&nbsp;}<BR>});<BR>jQuery(&nbsp;expression,&nbsp;[context]&nbsp;)&nbsp;—$(&nbsp;expression,&nbsp;[context]);&nbsp;在默认情况下，$()查询的是当前HTML文档中的DOM元素。<BR><BR>each(&nbsp;callback&nbsp;)&nbsp;以每一个匹配的元素作为上下文来执行一个函数<BR>举例：</SPAN><SPAN style=\"COLOR: #000000\">1</SPAN><SPAN style=\"COLOR: #000000\"><BR>$(”span”).click(</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">){<BR>$(”li”).each(</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(){<BR>$(</SPAN><SPAN style=\"COLOR: #0000ff\">this</SPAN><SPAN style=\"COLOR: #000000\">).toggleClass(”example”);<BR>});<BR>});<BR>举例：</SPAN><SPAN style=\"COLOR: #000000\">2</SPAN><SPAN style=\"COLOR: #000000\"><BR>$(”button”).click(</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;()&nbsp;{<BR>$(”div”).each(</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;(index,&nbsp;domEle)&nbsp;{<BR></SPAN><SPAN style=\"COLOR: #008000\">//</SPAN><SPAN style=\"COLOR: #008000\">&nbsp;domEle&nbsp;==&nbsp;this</SPAN><SPAN style=\"COLOR: #008000\"><BR></SPAN><SPAN style=\"COLOR: #000000\">$(domEle).css(”backgroundColor”,&nbsp;“yellow”);<BR></SPAN><SPAN style=\"COLOR: #0000ff\">if</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;($(</SPAN><SPAN style=\"COLOR: #0000ff\">this</SPAN><SPAN style=\"COLOR: #000000\">).is(”#stop”))&nbsp;{<BR>$(”span”).text(”Stopped&nbsp;at&nbsp;div&nbsp;index&nbsp;#”&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">+</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;index);<BR></SPAN><SPAN style=\"COLOR: #0000ff\">return</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">false</SPAN><SPAN style=\"COLOR: #000000\">;<BR>}<BR>});<BR>});<BR><BR><BR>jQuery&nbsp;Event:<BR><BR>ready(fn);&nbsp;$(document).ready()注意在body中没有onload事件，否则该函数不能执行。在每个页面中可以<BR>有很多个函数被加载执行，按照fn的顺序来执行。<BR>bind(&nbsp;type,&nbsp;[data],&nbsp;fn&nbsp;)&nbsp;为每一个匹配元素的特定事件（像click）绑定一个或多个事件处理器函数。可能的事件属性有：blur,&nbsp;focus,&nbsp;load,&nbsp;resize,&nbsp;scroll,&nbsp;unload,&nbsp;click,&nbsp;dblclick,&nbsp;mousedown,&nbsp;mouseup,&nbsp;mousemove,<BR>mouseover,&nbsp;mouseout,&nbsp;mouseenter,&nbsp;mouseleave,&nbsp;change,&nbsp;select,&nbsp;submit,&nbsp;keydown,&nbsp;keypress,<BR>keyup,&nbsp;error<BR>one(&nbsp;type,&nbsp;[data],&nbsp;fn&nbsp;)&nbsp;为每一个匹配元素的特定事件（像click）绑定一个或多个事件处理器函数。在每个对<BR>象上，这个事件处理函数只会被执行一次。其他规则与bind()函数相同。<BR><BR>trigger(&nbsp;type,&nbsp;[data]&nbsp;)&nbsp;在每一个匹配的元素上触发某类事件。<BR>triggerHandler(&nbsp;type,&nbsp;[data]&nbsp;)&nbsp;这一特定方法会触发一个元素上特定的事件(指定一个事件类型)，同时取消浏览器对此事件的默认行动<BR>unbind(&nbsp;[type],&nbsp;[data]&nbsp;)&nbsp;反绑定，从每一个匹配的元素中删除绑定的事件。<BR>$(”p”).unbind()&nbsp;移除所有段落上的所有绑定的事件<BR>$(”p”).unbind(&nbsp;“click”&nbsp;)&nbsp;移除所有段落上的click事件<BR>hover(&nbsp;over,&nbsp;out&nbsp;)&nbsp;over,out都是方法,&nbsp;当鼠标移动到一个匹配的元素上面时，会触发指定的第一个函数。当鼠标移出这个元素时，会触发指定的第二个函数。<BR>$(”p”).hover(</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(){<BR>$(</SPAN><SPAN style=\"COLOR: #0000ff\">this</SPAN><SPAN style=\"COLOR: #000000\">).addClass(”over”);<BR>},<BR></SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(){<BR>$(</SPAN><SPAN style=\"COLOR: #0000ff\">this</SPAN><SPAN style=\"COLOR: #000000\">).addClass(”out”);<BR>}<BR>);<BR><BR>toggle(&nbsp;fn,&nbsp;fn&nbsp;)&nbsp;如果点击了一个匹配的元素，则触发指定的第一个函数，当再次点击同一元素时，则触发指定的第二个函数。<BR>$(”p”).toggle(</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(){<BR>$(</SPAN><SPAN style=\"COLOR: #0000ff\">this</SPAN><SPAN style=\"COLOR: #000000\">).addClass(”selected”);<BR>},<BR></SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(){<BR>$(</SPAN><SPAN style=\"COLOR: #0000ff\">this</SPAN><SPAN style=\"COLOR: #000000\">).removeClass(”selected”);<BR>}<BR>);<BR><BR>元素事件列表说明<BR>注：不带参数的函数，其参数为可选的&nbsp;fn。jQuery不支持form元素的reset事件。<BR>事件&nbsp;描述&nbsp;支持元素或对象<BR>blur(&nbsp;)&nbsp;元素失去焦点&nbsp;a,&nbsp;input,&nbsp;textarea,&nbsp;button,&nbsp;select,&nbsp;label,&nbsp;map,&nbsp;area<BR>change(&nbsp;)&nbsp;用户改变域的内容&nbsp;input,&nbsp;textarea,&nbsp;select<BR>click(&nbsp;)&nbsp;鼠标点击某个对象&nbsp;几乎所有元素<BR>dblclick(&nbsp;)&nbsp;鼠标双击某个对象&nbsp;几乎所有元素<BR>error(&nbsp;)&nbsp;当加载文档或图像时发生某个错误&nbsp;window,&nbsp;img<BR>focus(&nbsp;)&nbsp;元素获得焦点&nbsp;a,&nbsp;input,&nbsp;textarea,&nbsp;button,&nbsp;select,&nbsp;label,&nbsp;map,&nbsp;area<BR>keydown(&nbsp;)&nbsp;某个键盘的键被按下&nbsp;几乎所有元素<BR>keypress(&nbsp;)&nbsp;某个键盘的键被按下或按住&nbsp;几乎所有元素<BR>keyup(&nbsp;)&nbsp;某个键盘的键被松开&nbsp;几乎所有元素<BR>load(&nbsp;fn&nbsp;)&nbsp;某个页面或图像被完成加载&nbsp;window,&nbsp;img<BR>mousedown(&nbsp;fn&nbsp;)&nbsp;某个鼠标按键被按下&nbsp;几乎所有元素<BR>mousemove(&nbsp;fn&nbsp;)&nbsp;鼠标被移动&nbsp;几乎所有元素<BR>mouseout(&nbsp;fn&nbsp;)&nbsp;鼠标从某元素移开&nbsp;几乎所有元素<BR>mouseover(&nbsp;fn&nbsp;)&nbsp;鼠标被移到某元素之上&nbsp;几乎所有元素<BR>mouseup(&nbsp;fn&nbsp;)&nbsp;某个鼠标按键被松开&nbsp;几乎所有元素<BR>resize(&nbsp;fn&nbsp;)&nbsp;窗口或框架被调整尺寸&nbsp;window,&nbsp;iframe,&nbsp;frame<BR>scroll(&nbsp;fn&nbsp;)&nbsp;滚动文档的可视部分时&nbsp;window<BR>select(&nbsp;)&nbsp;文本被选定&nbsp;document,&nbsp;input,&nbsp;textarea<BR>submit(&nbsp;)&nbsp;提交按钮被点击&nbsp;form<BR>unload(&nbsp;fn&nbsp;)&nbsp;用户退出页面&nbsp;window<BR><BR>JQuery&nbsp;Ajax&nbsp;方法说明:<BR><BR>load(&nbsp;url,&nbsp;[data],&nbsp;[callback]&nbsp;)&nbsp;装入一个远程HTML内容到一个DOM结点。<BR>$(”#feeds”).load(”feeds.html”);&nbsp;将feeds.html文件载入到id为feeds的div中<BR>$(”#feeds”).load(”feeds.php”,&nbsp;{limit:&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">25</SPAN><SPAN style=\"COLOR: #000000\">},&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(){<BR>alert(”The&nbsp;last&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">25</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;entries&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">in</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;the&nbsp;feed&nbsp;have&nbsp;been&nbsp;loaded”);<BR>});<BR><BR>jQuery.get(&nbsp;url,&nbsp;[data],&nbsp;[callback]&nbsp;)&nbsp;使用GET请求一个页面。<BR>$.get(”test.cgi”,&nbsp;{&nbsp;name:&nbsp;“John”,&nbsp;time:&nbsp;“2pm”&nbsp;},&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(data){<BR>alert(”Data&nbsp;Loaded:&nbsp;”&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">+</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;data);<BR>});<BR><BR>jQuery.getJSON(&nbsp;url,&nbsp;[data],&nbsp;[callback]&nbsp;)&nbsp;使用GET请求JSON数据。<BR>$.getJSON(”test.js”,&nbsp;{&nbsp;name:&nbsp;“John”,&nbsp;time:&nbsp;“2pm”&nbsp;},&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(json){<BR>alert(”JSON&nbsp;Data:&nbsp;”&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">+</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;json.users[</SPAN><SPAN style=\"COLOR: #000000\">3</SPAN><SPAN style=\"COLOR: #000000\">].name);<BR>});<BR><BR>jQuery.getScript(&nbsp;url,&nbsp;[callback]&nbsp;)&nbsp;使用GET请求javascript文件并执行。<BR>$.getScript(”test.js”,&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(){<BR>alert(”Script&nbsp;loaded&nbsp;and&nbsp;executed.”);<BR>});<BR>jQuery.post(&nbsp;url,&nbsp;[data],&nbsp;[callback],&nbsp;[type]&nbsp;)&nbsp;使用POST请求一个页面。<BR><BR>ajaxComplete(&nbsp;callback&nbsp;)&nbsp;当一个AJAX请求结束后，执行一个函数。这是一个Ajax事件<BR>$(”#msg”).ajaxComplete(</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(request,&nbsp;settings){<BR>$(</SPAN><SPAN style=\"COLOR: #0000ff\">this</SPAN><SPAN style=\"COLOR: #000000\">).append(”</SPAN><SPAN style=\"COLOR: #000000\">&lt;</SPAN><SPAN style=\"COLOR: #000000\">li</SPAN><SPAN style=\"COLOR: #000000\">&gt;</SPAN><SPAN style=\"COLOR: #000000\">Request&nbsp;Complete.</SPAN><SPAN style=\"COLOR: #000000\">&lt;</SPAN><SPAN style=\"COLOR: #000000\">/</SPAN><SPAN style=\"COLOR: #000000\">li&gt;”);</SPAN><SPAN style=\"COLOR: #000000\"><BR></SPAN><SPAN style=\"COLOR: #000000\">});<BR>ajaxError(&nbsp;callback&nbsp;)&nbsp;当一个AJAX请求失败后，执行一个函数。这是一个Ajax事件<BR>$(”#msg”).ajaxError(</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(request,&nbsp;settings){<BR>$(</SPAN><SPAN style=\"COLOR: #0000ff\">this</SPAN><SPAN style=\"COLOR: #000000\">).append(”</SPAN><SPAN style=\"COLOR: #000000\">&lt;</SPAN><SPAN style=\"COLOR: #000000\">li</SPAN><SPAN style=\"COLOR: #000000\">&gt;</SPAN><SPAN style=\"COLOR: #000000\">Error&nbsp;requesting&nbsp;page&nbsp;”&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">+</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;settings.url&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">+</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;“</SPAN><SPAN style=\"COLOR: #000000\">&lt;</SPAN><SPAN style=\"COLOR: #000000\">/</SPAN><SPAN style=\"COLOR: #000000\">li&gt;”);</SPAN><SPAN style=\"COLOR: #000000\"><BR></SPAN><SPAN style=\"COLOR: #000000\">});<BR><BR></SPAN>\r\n<P>&nbsp;</P>\r\n<P>&nbsp;</P>\r\n<DIV class=cnblogs_code onclick=\"cnblogs_code_show(\'6357699d-82fd-46d4-9a43-4539d0a3e289\')\"><IMG class=code_img_closed id=code_img_closed_6357699d-82fd-46d4-9a43-4539d0a3e289 style=\"DISPLAY: none\" alt=\"\" src=\"http://images.cnblogs.com/OutliningIndicators/ContractedBlock.gif\"><IMG class=code_img_opened id=code_img_opened_6357699d-82fd-46d4-9a43-4539d0a3e289 onclick=\"cnblogs_code_hide(\'6357699d-82fd-46d4-9a43-4539d0a3e289\',event)\" src=\"http://images.cnblogs.com/OutliningIndicators/ExpandedBlockStart.gif\"><SPAN class=cnblogs_code_collapse>代码</SPAN> \r\n<DIV id=cnblogs_code_open_6357699d-82fd-46d4-9a43-4539d0a3e289>\r\n<DIV><!--<br/ /><br/ />Code highlighting produced by Actipro CodeHighlighter (freeware)<br/ />http://www.CodeHighlighter.com/<br/ /><br/ />--><SPAN style=\"COLOR: #000000\">ajaxSend(&nbsp;callback&nbsp;)&nbsp;在一个AJAX请求发送时，执行一个函数。这是一个Ajax事件<BR>$(”#msg”).ajaxSend(</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(evt,&nbsp;request,&nbsp;settings){<BR>$(</SPAN><SPAN style=\"COLOR: #0000ff\">this</SPAN><SPAN style=\"COLOR: #000000\">).append(”</SPAN><SPAN style=\"COLOR: #000000\">&lt;</SPAN><SPAN style=\"COLOR: #000000\">li</SPAN><SPAN style=\"COLOR: #000000\">&lt;</SPAN><SPAN style=\"COLOR: #000000\">Starting&nbsp;request&nbsp;at&nbsp;”&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">+</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;settings.url<BR></SPAN><SPAN style=\"COLOR: #000000\">+</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;“</SPAN><SPAN style=\"COLOR: #000000\">&lt;</SPAN><SPAN style=\"COLOR: #000000\">/</SPAN><SPAN style=\"COLOR: #000000\">li&lt;”);</SPAN><SPAN style=\"COLOR: #000000\"><BR></SPAN><SPAN style=\"COLOR: #000000\">});<BR><BR>ajaxStart(&nbsp;callback&nbsp;)&nbsp;在一个AJAX请求开始但还没有激活时，执行一个函数。这是一个Ajax事件<BR>当AJAX请求开始(并还没有激活时)显示loading信息<BR>$(”#loading”).ajaxStart(</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(){<BR>$(</SPAN><SPAN style=\"COLOR: #0000ff\">this</SPAN><SPAN style=\"COLOR: #000000\">).show();<BR>});<BR><BR>ajaxStop(&nbsp;callback&nbsp;)&nbsp;当所有的AJAX都停止时，执行一个函数。这是一个Ajax事件<BR>当所有AJAX请求都停止时，隐藏loading信息。<BR>$(”#loading”).ajaxStop(</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(){<BR>$(</SPAN><SPAN style=\"COLOR: #0000ff\">this</SPAN><SPAN style=\"COLOR: #000000\">).hide();<BR>});<BR><BR>ajaxSuccess(&nbsp;callback&nbsp;)&nbsp;当一个AJAX请求成功完成后，执行一个函数。这是一个Ajax事件<BR>当AJAX请求成功完成时，显示信息。<BR>$(”#msg”).ajaxSuccess(</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(evt,&nbsp;request,&nbsp;settings){<BR>$(</SPAN><SPAN style=\"COLOR: #0000ff\">this</SPAN><SPAN style=\"COLOR: #000000\">).append(”</SPAN><SPAN style=\"COLOR: #000000\">&lt;</SPAN><SPAN style=\"COLOR: #000000\">li</SPAN><SPAN style=\"COLOR: #000000\">&gt;</SPAN><SPAN style=\"COLOR: #000000\">Successful&nbsp;Request</SPAN><SPAN style=\"COLOR: #000000\">!&lt;</SPAN><SPAN style=\"COLOR: #000000\">/</SPAN><SPAN style=\"COLOR: #000000\">li&gt;”);</SPAN><SPAN style=\"COLOR: #000000\"><BR></SPAN><SPAN style=\"COLOR: #000000\">});<BR><BR>jQuery.ajaxSetup(&nbsp;options&nbsp;)&nbsp;为所有的AJAX请求进行全局设置。查看$.ajax函数取得所有选项信息。<BR>设置默认的全局AJAX请求选项。<BR>$.ajaxSetup({<BR>url:&nbsp;“</SPAN><SPAN style=\"COLOR: #000000\">/</SPAN><SPAN style=\"COLOR: #000000\">xmlhttp</SPAN><SPAN style=\"COLOR: #000000\">/</SPAN><SPAN style=\"COLOR: #000000\">”,<BR>global:&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">false</SPAN><SPAN style=\"COLOR: #000000\">,<BR>type:&nbsp;“POST”<BR>});<BR>$.ajax({&nbsp;data:&nbsp;myData&nbsp;});<BR><BR>serialize(&nbsp;)&nbsp;以名称和值的方式连接一组input元素。实现了正确表单元素序列<BR></SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;showValues()&nbsp;{<BR></SPAN><SPAN style=\"COLOR: #0000ff\">var</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;str&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;$(”form”).serialize();<BR>$(”#results”).text(str);<BR>}<BR>$(”:checkbox,&nbsp;:radio”).click(showValues);<BR>$(”select”).change(showValues);<BR>showValues();<BR><BR>serializeArray(&nbsp;)&nbsp;连接所有的表单和表单元素(类似于.serialize()方法)，但是返回一个JSON数据格式。<BR>从form中取得一组值，显示出来<BR></SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;showValues()&nbsp;{<BR></SPAN><SPAN style=\"COLOR: #0000ff\">var</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;fields&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;$(”:input”).serializeArray();<BR>alert(fields);<BR>$(”#results”).empty();<BR>jQuery.each(fields,&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(i,&nbsp;field){<BR>$(”#results”).append(field.value&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">+</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;”&nbsp;“);<BR>});<BR>}<BR>$(”:checkbox,&nbsp;:radio”).click(showValues);<BR>$(”select”).change(showValues);<BR>showValues();<BR><BR>JQuery&nbsp;Effects&nbsp;方法说明<BR><BR>show(&nbsp;)&nbsp;显示隐藏的匹配元素。<BR>show(&nbsp;speed,&nbsp;[callback]&nbsp;)&nbsp;以优雅的动画显示所有匹配的元素，并在显示完成后可选地触发一个回调函数。<BR>hide(&nbsp;)&nbsp;隐藏所有的匹配元素。<BR>hide(&nbsp;speed,&nbsp;[callback]&nbsp;)&nbsp;以优雅的动画隐藏所有匹配的元素，并在显示完成后可选地触发一个回调函数<BR>toggle(&nbsp;)&nbsp;切换元素的可见状态。如果元素是可见的，切换为隐藏的；如果元素是隐藏的，<BR>切换为可见的。<BR>slideDown(&nbsp;speed,&nbsp;[callback]&nbsp;)&nbsp;通过高度变化（向下增大）来动态地显示所有匹配的元素，在显示完成后可选<BR>地触发一个回调函数。这个动画效果只调整元素的高度，可以使匹配的元素以<BR>“滑动”的方式显示出来。<BR>slideUp(&nbsp;speed,&nbsp;[callback]&nbsp;)&nbsp;通过高度变化（向上减小）来动态地隐藏所有匹配的元素，在隐藏完成后可选地<BR>触发一个回调函数。这个动画效果只调整元素的高度，可以使匹配的元素以”滑动”<BR>的方式隐藏起来。<BR>slideToggle(&nbsp;speed,&nbsp;[callback]&nbsp;)&nbsp;通过高度变化来切换所有匹配元素的可见性，并在切换完成后可选地触发一个回<BR>调函数。&nbsp;这个动画效果只调整元素的高度，可以使匹配的元素以”滑动”的方式隐<BR>藏或显示。<BR>fadeIn(&nbsp;speed,&nbsp;[callback]&nbsp;)&nbsp;通过不透明度的变化来实现所有匹配元素的淡入效果，并在动画完成后可选地触<BR>发一个回调函数。&nbsp;这个动画只调整元素的不透明度，也就是说所有匹配的元素的<BR>高度和宽度不会发生变化。<BR>fadeOut(&nbsp;speed,&nbsp;[callback]&nbsp;)&nbsp;通过不透明度的变化来实现所有匹配元素的淡出效果，并在动画完成后可选地触<BR>发一个回调函数。&nbsp;这个动画只调整元素的不透明度，也就是说所有匹配的元素的<BR>高度和宽度不会发生变化。<BR>fadeTo(&nbsp;speed,&nbsp;opacity,&nbsp;[callback]&nbsp;)&nbsp;把所有匹配元素的不透明度以渐进方式调整到指定的不透明度，并在动画完成<BR>后可选地触发一个回调函数。&nbsp;这个动画只调整元素的不透明度，也就是说所<BR>有匹配的元素的高度和宽度不会发生变化。<BR>stop(&nbsp;)&nbsp;停止所有匹配元素当前正在运行的动画。如果有动画处于队列当中，他们就会立即开始。<BR>queue(&nbsp;)&nbsp;取得第一个匹配元素的动画序列的引用(返回一个内容为函数的数组)<BR>queue(&nbsp;callback&nbsp;)&nbsp;在每一个匹配元素的事件序列的末尾添加一个可执行函数，作为此元素的事件函数<BR>queue(&nbsp;queue&nbsp;)&nbsp;以一个新的动画序列代替所有匹配元素的原动画序列<BR>dequeue(&nbsp;)&nbsp;执行并移除动画序列前端的动画<BR>animate(&nbsp;params,&nbsp;[duration],&nbsp;[easing],&nbsp;[callback]&nbsp;)&nbsp;用于创建自定义动画的函数。<BR>animate(&nbsp;params,&nbsp;options&nbsp;)&nbsp;创建自定义动画的另一个方法。作用同上。<BR><BR>JQuery&nbsp;Traversing&nbsp;方法说明<BR><BR>eq(&nbsp;index&nbsp;)&nbsp;从匹配的元素集合中取得一个指定位置的元素，index从0开始<BR>filter(&nbsp;expr&nbsp;)&nbsp;返回与指定表达式匹配的元素集合，可以使用”,”号分割多个expr，用于实现多个条件筛选<BR>filter(&nbsp;fn&nbsp;)&nbsp;利用一个特殊的函数来作为筛选条件移除集合中不匹配的元素。<BR>is(&nbsp;expr&nbsp;)&nbsp;用一个表达式来检查当前选择的元素集合，如果其中至少有一个元素符合这个给定的<BR>表达式就返回true。<BR>map(&nbsp;callback&nbsp;)&nbsp;将jQuery对象中的一组元素利用callback方法转换其值，然后添加到一个jQuery数组中。<BR>not(&nbsp;expr&nbsp;)&nbsp;从匹配的元素集合中删除与指定的表达式匹配的元素。<BR>slice(&nbsp;start,&nbsp;[end]&nbsp;)&nbsp;从匹配元素集合中取得一个子集，和内建的数组的slice方法相同。<BR>add(&nbsp;expr&nbsp;)&nbsp;把与表达式匹配的元素添加到jQuery对象中。<BR>children(&nbsp;[expr]&nbsp;)&nbsp;取得一个包含匹配的元素集合中每一个元素的所有子元素的元素集合。可选的过滤器<BR>将使这个方法只匹配符合的元素(只包括元素节点，不包括文本节点)。<BR>contents(&nbsp;)&nbsp;取得一个包含匹配的元素集合中每一个元素的所有子孙节点的集合(只包括元素节点，不<BR>包括文本节点)，如果元素为iframe，则取得其中的文档元素<BR>find(&nbsp;expr&nbsp;)&nbsp;搜索所有与指定表达式匹配的元素。<BR>next(&nbsp;[expr]&nbsp;)&nbsp;取得一个包含匹配的元素集合中每一个元素紧邻的后面同辈元素的元素集合。<BR>nextAll(&nbsp;[expr]&nbsp;)&nbsp;取得一个包含匹配的元素集合中每一个元素所有的后面同辈元素的元素集合<BR>parent(&nbsp;[expr]&nbsp;)&nbsp;取得一个包含着所有匹配元素的唯一父元素的元素集合。<BR>parents(&nbsp;[expr]&nbsp;)&nbsp;取得一个包含着所有匹配元素的唯一祖先元素的元素集合（不包含根元素）。<BR>prev(&nbsp;[expr]&nbsp;)&nbsp;取得一个包含匹配的元素集合中每一个元素紧邻的前一个同辈元素的元素集合。<BR>prevAll(&nbsp;[expr]&nbsp;)&nbsp;取得一个包含匹配的元素集合中每一个元素的之前所有同辈元素的元素集合。<BR>siblings(&nbsp;[expr]&nbsp;)&nbsp;取得一个包含匹配的元素集合中每一个元素的所有同辈元素的元素集合。<BR>andSelf(&nbsp;)&nbsp;将前一个匹配的元素集合添加到当前的集合中<BR>取得所有div元素和其中的p元素，添加border类属性。取得所有div元素中的p元素，<BR>添加background类属性<BR>$(”div”).find(”p”).andSelf().addClass(”border”);<BR>$(”div”).find(”p”).addClass(”background”);<BR>end(&nbsp;)&nbsp;结束当前的操作，回到当前操作的前一个操作<BR>找到所有p元素其中的span元素集合，然后返回p元素集合，添加css属性<BR>$(”p”).find(”span”).end().css(”border”,&nbsp;“2px&nbsp;red&nbsp;solid”);<BR><BR>JQuery&nbsp;Selectors&nbsp;方法说明<BR><BR>基本选择器<BR>$(”#myDiv”)&nbsp;匹配唯一的具有此id值的元素<BR>$(”div”)&nbsp;匹配指定名称的所有元素<BR>$(”.myClass”)&nbsp;匹配具有此class样式值的所有元素<BR>$(”</SPAN><SPAN style=\"COLOR: #000000\">*</SPAN><SPAN style=\"COLOR: #000000\">”)&nbsp;匹配所有元素<BR>$(”div,span,p.myClass”)&nbsp;联合所有匹配的选择器<BR>层叠选择器<BR>$(”form&nbsp;input”)&nbsp;后代选择器，选择ancestor的所有子孙节点<BR>$(”#main&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">&gt;</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">*</SPAN><SPAN style=\"COLOR: #000000\">”)&nbsp;子选择器，选择parent的所有子节点<BR>$(”label&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">+</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;input”)&nbsp;临选择器，选择prev的下一个临节点<BR>$(”#prev&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">~</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;div”)&nbsp;同胞选择器，选择prev的所有同胞节点<BR>基本过滤选择器<BR>$(”tr:first”)&nbsp;匹配第一个选择的元素<BR>$(”tr:last”)&nbsp;匹配最后一个选择的元素<BR>$(”input:not(:checked)&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">+</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;span”)从原元素集合中过滤掉匹配selector的所有元素（这里有是一个临选择器）<BR>$(”tr:even”)&nbsp;匹配集合中偶数位置的所有元素(从0开始)<BR>$(”tr:odd”)&nbsp;匹配集合中奇数位置的所有元素(从0开始)<BR>$(”td:eq(</SPAN><SPAN style=\"COLOR: #000000\">2</SPAN><SPAN style=\"COLOR: #000000\">)”)&nbsp;匹配集合中指定位置的元素(从0开始)<BR>$(”td:gt(</SPAN><SPAN style=\"COLOR: #000000\">4</SPAN><SPAN style=\"COLOR: #000000\">)”)&nbsp;匹配集合中指定位置之后的所有元素(从0开始)<BR>$(”td:gl(</SPAN><SPAN style=\"COLOR: #000000\">4</SPAN><SPAN style=\"COLOR: #000000\">)”)&nbsp;匹配集合中指定位置之前的所有元素(从0开始)<BR>$(”:header”)&nbsp;匹配所有标题<BR>$(”div:animated”)&nbsp;匹配所有正在运行动画的所有元素<BR>内容过滤选择器<BR>$(”div:contains(’John’)”)&nbsp;匹配含有指定文本的所有元素<BR>$(”td:empty”)&nbsp;匹配所有空元素(只含有文本的元素不算空元素)<BR>$(”div:has(p)”)&nbsp;从原元素集合中再次匹配所有至少含有一个selector的所有元素<BR>$(”td:parent”)&nbsp;匹配所有不为空的元素(含有文本的元素也算)<BR>$(”div:hidden”)&nbsp;匹配所有隐藏的元素，也包括表单的隐藏域<BR>$(”div:visible”)&nbsp;匹配所有可见的元素<BR>属性过滤选择器<BR>$(”div[id]”)&nbsp;匹配所有具有指定属性的元素<BR>$(”input[name</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">’newsletter’]”)&nbsp;匹配所有具有指定属性值的元素<BR>$(”input[name</SPAN><SPAN style=\"COLOR: #000000\">!=</SPAN><SPAN style=\"COLOR: #000000\">’newsletter’]”)&nbsp;匹配所有不具有指定属性值的元素<BR>$(”input[name</SPAN><SPAN style=\"COLOR: #000000\">^=</SPAN><SPAN style=\"COLOR: #000000\">’news’]”)&nbsp;匹配所有指定属性值以value开头的元素<BR>$(”input[name$</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">’letter’]”)&nbsp;匹配所有指定属性值以value结尾的元素<BR>$(”input[name</SPAN><SPAN style=\"COLOR: #000000\">*=</SPAN><SPAN style=\"COLOR: #000000\">’man’]”)&nbsp;匹配所有指定属性值含有value字符的元素<BR>$(”input[id][name$</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">’man’]”)&nbsp;匹配同时符合多个选择器的所有元素<BR>子元素过滤选择器<BR>$(”ul&nbsp;li:nth</SPAN><SPAN style=\"COLOR: #000000\">-</SPAN><SPAN style=\"COLOR: #000000\">child(</SPAN><SPAN style=\"COLOR: #000000\">2</SPAN><SPAN style=\"COLOR: #000000\">)”),<BR>$(”ul&nbsp;li:nth</SPAN><SPAN style=\"COLOR: #000000\">-</SPAN><SPAN style=\"COLOR: #000000\">child(odd)”),&nbsp;匹配父元素的第n个子元素<BR>$(”ul&nbsp;li:nth</SPAN><SPAN style=\"COLOR: #000000\">-</SPAN><SPAN style=\"COLOR: #000000\">child(3n&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">+</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">1</SPAN><SPAN style=\"COLOR: #000000\">)”)<BR><BR>$(”div&nbsp;span:first</SPAN><SPAN style=\"COLOR: #000000\">-</SPAN><SPAN style=\"COLOR: #000000\">child”)&nbsp;匹配父元素的第1个子元素<BR>$(”div&nbsp;span:last</SPAN><SPAN style=\"COLOR: #000000\">-</SPAN><SPAN style=\"COLOR: #000000\">child”)&nbsp;匹配父元素的最后1个子元素<BR>$(”div&nbsp;button:only</SPAN><SPAN style=\"COLOR: #000000\">-</SPAN><SPAN style=\"COLOR: #000000\">child”)&nbsp;匹配父元素的唯一1个子元素<BR>表单元素选择器<BR>$(”:input”)&nbsp;匹配所有的表单输入元素，包括所有类型的input,&nbsp;textarea,&nbsp;select&nbsp;和&nbsp;button<BR>$(”:text”)&nbsp;匹配所有类型为text的input元素<BR>$(”:password”)&nbsp;匹配所有类型为password的input元素<BR>$(”:radio”)&nbsp;匹配所有类型为radio的input元素<BR>$(”:checkbox”)&nbsp;匹配所有类型为checkbox的input元素<BR>$(”:submit”)&nbsp;匹配所有类型为submit的input元素<BR>$(”:image”)&nbsp;匹配所有类型为image的input元素<BR>$(”:reset”)&nbsp;匹配所有类型为reset的input元素<BR>$(”:button”)&nbsp;匹配所有类型为button的input元素<BR>$(”:file”)&nbsp;匹配所有类型为file的input元素<BR>$(”:hidden”)&nbsp;匹配所有类型为hidden的input元素或表单的隐藏域<BR>表单元素过滤选择器<BR>$(”:enabled”)&nbsp;匹配所有可操作的表单元素<BR>$(”:disabled”)&nbsp;匹配所有不可操作的表单元素<BR>$(”:checked”)&nbsp;匹配所有已点选的元素<BR>$(”select&nbsp;option:selected”)&nbsp;匹配所有已选择的元素<BR><BR>JQuery&nbsp;CSS&nbsp;方法说明<BR><BR>css(&nbsp;name&nbsp;)&nbsp;访问第一个匹配元素的样式属性。<BR>css(&nbsp;properties&nbsp;)&nbsp;把一个”名</SPAN><SPAN style=\"COLOR: #000000\">/</SPAN><SPAN style=\"COLOR: #000000\">值对”对象设置为所有匹配元素的样式属性。</SPAN><SPAN style=\"COLOR: #000000\"><BR></SPAN><SPAN style=\"COLOR: #000000\">$(”p”).hover(</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;()&nbsp;{<BR>$(</SPAN><SPAN style=\"COLOR: #0000ff\">this</SPAN><SPAN style=\"COLOR: #000000\">).css({&nbsp;backgroundColor:”yellow”,&nbsp;fontWeight:”bolder”&nbsp;});<BR>},&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;()&nbsp;{<BR></SPAN><SPAN style=\"COLOR: #0000ff\">var</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;cssObj&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;{<BR>backgroundColor:&nbsp;“#ddd”,<BR>fontWeight:&nbsp;“”,<BR>color:&nbsp;“rgb(</SPAN><SPAN style=\"COLOR: #000000\">0</SPAN><SPAN style=\"COLOR: #000000\">,</SPAN><SPAN style=\"COLOR: #000000\">40</SPAN><SPAN style=\"COLOR: #000000\">,</SPAN><SPAN style=\"COLOR: #000000\">244</SPAN><SPAN style=\"COLOR: #000000\">)”<BR>}<BR>$(</SPAN><SPAN style=\"COLOR: #0000ff\">this</SPAN><SPAN style=\"COLOR: #000000\">).css(cssObj);<BR>});<BR>css(&nbsp;name,&nbsp;value&nbsp;)&nbsp;在所有匹配的元素中，设置一个样式属性的值。<BR>offset(&nbsp;)&nbsp;取得匹配的第一个元素相对于当前可视窗口的位置。返回的对象有2个属性，<BR>top和left，属性值为整数。这个函数只能用于可见元素。<BR></SPAN><SPAN style=\"COLOR: #0000ff\">var</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;p&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;$(”p:last”);<BR></SPAN><SPAN style=\"COLOR: #0000ff\">var</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;offset&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;p.offset();<BR>p.html(&nbsp;“left:&nbsp;”&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">+</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;offset.left&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">+</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;“,&nbsp;top:&nbsp;”&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">+</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;offset.top&nbsp;);<BR>width(&nbsp;)&nbsp;取得当前第一匹配的元素的宽度值，<BR>width(&nbsp;val&nbsp;)&nbsp;为每个匹配的元素设置指定的宽度值。<BR>height(&nbsp;)&nbsp;取得当前第一匹配的元素的高度值，<BR>height(&nbsp;val&nbsp;)&nbsp;为每个匹配的元素设置指定的高度值。<BR><BR>JQuery&nbsp;Utilities&nbsp;方法说明<BR>jQuery.browser<BR>.msie&nbsp;表示ie<BR>jQuery.browser.version&nbsp;读取用户浏览器的版本信息<BR>jQuery.boxModel&nbsp;检测用户浏览器针对当前页的显示是否基于w3c&nbsp;CSS的盒模型<BR>jQuery.isFunction(&nbsp;obj&nbsp;)&nbsp;检测传递的参数是否为function<BR></SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;stub()&nbsp;{&nbsp;}<BR></SPAN><SPAN style=\"COLOR: #0000ff\">var</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;objs&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;[<BR></SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;()&nbsp;{},<BR>{&nbsp;x:</SPAN><SPAN style=\"COLOR: #000000\">15</SPAN><SPAN style=\"COLOR: #000000\">,&nbsp;y:</SPAN><SPAN style=\"COLOR: #000000\">20</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;},<BR></SPAN><SPAN style=\"COLOR: #0000ff\">null</SPAN><SPAN style=\"COLOR: #000000\">,<BR>stub,<BR>“</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">”<BR>];<BR>jQuery.each(objs,&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;(i)&nbsp;{<BR></SPAN><SPAN style=\"COLOR: #0000ff\">var</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;isFunc&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;jQuery.isFunction(objs[i]);<BR>$(”span:eq(&nbsp;”&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">+</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;i&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">+</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;“)”).text(isFunc);<BR>});<BR>jQuery.trim(&nbsp;str&nbsp;)&nbsp;清除字符串两端的空格，使用正则表达式来清除给定字符两端的空格<BR>jQuery.each(&nbsp;object,&nbsp;callback&nbsp;)&nbsp;一个通用的迭代器，可以用来无缝迭代对象和数组<BR>jQuery.extend(&nbsp;target,&nbsp;object1,&nbsp;[objectN]&nbsp;)&nbsp;扩展一个对象，修改原来的对象并返回，这是一个强大的实现继承的<BR>工具，这种继承是采用传值的方法来实现的，而不是JavaScript中的<BR>原型链方式。<BR>合并settings和options对象，返回修改后的settings对象<BR></SPAN><SPAN style=\"COLOR: #0000ff\">var</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;settings&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;{&nbsp;validate:&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">false</SPAN><SPAN style=\"COLOR: #000000\">,&nbsp;limit:&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">5</SPAN><SPAN style=\"COLOR: #000000\">,&nbsp;name:&nbsp;“foo”&nbsp;};<BR></SPAN><SPAN style=\"COLOR: #0000ff\">var</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;options&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;{&nbsp;validate:&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">true</SPAN><SPAN style=\"COLOR: #000000\">,&nbsp;name:&nbsp;“bar”&nbsp;};<BR>jQuery.extend(settings,&nbsp;options);<BR><BR>合并defaults和options对象，defaults对象并没有被修改。options对象中的值<BR>代替了defaults对象的值传递给了empty。<BR><BR></SPAN><SPAN style=\"COLOR: #0000ff\">var</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;empty&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;{}<BR></SPAN><SPAN style=\"COLOR: #0000ff\">var</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;defaults&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;{&nbsp;validate:&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">false</SPAN><SPAN style=\"COLOR: #000000\">,&nbsp;limit:&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">5</SPAN><SPAN style=\"COLOR: #000000\">,&nbsp;name:&nbsp;“foo”&nbsp;};<BR></SPAN><SPAN style=\"COLOR: #0000ff\">var</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;options&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;{&nbsp;validate:&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">true</SPAN><SPAN style=\"COLOR: #000000\">,&nbsp;name:&nbsp;“bar”&nbsp;};<BR></SPAN><SPAN style=\"COLOR: #0000ff\">var</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;settings&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;$.extend(empty,&nbsp;defaults,&nbsp;options);<BR>jQuery.grep(&nbsp;array,&nbsp;callback,&nbsp;[invert]&nbsp;)&nbsp;通过一个筛选函数来去除数组中的项<BR>$.grep(&nbsp;[</SPAN><SPAN style=\"COLOR: #000000\">0</SPAN><SPAN style=\"COLOR: #000000\">,</SPAN><SPAN style=\"COLOR: #000000\">1</SPAN><SPAN style=\"COLOR: #000000\">,</SPAN><SPAN style=\"COLOR: #000000\">2</SPAN><SPAN style=\"COLOR: #000000\">],&nbsp;</SPAN><SPAN style=\"COLOR: #0000ff\">function</SPAN><SPAN style=\"COLOR: #000000\">(n,i){<BR></SPAN><SPAN style=\"COLOR: #0000ff\">return</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;n&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">&gt;</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">0</SPAN><SPAN style=\"COLOR: #000000\">;<BR>});<BR>jQuery.makeArray(&nbsp;obj&nbsp;)&nbsp;将一个类似数组的对象转化为一个真正的数组<BR>将选取的div元素集合转化为一个数组<BR></SPAN><SPAN style=\"COLOR: #0000ff\">var</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;arr&nbsp;</SPAN><SPAN style=\"COLOR: #000000\">=</SPAN><SPAN style=\"COLOR: #000000\">&nbsp;jQuery.makeArray(document.getElementsByTagName(”div”));<BR>arr.reverse();&nbsp;</SPAN><SPAN style=\"COLOR: #008000\">//</SPAN><SPAN style=\"COLOR: #008000\">&nbsp;use&nbsp;an&nbsp;Array&nbsp;method&nbsp;on&nbsp;list&nbsp;of&nbsp;dom&nbsp;elements</SPAN><SPAN style=\"COLOR: #008000\"><BR></SPAN><SPAN style=\"COLOR: #000000\">$(arr).appendTo(document.body);<BR>jQuery.map(&nbsp;array,&nbsp;callback&nbsp;)&nbsp;使用某个方法修改一个数组中的项，然后返回一个新的数组<BR>jQuery.inArray(&nbsp;value,&nbsp;array&nbsp;)&nbsp;返回value在数组中的位置，如果没有找到，则返回</SPAN><SPAN style=\"COLOR: #000000\">-</SPAN><SPAN style=\"COLOR: #000000\">1</SPAN><SPAN style=\"COLOR: #000000\"><BR>jQuery.unique(&nbsp;array&nbsp;)&nbsp;删除数组中的所有重复元素，返回整理后的数组<BR></SPAN></DIV></DIV></DIV></DIV>','192.168.115.1','a:0:{}',1267115631,'','',0,0,0),(36,1,'a:2:{i:35;s:6:\"jQuery\";i:36;s:6:\"大全\";}','<DIV>\r\n<DIV class=posthead>\r\n<H2><A class=singleposttitle id=ctl03_TitleUrl href=\"http://www.cnblogs.com/Fooo/archive/2009/05/01/1447312.html\"><FONT color=#223355>【经典】jQuery使用大全&nbsp;</FONT></A><BR><BR><SPAN style=\"FONT-SIZE: 10pt\">&nbsp;&nbsp;&nbsp; jQuery是一款同prototype一样优秀js开发库类，特别是对css和XPath的支持，使我们写js变得更加方便！如果你不是个js高手又想写出优 秀的js效果，jQuery可以帮你达到目的！<BR>&nbsp;&nbsp; 下载地址：Starterkit （</SPAN><a href=\"http://jquery.bassistance.de/jquery-starterkit.zip\" target=\"_blank\"><SPAN style=\"FONT-SIZE: 10pt\"><FONT color=#1d58d1>http://jquery.bassistance.de/jquery-starterkit.zip</FONT></SPAN></A><SPAN style=\"FONT-SIZE: 10pt\">）&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<BR>\r\n<SCRIPT type=text/javascript><!-- google_ad_client=\"pub-3555979289815451\"   ; google_ad_slot=\"0437120238\"   ; google_ad_width=\"468;\r\ngoogle_ad_height\"   = 60;\r\n//-->\r\n</SCRIPT>\r\n\r\n<SCRIPT src=\"http://pagead2.googlesyndication.com/pagead/show_ads.js\" type=text/javascript>\r\n</SCRIPT>\r\n\r\n<SCRIPT src=\"http://googleads.g.doubleclick.net/pagead/test_domain.js\"></SCRIPT>\r\n\r\n<SCRIPT src=\"http://pagead2.googlesyndication.com/pagead/render_ads.js\"></SCRIPT>\r\n\r\n<SCRIPT>google_protectAndRun(\"render_ads.js::google_render_ad\", google_handleError, google_render_ad);</SCRIPT>\r\n<IFRAME name=google_ads_frame marginWidth=0 marginHeight=0 src=\"http://googleads.g.doubleclick.net/pagead/ads?format=undefinedxundefined&amp;output=html&amp;lmt=1267073321&amp;ea=0&amp;flash=10.0.42.34&amp;url=http%3A%2F%2Fwww.cnblogs.com%2FFooo%2Farchive%2F2009%2F05%2F01%2F1447312.html&amp;dt=1267073321458&amp;correlator=1267073321474&amp;frm=0&amp;ga_vid=5195733.1262251470&amp;ga_sid=1267073209&amp;ga_hid=367375862&amp;ga_fc=1&amp;u_tz=480&amp;u_his=2&amp;u_java=1&amp;u_h=1024&amp;u_w=1280&amp;u_ah=969&amp;u_aw=1280&amp;u_cd=32&amp;u_nplug=0&amp;u_nmime=0&amp;biw=1260&amp;bih=843&amp;eid=44901217&amp;ref=http%3A%2F%2Fwww.cnblogs.com%2FFooo%2Fcategory%2F163870.html&amp;fu=0&amp;ifi=1&amp;dtd=31\" frameBorder=0 scrolling=no allowTransparency></IFRAME>\r\n<SCRIPT src=\"http://googleads.g.doubleclick.net/pagead/test_domain.js\"></SCRIPT>\r\n\r\n<SCRIPT src=\"http://pagead2.googlesyndication.com/pagead/render_ads.js\"></SCRIPT>\r\n\r\n<SCRIPT>google_protectAndRun(\"render_ads.js::google_render_ad\", google_handleError, google_render_ad);</SCRIPT>\r\n\r\n<SCRIPT>window.google_render_ad();</SCRIPT>\r\n\r\n<SCRIPT> window.google_render_ad(); </SCRIPT>\r\n\r\n<SCRIPT> window.google_render_ad(); </SCRIPT>\r\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; jQuery Downloads （</SPAN><a href=\"http://jquery.com/src/\" target=\"_blank\"><SPAN style=\"FONT-SIZE: 10pt\"><FONT color=#1d58d1>http://jquery.com/src/</FONT></SPAN></A><SPAN style=\"FONT-SIZE: 10pt\">）</SPAN> </H2></DIV>\r\n<DIV class=postbody>\r\n<P>&nbsp;&nbsp; <SPAN style=\"FONT-SIZE: 10pt\">下载完成后先加载到文档中，然后我们来看个简单的例子！</SPAN></P>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,0)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">script&nbsp;language</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">javascript</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;type</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">text/javascript</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;&nbsp;&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;$(document).ready(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).click(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">()&nbsp;{<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;alert(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello&nbsp;world!</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">);<BR>&nbsp;&nbsp;&nbsp;});<BR>});<BR></SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">script</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&gt;</SPAN></DIV>\r\n<P>&nbsp;&nbsp;&nbsp;&nbsp; <SPAN style=\"FONT-SIZE: 10pt\">上边的效果是点击文档中所有a标签时将弹出对话框，$(\"a\") 是一个jQuery选择器，$本身表示一个jQuery类，所有$()是构造一个jQuery对象，click()是这个对象的方法，同理$(document)也是一个jQuery对象，ready(fn)是$(document)的方法，表示当document全部下载完毕时执行函数。<BR>&nbsp;&nbsp;&nbsp;&nbsp; 在进行下面内容之前我还要说明一点$(\"p\")和$(\"#p\")的区别,$(\"p\")表示取所有p标签(&lt;p&gt;&lt;/p&gt;)的元素,$(\"#p\")表示取id为\"p\"(&lt;span&nbsp; id=\"p\"&gt;&lt;/span&gt;)的元素.</SPAN></P>\r\n<P><SPAN style=\"FONT-SIZE: 10pt\">我将从以下几个内容来讲解jQuery的使用:<BR>1:核心部分<BR>2:DOM操作<BR>3:css操作<BR>4:javascript处理<BR>5:动态效果<BR>6:event事件 <BR>7:ajax支持 <BR>8:插件程序</SPAN></P>\r\n<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<U><STRONG style=\"FONT-SIZE: 18pt\">一：核心部分</STRONG></U><BR><SPAN style=\"FONT-SIZE: 12pt\"><STRONG style=\"FONT-SIZE: 12pt; COLOR: red\">$(expr)<BR></STRONG></SPAN><SPAN style=\"FONT-SIZE: 10pt\">说明：该函数可以通过css选择器，Xpath或html代码来匹配目标元素，所有的jQuery操作都以此为基础<BR>参数：expr：字符串，一个查询表达式或一段html字符串<BR><STRONG>例子：</STRONG><BR>未执行jQuery前：</SPAN></P>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">one</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">two</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;<BR>&nbsp;&nbsp;&nbsp; &lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">three</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;<BR></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&nbsp;&nbsp;&nbsp; &lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></DIV><BR><SPAN style=\"FONT-SIZE: 10pt\">jQuery代码及功能：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){&nbsp;&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">div&nbsp;&gt;&nbsp;p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).html());&nbsp;&nbsp;<BR>}</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">运行：当点击id为test的元素时，弹出对话框文字为two，即div标签下p元素的内容</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&lt;div&gt;&lt;p&gt;Hello&lt;/p&gt;&lt;/div&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).appendTo(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">body</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">);<BR>}</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">运行：当点击id为test的元素时，向body中添加“&lt;div&gt;&lt;p&gt;Hello&lt;/p&gt;&lt;/div&gt;”</SPAN><BR><BR><SPAN style=\"FONT-SIZE: 12pt\"><STRONG style=\"COLOR: red\">$(elem)</STRONG></SPAN><BR><SPAN style=\"FONT-SIZE: 10pt\">说明：限制jQuery作用于一个特定的dom元素，这个函数也接受xml文档和windows对象<BR>参数： elem：通过jQuery对象压缩的DOM元素<BR>例子：<BR>未执行jQuery前：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">one</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR>&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">two</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR>&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">three</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">jQuery代码及功能：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;alert($(document).find(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">div&nbsp;&gt;&nbsp;p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).html());<BR>}</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">运行：当点击id为test的元素时，弹出对话框文字为two，即div标签下p元素的内容</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;$(document.body).background(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">black</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">);<BR>}</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">运行：当点击id为test的元素时，背景色变成黑色<BR></SPAN><BR><SPAN style=\"FONT-SIZE: 12pt\"><STRONG style=\"COLOR: red\"><SPAN style=\"FONT-SIZE: 12pt\">$(elems)</SPAN><BR></STRONG><FONT size=3><SPAN style=\"FONT-SIZE: 10pt\">说明：限制jQuery作用于一组特定的DOM元素<BR>参数： elem：一组通过jQuery对象压缩的DOM元素<BR>例子：<BR>未执行jQuery前：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">form&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"form1\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">input&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">type</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"text\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;name</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"textfield\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">input&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">type</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"submit\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;name</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"Submit\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;value</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"提交\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">form</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">jQuery代码及功能：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){&nbsp;<BR>&nbsp;&nbsp;&nbsp;$(form1.elements&nbsp;).hide();&nbsp;<BR>}</SPAN></DIV></FONT></SPAN><SPAN style=\"FONT-SIZE: 10pt\">运行：当点击id为test的元素时，隐藏form1表单中的所有元素。</SPAN><BR><BR><SPAN style=\"FONT-SIZE: 12pt\"><STRONG style=\"COLOR: red\"><SPAN style=\"FONT-SIZE: 12pt\">$(fn)</SPAN><BR></STRONG><FONT size=3><SPAN style=\"FONT-SIZE: 10pt\">说明：$(document).ready()的一个速记方式，当文档全部载入时执行函数。可以有多个$(fn)当文档载入时，同时执行所有函数！<BR>参数：fn (Function):当文档载入时执行的函数！<BR>例子：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,0)\">$(&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;$(document.body).background(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">black</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">);<BR>})</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">运行：当文档载入时背景变成黑色，相当于onLoad。</SPAN><BR><BR><SPAN style=\"FONT-SIZE: 12pt\"><STRONG style=\"COLOR: red\"><SPAN style=\"FONT-SIZE: 12pt\">$(obj)</SPAN><BR></STRONG><FONT size=3><SPAN style=\"FONT-SIZE: 10pt\">说明：复制一个jQuery对象，<BR>参数：obj (jQuery): 要复制的jQuery对象<BR>例子：<BR>未执行jQuery前：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">one</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR>&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">two</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">three</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">jQuery代码及功能：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">var</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;f&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">);&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;alert($(f).find(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).html())&nbsp;<BR>}</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">运行：当点击id为test的元素时，弹出对话框文字为two，即div标签下p元素的内容。</SPAN><BR><BR><SPAN style=\"FONT-SIZE: 12pt\"><STRONG style=\"COLOR: red\"><SPAN style=\"FONT-SIZE: 12pt\">each(fn)</SPAN><BR></STRONG><FONT size=3><SPAN style=\"FONT-SIZE: 10pt\">说明：将函数作用于所有匹配的对象上<BR>参数：fn (Function): 需要执行的函数<BR>例子：<BR>未执行jQuery前：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">img&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">src</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"1.jpg\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">/&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">img&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">src</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"1.jpg\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">/&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">jQuery代码及功能：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">img</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).each(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">(){&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">this</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">.src&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">2.jpg</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">;&nbsp;});<BR>}</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">运行：当点击id为test的元素时，img标签的src都变成了2.jpg。</SPAN><BR><BR><SPAN style=\"FONT-SIZE: 12pt\"><STRONG style=\"COLOR: red\"><SPAN style=\"FONT-SIZE: 12pt\">eq(pos)</SPAN><BR></STRONG><FONT size=3><SPAN style=\"FONT-SIZE: 10pt\">说明：减少匹配对象到一个单独得dom元素<BR>参数：pos (Number): 期望限制的索引，从0 开始<BR>例子：<BR>未执行jQuery前：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">This&nbsp;is&nbsp;just&nbsp;a&nbsp;test.</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">So&nbsp;is&nbsp;this</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">jQuery代码及功能：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).eq(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">1</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).html())<BR>}</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">运行：当点击id为test的元素时，alert对话框显示：So is this，即第二个&lt;p&gt;标签的内容<BR></SPAN><BR><SPAN style=\"FONT-SIZE: 12pt\"><SPAN style=\"FONT-SIZE: 12pt\"><FONT style=\"FONT-SIZE: 12pt\" color=#000000 size=3><STRONG style=\"COLOR: red\">get() get(num)<BR></STRONG></FONT></SPAN><FONT size=3><SPAN style=\"FONT-SIZE: 10pt\">说明：获取匹配元素，get(num)返回匹配元素中的某一个元素<BR>参数：get (Number): 期望限制的索引，从0 开始<BR>例子：<BR>未执行jQuery前：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">This&nbsp;is&nbsp;just&nbsp;a&nbsp;test.</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">So&nbsp;is&nbsp;this</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">jQuery代码及功能：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).get(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">1</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).innerHTML);<BR>}</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">运行：当点击id为test的元素时，alert对话框显示：So is this，即第二个&lt;p&gt;标签的内容<BR></SPAN><SPAN style=\"FONT-SIZE: 10pt; COLOR: rgb(153,51,102)\"><STRONG>注意get和eq的区别，eq返回的是jQuery对象，get返回的是所匹配的dom对象，所有取$(\"p\").eq(1)对象的内容用jQuery方法html()，而取$(\"p\").get(1)的内容用innerHTML<BR></STRONG></SPAN><BR><SPAN style=\"FONT-SIZE: 12pt\"><SPAN style=\"FONT-SIZE: 12pt\"><FONT style=\"FONT-SIZE: 12pt\" color=#000000 size=3><STRONG style=\"COLOR: red\">index(obj)<BR></STRONG></FONT></SPAN><FONT size=3><SPAN style=\"FONT-SIZE: 10pt\">说明：返回对象索引<BR>参数：obj (Object): 要查找的对象<BR>例子：<BR>未执行jQuery前：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test1\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test2\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">jQuery代码及功能：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).index(document.getElementById(\'test1\')));<BR>&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).index(document.getElementById(\'test2\')));<BR>}</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">运行：当点击id为test的元素时，两次弹出alert对话框分别显示0，1<BR></SPAN><BR><SPAN style=\"FONT-SIZE: 12pt\"><SPAN style=\"FONT-SIZE: 12pt\"><FONT style=\"FONT-SIZE: 12pt\" color=#000000 size=3><STRONG style=\"COLOR: red\">size()&nbsp;&nbsp; Length<BR></STRONG></FONT></SPAN><FONT size=3><SPAN style=\"FONT-SIZE: 10pt\">说明：当前匹配对象的数量，两者等价<BR>例子：<BR>未执行jQuery前：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">img&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">src</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test1.jpg\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">/&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">img&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">src</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test2.jpg\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">/&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">jQuery代码及功能：</SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">img</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).length);<BR>}</SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">运行：当点击id为test的元素时，弹出alert对话框显示2，表示找到两个匹配对象</SPAN></FONT></SPAN></FONT></SPAN></FONT></SPAN></FONT></SPAN></FONT></SPAN></FONT></SPAN></FONT></SPAN><FONT size=2>&nbsp;<BR></FONT><STRONG><BR><BR></STRONG><FONT size=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<SPAN style=\"FONT-SIZE: 18pt\"><STRONG><U>二：DOM操作</U></STRONG></SPAN><BR></FONT><SPAN style=\"COLOR: red\"><STRONG style=\"FONT-SIZE: 12pt\"><FONT size=2>属性<BR></FONT></STRONG></SPAN><SPAN style=\"FONT-SIZE: 10pt\">我们以&lt;img id=\"a\" scr=\"5.jpg\"/&gt;为例，在原始的javascript里面可以用var o=document.getElementById(\'a\')取的id为a的节点对象，在用o.src来取得或修改该节点的scr属性，在jQuery里$(\"#a\")将得到jQuery对象[ &lt;img id=\"a\" scr=\"5.jpg\"/&gt; ]，然后可以用jQuery提供的很多方法来进行操作，如$(\"#a\").scr()将得到5.jpg,$(\"#a\").scr(\"1.jpg\")将该对象src属性改为1,jpg。下面我们来讲jQuery提供的众多jQuery方法，方便大家快速对DOM对象进行操作<BR><STRONG style=\"COLOR: rgb(128,0,128)\">herf()&nbsp;&nbsp; herf(val)<BR></STRONG>说明：对jQuery对象属性herf的操作。<BR>例子：<BR>未执行jQuery前</SPAN><FONT size=2> </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"1.htm\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><SPAN style=\"FONT-SIZE: 10pt\">jQuery代码及功能：</SPAN><FONT size=2> </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#test</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">).href());<BR>&nbsp;&nbsp;&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#test</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).href(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">2.html</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>);<BR>}</FONT></SPAN></DIV><SPAN style=\"FONT-SIZE: 10pt\">运行：先弹出对话框显示id为test的连接url，在将其url改为2.html，当弹出对话框后会看到转向到2.html<BR>同理，jQuery还提供类似的其他方法，大家可以分别试验一下：<BR><STRONG style=\"COLOR: rgb(128,0,128)\">herf()&nbsp; herf(val)&nbsp;&nbsp; html()&nbsp; html(val)&nbsp;&nbsp; id()&nbsp; id (val)&nbsp; name()&nbsp; name (val)&nbsp;&nbsp; rel()&nbsp; rel (val)<BR>src()&nbsp;&nbsp;&nbsp; src (val)&nbsp;&nbsp; title()&nbsp; title (val)&nbsp;&nbsp; val()&nbsp; val(val)<BR></STRONG></SPAN><BR><SPAN style=\"COLOR: red\"><STRONG><FONT size=2>操作<BR></FONT></STRONG></SPAN><SPAN style=\"FONT-SIZE: 10pt\"><STRONG style=\"COLOR: rgb(128,0,128)\">after(html)&nbsp; 在匹配元素后插入一段html</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV></SPAN><FONT size=2>jQuery代码及功能： </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){&nbsp;&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#test</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).after(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&lt;b&gt;Hello&lt;/b&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>);&nbsp;&nbsp;<BR>}</FONT></SPAN></DIV><FONT size=2>执行后相当于： </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">b</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">b</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><BR><FONT size=2><STRONG style=\"COLOR: rgb(128,0,128)\">after(elem)&nbsp; after(elems)&nbsp; 将指定对象elem或对象组elems插入到在匹配元素后</STRONG> </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">after</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><FONT size=2>jQuery代码及功能 </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){&nbsp;&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).after($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#test</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>));&nbsp;&nbsp;<BR>}</FONT></SPAN></DIV><FONT size=2>执行后相当于 </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">after</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><BR><SPAN style=\"FONT-SIZE: 10pt\"><STRONG style=\"COLOR: rgb(128,0,128)\">append(html)在匹配元素内部，且末尾插入指定html</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV></SPAN><FONT size=2>jQuery代码及功能： </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">function&nbsp;jq(){&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$(\"#test\").append(\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">b</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">b</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>\");&nbsp;&nbsp;<BR>}</FONT></SPAN></DIV><FONT size=2>执行后相当于 </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">b</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">b</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><FONT size=2>同理还有append(elem)&nbsp; append(elems) before(html) before(elem) before(elems)请执行参照append和after的方来测试、理解！<BR><BR><STRONG><SPAN style=\"COLOR: rgb(128,0,128)\">ap</SPAN><SPAN style=\"COLOR: rgb(128,0,128)\">pendTo(expr)&nbsp; 与append(elem)相反</SPAN></STRONG> </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">after</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><FONT size=2>jQuery代码及功能 </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){&nbsp;&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).&nbsp;appendTo&nbsp;($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#test</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>));&nbsp;&nbsp;<BR>}</FONT></SPAN></DIV><FONT size=2>执行后相当于 </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">after</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><BR><SPAN style=\"FONT-SIZE: 10pt\"><STRONG style=\"FONT-SIZE: 10pt; COLOR: rgb(128,0,128)\">clone() 复制一个jQuery对象</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">after</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV>jQuery代码及功能： \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){&nbsp;&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#test</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).clone().appendTo($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>));&nbsp;&nbsp;<BR>}</FONT></SPAN></DIV>复制$(\"#test\")然后插入到&lt;a&gt;后,执行后相当于 \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">after</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">after</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV></SPAN><BR><FONT size=2><STRONG style=\"COLOR: rgb(128,0,128)\">empty() 删除匹配对象的所有子节点</STRONG> </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><FONT size=2><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top>&nbsp;&nbsp;</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">span</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">span</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">span</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><FONT size=2><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top>&nbsp;&nbsp;</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">after</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><FONT size=2><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top></FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><FONT size=2><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top></FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><FONT size=2>jQuery代码及功能： </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){&nbsp;&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#test</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>).empty();&nbsp;&nbsp;<BR>}</FONT></SPAN></DIV><FONT size=2>执行后相当于 </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><BR><FONT size=2><STRONG><SPAN style=\"COLOR: rgb(128,0,128)\">insertAfter(expr)&nbsp;&nbsp; insertBefore(expr)</SPAN><BR></STRONG>&nbsp;&nbsp;&nbsp;&nbsp; 按照官方的解释和我的几个简单测试insertAfter(expr)相当于before(elem),insertBefore(expr)相当于after (elem)<BR><BR></FONT><FONT size=2><STRONG><SPAN style=\"COLOR: rgb(128,0,128)\">prepend (html)&nbsp; prepend (elem)&nbsp; prepend (elems)&nbsp;&nbsp; 在匹配元素的内部且开始出插入</SPAN><BR></STRONG>通过下面例子区分append(elem)&nbsp; appendTo(expr)&nbsp; prepend (elem) </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"a\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><SPAN style=\"FONT-SIZE: 10pt\">执行</SPAN><FONT size=2>$<STRONG>(\"#a\").append($(\"div\")) </STRONG>后相当于 </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"a\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><FONT size=2>&nbsp;&nbsp;P<BR>&nbsp;&nbsp;</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><SPAN style=\"FONT-SIZE: 10pt\">执行</SPAN><FONT size=2><STRONG>$(\"#a\").appendTo($(\"div\"))&nbsp;</STRONG>后 相当于 </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><FONT size=2>&nbsp;&nbsp;&nbsp;div<BR>&nbsp;&nbsp;&nbsp;</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"a\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><SPAN style=\"FONT-SIZE: 10pt\">执行</SPAN><FONT size=2><STRONG>$(\"#a\").prepend ($(\"div\"))</STRONG>&nbsp;后 相当于 </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"a\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><FONT size=2>&nbsp;&nbsp;&nbsp;</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><FONT size=2>&nbsp;&nbsp;&nbsp;P<BR></FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><BR><FONT size=2><STRONG style=\"COLOR: rgb(128,0,128)\">remove()&nbsp; 删除匹配对象</STRONG><BR>注意区分empty()，empty()移出匹配对象的子节点，remove()，移出匹配对象<BR><BR>wrap(htm) 将匹配对象包含在给出的html代码内 </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Test&nbsp;Paragraph.</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><FONT size=2>jQuery代码及功能： </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){&nbsp;&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).wrap(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&lt;div&nbsp;class=\'wrap\'&gt;&lt;/div&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>);&nbsp;<BR>}</FONT></SPAN></DIV><FONT size=2>执行后相当于 </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">class</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\'wrap\'</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Test&nbsp;Paragraph.</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><BR><SPAN style=\"FONT-SIZE: 10pt\"><STRONG style=\"COLOR: rgb(128,0,128)\">wrap(elem) 将匹配对象包含在给出的对象内</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Test&nbsp;Paragraph.</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"content\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV></SPAN><FONT size=2>jQuery代码及功能： </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){&nbsp;&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>).wrap(&nbsp;document.getElementById(\'content\')&nbsp;);<BR>}</FONT></SPAN></DIV><FONT size=2>执行后相当于 </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"content\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Test&nbsp;Paragraph.</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><BR><SPAN style=\"COLOR: red\"><STRONG><FONT size=2>遍历、组合<BR></FONT></STRONG></SPAN><SPAN style=\"FONT-SIZE: 10pt\"><STRONG style=\"COLOR: rgb(128,0,128)\">add(expr)&nbsp; 在原对象的基础上在附加符合指定表达式的jquery对象</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">span</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello&nbsp;Again</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">span</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>&gt;<BR><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"jq()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></SPAN></DIV>jQuery代码及功能： \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">var</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;f</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).add(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">span</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">);&nbsp;&nbsp;&nbsp;&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">for</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">var</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;i</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">0</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">;i&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;$(f).size();i</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">++</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>){<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;alert($(f).eq(i).html());}<BR>}</FONT></SPAN></DIV>执行$(\"p\")得到匹配&lt;p&gt;的对象，有两个，add(\"span\")是在(\"p\")的基础上加上匹配&lt;span &gt;的对象，所有一共有3个，从上面的函数运行结果可以看到$(\"p\").add(\"span\")是3个对象的集合，分别是[&lt;p&gt;Hello&lt;/p&gt;]，[&lt;p&gt;&lt;span&gt;Hello Again&lt;/span&gt;&lt;/p&gt;]，[&lt;span&gt;Hello Again&lt;/span&gt;]。<BR><BR><STRONG style=\"COLOR: rgb(128,0,128)\">add(el)&nbsp; 在匹配对象的基础上在附加指定的dom元素。</STRONG><BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $(\"p\").add(document.getElementById(\"a\"));<BR><BR><STRONG><SPAN style=\"COLOR: rgb(128,0,128)\">add(els)&nbsp; 在匹配对象的基础上在附加指定的一组对象，els是一个数组</SPAN>。</STRONG><BR>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">span</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello&nbsp;Again</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">span</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV>jQuery代码及功能： \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">var</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;f</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).add([document.getElementById(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">),&nbsp;document.getElementById(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">b</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">)])<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">for</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">var</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;i</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">0</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">;i&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;$(f).size();i</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">++</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>){<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;alert($(f).eq(i).html());}<BR>}</FONT></SPAN></DIV>注意els是一个数组，这里的[ ]不能漏掉。<BR><BR><STRONG style=\"COLOR: rgb(128,0,128)\">ancestors ()&nbsp; 一依次以匹配结点的父节点的内容为对象,根节点除外（有点不好理解，看看下面例子就明白了）</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><FONT size=2>&nbsp;&nbsp;&nbsp;&nbsp;</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">one</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><FONT size=2>&nbsp;&nbsp;&nbsp;&nbsp;</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">span</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><FONT size=2>&nbsp;&nbsp;&nbsp;&nbsp;</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">u</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">two</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">u</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><FONT size=2>&nbsp;&nbsp;&nbsp;&nbsp;</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">span</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV>jQuery代码及功能： \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">var</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;f</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">u</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">).ancestors();<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">for</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">var</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;i</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">0</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">;i&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;$(f).size();i</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">++</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>){<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;alert($(f).eq(i).html());}<BR>}</FONT></SPAN></DIV>第一个对象是以&lt;u&gt;的父节点的内容为对象，[ &lt;u&gt;two&lt;/u&gt; ]<BR>第一个对象是以&lt;u&gt;的父节点的父节点（div）的内容为对象，[&lt;p&gt;one&lt;/p&gt;&lt;span&gt;&lt;u&gt;two&lt;/u&gt;&lt;/span&gt; ]<BR>一般一个文档还有&lt;body&gt;和&lt;html&gt;，依次类推下去。<BR><BR><STRONG style=\"COLOR: rgb(128,0,128)\">ancestors (expr)&nbsp; 在ancestors（）的基础上之取符合表达式的对象</STRONG><BR>如上各例子讲var f改为var f= $(\"u\").ancestors(“div”),则只返回一个对象：<BR>[ &lt;p&gt;one&lt;/p&gt;&lt;span&gt;&lt;u&gt;two&lt;/u&gt;&lt;/span&gt;&nbsp; ]<BR><BR><STRONG style=\"COLOR: rgb(128,0,128)\">children()&nbsp; 返回匹配对象的子介点</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">one</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"ch\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;&nbsp;&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">span</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">two</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">span</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV>jQuery代码及功能： \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#ch</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>).children().html());<BR>}</FONT></SPAN></DIV>$(\"#ch\").children()得到对象[ &lt;span&gt;two&lt;/span&gt; ].所以.html()的结果是”two”<BR><BR><STRONG style=\"COLOR: rgb(128,0,128)\">children(expr)&nbsp; 返回匹配对象的子介点中符合表达式的节点</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"ch\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;&nbsp;&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">span</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">two</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">span</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><FONT size=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">span&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"sp\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">three</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">span</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV>jQuery代码及功能 \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#ch</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>).children(“#sp”).html());<BR>}</FONT></SPAN></DIV>$(\"#ch\").children()得到对象[&lt;span&gt;two&lt;/span&gt;&lt;span id=\"sp\"&gt;three&lt;/span&gt; ].<BR>$(\"#ch\").children(“#sp”)过滤得到[&lt;span id=\"sp\"&gt;three&lt;/span&gt; ]<BR><BR><STRONG style=\"COLOR: rgb(128,0,128)\">parent ()&nbsp; parent (expr)取匹配对象父节点的。参照children帮助理解</STRONG><BR><BR><SPAN style=\"COLOR: rgb(128,0,128)\"><STRONG>contains(str)&nbsp; 返回匹配对象中包含字符串str的对象</STRONG></SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">This&nbsp;is&nbsp;just&nbsp;a&nbsp;test.</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">So&nbsp;is&nbsp;this</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV>jQuery代码及功能： \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).contains(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">test</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>).html());<BR>}</FONT></SPAN></DIV>$(\"p\")得到两个对象，而包含字符串”test”只有一个。所有$(\"p\").contains(\"test\")返回 [ &lt;p&gt;This is just a test.&lt;/p&gt; ]<BR><BR><STRONG><SPAN style=\"COLOR: rgb(128,0,128)\">end() 结束操作,返回到匹配元素清单上操作前的状态</SPAN>.<BR></STRONG><BR><STRONG style=\"COLOR: rgb(128,0,128)\">filter(expr)&nbsp;&nbsp; filter(exprs)&nbsp;&nbsp; 过滤现实匹配符合表达式的对象 exprs为数组，注意添加“[ ]”</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello&nbsp;Again</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">class</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"selected\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">And&nbsp;Again</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV>jQuery代码及功能： \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).filter(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">.selected</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>).html())<BR>}</FONT></SPAN></DIV>$(\"p\")得到三个对象，$(\"p\").contains(\"test\")只返回class为selected的对象。<BR><BR><STRONG style=\"COLOR: rgb(128,0,128)\">find(expr)&nbsp; 在匹配的对象中继续查找符合表达式的对象</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"a\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello&nbsp;Again</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">class</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"selected\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">And&nbsp;Again</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV>Query代码及功能： \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).find(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>).html())<BR>}</FONT></SPAN></DIV>在$(\"p\")对象中查找id为a的对象。<BR><BR><STRONG style=\"COLOR: rgb(128,0,128)\">is(expr)&nbsp; 判断对象是否符合表达式,返回boolen值</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"a\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello&nbsp;Again</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">class</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"selected\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">And&nbsp;Again</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV>Query代码及功能： \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).is(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>));<BR>}</FONT></SPAN></DIV>在$(\"#a \")是否符合jquery表达式。<BR>大家可以用$(\"#a\").is(\"div\");&nbsp; (\"#a\").is(\"#a\")多来测试一下<BR><BR><STRONG>next()&nbsp; next(expr)&nbsp; 返回匹配对象剩余的兄弟节点</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"a\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello&nbsp;Again</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">class</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"selected\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">And&nbsp;Again</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV>jQuery代码及功能 \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jq(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">).next().html());<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).next(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">.selected</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>).html());<BR>}</FONT></SPAN></DIV>$(\"p\").next()返回 [ &lt;p id=\"a\"&gt;Hello Again&lt;/p&gt; , &lt;p class=\"selected\"&gt;And Again&lt;/p&gt; ]两个对象<BR>$(\"p\").next(\".selected)只返回 [&lt;p class=\"selected\"&gt;And Again&lt;/p&gt; ]一个对象<BR><BR><STRONG><SPAN style=\"COLOR: rgb(128,0,128)\">prev ()&nbsp; prev (expr)&nbsp; 参照next理解</SPAN><BR></STRONG><BR><STRONG style=\"COLOR: rgb(128,0,128)\">not(el)&nbsp; not(expr)&nbsp; 从jQuery对象中移出匹配的对象，el为dom元素，expr为jQuery表达式。</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">one</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"a\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">two</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onclick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"js()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV>jQuery代码及功能： \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;js(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).not(document.getElementById(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">)).html());<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>).not(“#a”).html());<BR>}</FONT></SPAN></DIV>$(\"p\")由两个对象，排除后的对象为[&lt;p&gt;one&lt;/p&gt; ]<BR><BR><SPAN style=\"COLOR: rgb(128,0,128)\"><STRONG>siblings ()&nbsp; siblings (expr)&nbsp; jquery匹配对象中其它兄弟级别的对象</STRONG></SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">one</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><FONT size=2>&nbsp;&nbsp;</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"a\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">two</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onclick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"js()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV>jQuery代码及功能： \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;js(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).siblings().eq(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">1</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>).html());<BR>}</FONT></SPAN></DIV>$(\"div\").siblings()的结果实返回两个对象[&lt;p&gt;one&lt;/p&gt;，&lt;a href=\"#\" onclick=\"js()\"&gt;jQuery&lt;/a&gt; ]<BR>alert($(\"div\").siblings(“a”)返回一个对象[&lt;a href=\"#\" onclick=\"js()\"&gt;jQuery&lt;/a&gt; ]<BR><BR><SPAN style=\"COLOR: red\"><STRONG>其他<BR></STRONG><SPAN style=\"FONT-SIZE: 10pt; COLOR: rgb(0,0,0)\"><STRONG>addClass(class)&nbsp;&nbsp; 为匹配对象添加一个class样式<BR>removeClass (class)&nbsp;&nbsp; 将第一个匹配对象的某个class样式移出<BR></STRONG><BR><STRONG style=\"COLOR: rgb(128,0,128)\">attr (name)&nbsp;&nbsp; 获取第一个匹配对象的属性</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">img&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">src</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test.jpg\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">/&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onclick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"js()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN></FONT></DIV>jQuery代码及功能： \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;js(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;alert($(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">img</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).attr(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">src</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>));<BR>}</FONT></SPAN></DIV>返回test.jpg<BR><BR><STRONG><SPAN style=\"COLOR: rgb(128,0,128)\">attr (prop)&nbsp;&nbsp; 为第一个匹配对象的设置属性，prop为hash对象，用于为某对象批量添加众多属性</SPAN></STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">img</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">/&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onclick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"js()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV>jQuery代码及功能： \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;js(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">img</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).attr({&nbsp;src:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">test.jpg</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,&nbsp;alt:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Test&nbsp;Image</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>&nbsp;});&nbsp;<BR>}</FONT></SPAN></DIV>运行结果相当于&lt;img src=\"test.jpg\" alt=\"Test Image\"/&gt;<BR><BR><SPAN style=\"COLOR: rgb(128,0,128)\"><STRONG>attr (key,value)&nbsp;&nbsp; 为第一个匹配对象的设置属性，key为属性名，value为属性值</STRONG></SPAN> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">img</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">/&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">a&nbsp;href</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;onclick</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">js()</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&gt;</SPAN></FONT></DIV>jQuery代码及功能 \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;js(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">img</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>).attr(“src”,”test.jpg”);&nbsp;<BR>}</FONT></SPAN></DIV>运行结果相当于&lt;img src=\"test.jpg\"/&gt;<BR><BR><STRONG style=\"COLOR: rgb(128,0,128)\">removeAttr (name)&nbsp;&nbsp; 将第一个匹配对象的某个属性移出</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">img&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">alt</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"test\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">/&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onclick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"js()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV>jQuery代码及功能： \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><SPAN style=\"COLOR: rgb(0,0,255)\"><FONT size=2>function</FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;js(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">img</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).&nbsp;removeAttr(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">alt</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>);&nbsp;<BR>}</FONT></SPAN></DIV>运行结果相当于&lt;img /&gt;<BR><BR><STRONG style=\"COLOR: rgb(128,0,128)\">toggleClass (class)&nbsp;&nbsp; 将当前对象添加一个样式，不是当前对象则移出此样式，返回的是处理后的对象</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">class</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"selected\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello&nbsp;Again</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onclick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"js()\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV>$(\"p\")的结果是返回对象 [&lt;p&gt;Hello&lt;/p&gt;,&lt;p class=\"selected\"&gt;Hello Again&lt;/p&gt; ]<BR>$(\"p\").toggleClass(\"selected\")的结果是实返回对象 [ &lt;p class=\"selected\"&gt;Hello&lt;/p&gt;, &lt;p&gt;Hello Again&lt;/p&gt; ]</SPAN></SPAN></SPAN><FONT size=2>&nbsp;<BR><BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<U>三<SPAN style=\"FONT-SIZE: 18pt\"><STRONG>：CSS操作</STRONG></SPAN></U><BR></FONT><SPAN style=\"COLOR: red\"><STRONG style=\"FONT-SIZE: 12pt\"><BR></STRONG></SPAN><SPAN style=\"FONT-SIZE: 10pt\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 传统javascript对css的操作相当繁琐，比如&lt;div id=\"a\" style=\"background:blue\"&gt;css&lt;/div&gt;取它的background语法是 document.getElementById(\"a\").style.background，而jQuery对css更方便的操作，$(\"#a\").background()，$(\"#a\").background(“red”)<BR>$(\"#a\")得到jQuery对象[ &lt;div id=\"a\" … /div&gt; ]<BR>$(\"#a\").background()将取出该对象的background样式。<BR>$(\"#a\").background(“red”)将该对象的background样式设为red</SPAN><SPAN style=\"FONT-SIZE: 10pt\">jQuery提供了以下方法，来操作css<BR><SPAN style=\"COLOR: rgb(153,51,102)\"><STRONG>background ()&nbsp;&nbsp; background (val)&nbsp;&nbsp;&nbsp;&nbsp; color()&nbsp;&nbsp;&nbsp; color(val)&nbsp;&nbsp;&nbsp;&nbsp; css(name)&nbsp;&nbsp;&nbsp; css(prop)&nbsp;&nbsp;&nbsp; <BR>css(key, value)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;float()&nbsp;&nbsp; float(val)&nbsp;&nbsp; height()&nbsp;&nbsp; height(val)&nbsp; width()&nbsp; width(val)&nbsp; <BR>left()&nbsp;&nbsp; left(val)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; overflow()&nbsp;&nbsp; overflow(val)&nbsp;&nbsp; position()&nbsp;&nbsp; position(val)&nbsp; top()&nbsp;&nbsp; top(val)</STRONG><BR></SPAN><BR>这里需要讲解一下css(name)&nbsp; css(prop)&nbsp; css(key, value)，其他的看名字都知道什么作用了！ \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"a\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;style</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"background:blue;&nbsp;color:red\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">css</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">div</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">P&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"b\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">test</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">P</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">css(name)</SPAN>&nbsp; 获取样式名为name的样式</STRONG> <BR>$(\"#a\").css(\"color\") 将得到样式中color值red，(\"#a\").css(\"background \")将得到blue<BR><BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">css(prop)</SPAN>&nbsp; prop是一个hash对象，用于设置大量的css样式</STRONG><BR>$(\"#b\").css({ color: \"red\", background: \"blue\" });<BR>最终效果是&lt;p id=\"b\" style=\"background:blue; color:red\"&gt;test&lt;/p&gt;,{ color: \"red\", background: \"blue\" }，hash对象，color为key，\"red\"为value，<BR><BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">css(key, value)</SPAN>&nbsp; 用于设置一个单独得css样式<BR></STRONG>$(\"#b\").css(\"color\",\"red\");最终效果是&lt;p id=\"b\" style=\"color:red\"&gt;test&lt;/p&gt;<BR><BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<FONT size=2><U><STRONG><SPAN style=\"FONT-SIZE: 14pt\">四</SPAN><SPAN style=\"FONT-SIZE: 18pt\">：JavaScript处理</SPAN></STRONG></U><BR></FONT><SPAN style=\"COLOR: red\"><BR></SPAN><SPAN style=\"FONT-SIZE: 10pt\"><STRONG>$.browser()&nbsp; 判断浏览器类型，返回boolen值</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">$(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">if</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">($.browser.msie)&nbsp;{<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;alert(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">这是一个IE浏览器</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">);}<BR>&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">else</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">if</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">($.browser.opera)&nbsp;{<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;alert(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">这是一个opera浏览器</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>);}<BR>})</FONT></SPAN></DIV>当页面载入式判断浏览器类型，可判断的类型有msie、mozilla、opera、safari<BR><BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">$.each(obj, fn)</SPAN>&nbsp; obj为对象或数组，fn为在obj上依次执行的函数，注意区分$().each()</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">$.each(&nbsp;[</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">0</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">1</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">2</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">],&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">(i){&nbsp;alert(&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Item&nbsp;#</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">+</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;i&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">+</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">+</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">this</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;);&nbsp;});</SPAN></FONT></DIV>&nbsp;&nbsp;&nbsp; 分别将0，1，2为参数，传入到function(i)中 \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">$.each({&nbsp;name:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">John</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,&nbsp;lang:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">JS</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;},&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">(i){&nbsp;alert(&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Name:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">+</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;i&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">+</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,&nbsp;Value:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">+</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">this</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;);</SPAN></FONT></DIV>&nbsp;&nbsp;&nbsp; { name: \"John\", lang: \"JS\" }为一个hash对象，依次将hash中每组对象传入到函数中<BR><BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">$.extend(obj, prop)</SPAN>&nbsp; 用第二个对象扩展第一个对象</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">var</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;settings&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;{&nbsp;validate:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">false</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,&nbsp;limit:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">5</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,&nbsp;name:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">foo</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;};<BR></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">var</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;options&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;{&nbsp;validate:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">true</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,&nbsp;name:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">bar</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>&nbsp;};<BR>$.extend(settings,&nbsp;options);</FONT></SPAN></DIV>执行后settings对象为{ validate: true, limit: 5, name: \"bar\" }<BR>可以用下面函数来测试 \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">$(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">var</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;settings&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;{&nbsp;validate:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">false</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,&nbsp;limit:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">5</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,&nbsp;name:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">foo</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;};<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">var</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;options&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;{&nbsp;validate:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">true</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,&nbsp;name:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">bar</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;};<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$.extend(settings,&nbsp;options);<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $.each(settings,&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">(i){&nbsp;alert(&nbsp;i&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">+</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">+</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">this</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>&nbsp;);&nbsp;});<BR>})</FONT></SPAN></DIV><BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">$.grep(array,fn)</SPAN>&nbsp; 通过函数fn来过滤array，将array中的元素依次传给fn，fn必须返回一个boolen，如fn返回true，将被过滤</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">$(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">(){<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">var</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;arr</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;$.grep(&nbsp;[</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">0</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">1</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">2</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">3</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">4</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">],&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">(i){&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">return</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;i&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">2</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">;&nbsp;});<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$.each(arr,&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>(i){&nbsp;alert(i);&nbsp;});<BR>})</FONT></SPAN></DIV>我们可以看待执行$.grep后数组[0,1,2,3,4]变成[0，1]<BR><BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">$.merge(first, second)</SPAN>&nbsp; 两个参数都是数组，排出第二个数组中与第一个相同的，再将两个数组合并</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">$(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">(){&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">var</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;arr&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">=</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;$.merge(&nbsp;[</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">0</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">1</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">2</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">],&nbsp;[</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">2</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">3</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">4</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">]&nbsp;)<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$.each(arr,&nbsp;&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>(i){&nbsp;alert(i);&nbsp;});<BR>})</FONT></SPAN></DIV>可以看出arr的结果为[0,1,2,3,4]<BR><BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">$.trim(str)</SPAN>&nbsp; 移出字符串两端的空格</STRONG><BR>&nbsp;&nbsp;&nbsp; $.trim(\"&nbsp;&nbsp; hello, how are you?&nbsp;&nbsp; \")的结果是\"hello, how are you?\"<BR><BR><BR><BR><STRONG><SPAN style=\"FONT-SIZE: 14pt\"><FONT size=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <U>五</U></FONT></SPAN><U><FONT size=2><SPAN style=\"FONT-SIZE: 18pt\">：动态效果</SPAN><BR></FONT></U></STRONG><SPAN style=\"COLOR: red\"><BR></SPAN><SPAN style=\"FONT-SIZE: 10pt\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在将这部分之前我们先看个例子，相信做网页的朋友都遇到n级菜单的情景，但点击某菜单按钮时，如果它的子菜单是显示的，则隐藏子菜单，如果子菜单隐藏，则显示出来，传统的javascript做法是先用getElementById取出子菜单所在容器的id，在判断该容器的style.display是否等于none，如果等于则设为block,如果不等于这设为none，如果在将效果设置复杂一点，当点击按钮时，不是忽然隐藏和显示子菜单，而是高度平滑的转变，这时就要通过setTimeout来设置子菜单的height了，再复杂一点透明度也平滑的消失和显现，这时显现下来需要编写很多代码，如果js基础不好的朋友可能只能从别人写好的代码拿过来修改了！jQuery实现上面效果只需要1句话就行，$(\"#a\").toggle(\"slow\"),<IMG height=20 alt=\"\" src=\"http://www.cnblogs.com/Emoticons/QQ/23.gif\" width=20 border=0>,学完jQuery后还需要抄袭修改别人的代码吗？下面我们逐个介绍jQuery用于效果处理的方法。<BR><BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">hide()</SPAN>&nbsp; 隐藏匹配对象</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">id</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"a\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Hello&nbsp;Again</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">p</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=’&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">(\"#a\").hide()’</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV></SPAN></SPAN></SPAN><FONT size=2>当点击连接时,id为a的对象的display变为none。<BR><BR></FONT><FONT size=2><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">show()</SPAN> 显示匹配对象<BR><BR><SPAN style=\"COLOR: rgb(153,51,102)\">hide(speed)</SPAN>&nbsp; 以一定的速度隐藏匹配对象，其大小（长宽）和透明度都逐渐变化到0，speed有3级(\"slow\", \"normal\",&nbsp; \"fast\")，也可以是自定义的速度。<BR><BR><SPAN style=\"COLOR: rgb(153,51,102)\">show(speed)</SPAN>&nbsp; 以一定的速度显示匹配对象，其大小（长宽）和透明度都由0逐渐变化到正常<BR><BR><SPAN style=\"COLOR: rgb(153,51,102)\">hide(speed, callback)&nbsp; show(speed, callback)</SPAN> 当显示和隐藏变化结束后执行函数callback<BR><BR><SPAN style=\"COLOR: rgb(153,51,102)\">toggle()&nbsp;&nbsp;&nbsp; <SPAN style=\"COLOR: rgb(153,51,102)\">toggle(speed)</SPAN></SPAN>&nbsp;如果当前匹配对象隐藏，则显示他们，如果当前是显示的，就隐藏，toggle(speed),其大小（长宽）和透明度都随之逐渐变化。</STRONG> </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">img&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">src</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"1.jpg\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;style</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"width:150px\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">/&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR><FONT size=2><IMG alt=\"\" src=\"http://www.cnblogs.com/Images/OutliningIndicators/None.gif\" align=top></FONT></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\'$(\"img\").toggle(\"slow\")\'</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><BR><FONT size=2><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">fadeIn(speeds)&nbsp;&nbsp; fadeOut(speeds)</SPAN>&nbsp; 根据速度调整透明度来显示或隐藏匹配对象，注意有别于hide(speed)和show(speed)，fadeIn和fadeOut都只调整透明度，不调整大小</STRONG> </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">img&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">src</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"1.jpg\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;style</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"display:none\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">/&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\'$(\"img&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">\").fadeIn(\"slow\")\'</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jQuery&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><FONT size=2>点击连接后可以看到图片逐渐显示。<BR><BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">fadeIn(speed, callback)&nbsp; fadeOut(speed, callback)</SPAN>&nbsp;&nbsp; callback为函数，先通过调整透明度来显示或隐藏匹配对象，当调整结束后执行callback函数</STRONG> </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">img&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">src</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"1.jpg\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">/&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\'$(\"img&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">\").fadeIn(\"slow\",function(){&nbsp;alert(\"Animation&nbsp;Done.\");&nbsp;})\'</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jQuery&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><FONT size=2>点击连接后可以看到图片逐渐显示,显示完全后弹出对话框<BR><BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">fadeTo(speed, opacity, callback)</SPAN>&nbsp; 将匹配对象以speed速度调整倒透明度opacity，然后执行函数callback。Opacity为最终显示的透明度(0-1).</STRONG> </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">img&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">src</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"1.jpg\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">/&gt;&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">br</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\'$(\"img&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">\").fadeTo(\"slow\",0.55,function(){&nbsp;alert(\"Animation&nbsp;Done.\");&nbsp;})\'</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;jQuery&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><FONT size=2>大家可以看一下自己看看效果，如果不用jQuery，编写原始javascript脚本可能很多代码！<BR><BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">slideDown(speeds)</SPAN>&nbsp; 将匹配对象的高度由0以指定速率平滑的变化到正常！</STRONG> </FONT>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">img&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">src</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"1.jpg\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;style</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"display:none\"</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">/&gt;</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><BR></SPAN><FONT size=2><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a&nbsp;</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">href</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\"#\"</SPAN><SPAN style=\"COLOR: rgb(255,0,0)\">&nbsp;onClick</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">=\'$(\"img&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">\").slideDown(\"slow\")\'</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">jQuery</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&lt;/</SPAN><SPAN style=\"COLOR: rgb(128,0,0)\">a</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&gt;</SPAN></FONT></DIV><BR><FONT size=2><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">slideDown(speeds,callback)</SPAN>&nbsp; 将匹配对象的高度由0变化到正常！变化结束后执行函数callback<BR></STRONG><BR></FONT><FONT size=2><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">slideUp(\"slow\")&nbsp; slideUp(speed, callback)</SPAN> 匹配对象的高度由正常变化到0<BR></STRONG><BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">slideToggle(\"slow\")</SPAN> 如果匹配对象的高度正常则逐渐变化到0，若为0，则逐渐变化到正常</STRONG>&nbsp;<BR><BR><BR><STRONG>&nbsp;</STRONG></FONT><U><SPAN style=\"FONT-SIZE: 18pt\"><STRONG><FONT size=2>六</FONT></STRONG></SPAN><SPAN style=\"FONT-SIZE: 18pt\"><STRONG><FONT size=2>：事件处理<BR></FONT></STRONG></SPAN></U><SPAN style=\"COLOR: red\"><BR></SPAN><SPAN style=\"FONT-SIZE: 10pt\">&nbsp;<STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">hover(Function, Function)</SPAN>&nbsp;&nbsp;&nbsp; 当鼠标move over时触发第一个function，当鼠标move out时触发第二个function</STRONG><BR>样式：&lt;style&gt;.red{color:#FF0000}&lt;/style&gt;<BR>Html代码： &lt;div id=\"a\"&gt;sdf&lt;/div&gt;<BR>jQuery代码及效果 \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">$(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">(){<BR>&nbsp;&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).hover(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">(){$(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">this</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).addClass(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">red</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">);},<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">(){&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">this</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).removeClass(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">red</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>);&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; });<BR>})</FONT></SPAN></DIV>最终效果是当鼠标移到id为a的层上时图层增加一个red样式，离开层时移出red样式<BR><BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">toggle(Function, Function)</SPAN>&nbsp;&nbsp;&nbsp; 当匹配元素第一次被点击时触发第一个函数，当第二次被点击时触发第二个函数</STRONG><BR>样式：&lt;style&gt;.red{color:#FF0000}&lt;/style&gt;<BR>Html代码： &lt;div id=\"a\"&gt;sdf&lt;/div&gt;<BR>jQuery代码及效果 \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">$(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">(){<BR>&nbsp;&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).&nbsp;toggle&nbsp;(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">(){$(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">this</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).addClass(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">red</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">);},<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">(){&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">this</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).removeClass(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">red</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>);&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; });<BR>})</FONT></SPAN></DIV>最终效果是当鼠标点击id为a的层上时图层增加一个red样式，离开层时移出red样式<BR><BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">bind(type, fn)</SPAN>&nbsp;&nbsp; 用户将一个事件和触发事件的方式绑定到匹配对象上。<BR><SPAN style=\"COLOR: rgb(153,51,102)\">trigger(type)</SPAN>&nbsp;&nbsp; 用户触发type形式的事件。$(\"p\").trigger(\"click\")<BR></STRONG>还有：<SPAN style=\"COLOR: rgb(153,51,102)\"><STRONG>unbind()&nbsp;&nbsp; unbind(type)&nbsp;&nbsp;&nbsp; unbind(type, fn)<BR></STRONG></SPAN><BR><STRONG>Dynamic event(Function)&nbsp;&nbsp;&nbsp; 绑定和取消绑定提供函数的简捷方式</STRONG><BR>例： \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).bind(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">click</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">()&nbsp;{&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">this</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).addClass(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">red</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>);<BR>})</FONT></SPAN></DIV>也可以这样写： \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).click(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">()&nbsp;{&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $(</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">this</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).addClass(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">red</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>);<BR>});</FONT></SPAN></DIV>\r\n<P>最终效果是当鼠标点击id为a的层上时图层增加一个red样式，<BR><BR><STRONG>jQuery提供的函数</STRONG> <BR><STRONG>用于browers事件</STRONG><BR><STRONG style=\"COLOR: rgb(153,51,102)\">error(fn)&nbsp;&nbsp;&nbsp; load(fn)&nbsp;&nbsp;&nbsp;&nbsp; unload(fn)&nbsp;&nbsp;&nbsp; resize(fn)&nbsp;&nbsp;&nbsp; scroll(fn)<BR></STRONG><BR><STRONG>用于form事件</STRONG><BR><STRONG style=\"COLOR: rgb(153,51,102)\">change(fn)&nbsp;&nbsp;&nbsp; select(fn)&nbsp;&nbsp;&nbsp; submit(fn)</STRONG><BR><BR><STRONG>用于keyboard事件</STRONG><BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">keydown</SPAN><SPAN style=\"COLOR: rgb(153,51,102)\">(fn)&nbsp;&nbsp;&nbsp; keypress(fn)&nbsp;&nbsp;&nbsp; keyup(fn)</SPAN><BR></STRONG><BR><STRONG>用于mouse事件</STRONG><BR><STRONG style=\"COLOR: rgb(153,51,102)\">click(fn)&nbsp;&nbsp;&nbsp; dblclick(fn)&nbsp;&nbsp;&nbsp; mousedown(fn)&nbsp;&nbsp; mousemove(fn)<BR>mouseout(fn)&nbsp; mouseover(fn)&nbsp;&nbsp;&nbsp;&nbsp; mouseup(fn)</STRONG></P>\r\n<P><STRONG>用于UI事件<BR>blur(fn)&nbsp;&nbsp;&nbsp; focus(fn)</STRONG><BR><BR><SPAN style=\"COLOR: rgb(51,153,102)\">以上事件的扩展再扩展为5类<BR>举例，click(fn) 扩展 click()&nbsp; unclick()&nbsp; oneclick(fn)&nbsp; unclick(fn)<BR>click(fn)：增加一个点击时触发某函数的事件<BR>click()：可以在其他事件中执行匹配对象的click事件。<BR>unclick ()：不执行匹配对象的click事件。<BR>oneclick(fn)：只增加可以执行一次的click事件。<BR>unclick (fn)：增加一个点击时不触发某函数的事件。<BR>上面列举的用于browers、form、keyboard、mouse、UI的事件都可以按以上方法扩展。<BR></SPAN><BR><BR><SPAN style=\"FONT-SIZE: 14pt\"><FONT size=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</FONT></SPAN><U><STRONG><SPAN style=\"FONT-SIZE: 18pt\"><FONT size=2>七</FONT></SPAN><SPAN style=\"FONT-SIZE: 18pt\"><FONT size=2>：Ajax支持<BR></FONT></SPAN></STRONG></U><SPAN style=\"COLOR: red\"><STRONG style=\"FONT-SIZE: 12pt\"><BR></STRONG></SPAN><SPAN style=\"FONT-SIZE: 10pt\">&nbsp;通用方式：<BR><SPAN style=\"COLOR: rgb(0,0,0)\"><STRONG>$.ajax(prop)&nbsp;&nbsp;&nbsp; 通过一个ajax请求，回去远程数据，prop是一个hash表，它可以传递的key/value有以下几种</STRONG></SPAN>。<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(String)type：数据传递方式(get或post)。<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;((String)url：数据请求页面的url<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;((String)data：传递数据的参数字符串，只适合post方式<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;((String)dataType：期待数据返回的数据格式(例如 \"xml\", \"html\", \"script\",或 \"json\")<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;((Boolean)ifModified： 当最后一次请求的相应有变化是才成功返回，默认值是false<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;((Number)timeout:设置时间延迟请求的时间。可以参考$.ajaxTimeout<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;((Boolean)global：是否为当前请求触发ajax全局事件，默认为true<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;((Function)error：当请求失败时触发的函数。<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;((Function)success：当请求成功时触发函数<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;((Function)complete：当请求完成后出发函数<BR>jQuery代码及说明</SPAN></P>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">$.ajax({url:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">ajax.htm</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;success:</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">(msg){&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$(div</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>).html(msg);<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;});</FONT></SPAN></DIV>将ajax.htm返回的内容作为id为a的div内容 \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">$.ajax({&nbsp;url:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">ajax.aspx</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; type:</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">get</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">,&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dataType:</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">html</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;data:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">name=John&amp;location=Boston</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;success:</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">(msg){&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>).html(msg);<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; });</FONT></SPAN></DIV>\r\n<P>用get方式向ajax.aspx页面传参数，并将返回内容负给id为a的对象。<BR><BR><SPAN style=\"COLOR: rgb(153,51,102)\"><STRONG>$.ajaxTimeout(time)</STRONG></SPAN> <STRONG>设置请求结束时间</STRONG><BR>&nbsp;&nbsp; $.ajaxTimeout( 5000 )<BR><BR>其它简化方式：</P>\r\n<P><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">$.get(url, params, callback)</SPAN>&nbsp; 用get方式向远程页面传递参数，请求完成后处理函数，除了url外，其它参数任意选择</STRONG>！</P>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">$.get(&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">ajax.htm</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;,&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">(data){&nbsp;$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).html(data)&nbsp;&nbsp;})</SPAN></FONT></DIV>\r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">$.get(&nbsp;&nbsp; </SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">ajax.asp</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">,&nbsp;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {&nbsp;name:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">young</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,&nbsp;age:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">25</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN></FONT><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;},<BR></SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">(data){&nbsp;alert(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">Data&nbsp;Loaded:&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">+</SPAN></FONT><SPAN style=\"COLOR: rgb(0,0,0)\"><FONT size=2>&nbsp;data);&nbsp;}<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; )&nbsp;</FONT></SPAN></DIV><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">$.getIfModified(url, params, callback)</SPAN>&nbsp; 用get方式向远程页面传递参数，从最后一次请求后如果数据有变化才作出响应，执行函数callback<BR><SPAN style=\"COLOR: rgb(153,51,102)\">$.getJSON(url, params, callback)</SPAN>&nbsp; 用get方式向远程json对象传递参数，请求完成后处理函数callback。<BR><SPAN style=\"COLOR: rgb(153,51,102)\">$.getScript(url, callback)</SPAN>&nbsp; 用get方式载入并运行一个远程javascript文件。请求完成后处理函数callback。<BR><SPAN style=\"COLOR: rgb(153,51,102)\">$.post(url, params, callback)</SPAN>&nbsp; 用post方式向远程页面传递参数，请求完成后处理函数callback<BR><SPAN style=\"COLOR: rgb(153,51,102)\">load(url, params, callback)</SPAN>&nbsp; 载入一个远程文件并载入页面DOM中，并执行函数callback</STRONG> \r\n<DIV style=\"BORDER-RIGHT: rgb(204,204,204) 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: rgb(204,204,204) 1px solid; PADDING-LEFT: 4px; FONT-SIZE: 13px; PADDING-BOTTOM: 4px; BORDER-LEFT: rgb(204,204,204) 1px solid; WIDTH: 98%; PADDING-TOP: 4px; BORDER-BOTTOM: rgb(204,204,204) 1px solid; BACKGROUND-COLOR: rgb(238,238,238)\"><FONT size=2><SPAN style=\"COLOR: rgb(0,0,0)\">$(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">#a</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">).load(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">ajax.htm</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">,&nbsp;</SPAN><SPAN style=\"COLOR: rgb(0,0,255)\">function</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">()&nbsp;{&nbsp;alert(</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">load&nbsp;is&nbsp;done</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">\"</SPAN><SPAN style=\"COLOR: rgb(0,0,0)\">);&nbsp;}&nbsp;);</SPAN></FONT></DIV><A style=\"DISPLAY: none\" href=\"http://skylaugh.cnblogs.com/\"><STRONG><FONT color=#1d58d1>仰天一笑</FONT></STRONG></A> <A style=\"DISPLAY: none\" href=\"http://skylaugh.cnblogs.com/\"><STRONG><FONT color=#1d58d1>徐羽</FONT></STRONG></A> 向ajax.htm页面发出请求，将返回结果装入id为a的内容中，然后再执行函数callback。<BR><STRONG><SPAN style=\"COLOR: rgb(153,51,102)\">loadIfModified(url, params, callback)</SPAN>&nbsp; 用get方式向远程页面传递参数，从最后一次请求后如果数据有变化才作出响应，将返回结果载入页面DOM中，并执行函数callback<BR><SPAN style=\"COLOR: rgb(153,51,102)\">ajaxStart(callback)</SPAN> 当ajax请求发生错误是时执行函数callback<BR><SPAN style=\"COLOR: rgb(153,51,102)\">ajaxComplete(callback)</SPAN>&nbsp; 当ajax请求完成时执行函数callback<BR><SPAN style=\"COLOR: rgb(153,51,102)\">ajaxError(callback)</SPAN>&nbsp; 当ajax请求发生错误时执行函数callback<BR><SPAN style=\"COLOR: rgb(153,51,102)\">ajaxStop(callback)</SPAN>&nbsp; 当ajax请求停止时执行函数callback<BR><SPAN style=\"COLOR: rgb(153,51,102)\">ajaxSuccess(callback)</SPAN>&nbsp; 当ajax请求成功时执行函数callback</STRONG></SPAN><FONT size=2> </FONT></DIV></DIV>','192.168.115.1','a:0:{}',1268492105,'','',0,0,0),(37,1,'','<div class=\"uchome-message-pic\"><img src=\"attachment/201003/3/1_1267626956toRT.gif\"><p></p></div>','192.168.115.1','',0,'','',0,0,0);

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
  `visitnums` mediumint(8) unsigned NOT NULL default '0',
  `lastvisit` int(11) NOT NULL,
  `browserid` mediumint(1) unsigned NOT NULL default '0',
  PRIMARY KEY  (`bmid`)
) ENGINE=MyISAM AUTO_INCREMENT=163 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_bookmark` */

insert  into `uchome_bookmark`(`bmid`,`uid`,`groupid`,`parentid`,`linkid`,`level`,`subject`,`description`,`tag`,`dateline`,`type`,`visitnums`,`lastvisit`,`browserid`) values (1,1,8000,0,0,1,'链接','','',1270197450,1,0,0,1),(2,1,0,0,2,1,'2010-06-04','数万首歌曲音乐在线试听','a:6:{i:101;s:12:\"在线试听\";i:102;s:12:\"音乐下载\";i:103;s:15:\"好听音乐网\";i:15;s:5:\"music\";i:104;s:7:\"haoting\";i:55;s:6:\"搜索\";}',1275595388,0,0,0,1),(3,1,0,0,3,1,'GoalHi','aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa','a:9:{i:17;s:6:\"足球\";i:19;s:6:\"中超\";i:20;s:6:\"英超\";i:21;s:6:\"意甲\";i:22;s:6:\"西甲\";i:23;s:6:\"欧冠\";i:24;s:9:\"冠军杯\";i:25;s:12:\"五大联赛\";i:26;s:12:\"中国足球\";}',1275963204,0,6,1273275399,1),(7,1,0,0,3,1,'GoalHi足球—努力做最好的足球网站','','',1270270571,0,0,0,1),(6,1,0,0,5,1,'新浪首页','','',1270270225,0,0,0,1),(8,1,0,0,6,1,'当当网—网上购物中心：图书、母婴、美妆、家居、数码、家电、服装、鞋包等，正品低价，货到','','',1270454831,0,0,0,1),(9,1,0,0,7,1,'我的空间 - Powered by UCenter Home','','',1270768583,0,0,0,1),(123,1,8004,8001,0,2,'体育','','',1270974115,1,0,0,2),(121,1,0,8002,8,2,'使用火狐中国版','','',1270973915,0,0,0,2),(119,1,8002,0,0,1,'书签工具栏','','',1270973914,1,0,0,2),(118,1,0,8001,9,2,'腾讯首页','','',1270973914,0,0,0,2),(117,1,0,8001,10,2,'网易','','',1270973914,0,0,0,2),(116,1,8001,0,0,1,'书签菜单','','',1270973914,1,0,0,2),(125,1,0,8001,11,2,'分类: 动作 - 电影频道','','',1271334105,0,0,0,2),(126,1,8005,0,0,1,'体育','','',1274240076,1,0,0,1),(127,1,0,8000,2,2,'好听音乐网','数万首歌曲音乐在线试听','a:6:{i:101;s:12:\"在线试听\";i:102;s:12:\"音乐下载\";i:103;s:15:\"好听音乐网\";i:15;s:5:\"music\";i:104;s:7:\"haoting\";i:55;s:6:\"搜索\";}',1274240394,0,0,0,1),(128,1,8006,8005,0,2,'足球','','',1274856048,1,0,0,1),(133,1,8007,8005,0,2,'篮球','','',1274874904,1,0,0,1),(134,1,8008,8006,0,3,'国际足球','','',1274874921,1,0,0,1),(135,1,8009,8008,0,4,'欧洲足球','','',1274876126,1,0,0,1),(136,1,0,8009,4,5,'天下足球网','','',1274902484,0,0,0,1),(137,1,8010,8006,0,3,'亚洲足球','','',1274898001,1,0,0,1),(138,1,0,0,16,1,'球皇网','','',1275167269,0,0,0,1),(139,1,0,0,17,1,'nba','','',1275167334,0,0,0,1),(140,1,0,0,18,1,'和讯股票','','',1275167365,0,0,0,1),(148,10,8001,0,0,1,'Links','','',1280690640,1,0,0,1),(154,10,0,0,19,1,'搜狐-中国最大的门户网站','','',1280750189,0,0,0,1),(155,10,0,0,21,1,'天涯社区_全球华人网上家园','','',1280773862,0,0,0,1),(156,10,0,0,22,1,'sina','','',1280776803,0,0,0,1),(143,10,8000,0,0,1,'科幻小说','','',1276169928,1,0,0,1),(162,10,0,8000,6,2,'当当网—网上购物中心：图书、母婴、美妆、家居、数码、家电、服装、鞋包等，正品低价，货到付款','','',1281325773,0,0,0,1),(145,10,0,8000,12,2,'百度','','',1275942381,0,0,0,1),(146,10,0,8000,1,2,'好听音乐网','数万首歌曲音乐在线试听','a:6:{i:101;s:12:\"在线试听\";i:102;s:12:\"音乐下载\";i:103;s:15:\"好听音乐网\";i:15;s:5:\"music\";i:104;s:7:\"haoting\";i:55;s:6:\"搜索\";}',1275943913,0,0,0,1),(157,10,0,0,23,1,'20款Notepad++插件下载和介绍  帕兰映像','','',1280925873,0,0,0,1),(158,10,0,0,24,1,'军事－中华网－中国最大的军事网站－男性最喜爱的网站！','','',1280926642,0,0,0,1),(159,10,0,0,25,1,'新浪军事_新浪网','','',1280926817,0,0,0,1),(161,10,0,0,26,1,'军事频道_网易新闻中心','','',1280927787,0,0,0,1);

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

insert  into `uchome_config`(`var`,`datavalue`) values ('sitename','我的空间'),('template','default'),('adminemail','webmaster@192.168.115.2'),('onlinehold','1800'),('timeoffset','8'),('maxpage','100'),('starcredit','100'),('starlevelnum','5'),('cachemode','database'),('cachegrade','0'),('allowcache','1'),('allowdomain','0'),('allowrewrite','0'),('allowwatermark','0'),('allowftp','0'),('holddomain','www|*blog*|*space*|x'),('mtagminnum','5'),('feedday','7'),('feedmaxnum','100'),('feedfilternum','10'),('importnum','100'),('maxreward','10'),('singlesent','50'),('groupnum','8'),('closeregister','0'),('closeinvite','0'),('close','0'),('networkpublic','1'),('networkpage','1'),('seccode_register','1'),('uc_tagrelated','1'),('manualmoderator','1'),('linkguide','1'),('showall','1'),('sendmailday','0'),('realname','0'),('namecheck','0'),('namechange','0'),('name_allowviewspace','1'),('name_allowfriend','1'),('name_allowpoke','1'),('name_allowdoing','1'),('name_allowblog','0'),('name_allowalbum','0'),('name_allowthread','0'),('name_allowshare','0'),('name_allowcomment','0'),('name_allowpost','0'),('showallfriendnum','10'),('feedtargetblank','1'),('feedread','1'),('feedhotnum','3'),('feedhotday','2'),('feedhotmin','3'),('feedhiddenicon','friend,profile,task,wall'),('uc_tagrelatedtime','86400'),('privacy','a:2:{s:4:\"view\";a:12:{s:5:\"index\";i:0;s:7:\"profile\";i:0;s:6:\"friend\";i:0;s:4:\"wall\";i:0;s:4:\"feed\";i:0;s:4:\"mtag\";i:0;s:5:\"event\";i:0;s:5:\"doing\";i:0;s:4:\"blog\";i:0;s:5:\"album\";i:0;s:5:\"share\";i:0;s:4:\"poll\";i:0;}s:4:\"feed\";a:21:{s:5:\"doing\";i:1;s:4:\"blog\";i:1;s:6:\"upload\";i:1;s:5:\"share\";i:1;s:4:\"poll\";i:1;s:8:\"joinpoll\";i:1;s:6:\"thread\";i:1;s:4:\"post\";i:1;s:4:\"mtag\";i:1;s:5:\"event\";i:1;s:4:\"join\";i:1;s:6:\"friend\";i:1;s:7:\"comment\";i:1;s:4:\"show\";i:1;s:9:\"spaceopen\";i:1;s:6:\"credit\";i:1;s:6:\"invite\";i:1;s:4:\"task\";i:1;s:7:\"profile\";i:1;s:5:\"album\";i:1;s:5:\"click\";i:1;}}'),('cronnextrun','1284109500'),('my_status','0'),('uniqueemail','1'),('updatestat','1'),('my_showgift','1'),('topcachetime','60'),('newspacenum','3'),('sitekey','27eaef3UkjDtZ6DD'),('siteallurl',''),('licensed','0'),('debuginfo','0'),('miibeian',''),('headercharset','0'),('avatarreal','0'),('uc_dir',''),('my_ip',''),('closereason',''),('checkemail','0'),('regipdate',''),('my_closecheckupdate','0'),('openxmlrpc','0'),('domainroot',''),('name_allowpoll','0'),('name_allowevent','0'),('name_allowuserapp','0'),('video_allowviewphoto','0'),('video_allowfriend','0'),('video_allowpoke','0'),('video_allowwall','0'),('video_allowcomment','0'),('video_allowdoing','0'),('video_allowblog','0'),('video_allowalbum','0'),('video_allowthread','0'),('video_allowpoll','0'),('video_allowevent','0'),('video_allowshare','0'),('video_allowpost','0'),('video_allowuserapp','0'),('ftpurl',''),('newspaceavatar','0'),('newspacerealname','0'),('newspacevideophoto','0');

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

insert  into `uchome_creditlog`(`clid`,`uid`,`rid`,`total`,`cyclenum`,`credit`,`experience`,`starttime`,`info`,`user`,`app`,`dateline`) values (1,1,1,1,1,10,0,0,'','','',1256533858),(2,1,10,73,1,15,15,0,'','','',1275962394),(3,1,16,28,1,5,5,0,'','','',1267626956),(4,1,15,1,1,1,1,0,'','','',1258082611),(5,1,17,5,4,2,2,0,'','','',1264944906),(6,1,26,8,1,2,2,0,'','','',1269013828),(7,2,1,1,1,10,0,0,'','','',1261707439),(8,2,10,8,1,15,15,0,'','','',1273015459),(9,2,26,1,1,2,2,0,'','','',1261707463),(10,3,1,1,1,10,0,0,'','','',1262551556),(11,3,10,4,1,15,15,0,'','','',1273015486),(12,3,16,3,1,5,5,0,'','','',1264752700),(13,4,1,1,1,10,0,0,'','','',1262551844),(14,4,10,7,1,15,15,0,'','','',1264768741),(15,4,16,6,1,5,5,0,'','','',1264679950),(16,3,11,2,1,1,1,0,'','4','',1264698319),(17,1,27,1,1,1,1,0,'blogid24','','',1264768714),(18,3,28,1,1,1,0,0,'blogid24','','',1264768714),(19,5,1,1,1,10,0,0,'','','',1268063077),(20,5,10,2,1,15,15,0,'','','',1275599326),(21,1,5,1,1,15,15,0,'','','',1269136704),(22,6,1,1,1,10,0,0,'','','',1274701531),(23,6,10,1,1,15,15,0,'','','',1274701531),(24,7,1,1,1,10,0,0,'','','',1274709069),(25,7,10,1,1,15,15,0,'','','',1274709069),(26,8,1,1,1,10,0,0,'','','',1274717119),(27,8,10,2,1,15,15,0,'','','',1275430715),(28,9,1,1,1,10,0,0,'','','',1274717309),(29,9,10,1,1,15,15,0,'','','',1274717309),(30,10,1,1,1,10,0,0,'','','',1275429834),(31,10,10,21,1,15,15,0,'','','',1284087022),(32,10,26,2,2,2,2,0,'','','',1276290634);

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

insert  into `uchome_cron`(`cronid`,`available`,`type`,`name`,`filename`,`lastrun`,`nextrun`,`weekday`,`day`,`hour`,`minute`) values (1,1,'system','更新浏览数统计','log.php',1284109335,1284109500,-1,-1,-1,'0	5	10	15	20	25	30	35	40	45	50	55'),(2,1,'system','清理过期feed','cleanfeed.php',1284085642,1284145440,-1,-1,3,'4'),(3,1,'system','清理个人通知','cleannotification.php',1284087022,1284152760,-1,-1,5,'6'),(4,1,'system','同步UC的feed','getfeed.php',1284109341,1284109620,-1,-1,-1,'2	7	12	17	22	27	32	37	42	47	52'),(5,1,'system','清理脚印和最新访客','cleantrace.php',1284100988,1284141780,-1,-1,2,'3'),(9,1,'user','每日推荐','everydayhot.php',1284100875,1284138060,-1,-1,1,'1');

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

insert  into `uchome_doing`(`doid`,`uid`,`username`,`from`,`dateline`,`message`,`ip`,`replynum`,`mood`) values (1,1,'admin','',1258082611,'SO_LINGER\r\n\r\n   此选项指定函数close对面向连接的协议如何操作（如TCP）。缺省close操作是立即返回，如果有数据残留在套接口缓冲区中则系统将试着将这些数据发送给对方。\r\n\r\n\r\nSO_LINGER选项用来改变此缺省设置。使','192.168.115.1',0,0);

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
) ENGINE=MyISAM AUTO_INCREMENT=91 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_feed` */

insert  into `uchome_feed`(`feedid`,`appid`,`icon`,`uid`,`username`,`dateline`,`friend`,`hash_template`,`hash_data`,`title_template`,`title_data`,`body_template`,`body_data`,`body_general`,`image_1`,`image_1_link`,`image_2`,`image_2_link`,`image_3`,`image_3_link`,`image_4`,`image_4_link`,`target_ids`,`id`,`idtype`,`hot`) values (37,1,'blog',3,'lele',1264752700,0,'2c24ba00fafd81b79f331389e04a26cb','3807b879dc790be9ac78863a4eba880e','{actor} 发表了新日志','N;','<b>{subject}</b><br>{summary}','a:2:{s:7:\"subject\";s:65:\"<a href=\"space.php?uid=3&do=blog&id=24\">用户栈开始内容</a>\";s:7:\"summary\";s:149:\"when the userspace receives control, the stack layout has a fixed format. The rough order is this:    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;lt;ar\";}','','','','','','','','','','',24,'blogid',1),(39,1,'blog',1,'admin',1263497380,2,'2c24ba00fafd81b79f331389e04a26cb','40ee73c7cfdd6863104282021e7504e1','{actor} 发表了新日志','N;','<b>{subject}</b><br>{summary}','a:2:{s:7:\"subject\";s:56:\"<a href=\"space.php?uid=1&do=blog&id=18\">ppp 获取IP</a>\";s:7:\"summary\";s:101:\"osk中PPPoe 获取IP后，调用sys-stub.c 中的sifaddr设置vip，    而其他方式则是setItfIp\";}','','','','','','','','','','3',18,'blogid',50);

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

/*Table structure for table `uchome_link` */

DROP TABLE IF EXISTS `uchome_link`;

CREATE TABLE `uchome_link` (
  `linkid` mediumint(8) unsigned NOT NULL auto_increment,
  `postuid` mediumint(8) unsigned NOT NULL default '0',
  `username` char(15) NOT NULL default '',
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
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_link` */

insert  into `uchome_link`(`linkid`,`postuid`,`username`,`classid`,`link_subject`,`url`,`link_tag`,`link_description`,`viewnum`,`replynum`,`storenum`,`hot`,`link_dateline`,`pic`,`picflag`,`tmppic`,`noreply`,`friend`,`password`,`origin`,`verify`,`md5url`,`hashurl`,`privateflag`,`trynum`,`up`,`down`,`delflag`,`initaward`,`award`,`click_2`,`click_3`,`click_4`,`click_5`) values (1,1,'admin','18','好听音乐网','http://search.haoting.com/user/search1.asp?word=%C7%F4%C4%F1&amp;wofrdf=%C7%F4%C4%F1&amp;type=1&amp;more=true','a:6:{i:101;s:12:\"在线试听\";i:102;s:12:\"音乐下载\";i:103;s:15:\"好听音乐网\";i:15;s:5:\"music\";i:104;s:7:\"haoting\";i:55;s:6:\"搜索\";}','数万首歌曲音乐在线试听',14,0,2,0,1275347991,'snapshot/7/4/1/5',1,'snapshot/random/30.jpg',0,0,'',1,0,'52dda3cf118965987ad84a533706da47',121930165,0,1,33,22,1,8000,8027,0,0,0,0),(2,1,'admin','18','好听音乐网 - 听好音乐 有好心情\n','http://search.haoting.com/user/search1.asp?word=%C7%F4%C4%F1&amp;wofrdf=%C7%F4%C4%F1&amp;type=1&amp;more=true','a:6:{i:101;s:12:\"在线试听\";i:102;s:12:\"音乐下载\";i:103;s:15:\"好听音乐网\";i:15;s:5:\"music\";i:104;s:7:\"haoting\";i:105;s:7:\"搜索\n\";}','数万首歌曲音乐在线试听\n',0,0,2,0,1270197450,'snapshot/7/4/1/5',1,'snapshot/random/9.jpg',0,0,'',1,1,'52dda3cf118965987ad84a533706da47',121930165,0,1,5,1,0,7000,7006,0,0,0,0),(3,1,'admin','33','GoalHi足球—努力做最好的足球网站\n','http://www.goalhi.com','a:9:{i:17;s:6:\"足球\";i:19;s:6:\"中超\";i:20;s:6:\"英超\";i:21;s:6:\"意甲\";i:22;s:6:\"西甲\";i:23;s:6:\"欧冠\";i:24;s:9:\"冠军杯\";i:25;s:12:\"五大联赛\";i:67;s:13:\"中国足球\n\";}','足球,GoalHi足球是英超,意甲,五大联赛,欧冠,冠军杯,中超,国足,亚冠等足球赛事为主的网站,包含最新足球比赛视频,足球新闻,最全的足球直播,赛程,积分,射手榜,图片,比赛讨论等原创内容,拥有热情理性的足球讨论社区供足球迷交流讨论.\n',6,0,2,0,1270200666,'snapshot/6/3/1/5',1,'snapshot/random/11.jpg',0,0,'',1,1,'580b23629f65c8455cd4baa93b5a0da2',1857266045,0,1,6,0,0,7000,7014,0,0,0,0),(4,1,'admin','33','天下足球网 - |最新足球赛事|NBA篮球|体育赛事|球迷论坛|足球博彩|网络直播 - Powered by PHPWind.net\n','http://www.txzqw.com','','\n',0,0,1,0,1270200744,'snapshot/4/4/0/5',1,'snapshot/random/11.jpg',0,0,'',1,1,'9e9ccd263c2c516efd96da226e4556c5',213141597,0,1,0,0,0,7000,7001,0,0,0,0),(5,1,'admin','','新浪首页\n','http://www.sina.com.cn','','新浪网为全球用户24小时提供全面及时的中文资讯，内容覆盖国内外突发新闻事件、体坛赛事、娱乐时尚、产业资讯、实用信息等，设有新闻、体育、娱乐、财经、科技、房产、汽车等30多个内容频道，同时开设博客、视频、论坛等自由互动交流空间。\n',0,0,1,0,1270270225,'snapshot/1/7/4/6',1,'snapshot/random/10.jpg',0,0,'',1,1,'4f12a25ee6cc3d6123be77df850e343e',22017182,0,1,0,0,0,7000,0,0,0,0,0),(6,1,'admin','18','当当网—网上购物中心：图书、母婴、美妆、家居、数码、家电、服装、鞋包等，正品低价，货到付款\n','http://www.dangdang.com','a:39:{i:107;s:9:\"当当网\";i:108;s:6:\"当当\";i:109;s:12:\"网上购物\";i:110;s:12:\"网上商城\";i:111;s:12:\"网上买书\";i:112;s:12:\"购物中心\";i:113;s:12:\"在线购物\";i:114;s:6:\"图书\";i:115;s:6:\"影视\";i:116;s:6:\"音像\";i:117;s:12:\"教育音像\";i:118;s:3:\"DVD\";i:119;s:6:\"百货\";i:120;s:6:\"母婴\";i:121;s:6:\"家居\";i:122;s:6:\"家纺\";i:123;s:6:\"厨具\";i:124;s:9:\"化妆品\";i:125;s:6:\"美妆\";i:126;s:18:\"个人护理用品\";i:127;s:6:\"数码\";i:98;s:6:\"电脑\";i:128;s:9:\"笔记本\";i:129;s:4:\"u盘\";i:99;s:6:\"手机\";i:130;s:3:\"mp3\";i:131;s:3:\"mp4\";i:132;s:12:\"数码相机\";i:133;s:6:\"摄影\";i:134;s:6:\"摄像\";i:135;s:6:\"家电\";i:136;s:6:\"软件\";i:11;s:6:\"游戏\";i:137;s:6:\"服装\";i:138;s:3:\"鞋\";i:139;s:12:\"礼品箱包\";i:140;s:12:\"钟表首饰\";i:141;s:6:\"玩具\";i:142;s:19:\"运动健康用品\n\";}','全球领先的综合性网上购物中心。超过100万种商品在线热销！图书、音像、母婴、美妆、家居、数码3C、服装、鞋包等几十大类，正品行货，低至2折，700多城市货到付款，（全场购物满29元免运费。当当网一贯秉承提升顾客体验的承诺，自助退换货便捷又放心）。\n',11,0,2,0,1270454831,'snapshot/6/5/3/5',1,'snapshot/random/14.jpg',0,0,'',1,1,'8239c5d74a80ad380e7e415cc7356b1b',111506365,0,1,0,0,0,7000,7013,0,0,0,0),(7,1,'admin','18','','http://192.168.115.2/uc/home/space.php?do=all','','',0,0,1,0,1270768583,'snapshot/1/3/7/4',0,'snapshot/random/28.jpg',0,0,'',0,0,'2144247327865e53c4019006701151e0',1097025356,1,0,0,0,0,7000,7001,0,0,0,0),(8,1,'admin','18','','http://g-fox.cn/chinaedition/userguide','','',0,0,14,0,1270882194,'snapshot/4/5/1/5',0,'snapshot/random/25.jpg',0,0,'',0,0,'59ff797c41ab96999eed8b754e8f022c',71651813,0,0,0,0,0,7000,7014,0,0,0,0),(9,1,'admin','18','','http://www.qq.com','','',0,0,14,0,1270882194,'snapshot/0/4/1/5',0,'snapshot/random/28.jpg',0,0,'',0,0,'3872e0b6ee1fd73301ad2cb6365b00a2',542415357,0,0,0,0,0,7000,7014,0,0,0,0),(10,1,'admin','18','','http://www.164.com','','',0,0,14,0,1270882195,'snapshot/1/2/4/5',0,'snapshot/random/17.jpg',0,0,'',0,0,'17c9daae94bd72c96aa514701f626996',161117405,0,0,0,0,0,7000,7014,0,0,0,0),(11,1,'admin','18','','http://movie.xunlei.com/type分类: 动作 - 电影频道Cgenre/movie分类: 动作 - 电影频道CAction','','',0,0,1,0,1271334105,'snapshot/2/5/1/6',0,'snapshot/random/8.jpg',0,0,'',0,0,'a2ff9b558f0afe34a2462201aad7ab8f',1792872830,0,0,0,0,0,7000,7001,0,0,0,0),(12,1,'admin','18','百度','http://www.baidu.com','','',0,0,1,0,1274336125,'snapshot/2/6/4/5',0,'snapshot/random/18.jpg',0,0,'',1,0,'bfa89e563d9509fbc5c6503dd50faf2e',42886333,0,0,0,0,0,7000,7001,0,0,0,0),(13,1,'admin','18','','http://sport.sohu.com','','',0,0,0,0,1274862443,'snapshot/4/2/1/5',0,'snapshot/random/15.jpg',0,0,'',0,0,'98a64d7b253f9f9c6eeb315d8c96cd4e',1144185149,0,0,0,0,0,7000,7000,0,0,0,0),(14,1,'admin','18','','http://sport.sina.com','','',0,0,0,0,1274862652,'snapshot/5/6/1/5',0,'snapshot/random/27.jpg',0,0,'',0,0,'4b9cc84f65094d0613f5b6dcc69d3f7c',1032249821,0,0,0,0,0,7000,7000,0,0,0,0),(15,1,'admin','18','','http://sport.163.com','','',0,0,0,0,1274863092,'snapshot/1/5/3/5',0,'snapshot/random/13.jpg',0,0,'',0,0,'2a4f6635db96316c0f5aed52348300e0',292936605,0,0,0,0,0,7000,7000,0,0,0,0),(16,1,'admin','','','http://bbs.qhball.com','','',0,0,5,0,1275166705,'snapshot/6/6/0/5',0,'snapshot/random/9.jpg',0,0,'',0,0,'669b347d5758c0d5adf8f737415cb485',101583005,0,0,0,0,0,7000,0,0,0,0,0),(17,1,'admin','','','http://nba.tom.com','','',0,0,1,0,1275167334,'snapshot/6/2/7/5',0,'snapshot/random/3.jpg',0,0,'',0,0,'fde8aba8da48192f15781074b725973f',114970557,0,0,0,0,0,7000,7000,0,0,0,0),(18,1,'admin','','','http://stock.hexun.com','','',0,0,1,0,1275167365,'snapshot/4/6/7/5',0,'snapshot/random/17.jpg',0,0,'',0,0,'5a6866ac28f939fd64a2820e284352de',1421745949,0,0,0,0,0,7000,7000,0,0,0,0),(19,10,'ramen.sh@gmail.','','','http://www.sohu.com','','',1,0,1,0,1276169654,'snapshot/5/3/2/5',0,'snapshot/random/23.jpg',0,0,'',0,0,'3c29e52969d51cf519409f60619b6d1e',86239805,0,0,0,0,0,7000,7000,0,0,0,0),(20,10,'ramen.sh@gmail.','','','http://www.tudou.com','','',0,0,0,0,1276366535,'snapshot/1/1/1/5',0,'snapshot/random/14.jpg',0,0,'',0,0,'2cc9c959a710cba782cfe7f123c007a4',1235335485,0,0,0,0,0,7000,7000,0,0,0,0),(21,10,'ramen.sh@gmail.','','','http://www.tianya.cn','','',0,0,1,0,1280773862,'snapshot/6/2/5/6',0,'snapshot/random/30.jpg',0,0,'',0,0,'ab03fa3e3efa5a55e605a00f9c639191',110802302,0,0,0,0,0,7000,7000,0,0,0,0),(22,10,'ramen.sh@gmail.','','','http://www.sina.com','','',0,0,1,0,1280776803,'snapshot/0/7/2/5',0,'snapshot/random/24.jpg',0,0,'',0,0,'c9e237b73229517259dd5a83531f541d',9431805,0,0,0,0,0,7000,7000,0,0,0,0),(23,10,'ramen.sh@gmail.','','','http://paranimage.com/20-notepad-plus-plugins','','',0,0,1,0,1280925873,'snapshot/7/7/6/3',0,'snapshot/random/28.jpg',0,0,'',0,0,'fe05b6e04ef0f1c0f57eb7098fcf6019',124208755,0,0,0,0,0,7000,7000,0,0,0,0),(24,10,'ramen.sh@gmail.','','','http://military.china.com/zh_cn','','',0,0,1,0,1280926642,'snapshot/7/6/0/6',0,'snapshot/random/23.jpg',0,0,'',0,0,'50c0ecee1acfb405efa4630e5b2e34f2',1601108190,0,0,0,0,0,7000,7000,0,0,0,0),(25,10,'ramen.sh@gmail.','','','http://mil.news.sina.com.cn','','',0,0,1,0,1280926817,'snapshot/1/0/2/6',0,'snapshot/random/11.jpg',0,0,'',0,0,'3fec3efcb7071c1408ddb31bf6e52010',166216350,0,0,0,0,0,7000,7000,0,0,0,0),(26,10,'ramen.sh@gmail.','','','http://war.news.163.com','','',0,0,1,0,1280927022,'snapshot/5/4/4/5',0,'snapshot/random/28.jpg',0,0,'',0,0,'c442cd441e60eaabd30d45582b4fb179',95747325,0,0,0,0,0,7000,7000,0,0,0,0);

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
) ENGINE=MyISAM AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linkclass` */

insert  into `uchome_linkclass`(`classid`,`uid`,`classname`,`groupid`,`parentid`,`dateline`,`totalnum`,`close`,`nav`) values (1,1,'生活服务',1000,0,2010,0,0,0),(2,1,'娱乐休闲',1001,0,2010,0,0,0),(3,1,'其它',1002,0,2010,0,0,0),(4,1,'购物',2003,1000,2010,0,0,0),(5,1,'彩票',2004,1000,2010,0,0,0),(6,1,'查询',2005,1000,2010,0,0,0),(7,1,'股票',2006,1000,2010,0,0,0),(8,1,'银行',2007,1000,2010,0,0,0),(9,1,'旅游',2008,1000,2010,0,0,0),(10,1,'菜谱',2009,1000,2010,0,0,0),(11,1,'汽车',2010,1000,2010,0,0,0),(12,1,'地图',2011,1000,2010,0,0,0),(13,1,'健康',2012,1000,2010,0,0,0),(14,1,'宠物',2013,1000,2010,0,0,0),(15,1,'女性',2014,1000,2010,0,0,0),(16,1,'时尚',2015,1000,2010,0,0,0),(17,1,'儿童',2016,1000,2010,0,0,1),(18,1,'音乐',2017,1001,2010,0,0,1),(19,1,'视频',2018,1001,2010,0,0,0),(20,1,'游戏',2019,1001,2010,0,0,0),(21,1,'电影',2020,1001,2010,0,0,0),(22,1,'新闻',2021,1001,2010,0,0,0),(23,1,'小说',2022,1001,2010,0,0,0),(24,1,'军事',2023,1001,2010,0,0,0),(25,1,'图片',2024,1001,2010,0,0,0),(26,1,'动漫',2025,1001,2010,0,0,0),(27,1,'星座',2026,1001,2010,0,0,0),(28,1,'体育',2027,1001,2010,0,0,0),(29,1,'NBA',2028,1001,2010,0,0,0),(30,1,'交友',2029,1001,2010,0,0,0),(31,1,'明星',2030,1001,2010,0,0,0),(32,1,'社区',2031,1001,2010,0,0,0),(33,1,'在线音乐',3000,2017,2010,0,0,0),(34,1,'DJ音乐',3001,2017,2010,0,0,0),(35,1,'音乐周边',3002,2017,2010,0,0,0),(36,1,'宠物综合',3000,2013,0,0,0,0);

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
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linkclasstag` */

insert  into `uchome_linkclasstag`(`tagid`,`tagname`,`hashname`,`uid`,`classid`,`dateline`,`totalnum`) values (1,'音乐',0,1,18,0,0),(2,'免费音乐',0,1,18,0,0),(3,'音乐试听',0,1,18,1268323597,0),(4,'音乐下载',0,1,18,1268323935,0),(5,'在线试听',0,1,18,1268323972,0),(6,'music',0,1,18,1268323982,0),(7,'mp3',0,1,18,1268369733,0),(8,'wmv',0,1,18,1268369839,0),(9,'音乐网站',0,1,18,1268370437,0),(10,'流行音乐',0,1,18,1268370536,0),(11,'mp3歌曲',0,1,18,1268370815,0),(12,'影视金曲',0,1,18,1269015002,0),(13,'奥斯卡金曲',0,1,18,1269015063,0),(14,'流行歌曲',123959218,1,18,1269015155,0),(15,'金曲',623618,1,18,1269015232,0);

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
) ENGINE=MyISAM AUTO_INCREMENT=143 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linktag` */

insert  into `uchome_linktag`(`tagid`,`tagname`,`uid`,`dateline`,`totalnum`,`close`) values (1,'天涯',1,1266595086,1,0),(2,'小说',1,1266595086,1,0),(3,'文学',1,1266595086,1,0),(4,'电影',1,1266600734,4,0),(5,'电视剧',1,1266600734,2,0),(6,'原创',1,1266600734,1,0),(7,'音乐',1,1266600734,4,0),(8,'娱乐',1,1266600734,2,0),(9,'资讯',1,1266600734,0,0),(10,'动漫',1,1266600734,1,0),(11,'游戏',1,1266600734,1,0),(12,'搞笑',1,1266600734,0,0),(13,'生活',1,1266600734,0,0),(14,'教育',1,1266600734,3,0),(15,'music',1,1266946908,22,0),(16,'hello',1,1266946908,0,0),(17,'足球',1,1267186916,37,0),(18,'新闻',1,1267189669,2,0),(19,'中超',1,1268144511,33,0),(20,'英超',1,1268144511,33,0),(21,'意甲',1,1268144511,33,0),(22,'西甲',1,1268144511,33,0),(23,'欧冠',1,1268144511,33,0),(24,'冠军杯',1,1268144511,33,0),(25,'五大联赛',1,1268144511,33,0),(26,'中国足球',1,1268144511,22,0),(27,'社交',1,1268235293,1,0),(28,'SNS',1,1268235293,1,0),(29,'开心网',1,1268235412,1,0),(30,'开心网001',1,1268235412,1,0),(31,'SNS交友',1,1268235412,1,0),(32,'社交网站',1,1268235412,1,0),(33,'社交网',1,1268235412,1,0),(34,'争车位',1,1268235412,1,0),(35,'朋友买卖',1,1268235412,1,0),(36,'花园',1,1268235412,1,0),(37,'菜地',1,1268235412,1,0),(38,'开心农场',1,1268235412,1,0),(39,'鱼塘',1,1268235412,1,0),(40,'钓鱼',1,1268235412,1,0),(41,'视频',1,1268235443,3,0),(42,'在线观看',1,1268235443,1,0),(43,'最新视频',1,1268235443,1,0),(44,'最热视频',1,1268235443,1,0),(45,'视频播客',1,1268235443,1,0),(46,'视频分享',1,1268235443,2,0),(47,'视频搜索',1,1268235460,1,0),(48,'视频播放',1,1268235460,1,0),(49,'360安全网址',1,1268235482,1,0),(50,'360网址大全',1,1268235482,1,0),(51,'上网导航',1,1268235482,1,0),(52,'网址之家',1,1268235482,1,0),(53,'网址大全',1,1268235482,1,0),(54,'网址',1,1268235482,1,0),(55,'搜索',1,1268235482,20,0),(56,'图片',1,1268235482,3,0),(57,'小游戏',1,1268235482,1,0),(58,'短信',1,1268235482,1,0),(59,'社区',1,1268235482,1,0),(60,'日记',1,1268235482,1,0),(61,'相册',1,1268235482,1,0),(62,'K歌',1,1268235482,1,0),(63,'通讯簿',1,1268235482,1,0),(64,'BLOG',1,1268235482,1,0),(65,'天气预报',1,1268235482,1,0),(66,'最快捷',1,1268235482,1,0),(67,'中国足球\n',1,1268397845,11,0),(68,'新闻中心',1,1268407405,1,0),(69,'时政',1,1268407405,1,0),(70,'人事任免',1,1268407405,1,0),(71,'国际',1,1268407405,1,0),(72,'地方',1,1268407405,1,0),(73,'香港',1,1268407405,1,0),(74,'台湾',1,1268407405,1,0),(75,'澳门',1,1268407405,1,0),(76,'华人',1,1268407405,1,0),(77,'军事',1,1268407405,1,0),(78,'财经',1,1268407405,1,0),(79,'政权',1,1268407405,1,0),(80,'股票',1,1268407405,1,0),(81,'房产',1,1268407405,1,0),(82,'汽车',1,1268407405,1,0),(83,'体育',1,1268407405,1,0),(84,'奥运',1,1268407405,1,0),(85,'法治',1,1268407405,1,0),(86,'廉政',1,1268407405,1,0),(87,'社会',1,1268407405,1,0),(88,'科技',1,1268407405,1,0),(89,'互联网',1,1268407405,1,0),(90,'文娱',1,1268407405,1,0),(91,'访谈',1,1268407405,1,0),(92,'直播',1,1268407405,1,0),(93,'专题\n',1,1268407405,1,0),(94,'太平洋电脑网',1,1268407405,4,0),(95,'太平洋',1,1268407405,4,0),(96,'IT门户',1,1268407405,4,0),(97,'IT资讯',1,1268407405,4,0),(98,'电脑',1,1268407405,5,0),(99,'手机',1,1268407405,5,0),(100,'数码\n',1,1268407405,4,0),(101,'在线试听',1,1270454517,22,0),(102,'音乐下载',1,1270454517,22,0),(103,'好听音乐网',1,1270454517,22,0),(104,'haoting',1,1270454517,22,0),(105,'搜索\n',1,1270454517,3,0),(106,'购物',1,1270455202,1,0),(107,'当当网',1,1270771228,1,0),(108,'当当',1,1270771228,1,0),(109,'网上购物',1,1270771228,1,0),(110,'网上商城',1,1270771228,1,0),(111,'网上买书',1,1270771228,1,0),(112,'购物中心',1,1270771228,1,0),(113,'在线购物',1,1270771228,1,0),(114,'图书',1,1270771228,1,0),(115,'影视',1,1270771228,1,0),(116,'音像',1,1270771228,1,0),(117,'教育音像',1,1270771228,1,0),(118,'DVD',1,1270771228,1,0),(119,'百货',1,1270771228,1,0),(120,'母婴',1,1270771228,1,0),(121,'家居',1,1270771228,1,0),(122,'家纺',1,1270771228,1,0),(123,'厨具',1,1270771228,1,0),(124,'化妆品',1,1270771228,1,0),(125,'美妆',1,1270771228,1,0),(126,'个人护理用品',1,1270771228,1,0),(127,'数码',1,1270771228,1,0),(128,'笔记本',1,1270771228,1,0),(129,'u盘',1,1270771228,1,0),(130,'mp3',1,1270771228,1,0),(131,'mp4',1,1270771228,1,0),(132,'数码相机',1,1270771228,1,0),(133,'摄影',1,1270771228,1,0),(134,'摄像',1,1270771228,1,0),(135,'家电',1,1270771228,1,0),(136,'软件',1,1270771228,1,0),(137,'服装',1,1270771228,1,0),(138,'鞋',1,1270771228,1,0),(139,'礼品箱包',1,1270771228,1,0),(140,'钟表首饰',1,1270771228,1,0),(141,'玩具',1,1270771228,1,0),(142,'运动健康用品\n',1,1270771228,1,0);

/*Table structure for table `uchome_linktagbookmark` */

DROP TABLE IF EXISTS `uchome_linktagbookmark`;

CREATE TABLE `uchome_linktagbookmark` (
  `tagid` mediumint(8) unsigned NOT NULL default '0',
  `bmid` mediumint(8) unsigned NOT NULL default '0',
  `uid` mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY  (`tagid`,`bmid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linktagbookmark` */

insert  into `uchome_linktagbookmark`(`tagid`,`bmid`,`uid`) values (18,41,1),(17,3,1),(17,7,1),(19,50,1),(20,50,1),(21,50,1),(22,50,1),(23,50,1),(24,50,1),(25,50,1),(26,50,1),(19,3,1),(20,3,1),(21,3,1),(22,3,1),(23,3,1),(24,3,1),(25,3,1),(26,3,1),(101,127,1),(102,127,1),(103,127,1),(15,127,1),(104,127,1),(55,127,1),(101,2,1),(102,2,1),(103,2,1),(15,2,1),(104,2,1),(55,2,1),(101,146,10),(102,146,10),(103,146,10),(15,146,10),(104,146,10),(55,146,10);

/*Table structure for table `uchome_linktaglink` */

DROP TABLE IF EXISTS `uchome_linktaglink`;

CREATE TABLE `uchome_linktaglink` (
  `tagid` mediumint(8) unsigned NOT NULL default '0',
  `linkid` mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY  (`tagid`,`linkid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linktaglink` */

insert  into `uchome_linktaglink`(`tagid`,`linkid`) values (4,27),(5,27),(7,26),(8,26),(11,6),(14,27),(15,1),(15,2),(17,3),(17,21),(19,3),(19,21),(20,3),(20,21),(21,3),(21,21),(22,3),(22,21),(23,3),(23,21),(24,3),(24,21),(25,3),(25,21),(27,22),(28,22),(29,23),(30,23),(31,23),(32,23),(33,23),(34,23),(35,23),(36,23),(37,23),(38,23),(39,23),(40,23),(41,24),(41,25),(41,27),(42,24),(43,24),(44,24),(45,24),(46,24),(46,25),(47,25),(48,25),(49,26),(50,26),(51,26),(52,26),(53,26),(54,26),(55,1),(55,26),(56,26),(56,27),(56,32),(57,26),(58,26),(59,26),(60,26),(61,26),(62,26),(63,26),(64,26),(65,26),(66,26),(67,3),(67,21),(68,27),(69,27),(70,27),(71,27),(72,27),(73,27),(74,27),(75,27),(76,27),(77,27),(78,27),(79,27),(80,27),(81,27),(82,27),(83,27),(84,27),(85,27),(86,27),(87,27),(88,27),(89,27),(90,27),(91,27),(92,27),(93,27),(94,28),(95,28),(96,28),(97,28),(98,6),(98,28),(99,6),(99,28),(100,28),(101,1),(101,2),(102,1),(102,2),(103,1),(103,2),(104,1),(104,2),(105,1),(105,2),(106,6),(107,6),(108,6),(109,6),(110,6),(111,6),(112,6),(113,6),(114,6),(115,6),(116,6),(117,6),(118,6),(119,6),(120,6),(121,6),(122,6),(123,6),(124,6),(125,6),(126,6),(127,6),(128,6),(129,6),(130,6),(131,6),(132,6),(133,6),(134,6),(135,6),(136,6),(137,6),(138,6),(139,6),(140,6),(141,6),(142,6);

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
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linktoolbar` */

insert  into `uchome_linktoolbar`(`toolbarid`,`postuid`,`classid`,`subject`,`url`,`description`,`css`,`viewnum`,`replynum`,`storenum`,`hot`,`dateline`,`hashurl`) values (1,1,1,'百度','http://www.baidu.com','','',0,0,0,0,0,42886333),(2,1,1,'google','http://www.google.com','','',0,0,0,0,1274336489,1920443229),(3,1,1,'新浪','http://www.sina.com.cn/','','',0,0,0,0,1274336579,83839535),(4,0,1,'搜狐','http://www.sohu.com','','',0,0,0,0,0,0),(5,0,2,'新浪新闻','http://news.sina.com.cn/','','',0,0,0,0,0,0);

/*Table structure for table `uchome_linktoolbartype` */

DROP TABLE IF EXISTS `uchome_linktoolbartype`;

CREATE TABLE `uchome_linktoolbartype` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `toolbarname` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

/*Data for the table `uchome_linktoolbartype` */

insert  into `uchome_linktoolbartype`(`id`,`toolbarname`) values (1,'常用类'),(2,'资讯类'),(3,'购物类'),(4,'娱乐类'),(5,'生活类'),(6,'在线工具'),(7,'常用工具');

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

insert  into `uchome_session`(`uid`,`username`,`password`,`name`,`lastactivity`,`ip`,`magichidden`) values (10,'ramen.sh@gmail.com','b4f248ca9a48ff6359b60a51111458fc','城市森林',1284109364,192168115,0);

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
  `description` text NOT NULL,
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
  `end` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `class` (`class`),
  KEY `starttime` (`starttime`),
  KEY `endtime` (`endtime`)
) ENGINE=MyISAM AUTO_INCREMENT=41145 DEFAULT CHARSET=utf8;

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

insert  into `uchome_siteclass`(`classid`,`parentid`,`classname`,`displayorder`,`sitenum`,`path`,`keywords`,`description`) values (1,0,'娱乐休闲',1,0,'','',''),(2,0,'生活服务',2,0,'','',''),(3,0,'文化教育',4,0,'','',''),(4,0,'电脑网络',3,0,'','',''),(644,1,'小说',106,0,'xiaoshuo','',''),(645,644,'小说阅读',1,25,'','',''),(647,2209,'小说论坛',4,14,'','',''),(648,644,'作家作品',3,30,'','',''),(649,644,'文化文学',2,15,'','',''),(2101,783,'风水玄学',4,5,'','',''),(2103,1588,'室内设计',3,9,'','',''),(652,1,'摄影',117,0,'sheying','',''),(653,2199,'网络相册',3,15,'','',''),(1923,2172,'明星后援会',5,27,'','',''),(1603,755,'北京电台',1,5,'','',''),(2156,1036,'各学科课件教案',4,0,'','',''),(658,2,'娱乐',123,0,'yule','',''),(659,658,'娱乐综合',1,22,'','',''),(1973,731,'搞笑视频',2,5,'','',''),(1924,2172,'网络红人',6,18,'','',''),(662,2,'两性',115,0,'sex','',''),(663,662,'两性健康',1,20,'','',''),(664,2218,'女性',1,25,'','',''),(665,2218,'男士',4,10,'','',''),(1978,921,'电子优惠券',4,5,'','',''),(2028,1596,'软件游戏',6,9,'','',''),(668,4,'博客',108,0,'blog','',''),(669,668,'博客',1,32,'','',''),(670,668,'博客周边',2,10,'','',''),(1931,2209,'教育论坛',22,9,'','',''),(673,668,'网摘/书签',3,12,'','',''),(674,1,'社区',114,0,'bbs','',''),(675,674,'综合论坛',1,45,'','',''),(1937,1936,'北京论坛',1,7,'','',''),(678,2209,'软件论坛',6,34,'','',''),(1933,2209,'旅游论坛',20,13,'','',''),(680,2209,'安全防毒论坛',7,6,'','',''),(681,2209,'硬件论坛',5,18,'','',''),(2160,974,'科普知识',2,6,'','',''),(684,2209,'贴图论坛',14,9,'','',''),(685,2209,'笑话论坛',15,10,'','',''),(686,2209,'音乐论坛',3,25,'','',''),(2104,1588,'建筑设计',4,4,'','',''),(689,2209,'数码论坛',8,8,'','',''),(690,2209,'手机论坛',9,15,'','',''),(691,2209,'军事论坛',10,8,'','',''),(1936,674,'地方论坛',3,0,'','',''),(693,2209,'股市论坛',11,25,'','',''),(1932,2209,'人生论坛',17,8,'','',''),(2077,2209,'足球论坛',13,17,'','',''),(697,2209,'体育论坛',12,20,'','',''),(698,1,'游戏',103,0,'games','',''),(699,698,'游戏综合',1,25,'','',''),(700,765,'手机游戏/电影',3,10,'','',''),(701,2215,'小游戏',2,19,'','',''),(703,2209,'游戏论坛',16,14,'','',''),(704,698,'游戏下载',6,8,'','',''),(706,698,'单机电玩',8,10,'','',''),(2145,795,'数码影像',100,5,'','',''),(708,1,'美图',110,0,'bizhi','',''),(709,708,'综合图库',1,15,'','',''),(710,708,'明星美女',3,9,'','',''),(711,2219,'桌面壁纸',1,22,'','',''),(712,2219,'桌面主题美化',4,8,'','',''),(2110,1588,'设计竞标',6,4,'','',''),(715,1,'音乐',101,0,'music','',''),(716,715,'在线音乐',1,24,'','',''),(717,715,'音乐周边',4,10,'','',''),(719,2223,'音乐翻唱/原创音乐',6,9,'','',''),(720,715,'DJ舞曲',2,10,'','',''),(725,1,'军事',118,0,'junshi','',''),(726,725,'军事资讯',1,20,'','',''),(727,725,'军事论坛',2,13,'','',''),(728,2168,'军事刊物',3,14,'','',''),(729,2168,'军事史',4,30,'','',''),(730,725,'军人天地',5,8,'','',''),(731,1,'笑话',113,0,'fun','',''),(732,731,'笑话大全',1,14,'','',''),(733,731,'很囧很雷人',3,9,'','',''),(734,2,'时尚',118,0,'fashion','',''),(735,734,'时尚资讯',1,15,'','',''),(736,2218,'美容',2,18,'','',''),(737,2188,'化妆品牌',4,20,'','',''),(738,734,'时尚杂志',4,14,'','',''),(739,921,'饮食综合',1,19,'','',''),(2197,921,'菜谱大全',2,5,'','',''),(741,4,'聊天',109,0,'liaotian_qq','',''),(742,741,'聊天室',2,14,'','',''),(2146,1711,'掌上电脑',100,5,'','',''),(744,741,'聊天工具',1,18,'','',''),(745,741,'QQ相关',5,13,'','',''),(1930,2209,'特色论坛',2,40,'','',''),(748,2226,'电视电台',106,0,'dianshi','',''),(749,2167,'热播电视台',2,24,'','',''),(2051,2050,'亚洲旅游局',1,12,'','',''),(751,748,'地方电视台',4,0,'','',''),(752,748,'电视资讯/节目预告表',1,10,'','',''),(2031,891,'旅游景点',5,7,'','',''),(754,2167,'热门广播电台',5,27,'','',''),(755,748,'地方电台',5,0,'','',''),(756,748,'网络电台',2,9,'','',''),(757,4,'Flash',126,0,'flash-show','',''),(758,757,'Flash欣赏',1,13,'','',''),(759,757,'休闲小游戏',2,15,'','',''),(760,757,'Flash教程',4,10,'','',''),(762,757,'Flash技术',5,5,'','',''),(765,2,'手机',110,0,'shouji','',''),(766,765,'手机综合',1,20,'','',''),(767,765,'手机论坛',4,14,'','',''),(768,765,'手机厂商',7,12,'','',''),(769,765,'手机图铃/短信',6,10,'','',''),(770,765,'手机报价',2,5,'','',''),(1975,803,'网络电视',10,5,'','',''),(774,2091,'通信资讯',1,10,'','',''),(775,2091,'电信运营商',0,4,'','',''),(776,1,'动漫',112,0,'dongman','',''),(777,776,'动漫综合',1,15,'','',''),(778,776,'动漫下载',4,8,'','',''),(779,776,'动漫专题',8,10,'','',''),(783,1,'星相',111,0,'xingzuo','',''),(784,783,'星座',1,15,'','',''),(785,783,'算命占卜',2,20,'','',''),(786,783,'生肖/解梦',3,5,'','',''),(787,783,'心理测试',5,5,'','',''),(2027,1596,'商业财经',7,9,'','',''),(789,1,'交友',115,0,'love','',''),(790,789,'交友综合',1,20,'','',''),(791,789,'婚嫁婚介',3,15,'','',''),(792,789,'情感爱情',2,9,'','',''),(1977,757,'Flash音乐',3,5,'','',''),(795,4,'数码',121,0,'shuma_shishang','',''),(796,795,'数码综合',1,17,'','',''),(799,1711,'MP3/MD',7,9,'','',''),(800,795,'数码论坛',2,8,'','',''),(801,1711,'摄像头厂商',3,25,'','',''),(1713,1076,'特色搜索',6,20,'','',''),(803,1,'视频',102,0,'vedio','',''),(1981,776,'在线漫画',3,8,'','',''),(805,2212,'在线电影',2,8,'','',''),(2068,698,'游戏周边',9,15,'','',''),(813,2,'彩票',109,0,'caipiao','',''),(814,813,'彩票门户',1,13,'','',''),(815,813,'福利彩票',3,32,'','',''),(816,813,'体育彩票',4,38,'','',''),(817,813,'足球彩票',5,10,'','',''),(2059,2193,'地方宠物网',7,10,'','',''),(820,2,'宠物',116,0,'pet','',''),(821,820,'宠物综合',1,15,'','',''),(822,820,'花草花卉',9,9,'','',''),(824,1,'明星',116,0,'star','',''),(825,824,'解读明星',1,11,'','',''),(826,824,'名模写真',2,4,'','',''),(827,2172,'大陆明星',1,22,'','',''),(828,2172,'港台明星',2,26,'','',''),(829,2172,'国外明星',3,37,'','',''),(2155,2034,'球迷天下',100,0,'','',''),(831,1,'新闻',104,0,'news','',''),(832,831,'新闻综合',1,30,'','',''),(835,668,'博客搜索引擎',5,5,'','',''),(837,831,'国内知名报刊',2,25,'','',''),(838,831,'地方报刊',5,0,'','',''),(842,2,'股票',103,0,'gupiao','',''),(843,842,'财经资讯',1,20,'','',''),(844,842,'股票论坛/博客',4,18,'','',''),(845,2148,'热门证券公司',6,47,'','',''),(847,2148,'财经报刊',4,21,'','',''),(848,842,'股评研究',3,10,'','',''),(850,2148,'股票分析软件',3,5,'','',''),(851,2,'购物',105,0,'gouwu','',''),(852,851,'网上购物',1,23,'','',''),(853,851,'图书/音像',8,9,'','',''),(2134,662,'两性用品',2,4,'','',''),(1717,924,'工艺饰品',5,17,'','',''),(856,2,'银行',106,28,'bank','',''),(1688,2204,'外资银行',5,20,'','',''),(858,856,'内地银行',1,19,'','',''),(860,856,'保险资讯',2,12,'','',''),(1721,871,'北京医院',1,35,'','',''),(2049,912,'案例分析',8,9,'','',''),(863,2,'健康',111,0,'health','',''),(864,863,'健康医疗',1,20,'','',''),(2207,2205,'地方法律援助网',100,7,'','',''),(866,2203,'艾滋病防治',9,11,'','',''),(2206,2205,'地方律师网',100,22,'','',''),(869,2203,'医学研究',5,19,'','',''),(870,2203,'医院管理',7,4,'','',''),(871,863,'各地医院',5,2,'','',''),(872,2203,'医药药品',5,33,'','',''),(873,2226,'招商加盟',101,0,'zhaoshang','',''),(2133,2219,'系统美化论坛',5,5,'','',''),(2153,1020,'足球世界',3,13,'','',''),(878,2,'房产',108,0,'house','',''),(879,878,'家居装修',2,18,'','',''),(881,878,'房地产',1,24,'','',''),(883,2,'亲子',113,0,'qinzi','',''),(884,883,'亲子育儿',1,25,'','',''),(2167,748,'热门电视电台',3,0,'','',''),(886,883,'儿童教育',2,11,'','',''),(888,883,'亲子论坛',5,9,'','',''),(889,883,'游戏童谣',6,10,'','',''),(890,883,'素质教育',3,8,'','',''),(891,2,'旅游',117,0,'travel','',''),(892,891,'旅游资讯',1,23,'','',''),(893,891,'各地旅游',7,0,'','',''),(2050,891,'各国旅游局',8,0,'','',''),(895,891,'旅行社/酒店/机票',2,15,'','',''),(2024,2229,'病毒防治',3,20,'','',''),(2039,715,'音乐播放软件',10,5,'','',''),(899,2226,'政府部门',103,0,'zhengfu','',''),(902,899,'地方政府',3,0,'','',''),(903,2179,'国家信息中心',2,23,'','',''),(904,2186,'国际组织',5,52,'','',''),(905,899,'各国政府',5,0,'','',''),(2085,891,'自助户外游',6,5,'','',''),(907,2,'生活',122,0,'life','',''),(908,907,'时尚生活',1,15,'','',''),(912,2,'法律',112,0,'law','',''),(913,912,'法律综合',1,24,'','',''),(914,2205,'地方法院',7,29,'','',''),(915,912,'律师网站',3,10,'','',''),(916,912,'知识产权',5,6,'','',''),(2284,2226,'地方服务',102,0,'html/local/index.htm','',''),(921,2,'美食',119,0,'foods','',''),(2080,921,'食疗养生',3,5,'','',''),(1919,831,'国际知名媒体',4,15,'','',''),(924,2226,'鲜花礼品',110,0,'lipin','',''),(925,924,'礼品',1,10,'','',''),(926,924,'玩具',3,10,'','',''),(927,1,'体育',107,0,'tiyu','',''),(928,927,'体育综合',1,20,'','',''),(929,927,'体育论坛',6,10,'','',''),(930,2034,'NBA专题',1,9,'','',''),(931,2150,'户外运动',13,21,'','',''),(934,2150,'羽毛球',17,10,'','',''),(935,2150,'乒乓球',18,24,'','',''),(937,2150,'网球',9,20,'','',''),(2081,2186,'驻华使馆/领事馆',101,27,'','',''),(940,2150,'高尔夫',16,13,'','',''),(941,2150,'气功养生',25,14,'','',''),(944,2150,'排球',14,14,'','',''),(946,3,'大学',7,0,'xiaoyuan_gaoxiao','',''),(947,2246,'同学录',2,5,'','',''),(2078,2149,'高校BBS论坛',6,55,'','',''),(2055,2050,'大洋洲旅游局',5,4,'','',''),(950,946,'地方高校',9,7,'','',''),(951,2149,'国内名校',4,20,'','',''),(2023,2239,'交通地图',3,10,'','',''),(2158,974,'基础学科',4,0,'','',''),(955,2149,'各大学图书馆',5,77,'','',''),(2054,2050,'美洲旅游局',4,6,'','',''),(957,2,'招聘',121,0,'rencai','',''),(958,957,'人才招聘',1,25,'','',''),(959,957,'地方人才网',6,0,'','',''),(960,957,'简历写作',3,7,'','',''),(961,3,'教育',1,0,'jiaoyu','',''),(962,961,'教育综合',1,20,'','',''),(964,961,'幼儿教育',2,9,'','',''),(2283,873,'招商加盟',0,5,'','',''),(966,961,'基础教育',3,9,'','',''),(967,961,'职业教育',6,4,'','',''),(969,961,'成人教育',5,5,'','',''),(970,961,'特殊教育',8,5,'','',''),(2061,2173,'地方礼品',2,20,'','',''),(2088,961,'高等教育',4,4,'','',''),(974,3,'科技',2,0,'kexue_jishu','',''),(975,974,'科技综合',1,14,'','',''),(976,2158,'生物学',5,15,'','',''),(977,2158,'地理学',8,14,'','',''),(978,2158,'化学',6,15,'','',''),(979,2158,'数学',13,12,'','',''),(980,2158,'物理学',12,15,'','',''),(981,2158,'天文学',11,19,'','',''),(983,2158,'历史学',9,21,'','',''),(984,2158,'经济学',3,25,'','',''),(985,2158,'政治学',7,11,'','',''),(986,2158,'心理学',1,9,'','',''),(987,2158,'哲学',2,14,'','',''),(2105,1588,'服装设计',5,8,'','',''),(989,2159,'重点实验室',17,20,'','',''),(2265,2264,'考研论坛',100,6,'','',''),(991,2161,'考试招生',0,20,'','',''),(992,2161,'自学考试',7,10,'','',''),(993,2264,'考研综合',2,14,'','',''),(994,2161,'司法考试',11,14,'','',''),(995,2161,'财会考试',11,15,'','',''),(996,2161,'公务员考试',1,9,'','',''),(998,2161,'计算机考试',10,8,'','',''),(999,2161,'MBA管理培训',9,7,'','',''),(2087,1011,'纹身',9,2,'','',''),(1001,2263,'高考资讯',3,15,'','',''),(1003,3,'人文',11,0,'shehui_wenhua','',''),(1004,1003,'社会文化',1,20,'','',''),(2164,2224,'道教网址',2,4,'','',''),(1006,2225,'公益网站',6,13,'','',''),(2163,2224,'佛教网址',1,17,'','',''),(2162,1003,'历史名人',100,5,'','',''),(1009,1003,'历史人文',2,5,'','',''),(2239,2,'地图',126,0,'map','',''),(1011,3,'爱好',13,0,'yishu_aihao','',''),(1012,1011,'艺术鉴赏',0,15,'','',''),(1015,1011,'书法艺术',3,10,'','',''),(2149,946,'中国大学',4,0,'','',''),(1017,1011,'美术绘画',2,9,'','',''),(1018,2223,'相声小品评书',1,11,'','',''),(1019,1011,'收藏艺术',1,20,'','',''),(1020,1,'足球',108,0,'football','',''),(1021,1020,'足球综合',1,15,'','',''),(1036,3,'论文',8,0,'kejian_lunwen','',''),(1037,1036,'课件资源',2,11,'','',''),(1038,2156,'数学课件教案',4,4,'','',''),(1039,2156,'英语课件教案',5,9,'','',''),(1040,2156,'语文课件教案',6,9,'','',''),(1699,1682,'网吧联盟',2,36,'','',''),(1698,1682,'网管技术',3,26,'','',''),(1043,1036,'免费论文',1,14,'','',''),(1044,3,'外语',3,0,'waiyu_xuexi','',''),(1045,1044,'英语学习',1,25,'','',''),(2150,927,'各类运动项目',100,0,'','',''),(1047,1044,'在线翻译',2,13,'','',''),(2270,1131,'网页制作辅助',100,10,'','',''),(2165,2224,'基督教网站',3,6,'','',''),(1050,1044,'其他语种学习',5,13,'','',''),(1051,3,'留学',12,0,'chuguo_liuxue','',''),(1052,1051,'出国留学',1,15,'','',''),(1053,1051,'各国移民留学',3,10,'','',''),(1054,1051,'移民',2,5,'','',''),(1696,957,'行业人才',5,42,'','',''),(1695,957,'威客网址',4,8,'','',''),(2034,1,'NBA',109,0,'nba','',''),(1068,2199,'国内免费邮箱',1,15,'','',''),(1689,1711,'MP4相关',3,9,'','',''),(1076,4,'搜索',122,0,'Sousuo_Yinqing','',''),(1077,1076,'搜索',1,10,'','',''),(2159,974,'科学研究',5,0,'','',''),(1686,1711,'MP3/MP4品牌',2,15,'','',''),(1082,2226,'国外网站',105,0,'guowai','',''),(1084,1082,'综合门户',2,42,'','',''),(1085,1082,'国外软件',14,32,'','',''),(1086,1082,'报刊杂志',11,91,'','',''),(1087,1082,'国外免费邮箱',9,10,'','',''),(1088,1082,'海外华人网',3,30,'','',''),(1089,1082,'搜索引擎',1,13,'','',''),(1090,1082,'国外硬件',15,31,'','',''),(1091,1082,'新闻网址',4,25,'','',''),(1092,1082,'体育网址',5,20,'','',''),(1093,1082,'国外电影',9,37,'','',''),(1094,1082,'流行时尚',8,24,'','',''),(1095,4,'硬件',120,0,'Yingjian_Zixun','',''),(1096,1095,'硬件资讯',1,17,'','',''),(1097,2147,'硬件品牌',1,86,'','',''),(1711,795,'数码相关',100,0,'','',''),(1099,2147,'笔记本电脑',3,15,'','',''),(1101,1095,'硬件评测',2,9,'','',''),(1102,1095,'驱动程序',4,8,'','',''),(1103,1095,'硬件论坛',3,10,'','',''),(1104,2147,'服务器资讯',4,15,'','',''),(1105,4,'软件',103,0,'soft','',''),(1106,1105,'软件下载',1,22,'','',''),(1107,1105,'软件论坛',5,9,'','',''),(1109,1105,'装机软件',3,5,'','',''),(1110,1588,'字体下载',8,8,'','',''),(1285,803,'视频播客',1,20,'','',''),(1113,2120,'BT下载',2,14,'','',''),(1114,2120,'P2P软件',8,10,'','',''),(1284,2120,'P2P辅助',9,4,'','',''),(1117,1082,'国外下载',6,18,'','',''),(1118,1105,'驱动下载',2,9,'','',''),(1119,2212,'电影下载',4,10,'','',''),(1121,4,'IT',101,0,'it','',''),(1122,1121,'IT资讯',0,30,'','',''),(1123,2147,'电脑公司',2,20,'','',''),(1124,2198,'电脑教程',3,10,'','',''),(1126,2198,'电脑报刊',4,20,'','',''),(1709,1131,'站长资讯',2,10,'','',''),(2107,1588,'设计素材',1,16,'','',''),(1131,4,'建站',125,0,'Jianzhan_Sheji','',''),(1132,1131,'网页制作',1,16,'','',''),(1133,2220,'域名主机',1,14,'','',''),(2047,2204,'国内地方银行',3,30,'','',''),(1138,4,'黑客',105,0,'Heike_Anquan','',''),(1139,1138,'黑客/安全站点',1,18,'','',''),(1358,1138,'黑客论坛',4,14,'','',''),(2212,1,'电影',105,0,'movie','',''),(1142,2229,'安全防毒论坛',5,7,'','',''),(1143,2226,'免费资源',109,0,'free','',''),(1704,2186,'区域组织',7,13,'','',''),(2142,1143,'免费信息发布',2,5,'','',''),(1146,1143,'免费主页空间',5,5,'','',''),(1147,1143,'免费域名',4,5,'','',''),(1705,1082,'专项体育',6,15,'','',''),(2113,1131,'论坛 CMS',4,10,'','',''),(1150,1143,'免费留言本',8,3,'','',''),(1151,1143,'免费论坛申请',5,7,'','',''),(1152,4,'编程',124,0,'Chengxu_Biancheng','',''),(1153,1152,'编程开发',1,15,'','',''),(2259,2198,'网管技术',100,5,'','',''),(1155,2169,'ASP',4,17,'','',''),(1156,2169,'Java',12,17,'','',''),(1157,2169,'Linux',13,17,'','',''),(1158,2169,'Delphi',11,8,'','',''),(1159,2169,'C/C++/C#',10,8,'','',''),(1160,2169,'PHP',5,15,'','',''),(1161,2169,'Wap',7,5,'','',''),(1162,2169,'VB',9,10,'','',''),(1163,2169,'JSP',6,8,'','',''),(2063,2173,'地方工艺饰品',6,8,'','',''),(1165,2169,'Power Builder',14,7,'','',''),(1166,2169,'数据库编程',0,8,'','',''),(1167,2169,'CGI',8,6,'','',''),(1168,2,'汽车',107,0,'car','',''),(1169,1168,'汽车资讯',1,30,'','',''),(1170,2175,'汽车企业汇总',9,31,'','',''),(1171,1168,'汽车配件',5,20,'','',''),(1642,1251,'投资理财',1,15,'','',''),(2208,2205,'地方知识产权局',100,28,'','',''),(2200,1121,'IT博客',100,9,'','',''),(2188,907,'各类品牌汇总',5,0,'','',''),(2189,907,'衣食住行用',1,24,'','',''),(2205,912,'知法维权',100,0,'','',''),(2202,863,'寻医问药',2,10,'','',''),(2193,820,'宠物相关',100,0,'','',''),(1251,2,'基金',104,0,'jijin','',''),(1253,873,'企业黄页',4,12,'','',''),(2209,674,'各类论坛',2,0,'','',''),(2058,2155,'篮球迷网站',5,18,'','',''),(1270,2220,'网站推广',4,13,'','',''),(1926,873,'电子商务',3,18,'','',''),(2035,891,'天气预报',4,5,'qixiangditu','',''),(2057,2034,'中国篮协CBA',3,9,'','',''),(1282,765,'手机软件/电子书',5,10,'','',''),(1289,950,'北京高校',-3,69,'','',''),(1290,950,'天津高校',-1,24,'','',''),(1291,950,'上海高校',-2,40,'','',''),(1292,950,'江苏高校',2,39,'','',''),(1293,950,'浙江高校',4,35,'','',''),(1294,950,'湖北高校',9,34,'','',''),(1295,950,'广东高校',1,62,'','',''),(1296,950,'陕西高校',18,34,'','',''),(1297,950,'四川高校',8,40,'','',''),(1298,950,'重庆高校',0,13,'','',''),(1299,950,'辽宁高校',7,43,'','',''),(1300,950,'黑龙江高校',12,26,'','',''),(1301,950,'湖南高校',11,31,'','',''),(1302,950,'山东高校',3,35,'','',''),(1303,950,'安徽高校',13,32,'','',''),(1304,950,'山西高校',19,15,'','',''),(1305,950,'吉林高校',16,27,'','',''),(1306,950,'福建高校',10,24,'','',''),(1307,950,'河南高校',5,32,'','',''),(1308,950,'河北高校',6,35,'','',''),(1309,950,'内蒙古高校',20,21,'','',''),(1310,950,'江西高校',14,27,'','',''),(1311,950,'广西高校',15,24,'','',''),(1312,950,'海南高校',24,10,'','',''),(1313,950,'贵州高校',22,16,'','',''),(1314,950,'云南高校',17,17,'','',''),(1315,950,'西藏高校',27,3,'','',''),(1316,950,'甘肃高校',23,21,'','',''),(1317,950,'青海高校',25,9,'','',''),(1318,950,'宁夏高校',26,10,'','',''),(1319,950,'新疆高校',21,16,'','',''),(1320,950,'香港高校',531,15,'','',''),(1321,2149,'211工程高校名单',2,108,'','',''),(1322,946,'各国大学/高校',10,0,'','',''),(1323,950,'澳门高校',532,10,'','',''),(1324,950,'台湾省高校',533,25,'','',''),(1325,1322,'美国高校',1,20,'','',''),(1326,1322,'英国高校',2,8,'','',''),(1327,1322,'加拿大高校',3,6,'','',''),(1328,1322,'日本高校',5,16,'','',''),(1329,1322,'新加坡高校',4,2,'','',''),(1330,1322,'韩国高校',6,10,'','',''),(1331,1322,'澳大利亚高校',7,8,'','',''),(1332,1322,'新西兰高校',8,4,'','',''),(1342,1322,'西班牙高校',11,8,'','',''),(1341,1322,'德国高校',10,12,'','',''),(1335,1322,'比利时高校',12,4,'','',''),(1336,1322,'瑞士高校',13,6,'','',''),(1337,1322,'葡萄牙高校',14,2,'','',''),(1338,1322,'瑞典高校',15,2,'','',''),(1339,1322,'荷兰高校',16,2,'','',''),(1340,1322,'奥地利高校',17,3,'','',''),(1343,1322,'法国高校',9,12,'','',''),(1345,820,'水族爬虫',4,15,'','',''),(1346,820,'动物保护',8,8,'','',''),(1347,820,'猫猫狗狗',3,10,'','',''),(2062,2173,'地方玩具',4,10,'','',''),(2199,4,'邮箱',102,0,'mail','',''),(1350,2193,'地方宠物医院',7,12,'','',''),(1351,820,'宠物鸟',5,3,'','',''),(2135,776,'动漫视频',2,5,'','',''),(1360,1138,'国外黑客组织',6,10,'','',''),(1359,1138,'在线工具',2,19,'','',''),(1361,751,'福建电视台',10,9,'','',''),(1362,751,'北京电视台',-3,4,'','',''),(1363,751,'上海电视台',-2,3,'','',''),(1364,751,'天津电视台',-1,1,'','',''),(1365,751,'河北电视台',6,5,'','',''),(1366,751,'山东电视台',3,10,'','',''),(1367,751,'山西电视台',19,3,'','',''),(1368,751,'内蒙古电视台',20,1,'','',''),(1369,751,'江苏电视台',2,8,'','',''),(1370,751,'浙江电视台',4,9,'','',''),(1371,751,'安徽电视台',13,4,'','',''),(1372,751,'广东电视台',1,18,'','',''),(1373,751,'广西电视台',15,2,'','',''),(1374,751,'海南电视台',24,2,'','',''),(1375,751,'河南电视台',5,10,'','',''),(1376,751,'湖北电视台',9,8,'','',''),(1377,751,'湖南电视台',11,3,'','',''),(1378,751,'江西电视台',14,5,'','',''),(1379,751,'辽宁电视台',7,8,'','',''),(1380,751,'吉林电视台',16,3,'','',''),(1381,751,'黑龙江电视台',12,4,'','',''),(1382,751,'陕西电视台',18,4,'','',''),(1383,751,'宁夏电视台',26,1,'','',''),(1384,751,'甘肃电视台',23,4,'','',''),(1385,751,'青海电视台',25,2,'','',''),(1386,751,'新疆电视台',21,2,'','',''),(1387,751,'重庆电视台',0,2,'','',''),(1388,751,'四川电视台',8,9,'','',''),(1389,751,'贵州电视台',22,6,'','',''),(1390,751,'云南电视台',17,10,'','',''),(1391,751,'西藏电视台',27,1,'','',''),(1392,751,'台湾电视台',28,7,'','',''),(1393,751,'香港电视台',29,6,'','',''),(1394,751,'澳门电视台',30,2,'','',''),(1518,959,'广东人才',1,19,'','',''),(1925,1082,'国外相册',13,6,'','',''),(1519,959,'北京人才',-3,22,'','',''),(1520,959,'四川人才',8,12,'','',''),(1521,959,'青海人才',25,10,'','',''),(1522,959,'新疆人才',21,11,'','',''),(1523,959,'云南人才',17,15,'','',''),(1524,959,'甘肃人才',23,11,'','',''),(1525,959,'黑龙江人才',12,10,'','',''),(1526,959,'山东人才',3,13,'','',''),(1527,959,'江苏人才',2,27,'','',''),(1528,959,'浙江人才',4,21,'','',''),(1529,959,'上海人才',-2,17,'','',''),(1530,959,'江西人才',14,7,'','',''),(1531,959,'福建人才',10,14,'','',''),(1532,959,'内蒙古人才',20,16,'','',''),(1533,959,'西藏人才',27,7,'','',''),(1534,959,'河北人才',6,9,'','',''),(1535,959,'河南人才',5,7,'','',''),(1536,959,'宁夏人才',26,13,'','',''),(1537,959,'陕西人才',18,14,'','',''),(1538,959,'重庆人才',0,9,'','',''),(1539,959,'海南人才',24,11,'','',''),(1540,959,'贵州人才',22,14,'','',''),(1541,959,'辽宁人才',7,11,'','',''),(1542,959,'吉林人才',16,14,'','',''),(1543,959,'安徽人才',13,11,'','',''),(1544,959,'湖南人才',11,12,'','',''),(1545,959,'湖北人才',9,9,'','',''),(1546,959,'山西人才',19,11,'','',''),(1547,959,'天津人才',-1,11,'','',''),(1554,838,'上海报刊',-2,38,'','',''),(1553,838,'北京报刊',-3,17,'','',''),(1555,838,'天津报刊',-1,4,'','',''),(1551,959,'广西人才',15,15,'','',''),(1552,959,'港澳台人才',28,15,'','',''),(1556,838,'重庆报刊',0,7,'','',''),(1557,838,'广东报刊',1,49,'','',''),(1558,838,'江苏报刊',2,11,'','',''),(1559,838,'山东报刊',3,28,'','',''),(1560,838,'浙江报刊',4,30,'','',''),(1561,838,'河南报刊',5,18,'','',''),(1562,838,'河北报刊',6,9,'','',''),(1563,838,'辽宁报刊',7,19,'','',''),(1564,838,'四川报刊',8,23,'','',''),(1565,838,'湖北报刊',9,18,'','',''),(1566,838,'福建报刊',10,25,'','',''),(1567,838,'湖南报刊',11,19,'','',''),(1568,838,'黑龙江报刊',12,5,'','',''),(1569,838,'安徽报刊',13,13,'','',''),(1570,838,'江西报刊',14,8,'','',''),(1571,838,'广西报刊',15,15,'','',''),(1572,838,'吉林报刊',16,9,'','',''),(1573,838,'云南报刊',17,10,'','',''),(1574,838,'陕西报刊',18,9,'','',''),(1575,838,'山西报刊',19,14,'','',''),(1576,838,'内蒙古报刊',20,4,'','',''),(1577,838,'新疆报刊',21,0,'','',''),(1578,838,'贵州报刊',22,6,'','',''),(1579,838,'甘肃报刊',23,3,'','',''),(1580,838,'海南报刊',24,8,'','',''),(1581,838,'青海报刊',25,1,'','',''),(1582,838,'宁夏报刊',26,3,'','',''),(1583,838,'西藏报刊',27,1,'','',''),(1584,838,'香港报刊',28,7,'','',''),(1585,838,'澳门报刊',29,5,'','',''),(1586,838,'台湾报刊',30,6,'','',''),(1938,1936,'天津论坛',3,5,'','',''),(1588,4,'设计',123,0,'design','',''),(2102,1588,'平面设计',2,10,'','',''),(1596,2226,'Wap网址',107,0,'wap','',''),(1597,1596,'WAP搜索',1,5,'','',''),(1598,1596,'综合门户',2,25,'','',''),(1599,1596,'论坛社区',5,19,'','',''),(1600,1596,'图铃娱乐',3,13,'','',''),(1601,1596,'移动书城',4,18,'','',''),(1604,755,'上海电台',3,6,'','',''),(1605,755,'天津电台',2,7,'','',''),(1606,755,'河北电台',100,5,'','',''),(1607,755,'山东电台',100,11,'','',''),(1608,755,'山西电台',100,4,'','',''),(1609,755,'内蒙古电台',104,3,'','',''),(1610,755,'江苏电台',100,9,'','',''),(1611,755,'浙江电台',100,8,'','',''),(1612,755,'安徽电台',100,1,'','',''),(1613,755,'福建电台',100,9,'','',''),(1614,755,'广东电台',100,12,'','',''),(1615,755,'广西电台',100,2,'','',''),(1616,755,'河南电台',100,7,'','',''),(1617,755,'湖北电台',100,7,'','',''),(1618,755,'湖南电台',100,4,'','',''),(1619,755,'江西电台',100,5,'','',''),(1620,755,'辽宁电台',100,7,'','',''),(1621,755,'吉林电台',100,2,'','',''),(1622,755,'黑龙江电台',100,2,'','',''),(1623,755,'陕西电台',100,6,'','',''),(1624,755,'宁夏电台',100,1,'','',''),(1625,755,'甘肃电台',100,1,'','',''),(1626,755,'青海电台',101,1,'','',''),(1627,755,'新疆电台',102,3,'','',''),(1628,755,'重庆电台',100,0,'','',''),(1629,755,'四川电台',100,4,'','',''),(1630,755,'贵州电台',100,2,'','',''),(1631,755,'云南电台',100,2,'','',''),(1632,755,'西藏电台',103,0,'','',''),(1633,755,'台湾电台',100,0,'','',''),(1634,755,'香港电台',100,1,'','',''),(1635,755,'澳门电台',105,1,'','',''),(1645,1251,'基金理财',1,10,'','',''),(1646,1251,'外汇资讯',6,8,'','',''),(1647,1251,'期货资讯',7,4,'','',''),(1648,1251,'黄金资讯',8,5,'','',''),(1649,1251,'证券债券',3,10,'','',''),(1687,2204,'港澳台银行',4,20,'','',''),(1652,1251,'风险投资',9,2,'','',''),(1662,1168,'报价交易',2,9,'','',''),(1663,1168,'二手车',4,8,'','',''),(1664,1168,'汽车论坛',3,10,'','',''),(1665,2175,'各地汽车网',5,26,'','',''),(1666,2175,'汽车品牌',6,50,'','',''),(1670,2150,'武术',12,14,'','',''),(1671,2150,'棋牌',11,21,'','',''),(1672,2223,'舞蹈',2,6,'','',''),(1673,2150,'钓鱼',10,12,'','',''),(1675,2150,'水上运动',23,8,'','',''),(1676,2150,'冰雪运动',22,4,'','',''),(1677,2150,'民间体育',21,7,'','',''),(1678,927,'健美健身',20,5,'','',''),(2152,1020,'足球彩票',2,5,'','',''),(1680,2223,'乐器',3,15,'','',''),(2168,725,'国防教育',100,0,'','',''),(1682,1682,'网吧技术',6,0,'Wangba_Lianmeng','',''),(2092,2091,'中国各地铁通',100,30,'','',''),(1690,946,'中国大学排行榜',3,5,'','',''),(1691,2246,'校园综合',1,13,'','',''),(1700,1682,'网吧综合',1,30,'','',''),(1701,1143,'免费在线翻译',3,14,'','',''),(1702,2199,'免费网络硬盘',2,9,'','',''),(1706,1082,'体育组织',7,29,'','',''),(1707,1082,'软件公司',12,34,'','',''),(1708,2203,'国外医院',5,17,'','',''),(1714,1076,'MP3搜索',2,5,'','',''),(1715,1076,'免费登陆口',4,5,'','',''),(1716,1152,'源码下载',2,14,'','',''),(2138,851,'快递物流',10,10,'','',''),(2053,2050,'非洲旅游局',3,2,'','',''),(1720,851,'网上支付',9,10,'pay_tools','',''),(1722,871,'天津医院',2,11,'','',''),(1723,871,'河北医院',100,12,'','',''),(1724,871,'山西医院',100,6,'','',''),(1725,871,'内蒙古医院',100,3,'','',''),(1726,871,'辽宁医院',100,12,'','',''),(1727,871,'吉林医院',100,9,'','',''),(1728,871,'黑龙江医院',100,12,'','',''),(1729,871,'上海医院',3,32,'','',''),(1730,871,'江苏医院',100,24,'','',''),(1731,871,'浙江医院',100,14,'','',''),(1732,871,'安徽医院',100,7,'','',''),(1733,871,'福建医院',100,21,'','',''),(1734,871,'江西医院',100,11,'','',''),(1735,871,'山东医院',100,10,'','',''),(1736,871,'河南医院',100,10,'','',''),(1737,871,'湖北医院',100,10,'','',''),(1738,871,'湖南医院',100,7,'','',''),(1739,871,'广东医院',100,30,'','',''),(1740,871,'广西医院',100,8,'','',''),(1741,871,'海南医院',100,5,'','',''),(1742,871,'重庆医院',100,5,'','',''),(1743,871,'四川医院',100,2,'','',''),(1744,871,'贵州医院',100,6,'','',''),(1745,871,'云南医院',100,6,'','',''),(1746,871,'西藏医院',100,1,'','',''),(1747,871,'陕西医院',100,4,'','',''),(1748,871,'甘肃医院',100,3,'','',''),(1749,871,'宁夏医院',100,4,'','',''),(1750,871,'新疆医院',100,2,'','',''),(1751,871,'香港医院',101,3,'','',''),(1752,871,'澳门医院',102,4,'','',''),(1753,871,'台湾医院',103,6,'','',''),(1754,871,'青海医院',100,2,'','',''),(2201,734,'奢侈品',3,5,'','',''),(1756,2159,'工程研究中心',16,26,'','',''),(1757,2159,'中外科技网站',18,28,'','',''),(1758,2159,'科学研究机构',15,18,'','',''),(2056,2155,'NBA球队',4,29,'','',''),(2203,863,'医疗相关',6,0,'','',''),(1761,878,'地方房产',3,6,'','',''),(1762,1761,'北京房产',1,8,'','',''),(1763,1761,'天津房产',2,3,'','',''),(1764,1761,'河北房产',99,2,'','',''),(1765,1761,'山西房产',100,1,'','',''),(1766,1761,'内蒙古房产',104,1,'','',''),(1767,1761,'辽宁房产',99,7,'','',''),(1768,1761,'吉林房产',100,1,'','',''),(1769,1761,'黑龙江房产',100,2,'','',''),(1770,1761,'上海房产',3,13,'','',''),(1771,1761,'江苏房产',99,8,'','',''),(1772,1761,'浙江房产',99,7,'','',''),(1773,1761,'安徽房产',100,3,'','',''),(1774,1761,'福建房产',99,12,'','',''),(1775,1761,'江西房产',99,5,'','',''),(1776,1761,'山东房产',99,10,'','',''),(1777,1761,'河南房产',99,4,'','',''),(1778,1761,'湖北房产',99,4,'','',''),(1779,1761,'湖南房产',99,1,'','',''),(1780,1761,'广东房产',99,12,'','',''),(1781,1761,'广西房产',99,6,'','',''),(1782,1761,'海南房产',100,2,'','',''),(1783,1761,'重庆房产',100,2,'','',''),(1784,1761,'四川房产',100,4,'','',''),(1785,1761,'贵州房产',100,1,'','',''),(1786,1761,'云南房产',100,2,'','',''),(1787,1761,'西藏房产',100,1,'','',''),(1788,1761,'陕西房产',99,3,'','',''),(1789,1761,'甘肃房产',100,2,'','',''),(1790,1761,'青海房产',101,2,'','',''),(1791,1761,'宁夏房产',100,1,'','',''),(1792,1761,'新疆房产',102,1,'','',''),(1793,1761,'香港房产',105,0,'','',''),(1794,1761,'台湾房产',106,0,'','',''),(1797,893,'北京旅游',1,23,'','',''),(1798,893,'天津旅游',2,10,'','',''),(1799,893,'河北旅游',100,5,'','',''),(1800,893,'山西旅游',100,8,'','',''),(1801,893,'内蒙古旅游',100,5,'','',''),(1802,893,'辽宁旅游',100,17,'','',''),(1803,893,'吉林旅游',100,8,'','',''),(1804,893,'黑龙江旅游',100,15,'','',''),(1805,893,'上海旅游',3,10,'','',''),(1806,893,'江苏旅游',100,29,'','',''),(1807,893,'浙江旅游',100,20,'','',''),(1808,893,'安徽旅游',100,15,'','',''),(1809,893,'福建旅游',100,19,'','',''),(1810,893,'江西旅游',100,15,'','',''),(1811,893,'山东旅游',100,12,'','',''),(1812,893,'河南旅游',100,18,'','',''),(1813,893,'湖北旅游',100,14,'','',''),(1814,893,'湖南旅游',100,22,'','',''),(1815,893,'广东旅游',100,18,'','',''),(1816,893,'广西旅游',100,21,'','',''),(1817,893,'海南旅游',100,18,'','',''),(1818,893,'重庆旅游',100,13,'','',''),(1819,893,'四川旅游',100,31,'','',''),(1820,893,'贵州旅游',100,14,'','',''),(1821,893,'云南旅游',100,15,'','',''),(1822,893,'西藏旅游',100,11,'','',''),(1823,893,'陕西旅游',100,12,'','',''),(1824,893,'甘肃旅游',100,10,'','',''),(1825,893,'青海旅游',100,8,'','',''),(1826,893,'宁夏旅游',100,9,'','',''),(1827,893,'新疆旅游',100,12,'','',''),(1828,893,'香港旅游',101,11,'','',''),(1829,893,'澳门旅游',102,5,'','',''),(1830,893,'台湾旅游',103,10,'','',''),(1832,905,'亚洲地区',100,20,'','',''),(1833,905,'欧洲地区',100,46,'','',''),(1834,905,'北美地区',100,11,'','',''),(1835,905,'南美地区',100,4,'','',''),(1836,905,'非洲地区',100,3,'','',''),(1837,905,'大洋地区',100,3,'','',''),(1838,902,'北京政府机构',1,19,'','',''),(1839,902,'天津政府机构',2,11,'','',''),(1840,902,'河北政府机构',100,12,'','',''),(1841,902,'山西政府机构',100,11,'','',''),(1842,902,'内蒙古政府机构',103,15,'','',''),(1843,902,'辽宁政府机构',100,12,'','',''),(1844,902,'吉林政府机构',100,9,'','',''),(1845,902,'黑龙江政府机构',100,12,'','',''),(1846,902,'上海政府机构',3,18,'','',''),(1847,902,'江苏政府机构',100,14,'','',''),(1848,902,'浙江政府机构',100,11,'','',''),(1849,902,'安徽政府机构',100,18,'','',''),(1850,902,'福建政府机构',100,10,'','',''),(1851,902,'江西政府机构',100,11,'','',''),(1852,902,'山东政府机构',100,17,'','',''),(1853,902,'河南政府机构',100,19,'','',''),(1854,902,'湖北政府机构',100,16,'','',''),(1855,902,'湖南政府机构',100,9,'','',''),(1856,902,'广东政府机构',100,20,'','',''),(1857,902,'广西政府机构',100,10,'','',''),(1858,902,'海南政府机构',100,7,'','',''),(1859,902,'重庆政府机构',100,16,'','',''),(1860,902,'四川政府机构',100,19,'','',''),(1861,902,'贵州政府机构',100,16,'','',''),(1862,902,'云南政府机构',100,16,'','',''),(1863,902,'西藏政府机构',100,3,'','',''),(1864,902,'陕西政府机构',100,20,'','',''),(1865,902,'甘肃政府机构',100,13,'','',''),(1866,902,'青海政府机构',101,4,'','',''),(1867,902,'宁夏政府机构',100,5,'','',''),(1868,902,'新疆政府机构',102,0,'','',''),(1869,902,'香港特区政府',104,11,'','',''),(1870,902,'澳门特区政府',105,12,'','',''),(1871,2188,'服饰品牌',5,58,'','',''),(1872,2188,'餐饮食品',2,37,'','',''),(1873,2188,'生活日用',3,20,'','',''),(1874,2188,'汽车品牌',7,18,'','',''),(1875,2188,'家电品牌',8,43,'','',''),(1876,2188,'品牌电脑',9,18,'','',''),(1877,2188,'手机品牌',6,14,'','',''),(1878,912,'法律法规',2,15,'','',''),(1879,912,'法律援助',4,12,'','',''),(1880,2205,'商标法',6,17,'','',''),(1884,2225,'网上求助',6,6,'','',''),(2198,4,'电脑',104,0,'computer','',''),(1921,2168,'军事院校',6,9,'','',''),(1934,2209,'女性论坛',18,17,'','',''),(1935,2209,'服饰论坛',19,15,'','',''),(1939,1936,'河北论坛',14,8,'','',''),(1940,1936,'山西论坛',13,8,'','',''),(1941,1936,'内蒙古论坛',31,4,'','',''),(1942,1936,'辽宁论坛',25,7,'','',''),(1943,1936,'吉林论坛',16,3,'','',''),(1944,1936,'黑龙江论坛',5,4,'','',''),(1945,1936,'上海论坛',2,10,'','',''),(1946,1936,'江苏论坛',17,15,'','',''),(1947,1936,'浙江论坛',18,25,'','',''),(1948,1936,'安徽论坛',19,12,'','',''),(1949,1936,'福建论坛',20,17,'','',''),(1950,1936,'江西论坛',21,4,'','',''),(1951,1936,'山东论坛',22,17,'','',''),(1952,1936,'河南论坛',23,9,'','',''),(1953,1936,'湖北论坛',24,12,'','',''),(1954,1936,'湖南论坛',27,7,'','',''),(1955,1936,'广东论坛',8,26,'','',''),(1956,1936,'广西论坛',26,7,'','',''),(1957,1936,'海南论坛',15,5,'','',''),(1958,1936,'重庆论坛',4,6,'','',''),(1959,1936,'四川论坛',6,6,'','',''),(1960,1936,'贵州论坛',7,4,'','',''),(1961,1936,'云南论坛',28,3,'','',''),(1962,1936,'西藏论坛',30,2,'','',''),(1963,1936,'陕西论坛',8,5,'','',''),(1964,1936,'甘肃论坛',9,5,'','',''),(1965,1936,'青海论坛',10,2,'','',''),(1966,1936,'宁夏论坛',11,6,'','',''),(1967,1936,'新疆论坛',29,5,'','',''),(1968,1936,'香港论坛',101,4,'','',''),(1969,1936,'澳门论坛',102,3,'','',''),(1970,1936,'台湾论坛',103,1,'','',''),(1979,2209,'设计论坛',21,25,'','',''),(1980,2212,'影视资讯',5,14,'','',''),(2272,2034,'NBA直播',0,4,'','',''),(1984,1076,'搜索工具及相关',6,5,'','',''),(1985,2091,'中国各地移动',6,34,'','',''),(1986,2091,'中国各地联通',7,28,'','',''),(2169,1152,'各类编程学习',3,0,'','',''),(1988,2091,'中国各地电信',5,29,'','',''),(2276,831,'时事论坛',3,5,'','',''),(1990,851,'导购/打折',2,16,'','',''),(1991,851,'数码/家电',3,8,'','',''),(1992,851,'女性/母婴',5,10,'','',''),(2052,2050,'欧洲旅游局',2,13,'','',''),(1994,2175,'热门车型',8,34,'','',''),(1995,856,'保险公司',3,10,'','',''),(1996,2148,'热门基金公司',9,49,'','',''),(1997,1251,'基金数据',4,10,'','',''),(2204,856,'各地银行',5,0,'','',''),(2000,1044,'英语学习论坛',3,4,'','',''),(2263,3,'高考',5,0,'gaokao','',''),(2003,2161,'专业类考试',12,20,'','',''),(2004,1082,'著名通讯社',10,22,'','',''),(2030,1596,'博客影漫',8,10,'','',''),(2032,851,'两性/保健',4,6,'','',''),(2044,741,'QQ空间代码',3,10,'','',''),(2148,842,'财经相关',100,0,'','',''),(2147,1095,'硬件相关',100,0,'','',''),(2091,2,'通信',120,0,'tongxin','',''),(2094,2149,'中国科研院所',8,14,'','',''),(2114,2220,'流量统计',3,9,'','',''),(2099,2212,'电影字幕',9,5,'','',''),(2106,1588,'设计综合',0,20,'','',''),(2109,2220,'站长工具',2,20,'','',''),(2115,2155,'篮球协会',6,14,'','',''),(2116,2034,'篮球综合',2,4,'','',''),(2120,4,'BT',106,0,'BT','',''),(2121,652,'摄影综合',1,14,'','',''),(2122,652,'摄影论坛',3,9,'','',''),(2144,1711,'数码品牌',1,39,'','',''),(2139,856,'信用卡资讯',4,4,'','',''),(2140,2209,'动漫论坛',16,2,'','',''),(2141,698,'网页游戏',3,10,'','',''),(2161,3,'考试',4,0,'kaoshi','',''),(2166,2224,'伊斯兰教网址',4,4,'','',''),(2171,2169,'Ajax',100,2,'','',''),(2172,824,'明星全接触',3,0,'','',''),(2173,924,'地方礼品/工艺品',100,0,'','',''),(2174,924,'鲜花',2,5,'','',''),(2175,1168,'厂商/品牌/车型',100,0,'','',''),(2176,2175,'各地二手车网',100,20,'','',''),(2177,1168,'驾校学车',6,4,'','',''),(2178,899,'国家机构',0,4,'','',''),(2179,899,'中国政府机构',2,0,'','',''),(2180,899,'国务院组成部门',1,23,'','',''),(2182,2179,'国务院直属机构',100,20,'','',''),(2183,2179,'国务院办事机构',100,4,'','',''),(2184,2179,'国务院事业单位',100,27,'','',''),(2185,2179,'国务院部委管理国家局',100,10,'','',''),(2186,899,'国际/区域组织',4,0,'','',''),(2213,1,'网游',119,0,'http://game.114la.com/','',''),(2215,1,'小游戏',121,0,'xiaoyouxi','',''),(2216,2,'天气',101,0,'http://weather.114la.com/weather.htm','',''),(2217,2,'查询',102,0,'http://tool.114la.com/','',''),(2218,2,'女性',114,0,'lady','',''),(2219,4,'桌面',107,0,'desktop','',''),(2220,2226,'站长工具',125,0,'webtool','',''),(2240,2239,'交通',100,10,'','',''),(2222,4,'非主流',128,0,'http://qq.114la.com/','',''),(2223,3,'曲艺',10,0,'quyi','',''),(2224,3,'宗教',14,0,'zongjiao','',''),(2225,3,'公益',15,0,'gongyi','',''),(2226,0,'其他类别',5,0,'','',''),(2241,2239,'航空',100,10,'','',''),(2228,2226,'行业网站',104,0,'html/trade_sites.htm','',''),(2229,2226,'杀毒防毒',108,0,'shadu','',''),(2234,2218,'减肥',100,8,'','',''),(2235,662,'两性论坛',3,5,'','',''),(2236,662,'男士女性',4,14,'','',''),(2237,2223,'魔术杂技',4,5,'','',''),(2238,2223,'地方戏',5,11,'','',''),(2242,803,'免费电影',2,8,'','',''),(2246,3,'校园',9,0,'xiaoyuan','',''),(2253,698,'小游戏',2,5,'','',''),(2254,2215,'合金弹头',100,8,'','',''),(2255,2215,'火影忍者',100,8,'','',''),(2256,2215,'格斗小游戏',100,8,'','',''),(2258,715,'轻音乐',3,5,'','',''),(2260,1121,'网络编辑',100,3,'','',''),(2261,2226,'奇趣酷站',119,0,'cool','',''),(2262,2261,'搜趣探奇',100,25,'','',''),(2264,3,'考研',6,0,'kaoyan','',''),(2268,2229,'木马/恶意插件查杀',100,10,'','','');

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

insert  into `uchome_space`(`uid`,`groupid`,`credit`,`experience`,`username`,`name`,`linknum`,`bmdirnum`,`lastmodified`,`namestatus`,`videostatus`,`domain`,`friendnum`,`viewnum`,`notenum`,`addfriendnum`,`mtaginvitenum`,`eventinvitenum`,`myinvitenum`,`pokenum`,`doingnum`,`blognum`,`albumnum`,`threadnum`,`pollnum`,`eventnum`,`sharenum`,`dateline`,`updatetime`,`lastsearch`,`lastpost`,`lastlogin`,`lastsend`,`attachsize`,`addsize`,`addfriend`,`flag`,`newpm`,`avatar`,`regip`,`ip`,`mood`,`style`) values (1,1,1288,1278,'admin','admin',150,136,'12759632048978050',1,0,'',0,20,0,0,0,0,0,0,1,28,1,0,0,0,8,1256533858,1275962394,0,1269013828,1275962394,0,1295171,0,0,1,0,1,'192.168.115.1',192168115,0,0),(2,6,132,122,'ramen','',0,0,'0',0,0,'',0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1261707439,1261707463,0,1261707463,1273015459,0,0,0,0,0,0,0,'192.168.115.1',192168115,0,0),(3,5,88,77,'lele','',0,0,'0',0,0,'',0,5,1,0,0,0,0,0,0,3,0,0,0,0,0,1262551556,1264752700,0,1264768602,1273015486,0,0,0,0,0,0,0,'192.168.115.1',192168115,0,0),(4,6,150,135,'osk','',0,0,'0',0,0,'',0,2,0,0,0,0,0,0,0,6,0,0,0,0,0,1262551844,1264679950,0,1264679950,1264768741,0,0,0,0,0,0,0,'192.168.115.1',192168115,0,0),(5,1,40,30,'moyiqun','',0,0,'0',0,0,'',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1268063077,0,0,0,1275599326,0,0,0,0,0,0,0,'192.168.1.110',192168001,0,0),(6,5,25,15,'myqsq@sohu.com','沈大宝',0,0,'',0,0,'',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1274701531,0,0,0,1274702368,0,0,0,0,0,0,0,'192.168.115.1',192168115,0,0),(7,5,25,15,'myq@gmail.com','xiaoxiao',0,0,'',0,0,'',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1274709069,0,0,0,1274709069,0,0,0,0,0,0,0,'192.168.115.1',192168115,0,0),(8,1,40,30,'ra@123.com','1234',0,0,'',0,0,'',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1274717119,0,0,0,1275430782,0,0,0,0,1,0,0,'192.168.115.1',192168115,0,0),(9,5,25,15,'ra1@123.com','1234',0,0,'',0,0,'',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1274717309,0,0,0,1274717309,0,0,0,0,0,0,0,'192.168.115.1',192168115,0,0),(10,1,329,319,'ramen.sh@gmail.com','城市森林',10,2,'1281325773639800',0,0,'',0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,1275429834,1276290634,0,1276290634,1284087022,0,0,0,0,1,0,0,'192.168.115.1',192168115,0,0);

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

insert  into `uchome_spacefield`(`uid`,`sex`,`email`,`newemail`,`emailcheck`,`mobile`,`qq`,`msn`,`msnrobot`,`msncstatus`,`videopic`,`birthyear`,`birthmonth`,`birthday`,`blood`,`marry`,`birthprovince`,`birthcity`,`resideprovince`,`residecity`,`note`,`spacenote`,`authstr`,`theme`,`nocss`,`menunum`,`css`,`privacy`,`friend`,`feedfriend`,`sendmail`,`magicstar`,`magicexpire`,`timeoffset`,`field_1`) values (1,0,'ramen.sh@gmail.com','',0,'','','','',0,'',0,0,0,'',0,'','','','','SO_LINGER\r\n\r\n   此选项指定函数close对面向连接的协议如何操作（如TCP）。缺省close操作是立即返回，如果有数据残留在套接口缓冲区中则系统将试着将这些数据发送给对方。\r\n\r\n\r\nSO_LINGER选项用来改变此缺省设置。使','','','',0,0,'','','','','',0,0,'',''),(2,0,'ramen.sh@gmail.com','',0,'','','','',0,'',0,0,0,'',0,'','','','','','','1272084695	1	gAy33V','',0,0,'','','','','',0,0,'',''),(3,0,'myqsq@sohu.com','',0,'','','','',0,'',0,0,0,'',0,'','','','','','','1272083508	1	Vk66Kd','',0,0,'','','','','',0,0,'',''),(4,0,'osk@123.com','',0,'','','','',0,'',0,0,0,'',0,'','','','','','','','',0,0,'','','','','',0,0,'',''),(5,0,'moyiqun_lele@sina.com','',0,'','','','',0,'',0,0,0,'',0,'','','','','','','','',0,0,'','','','','',0,0,'',''),(6,0,'myqsq@sohu.com','',0,'','','','',0,'',0,0,0,'',0,'','','','','','','','',0,0,'','','','','',0,0,'',''),(7,0,'myq@gmail.com','',0,'','','','',0,'',0,0,0,'',0,'','','','','','','','',0,0,'','','','','',0,0,'',''),(8,0,'ra@123.com','',0,'','','','',0,'',0,0,0,'',0,'','','','','','','','',0,0,'','','','','',0,0,'',''),(9,0,'ra1@123.com','',0,'','','','',0,'',0,0,0,'',0,'','','','','','','','',0,0,'','','','','',0,0,'',''),(10,0,'ramen.sh@gmail.com','',0,'','','','',0,'',0,0,0,'',0,'','','','','','','','',0,0,'','','','','',0,0,'','');

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







