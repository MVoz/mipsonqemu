#ifndef LOG_H
#define LOG_H
#if defined(LOG_DLL)
#ifndef CLASSEXPORT
#define CLASSEXPORT __declspec(dllexport)
#endif
#ifndef FUNCEXPORT
#define FUNCEXPORT extern "C" __declspec(dllexport)
#endif
#else
#ifndef CLASSEXPORT
#define CLASSEXPORT __declspec(dllimport)
#endif
#ifndef FUNCEXPORT
#define FUNCEXPORT extern "C" __declspec(dllimport)
#endif
#endif
#pragma warning(disable:4996)
FUNCEXPORT void QDEBUG(const char *cformat, ...);
FUNCEXPORT void logToFile(const char* cformat,...);
FUNCEXPORT void logMsgbox(const char* cformat,...);
#endif