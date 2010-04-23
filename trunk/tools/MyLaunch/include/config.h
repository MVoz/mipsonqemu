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


#define CONFIG_SYNDLG_SHAREPTR 1

#define CONFIG_SYNC_TIMECHECK

#define APP_NAME "MyLaunchy"

#define BM_SERVER_ADDRESS "192.168.1.115"
#ifdef CONFIG_AUTH_ENCRYPTION
#ifdef CONFIG_SYNC_TIMECHECK
#define BM_SERVER_GET_BMXML_URL "http://192.168.1.115/uc/home/do.php?ac=bmxml&source=client&auth=%1&authkey=%2&tm=%3"
#else
#define BM_SERVER_GET_BMXML_URL "http://192.168.1.115/uc/home/do.php?ac=bmxml&source=client&auth=%1&authkey=%2"
#endif
#define BM_SERVER_ADD_URL "/uc/home/cp.php?ac=bmdir&op=add&bmdirid=%1&browserid=%2&source=client&auth=%3&authkey=%4"
#define BM_SERVER_ADD_DIR BM_SERVER_ADD_URL
#define BM_SERVER_DELETE_URL "/uc/home/cp.php?ac=bookmark&op=delete&bmid=%1&browserid=%2&source=client&auth=%3&authkey=%4"
#define BM_SERVER_DELETE_DIR  "/uc/home/cp.php?ac=bmdir&op=delete&bmdirid=%1&browserid=%2&source=client&auth=%3&authkey=%4"

#else
//#define BM_SERVER_GET_BMLIST_URL "http://192.168.1.115/bookmark.php"
#define BM_SERVER_GET_BMXML_URL "http://192.168.1.115/uc/home/do.php?ac=bmxml&source=client&username=%1&password=%2"


#define BM_SERVER_ADD_URL "/uc/home/cp.php?ac=bmdir&op=add&bmdirid=%1&browserid=%2&source=client&username=%3&password=%4"
#define BM_SERVER_ADD_DIR BM_SERVER_ADD_URL

#define BM_SERVER_DELETE_URL "/uc/home/cp.php?ac=bookmark&op=delete&bmid=%1&browserid=%2&source=client&username=%3&password=%4"

#define BM_SERVER_DELETE_DIR  "/uc/home/cp.php?ac=bmdir&op=delete&bmdirid=%1&browserid=%2&source=client&username=%3&password=%4"

#endif

#define BM_TEST_ACCOUNT_URL "/testAccount.php"
#define BM_XML_FROM_SERVER	"bm_from_server.xml"
#define BM_XML_FROM_FIREFOX  "firefox.xml"

#define SUCCESSSTRING "do_success"

#define DO_NOTHING   "do_nothing"

#undef CATALOG_COMPRESS_ENABLE 

#define PARENT_ID_START 8000

#define IS_NULL(x) (((x)==NULL)||((x)==(void*)0xcdcdcdcd)) 

#define TIME_FORMAT "yyyy-MM-dd hh:mm:ss"

#define TIME_INIT_STR "1970-01-01 00:00:00"

#define LOCAL_BM_SETTING_FILE_NAME "localbm.dat"
#define IE_BM_XML_FILE_NAME "iefav.xml"
#define LOCAL_BM_SETTING_INTERVAL "@@$$=$$@@"
#define TOCHAR(str) ((str).toLatin1().data())



#define LOG_RUN_LINE logToFile("Call function %s()  %d in the file %s",__FUNCTION__,__LINE__,__FILE__);
#define QDEBUG_LINE   QDEBUG("%s %d\n",__FUNCTION__,__LINE__);
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


#endif

