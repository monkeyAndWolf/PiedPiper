#ifndef RELOADNOTIFIER_H
#define RELOADNOTIFIER_H

#include <QDateTime>
#include <QFileSystemWatcher>
#include <QObject>

class PPQmlReloadingEngine;

class ReloadNotifier : public QObject
{
    Q_PROPERTY(QString filepath READ filepath WRITE setFilepath NOTIFY filepathChanged)

    Q_OBJECT
public:
    explicit ReloadNotifier(PPQmlReloadingEngine *engine, QObject *parent = 0);

    QString filepath();
    Q_INVOKABLE void trimCache();

signals:
    void filepathChanged(QString filepath);

public slots:
    void setFilepath(QString filepath);

private:
    QString                 m_filepath;
    PPQmlReloadingEngine   *m_engine;
};

#endif // RELOADNOTIFIER_H
