#ifndef CONFIG_H_
#include "version.h"
#define CONFIG_H_
#define LAUNCHY_VERSION 220
#define LAUNCHY_VERSION_STRING "2.2.0"
#define VERSION_FILE "version.h"
#define SERVER_VERSION_FILE_PHP "index.php"

#define HASH_LAUNCHY 0

#define LABEL_FILE 0
#define CONFIG_LOG_ENABLE	1

#define CONFIG_NEW_UI
#define CONFIG_UI_WEBKIT 
#define CONFIG_RAMEN_CODE
#define CONFIG_HTTP_TIMEOUT
#define CONFIG_SYNC_THREAD

#define CONFIG_BOOKMARK_TODB

#ifdef CONFIG_HTTP_TIMEOUT
#define DEFAULT_HTTP_TIMEOUT 30 //30 seconds
#endif

#define CONFIG_AUTH_ENCRYPTION

#define APP_NAME "touchAny"
#define APP_SLOGAN "everything_is_in_touch"


#define HTTP_SERVER_HOST "192.168.115.2"

#define HTTP_SERVER_URL "http://"HTTP_SERVER_HOST"/"

//#define BM_SERVER_ADDRESS "www.tanzhi.com"
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


#undef LOCALBM_COMPRESS_ENABLE 


#define IS_NULL(x) (((x)==NULL)||((x)==(void*)0xcdcdcdcd)) 

#define TIME_FORMAT "yyyy-MM-dd hh:mm:ss"

#define TIME_INIT_STR "1970-01-01 00:00:00"

#define LOCAL_BM_SETTING_FILE_NAME "localbm.dat"
#define LOCAL_BM_TMP_FOR_BUILD "bmtmp.dat"
#define IE_BM_XML_FILE_NAME "iefav.xml"
#define LOCAL_BM_SETTING_INTERVAL "@@$$=$$@@"
#define TOCHAR(str) ((str).toLatin1().data())



#define LOG_RUN_LINE qDebug("Call function %s()  %d in the file %s",__FUNCTION__,__LINE__,__FILE__);
#define QDEBUG_LINE   qDebug("%s %d",__FUNCTION__,__LINE__);
#define SHAREPTRPRINT(X) (X?X.get():0)

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

#define MAX_SEARCH_RESULT 10
#define DB_DATABASE_NAME APP_NAME".db"
//#define DB_TABLE_NAME "launch_db"
#define DB_TABLE_SUFFIX APP_NAME

#define LAUNCH_BM_TABLE "launch_bm"

#define FIREFOX_SQLITE_UNIQUE 1

#define TEST_DB_MAXINUM_TIMEOUT 3

/*updatestatus flag*/
#define UPDATESTATUS_FLAG_APPLY 0
#define UPDATESTATUS_FLAG_RETRY 1


#define LOGIN_FALIL_STRING   "login_failure_please_re_login"



#define LANGUAGE_APPLY "apply"
#define LANGUAGE_RETRY "retry"
#define LANGUAGE_CANCEL "cancel"
#define LANGUAGE_REJECT "reject"

#define SYN_MODE_SILENCE  0
#define SYN_MODE_NOSILENCE  1



#define COME_FROM_SHORTCUT 1
#define COME_FROM_PREDEFINE 2
#define COME_FROM_COMMAND 3

#define COME_FROM_PROGRAM 4
#define COME_FROM_LEARNPROCESS 5

#define COME_FROM_MYBOOKMARK 6

#define COME_FROM_NETBOOKMARK 7
#define COME_FROM_IE (COME_FROM_NETBOOKMARK+1)
#define COME_FROM_FIREFOX	 (COME_FROM_NETBOOKMARK+2)
#define COME_FROM_OPERA	 (COME_FROM_NETBOOKMARK+3)
#define COME_FROM_MAX	(COME_FROM_NETBOOKMARK+4)



#define COME_FROM_BROWSER_START COME_FROM_NETBOOKMARK
#define COME_FROM_BROWSER_END (COME_FROM_MAX-1)

#define COME_FROM_BROWSER COME_FROM_BROWSER_START

#define IS_FROM_BROWSER(x) (((x)>=COME_FROM_NETBOOKMARK)&&((x)<COME_FROM_MAX))

#define BROWSE_TYPE_NETBOOKMARK		(COME_FROM_NETBOOKMARK-COME_FROM_NETBOOKMARK)
#define BROWSE_TYPE_IE 		(COME_FROM_IE-COME_FROM_NETBOOKMARK)
#define BROWSE_TYPE_FIREFOX 	(COME_FROM_FIREFOX-COME_FROM_NETBOOKMARK)
#define BROWSE_TYPE_OPERA		(COME_FROM_OPERA-COME_FROM_NETBOOKMARK)
#define BROWSE_TYPE_MAX 		(COME_FROM_MAX-COME_FROM_NETBOOKMARK)




#define BOOKMARK_CATAGORY_FLAG 1
#define BOOKMARK_ITEM_FLAG 2

#define FIREFOX_VERSION_2 2
#define FIREFOX_VERSION_3 3

#define PINYIN_DB_FILENAME "pinyin.db"
#define PINYIN_DB_TABLENAME "pytable"

#define CONFIG_SERVER_IP_SETTING
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

#define APP_HKEY_PATH "HKEY_LOCAL_MACHINE\\Software\\zhiqiu\\launchy"
#define APP_HEKY_UPDATE_ITEM "updaterflag"
#define REGISTER_GET_MODE 0
#define REGISTER_SET_MODE 1

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


#define UPDATE_SILENT_MODE 0
#define UPDATE_DLG_MODE 1


#define FAVICO_DIRECTORY "ico"

#define FROMSERVER_XML_PREFIX "from_server_xml_"

#define SECONDS 1000
#define MINUTES  (60*SECONDS)
#define HOURS (60*MINUTES)
#define DAYS (24*HOURS)
#define POST_ITEM_TIMEOUT 10
#define TEST_SERVER_TIMEOUT 10

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


#define NO_PINYIN_FLAG 0
#define HAS_PINYIN_FLAG 1
#define BROKEN_TOKEN_STR "$#@#$"

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
	NETPROXY
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
	BM_SYNC_SUCCESS_NO_ACTION,//merge success but no any action
	BM_SYNC_SUCCESS_WITH_ACTION,//merge successful with action
	BM_SYNC_FAIL,
	BM_SYNC_FAIL_SERVER_NET_ERROR,//can't connect to server	
	BM_SYNC_FAIL_SERVER_REFUSE,//server refuse sevice
	BM_SYNC_FAIL_SERVER_BMXML_FAIL,//get bm.xml file failed
	BM_SYNC_FAIL_BMXML_TIMEOUT,
	BM_SYNC_FAIL_MERGE_ERROR,//failed to merge data to server
	BM_SYNC_FAIL_PROXY_ERROR,//can't connect to proxy
	BM_SYNC_FAIL_PROXY_AUTH_ERROR,//auth failed when connect to proxy		
	BM_SYNC_FAIL_SERVER_TESTACCOUNT_FAIL,
	BM_SYNC_FAIL_SERVER_LOGIN
};


enum TEST_NET_RESULT{
	TEST_NET_REFUSE=0,
	TEST_NET_SUCCESS,
	TEST_NET_ERROR_PROXY,
	TEST_NET_ERROR_PROXY_AUTH,
	TEST_NET_ERROR_SERVER,
	TEST_NET_UNNEED
};


#define SETTING_MERGE_LOCALTOSERVER  0
#define SETTING_MERGE_SERVERTOLOCAL  1

#define SETTING_MERGE_MODE_DOWNLOAD 0
#define SETTING_MERGE_MODE_CHECKFILE 1

#define HTTP_OK 200
#define HTTP_FILE_NOT_FOUND 404

#define CONFIG_OPTION_NEWUI


#define SYNC_STATUS_FAIL 0
#define SYNC_STATUS_PROCESSING  1
#define SYNC_STATUS_SUCCESS  2

#define HOTKEY_PART_0 Qt::ControlModifier
#define HOTKEY_PART_1 Qt::Key_Enter

#define NET_BOOKMARK_GROUPID_START 8000

#define BROWSER_FIREFOX_BIN_NAME "firefox.exe"

#define CONFIG_ACTION_LIST

#define CONFIG_AUTO_LEARN_PROCESS


#define CONFIG_DIGG_XML

//timer
//base unit hour


#ifdef QT_NO_DEBUG
#define CATALOG_BUILDER_INTERVAL (12)
#define CATALOG_BUILDER_INTERVAL_UNIT HOURS
#else
#define CATALOG_BUILDER_INTERVAL (12)
#define CATALOG_BUILDER_INTERVAL_UNIT MINUTES
#endif


#ifdef  CONFIG_AUTO_LEARN_PROCESS
#ifdef QT_NO_DEBUG
#define AUTO_LEARN_PROCESS_INTERVAL 5
#define AUTO_LEARN_PROCESS_INTERVAL_UNIT MINUTES
#else
#define AUTO_LEARN_PROCESS_INTERVAL (10)
#define AUTO_LEARN_PROCESS_INTERVAL_UNIT SECONDS
#endif
#endif

#ifdef CONFIG_DIGG_XML
#ifdef QT_NO_DEBUG
#define DIGG_XML_INTERVAL 60
#define DIGG_XML_INTERVAL_UNIT MINUTES
#else
#define DIGG_XML_INTERVAL (10)
#define DIGG_XML_INTERVAL_UNIT SECONDS
#endif
#endif

#ifdef QT_NO_DEBUG
#define SILENT_SYNC_INTERVAL (5)
#define SILENT_SYNC_INTERVAL_UNIT MINUTES
#else
#define SILENT_SYNC_INTERVAL (10)
#define SILENT_SYNC_INTERVAL_UNIT SECONDS
#endif

#define MONITER_TIME_INTERVAL (10)


#define INIT_TIMER_ACTION_LIST(type,name,start,val)\
	timer_actionlist[type].actionType= type;\
	timer_actionlist[type].enable =  (gSettings->value("ck"##name, true).toBool())?1:0;\
	timer_actionlist[type].startAfterRun =  (short)(start);\
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

#define DIGG_XML_LOCAL_FILE "./data/digg.xml"

enum{
	POST_HTTP_ACTION_DELETE_URL=0,
	POST_HTTP_ACTION_DELETE_DIR,
	POST_HTTP_ACTION_ADD_URL,
	POST_HTTP_ACTION_ADD_DIR,	
	DOWN_LOCAL_ACTION_ADD_ITEM,
	DOWN_LOCAL_ACTION_ADD_DIR,
	DOWN_LOCAL_ACTION_DELETE_ITEM,
	DOWN_LOCAL_ACTION_DELETE_DIR
};

#define POST_DOWN_AFTER_MERGE 

#endif

