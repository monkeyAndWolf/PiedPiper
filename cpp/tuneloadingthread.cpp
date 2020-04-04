#include "tuneloadingthread.h"

#include <QDebug>
TuneLoadingThread::TuneLoadingThread(QFileInfoList fil, TunesModel *model, QObject *parent) : QThread(parent)
  , tuneModel(model)
{
    fileIList = fil;
}

TuneLoadingThread::~TuneLoadingThread()
{

}

void TuneLoadingThread::run()
{
#ifdef CUPERTINO_BABY
    if (fileIList.length() < 1)
        return;
#endif
    tuneModel->addFiles(fileIList);
}
