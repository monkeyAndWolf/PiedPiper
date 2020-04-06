import QtQuick 2.0
import QtQuick.Controls 2.1

Loader {
    anchors.fill: parent
    source: styles.narrow ? "NarrowSetBuilder.qml" : "WideSetBuilder.qml"
}

