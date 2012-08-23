#! [0]
TEMPLATE        = lib
CONFIG         += dll qt_warn debug_and_release
INCLUDEPATH    += .
INCLUDEPATH    += ./include/
INCLUDEPATH    += c:/boost/
HEADERS         =./include/bmsync.h
SOURCES         = bmsync.cpp
#TARGET          = $$qtLibraryTarget(mergethread)

MOC_DIR += tmp
OBJECTS_DIR += tmp

QT += network
QT += xml
QT += sql
DEFINES += WIN32
DEFINES += BOOKMARK_SYNC_DLL
CONFIG -= embed_manifest_dll

if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
	DESTDIR = ./debug/
	LIBS +=   ./debug/bmapi.lib
	LIBS +=   ./debug/bmxml.lib
	LIBS +=   ./debug/bmpost.lib
	LIBS +=   ./debug/bmmerge.lib
	LIBS +=   ./debug/bmnet.lib
   }
   CONFIG(release, debug|release) {
#    CONFIG +=     embed_manifest_dll
	DESTDIR = ./release/
	LIBS +=   ./release/bmapi.lib
	LIBS +=   ./release/bmxml.lib
	LIBS +=   ./release/bmpost.lib
	LIBS +=   ./release/bmmerge.lib
	LIBS +=   ./release/bmnet.lib
   }
 }
