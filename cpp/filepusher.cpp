#include "filepusher.h"

FilePusher::FilePusher(QObject *parent) : QObject(parent)
{

}

void FilePusher::pushFile(QString filename)
{
    emit filePushed(filename);
}

void FilePusher::deleteFile(QString filename)
{
    emit fileDeleteRequested(filename);
}
