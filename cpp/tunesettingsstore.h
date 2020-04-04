#ifndef TUNESETTINGSSTORE_H
#define TUNESETTINGSSTORE_H

#include <QVariant>

class QSettings;

class TuneSettingsStore
{
public:
    TuneSettingsStore(QString directory);
    virtual ~TuneSettingsStore();

public:
    void setValue(QString filename, QString key, QVariant value);
    QVariant getValue(QString filename, QString key);
    void deleteValue(QString filename, QString key);

private:
    QSettings *m_settings;
    QString mashKey(QString filename, QString key);
};

#endif // TUNESETTINGSSTORE_H
