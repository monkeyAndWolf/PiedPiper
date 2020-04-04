import QtQuick 2.0

Item {
    property alias label: labelText.text;
    property alias text: titleText.text;
    property alias labelWidth: labelText.width;
    property alias textWidth: titleText.width;
    property string nameOfFile: "NOT SET";
    property string value: "DANGER!";
    property bool live: false;
    property bool editable: false;
    property int lines: 1
    property int boxWidth: 1

    height: titleText.height
    Text {
        id: labelText
        text: qsTr("Title:");
        width: 50
    }
    Rectangle {
        color: (editable ? "white": "grey");
        border.color: "black"
        x: labelText.width
        width: titleText.width
        height: titleText.height
        TextEdit{
            anchors.centerIn: parent
            width: 250 * boxWidth;
            wrapMode: TextEdit.Wrap
            id: titleText;
            text: "haha";
            height: (font.pixelSize * lines > contentHeight) ? font.pixelSize * lines : contentHeight;
            onTextChanged: {
                if (live && editable) {
                    settingsAccess.setValue(nameOfFile, value, text);
                }
            }
            onFocusChanged: {
                if (focus) {
                    live = true;
                }
            }
        }
    }
}
