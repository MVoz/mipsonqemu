######################################################################
# Automatically generated by qmake (2.01a) ??? ??? 6 14:25:24 2009
######################################################################

TEMPLATE = app
win32 {
  TARGET = url2img
}
DEPENDPATH += .
INCLUDEPATH += .
INCLUDEPATH += .
CONFIG += debug_and_release

INCLUDEPATH += ../include/
LIBS += -LC:\MySQL\MySQLServer5\lib\opt -llibmysql
INCLUDEPATH += C:\MySQL\MySQLServer5\include

# Input
HEADERS     = window.h
SOURCES     = main.cpp \
              window.cpp
CONFIG     += qt
QT += sql
QT           += network
QTPLUGIN += qsqlmysql
win32 {
  INCLUDEPATH += c:/boost/
  LIBS 		+= shell32.lib user32.lib
  LIBS		+= qsqlmysql4.lib
  CONFIG += embed_manifest_exe

  if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
    CONFIG += console
    DESTDIR =     ./
   }
   CONFIG(release, debug|release) {
      DESTDIR =    ../tool/
  }
}
}