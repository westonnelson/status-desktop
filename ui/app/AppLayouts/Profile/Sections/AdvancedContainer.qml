import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtGraphicalEffects 1.13
import "../../../../imports"
import "../../../../shared"
import "../../../../shared/status"

Item {
    id: advancedContainer
    Layout.fillHeight: true
    Layout.fillWidth: true
    clip: true

    Column {
        id: generalColumn
        anchors.top: parent.top
        anchors.topMargin: topMargin
        width: profileContainer.profileContentWidth

        anchors.horizontalCenter: parent.horizontalCenter

        StatusSettingsLineButton {
            //% "Network"
            text: qsTrId("network")
            currentValue: utilsModel.getNetworkName()
            onClicked: networksModal.open()
        }

        StatusSettingsLineButton {
            //% "Fleet"
            text: qsTrId("fleet")
            currentValue: profileModel.fleets.fleet
            onClicked: fleetModal.open()
        }

        StatusSettingsLineButton {
            //% "Minimize on close"
            text: qsTrId("minimize-on-close")
            isSwitch: true
            switchChecked: !appSettings.quitOnClose
            onClicked: function (checked) {
                appSettings.quitOnClose = !checked
            }
        }

        Item {
            id: spacer1
            height: Style.current.bigPadding
            width: parent.width
        }

        Separator {
            anchors.topMargin: Style.current.bigPadding
            anchors.left: parent.left
            anchors.leftMargin: -Style.current.padding
            anchors.right: parent.right
            anchors.rightMargin: -Style.current.padding
        }

        StatusSectionHeadline {
            //% "Experimental features"
            text: qsTrId("experimental-features")
            topPadding: Style.current.bigPadding
            bottomPadding: Style.current.padding
        }

        StatusSettingsLineButton {
            //% "Wallet"
            text: qsTrId("wallet")
            isSwitch: true
            switchChecked: appSettings.isWalletEnabled
            onClicked: {
                if (!appSettings.isWalletEnabled) {
                    confirmationPopup.settingsProp = "isWalletEnabled"
                    confirmationPopup.open()
                } else {
                    appSettings.isWalletEnabled = false
                }
            }
        }

        StatusSettingsLineButton {
            //% "Dapp Browser"
            text: qsTrId("dapp-browser")
            isSwitch: true
            switchChecked: appSettings.isBrowserEnabled
            onClicked: {
                if (!appSettings.isBrowserEnabled) {
                    confirmationPopup.settingsProp = "isBrowserEnabled"
                    confirmationPopup.open()
                } else {
                    appSettings.isBrowserEnabled = false
                }
            }
        }

        StatusSettingsLineButton {
            //% "Communities"
            text: qsTrId("communities")
            isSwitch: true
            switchChecked: appSettings.communitiesEnabled
            onClicked: {
                if (!appSettings.communitiesEnabled) {
                    confirmationPopup.settingsProp = "communitiesEnabled"
                    confirmationPopup.open()
                } else {
                    appSettings.communitiesEnabled = false
                }
            }
        }

        StatusSettingsLineButton {
            //% "Activity Center"
            text: qsTrId("activity-center")
            isSwitch: true
            switchChecked: appSettings.isActivityCenterEnabled
            onClicked: {
                if (!appSettings.isActivityCenterEnabled) {
                    confirmationPopup.settingsProp = "isActivityCenterEnabled"
                    confirmationPopup.open()
                } else {
                    appSettings.isActivityCenterEnabled = false
                }
            }
        }

        StatusSettingsLineButton {
            id: onlineUsers
            text: qsTr("Online users")
            isSwitch: true
            switchChecked: appSettings.showOnlineUsers
            onClicked: {
                appSettings.showOnlineUsers = !appSettings.showOnlineUsers
            }
        }

        Loader {
            active: onlineUsers.switchChecked
            anchors.left: parent.left
            anchors.right: parent.right
            sourceComponent: StatusSettingsLineButton {
                text: qsTr("Broadcast user status")
                isSwitch: true
                switchChecked: profileModel.profile.sendUserStatus
                onClicked: function (checked) {
                    if (profileModel.profile.sendUserStatus !== checked) {
                        profileModel.setSendUserStatus(checked)
                    }
                }
            }
        }

        StatusSectionHeadline {
            //% "Bloom filter level"
            text: qsTrId("bloom-filter-level")
            topPadding: Style.current.bigPadding
            bottomPadding: Style.current.padding
        }

        Row {
            spacing: 11

            Component {
                id: bloomConfirmationDialogComponent
                ConfirmationDialog {
                    property string mode: "normal"

                    id: confirmDialog
                    //% "Warning!"
                    title: qsTrId("close-app-title")
                    //% "The account will be logged out. When you login again, the selected mode will be enabled"
                    confirmationText: qsTrId("the-account-will-be-logged-out--when-you-login-again--the-selected-mode-will-be-enabled")
                    onConfirmButtonClicked: {
                        nodeModel.setBloomLevel(mode)
                    }
                    onClosed: {
                        switch(nodeModel.bloomLevel){
                            case "light":  btnBloomLight.click(); break;
                            case "normal":  btnBloomNormal.click(); break;
                            case "full":  btnBloomFull.click(); break;
                        }
                        destroy()
                    }
                }
            }

            ButtonGroup {
                id: bloomGroup
            }

            BloomSelectorButton {
                id: btnBloomLight
                buttonGroup: bloomGroup
                checkedByDefault: nodeModel.bloomLevel == "light"
                //% "Light Node"
                btnText: qsTrId("light-node")
                onToggled: {
                    if (nodeModel.bloomLevel != "light") {
                        openPopup(bloomConfirmationDialogComponent, {mode: "light"})
                    } else {
                        btnBloomLight.click()
                    }
                }
            }

            BloomSelectorButton {
                id: btnBloomNormal
                buttonGroup: bloomGroup
                checkedByDefault: nodeModel.bloomLevel == "normal"
                //% "Normal"
                btnText: qsTrId("normal")
                onToggled: {
                    if (nodeModel.bloomLevel != "normal") {
                        openPopup(bloomConfirmationDialogComponent, {mode: "normal"})
                    } else {
                        btnBloomNormal.click()
                    }
                }
            }

            BloomSelectorButton {
                id: btnBloomFull
                buttonGroup: bloomGroup
                checkedByDefault: nodeModel.bloomLevel == "full"
                //% "Full Node"
                btnText: qsTrId("full-node")
                onToggled: {
                    if (nodeModel.bloomLevel != "full") {
                        openPopup(bloomConfirmationDialogComponent, {mode: "full"})
                    } else {
                        btnBloomFull.click()
                    }
                }
            }
        }        

        StatusSettingsLineButton {
            text: qsTr("GIF Widget")
            isSwitch: true
            switchChecked: appSettings.isGifWidgetEnabled
            onClicked: {
                appSettings.isGifWidgetEnabled = !appSettings.isGifWidgetEnabled
            }
        }

        // StatusSettingsLineButton {
        //     //% "Node Management"
        //     text: qsTrId("node-management")
        //     isSwitch: true
        //     switchChecked: appSettings.nodeManagementEnabled
        //     onClicked: {
        //         if (!appSettings.nodeManagementEnabled) {
        //             confirmationPopup.settingsProp = "nodeManagementEnabled"
        //             confirmationPopup.open()
        //         } else {
        //             appSettings.nodeManagementEnabled = false
        //         }
        //     }
        // }
    }

    NetworksModal {
        id: networksModal
    }

    FleetsModal {
        id: fleetModal
    }

    ConfirmationDialog {
        id: confirmationPopup
        property string settingsProp: ""
        height: 310
        showCancelButton: true
        //% "This feature is experimental and is meant for testing purposes by core contributors and the community. It's not meant for real use and makes no claims of security or integrity of funds or data. Use at your own risk."
        confirmationText: qsTrId("this-feature-is-experimental-and-is-meant-for-testing-purposes-by-core-contributors-and-the-community--it-s-not-meant-for-real-use-and-makes-no-claims-of-security-or-integrity-of-funds-or-data--use-at-your-own-risk-")
        //% "I understand"
        confirmButtonLabel: qsTrId("i-understand")
        onConfirmButtonClicked: {
            appSettings[settingsProp] = true
            settingsProp = ""
            close()
        }

        onCancelButtonClicked: {
            close()
        }
    }
}

/*##^##
Designer {
    D{i:0;height:400;width:700}
}
##^##*/
