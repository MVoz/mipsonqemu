TEMPLATE        = lib
CONFIG         += dll qt_warn debug_and_release
INCLUDEPATH    += .
INCLUDEPATH    += ../include/
INCLUDEPATH    += c:/boost/
HEADERS         = ../include/optionUI.h
SOURCES         = optionUI.cpp 
#TARGET          = $$qtLibraryTarget(mergethread)

QT += network
QT += xml
QT += webkit
QT += sql
DEFINES += WIN32
DEFINES += OPTIONS_DLL
CONFIG -= embed_manifest_dll

if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
	DESTDIR =     ../debug/
	LIBS +=   ../debug/bmapi.lib
	LIBS +=   ../debug/bmxml.lib
	LIBS +=   ../debug/bmpost.lib
	LIBS +=   ../debug/bmsync.lib
	LIBS +=   ../debug/appupdater.lib
	LIBS +=   ../debug/baseitem.lib
	LIBS +=   ../debug/bmnet.lib
	
   }
   CONFIG(release, debug|release) {
	DESTDIR = ../release/
	LIBS +=   ../release/bmapi.lib
	LIBS +=   ../release/bmxml.lib
	LIBS +=   ../release/bmpost.lib
	LIBS +=   ../release/bmsync.lib
	LIBS +=   ../release/baseitem.lib
	LIBS +=   ../release/appupdater.lib
	LIBS +=   ../release/bmnet.lib
   }
 }