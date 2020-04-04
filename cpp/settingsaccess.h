#ifndef SETTINGSACCESS_H
#define SETTINGSACCESS_H

#include <QObject>
#include <QVariant>

class TunesModel;

class SettingsAccess : public QObject
{
    Q_OBJECT
public:
    explicit SettingsAccess(TunesModel *model);

    Q_INVOKABLE QVariant getValue(QString filename, QString key);

signals:

public slots:

    void setValue(QString filename, QString key, QVariant value);

private:
    TunesModel *m_model;
};

#endif // SETTINGSACCESS_H
