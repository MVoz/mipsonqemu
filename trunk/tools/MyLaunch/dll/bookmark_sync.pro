#! [0]
TEMPLATE        = lib
CONFIG         += dll qt_warn debug_and_release
INCLUDEPATH    += .
INCLUDEPATH    += ../include/
INCLUDEPATH    += c:/boost/
HEADERS         = bookmark_sync.h
SOURCES         = bookmark_sync.cpp
#TARGET          = $$qtLibraryTarget(mergethread)
#! [0]
QT += network
QT += xml
QT += webkit
QT += sql
DEFINES += WIN32
DEFINES += BOOKMARK_SYNC_DLL
CONFIG -= embed_manifest_dll
# install
target.path = .
sources.files = bookmark_sync.pro
sources.path = .
#INSTALLS += target sources
if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
	DESTDIR = ../debug/
	LIBS +=   ../debug/bmapi.lib
	LIBS +=   ../debug/xmlreader.lib
	LIBS +=   ../debug/posthttp.lib
	LIBS +=   ../debug/mergethread.lib
   }
   CONFIG(release, debug|release) {
#    CONFIG +=     embed_manifest_dll
	DESTDIR = ../release/
	LIBS +=   ../release/bmapi.lib
	LIBS +=   ../release/xmlreader.lib
	LIBS +=   ../release/posthttp.lib
	LIBS +=   ../release/mergethread.lib
   }
 }
