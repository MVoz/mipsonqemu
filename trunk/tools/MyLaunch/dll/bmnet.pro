######################################################################
# Automatically generated by qmake (1.07a) ??? ?? 30 10:58:24 2007
######################################################################

TEMPLATE	= lib
CONFIG		+=dll  qt_warn debug_and_release
VPATH 		+= ../../src/
INCLUDEPATH += ../../src/
INCLUDEPATH += c:/boost/
INCLUDEPATH += ../../win/
INCLUDEPATH += ../include/
VPATH		+= src/
SOURCES		=bmnet.cpp
HEADERS		=../include/bmnet.h
LIBS 		+= shell32.lib user32.lib gdi32.lib comctl32.lib
CONFIG -= embed_manifest_dll
DEFINES += WIN32
DEFINES += TEST_SERVER_DLL
QT += sql
QT += network
QT += xml

if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
    DESTDIR =     ../debug/
    LIBS +=../debug/bmapi.lib
   }
   CONFIG(release, debug|release) {
    DESTDIR = ../release/
    LIBS +=../release/bmapi.lib
   }
 }