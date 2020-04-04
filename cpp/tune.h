#ifndef TUNE_H
#define TUNE_H

#include <QFileInfo>
#include <QObject>
#include <QVariant>

class Tune : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString title READ title)
    Q_PROPERTY(QString meter READ meter)
    Q_PROPERTY(QString author READ author)
    Q_PROPERTY(QVariant content READ content)
    Q_PROPERTY(QString type READ type)
    Q_PROPERTY(int fileType READ fileType)
    Q_PROPERTY(QString filename READ filename)
    Q_PROPERTY(bool editable READ editable)
    Q_PROPERTY(QString notes READ notes)

public:

    enum Role {
        Title = 2,
        Meter,
        Author,
        Content,
        Type,
        FileType,
        Filename,
        IsEditable,
        Notes
    };

    enum Type {
        Duff = 0,
        Abc = 1,
        Image = 2,
        Pdf = 3
    };

    Q_ENUMS(Role)
    Q_ENUMS(Type)

    // Default constructor. It's here so that QML can use the enums. Srsly.
    explicit Tune() {}
    explicit Tune(QFileInfo fileInfo, QObject *parent = 0);

    QVariant getValue(int role);
    bool setValue(QVariant value, int role);

    QString title() { return m_title; }
    QString meter() { return m_meter; }
    QString author() { return m_author; }
    QVariant content() { return m_content; }
    QString type() { return m_type; }
    int fileType() { return m_fileType; }
    QString filename() { return m_filename; }
    bool editable() { return m_editable; }
    QString notes() { return m_notes; }

signals:

public slots:

private:
    QString     m_title;
    QString     m_meter;
    QString     m_author;
    QVariant    m_content;
    QString     m_type;
    int         m_fileType;
    QString     m_filename;
    // NOTE: editable refers to the editable persistent settings, not the
    // files themselves. So while ABC files can be edited, the settings for
    // them currently can not. Whereas Images and PDFs aren't so easy to
    // edit, but the settings are editable. Simple, huh?
    bool        m_editable;
    QString     m_notes;

    void loadAbc(QString file);
    void loadImage(QString file);
    void loadPdf(QString file);

    bool isImage(QString suffix);

};

#endif // TUNE_H
