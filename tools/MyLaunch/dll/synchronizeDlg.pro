#! [0]
TEMPLATE        = lib
CONFIG         += dll qt_warn debug_and_release
INCLUDEPATH    += .
INCLUDEPATH    += ../include/
INCLUDEPATH    += c:/boost/
HEADERS         = ../include/synchronizeDlg.h
SOURCES         = synchronizeDlg.cpp 
#TARGET          = $$qtLibraryTarget(mergethread)

QT += network
QT += xml
QT += webkit
QT += sql
DEFINES += WIN32
DEFINES += SYNC_DLG_DLL

CONFIG -= embed_manifest_dll

if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
	DESTDIR =     ../debug/
	LIBS +=   ../debug/bmapi.lib
	LIBS +=   ../debug/bmxml.lib
   }
   CONFIG(release, debug|release) {
#    CONFIG +=     embed_manifest_dll
	DESTDIR = ../release/
	LIBS +=   ../release/bmapi.lib
	LIBS +=   ../release/bmxml.lib
   }
 }