TEMPLATE = app

QT += qml quick widgets svg xml gui websockets

android {
    DEFINES += MOBILE_DEVICE
    DEFINES += ANDROID_FTW
    LIBS += -L../ShotGlassAndroid -lABCShots
}
ios {
    DEFINES += MOBILE_DEVICE
    DEFINES += CUPERTINO_BABY
    LIBS += -L../ShotGlassIos -lABCShots
}
#!android:!ios {
#    QT += webengine
#}

linux:!android {
    LIBS += -L../ShotGlass -lABCShots
}

macx {
    ICON = assets/piedpiper.icns
    LIBS += -L../ShotGlass -lABCShots
}

# Add the ShotGlass SVG cruncher
INCLUDEPATH += ../ABCShot

SOURCES += cpp/main.cpp \
    cpp/tunesmodel.cpp \
    cpp/setmodel.cpp \
    cpp/tune.cpp \
    cpp/tuneloadingthread.cpp \
    cpp/filepusher.cpp \
    cpp/styleclass.cpp \
    cpp/tunesettingsstore.cpp \
    cpp/settingsaccess.cpp \
    cpp/generalfilesaver.cpp \
    cpp/piedlogger.cpp \
    cpp/set.cpp \
    cpp/setbuildertunemodel.cpp \
    cpp/tunesvggrndr.cpp \
    cpp/ppqmlreloadingengine.cpp \
    cpp/reloadnotifier.cpp \
    cpp/websocketserver.cpp \
    cpp/websocketclient.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    cpp/tunesmodel.h \
    cpp/setmodel.h \
    cpp/tune.h \
    cpp/tuneloadingthread.h \
    cpp/filepusher.h \
    cpp/styleclass.h \
    cpp/tunesettingsstore.h \
    cpp/settingsaccess.h \
    cpp/generalfilesaver.h \
    cpp/piedlogger.h \
    cpp/set.h \
    cpp/setbuildertunemodel.h \
    cpp/tunesvggrndr.h \
    cpp/ppqmlreloadingengine.h \
    cpp/reloadnotifier.h \
    cpp/websocketserver.h \
    cpp/websocketclient.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/assets/page.html

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
