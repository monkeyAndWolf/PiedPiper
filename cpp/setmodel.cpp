#include "setmodel.h"

#include <QModelIndex>
#include <QTextStream>
//#include <QVector>

SetModel::SetModel()
{
    qWarning("SetModel constructor unused.");
}

SetModel::SetModel(PiedLogger *logger, QDir tunesDir)
{
    m_logger = logger;
    QString setFile = tunesDir.absolutePath() + QDir::separator() + "setFile.ini";
    m_setSettings = new QFile(setFile, this);
    populateRoles();
    loadSettings();
}

SetModel::~SetModel()
{
    if (m_setSettings->isOpen())
        m_setSettings->close();
}

// === QML API

void SetModel::newSet(QString name)
{
    Set *set = new Set();
    set->setSetName(name); // lol
    emit layoutAboutToBeChanged();
    m_sets[name] = set;
    saveSettings();
    emit layoutChanged();
}

void SetModel::deleteSet(QString name)
{
    emit layoutAboutToBeChanged();
    m_sets.remove(name);
    saveSettings();
    emit layoutChanged();
}

void SetModel::renameSet(QString oldName, QString newName)
{
    emit layoutAboutToBeChanged();
    if (m_sets.keys().contains(oldName))
    {
        emit layoutAboutToBeChanged();
        Set *set = m_sets[oldName];
        m_sets.remove(oldName);
        set->setSetName(newName);
        m_sets[newName] = set;
        emit layoutChanged();
        saveSettings();
    }
    emit layoutChanged();
}

void SetModel::removeTuneFromSet(QString setName, QString tuneName)
{
    if (m_sets.keys().contains(setName))
    {
        emit layoutAboutToBeChanged();
        Set *set = m_sets[setName];
        bool chuneFound = false;
        int i;
        for (i = 0; i < set->length(); i++)
        {
            if (set->at(i) == tuneName)
            {
                chuneFound = true;
                break;
            }
        }
        if (chuneFound)
            set->removeAt(i);
        saveSettings();
        emit layoutChanged();
    }
}

void SetModel::addTuneToSet(QString setName, QString tuneName, int position)
{
    if (m_sets.keys().contains(setName))
    {
        emit layoutAboutToBeChanged();
        Set *set = m_sets[setName];
        if (position == -1)
        {
            set->append(tuneName);
        }
        else
        {
            if (!((position < 0) && (position > (set->length()-1))))
            {
                set->insert((position-1), tuneName); // most likely I got the insert position wrong.
            }
        }
        saveSettings();
        emit layoutChanged();
    }
}

void SetModel::saveSet(QString setName, QStringList tunes)
{
    emit layoutAboutToBeChanged();
    Set *set = 0;
    if (m_sets.keys().contains(setName))
    {
        set = m_sets[setName];
        set->clear();
    }
    else
    {
        set = new Set();
        set->setSetName(setName);
    }
    set->append(tunes);
    m_sets[setName] = set;
    saveSettings();
    emit layoutChanged();
}


// === Yo end QML API



QModelIndex SetModel::index(int row, int column, const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return createIndex(row, column);
}

QModelIndex SetModel::parent(const QModelIndex &child) const
{
    Q_UNUSED(child)
    return QModelIndex();
}

int SetModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_sets.size();
}

QVariant SetModel::data(const QModelIndex &index, int role) const
{
    Set *set;
    QVariant v;
    int rowIndex = index.row();
    if (rowIndex > -1 && !(rowIndex >= m_sets.size()))
    {
        set = m_sets.values().at(rowIndex);
        switch (role)
        {
        case SetModel::Name:
            v = set->setName();
            break;
        case SetModel::Length:
            v = set->length();
            break;
        case SetModel::Tunes:
            QStringList choons(*set);
            v = choons;
        }
    }
    return v;
}

QHash<int, QByteArray> SetModel::roleNames() const
{
    return m_roles;
}

QString SetModel::getTuneNameAt(QString setName, int index)
{
    Set* s = m_sets[setName];
    if (s)
    {
        if (index < s->length())
            return s->at(index);
    }
    return QString("");
}

// This would be another way of editing the model from the QtQuick side, but it
// doesnae work like that so it's not implemented.
bool SetModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    Set *set = m_sets.values().at(index.row());

    if (role == Roles::Name) {
        set->setSetName(value.toString());
        QVector<int> v;
        v << role;
        saveSettings();
        emit dataChanged(index, index, v);
    }

    return false;
}

// Currently tunes added from the C++ side do not trigger change notifications
// This is mostly because I want to make sure that these changes work, but also
// because there is no C++ API for changing tunes at runtime. So there.
void SetModel::bulkAddSet(QList<Set *> sets)
{
    foreach (Set* setti, sets)
    {
        doAddSet(setti);
    }
    saveSettings();
}

void SetModel::addSet(Set *set)
{
    doAddSet(set);
    saveSettings();
}

void SetModel::doAddSet(Set *set)
{
    m_sets[set->setName()] = set;
}


bool SetModel::removeSet(Set *set)
{
    if (m_sets.keys().contains(set->setName()))
    {
        m_sets.remove(set->setName());
        saveSettings();
        return true;
    }
    return false;
}

// does this need to be a list of sets to cover use case of set with same name
Set *SetModel::getSet(QString setName)
{
    Set *setFound = 0;
    // TODO searching all sets is a pita, so change to hash-based
    // system if this looks usesful.
    // Actually may need that anyway if this is going to be searchable.
    foreach(Set *set, m_sets)
    {
        if (set->setName() == setName)
            setFound = set;
    }
    return setFound;
}

Set *SetModel::getSet(int index)
{
    Set *set = 0;
    if (index > -1 && index >= m_sets.size())
    {
        set = m_sets.values().at(index);
    }
    return set;
}

int SetModel::keyToRole(QString key)
{
    int keyIndex = m_roles.values().indexOf(key.toLatin1());
    if (keyIndex != -1)
    {
        keyIndex = m_roles.keys().indexOf(keyIndex);
    }
    return keyIndex;
}

int SetModel::getSetLength(QString setName)
{
    Set *set = getSet(setName);
    if (set)
        return set->length();
    return 0;
}

QStringList SetModel::getSetTunes(QString setName)
{
    Set *set = getSet(setName);
    QStringList list;
    if (set)
    {
        // Pöh
        for (int i = 0; i < set->length(); i++)
        {
            list << set->at(i);
        }
    }
    return list;
}


// TODO - not overly happy with the usable keys being buried so deep in the CPP.
// Would be good to take them out and put them somewhere visible.
void SetModel::populateRoles()
{
    m_roles[SetModel::Name] = "setName";
    m_roles[SetModel::Length] = "length";
    m_roles[SetModel::Tunes] = "tunes";
}

bool SetModel::setExists(QString setName)
{
    return m_sets.contains(setName);
}

void SetModel::loadSettings()
{
    if (m_setSettings->open(QIODevice::ReadOnly))
    {
        QString setStr = m_setSettings->readLine();
        while (!setStr.isEmpty())
        {
            Set *s = new Set();
            QStringList setBits = setStr.split("∆");
            s->setSetName(setBits.at(0));
            for (int i = 1; i < setBits.length(); i++)
            {
                s->append(QString(setBits.at(i)).trimmed());
            }
            doAddSet(s);
            setStr = m_setSettings->readLine();
        }
        m_setSettings->close();
    }
}

void SetModel::saveSettings()
{
    if (m_setSettings->open(QIODevice::WriteOnly))
    {
        QTextStream stream(m_setSettings);
        foreach (Set *set, m_sets.values())
        {
            stream << set->toString();
            stream << "\r\n";
            stream.flush();
        }
        m_setSettings->close();
    }
}
