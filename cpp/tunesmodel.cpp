#include "tunesmodel.h"

#include "tune.h"
#include "tuneloadingthread.h"

#include <QDebug>
#include <QFile>
#include <QHashIterator>
#include <QModelIndex>
#include <QUrl>

TunesModel::TunesModel() : QAbstractListModel()
  , m_expectDirectoryChange(false)
  , m_filter(NoFilter)
  , m_currentSort(TunesModel::Title)
  , m_sortAscending(true)
{
    m_store = new TuneSettingsStore(QDir::homePath());
    m_watcher.addPath(QDir::homePath());
}

TunesModel::TunesModel(const TunesModel &model) : QAbstractListModel()
  , m_expectDirectoryChange(false)
  , m_filter(NoFilter)
  , m_currentSort(TunesModel::Title)
  , m_sortAscending(true)
{
    m_store = new TuneSettingsStore(model.m_homeDir);
    m_tunesStore = model.m_tunesStore;
    m_watcher.addPath(model.m_homeDir);
}

TunesModel::TunesModel(PiedLogger *logger, QDir tunesDir, QStringList extensions) : QAbstractListModel()
  , m_expectDirectoryChange(false)
  , m_logger(logger)
  , m_filter(NoFilter)
  , m_currentSort(TunesModel::Title)
  , m_sortAscending(true)
{
    m_store = new TuneSettingsStore(tunesDir.absolutePath());
    m_watcher.addPath(tunesDir.absolutePath());
    m_extensions = extensions;

    connect(&m_watcher, &QFileSystemWatcher::directoryChanged, this, &TunesModel::fileDirectoryChanged);

    m_roles[Tune::Title] = "title";
    m_roles[Tune::Meter] = "meter";
    m_roles[Tune::Author] = "author";
    m_roles[Tune::Content] = "content";
    m_roles[Tune::Filename] = "filename";
    m_roles[Tune::Type] = "type";
    m_roles[Tune::FileType] = "fileType";
    m_roles[Tune::Notes] = "notes";

    QFileInfoList fil = tunesDir.entryInfoList(extensions);

    TuneLoadingThread *loadingThread = new TuneLoadingThread(fil, this, this);
    connect(loadingThread, &TuneLoadingThread::finished, loadingThread, &TuneLoadingThread::deleteLater);
    loadingThread->start();
    m_homeDir = tunesDir.absolutePath();
}

TunesModel::~TunesModel()
{
    delete (m_store);
}

void TunesModel::clearFilter()
{
    m_filter = NoFilter;
    m_filterExpression = "";
    QList<Tune*>::const_iterator it;
    int i;
    for (i = 0, it = m_tunesStore.begin(); it != m_tunesStore.end(); ++it, ++i)
    {
        Tune *t = *it;
        if (!m_tunesDisplayed.contains(t))
        {
            beginInsertRows(QModelIndex(), m_tunesDisplayed.size(), m_tunesDisplayed.length());
            m_tunesDisplayed.append(t);
            endInsertRows();
        }
    }
    sortAppropriately();
}

int TunesModel::filter(TunesModel::Filter role, QString expression)
{
    QList<Tune*>::const_iterator it;
    m_filter = role;
    m_filterExpression = expression;
    int i;
    for (i = 0, it = m_tunesStore.begin(); it != m_tunesStore.end(); ++it, ++i)
    {
        Tune *t = *it;

        if (putTuneThroughFilter(t))
        {
            // The tune should be displayed. Is it though?
            if (!m_tunesDisplayed.contains(t))
            {
                //no, so add it
                beginInsertRows(QModelIndex(), m_tunesDisplayed.size(), m_tunesDisplayed.length());
                m_tunesDisplayed.append(t);
                endInsertRows();
            }
        }
        else
        {
            // The tune should not be displayed
            if (m_tunesDisplayed.contains(t))
            {
                int row = m_tunesDisplayed.indexOf(t);
                beginRemoveRows(QModelIndex(), row, row);
                m_tunesDisplayed.removeAt(row);
                endRemoveRows();
            }
        }
    }
    sortAppropriately();
    return m_tunesDisplayed.length();
}

void TunesModel::sortTunes(TunesModel::Filter sortBy, bool forward)
{
    if (sortBy != m_currentSort && m_sortAscending != forward)
    {
        if (sortBy != NoFilter && sortBy != Notes)
        {
            m_currentSort = sortBy;
            m_sortAscending = forward;
            sortAppropriately();
        }
    }
}

QString TunesModel::tunePathToName(QString path)
{
    foreach (Tune* tune, m_tunesStore) {
        if (tune->filename() == path) {
            return tune->title();
        }
    }
    return "";
}

void TunesModel::fileDirectoryChanged(QString directory)
{
    if (!m_expectDirectoryChange)
    {
        QDir like(directory);
        QStringList filesNow = like.entryList(m_extensions);
        foreach (QString file, filesNow)
        {
            file.prepend(QDir::separator());
            file.prepend(directory);           
            if (getTuneActualIndex(file) == -1)
            {
                m_logger->logTuneImport(file);
                quickAddTune(QFileInfo(file));
            }
        }
        emit layoutAboutToBeChanged();
        sortByName();  // TODO - it would be better to have a 'most recent sort' feature
        emit layoutChanged();
        m_expectDirectoryChange = false;
    }
}

QString TunesModel::randomTune()
{
    int rnd = qrand();
    rnd = rnd % (m_tunesStore.length()-1);
    Tune *t = m_tunesStore[rnd];
    return t->filename();
}

QString TunesModel::importAFile(QString filePath)
{
    QUrl url(filePath);
    QFile f(url.toLocalFile());
    QString newFileName = "";
    if (f.exists())
    {
        QFileInfo info(f);
        newFileName = m_homeDir + QDir::separator() + info.fileName();
        if (f.copy(f.fileName(), newFileName))
        {
            QFileInfo moreInfo(newFileName);
            prependTune(moreInfo);
        }
        sortByName();
        emit layoutChanged();
    }
    return newFileName;
}


QString TunesModel::getHomeDirectory()
{
    return m_homeDir;
}

int TunesModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_tunesDisplayed.size();
}


QVariant TunesModel::data(const QModelIndex &index, int role) const
{

    Tune *tune = m_tunesDisplayed.at(index.row());
    QVariant v = tune->getValue(role);
    return v;
}

int TunesModel::getTuneActualIndex(QString filename)
{
    int i =  0;
    bool found = false;
    for ( ; i < m_tunesStore.length(); ++i)
    {
        if (m_tunesStore[i]->filename() == filename)
        {
            found = true;
            break;
        }
    }
    if (!found)
    {
        i = -1;
    }
    return i;
}

int TunesModel::getTuneDisplayIndex(QString filename)
{
    int i =  0;
    bool found = false;
    for ( ; i < m_tunesDisplayed.length(); ++i)
    {
        if (m_tunesDisplayed[i]->filename() == filename)
        {
            found = true;
            break;
        }
    }
    if (!found)
    {
        i = -1;
    }
    return i;
}

bool TunesModel::slideDataIn(QString filename, QString key, QVariant value)
{
    bool result = false;
    int number = getTuneDisplayIndex(filename);
    if (number != -1)
    {
        emit layoutAboutToBeChanged();
        int role = -1;
        Tune *tune = m_tunesDisplayed[number];
        role = keyToRole(key);
        if (tune && (role > -1))
        {
            tune->setValue(value, role);
            emit dataChanged(index((number), 0), index((number), 0));
            result = true;
        }
        emit layoutChanged();
    }
    return result;
}

int TunesModel::keyToRole(QString key)
{
    if ("title" == key)
        return Tune::Title;
    else if ("meter" == key)
        return Tune::Meter;
    else if ("author" == key)
        return Tune::Author;
    else if ("content" == key)
        return Tune::Content;
    else if ("filename" == key)
        return Tune::Filename;
    else if ("type" == key)
        return Tune::Type;
    else if ("fileType" == key)
        return Tune::FileType;
    else if ("editable" == key)
        return Tune::IsEditable;
    return 10;
}

QHash<int, QByteArray> TunesModel::roleNames() const
{
    return m_roles;
}


void TunesModel::deleteAFile(QString filePath)
{
    int i = getTuneActualIndex(filePath);
    m_tunesStore.removeAt(i);
    i = getTuneDisplayIndex(filePath);
    if (-1 != i)
    {
        beginRemoveRows(QModelIndex(), i,i);
        QFile f(filePath);
        bool success = f.remove();
        if (success)
        {
            m_tunesDisplayed.removeAt(i);
            deleteTuneSettings(filePath);
            endRemoveRows();
        }
    }
}


void TunesModel::addFiles(QFileInfoList infoList)
{
    beginInsertRows(QModelIndex(), (m_tunesDisplayed.size()+1), (m_tunesDisplayed.size()+infoList.size()));
    foreach (QFileInfo fileInfo, infoList) {
       quickAddTune(fileInfo);
    }
    sortByName();
    endInsertRows();
}

void TunesModel::prependTune(QFileInfo info)
{
    clearFilter();
    Tune *tuneARoonie = createTune(info);
    m_tunesStore.prepend(tuneARoonie);
    if (putTuneThroughFilter(tuneARoonie))
    {
        m_tunesDisplayed.prepend(tuneARoonie);
        int here = 0;
        Q_ASSERT(0 == getTuneDisplayIndex(info.absoluteFilePath()));
        beginInsertRows(QModelIndex(), here, here);
        endInsertRows();
    }
}

void TunesModel::addTune(QFileInfo fileInfo)
{
    if (m_filter)
    {
        beginInsertRows(QModelIndex(), (m_tunesStore.size()), (m_tunesStore.size()));
        quickAddTune(fileInfo);
        endInsertRows();
    }
    else
    {
        beginInsertRows(QModelIndex(), (m_tunesDisplayed.size()), (m_tunesDisplayed.size()));
        quickAddTune(fileInfo);
        endInsertRows();
    }

}

void TunesModel::quickAddTune(QFileInfo info)
{
    clearFilter();
    Tune *tuneARoonie =  createTune(info); //new Tune(info);
    m_tunesStore.append(tuneARoonie);
    if (putTuneThroughFilter(tuneARoonie))
        m_tunesDisplayed.append(tuneARoonie);
}


void TunesModel::deleteTuneSettings(QString filename)
{
    for (int i = 0; i < m_roles.size(); i++)
    {
        m_store->deleteValue(filename, m_roles.values().at(i));
    }
}

void TunesModel::setValue(QString filename, QString key, QVariant value)
{
    m_store->setValue(filename, key, value);
    if (slideDataIn(filename, key, value))
    {
        m_expectDirectoryChange = true;
//        emit layoutAboutToBeChanged();
//        sortByName();
//        emit layoutChanged();
    }
}

QVariant TunesModel::getValue(QString filename, QString key)
{
    QVariant v;
    foreach (Tune *tune, m_tunesStore) {
        if (tune->filename() == filename) {
            v = tune->getValue(keyToRole(key));
            break;
        }
    }

    return v;
}

Tune *TunesModel::createTune(QFileInfo fileInfo)
{

    Tune *newTune = new Tune(fileInfo);
    // And populate some of the standard fields:
    QString filename = fileInfo.absoluteFilePath();
    if (newTune->fileType() != Tune::Abc)
    {
        for (int i = 0; i < m_roles.size(); i++)
        {
            int key = m_roles.keys().at(i);
            if ((key != Tune::Filename) && (key != Tune::Content) && (key != Tune::FileType))
                newTune->setValue( m_store->getValue(filename, m_roles[key]), key );
        }
    }
    else
    {
        newTune->setValue(m_store->getValue(filename, m_roles[Tune::Notes]), Tune::Notes);
    }

    return newTune;
}

void TunesModel::sortAppropriately()
{
    switch (m_currentSort) {
    case Meter:
        emit layoutAboutToBeChanged();
        sortByMeter(m_sortAscending);
        emit layoutChanged();
        break;
    case Author:
        emit layoutAboutToBeChanged();
        sortByAuthor(m_sortAscending);
        emit layoutChanged();
    case Title:
    default:
        emit layoutAboutToBeChanged();
        sortByName(m_sortAscending);
        emit layoutChanged();
        break;
    }
}


void TunesModel::sortByName(bool forward)
{
    if (forward)
        std::sort(m_tunesDisplayed.begin(), m_tunesDisplayed.end(), tuneNameLessThan);
    else
        std::sort(m_tunesDisplayed.begin(), m_tunesDisplayed.end(), tuneNameMoreThan);
}

bool TunesModel::tuneNameLessThan(Tune *tune1, Tune *tune2)
{
    return (tune1->title() < tune2->title());
}

bool TunesModel::tuneNameMoreThan(Tune *tune1, Tune *tune2)
{
    return (tune2->title() < tune1->title());
}

void TunesModel::sortByMeter(bool forward)
{
    if (forward)
        std::sort(m_tunesDisplayed.begin(), m_tunesDisplayed.end(), meterLessThan);
    else
        std::sort(m_tunesDisplayed.begin(), m_tunesDisplayed.end(), meterMoreThan);
}

bool TunesModel::meterLessThan(Tune *tune1, Tune* tune2)
{
    return (tune1->meter() < tune2->meter());
}

bool TunesModel::meterMoreThan(Tune *tune1, Tune *tune2)
{
    return (tune2->meter() < tune1->meter());
}

void TunesModel::sortByAuthor(bool forward)
{
    if (forward)
        std::sort(m_tunesDisplayed.begin(), m_tunesDisplayed.end(), authorLessThan);
    else
        std::sort(m_tunesDisplayed.begin(), m_tunesDisplayed.end(), authorMoreThan);
}

bool TunesModel::authorLessThan(Tune *tune1, Tune *tune2)
{
    return (tune1->author() < tune2->author());
}

bool TunesModel::authorMoreThan(Tune *tune1, Tune *tune2)
{
    return (tune2->author() < tune1->author());
}

void TunesModel::sortByType(bool forward)
{
    if (forward)
        std::sort(m_tunesDisplayed.begin(), m_tunesDisplayed.end(), typeLessThan);
    else
        std::sort(m_tunesDisplayed.begin(), m_tunesDisplayed.end(), typeMoreThan);
}

bool TunesModel::typeLessThan(Tune *tune1, Tune *tune2)
{
    return (tune1->type() < tune2->type());
}

bool TunesModel::typeMoreThan(Tune *tune1, Tune *tune2)
{
    return (tune2->type() < tune1->type());
}

// Return false if the filter removes the tune, true if the tune passes the filter.
bool TunesModel::putTuneThroughFilter(Tune *tune)
{
    bool filterize = false;
    if (m_filter)
    {
        switch (m_filter)
        {
        case Title:
            if (tune->title().contains(m_filterExpression, Qt::CaseInsensitive)) filterize = true;
            break;
        case Author:
            if (tune->author().contains(m_filterExpression, Qt::CaseInsensitive)) filterize = true;
            break;
        case Type:
            if (tune->type().contains(m_filterExpression, Qt::CaseInsensitive)) filterize = true;
            break;
        case Meter:
            if (tune->meter().contains(m_filterExpression, Qt::CaseInsensitive)) filterize = true;
            break;
        case Notes:
            if (tune->notes().contains(m_filterExpression, Qt::CaseInsensitive)) filterize = true;
            break;
        default:
            break;
        }
    }
    return filterize;
}
