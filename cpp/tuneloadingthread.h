#ifndef TUNELOADINGTHREAD_H
#define TUNELOADINGTHREAD_H

#include "tunesmodel.h"

#include <QFileInfoList>
#include <QObject>
#include <QThread>

class TuneLoadingThread : public QThread
{
    Q_OBJECT
public:
    explicit TuneLoadingThread(QFileInfoList fil, TunesModel *model, QObject *parent = 0);
    virtual ~TuneLoadingThread();

protected:
    virtual void run();

private:
    QFileInfoList fileIList;
    TunesModel *tuneModel;
};

#endif // TUNELOADINGTHREAD_H
