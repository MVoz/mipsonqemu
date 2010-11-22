TEMPLATE = app
unix {
  TARGET = launchy
}
win32 {
  TARGET = touchAny
}
CONFIG += debug_and_release

#CONFIG += qt release
QT += network
QT += xml
QT += sql
INCLUDEPATH += .

INCLUDEPATH += ../include/

SOURCES = main.cpp \
 globals.cpp \
 catalog_builder.cpp \
 plugin_interface.cpp \
 platform_util.cpp 

 
HEADERS = platform_util.h \
 platform_base.h \
 main.h \
 catalog_builder.h \
 plugin_interface.h 



ICON = touchAny.ico

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
  RC_FILE =   ../win/launchy.rc
  LIBS +=   shell32.lib
  CONFIG += embed_manifest_exe

  if(!debug_and_release|build_pass) {
   CONFIG(debug, debug|release) {
    CONFIG += console
    DESTDIR =     ../debug/
      LIBS +=   ../debug/bmapi.lib
      LIBS +=   ../debug/bmxml.lib
      LIBS +=   ../debug/bmpost.lib
      LIBS +=   ../debug/bmmerge.lib
      LIBS +=   ../debug/bmsync.lib
      LIBS +=   ../debug/optionUI.lib
      LIBS +=   ../debug/baseitem.lib
      LIBS +=   ../debug/appupdater.lib
      LIBS +=   ../debug/fileget.lib
      LIBS +=   ../debug/bmnet.lib
   }
   CONFIG(release, debug|release) {
      DESTDIR =    ../release/	
      LIBS +=   ../release/bmapi.lib
      LIBS +=   ../release/bmxml.lib
      LIBS +=   ../release/bmpost.lib
      LIBS +=   ../release/bmmerge.lib
      LIBS +=   ../release/bmsync.lib
      LIBS +=   ../release/optionUI.lib
      LIBS +=   ../release/baseitem.lib
      LIBS +=   ../release/appupdater.lib
      LIBS +=   ../release/fileget.lib
      LIBS +=   ../release/bmnet.lib
      
  }
}
}
#TRANSLATIONS =  ../translations/launchy_fr.ts  ../translations/launchy_nl.ts  \
#		    ../translations/launchy_zh.ts ../translations/launchy_es.ts \
#		    ../translations/launchy_de.ts ../translations/launchy_ja.ts
OBJECTS_DIR = build
MOC_DIR = build
#UI_DIR = build
#RESOURCES += launchy.qrc
