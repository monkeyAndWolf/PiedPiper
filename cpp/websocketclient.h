#ifndef WEBSOCKETCLIENT_H
#define WEBSOCKETCLIENT_H

#include <QObject>

class WebSocketClient : public QObject
{
    Q_OBJECT
public:
    explicit WebSocketClient(QObject *parent = 0);

signals:
    void clientConnected();
    void clientDisconnected();
    void clientConnectFailed();

public slots:
    void connectPlz(QString address);
};

#endif // WEBSOCKETCLIENT_H
