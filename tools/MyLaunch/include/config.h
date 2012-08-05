#ifndef CONFIG_H_
#define CONFIG_H_

#ifdef QT_NO_DEBUG
#undef TOUCH_ANY_DEBUG
#define CONFIG_RELEASE
#else
#define TOUCH_ANY_DEBUG
#undef CONFIG_RELEASE
#endif

#include "version.h"



/******feature*******/

#define CONFIG_NEW_UI
#define CONFIG_UI_WEBKIT 
#define CONFIG_RAMEN_CODE
#define CONFIG_HTTP_TIMEOUT
#define CONFIG_SYNC_THREAD
#define CONFIG_BOOKMARK_TODB
#define POST_DOWN_AFTER_MERGE
#define CONFIG_AUTH_ENCRYPTION
#undef LOCALBM_COMPRESS_ENABLE 
#define CONFIG_SERVER_IP_SETTING
#define CONFIG_OPTION_NEWUI
#define BROWSER_FIREFOX_BIN_NAME "firefox.exe"
#define CONFIG_ACTION_LIST
#define CONFIG_AUTO_LEARN_PROCESS
#define CONFIG_DIGG_XML
#undef CONFIG_SKIN_CONFIGURABLE
#undef CONFIG_INPUT_WITH_ICON
#define OUTPUT_ICON_DEFAULT_SIZE 48
#if    OUTPUT_ICON_DEFAULT_SIZE==48
#define MULTIPLE_ICON_SIZE 2
#else
#define MULTIPLE_ICON_SIZE 2
#endif

/***********defines*****************/
enum{
	POST_HTTP_ACTION_DELETE_ITEM=0,
	POST_HTTP_ACTION_DELETE_DIR,
	POST_HTTP_ACTION_ADD_ITEM,
	POST_HTTP_ACTION_ADD_DIR,	
	DOWN_LOCAL_ACTION_ADD_ITEM,
	DOWN_LOCAL_ACTION_ADD_DIR,
	DOWN_LOCAL_ACTION_DELETE_ITEM,
	DOWN_LOCAL_ACTION_DELETE_DIR
};

enum{
	COME_FROM_SHORTCUT=1,
	COME_FROM_PREDEFINE,
	COME_FROM_COMMAND,
	COME_FROM_PROGRAM,
	COME_FROM_LEARNPROCESS,
	COME_FROM_MYBOOKMARK,
	COME_FROM_NETBOOKMARK,
	COME_FROM_IE,
	COME_FROM_FIREFOX,
	COME_FROM_OPERA,
	COME_FROM_MAX
};
#define COME_FROM_BROWSER COME_FROM_NETBOOKMARK
#define IS_FROM_BROWSER(x) (((x)>=COME_FROM_BROWSER)&&((x)<COME_FROM_MAX))
#define COMEFROM_TO_BROWSER_ID(x) ((x)-COME_FROM_BROWSER)
#define BROWSER_ID_TO_COMEFROM(x) ((x)+COME_FROM_BROWSER)


#define BROWSE_TYPE_NETBOOKMARK		(COME_FROM_NETBOOKMARK-COME_FROM_BROWSER)
#define BROWSE_TYPE_IE 		(COME_FROM_IE-COME_FROM_BROWSER)
#define BROWSE_TYPE_FIREFOX 	(COME_FROM_FIREFOX-COME_FROM_BROWSER)
#define BROWSE_TYPE_OPERA		(COME_FROM_OPERA-COME_FROM_BROWSER)
#define BROWSE_TYPE_MAX 		(COME_FROM_MAX-COME_FROM_BROWSER)


#define SYN_MODE_SILENCE  0
#define SYN_MODE_NOSILENCE  1

#define BM_EQUAL 1
#define BM_MODIFY 2
#define BM_DELETE 3
#define BM_DIFFERENT 4
#define BM_ADD 5

#define MERGE_FROM_SERVER 0
#define MERGE_FROM_LOCAL 1

#define ACTION_ITEM_DELETE 0
#define ACTION_ITEM_ADD 1

#define MERGE_TYPE_EQUAL_UNDO 0
#define MERGE_TYPE_EQUAL_ADD 1

#define NAME_IS_FILE 1
#define NAME_IS_DIR 2

#define	POST_HTTP_TYPE_TESTACCOUNT  1
#define    POST_HTTP_TYPE_HANDLE_ITEM 2

/*updatestatus flag*/
#define UPDATESTATUS_FLAG_APPLY 0
#define UPDATESTATUS_FLAG_RETRY 1

#define BOOKMARK_CATAGORY_FLAG 1
#define BOOKMARK_ITEM_FLAG 2

#define FIREFOX_VERSION_2 2
#define FIREFOX_VERSION_3 3

#define SETTING_MERGE_LOCALTOSERVER  0
#define SETTING_MERGE_SERVERTOLOCAL  1

#define SETTING_MERGE_MODE_DOWNLOAD 0
#define SETTING_MERGE_MODE_CHECKFILE 1

#define HTTP_OK 200
#define HTTP_FILE_NOT_FOUND 404



#define HOTKEY_PART_0 Qt::ControlModifier
#define HOTKEY_PART_1 Qt::Key_Enter

#define NET_BOOKMARK_GROUPID_START 8000

#define REGISTER_GET_MODE 0
#define REGISTER_SET_MODE 1

#define UPDATE_SILENT_MODE 0
#define UPDATE_DLG_MODE 1

#define SECONDS 1000
#define MINUTES  (60*SECONDS)
#define HOURS (60*MINUTES)
#define DAYS (24*HOURS)

/**************string*******************/
#define LABEL_FILE 0
#define LAUNCHY_VERSION 220
#define LAUNCHY_VERSION_STRING "2.2.0"
#define VERSION_FILE "version.h"
#define SERVER_VERSION_FILE_PHP "index.php"

#define APP_NAME "touchAny"
#define APP_SLOGAN "everything_is_in_touch"

#define HTTP_SERVER_HOST "192.168.115.2"
#define HTTP_SERVER_URL "http://"HTTP_SERVER_HOST"/"
#define BM_SERVER_ADDRESS HTTP_SERVER_HOST
#define BM_SERVER_GET_BMXML_URL HTTP_SERVER_URL"do.php?ac=bmxml&source=client&auth=%1&authkey=%2&tm=%3"
#define BM_SERVER_TESTACCOUNT_URL HTTP_SERVER_URL"do.php?ac=testaccount&source=client&auth=%1&authkey=%2"
#define BM_SERVER_ADD_URL "/cp.php?ac=bmdir&op=add&bmdirid=%1&browserid=%2&source=client&auth=%3&authkey=%4"
#define BM_SERVER_ADD_DIR BM_SERVER_ADD_URL
#define BM_SERVER_DELETE_URL "/cp.php?ac=bookmark&op=delete&bmid=%1&browserid=%2&source=client&auth=%3&authkey=%4"
#define BM_SERVER_DELETE_DIR  "/cp.php?ac=bmdir&op=delete&bmdirid=%1&browserid=%2&source=client&auth=%3&authkey=%4"
#define BM_TEST_ACCOUNT_URL "/do.php?testAccount.php&"
#define BM_SERVER_GET_DIGGXML_URL HTTP_SERVER_URL"do.php?ac=diggxml&source=client"
#define BM_XML_FROM_FIREFOX  "firefox.xml"
#define DOSUCCESSS  "do_success"
#define DEFAULT_LANGUAGE 0 //chinese
#define DO_NOTHING   "do_nothing"
#define TIME_FORMAT "yyyy-MM-dd hh:mm:ss"
#define TIME_INIT_STR "1970-01-01 00:00:00"
#define LOCAL_BM_SETTING_FILE_NAME "localbm.dat"
#define LOCAL_BM_TMP_FOR_BUILD "bmtmp.dat"
#define IE_BM_XML_FILE_NAME "iefav.xml"
#define LOCAL_BM_SETTING_INTERVAL "@@$$=$$@@"
#define DB_DATABASE_NAME APP_NAME".db"
#define APP_INI_NAME APP_NAME".ini"

#define DB_TABLE_SUFFIX APP_NAME
#define LOGIN_FALIL_STRING   "login_failure_please_re_login"
#define LAUNCH_BM_TABLE "launch_bm"
#define LANGUAGE_APPLY "apply"
#define LANGUAGE_RETRY "retry"
#define LANGUAGE_CANCEL "cancel"
#define LANGUAGE_REJECT "reject"
#define PINYIN_DB_FILENAME "pinyin.db"
#define PINYIN_DB_TABLENAME "pytable"
#define DIGG_XML_LOCAL_FILE "./data/digg.xml"
#define APP_HKEY_PATH "HKEY_LOCAL_MACHINE\\Software\\zhiqiu\\launchy"
#define APP_HEKY_UPDATE_ITEM "updaterflag"
#define APP_SILENT_UPDATE_NAME "updater.exe"
#define APP_PROGRAM_NAME  "tanzhi.exe"
#define APP_SETUP_NAME "setup.exe"
#define APP_FILEMD5_NAME "fmd5.exe"
#define APP_DATA_PATH "data"
#define APP_DEFINE_DB_NAME "defines.db"
#define UPDATE_SERVER_HOST HTTP_SERVER_HOST
#define TEST_NET_URL HTTP_SERVER_URL"testnet.php"
#define TOUCHANY_VERSION_URL HTTP_SERVER_URL"download/index.php"
#define TEST_DIGGXML_URL  HTTP_SERVER_URL"do.php?ac=testdiggxml"
#define UPDATE_DIRECTORY "temp"
#define UPDATE_DIRECTORY_SUFFIX UPDATE_DIRECTORY"/"
#define UPDATE_PORTABLE_DIRECTORY    UPDATE_DIRECTORY"/portable/"
#define UPDATE_SETUP_DIRECTORY    UPDATE_DIRECTORY"/setup/"
#define UPDATE_FILE_NAME "update.ini"
#define UPDATE_SERVER_URL UPDATE_FILE_NAME
#define CONFIG_USER_INI_BACKUP_FILE "config.user"
#define CONFIG_USER_CONFIG_DIR "config"
#define UPDATE_PORTABLE_KEYWORD    "portable"
#define UPDATE_SETUP_KEYWORD    "setup"
#define FAVICO_DIRECTORY "ico"
#define FROMSERVER_XML_PREFIX "from_server_xml_"
#define BROKEN_TOKEN_STR "$#@#$"


/**************code*******************/

#define IS_NULL(x) (((x)==NULL)||((x)==(void*)0xcdcdcdcd)) 
#define TOCHAR(str) ((str).toLatin1().data())
#define LOG_RUN_LINE qDebug("Call function %s()  %d in the file %s",__FUNCTION__,__LINE__,__FILE__);
#define SHAREPTRPRINT(X) (X?X.get():0)


/**************parameters*******************/
#define MAX_SEARCH_RESULT 10


#ifdef CONFIG_SERVER_IP_SETTING
#define SET_SERVER_IP(x,y) do{\
		QString serverIp = (x)->value("serverip","" ).toString().trimmed();\
		if( !serverIp.isEmpty())\
			(y).replace(BM_SERVER_ADDRESS,serverIp);\
	}while(0);	
#define SET_HOST_IP(x,y) do{\
		QString serverIp = (x)->value("serverip","" ).toString().trimmed();\
		if( !serverIp.isEmpty())\
			(y)->setHost(serverIp);\
		else\
			(y)->setHost(BM_SERVER_ADDRESS);\
	}while(0);

#endif


#define SET_RUN_PARAMETER(x,y) tz::runParameter(SET_MODE,(x),(y))
#define GET_RUN_PARAMETER(x) tz::runParameter(GET_MODE,(x), 0)


#define SET_NET_PROXY(x,y) \
	tz::netProxy(SET_MODE,(y),NULL);\
	if( GET_RUN_PARAMETER(RUN_PARAMETER_NETPROXY_ENABLE)){\
		QNetworkProxy* netProxy = NULL;\
		tz::netProxy(GET_MODE,NULL,&netProxy);\
		(x)->setProxy(*netProxy);	\
	}

#define IS_URL(x)\
	(((x).trimmed().startsWith("http://",Qt::CaseInsensitive))||((x).trimmed().startsWith("https://",Qt::CaseInsensitive)))

#ifdef QT_NO_DEBUG
#define CPU_USAGE_THRESHOLD 20
#else
#define CPU_USAGE_THRESHOLD 100
#endif

#define Q_RECORD_INDEX(x,y) (x).record().indexOf(y)
#define Q_VALUE_STRING(x,y) (x).value(Q_RECORD_INDEX((x),(y))).toString()
#define Q_VALUE_STRING_HTML(x,y) (x).value(Q_RECORD_INDEX((x),(y))).toString().replace("\\", "\\\\")
#define Q_VALUE_STRING_HTML_P(x,y) (x).value(Q_RECORD_INDEX((x),(y))).toString().replace("\\", "\\\\\\\\")

#define Q_VALUE_UINT(x,y) (x).value(Q_RECORD_INDEX((x),(y))).toUInt()


#define Q_PTR_RECORD_INDEX(x,y) (x)->record().indexOf(y)
#define Q_PTR_VALUE_STRING(x,y) (x)->value(Q_PTR_RECORD_INDEX((x),(y))).toString()
#define Q_PTR_VALUE_UINT(x,y) (x)->value(Q_PTR_RECORD_INDEX((x),(y))).toUInt()


#define QSETTING_VALUE_STRING(x,y) (x)->value(y).toString()
#define QSETTING_VALUE_STRINGLIST(x,y) (x)->value(y).toStringList()
#define QSETTING_VALUE_STRING_HTML(x,y) (x)->value(y).toString().replace("\\", "\\\\")
#define QSETTING_VALUE_STRING_HTML_P(x,y) (x)->value(y).toString().replace("\\", "\\\\\\\\")
#define QSETTING_VALUE_INT(x,y,def) (x)->value((y),(def)).toInt()
#define QSETTING_VALUE_UINT(x,y,def) (x)->value((y),(def)).toUInt()
#define QSETTING_VALUE_BOOL(x,y,def) (x)->value((y),(def)).toBool()


#define NO_PINYIN_FLAG 0
#define HAS_PINYIN_FLAG 1


#define BIND_CATITEM_QUERY(x,y) do{\
	(x)->bindValue(":fullPath", (y).fullPath);\
	(x)->bindValue(":shortName", (y).shortName);\
	(x)->bindValue(":lowName", (y).lowName);\
	(x)->bindValue(":realname", (y).realname);\
	(x)->bindValue(":icon", (y).icon);\
	(x)->bindValue(":usage", (y).usage);\
	(x)->bindValue(":hashId", qHash((y).shortName));\
	(x)->bindValue(":isHasPinyin", (y).isHasPinyin);\
	(x)->bindValue(":comeFrom", (y).comeFrom);\
	(x)->bindValue(":time", (y).time);\
	(x)->bindValue(":pinyinReg", (y).pinyinReg);\
	(x)->bindValue(":allchars", (y).allchars);\
	(x)->bindValue(":alias2", (y).alias2);\
	(x)->bindValue(":domain", (y).domain);\
	(x)->bindValue(":shortCut", (y).shortCut);\
	(x)->bindValue(":delId", (y).delId);\
	(x)->bindValue(":args", (y).args);\
	(x)->bindValue(":groupId", (y).groupId);\
	(x)->bindValue(":parentId", (y).parentId);\
	(x)->bindValue(":type", (y).type);\
}while(0);

#define UPDATE_CATITEM_QUERY(x,y) do{\
	(x)->bindValue(":fullPath", (y).fullPath);\
	(x)->bindValue(":shortName", (y).shortName);\
	(x)->bindValue(":lowName", (y).lowName);\
	(x)->bindValue(":realname", (y).realname);\
	(x)->bindValue(":icon", (y).icon);\
	(x)->bindValue(":usage", (y).usage);\
	(x)->bindValue(":hashId", qHash((y).shortName));\
	(x)->bindValue(":isHasPinyin", (y).isHasPinyin);\
	(x)->bindValue(":comeFrom", (y).comeFrom);\
	(x)->bindValue(":time", (y).time);\
	(x)->bindValue(":pinyinReg", (y).pinyinReg);\
	(x)->bindValue(":allchars", (y).allchars);\
	(x)->bindValue(":alias2", (y).alias2);\
	(x)->bindValue(":domain", (y).domain);\
	(x)->bindValue(":shortCut", (y).shortCut);\
	(x)->bindValue(":delId", (y).delId);\
	(x)->bindValue(":args", (y).args);\
}while(0);

	
#define NOW_SECONDS  (QDateTime::currentDateTime().toTime_t())


#define DELETE_OBJECT(x) if(x){	delete (x);(x)=NULL;}

#define STOP_TIMER(x) if((x)&&(x)->isActive()) {(x)->stop();}
#define DELETE_SHAREOBJ(x) if(x) (x).reset();
#define DELETE_TIMER(x) \
	STOP_TIMER(x)\
	DELETE_OBJECT(x)
#define DELETE_FILE(x)	if(x){ if((x)->isOpen()) (x)->close();delete (x);(x)=NULL; }

#define NEW_TIMER(x) x = new QTimer(this);


#define PASSWORD_ENCRYPT_KEY 98122130
#define JS_APPEND_VALUE(x,y,defval) jsStr.append("$obj("#x").value ='"+settings->value((!QString(y).isEmpty())?y"/"x:x, defval).toString().replace("\\", "\\\\")+"';");
#define JS_APPEND_CHECKED(x,y,defval) jsStr.append("$obj("#x").checked ="+(settings->value((!QString(y).isEmpty())?y"/"x:x, defval).toBool()?QString("true"):QString("false"))+";");
#define JS_APPEND_PASSWD(x,y,defval) jsStr.append("$obj("#x").value ='"+tz::decrypt(settings->value((!QString(y).isEmpty())?y"/"x:x, defval).toString(),PASSWORD_ENCRYPT_KEY)+"';");


#define COMMAND(NAME) { NAME, NAME##_command }
#define LINK_MULTIPLE(a,b,c,d) a##_##b##_##c##_##d
//#define KERNEL_DEBUG_A(LEVEL,format, args...)  do{  printk("\033[0;31m%s %s %d....................\033[0m\n",__FILE__,__FUNCTION__,__LINE__);printk(format , ## args);}while(0);
//#define myprintf(templt,args...) fprintf(stderr,templt,args)
//#define myprintf(templt,...) fprintf(stderr,templt,__VA_ARGS__)

#define START_TIMER_ASYN(x,single,time,func) \
	(x)=new QTimer();\
	(x)->setSingleShot(single);\
	(x)->moveToThread(this);\
	connect((x), SIGNAL(timeout()), this, SLOT(func##()), Qt::DirectConnection);\
	(x)->start(time);

#define START_TIMER_INSIDE(x,single,time,func) \
	(x)=new QTimer();\
	(x)->setSingleShot(single);\
	(x)->moveToThread(this);\
	connect((x), SIGNAL(timeout()), this, SLOT(func##()), Qt::DirectConnection);\
	(x)->start(time);

	
#define START_TIMER_SYN(x,single,time,func) \
	(x)=new QTimer(this);\
	(x)->setSingleShot(single);\
	connect((x), SIGNAL(timeout()), this, SLOT(func##()), Qt::DirectConnection);\
	(x)->start(time);



#define THREAD_IS_RUNNING(x) ((x)&&(x)->isRunning())
#define THREAD_IS_FINISHED(x) ((x)&&(x)->isFinished())
#define TIMER_IS_ACTIVE(x) ((x)&&(x)->isActive())


enum CONFIG_NOTIFY{
	HOTKEY=0,
	SHOWTRAY,
	DIRLIST,
	CMDLIST,
	NETPROXY,
	NET_SEARCH_MODIFY,
	NET_ACCOUNT_MODIFY
};

#define THREAD_MONITOR_POINT \
	if(QThread::currentThread()!=this)\
		qDebug("%s %d currentthreadid=0x%08x this=0x%08x",__FUNCTION__,__LINE__,QThread::currentThread(),this);

enum {
	HTTP_UNCONNECTED=0,
	HTTP_HOSTLOOKUP,
	HTTP_CONNECTING,
	HTTP_SENDING,
	HTTP_READING,
	HTTP_CONNECTED,
	HTTP_CLOSING,
	HTTP_TIMEOUT,
	HTTP_TEST_ACCOUNT_SUCCESS,
	HTTP_TEST_ACCOUNT_FAIL,
	HTTP_GET_INI_FAILED,
	HTTP_GET_INI_SUCCESSFUL,
	HTTP_GET_INI_NOT_EXISTED,
	HTTP_GET_FILE_SUCCESSFUL,
	HTTP_GET_FILE_NOT_EXISTED,
	HTTP_GET_FILE_FAILED,
	HTTP_NEED_RETRY,
	TRY_CONNECT_SERVER,
	
	UPDATE_FAILED,
	UPDATE_SUCCESSFUL,	
	UPDATE_NO_NEED,
	UPDATE_NET_ERROR,	
	UPDATE_PROCESSING,
	UPDATE_SERVER_REFUSE,	
	UPDATE_NET_ERROR_PROXY,
	UPDATE_NET_ERROR_PROXY_AUTH,

	BM_SYNC_START,
	BM_SYNC_SUCCESS_NO_MODIFY,//merge success but no any action
	BM_SYNC_SUCCESS_WITH_MODIFY,//merge successful with action
	BM_SYNC_FAIL_LOGIN,
	BM_SYNC_FAIL_POST_HTTP,
	BM_SYNC_FAIL_SERVER_NET_ERROR,//can't connect to server	
	BM_SYNC_FAIL_SERVER_REFUSE,//server refuse sevice
	BM_SYNC_FAIL_SERVER_BMXML_FAIL,//get bm.xml file failed
	BM_SYNC_FAIL_BMXML_TIMEOUT,
	BM_SYNC_FAIL_MERGE_ERROR,//failed to merge data to server
	BM_SYNC_FAIL_PROXY_ERROR,//can't connect to proxy
	BM_SYNC_FAIL_PROXY_AUTH_ERROR,//auth failed when connect to proxy		
	BM_SYNC_FAIL_SERVER_TESTACCOUNT_FAIL,
	BM_SYNC_FAIL_SERVER_LOGIN,
	BM_SYNC_FAIL_DOWNLOCAL_WRITE_FILE,
	BM_SYNC_FAIL_DOWNLOCAL_DELETE_FILE,
	BM_SYNC_FAIL_DOWNLOCAL_DB_LOCK,
	BM_SYNC_FAIL_DOWNLOCAL_DB_QUERY,
	BM_SYNC_FAIL_EXCEED_TOTAL_NUM,
	BM_SYNC_FAIL_EXCEED_DIR_COUNT,
	BM_SYNC_FAIL_EXCEED_LEVEL,
	BM_SYNC_FAIL_GET_XML_FROM_SERVER,
	BM_SYNC_FAIL_READ_XML_FROM_SERVER,
	BM_SYNC_FAIL_READ_XML_LOCAL,
	BM_SYNC_FAIL_REMOVE_XML_LOCAL,
	SYNC_STATUS_MAX
};
enum{
	UPDATE_STATUS_ICON_LOADING=0,
	UPDATE_STATUS_ICON_SUCCESSFUL,
	UPDATE_STATUS_ICON_FAILED,
	UPDATE_STATUS_ICON_REFUSED
};
/*
enum{
	MERGE_STATUS_SUCCESS_NO_MODIFY=0,
	MERGE_STATUS_SUCCESS_WITH_MODIFY,
	MERGE_STATUS_FAIL_LOGIN,
	MERGE_STATUS_FAIL_POST_HTTP,
	MERGE_STATUS_FAIL_DOWNLOCAL_WRITE_FILE,
	MERGE_STATUS_FAIL_DOWNLOCAL_DELETE_FILE,
	MERGE_STATUS_FAIL_DOWNLOCAL_DB_LOCK,
	MERGE_STATUS_FAIL_DOWNLOCAL_DB_QUERY,
	MERGE_STATUS_FAIL_EXCEED_TOTAL_NUM,
	MERGE_STATUS_FAIL_EXCEED_DIR_COUNT,
	MERGE_STATUS_FAIL_EXCEED_LEVEL,
	MERGE_STATUS_FAIL_GET_XML_FROM_SERVER,
	MERGE_STATUS_FAIL_READ_XML_FROM_SERVER,
	MERGE_STATUS_FAIL_READ_XML_LOCAL,
	MERGE_STATUS_FAIL_REMOVE_XML_LOCAL,
	
};
*/


enum TEST_NET_RESULT{
	TEST_NET_REFUSE=0,
	TEST_NET_SUCCESS,
	TEST_NET_ERROR_PROXY,
	TEST_NET_ERROR_PROXY_AUTH,
	TEST_NET_ERROR_SERVER,
	TEST_NET_UNNEED
};





#define INIT_TIMER_ACTION_LIST(type,name,start,val)\
	timer_actionlist[type].actionType= type;\
	timer_actionlist[type].enable =  (gSettings->value("ck"##name, true).toBool())?1:0;\
	timer_actionlist[type].startAfterRun =  (uint)(start);\
	timer_actionlist[type].lastActionSeconds =gSettings->value("last"##name, 0).toUInt();\
	if(timer_actionlist[type].lastActionSeconds>runseconds)\
		timer_actionlist[type].lastActionSeconds=0;\
	timer_actionlist[type].faileds= 0 ;\
	timer_actionlist[type].interval= val;

#define SAVE_TIMER_ACTION(type,name,flag)\
	timer_actionlist[type].enable &=(~(0x02));\
	rebuildAll&=~(1<<type);\
	timer_actionlist[type].lastActionSeconds = NOW_SECONDS;\
	gSettings->setValue("last"##name, timer_actionlist[type].lastActionSeconds);\
	if(flag){\
		timer_actionlist[type].faileds=0;\
	}else\
		timer_actionlist[type].faileds++;



/**************time*******************/

#define POST_ITEM_TIMEOUT 10
#define TEST_SERVER_TIMEOUT 10


#ifdef CONFIG_HTTP_TIMEOUT
#define DEFAULT_HTTP_TIMEOUT 30 //30 seconds
#endif
#define TEST_DB_MAXINUM_TIMEOUT 3
#ifdef TOUCH_ANY_DEBUG
#define CATALOG_BUILDER_INTERVAL (12)
#define CATALOG_BUILDER_INTERVAL_UNIT MINUTES
#else
#define CATALOG_BUILDER_INTERVAL (12)
#define CATALOG_BUILDER_INTERVAL_UNIT HOURS
#endif


#ifdef  CONFIG_AUTO_LEARN_PROCESS
#ifdef TOUCH_ANY_DEBUG
#define AUTO_LEARN_PROCESS_INTERVAL (10)
#define AUTO_LEARN_PROCESS_INTERVAL_UNIT SECONDS
#else
#define AUTO_LEARN_PROCESS_INTERVAL 5
#define AUTO_LEARN_PROCESS_INTERVAL_UNIT MINUTES
#endif
#endif

#ifdef CONFIG_DIGG_XML
#ifdef TOUCH_ANY_DEBUG
#define DIGG_XML_INTERVAL (10)
#define DIGG_XML_INTERVAL_UNIT SECONDS
#else
#define DIGG_XML_INTERVAL 60
#define DIGG_XML_INTERVAL_UNIT MINUTES
#endif
#endif

#ifdef TOUCH_ANY_DEBUG
#define SILENT_SYNC_INTERVAL (10)
#define SILENT_SYNC_INTERVAL_UNIT SECONDS
#else
#define SILENT_SYNC_INTERVAL (5)
#define SILENT_SYNC_INTERVAL_UNIT MINUTES
#endif

#define MONITER_TIME_INTERVAL (10)


enum{
	ACTION_LIST_CATALOGBUILD=0,
	ACTION_LIST_BOOKMARK_SYNC,
	ACTION_LIST_TEST_ACCOUNT,
	ACTION_LIST_IMPORT_BOOKMARK,
	ACTION_LIST_ADD_NETBOOKMARK_DIR,
	ACTION_LIST_MODIFY_NETBOOKMARK_DIR,
	ACTION_LIST_DELETE_NETBOOKMARK_DIR,
	ACTION_LIST_ADD_NETBOOKMARK_ITEM,
	ACTION_LIST_MODIFY_NETBOOKMARK_ITEM,
	ACTION_LIST_DELETE_NETBOOKMARK_ITEM,
	ACTION_LIST_GET_DIGG_XML
};

enum{
	DEBUG_LEVEL_NORMAL=0,
	DEBUG_LEVEL_ACTION,
	DEBUG_LEVEL_CATABUILDER,
	DEBUG_LEVEL_BMSYNC,
	DEBUG_LEVEL_BMMERGE,
	DEBUG_LEVEL_DIGGXML,
	DEBUG_LEVEL_POSTHTTP,
	DEBUG_LEVEL_DOWNLOCAL,
	DEBUG_LEVEL_TESTACCOUNT	
};
#ifdef TOUCH_ANY_DEBUG
#define TOUCHANYDEBUG(level,y) do{\
	      QTextCodec::setCodecForTr(QTextCodec::codecForName("UTF-8"));\
	      QTextCodec::setCodecForCStrings(QTextCodec::codecForName("UTF-8"));\
	     qDebug()<<(level)<<":"<< "["<< QDateTime::currentDateTime().toString("hh:mm:ss")<< "]"<<y;\
          }while(0);
#else
#define TOUCHANYDEBUG(level,y) do{}while(0);
#endif

#define QDEBUG_LINE   TOUCHANYDEBUG(DEBUG_LEVEL_NORMAL,__FUNCTION__<<__LINE__);

enum{
	LOCAL_FULLPATH_BMDAT=0,
	LOCAL_FULLPATH_DB,
	LOCAL_FULLPATH_INI,
	LOCAL_FULLPATH_TEMP,
	LOCAL_FULLPATH_IEFAV,
	LOCAL_FULLPATH_IE,
	LOCAL_FULLPATH_FIREFOX,
	LOCAL_FULLPATH_OPERA,
	LOCAL_FULLPATH_DEFBROWSER,
	LOCAL_FULLPATH_MAX
};

enum{
	SYNC_STATUS_NONE=0,
	SYNC_STATUS_SUCCESSFUL,
	SYNC_STATUS_FAILED,
	SYNC_STATUS_PROCESSING,
	SYNC_STATUS_PROCESSING_1,
	SYNC_STATUS_PROCESSING_2,
	SYNC_STATUS_PROCESSING_MAX
};
#undef CONFIG_SYNC_STATUS_DEBUG
/*
enum {
	SYNC_STATUS_FAIL=0,
	SYNC_STATUS_PROCESSING,
	SYNC_STATUS_SUCCESS
};
*/


#define BROWSER_BM_MAX_TOTAL_COUNT   512

#define CONFIG_HTML_FROM_RESOURCE
#define CONFIG_SKIN_FROM_RESOURCE
#endif

