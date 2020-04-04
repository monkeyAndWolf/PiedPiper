#ifndef QQMLRELOADINGENGINE_H
#define QQMLRELOADINGENGINE_H

#include <QFileSystemWatcher>
#include <QQmlApplicationEngine>
#include <QObject>

class ReloadNotifier;

class PPQmlReloadingEngine : public QQmlApplicationEngine
{
public:
    PPQmlReloadingEngine();
    virtual ~PPQmlReloadingEngine();

public Q_SLOTS:
    void load(const QUrl &url);
    void load(const QString &filePath);

    void directoryChanged(QString filePath);

private:
    QString             m_originalFilePath;
    QStringList         m_suffixes;
    QFileSystemWatcher  m_watcher;
    ReloadNotifier     *m_notifier;

    void connectToMainFile(QString file);
    void connectToDirectory(QString directory);
};

#endif // QQMLRELOADINGENGINE_H
