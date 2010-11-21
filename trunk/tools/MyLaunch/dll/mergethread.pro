TEMPLATE        = lib
CONFIG         += dll qt_warn debug_and_release
INCLUDEPATH    += .
INCLUDEPATH    += ../include/
INCLUDEPATH    += c:/boost/
HEADERS         = ../include/mergethread.h
SOURCES         = mergethread.cpp 
#TARGET          = $$qtLibraryTarget(mergethread)

QT += network
QT += xml
QT += sql
DEFINES += WIN32
DEFINES += MERGE_THREAD_DLL
CONFIG -= embed_manifest_dll

if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
	DESTDIR =     ../debug/
	LIBS +=   ../debug/bmapi.lib
	LIBS +=   ../debug/xmlreader.lib
	LIBS +=   ../debug/posthttp.lib
	LIBS +=   ../debug/catalog.lib
	LIBS +=   ../debug/bmnet.lib
   }
   CONFIG(release, debug|release) {
	DESTDIR = ../release/
	LIBS +=   ../release/bmapi.lib
	LIBS +=   ../release/xmlreader.lib
	LIBS +=   ../release/posthttp.lib
	LIBS +=   ../release/catalog.lib
	LIBS +=   ../release/bmnet.lib
   }
 }