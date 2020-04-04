#include "ppqmlreloadingengine.h"
#include "reloadnotifier.h"

#include <QDebug>
#include <QDir>
#include <QFile>
#include <QQmlContext>

#define LOADER_URL  QUrl("qrc:/qml/launcher.qml")

PPQmlReloadingEngine::PPQmlReloadingEngine() : QQmlApplicationEngine()
{
    connect(&m_watcher, &QFileSystemWatcher::directoryChanged, this, &PPQmlReloadingEngine::directoryChanged);
    connect(&m_watcher, &QFileSystemWatcher::fileChanged, this, &PPQmlReloadingEngine::directoryChanged);
    m_notifier = new ReloadNotifier(this);

    m_suffixes << QStringLiteral("qml");
    m_suffixes << QStringLiteral("js");
    m_suffixes << QStringLiteral("png");
    m_suffixes << QStringLiteral("jpg");
    m_suffixes << QStringLiteral("jpeg");
    m_suffixes << QStringLiteral("gif");

    this->rootContext()->setContextProperty("reloader", m_notifier);
}

PPQmlReloadingEngine::~PPQmlReloadingEngine()
{
    m_notifier->deleteLater();
}

void PPQmlReloadingEngine::load(const QUrl &url)
{
    QString urlString = url.toString(QUrl::RemoveScheme|QUrl::PreferLocalFile);

    QFileInfo info(urlString);
    if (!info.exists()) {
        QString wrongPathStupid = "The file at " + urlString + " does not exist :|";
        qWarning() << wrongPathStupid;
    }

    this->load(urlString);
}

void PPQmlReloadingEngine::load(const QString &filePath)
{
    connectToMainFile(filePath);
    m_notifier->setFilepath(filePath);
    QQmlApplicationEngine::load(LOADER_URL);
}

void PPQmlReloadingEngine::connectToMainFile(QString file)
{
    m_originalFilePath = file;
    int stripFrom = m_originalFilePath.lastIndexOf(QDir::separator());
    connectToDirectory(m_originalFilePath.left(stripFrom));
}

void PPQmlReloadingEngine::connectToDirectory(QString directory)
{
    // 0. Listen to the directory
    m_watcher.addPath(directory);
    // 1. List all the files we are interested in and hook them up
    QDir dir(directory);
    QStringList relevantFiles = dir.entryList();
    // This should be easier to do, but Ima do it the hard way
    foreach (QString filename, relevantFiles) {
        if (!filename.startsWith("."))
        {
            filename.prepend((directory + QDir::separator()));
            QFileInfo info(filename);
            if (info.isDir())
                connectToDirectory(filename);
            else if (m_suffixes.contains(info.completeSuffix()))
                    m_watcher.addPath(filename);
        }
    }
}

void PPQmlReloadingEngine::directoryChanged(QString filePath)
{
    Q_UNUSED(filePath);
    m_watcher.removePaths(m_watcher.directories());
    m_watcher.removePaths(m_watcher.files());
//    this->clearComponentCache();
    this->load(m_originalFilePath);
}
