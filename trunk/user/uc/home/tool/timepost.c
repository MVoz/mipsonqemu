#include <stdio.h>
#include <curl/curl.h>
#include <stdlib.h>
#include <signal.h>
#include<time.h>

CURL *easy_handle=NULL;
FILE *fp = NULL;
#define MAX_TIME_INTERVAL 5 
#define MINUTE 60
char *httpserver = "http://192.168.115.2/";
char *robotid = "f69c1725e2a57ec91d1c89d452396c1f";
char *action[]={
	{"cp.php?ac=digg&op=updatediggupnum&inajax=1&diggid=#"},
	{"cp.php?ac=site&op=updatesiteupnum&inajax=1&siteid=#"},
	{"cp.php?ac=site&op=updatesiteviewnum&inajax=1&siteid=#"},
	{"cp.php?ac=digg&op=updatediggviewnum&inajax=1&diggid=#"},
	{"cp.php?ac=diggpool&op=publish&inajax=1"}
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
	
	int action_r = sizeof(action)/sizeof(char*);

	srand((int)time(0));
	int t=(int)(((float)(action_r))*rand()/(RAND_MAX+1.0));
	
	char url[1024]={0};
	strcpy(url,httpserver);
	strcat(url,action[t]);
	
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

	// 释放资源
	//随机定时
	srand((int)time(0));
	int n = MAX_TIME_INTERVAL;
	t=1+(int)(((float)(n))*rand()/(RAND_MAX+1.0));
//	alarm(t*MINUTE);
	alarm(t);
}
int main(int argc, char **argv)
{

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
