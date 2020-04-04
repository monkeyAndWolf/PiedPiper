#include "piedlogger.h"

#include <QDateTime>
#include <QDir>
#include <QFile>
#include <QTextStream>

#define DO_LOG_PLEASE

PiedLogger::PiedLogger(QString tuneHomeDir, QObject *parent) : QObject(parent)
{
#ifndef DO_LOG_PLEASE
    m_tuneHomeDir = tuneHomeDir;
#endif
}

PiedLogger::~PiedLogger()
{
}

void PiedLogger::logMessage(QString message)
{
#ifndef DO_LOG_PLEASE
    QString fileName = m_tuneHomeDir.append(QDir::separator()).append("loggs").append(QDateTime::currentDateTime().toString("yymmhh")).append(".txt");
    QString lol = QDateTime::currentDateTime().toString("yyyy-mm-dd-hh:mm");
    message.prepend(" ").prepend(lol);
    message.prepend("\n");
    QFile logFile(fileName);
    if (logFile.open(QIODevice::Append))
    {
        QTextStream stream(&logFile);
        stream << message;
        logFile.close();
    }
#endif

}

void PiedLogger::logTuneOpen(QString tuneName)
{
#ifndef DO_LOG_PLEASE
    tuneName.prepend("Opened tune ");
    logMessage(tuneName);
#endif
}

void PiedLogger::logTuneImport(QString tuneImport)
{
#ifndef DO_LOG_PLEASE
    tuneImport.prepend("Imported tune ");
    logMessage(tuneImport);
#endif
}

void PiedLogger::logTuneDelete(QString tuneDeleted)
{
#ifndef DO_LOG_PLEASE
    tuneDeleted.prepend("Deleted tune ");
    logMessage(tuneDeleted);
#endif
}

QString PiedLogger::getAllLogs()
{
    QString logz = "TODO";
    return logz;
}
