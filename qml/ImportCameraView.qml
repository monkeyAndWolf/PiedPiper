import QtQuick 2.0
import QtMultimedia 5.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

Rectangle {
    color: styles.mainScreenBackground

    signal newImageTakenPleaseEdit(var path);

    Stack.onStatusChanged: {
        if (Stack.status === Stack.Inactive) {
            camera.stop()
        }
    }

    Camera {
        id: camera

        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }

        imageCapture {
            onImageSaved: {
                newImageTakenPleaseEdit(path)
            }
        }

        flash.mode: Camera.FlashRedEyeReduction

    }

    ColumnLayout {

        Rectangle {
            id: buttonHolder
            height: shoot.height
            width: parent.width
            RowLayout {
                Button {
                    id: shoot
                    property string rightText: qsTr("Take Picture");
                    text: rightText
                    property bool running: false
                    onClicked: {
                        camera.imageCapture.captureToLocation(tuneDir)
                    }
                }
                Button {
                    visible: QtMultimedia.availableCameras.length > 1
                    text: "Switch Camera"
                    property int currentCamera: 0
                    onClicked: {
                        if (currentCamera === 0) {
                            camera.position = Camera.FrontFace
                            currentCamera = 1
                        }
                        else {
                            camera.position = Camera.BackFace
                            currentCamera = 0
                        }

                    }
                }
            }

        }
        VideoOutput {
            source: camera
            focus : visible // to receive focus and capture key events when visible
            anchors.top: buttonHolder.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }

    }

}
