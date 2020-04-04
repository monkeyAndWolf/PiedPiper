#include "websocketserver.h"

#include <QNetworkInterface>
#include <QWebSocketServer>


WebSocketServer::WebSocketServer(QObject *parent) : QObject(parent)
  , m_webSocketServer(0)
{

}

WebSocketServer::~WebSocketServer()
{
    closeTheSocket();
}

QList<int> WebSocketServer::listConnectedClients()
{
    QList<int> list;
    return list;
}

void WebSocketServer::openTheSocket(quint16 socketNumber)
{
    if (m_webSocketServer)
    {
        if (!m_webSocketServer->isListening())
        {
            m_webSocketServer->listen(QHostAddress::Any, socketNumber);
        }
    }
    else if (!m_webSocketServer)
    {
        // TODO should the server be secure? It's not carrying top secret information, so rilly??
        m_webSocketServer = new QWebSocketServer(QString::fromLatin1("PiedPiper"), QWebSocketServer::NonSecureMode);
        connect(m_webSocketServer, &QWebSocketServer::acceptError, this, &WebSocketServer::onAcceptError);
        connect(m_webSocketServer, &QWebSocketServer::closed, this, &WebSocketServer::onClosed);
        connect(m_webSocketServer, &QWebSocketServer::newConnection, this, &WebSocketServer::onNewConnection);
        connect(m_webSocketServer, &QWebSocketServer::originAuthenticationRequired, this, &WebSocketServer::onOriginAuthenticationRequired);
        connect(m_webSocketServer, &QWebSocketServer::peerVerifyError, this, &WebSocketServer::onPeerVerifyError);
        connect(m_webSocketServer, &QWebSocketServer::preSharedKeyAuthenticationRequired, this, &WebSocketServer::onPreSharedKeyAuthenticationRequired);
        connect(m_webSocketServer, &QWebSocketServer::serverError, this, &WebSocketServer::onServerError);
        connect(m_webSocketServer, &QWebSocketServer::sslErrors, this, &WebSocketServer::onSslErrors);

        m_webSocketServer->listen(QHostAddress::Any, socketNumber);

        QString address;
        QList<QHostAddress> addresses =  QNetworkInterface::allAddresses();
        foreach (QHostAddress intero, addresses)
        {
            if (!intero.isLoopback() && intero.protocol() == QAbstractSocket::IPv4Protocol)
                address += intero.toString()  + ":" + QString::number(socketNumber) + "  ";
        }

//       address =  m_webSocketServer->serverAddress().toString();

        emit socketOpen(address);
    }
}

void WebSocketServer::closeTheSocket()
{
    if (m_webSocketServer)
    {
        if (m_webSocketServer->isListening())
        {
            m_webSocketServer->close();
            emit socketClosed();
        }
        m_webSocketServer->deleteLater();
        m_webSocketServer = 0;
    }
}

void WebSocketServer::writeMessageToSocket(QString message, int clientNumber)
{

}

// Private internal parts
void WebSocketServer::onAcceptError(QAbstractSocket::SocketError socketError)
{

}

void WebSocketServer::onClosed()
{

}

void WebSocketServer::onNewConnection()
{

}

void WebSocketServer::onOriginAuthenticationRequired(QWebSocketCorsAuthenticator *authenticator)
{

}

void WebSocketServer::onPeerVerifyError(const QSslError &error)
{

}

void WebSocketServer::onPreSharedKeyAuthenticationRequired(QSslPreSharedKeyAuthenticator *authenticator)
{

}

void WebSocketServer::onServerError(QWebSocketProtocol::CloseCode closeCode)
{

}

void WebSocketServer::onSslErrors(const QList<QSslError> &errors)
{

}

