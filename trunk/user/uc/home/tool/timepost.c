#include <curl/curl.h>
#include <signal.h>
#include <time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>

CURL *easy_handle=NULL;
FILE *fp = NULL;
unsigned int maxinterval=100;
unsigned int mininterval=30;
#define MAX_TIME_INTERVAL 100 

#define MINUTES 60
#define POST_DIGG_MAX_INTERVAL (10*MINUTES)

unsigned int last_post_time = 0;
char *httpserver = "http://192.168.115.2/";
char *robotid = "f69c1725e2a57ec91d1c89d452396c1f";
char *action[]={
	{"cp.php?ac=digg&op=up&inajax=1&diggid=#"},//3
	{"cp.php?ac=site&op=up&inajax=1&siteid=#"},//2
	{"cp.php?ac=site&op=view&inajax=1&siteid=#"},//4
	{"cp.php?ac=digg&op=view&inajax=1&diggid=#"},//5
	{"cp.php?ac=diggpool&op=publish&inajax=1"},//3
	{"cp.php?ac=site&op=store&inajax=1&siteid=#"}//4
};

struct timer_action
{
	char **ac;
	int time[2];
};
struct timer_action timer_actions[]={
	{&action[0],{8,24}},
	{&action[0],{8,24}},
	{&action[0],{8,24}},

	{&action[1],{8,24}},
	{&action[1],{8,24}},

	{&action[2],{0,24}},
	{&action[2],{0,24}},
	{&action[2],{0,24}},
	{&action[2],{0,24}},

	{&action[3],{0,24}},
	{&action[3],{0,24}},	
	{&action[3],{0,24}},	
	{&action[3],{0,24}},
	{&action[3],{0,24}},
		
	{&action[4],{6,23}},
	{&action[4],{6,23}},
	{&action[4],{6,23}},

	{&action[5],{0,24}},
	{&action[5],{0,24}},
	{&action[5],{0,24}}	

};
/**
 *	@brief libcurl接收到数据时的回调函数
 *
 *	将接收到的数据保存到本地文件中，同时显示在控制台上。
 *
 *	@param [in] buffer 接收到的数据所在缓冲区
 *	@param [in] size 数据长度
 *	@param [in] nmemb 数据片数量
 *	@param [in/out] 用户自定义指针
 *	@return 获取的数据长度
 */

size_t process_data(void *buffer, size_t size, size_t nmemb, void *user_p)
{
//	FILE *fp = (FILE *)user_p;
//	size_t return_size = fwrite(buffer, size, nmemb, fp);
	printf("buffer=%s\n\n",buffer);
	return 0;
}
int sighandler_timer(int signo)
{
	// 设置easy handle属性
	time_t now;
	struct tm  *nowtime;
	now = time(NULL);
	nowtime = localtime(&now);
//	printf("Local time is: %s", asctime(nowtime));
	
	int action_r = sizeof(timer_actions)/sizeof(struct timer_action);
	
//	printf("action_r =%d\n",action_r);
	srand((int)time(0));
	int t=(int)(((float)(action_r))*rand()/(RAND_MAX+1.0));
	
	if(timer_actions[t].ac == &action[4] ){
		//保证最小间隔为10分钟发一次digg
		if(!last_post_time)
			last_post_time = now;
		if((now-last_post_time)<POST_DIGG_MAX_INTERVAL)
			goto NEXT;
		last_post_time = now;
	}

	if((nowtime->tm_hour>=timer_actions[t].time[0])&&(nowtime->tm_hour<=timer_actions[t].time[1]))
	{
		char url[1024]={0};
		strcpy(url,httpserver);
		strcat(url,*(timer_actions[t].ac));
		
		char *p = strchr(url,'#');
		if(p){
			sprintf(p,"%d",1);
		}
		sprintf(url,"%s&robot=%s",url,robotid);
		printf("url=%s\n",url);
		curl_easy_setopt(easy_handle, CURLOPT_URL,url);
		curl_easy_setopt(easy_handle, CURLOPT_WRITEFUNCTION, &process_data);
		curl_easy_setopt(easy_handle, CURLOPT_WRITEDATA, fp);

		// 执行数据请求
		curl_easy_perform(easy_handle);	
	}
NEXT:
	// 释放资源
	//随机定时
	srand((int)time(0));
	t=mininterval+(int)(((float)(maxinterval))*rand()/(RAND_MAX+1.0));
	alarm(t);
}
pid_t pid, sid;

void init_daemon(void)
{
/* Fork off the parent process */
        pid = fork();
        if (pid < 0) {
            exit(EXIT_FAILURE);
        }
        /* If we got a good PID, then
           we can exit the parent process. */
        if (pid > 0) {
            exit(EXIT_SUCCESS);
        }
 
        /* Change the file mode mask */
        umask(0);
 
        /* Create a new SID for the child process */
        sid = setsid();
        if (sid < 0) {
            /* Log the failure */
            exit(EXIT_FAILURE);
        }
 
        /* Change the current working directory */
        if ((chdir("/")) < 0) {
            /* Log the failure */
            exit(EXIT_FAILURE);
        }
 
        /* Close out the standard file descriptors */
        close(STDIN_FILENO);
        close(STDOUT_FILENO);
        close(STDERR_FILENO);
}



void PrintUsage(int argc, char *argv[]) {
    if (argc >=1) {
        printf("Usage: %s -h -n\n", argv[0]);
        printf("  Options:n");
        printf("      -d\tAs a daemon\n");
		printf("      -m\tSet maxinum interval\n");
		printf("      -l\tSet minium interval\n");
        printf("      -htShow this help screen\n");
        printf("n");
    }
}
int main(int argc, char **argv)
{
	int c;
	int daemonize = 0;
    while( (c = getopt(argc, argv, "dhm:l:|help")) != -1) {
        switch(c){
            case 'h':
                PrintUsage(argc, argv);
                exit(0);
                break;
            case 'd':
                daemonize = 1;
                break;
			case 'm':
                maxinterval = (unsigned int)strtol(optarg, NULL, 10);
                break;
			case 'l':
                mininterval = (unsigned int)strtol(optarg, NULL, 10);
                break;
            default:
                PrintUsage(argc, argv);
                exit(0);
                break;
        }
    }

	tzset();
	if(daemonize)
		init_daemon();
	// 初始化libcurl
	CURLcode return_code;
	return_code = curl_global_init(CURL_GLOBAL_ALL );
	if (CURLE_OK != return_code)
	{
		printf("init libcurl failed.\n");
		return -1;
	}

	// 获取easy handle
	easy_handle = curl_easy_init();
	if (NULL == easy_handle)
	{
		printf("get a easy handle failed.\n");
        curl_global_cleanup();
		return -1;
	}

	fp = fopen("data.html", "ab+");	//

	signal(SIGALRM, sighandler_timer);
	alarm(1);//1 seconds
	for(;;) 
		pause();

	fclose(fp);
	curl_easy_cleanup(easy_handle);
	curl_global_cleanup();

	return 0;
}
