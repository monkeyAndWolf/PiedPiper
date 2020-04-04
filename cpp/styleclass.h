#ifndef STYLECLASS_H
#define STYLECLASS_H

#include <QObject>

class StyleClass : public QObject
{
    Q_OBJECT
public:

    Q_PROPERTY(QString sideMenuButtonUp READ sideMenuButtonUp WRITE setSideMenuButtonUp NOTIFY sideMenuButtonUpChanged)
    Q_PROPERTY(QString sideMenuButtonDown READ sideMenuButtonDown WRITE setSideMenuButtonDown NOTIFY sideMenuButtonDownChanged)
    Q_PROPERTY(QString sideMenuBackground READ sideMenuBackground WRITE setSideMenuBackground NOTIFY sideMenuBackgroundChanged)
    Q_PROPERTY(QString topMenuButtonUp READ topMenuButtonUp WRITE setTopMenuButtonUp NOTIFY topMenuButtonUpChanged)
    Q_PROPERTY(QString topMenuButtonDown READ topMenuButtonDown WRITE setTopMenuButtonDown NOTIFY topMenuButtonDownChanged)
    Q_PROPERTY(QString topMenuBackground READ topMenuBackground WRITE setTopMenuBackground NOTIFY topMenuBackgroundChanged)
    Q_PROPERTY(QString mainScreenBackground READ mainScreenBackground WRITE setMainScreenBackground NOTIFY mainScreenBackgroundChanged)

    Q_PROPERTY(bool narrow READ narrow WRITE setNarrow NOTIFY narrowChanged)

    explicit StyleClass(QObject *parent = 0);

    QString sideMenuButtonUp() { return m_sideMenuButtonUp; }
    QString sideMenuButtonDown() { return m_sideMenuButtonDown; }
    QString sideMenuBackground() { return m_sideMenuBackground; }
    QString topMenuButtonUp() { return m_topMenuButtonUp; }
    QString topMenuButtonDown() { return m_topMenuButtonDown; }
    QString topMenuBackground() { return m_topMenuBackground; }
    QString mainScreenBackground() { return m_mainScreenBackground; }

    bool narrow() { return m_narrow; }

signals:
    void sideMenuButtonUpChanged(QString newLike);
    void sideMenuButtonDownChanged(QString newLike);
    void sideMenuBackgroundChanged(QString newLike);
    void topMenuButtonUpChanged(QString newLike);
    void topMenuButtonDownChanged(QString newLike);
    void topMenuBackgroundChanged(QString newLike);
    void mainScreenBackgroundChanged(QString newLike);

    void narrowChanged(bool newLike);

public slots:
    void setSideMenuButtonUp(QString newLike) { m_sideMenuButtonUp = newLike; emit sideMenuButtonUpChanged(newLike); }
    void setSideMenuButtonDown(QString newLike) { m_sideMenuButtonDown = newLike; emit sideMenuButtonDownChanged(newLike);}
    void setSideMenuBackground(QString newLike) { m_sideMenuBackground = newLike; emit sideMenuBackgroundChanged(newLike); }
    void setTopMenuButtonUp(QString newLike) { m_topMenuButtonUp = newLike; emit topMenuButtonUpChanged(newLike); }
    void setTopMenuButtonDown(QString newLike) { m_topMenuButtonDown = newLike; emit topMenuButtonDownChanged(newLike); }
    void setTopMenuBackground(QString newLike) { m_topMenuBackground = newLike; emit topMenuBackgroundChanged(newLike); }
    void setMainScreenBackground(QString newLike) { m_mainScreenBackground = newLike; emit mainScreenBackgroundChanged(newLike); }

    void setNarrow(bool newLike);

private:
    QString m_sideMenuButtonUp;
    QString m_sideMenuButtonDown;
    QString m_sideMenuBackground;
    QString m_topMenuButtonUp;
    QString m_topMenuButtonDown;
    QString m_topMenuBackground;
    QString m_mainScreenBackground;

    bool    m_narrow;
};

#endif // STYLECLASS_H
