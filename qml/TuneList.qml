import PiedPiper 1.0
import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {

    id: root

    property alias model: lister.model
    property alias delegate: lister.delegate
    property alias spacing: lister.spacing
    property alias show: lister.show

    Rectangle {
        id: filter
        x: 0
        y: 5
        z: 2
        height: 30;
        width: parent.width
        color: "#FFD700"
        radius: 5
        border.color: "black"
        border.width: 1
        clip: true

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 5
            width: parent.width - 10
            height: 20
            radius: parent.radius
            color: "transparent"

            Rectangle {
                border.color: "black"
                border.width: 1
                color: "#FFD999"
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left

                width: parent.width - height


                radius: parent.radius
                Text {
                    anchors.centerIn: parent
                    text: qsTr("Search")
                    visible: input.text.length === 0 && !input.focus
                }
                TextInput {
                    opacity: 1
                    id: input
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    width: parent.width - 4
                    onTextChanged: {
                        root.runSearch()
                    }
                }
            }
            Rectangle {
                height: parent.height
                width: height
                border.color: "black"
                border.width: 1
                anchors.right: parent.right
                radius: parent.radius

                MagicTriangle {
                    anchors.fill: parent
                    id: triangle
                    fillStyle: "#FFD999"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (30 === filter.height) {
                                filter.height = 60
                                triangle.down = false
                            }
                            else {
                                filter.height = 30
                                triangle.down = true
                            }
                        }
                    }
                }

            }
        }

        Rectangle {
            id: extraSearchFields
            color: "transparent"
            width: parent.width
            y: 30; x: 0
            height: 30
            property var searchMode: TunesModel.Title
            ComboBox {
                height: parent.height
                width: parent.width - 4
                anchors.centerIn: parent
                model: [ qsTr("Title"), qsTr("Author"), qsTr("Type"), qsTr("Meter"), qsTr("Notes") ]
                onCurrentIndexChanged: {
                    switch (currentIndex) {
                    case 0:
                        extraSearchFields.searchMode = TunesModel.Title
                        break;
                    case 1:
                        extraSearchFields.searchMode = TunesModel.Author
                        break;
                    case 2:
                        extraSearchFields.searchMode = TunesModel.Type
                        break;
                    case 3:
                        extraSearchFields.searchMode = TunesModel.Meter
                        break;
                    case 4:
                        extraSearchFields.searchMode = TunesModel.Notes
                        break;
                    default:
                        extraSearchFields.searchMode = TunesModel.Title
                        break;
                    }
                    root.runSearch()
                }
            }
        }
    }


    function runSearch() {
        var text = input.text
        if (text.length > 0)
            tuneModel.filter(extraSearchFields.searchMode, text)
        else
            tuneModel.clearFilter()
    }

    ListView {
        id: lister
        x: 0;
        z: 1
        y: 5 + filter.height;
        height: parent.height-5 - filter.height;
        width: parent.width;
        property bool show: true
//        clip: true
    }

    states: [
        State {
            name: "hidden"
        },
        State {
            name: "displayed"
            when: root.show
            PropertyChanges {
                target: root
                x: 0
            }
        }
    ]

    transitions: Transition {
        from: "displayed"
        to: ""
        reversible: true

        NumberAnimation {
            target: root
            property: "x"
            duration: 1000
            easing.type: Easing.OutQuad
        }
    }
}

