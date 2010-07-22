TEMPLATE = app
unix {
  TARGET = launchy
}
win32 {
  TARGET = Tanzhi
}
CONFIG += debug_and_release

#CONFIG += qt release
QT += network
QT += xml
QT += webkit
QT += sql
QT += svg
INCLUDEPATH += .

INCLUDEPATH += ../include/

SOURCES = main.cpp \
 globals.cpp \
 catalog_builder.cpp \
 plugin_handler.cpp \
 platform_util.cpp \
 plugin_interface.cpp 
 
HEADERS = platform_util.h \
 platform_base.h \
 main.h \
 catalog_builder.h \
 plugin_interface.h \
 plugin_handler.h \
 icon_delegate.h 

ICON = Launchy.ico

first.target = blah

unix {
 FORMS =  options.ui
 PREFIX = /usr
 DEFINES += SKINS_PATH=\\\"$$PREFIX/share/launchy/skins/\\\" \
           PLUGINS_PATH=\\\"$$PREFIX/lib/launchy/plugins/\\\" \
           PLATFORMS_PATH=\\\"$$PREFIX/lib/launchy/\\\"
           
 if(!debug_and_release|build_pass) {
  CONFIG(debug, debug|release) {
   DESTDIR =    ../debug/
  }
  CONFIG(release, debug|release) {
   DESTDIR =    ../release/
  }
 }

 target.path = $$PREFIX/bin/

 skins.path = $$PREFIX/share/launchy/skins/
 skins.files = ../skins/*

 icon.path = $$PREFIX/share/pixmaps
 icon.files = ../misc/Launchy_Icon/launchy_icon.png

 desktop.path = $$PREFIX/share/applications/
 desktop.files = ../linux/launchy.desktop

 INSTALLS += target skins icon desktop
}

win32 {
  INCLUDEPATH += c:/boost/
  #FORMS =   options.ui
  RC_FILE =   ../win/launchy.rc
  LIBS +=   shell32.lib
  CONFIG += embed_manifest_exe

  if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
    CONFIG += console
    DESTDIR =     ../debug/
      LIBS +=   ../debug/bmapi.lib
      LIBS +=   ../debug/xmlreader.lib
      LIBS +=   ../debug/posthttp.lib
      LIBS +=   ../debug/mergethread.lib
      LIBS +=   ../debug/bookmark_sync.lib
      LIBS +=   ../debug/synchronizeDlg.lib
      LIBS +=   ../debug/options.lib
      LIBS +=   ../debug/catalog.lib
      LIBS +=   ../debug/catalog_types.lib
      LIBS +=   ../debug/icon_delegate.lib
#      LIBS +=   ../debug/weby.lib
      LIBS +=   ../debug/runner.lib
      LIBS +=   ../debug/updaterThread.lib
   }
   CONFIG(release, debug|release) {
      LIBS +=   ../release/bmapi.lib
      LIBS +=   ../release/xmlreader.lib
      LIBS +=   ../release/posthttp.lib
      LIBS +=   ../release/mergethread.lib
      LIBS +=   ../release/bookmark_sync.lib
      LIBS +=   ../release/synchronizeDlg.lib
      LIBS +=   ../release/options.lib
      LIBS +=   ../release/catalog.lib
      LIBS +=   ../release/catalog_types.lib
      LIBS +=   ../release/icon_delegate.lib
#      LIBS +=   ../release/weby.lib
      LIBS +=   ../release/runner.lib
      LIBS +=   ../release/updaterThread.lib
      DESTDIR =    ../release/
  }
}
}
TRANSLATIONS =  ../translations/launchy_fr.ts  ../translations/launchy_nl.ts  \
		    ../translations/launchy_zh.ts ../translations/launchy_es.ts \
		    ../translations/launchy_de.ts ../translations/launchy_ja.ts
OBJECTS_DIR = build
MOC_DIR = build
#UI_DIR = build
#RESOURCES += launchy.qrc
