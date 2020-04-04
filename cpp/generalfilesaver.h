#ifndef GENERALFILESAVER_H
#define GENERALFILESAVER_H

#include <QObject>

class QQuickPaintedItem;

class GeneralFileSaver : public QObject
{
    Q_OBJECT
public:
    explicit GeneralFileSaver(QString directory, QObject *parent = 0);

signals:

public slots:
    void saveImage(QQuickPaintedItem *item);
    void saveTextFile(QString text);

private:
    QString m_directory;
};

#endif // GENERALFILESAVER_H
