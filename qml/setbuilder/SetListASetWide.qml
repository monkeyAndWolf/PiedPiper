import QtQuick 2.0

Item {

    id: mom

    property var setTunes
    property bool setSet: false

    function openASet(setName) {
        setSet = true
        setTunes = setModel.getSetTunes(setName)

        var ttt = setName + qsTr("(") + setModel.getSetLength(setName) + qsTr(" tunes)")
        texter.text = ttt
    }

    Item {
        id: topYee
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50

        Text {
            id: texter
            anchors.centerIn: parent
        }
    }

    ListView {
        clip: true
        anchors.top: topYee.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 2

        delegate: Rectangle {
            border.color: "black"; border.width: 2
            width: parent.width
            height: 50
            color: styles.sideMenuButtonUp
            radius: 10
            Column {
                anchors.fill: parent
                spacing: 2
                anchors.margins: 2
                property string content: content
                Text {
                    id: tit
                    text: tuneModel.getValue(setTunes[index], "title")
                    font.bold: true
                    wrapMode: Text.WordWrap
                }
                Text {
                    id: met
                    text: tuneModel.getValue(setTunes[index], "meter")
                }
            }

        }

        model: setTunes
    }


}
