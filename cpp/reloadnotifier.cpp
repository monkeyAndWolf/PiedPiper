#include "reloadnotifier.h"
#include "ppqmlreloadingengine.h"

#include <QDir>
#include <QFileInfo>

ReloadNotifier::ReloadNotifier(PPQmlReloadingEngine *engine, QObject *parent) : QObject(parent)
  , m_engine(engine)
{
    QString initialFilepath = QDir::homePath() + QDir::separator() +  "/code/VxReloadingUI/start.qml";
    m_filepath = initialFilepath;
}

QString ReloadNotifier::filepath()
{
    return "file://" + m_filepath;
}

void ReloadNotifier::setFilepath(QString filepath)
{
    m_filepath = filepath;
    emit filepathChanged(m_filepath);
}

void ReloadNotifier::trimCache()
{
    m_engine->clearComponentCache();
}
