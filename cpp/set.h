#ifndef SET_H
#define SET_H

#include <QObject>
#include <QStringList>

class Set : public QObject, public QStringList
{
    Q_OBJECT

    Q_PROPERTY(QString setName READ setName WRITE setSetName NOTIFY setNameChanged)
public:
    explicit Set();

    QString setName();

    QString toString();
signals:
    void setNameChanged(QString setNameThatWasSet);

public slots:
    void setSetName(QString setNameToSet);

private:
    QString m_setName;

};

#endif // SET_H
