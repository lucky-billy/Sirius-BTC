import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtBluetooth 5.2

Rectangle {
    id: root
    visible: true
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

    property bool isChinese: true                               // 中文或英文
    property bool serviceFound: false                           // 蓝牙是否连接成功
    property string remoteDeviceName: ""                        // 蓝牙设备名称
    property var pixel: Screen.desktopAvailableHeight / 840     // 像素标定值

    Component.onCompleted: {
        dialog.visible = false
        btModel.running = true
    }

    // 背景
    Image {
        anchors.fill: parent
        source: "qrc:/image/bg.png"
        enabled: !btModel.running && !dialog.visible

        // logo
        Image {
            x: 20*pixel; y: 20*pixel
            width: 240*pixel; height: 80*pixel
            source: "qrc:/image/logo.png"
        }

        // 调焦
        Image {
            width: root.isChinese ? 125*pixel : 165*pixel; height: 58*pixel
            anchors.top: parent.top
            anchors.topMargin: 150*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            source: root.isChinese ? "qrc:/image/focus-c.png" : "qrc:/image/focus-e.png"
        }

        // 调焦按钮组
        Rectangle {
            width: 330*pixel; height: 60*pixel
            anchors.top: parent.top
            anchors.topMargin: 210*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"

            // 调焦左旋钮
            Image {
                id: focus_left
                width: 160*pixel; height: 60*pixel
                anchors.top: parent.top
                anchors.left: parent.left
                source: "qrc:/image/down-default.png"

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        focus_left.source = "qrc:/image/down-pressed.png"
                        socket.stringData = "1"
                    }
                    onReleased: {
                        focus_left.source = "qrc:/image/down-default.png"
                        socket.stringData = "2"
                    }
                }
            }

            // 调焦右旋钮
            Image {
                id: focus_right
                width: 160*pixel; height: 60*pixel
                anchors.top: parent.top
                anchors.right: parent.right
                source: "qrc:/image/up-default.png"

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        focus_right.source = "qrc:/image/up-pressed.png"
                        socket.stringData = "3"
                    }
                    onReleased: {
                        focus_right.source = "qrc:/image/up-default.png"
                        socket.stringData = "4"
                    }
                }
            }
        }

        // 变倍
        Image {
            width: root.isChinese ? 126*pixel : 161*pixel; height: 58*pixel
            anchors.top: parent.top
            anchors.topMargin: 310*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            source: root.isChinese ? "qrc:/image/zoom-c.png" : "qrc:/image/zoom-e.png"
        }

        // 变倍按钮组
        Rectangle {
            width: 330*pixel; height: 60*pixel
            anchors.top: parent.top
            anchors.topMargin: 370*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"

            // 变倍左旋钮
            Image {
                id: zoom_left
                width: 160*pixel; height: 60*pixel
                anchors.top: parent.top
                anchors.left: parent.left
                source: "qrc:/image/down-default.png"

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        zoom_left.source = "qrc:/image/down-pressed.png"
                        socket.stringData = "5"
                    }
                    onReleased: {
                        zoom_left.source = "qrc:/image/down-default.png"
                        socket.stringData = "6"
                    }
                }
            }

            // 变倍右旋钮
            Image {
                id: zoom_right
                width: 160*pixel; height: 60*pixel
                anchors.top: parent.top
                anchors.right: parent.right
                source: "qrc:/image/up-default.png"

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        zoom_right.source = "qrc:/image/up-pressed.png"
                        socket.stringData = "7"
                    }
                    onReleased: {
                        zoom_right.source = "qrc:/image/up-default.png"
                        socket.stringData = "8"
                    }
                }
            }
        }

        // 对比度
        Image {
            id: contrast
            width: 200*pixel; height: 60*pixel
            anchors.top: parent.top
            anchors.topMargin: 500*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            source: root.isChinese ? "qrc:/image/contrast_c-default.png" : "qrc:/image/contrast_e-default.png"

            MouseArea {
                anchors.fill: parent
                onPressed: contrast.source = root.isChinese ? "qrc:/image/contrast_c-pressed.png" : "qrc:/image/contrast_e-pressed.png"
                onReleased: contrast.source = root.isChinese ? "qrc:/image/contrast_c-default.png" : "qrc:/image/contrast_e-default.png"
                onClicked: socket.stringData = "a"
            }
        }

        // 对准
        Image {
            id: align
            width: 200*pixel; height: 60*pixel
            anchors.top: parent.top
            anchors.topMargin: 600*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            source: root.isChinese ? "qrc:/image/align_c-default.png" : "qrc:/image/align_e-default.png"

            MouseArea {
                anchors.fill: parent
                onPressed: align.source = root.isChinese ? "qrc:/image/align_c-pressed.png" : "qrc:/image/align_e-pressed.png"
                onReleased: align.source = root.isChinese ? "qrc:/image/align_c-default.png" : "qrc:/image/align_e-default.png"
                onClicked: socket.stringData = "b"
            }
        }

        // 测量
        Image {
            id: measure
            width: 200*pixel; height: 60*pixel
            anchors.top: parent.top
            anchors.topMargin: 700*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            source: root.isChinese ? "qrc:/image/measure_c-default.png" : "qrc:/image/measure_e-default.png"

            MouseArea {
                anchors.fill: parent
                onPressed: measure.source = root.isChinese ? "qrc:/image/measure_c-pressed.png" : "qrc:/image/measure_e-pressed.png"
                onReleased: measure.source = root.isChinese ? "qrc:/image/measure_c-default.png" : "qrc:/image/measure_e-default.png"
                onClicked: socket.stringData = "c"
            }
        }

        // 蓝牙状态
        Image {
            width: 40*pixel; height: 40*pixel
            anchors.left: parent.left
            anchors.leftMargin: 20*pixel
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*pixel
            source: root.serviceFound ? "qrc:/image/bluetooth-ok.png" : "qrc:/image/bluetooth-notok.png"
        }

        // 语言
        Image {
            width: 50*pixel; height: 50*pixel
            anchors.right: parent.right
            anchors.rightMargin: 20*pixel
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*pixel
            source: root.isChinese ? "qrc:/image/english.png" : "qrc:/image/chinese.png"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.isChinese = !root.isChinese
                    contrast.source = root.isChinese ? "qrc:/image/contrast_c-default.png" : "qrc:/image/contrast_e-default.png"
                    align.source = root.isChinese ? "qrc:/image/align_c-default.png" : "qrc:/image/align_e-default.png"
                    measure.source = root.isChinese ? "qrc:/image/measure_c-default.png" : "qrc:/image/measure_e-default.png"
                }
            }
        }

    }

    //------------------------------------------------------------

    // 蓝牙扫描仪
    BluetoothDiscoveryModel {
        id: btModel
        discoveryMode: BluetoothDiscoveryModel.MinimalServiceDiscovery
        uuidFilter: "{00001101-0000-1000-8000-00805f9b34fb}"

        onRunningChanged : {
            if ( !btModel.running && !serviceFound ) {
                dialog.source = root.isChinese ? "qrc:/image/error_c_no-service.png" : "qrc:/image/error_e_no-service.png"
                dialog.visible = true
            }
        }

        onErrorChanged: {
            if ( !btModel.running && btModel.error != BluetoothDiscoveryModel.NoError ) {
                dialog.source = root.isChinese ? "qrc:/image/error_c_discovery-failed.png" : "qrc:/image/error_e_discovery-failed.png"
                dialog.visible = true
            }
        }

        onServiceDiscovered: {
            if (serviceFound) {
                return
            }

            console.log("BluetoothDiscoveryModel - Found new service - deviceAddress: " + service.deviceAddress + ", deviceAddress: " +
                        service.deviceName + ", serviceName: " + service.serviceName + ", serviceUuid: " + service.serviceUuid)

            if ( service.deviceAddress == "00:20:08:00:26:76" ) {
                console.log("BluetoothDiscoveryModel - service found !")
                serviceFound = true
                remoteDeviceName = service.deviceName
                socket.setService(service)
                console.log("BluetoothDiscoveryModel - connect to service successfully !")
            }
        }

        onDeviceDiscovered: console.log("BluetoothDiscoveryModel - New device: " + device)
    }

    // 蓝牙通信
    BluetoothSocket {
        id: socket
        connected: true

        onSocketStateChanged: {
            switch (socketState) {
            case BluetoothSocket.NoServiceSet: console.log("BluetoothSocket - NoServiceSet" ); break;
            case BluetoothSocket.Unconnected:
                console.log("BluetoothSocket - Unconnected" );
                dialog.source = root.isChinese ? "qrc:/image/error_c_disconnect.png" : "qrc:/image/error_e_disconnect.png"
                dialog.visible = true
                break;
            case BluetoothSocket.ServiceLookup: console.log("BluetoothSocket - ServiceLookup" ); break;
            case BluetoothSocket.Connecting: console.log("BluetoothSocket - Connecting" ); break;
            case BluetoothSocket.Connected: console.log("BluetoothSocket - Connected" ); break;
            case BluetoothSocket.Closing: console.log("BluetoothSocket - Closing" ); break;
            case BluetoothSocket.Listening: console.log("BluetoothSocket - Listening" ); break;
            case BluetoothSocket.Bound: console.log("BluetoothSocket - Bound" ); break;
            }
        }

        onStringDataChanged: {
            var data = remoteDeviceName + ": " + socket.stringData;
            console.log("Received data - " + data);
        }
    }

    //------------------------------------------------------------

    // 设备连接中
    Rectangle {
        width: root.width * 0.7; height: text.height*1.2;
        anchors.centerIn: parent
        radius: 5
        color: "#1c56f3"
        visible: btModel.running

        Text {
            id: text
            text: "设备连接中..."
            font.bold: true
            font.pointSize: 20
            anchors.centerIn: parent
        }

        SequentialAnimation on color {
            ColorAnimation { easing.type: Easing.InOutSine; from: "#1c56f3"; to: "white"; duration: 1000; }
            ColorAnimation { easing.type: Easing.InOutSine; to: "#1c56f3"; from: "white"; duration: 1000 }
            loops: Animation.Infinite
        }
    }

    // 错误弹窗
    Image {
        id: dialog
        width: 330*pixel; height: 610*pixel
        anchors.top: parent.top
        anchors.topMargin: 150*pixel
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false

        // 确认按钮
        Image {
            id: sure
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            source: root.isChinese ? "qrc:/image/sure_c-default.png" : "qrc:/image/sure_e-default.png"

            MouseArea {
                anchors.fill: parent
                onPressed: sure.source = root.isChinese ? "qrc:/image/sure_c-pressed.png" : "qrc:/image/sure_e-pressed.png"
                onReleased: sure.source = root.isChinese ? "qrc:/image/sure_c-default.png" : "qrc:/image/sure_e-default.png"
                onClicked: mainwindow.close()
            }
        }
    }

}
