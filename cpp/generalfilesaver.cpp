#include "generalfilesaver.h"

#include <QDateTime>
#include <QDir>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QPixmap>

#include <QDebug>

GeneralFileSaver::GeneralFileSaver(QString directory, QObject *parent) : QObject(parent)
{
    m_directory = directory;
}

void GeneralFileSaver::saveImage(QQuickPaintedItem *item)
{
    if (item != 0)
    {
        QPixmap pix(item->width(), item->height());
        QPainter painter(&pix);
        item->paint(&painter);
        QString filename = m_directory + QDir::separator() +  QDateTime::currentDateTime().toString() + ".jpg";
        pix.save(filename);
    }
}


void GeneralFileSaver::saveTextFile(QString text)
{

}
