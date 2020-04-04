#include "tunesvggrndr.h"

#include <abcshots.h>

#include <QDateTime>
#include <QDebug>
#include <QFileInfo>
#include <QString>

TuneSVGGrndr::TuneSVGGrndr(QObject *parent) : QObject(parent)
{

}

QString TuneSVGGrndr::getSvgPath(QString fileName)
{
    QString outFile = fileName.left(fileName.length() - (fileName.length()-fileName.lastIndexOf(".")));
    outFile.append(".svg");

    QFileInfo abcFileInfo(fileName);
    QFileInfo svgFileInfo(outFile);

    // Update all SVG files older than the latest update to the renderer.
    QDateTime updatePoint(QDate(2016,10,25),QTime(0,0,1));
    // This value should be updated whenever there is a new version of ABCShots added to the renderizer.

    if (!svgFileInfo.exists())
    {
        runAbcToBigSvg(fileName.toLatin1().data(), outFile.toLatin1().data());
    }
    else if (svgFileInfo.lastModified().currentMSecsSinceEpoch() < abcFileInfo.lastModified().currentMSecsSinceEpoch())
    {
        if (svgFileInfo.lastModified() < updatePoint)
        // There is no svg file, or if there is, it is older than the ABC file.
            runAbcToBigSvg(fileName.toLatin1().data(), outFile.toLatin1().data());
    }
    return outFile;
}
