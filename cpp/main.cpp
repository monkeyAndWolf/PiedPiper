#include "generalfilesaver.h"
#include "filepusher.h"
#include "piedlogger.h"
#include "set.h"
#include "setmodel.h"
#include "setmodel.h"
#include "settingsaccess.h"
#include "styleclass.h"
#include "tune.h"
#include "tunesmodel.h"
#include "tunesettingsstore.h"
#include "tunesvggrndr.h"
#include "websocketclient.h"
#include "websocketserver.h"

#include <QApplication>
#include <QDir>
#include <QObject>
#include <qqml.h>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlEngine>
#include <QTextStream>
#if MOBILE_DEVICE
#include <QDebug>
#include <QString>
#endif

//#define DEV_QML

#ifdef DEV_QML
#include "ppqmlreloadingengine.h"
#endif // DEV_QML

#include <QObject>

#include <QDebug>

void createButtermilkMary(QDir buttermilkMaryDir)
{
    QString buttermilkMary = "X: 1\nT: Buttermilk Mary\nZ: Red Crow\nS: https://thesession.org/tunes/8008#setting8008\nR: jig\nM: 6/8\nL: 1/8\nK: Gmaj\nBGE EDB,| DGB dBG| c2e dBG| FA^G ABc|\nBd^c def| gfe edc| (3Bcd B cAd| BGF G2B:|\ndgf gfe| dBG GBd| ea^g a2g| (3fga f def|\ngbg faf| ege def| gdB AGA| BGF G3:|";
    QString pathToMary = buttermilkMaryDir.path().append(QDir::separator()).append("buttermilkmary.abc");
    QFile mary(pathToMary);
    if (!mary.exists() && mary.open(QIODevice::WriteOnly))
    {
        QTextStream maryText(&mary);
        maryText << buttermilkMary;
        mary.close();
    }
}

void createDirectory(QDir directory)
{
#ifdef CUPERTINO_BABY
    createButtermilkMary(directory);
#else
    if (!directory.exists())
    {
        if (directory.mkdir(directory.path()))
        {
            createButtermilkMary(directory);
        }
    }
#endif
}

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QCoreApplication::setOrganizationName("loralora.co.uk");
    QCoreApplication::setApplicationName("PiedPiper");
    QString tunesDirDefault;

    qRegisterMetaType<TunesModel>("TunesModel");

    QString importDirectory;
    QString actualHomeDir = QDir::homePath();


#if MOBILE_DEVICE
    importDirectory = qgetenv("EXTERNAL_STORAGE");
//    tunesDirDefault += "/Android/data/co.uk.loralora.PiedPiper/Tunes";
#else
    importDirectory = actualHomeDir;
#endif // MOBILE_DEVICE

#ifndef CUPERTINO_BABY
    tunesDirDefault= QDir::homePath() + QDir::separator() + "PiedPiperTunes";
#else
    tunesDirDefault= QDir::homePath() + QDir::separator() + "Documents";
//    tunesDirDefault= QDir::homePath() + QDir::separator() + "PiedPiper.app" + QDir::separator() + "PiedPiperTunes";
#endif // CUPERTINO_BABY
    // This would be where the option for changing the tunesDir would kick in
    QDir tunesDir(tunesDirDefault);

    // Check the Directory exists, if not then create it and add a free tune
    createDirectory(tunesDir);




#if MOBILE_DEVICE
    QString displayUrl = "file:///android_asset/page.html";
#else
    QString displayUrl = "qrc:/html/page.html";
#endif

    PiedLogger logger(tunesDirDefault);
    QStringList exts;
    exts << "*.abc" << "*.png" << "*.jpg";
    TunesModel tuneModel(&logger, tunesDir, exts);
//    TuneSettingsStore::init(tunesDirDefault, &tuneModel);

    FilePusher filePusher;
    QObject::connect(&filePusher, &FilePusher::filePushed, &tuneModel, &TunesModel::importAFile);
    QObject::connect(&filePusher, &FilePusher::fileDeleteRequested, &tuneModel, &TunesModel::deleteAFile);

    StyleClass styles;
    SettingsAccess access(&tuneModel);

    GeneralFileSaver gfs(actualHomeDir);

    WebSocketServer wss;
    WebSocketClient wsc;

#if MOBILE_DEVICE
//    qDebug() << "Home direcotry"<< actualHomeDir;
//    qDebug() << "Import directory" << importDirectory;
#endif

    SetModel setModel(&logger, tunesDir);

#if 0
    Set *set1 = new Set();
    set1->setSetName("Monkey with this Set");
    set1->append("/data/data/co.uk.loralora.PiedPiper/files/PiedPiperTunes/giveusadrinkofwater-4.abc");
    set1->append("/data/data/co.uk.loralora.PiedPiper/files/PiedPiperTunes/chanterssong-1.abc");
    set1->append("/data/data/co.uk.loralora.PiedPiper/files/PiedPiperTunes/outontheocean-7.abc");
    setModel.addSet(set1);

    Set *set2 = new Set();
    set2->setSetName("Practice these tunes");
    set2->append("/data/data/co.uk.loralora.PiedPiper/files/PiedPiperTunes/concertina-1.abc");
    set2->append("/data/data/co.uk.loralora.PiedPiper/files/PiedPiperTunes/farewelltoerin-4.abc");
    set2->append("/data/data/co.uk.loralora.PiedPiper/files/PiedPiperTunes/offtocalifornia-1.abc");
    setModel.addSet(set2);

    Set *set3 = new Set();
    set3->setSetName("Jigs to proctice");
    set3->append("/data/data/co.uk.loralora.PiedPiper/files/PiedPiperTunes/blarneypilgrim-1.abc");
    set3->append("/data/data/co.uk.loralora.PiedPiper/files/PiedPiperTunes/banishmisfortune-1.abc");
    set3->append("/data/data/co.uk.loralora.PiedPiper/files/PiedPiperTunes/garrettbarrys-1.abc");
    set3->append("/data/data/co.uk.loralora.PiedPiper/files/PiedPiperTunes/rollingwaves-1.abc");
    setModel.addSet(set3);
#endif

    TuneSVGGrndr svgGenerator;


#ifdef DEV_QML
    PPQmlReloadingEngine engine;
#else
    QQmlApplicationEngine engine;
#endif // DEV_QML
    engine.rootContext()->setContextProperty("actualHomeDir", actualHomeDir);
    engine.rootContext()->setContextProperty("importDirectory", importDirectory);
    engine.rootContext()->setContextProperty("filePusher", &filePusher);
    engine.rootContext()->setContextProperty("fileSaver", &gfs);
    engine.rootContext()->setContextProperty("setModel", &setModel);
    engine.rootContext()->setContextProperty("settingsAccess", &access);
    engine.rootContext()->setContextProperty("styles", &styles);
    engine.rootContext()->setContextProperty("svgGen", &svgGenerator);
    engine.rootContext()->setContextProperty("tuneDir", tunesDirDefault);
    engine.rootContext()->setContextProperty("tuneModel", &tuneModel);
    engine.rootContext()->setContextProperty("pageLike", displayUrl);
    engine.rootContext()->setContextProperty("logger", &logger);
    engine.rootContext()->setContextProperty("wss", &wss);
    engine.rootContext()->setContextProperty("wsc", &wsc);

    qmlRegisterType<Tune>("PiedPiper", 1, 0, "Tune");
    qmlRegisterType<TunesModel>("PiedPiper", 1, 0, "TunesModel");

#ifdef DEV_QML
    // Use whatever path is being used for development on the dev machine.
    engine.load(QUrl(QStringLiteral("/Users/becks/Code/piedpiper/qml/main.qml")));
#else
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
#endif // DEV_QML
    return app.exec();
}
