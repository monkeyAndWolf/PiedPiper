#include "tune.h"

#include <QDebug>
#include <QFileInfo>
#include <QImage>
#include <QVariant>

Tune::Tune(QFileInfo fileInfo, QObject *parent) : QObject(parent)
  , m_editable(false)
{
    m_filename = fileInfo.absoluteFilePath();

    if ("abc" == fileInfo.suffix())
        loadAbc(m_filename);
    else if ("pdf" == fileInfo.suffix())
        loadPdf(m_filename);
    else if (isImage(fileInfo.suffix()))
        loadImage(m_filename);
    // It seems rather rum to pass a member variable around.

}


QVariant Tune::getValue(int role)
{
    QVariant v;
    switch (role) {
    case Tune::Title:
        v = m_title;
        break;
    case Tune::Meter:
        v = m_meter;
        break;
    case Tune::Author:
        v = m_author;
        break;
    case Tune::Content:
        v = m_content;
        break;
    case Tune::Type:
        v = m_type;
        break;
    case Tune::FileType:
        v = m_fileType;
        break;
    case Tune::Filename:
        v = m_filename;
        break;
    case Tune::Notes:
        v = m_notes;
        break;
    case Tune::IsEditable:
        v = m_editable;
    default:
        break;
    }
    return v;
}

bool Tune::setValue(QVariant value, int role)
{
    bool ticket = false;
    switch (role) {
    case Tune::Title:
        m_title = value.toString();
        ticket = true;
        break;
    case Tune::Meter:
        m_meter = value.toString();
        ticket = true;
        break;
    case Tune::Author:
        m_author = value.toString();
        ticket = true;
        break;
    case Tune::Type:
        m_type = value.toString();
        ticket = true;
        break;
    case Tune::Notes:
        m_notes = value.toString();
        // Can not be changed
//    case Tune::Content:
//        m_content = value;
//        ticket = true;
//        break;
//    case Tune::Filename:
//        m_filename = value.toString();
//        ticket = true;
//        break;
    default:
        break;
    }
    return ticket;
}


bool Tune::isImage(QString suffix)
{
    return ("png" == suffix || "jpg" == suffix);
}


void Tune::loadAbc(QString file)
{
    QFile abc(file);

    if (abc.open(QIODevice::ReadOnly))
    {
        // m_content is basically the entire file for,
        // line, abc files.
        QString content = abc.readAll().trimmed();
        if (content.contains("'"))
        {
            content = content.replace("\'", "\\'");
        }
        m_fileType = Tune::Abc;
        QStringList lines = content.split("\n");

        m_author = tr("Traditional");
        foreach (QString line, lines)
        {
            line = line.trimmed();

            if (line.startsWith("T")) {
                m_title = line.right((line.length()-2)).trimmed();
                m_title = m_title.replace("\\'", "\'");
            }
            else if (line.startsWith("M"))
                m_meter = line.right((line.length()-2)).trimmed();
            else if (line.startsWith("R"))
                m_type = line.right((line.length()-2)).trimmed();
            else if (line.startsWith("C"))
                m_author = line.right((line.length()-2)).trimmed();
        }
        content = content.replace("\r\n", "\\n");
        content = content.replace("\r", "\\n");
        content = content.replace("\n", "\\n");
        m_content = content;

        // There is a good chance that these will already be there, but hey.
    }
    else m_fileType = Tune::Duff;
}


void Tune::loadImage(QString file)
{
    QFileInfo f(file);
    if (f.exists())
    {
        m_editable = true;
        m_type = Tune::Image;
        if (m_title.isNull()) m_title = f.fileName();
        if (m_meter.isNull()) m_meter = "";
        if (m_author.isNull()) m_author = "";
        m_fileType = Tune::Image;
    }
    else
    {
        m_fileType = Tune::Duff;
    }
}


void Tune::loadPdf(QString file)
{
    m_fileType = Tune::Pdf;
    m_editable = true;
    Q_UNUSED(file)
}
