#include "tunesettingsstore.h"

#include <QDir>
#include <QSettings>

TuneSettingsStore::TuneSettingsStore(QString directory)
{
    directory += QDir::separator();
    directory += "piedpiper.ini";
    m_settings = new QSettings(directory, QSettings::IniFormat);
}

TuneSettingsStore::~TuneSettingsStore()
{
    m_settings->deleteLater();
}

QString TuneSettingsStore::mashKey(QString filename, QString key)
{
    return QString(filename + "M&W" + key);
}

void TuneSettingsStore::setValue(QString filename, QString key, QVariant value)
{
    QString keyed = mashKey(filename, key);
    m_settings->setValue(keyed, value);
    m_settings->sync();
}

QVariant TuneSettingsStore::getValue(QString filename, QString key)
{
    QString keyed = mashKey(filename, key);
    return m_settings->value(keyed);
}

void TuneSettingsStore::deleteValue(QString filename, QString key)
{
    QString keyed = mashKey(filename, key);
    m_settings->remove(keyed);
    m_settings->sync();
}
