import QtQuick 2.13
import QtQuick.Controls 2.13
import "../../imports"
import "../../shared"
import "../../shared/status"

ModalPopup {
    property var onAccountSelect: function () {}
    property var onOpenModalClick: function () {}
    id: popup
    //% "Your keys"
    title: qsTrId("your-keys")

    AccountList {
        id: accountList
        anchors.fill: parent

        accounts: loginModel
        isSelected: function (index, keyUid) {
            return loginModel.currentAccount.keyUid === keyUid
        }

        onAccountSelect: function(index) {
            popup.onAccountSelect(index)
            popup.close()
        }
    }

    footer: StatusButton {
        anchors.bottom: parent.bottom
        anchors.topMargin: Style.current.padding
        anchors.right: parent.right
        //% "Add another existing key"
        text: qsTrId("add-another-existing-key")

        onClicked : {
           onOpenModalClick()
           popup.close()
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorColor:"#ffffff";height:500;width:400}
}
##^##*/
