#ifndef TUNESVGGRNDR_H
#define TUNESVGGRNDR_H

#include <QObject>

class TuneSVGGrndr : public QObject
{
    Q_OBJECT
public:
    explicit TuneSVGGrndr(QObject *parent = 0);

    Q_INVOKABLE QString getSvgPath(QString fileName);
signals:

public slots:
};

#endif // TUNESVGGRNDR_H
