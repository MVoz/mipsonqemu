######################################################################
# Automatically generated by qmake (1.07a) ??? ?? 30 10:58:24 2007
######################################################################

TEMPLATE        = lib
CONFIG         += dll qt_warn debug_and_release
INCLUDEPATH    += .
INCLUDEPATH    += ../include/
INCLUDEPATH    += c:/boost/
HEADERS         = catalog_types.h
SOURCES         = catalog_types.cpp 
#TARGET          = $$qtLibraryTarget(mergethread)
#! [0]
DEFINES += WIN32
DEFINES += CATALOG_TYPES_DLL
CONFIG -= embed_manifest_dll
QT += sql
if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
    DESTDIR =     ../debug/
    LIBS +=   ../debug/catalog.lib
   }
   CONFIG(release, debug|release) {
  #  CONFIG +=     embed_manifest_dll
    DESTDIR = ../release/
    LIBS +=   ../release/catalog.lib
   }
 }