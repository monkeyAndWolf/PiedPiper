#include "set.h"

Set::Set()
{

}

void Set::setSetName(QString setNameToSet)
{
    if (setNameToSet != m_setName)
    {
        m_setName = setNameToSet;
        emit setNameChanged(m_setName);
    }
}

QString Set::setName()
{
    return m_setName;
}

QString Set::toString()
{
    QString string(m_setName);
    for (int i = 0; i < this->length(); i++)
    {
        string.append("∆");
        string.append(this->at(i));
    }
    return string;
}
