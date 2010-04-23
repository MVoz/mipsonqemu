#ifndef PINYIN_H
#define PINYIN_H
#include <config.h>
#include <QString>
#include <QStringList>
#include <QDir>
#include <windows.h>
#if defined(PINYIN_DLL)
#define PINYIN_DLL_CLASSEXPORT __declspec(dllexport)
#define PINYIN_DLL_FUNCEXPORT extern "C" __declspec(dllexport)
#else
#define PINYIN_DLL_CLASSEXPORT __declspec(dllexport)
#define PINYIN_DLL_FUNCEXPORT  extern "C" __declspec(dllimport)
#endif
PINYIN_DLL_FUNCEXPORT QStringList* pinyin_list[];
PINYIN_DLL_CLASSEXPORT int  get_pinyin (const char* hanzhi/*utf-8*/);
PINYIN_DLL_CLASSEXPORT void init_pinyin_utf8_list();
#endif