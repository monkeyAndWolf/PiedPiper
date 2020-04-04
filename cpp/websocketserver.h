#ifndef WEBSOCKETSERVER_H
#define WEBSOCKETSERVER_H


#include <QWebSocketCorsAuthenticator>
#include <QSslPreSharedKeyAuthenticator>
#include <QObject>
#include <QSslError>
#include <QWebSocketServer>

class WebSocketServer : public QObject
{
    Q_OBJECT
public:
    explicit WebSocketServer(QObject *parent = 0);
    virtual ~WebSocketServer();

    Q_INVOKABLE QList<int> listConnectedClients();

signals:
    void socketOpen(QString myAddress);
    void socketClosed();
    void socketStymied();
    void clientConnected(int howManyClientsThereAreNow);
    void clientClosed();
    void clientVanished();

public slots:
    void openTheSocket(quint16 socketNumber = 3468);
    void closeTheSocket();
    void writeMessageToSocket(QString message, int clientNumber = 0);

private slots:
    void	onAcceptError(QAbstractSocket::SocketError socketError);
    void	onClosed();
    void	onNewConnection();
    void	onOriginAuthenticationRequired(QWebSocketCorsAuthenticator *authenticator);
    void	onPeerVerifyError(const QSslError &error);
    void	onPreSharedKeyAuthenticationRequired(QSslPreSharedKeyAuthenticator *authenticator);
    void	onServerError(QWebSocketProtocol::CloseCode closeCode);
    void	onSslErrors(const QList<QSslError> &errors);

private:
    // Need to list the clients in a better way I guess?
    QList<QObject*> m_connectedClients;
    QWebSocketServer *m_webSocketServer;

};

#endif // WEBSOCKETSERVER_H
