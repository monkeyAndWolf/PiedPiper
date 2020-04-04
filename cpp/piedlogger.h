#ifndef PIEDLOGGER_H
#define PIEDLOGGER_H

#include <QObject>

class QFile;

class PiedLogger : public QObject
{
    Q_OBJECT
public:
    explicit PiedLogger(QString tuneHomeDir, QObject *parent = 0);
    ~PiedLogger();

    Q_INVOKABLE QString getAllLogs();

signals:

public slots:
    void logMessage(QString message);
    void logTuneOpen(QString tuneName);
    void logTuneImport(QString tuneImport);
    void logTuneDelete(QString tuneDeleted);

private:
    QString m_tuneHomeDir;
};

#endif // PIEDLOGGER_H
