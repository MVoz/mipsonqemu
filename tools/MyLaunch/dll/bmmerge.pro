TEMPLATE        = lib
CONFIG         += dll qt_warn debug_and_release
INCLUDEPATH    += .
INCLUDEPATH    += ./include/
INCLUDEPATH    += c:/boost/
HEADERS         = ./include/bmmerge.h
SOURCES         = bmmerge.cpp 
#TARGET          = $$qtLibraryTarget(mergethread)

MOC_DIR += tmp
OBJECTS_DIR += tmp

QT += network
QT += xml
QT += sql
DEFINES += WIN32
DEFINES += MERGE_THREAD_DLL
CONFIG -= embed_manifest_dll

if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
	DESTDIR =     ./debug/
	LIBS +=   ./debug/bmapi.lib
	LIBS +=   ./debug/bmxml.lib
	LIBS +=   ./debug/bmpost.lib
	LIBS +=   ./debug/baseitem.lib
	LIBS +=   ./debug/bmnet.lib
   }
   CONFIG(release, debug|release) {
	DESTDIR = ./release/
	LIBS +=   ./release/bmapi.lib
	LIBS +=   ./release/bmxml.lib
	LIBS +=   ./release/bmpost.lib
	LIBS +=   ./release/baseitem.lib
	LIBS +=   ./release/bmnet.lib
   }
 }