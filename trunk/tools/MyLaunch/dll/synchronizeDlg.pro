#! [0]
TEMPLATE        = lib
CONFIG         += dll qt_warn debug_and_release
INCLUDEPATH    += .
INCLUDEPATH    += ../include/
INCLUDEPATH    += c:/boost/
HEADERS         = synchronizeDlg.h
SOURCES         = synchronizeDlg.cpp 
#TARGET          = $$qtLibraryTarget(mergethread)
#! [0]
DESTDIR = ../debug/
QT += network
QT += xml
QT += webkit
QT += sql
DEFINES += WIN32
DEFINES += SYNC_DLG_DLL

CONFIG -= embed_manifest_dll
# install
target.path = .
sources.files = posthttp.pro
sources.path = .
#INSTALLS += target sources
if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
    DESTDIR =     ../debug/
	LIBS +=   ../debug/bmapi.lib
	LIBS +=   ../debug/xmlreader.lib
   }
   CONFIG(release, debug|release) {
#    CONFIG +=     embed_manifest_dll
    DESTDIR = ../release/
	LIBS +=   ../release/bmapi.lib
	LIBS +=   ../release/xmlreader.lib
   }
 }