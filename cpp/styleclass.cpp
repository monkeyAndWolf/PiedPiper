#include "styleclass.h"

StyleClass::StyleClass(QObject *parent) : QObject(parent)
{
    m_sideMenuButtonUp = "#009900";
    m_sideMenuButtonDown = "#006600";
    m_sideMenuBackground = "#FFFFC2";
    m_topMenuButtonUp = "#009900";
    m_topMenuButtonDown = "#006600";
    m_topMenuBackground = "#FFEFA0";
    m_mainScreenBackground = "#FFFFC2";

}

void StyleClass::setNarrow(bool newLike)
{
    if (newLike != m_narrow)
    {
        m_narrow = newLike;
        emit narrowChanged(newLike);
    }
}
