#ifndef SETBUILDERTUNEMODEL_H
#define SETBUILDERTUNEMODEL_H

#include <QAbstractListModel>
#include <QObject>

/**
 * @brief The SetBuilderTuneModel class
 * OK, so the idea here is to allow the TuneModel to be filtered
 * while it's in the SetBuilderView, without skronking up the
 * actual TuneModel used elsewhere. This class needs to be using
 * the TuneModel, and it needs to listen to the signals sent when
 * moar data is added, and it needs to filter out the tunes which
 * are in the currently selected set. COOL HUH?
 */
class SetBuilderTuneModel : public QAbstractListModel
{
    Q_OBJECT
public:
    SetBuilderTuneModel();
};

#endif // SETBUILDERTUNEMODEL_H
