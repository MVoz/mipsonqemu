TEMPLATE        = lib
CONFIG         += dll qt_warn debug_and_release
INCLUDEPATH    += .
INCLUDEPATH    += ./include/
INCLUDEPATH    += c:/boost/
HEADERS         = ./include/bmpost.h
SOURCES         = bmpost.cpp 

QT += network
QT += xml
QT += sql

MOC_DIR += tmp
OBJECTS_DIR += tmp

DEFINES += WIN32
DEFINES += POST_HTTP_DLL
CONFIG -= embed_manifest_dll

if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
	DESTDIR =     ./debug/
	LIBS +=   ./debug/bmapi.lib
	LIBS +=   ./debug/bmxml.lib
	LIBS +=   ./debug/bmnet.lib
   }
   CONFIG(release, debug|release) {
	 DESTDIR = ./release/
	LIBS +=   ./release/bmapi.lib
	LIBS +=   ./release/bmxml.lib
	LIBS +=   ./release/bmnet.lib
   }
 }