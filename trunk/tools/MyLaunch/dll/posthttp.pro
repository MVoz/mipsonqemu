#! [0]
TEMPLATE        = lib
CONFIG         += dll qt_warn debug_and_release
INCLUDEPATH    += .
INCLUDEPATH    += ../include/
INCLUDEPATH    += c:/boost/
HEADERS         = ../include/posthttp.h
SOURCES         = posthttp.cpp 
#TARGET          = $$qtLibraryTarget(mergethread)

QT += network
QT += xml
QT += sql
DEFINES += WIN32
DEFINES += POST_HTTP_DLL
CONFIG -= embed_manifest_dll

if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
	DESTDIR =     ../debug/
	LIBS +=   ../debug/bmapi.lib
	LIBS +=   ../debug/xmlreader.lib
	LIBS +=   ../debug/testserver.lib
   }
   CONFIG(release, debug|release) {
	 DESTDIR = ../release/
	LIBS +=   ../release/bmapi.lib
	LIBS +=   ../release/xmlreader.lib
	LIBS +=   ../release/testserver.lib
   }
 }