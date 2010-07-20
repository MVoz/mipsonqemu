#ifndef CONFIG_H_
#define CONFIG_H_
#define CONFIG_H_
#define LAUNCHY_VERSION 220
#define LAUNCHY_VERSION_STRING "2.2.0"


#define HASH_LAUNCHY 0

#define LABEL_FILE 0
#define CONFIG_LOG_ENABLE	1

#define CONFIG_SYSTEM_TRAY      1

#define CONFIG_NEW_UI
#define CONFIG_UI_WEBKIT 
#define CONFIG_RAMEN_CODE
#define CONFIG_ONE_OPTION
#define CONFIG_HTTP_TIMEOUT
#define CONFIG_SYNC_THREAD

#define CONFIG_BOOKMARK_TODB

#ifdef CONFIG_HTTP_TIMEOUT
#define DEFAULT_HTTP_TIMEOUT 30 //30 seconds
#endif

#define CONFIG_AUTH_ENCRYPTION



#define CONFIG_SYNC_TIMECHECK

#define APP_NAME "MyLaunchy"

#define HTTP_SERVER_HOST "192.168.115.2"

#define HTTP_SERVER_URL "http://"HTTP_SERVER_HOST"/"

//#define BM_SERVER_ADDRESS "www.tanzhi.com"
#define BM_SERVER_ADDRESS HTTP_SERVER_HOST

#ifdef CONFIG_AUTH_ENCRYPTION
#ifdef CONFIG_SYNC_TIMECHECK
#define BM_SERVER_GET_BMXML_URL HTTP_SERVER_URL"do.php?ac=bmxml&source=client&auth=%1&authkey=%2&tm=%3"
#else
#define BM_SERVER_GET_BMXML_URL HTTP_SERVER_URL"do.php?ac=bmxml&source=client&auth=%1&authkey=%2"
#endif
#define BM_SERVER_TESTACCOUNT_URL HTTP_SERVER_URL"do.php?ac=testaccount&source=client&auth=%1&authkey=%2"
#define BM_SERVER_ADD_URL "/cp.php?ac=bmdir&op=add&bmdirid=%1&browserid=%2&source=client&auth=%3&authkey=%4"
#define BM_SERVER_ADD_DIR BM_SERVER_ADD_URL
#define BM_SERVER_DELETE_URL "/cp.php?ac=bookmark&op=delete&bmid=%1&browserid=%2&source=client&auth=%3&authkey=%4"
#define BM_SERVER_DELETE_DIR  "/cp.php?ac=bmdir&op=delete&bmdirid=%1&browserid=%2&source=client&auth=%3&authkey=%4"

#else
//#define BM_SERVER_GET_BMLIST_URL "http://192.168.1.115/bookmark.php"
#define BM_SERVER_GET_BMXML_URL HTTP_SERVER_URL"do.php?ac=bmxml&source=client&username=%1&password=%2"


#define BM_SERVER_ADD_URL "/cp.php?ac=bmdir&op=add&bmdirid=%1&browserid=%2&source=client&username=%3&password=%4"
#define BM_SERVER_ADD_DIR BM_SERVER_ADD_URL

#define BM_SERVER_DELETE_URL "/cp.php?ac=bookmark&op=delete&bmid=%1&browserid=%2&source=client&username=%3&password=%4"

#define BM_SERVER_DELETE_DIR  "/cp.php?ac=bmdir&op=delete&bmdirid=%1&browserid=%2&source=client&username=%3&password=%4"

#endif

#define BM_TEST_ACCOUNT_URL "/do.php?testAccount.php&"


#define BM_XML_FROM_FIREFOX  "firefox.xml"

#define SUCCESSSTRING "do_success"

#define DEFAULT_LANGUAGE 0 //chinese

#define DO_NOTHING   "do_nothing"


#undef CATALOG_COMPRESS_ENABLE 

#define PARENT_ID_START 8000

#define IS_NULL(x) (((x)==NULL)||((x)==(void*)0xcdcdcdcd)) 

#define TIME_FORMAT "yyyy-MM-dd hh:mm:ss"

#define TIME_INIT_STR "1970-01-01 00:00:00"

#define LOCAL_BM_SETTING_FILE_NAME "localbm.dat"
#define LOCAL_BM_TMP_FOR_BUILD "bmtmp.dat"
#define IE_BM_XML_FILE_NAME "iefav.xml"
#define LOCAL_BM_SETTING_INTERVAL "@@$$=$$@@"
#define TOCHAR(str) ((str).toLatin1().data())



#define LOG_RUN_LINE qDebug("Call function %s()  %d in the file %s",__FUNCTION__,__LINE__,__FILE__);
#define QDEBUG_LINE   qDebug("%s %d\n",__FUNCTION__,__LINE__);
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
#define DB_DATABASE_NAME "launchy.dbs"
#define DB_TABLE_NAME "launch_db"
#define LAUNCH_BM_TABLE "launch_bm"

#define FIREFOX_SQLITE_UNIQUE 1

#define TEST_DB_MAXINUM_TIMEOUT 3

/*updatestatus flag*/
#define UPDATESTATUS_FLAG_APPLY 0
#define UPDATESTATUS_FLAG_RETRY 1

#define HTTP_TEST_ACCOUNT_SUCCESS_STRING  "http_test_account_success"
#define  HTTP_TEST_ACCOUNT_FAIL_STRING  "http_test_account_fail"
#define HTTP_TIMEOUT_STRING  "http_timeout"
#define BOOKMARK_SYNC_START_STRING  "bookmark_sync_start"
#define UPDATE_NET_ERROR_STRING  "update_net_error"
#define SYNC_SUCCESSFUL_STRING "sync_successful"
#define HTTP_GET_INI_SUCCESSFUL_STRING "http_get_ini_successful"
#define HTTP_GET_INI_NOT_EXISTED_STRING "http_get_ini_not_existed"
#define HTTP_GET_INI_FAILED_STRING "http_get_ini_failed"
#define  HTTP_GET_FILE_SUCCESSFUL_STRING "http_get_file_successful"
#define  HTTP_GET_FILE_FAILED_STRING "http_get_file_failed"
#define  HTTP_GET_FILE_NOT_EXISTED_STRING "http_get_file_not_existed"
#define HTTP_NEED_RETRY_STRING "http_need_retry"
#define UPDATE_FAILED_STRING "update_failed"
#define UPDATE_SUCCESSFUL_STRING "update_successful"
#define UPDATE_NO_NEED_STRING "update_no_need"
#define LOGIN_FALIL_STRING   "login_failure_please_re_login"
#define UPDATE_SERVER_REFUSE_STRING "server_refuse"






#define LANGUAGE_APPLY "apply"
#define LANGUAGE_RETRY "retry"
#define LANGUAGE_CANCEL "cancel"
#define LANGUAGE_REJECT "reject"

#define SYN_MODE_SILENCE  0
#define SYN_MODE_NOSILENCE  1



#define COME_FROM_DEFINE 1
#define COME_FROM_PREDEFINE 2
#define COME_FROM_RUNNER 3

#define COME_FROM_PROGRAM 4

#define COME_FROM_IE 5
#define COME_FROM_FIREFOX	 (COME_FROM_IE+1)
#define COME_FROM_OPERA	 (COME_FROM_IE+2)
#define COME_FROM_MAX	(COME_FROM_IE+3)

#define COME_FROM_BROWSER_START COME_FROM_IE
#define COME_FROM_BROWSER_END (COME_FROM_MAX-1)


#define IS_FROM_BROWSER(x) (((x)>=COME_FROM_IE)&&((x)<COME_FROM_MAX))

#define BROWSE_TYPE_IE 		(COME_FROM_IE-COME_FROM_IE)
#define BROWSE_TYPE_FIREFOX 	(COME_FROM_FIREFOX-COME_FROM_IE)
#define BROWSE_TYPE_OPERA		(COME_FROM_OPERA-COME_FROM_IE)
#define BROWSE_TYPE_MAX 		(COME_FROM_MAX-COME_FROM_IE)




#define BOOKMARK_CATAGORY_FLAG 1
#define BOOKMARK_ITEM_FLAG 2

#define FIREFOX_VERSION_2 2
#define FIREFOX_VERSION_3 3

#define PINYIN_DB_FILENAME "pinyin.db"
#define PINYIN_DB_TABLENAME "pytable"

#define CONFIG_PINYIN_FROM_DB

#define APP_HKEY_PATH "HKEY_LOCAL_MACHINE\\Software\\zhiqiu\\launchy"
#define APP_HEKY_UPDATE_ITEM "updaterflag"
#define REGISTER_GET_MODE 0
#define REGISTER_SET_MODE 1

#define APP_SILENT_UPDATE_NAME "newer.exe"
#define APP_PROGRAM_NAME  "tanzhi.exe"
#define APP_SETUP_NAME "setup.exe"
#define APP_FILEMD5_NAME "fmd5.exe"

#define APP_DATA_PATH "data"
#define APP_DEFINE_DB_NAME "defines.db"

#define UPDATE_SERVER_HOST HTTP_SERVER_HOST



#define TEST_NET_URL HTTP_SERVER_URL"testnet.php"

#define UPDATE_DIRECTORY "temp"
#define UPDATE_DIRECTORY_SUFFIX UPDATE_DIRECTORY"/"

#define UPDATE_PORTABLE_DIRECTORY    UPDATE_DIRECTORY"/portable/"
#define UPDATE_SETUP_DIRECTORY    UPDATE_DIRECTORY"/setup/"

#define UPDATE_FILE_NAME "update.ini"
#define UPDATE_SERVER_URL UPDATE_FILE_NAME


#define UPDATE_PORTABLE_KEYWORD    "portable"
#define UPDATE_SETUP_KEYWORD    "setup"

#define FAVICO_DIRECTORY "ico"


#define SECONDS 1000
#define MINUTES  (60*SECONDS)
#define HOURS (60*MINUTES)
#define DAYS (24*HOURS)

#define SET_NET_PROXY(x) \
	 if( tz::runParameter(GET_MODE,RUN_PARAMETER_NETPROXY_ENABLE, 0)){\
				 tz::runParameter(GET_MODE,RUN_PARAMETER_NETPROXY_USING, 1);\
				 QNetworkProxy* netProxy = NULL;\
				 tz::netProxy(GET_MODE,NULL,netProxy);\
				 (x)->setProxy(*netProxy);	\
	  }

#define IS_URL(x)\
		(((x).trimmed().startsWith("http://",Qt::CaseInsensitive))||((x).trimmed().startsWith("https://",Qt::CaseInsensitive)))

#ifdef QT_NO_DEBUG
#define CPU_USAGE_THRESHOLD 20
#else
#define CPU_USAGE_THRESHOLD 100
#endif

#endif

