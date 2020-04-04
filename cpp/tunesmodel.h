#ifndef TUNESMODEL_H
#define TUNESMODEL_H

#include "tunesettingsstore.h"
#include "tune.h"
#include "piedlogger.h"

#include <QAbstractListModel>
#include <QDir>
#include <QFileSystemWatcher>
#include <QObject>

class Tune;
class TuneLoadingThread;

class TunesModel : public QAbstractListModel
{
    Q_OBJECT


public:
    Q_PROPERTY(QString homeDir READ getHomeDirectory)
    enum Filter {
        NoFilter = 0,
        Title,
        Author,
        Type,
        Meter,
        Notes
    };
    Q_ENUMS(Filter)

    TunesModel();
    TunesModel(const TunesModel& model);
    TunesModel(PiedLogger *logger, QDir tunesDir, QStringList extensions);

    virtual ~TunesModel();

    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE QString getHomeDirectory();
    Q_INVOKABLE QVariant getValue(QString filename, QString key);
    Q_INVOKABLE QString importAFile(QString filePath);
    Q_INVOKABLE QString randomTune();

    bool slideDataIn(QString filename, QString key, QVariant value);

    void addFiles(QFileInfoList infoList);
    void addTune(QFileInfo fileInfo);

    void sortByName(bool forward = true);
    void sortByMeter(bool forward = true);
    void sortByAuthor(bool forward = true);
    void sortByType(bool forward = true);

    Q_INVOKABLE QString tunePathToName(QString path);
    Q_INVOKABLE int filter(Filter role, QString expression);

public slots:

    void deleteAFile(QString filePath);

    void setValue(QString filename, QString key, QVariant value);

    void fileDirectoryChanged(QString directory);

    void sortTunes(TunesModel::Filter sortBy, bool forward = true);
    void clearFilter();

private:

    void quickAddTune(QFileInfo info);
    void prependTune(QFileInfo info);
    int keyToRole(QString key);
    int getTuneActualIndex(QString filename);
    int getTuneDisplayIndex(QString filename);

    void sortAppropriately();

    QList <Tune*> getTuneList();

    QHash<int, QByteArray>      m_roles;
    QList <Tune*>               m_tunesStore;
    QList <Tune*>               m_tunesDisplayed;
    QString                     m_homeDir;
    TuneSettingsStore          *m_store;
    QFileSystemWatcher          m_watcher;
    QStringList                 m_extensions;
    bool                        m_expectDirectoryChange;
    PiedLogger                 *m_logger;

    Filter                      m_filter;
    QString                     m_filterExpression;
    Filter                      m_currentSort;
    bool                        m_sortAscending;

    void deleteTuneSettings(QString filename);
    Tune *createTune(QFileInfo fileInfo);

    bool putTuneThroughFilter(Tune *tune);

    static bool tuneNameLessThan(Tune *tune1, Tune* tune2);
    static bool meterLessThan(Tune *tune1, Tune* tune2);
    static bool authorLessThan(Tune *tune1, Tune *tune2);
    static bool typeLessThan(Tune *tune1, Tune *tune2);
    static bool tuneNameMoreThan(Tune *tune1, Tune* tune2);
    static bool meterMoreThan(Tune *tune1, Tune* tune2);
    static bool authorMoreThan(Tune *tune1, Tune *tune2);
    static bool typeMoreThan(Tune *tune1, Tune *tune2);
};

Q_DECLARE_METATYPE(TunesModel)

#endif // TUNESMODEL_H
