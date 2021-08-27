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

    // 初始化
    Component.onCompleted: {
        dialog.visible = false          // 隐藏弹窗
        messageBox.visible = false      // 隐藏提示弹窗
        btModel.running = true          // 运行蓝牙服务
    }

    // 背景
    Image {
        anchors.fill: parent
        source: "qrc:/image/bg.png"
        enabled: !btModel.running && !dialog.visible && !messageBox.visible

        // logo
        Image {
            x: 20*pixel; y: 20*pixel
            width: 240*pixel; height: 80*pixel
            source: "qrc:/image/logo.png"
        }

        // 调焦
        Image {
            width: root.isChinese ? 101*pixel : 133*pixel; height: 46*pixel
            anchors.top: parent.top
            anchors.topMargin: 120*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            source: root.isChinese ? "qrc:/image/focus-c.png" : "qrc:/image/focus-e.png"
        }

        // 调焦按钮组
        Rectangle {
            width: 330*pixel; height: 60*pixel
            anchors.top: parent.top
            anchors.topMargin: 170*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"

            // 调焦左旋钮
            Image {
                id: focus_left
                width: 160*pixel; height: 60*pixel
                anchors.top: parent.top
                anchors.left: parent.left
                source: focus_leftArea.containsPress ? "qrc:/image/down-pressed.png" : "qrc:/image/down-default.png"

                MouseArea {
                    id: focus_leftArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onPressed: socket.stringData = "a"
                    onReleased: socket.stringData = "b"
                }
            }

            // 调焦右旋钮
            Image {
                id: focus_right
                width: 160*pixel; height: 60*pixel
                anchors.top: parent.top
                anchors.right: parent.right
                source: focus_rightArea.containsPress ? "qrc:/image/up-pressed.png" : "qrc:/image/up-default.png"

                MouseArea {
                    id: focus_rightArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onPressed: socket.stringData = "c"
                    onReleased: socket.stringData = "d"
                }
            }
        }

        // 变倍
        Image {
            width: root.isChinese ? 101*pixel : 128*pixel; height: 46*pixel
            anchors.top: parent.top
            anchors.topMargin: 250*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            source: root.isChinese ? "qrc:/image/zoom-c.png" : "qrc:/image/zoom-e.png"
        }

        // 变倍按钮组
        Rectangle {
            width: 330*pixel; height: 60*pixel
            anchors.top: parent.top
            anchors.topMargin: 300*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"

            // 变倍左旋钮
            Image {
                id: zoom_left
                width: 160*pixel; height: 60*pixel
                anchors.top: parent.top
                anchors.left: parent.left
                source: zoom_leftArea.containsPress ? "qrc:/image/down-pressed.png" : "qrc:/image/down-default.png"

                MouseArea {
                    id: zoom_leftArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onPressed: socket.stringData = "e"
                    onReleased: socket.stringData = "f"
                }
            }

            // 变倍右旋钮
            Image {
                id: zoom_right
                width: 160*pixel; height: 60*pixel
                anchors.top: parent.top
                anchors.right: parent.right
                source: zoom_rightArea.containsPress ? "qrc:/image/up-pressed.png" : "qrc:/image/up-default.png"

                MouseArea {
                    id: zoom_rightArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onPressed: socket.stringData = "g"
                    onReleased: socket.stringData = "h"
                }
            }
        }

        // 亮度
        Image {
            width: root.isChinese ? 101*pixel : 252*pixel; height: 46*pixel
            anchors.top: parent.top
            anchors.topMargin: 380*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            source: root.isChinese ? "qrc:/image/brightness-c.png" : "qrc:/image/brightness-e.png"
        }

        // 亮度钮组
        Rectangle {
            width: 330*pixel; height: 60*pixel
            anchors.top: parent.top
            anchors.topMargin: 430*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"

            // 亮度左旋钮
            Image {
                id: brightness_left
                width: 160*pixel; height: 60*pixel
                anchors.top: parent.top
                anchors.left: parent.left
                source: zoom_leftArea.containsPress ? "qrc:/image/down-pressed.png" : "qrc:/image/down-default.png"

                MouseArea {
                    id: brightness_leftArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onPressed: socket.stringData = "i"
                    onReleased: socket.stringData = "j"
                }
            }

            // 亮度右旋钮
            Image {
                id: brightness_right
                width: 160*pixel; height: 60*pixel
                anchors.top: parent.top
                anchors.right: parent.right
                source: zoom_rightArea.containsPress ? "qrc:/image/up-pressed.png" : "qrc:/image/up-default.png"

                MouseArea {
                    id: brightness_rightArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onPressed: socket.stringData = "k"
                    onReleased: socket.stringData = "l"
                }
            }
        }

        // 对比度
        Image {
            width: root.isChinese ? 139*pixel : 217*pixel; height: 46*pixel
            anchors.top: parent.top
            anchors.topMargin: 510*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            source: root.isChinese ? "qrc:/image/contrast-c.png" : "qrc:/image/contrast-e.png"
        }

        // 对比度钮组
        Rectangle {
            width: 330*pixel; height: 60*pixel
            anchors.top: parent.top
            anchors.topMargin: 560*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"

            // 对比度左旋钮
            Image {
                id: contrast_left
                width: 160*pixel; height: 60*pixel
                anchors.top: parent.top
                anchors.left: parent.left
                source: zoom_leftArea.containsPress ? "qrc:/image/down-pressed.png" : "qrc:/image/down-default.png"

                MouseArea {
                    id: contrast_leftArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: socket.stringData = "m"
                }
            }

            // 对比度右旋钮
            Image {
                id: contrast_right
                width: 160*pixel; height: 60*pixel
                anchors.top: parent.top
                anchors.right: parent.right
                source: zoom_rightArea.containsPress ? "qrc:/image/up-pressed.png" : "qrc:/image/up-default.png"

                MouseArea {
                    id: contrast_rightArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: socket.stringData = "n"
                }
            }
        }

        // 对准
        Image {
            id: align
            width: 200*pixel; height: 60*pixel
            anchors.top: parent.top
            anchors.topMargin: 650*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            source: root.isChinese ? "qrc:/image/align_c-default.png" : "qrc:/image/align_e-default.png"

            MouseArea {
                anchors.fill: parent
                onPressed: align.source = root.isChinese ? "qrc:/image/align_c-pressed.png" : "qrc:/image/align_e-pressed.png"
                onReleased: align.source = root.isChinese ? "qrc:/image/align_c-default.png" : "qrc:/image/align_e-default.png"
                onClicked: socket.stringData = "o"
            }
        }

        // 测量
        Image {
            id: measure
            width: 200*pixel; height: 60*pixel
            anchors.top: parent.top
            anchors.topMargin: 730*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            source: root.isChinese ? "qrc:/image/measure_c-default.png" : "qrc:/image/measure_e-default.png"

            MouseArea {
                anchors.fill: parent
                onPressed: measure.source = root.isChinese ? "qrc:/image/measure_c-pressed.png" : "qrc:/image/measure_e-pressed.png"
                onReleased: measure.source = root.isChinese ? "qrc:/image/measure_c-default.png" : "qrc:/image/measure_e-default.png"
                onClicked: socket.stringData = "p"
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

            console.log("BluetoothDiscoveryModel - service found !")
            serviceFound = true
            remoteDeviceName = service.deviceName
            socket.setService(service)
            console.log("BluetoothDiscoveryModel - connect to service successfully !")
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
            var data = socket.stringData;
//            console.log("Received data - " + remoteDeviceName + ": " + data);

            if ( data === "FL\r\n" ) {
                // 调焦左限位已触发
            } else if ( data === "FR\r\n" ) {
                // 调焦右限位已触发
            } else if ( data === "ZL\r\n" ) {
                // 变倍左限位已触发
            } else if ( data === "ZR\r\n" ) {
                // 变倍右限位已触发
            } else if ( data === "CL\r\n" ) {
                // 对比度左限位已触发
            } else if ( data === "CR\r\n" ) {
                // 对比度右限位已触发
            }

            // 电机到达极限位置
            messageBox.source = root.isChinese ? "qrc:/image/error_c-limit.png" : "qrc:/image/error_e-limit.png"
            messageBox.visible = true
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
            source: sureArea.containsPress ? (root.isChinese ? "qrc:/image/sure_c-pressed.png" : "qrc:/image/sure_e-pressed.png")
                                           : (root.isChinese ? "qrc:/image/sure_c-default.png" : "qrc:/image/sure_e-default.png")

            MouseArea {
                id: sureArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: mainwindow.close()
            }
        }
    }

    // 提示弹窗
    Image {
        id: messageBox
        width: 330*pixel; height: 610*pixel
        anchors.top: parent.top
        anchors.topMargin: 150*pixel
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false

        // 确认按钮
        Image {
            id: sure2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50*pixel
            anchors.horizontalCenter: parent.horizontalCenter
            source: sure2Area.containsPress ? (root.isChinese ? "qrc:/image/sure_c-pressed.png" : "qrc:/image/sure_e-pressed.png")
                                            : (root.isChinese ? "qrc:/image/sure_c-default.png" : "qrc:/image/sure_e-default.png")

            MouseArea {
                id: sure2Area
                anchors.fill: parent
                hoverEnabled: true
                onClicked: messageBox.visible = false
            }
        }
    }

}
