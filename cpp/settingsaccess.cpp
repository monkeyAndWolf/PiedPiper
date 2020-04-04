#include "settingsaccess.h"

#include "tunesmodel.h"

#include <QDebug>

SettingsAccess::SettingsAccess(TunesModel *model) : QObject(model)
{
    m_model = model;
}

QVariant SettingsAccess::getValue(QString filename, QString key)
{
    return m_model->getValue(filename, key);
}

void SettingsAccess::setValue(QString filename, QString key, QVariant value)
{
    m_model->setValue(filename, key, value);
}

