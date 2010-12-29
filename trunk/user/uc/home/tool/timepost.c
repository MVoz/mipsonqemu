#include <stdio.h>
#include <curl/curl.h>
#include <stdlib.h>

/*
int main(int argc, char *argv[])
{
	printf("hello world");

    CURL *curl;
	CURLcode res;
    if(argc!=2)
    {
		printf("Usage : file <url>;\n");
        exit(1);
    }

    curl = curl_easy_init(); 
    if(curl!=NULL)
    {
       curl_easy_setopt(curl, CURLOPT_URL, argv[1]);     
       res = curl_easy_perform(curl);
	   curl_easy_cleanup(curl);
    }

    return 0;
}
*/
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
	FILE *fp = (FILE *)user_p;
	size_t return_size = fwrite(buffer, size, nmemb, fp);
	return return_size;
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
	CURL *easy_handle = curl_easy_init();
	if (NULL == easy_handle)
	{
		printf("get a easy handle failed.\n");
        curl_global_cleanup();

		return -1;
	}

	FILE *fp = fopen("data.html", "ab+");	//
	// 设置easy handle属性
	curl_easy_setopt(easy_handle, CURLOPT_URL,argv[1]);
	curl_easy_setopt(easy_handle, CURLOPT_WRITEFUNCTION, &process_data);
	curl_easy_setopt(easy_handle, CURLOPT_WRITEDATA, fp);

	// 执行数据请求
	curl_easy_perform(easy_handle);	

	// 释放资源

	fclose(fp);
	curl_easy_cleanup(easy_handle);
	curl_global_cleanup();

	return 0;
}
