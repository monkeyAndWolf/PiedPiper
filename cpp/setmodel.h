#ifndef SETMODEL_H
#define SETMODEL_H

#include "set.h"

#include "piedlogger.h"

#include <QAbstractListModel>
#include <QDir>
#include <QFile>
#include <QObject>

class SetModel : public QAbstractListModel
{
    Q_OBJECT
public:
    SetModel();
    SetModel(const SetModel& model) { Q_UNUSED(model); qWarning("Constructor unused!!"); }
    SetModel(PiedLogger *logger, QDir tunesDir);

    virtual ~SetModel();


    enum Roles {
        Name,
        Length,
        Tunes
    };

    QModelIndex index(int row, int column, const QModelIndex &parent) const;
    QModelIndex parent(const QModelIndex &child) const;
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    QHash<int, QByteArray> roleNames() const;

    void addSet(Set *set);
    void bulkAddSet(QList<Set*> sets);
    bool removeSet(Set *set);


    // TODO - which of these options is better?
    Set *getSet(QString setName);
    Set *getSet(int index);
    Q_INVOKABLE int getSetLength(QString setName);
    Q_INVOKABLE QStringList getSetTunes(QString setName);
    Q_INVOKABLE QString getTuneNameAt(QString setName, int index);

    // A better API for the QtQuick side
    Q_INVOKABLE bool setExists(QString setName);
public slots:
    void newSet(QString name);
    void deleteSet(QString name);
    void renameSet(QString oldName, QString newName);
    void removeTuneFromSet(QString setName, QString tuneName);
    void addTuneToSet(QString setName, QString tuneName, int position = -1); // -1 == no-one cares, just append
    void saveSet(QString setName, QStringList tunes); // I think that this is the one which is going to be the most useful
    // So, I don't like the amount of disk writes that setediting would need, but can fix that
    // later. Prolly use a QTimer, NotePuppy style.

private:
    QMap<QString, Set*>    m_sets;
    QHash<int, QByteArray>  m_roles;

    void populateRoles();
    void saveSettings();
    void loadSettings();
    int keyToRole(QString key);
    void doAddSet(Set* set);

    PiedLogger  *m_logger;
    QFile       *m_setSettings;
};


#endif // SETMODEL_H
