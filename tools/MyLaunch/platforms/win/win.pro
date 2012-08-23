TEMPLATE	= lib
TARGET		= platform
QT += sql
QT += network
CONFIG		+= plugin qt_warn debug_and_release
VPATH 		+= ./src/
INCLUDEPATH += ./src/
INCLUDEPATH += c:/boost/
INCLUDEPATH += ./platform/win/
INCLUDEPATH += ./include/

MOC_DIR += tmp
OBJECTS_DIR += tmp

VPATH		+= src/
SOURCES		= platform_win.cpp ./src/platform_base_hotkey.cpp platform_win_hotkey.cpp platform_win_util.cpp
HEADERS		= ./src/platform_base.h platform_win.h ./src/platform_base_hotkey.h ./src/platform_base_hottrigger.h platform_win_util.h
LIBS 		+= shell32.lib user32.lib gdi32.lib comctl32.lib
CONFIG		-= embed_manifest_dll


if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
    DESTDIR =  ./debug/
    LIBS +=./debug/bmapi.lib
   }
   CONFIG(release, debug|release) {
    DESTDIR = ./release/
    LIBS +=./release/bmapi.lib
   }
 }