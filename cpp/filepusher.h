#ifndef FILEPUSHER_H
#define FILEPUSHER_H

#include <QObject>

/**
 * @brief The FilePusher class
 *
 * This class exists because for reasons unknown, the QML runtime
 * doesnae recognize the TunesModel as being a TunesModel, but
 * only as the QAbstractListModel superclass. Thanks, Obama.
 */
class FilePusher : public QObject
{
    Q_OBJECT
public:
    explicit FilePusher(QObject *parent = 0);

signals:
    void filePushed(QString filename);
    void fileDeleteRequested(QString filename);

public slots:
    void pushFile(QString filename);
    void deleteFile(QString filename);

};

#endif // FILEPUSHER_H
