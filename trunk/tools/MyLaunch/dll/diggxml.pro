#! [0]
TEMPLATE        = lib
CONFIG         += dll qt_warn debug_and_release
INCLUDEPATH    += .
INCLUDEPATH    += ./include/
INCLUDEPATH    += c:/boost/
HEADERS         =./include/diggxml.h
SOURCES         = diggxml.cpp


QT += network
QT += sql
DEFINES += WIN32
DEFINES += DIGG_XML_DLL

MOC_DIR += tmp
OBJECTS_DIR += tmp

CONFIG -= embed_manifest_dll

if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
	DESTDIR = ./debug/
	LIBS +=   ./debug/bmapi.lib
	LIBS +=   ./debug/bmxml.lib
	LIBS +=   ./debug/bmnet.lib
   }
   CONFIG(release, debug|release) {
#    CONFIG +=     embed_manifest_dll
	DESTDIR = ./release/
	LIBS +=   ./release/bmapi.lib
	LIBS +=   ./release/bmxml.lib
	LIBS +=   ./release/bmnet.lib
   }
 }
