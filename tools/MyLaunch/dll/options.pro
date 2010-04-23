#! [0]
TEMPLATE        = lib
CONFIG         += dll qt_warn debug_and_release
INCLUDEPATH    += .
INCLUDEPATH    += ../include/
INCLUDEPATH    += c:/boost/
HEADERS         = options.h
SOURCES         = options.cpp 
#TARGET          = $$qtLibraryTarget(mergethread)
#! [0]

QT += network
QT += xml
QT += webkit
QT += sql
DEFINES += WIN32
DEFINES += OPTIONS_DLL
CONFIG -= embed_manifest_dll
# install

#INSTALLS += target sources

if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
    DESTDIR =     ../debug/
   	LIBS +=   ../debug/log.lib
	LIBS +=   ../debug/bmapi.lib
	LIBS +=   ../debug/xmlreader.lib
	LIBS +=   ../debug/posthttp.lib
	LIBS +=   ../debug/bookmark_sync.lib
	LIBS +=   ../debug/updaterThread.lib
	LIBS +=   ../debug/synchronizeDlg.lib
	LIBS +=   ../debug/catalog.lib
	
   }
   CONFIG(release, debug|release) {
 #   CONFIG +=     embed_manifest_dll
    DESTDIR = ../release/
    	LIBS +=   ../release/log.lib
	LIBS +=   ../release/bmapi.lib
	LIBS +=   ../release/xmlreader.lib
	LIBS +=   ../release/posthttp.lib
	LIBS +=   ../release/bookmark_sync.lib
	LIBS +=   ../release/synchronizeDlg.lib
	LIBS +=   ../release/catalog.lib
	LIBS +=   ../release/updaterThread.lib
   }
 }