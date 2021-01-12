import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtBluetooth 5.2

Rectangle {
    id: root
    visible: true
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

    property bool isChinese: true
    property bool serviceFound: false
    property string deviceName: ""

    // 背景
    Image {
        anchors.fill: parent
        source: "qrc:/image/bg.png"

        // logo
        Image {
            x: 20; y: 20
            source: "qrc:/image/logo.png"
        }

        // 调焦左旋钮
        Image {
            id: focus_left
            x: 57; y: 130
            source: "qrc:/image/left_default.png"

            MouseArea {
                anchors.fill: parent
                onPressed: focus_left.source = "qrc:/image/left_pressed.png"
                onReleased: focus_left.source = "qrc:/image/left_default.png"
                onClicked: socket.stringData = "1"
            }
        }

        // 调焦
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: focus_left.verticalCenter
            source: root.isChinese ? "qrc:/image/focus-c.png" : "qrc:/image/focus-e.png"
        }

        // 调焦右旋钮
        Image {
            id: focus_right
            x: 302; y: 130
            source: "qrc:/image/right_default.png"

            MouseArea {
                anchors.fill: parent
                onPressed: focus_right.source = "qrc:/image/right_pressed.png"
                onReleased: focus_right.source = "qrc:/image/right_default.png"
                onClicked: socket.stringData = "2"
            }
        }

        // 变倍左旋钮
        Image {
            id: zoom_left
            x: 57; y: 250
            source: "qrc:/image/left_default.png"

            MouseArea {
                anchors.fill: parent
                onPressed: zoom_left.source = "qrc:/image/left_pressed.png"
                onReleased: zoom_left.source = "qrc:/image/left_default.png"
                onClicked: socket.stringData = "3"
            }
        }

        // 变倍
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: zoom_left.verticalCenter
            source: root.isChinese ? "qrc:/image/zoom-c.png" : "qrc:/image/zoom-e.png"
        }

        // 变倍右旋钮
        Image {
            id: zoom_right
            x: 302; y: 250
            source: "qrc:/image/right_default.png"

            MouseArea {
                anchors.fill: parent
                onPressed: zoom_right.source = "qrc:/image/right_pressed.png"
                onReleased: zoom_right.source = "qrc:/image/right_default.png"
                onClicked: socket.stringData = "4"
            }
        }

        // 对比度左旋钮
        Image {
            id: contrast_left
            x: 57; y: 370
            source: "qrc:/image/left_default.png"

            MouseArea {
                anchors.fill: parent
                onPressed: contrast_left.source = "qrc:/image/left_pressed.png"
                onReleased: contrast_left.source = "qrc:/image/left_default.png"
                onClicked: socket.stringData = "5"
            }
        }

        // 对比度
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: contrast_left.verticalCenter
            source: root.isChinese ? "qrc:/image/contrast-c.png" : "qrc:/image/contrast-e.png"
        }

        // 对比度右旋钮
        Image {
            id: contrast_right
            x: 302; y: 370
            source: "qrc:/image/right_default.png"

            MouseArea {
                anchors.fill: parent
                onPressed: contrast_right.source = "qrc:/image/right_pressed.png"
                onReleased: contrast_right.source = "qrc:/image/right_default.png"
                onClicked: socket.stringData = "6"
            }
        }

        // 对准
        Image {
            x: 50; y: 480
            source: root.isChinese ? "qrc:/image/align-c.png" : "qrc:/image/align-e.png"

            MouseArea {
                anchors.fill: parent
                onClicked: socket.stringData = "9"
            }
        }

        // 测量
        Image {
            x: 210; y: 480
            source: root.isChinese ? "qrc:/image/measure-c.png" : "qrc:/image/measure-e.png"

            MouseArea {
                anchors.fill: parent
                onClicked: socket.stringData = "10"
            }
        }

        // 蓝牙状态
        Image {
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            source: root.serviceFound ? "qrc:/image/bluetooth-ok.png" : "qrc:/image/bluetooth-notok.png"
        }

        // 语言
        Image {
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            source: root.isChinese ? "qrc:/image/measure-e.png" : "qrc:/image/measure-c.png"

            MouseArea {
                anchors.fill: parent
                onClicked: root.isChinese = !root.isChinese
            }
        }

    }

    //------------------------------------------------------------

    // 蓝牙扫描仪
    BluetoothDiscoveryModel {
        id: btModel
        running: true
        discoveryMode: BluetoothDiscoveryModel.MinimalServiceDiscovery
        uuidFilter: "{00001101-0000-1000-8000-00805f9b34fb}"

        onRunningChanged : {
            if ( !btModel.running && !serviceFound ) {
                console.log("No service found.\nPlease start server and restart app.")
            }
        }

        onErrorChanged: {
            switch (btModel.error) {
            case BluetoothDiscoveryModel.NoError: break;
            case BluetoothDiscoveryModel.InputOutputError:
                console.log("Error: Bluetooth I/O Error")
                break;
            case BluetoothDiscoveryModel.PoweredOffError:
                console.log("Error: Bluetooth device not turned on")
                break;
            case BluetoothDiscoveryModel.InvalidBluetoothAdapterError:
                console.log("Error: Invalid Bluetooth Adapter Error")
                break;
            case BluetoothDiscoveryModel.UnknownError:
                console.log("Error: Unknown Error")
                break;
            }
        }

        onServiceDiscovered: {
            if (serviceFound) {
                return
            }

            console.log("BluetoothDiscoveryModel - Found new service - deviceAddress: " + service.deviceAddress + ", deviceAddress: " +
                        service.deviceName + ", serviceName: " + service.serviceName + ", serviceUuid: " + service.serviceUuid)

            if ( service.deviceAddress == "00:20:08:00:26:76" ) {
                serviceFound = true
                remoteDeviceName = service.deviceName
                socket.setService(service)
                btModel.running = false
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
            case BluetoothSocket.Unconnected: console.log("BluetoothSocket - Unconnected" ); break;
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

    // 搜索中
    Rectangle {
        id: busy
        width: root.width * 0.7;
        height: text.height*1.2;
        anchors.top: root.top;
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 5
        color: "#1c56f3"
        visible: btModel.running

        Text {
            id: text
            text: "设备连接中"
            font.bold: true
            font.pointSize: 20
            anchors.centerIn: parent
        }

        SequentialAnimation on color {
            id: busyThrobber
            ColorAnimation { easing.type: Easing.InOutSine; from: "#1c56f3"; to: "white"; duration: 1000; }
            ColorAnimation { easing.type: Easing.InOutSine; to: "#1c56f3"; from: "white"; duration: 1000 }
            loops: Animation.Infinite
        }
    }

    // 透明遮罩
    Rectangle {
        id: mask
        z: 1
        anchors.fill: parent
        color: "transparent"

        MouseArea{
            anchors.fill: parent;
            propagateComposedEvents: true   // 允许事件穿透
            hoverEnabled: true              // 处理鼠标悬浮

            onClicked: {
                mouse.accepted = false      // 不处理此事件，传递给下一层
                mask.visible = false
            }
        }

    }

}
