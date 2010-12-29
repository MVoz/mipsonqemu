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
 *	@brief libcurl���յ�����ʱ�Ļص�����
 *
 *	�����յ������ݱ��浽�����ļ��У�ͬʱ��ʾ�ڿ���̨�ϡ�
 *
 *	@param [in] buffer ���յ����������ڻ�����
 *	@param [in] size ���ݳ���
 *	@param [in] nmemb ����Ƭ����
 *	@param [in/out] �û��Զ���ָ��
 *	@return ��ȡ�����ݳ���
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
	// ����easy handle����
	
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

	// ִ����������
	curl_easy_perform(easy_handle);	

	// �ͷ���Դ
	//�����ʱ
	srand((int)time(0));
	int n = MAX_TIME_INTERVAL;
	t=1+(int)(((float)(n))*rand()/(RAND_MAX+1.0));
//	alarm(t*MINUTE);
	alarm(t);
}
int main(int argc, char **argv)
{

	// ��ʼ��libcurl
	CURLcode return_code;
	return_code = curl_global_init(CURL_GLOBAL_ALL );
	if (CURLE_OK != return_code)
	{
		printf("init libcurl failed.\n");
		return -1;
	}

	// ��ȡeasy handle
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
