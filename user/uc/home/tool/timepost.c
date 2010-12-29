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
	FILE *fp = (FILE *)user_p;
	size_t return_size = fwrite(buffer, size, nmemb, fp);
	return return_size;
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
	CURL *easy_handle = curl_easy_init();
	if (NULL == easy_handle)
	{
		printf("get a easy handle failed.\n");
        curl_global_cleanup();

		return -1;
	}

	FILE *fp = fopen("data.html", "ab+");	//
	// ����easy handle����
	curl_easy_setopt(easy_handle, CURLOPT_URL,argv[1]);
	curl_easy_setopt(easy_handle, CURLOPT_WRITEFUNCTION, &process_data);
	curl_easy_setopt(easy_handle, CURLOPT_WRITEDATA, fp);

	// ִ����������
	curl_easy_perform(easy_handle);	

	// �ͷ���Դ

	fclose(fp);
	curl_easy_cleanup(easy_handle);
	curl_global_cleanup();

	return 0;
}
