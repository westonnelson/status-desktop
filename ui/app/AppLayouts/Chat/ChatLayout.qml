import QtQuick 2.13
import QtQuick.Controls 2.13
import Qt.labs.settings 1.0
import "../../../imports"
import "../../../shared"
import "../../../shared/status"
import "."
import "components"
import "./ChatColumn"
import "./CommunityComponents"

import StatusQ.Layout 0.1

StatusAppThreePanelLayout {
    id: chatView

    handle: SplitViewHandle { implicitWidth: 5 }

    property alias chatColumn: chatColumn
    property bool stickersLoaded: false
    property bool profilePopupOpened: false
    signal profileButtonClicked()

    Connections {
        target: chatsModel.stickers
        onStickerPacksLoaded: {
            stickersLoaded = true;
        }
    }

    property var onActivated: function () {
        chatsModel.channelView.restorePreviousActiveChannel()
        chatColumn.onActivated()
    }

    leftPanel: Loader {
        id: contactColumnLoader
        sourceComponent: appSettings.communitiesEnabled && chatsModel.communities.activeCommunity.active ? communtiyColumnComponent : contactsColumnComponent
    }

    centerPanel: ChatColumn {
        id: chatColumn
        chatGroupsListViewCount: contactColumnLoader.item.chatGroupsListViewCount
    }

    showRightPanel: chatColumn.showUsers && (chatsModel.channelView.activeChannel.chatType !== Constants.chatTypeOneToOne)
    rightPanel: appSettings.communitiesEnabled && chatsModel.communities.activeCommunity.active ? communityUserListComponent : userListComponent

    Component {
        id: communityUserListComponent
        CommunityUserList { currentTime: chatColumn.currentTime }
    }

    Component {
        id: userListComponent
        UserList { currentTime: chatColumn.currentTime; userList: chatColumn.userList }
    }

    Component {
        id: contactsColumnComponent
        ContactsColumn {
            onOpenProfileClicked: {
                chatView.profileButtonClicked();
            }
        }
    }

    Component {
        id: communtiyColumnComponent
        CommunityColumn {
            pinnedMessagesPopupComponent: chatColumn.pinnedMessagesPopupComponent
        }
    }

    Component {
        id: groupInfoPopupComponent
        GroupInfoPopup {
            pinnedMessagesPopupComponent: chatColumn.pinnedMessagesPopupComponent
        }
    }

    Component {
        id: statusStickerPackClickPopup
        StatusStickerPackClickPopup{
            onClosed: {
                destroy();
            }
        }
    }

    function openProfilePopup(userNameParam, fromAuthorParam, identiconParam, textParam, nicknameParam, parentPopup){
        var popup = profilePopupComponent.createObject(chatView);
        if(parentPopup){
            popup.parentPopup = parentPopup;
        }
        popup.openPopup(profileModel.profile.pubKey !== fromAuthorParam, userNameParam, fromAuthorParam, identiconParam, textParam, nicknameParam);
        profilePopupOpened = true
    }

    property Component profilePopupComponent: ProfilePopup {
        id: profilePopup
        height: 504
        onClosed: {
            if(profilePopup.parentPopup){
                profilePopup.parentPopup.close();
            }
            profilePopupOpened = false
            destroy()
        }
    }


    ConfirmationDialog {
        id: removeContactConfirmationDialog
        // % "Remove contact"
        title: qsTrId("remove-contact")
        //% "Are you sure you want to remove this contact?"
        confirmationText: qsTrId("are-you-sure-you-want-to-remove-this-contact-")
        onConfirmButtonClicked: {
            if (profileModel.contacts.isAdded(chatColumn.contactToRemove)) {
                profileModel.contacts.removeContact(chatColumn.contactToRemove)
            }
            removeContactConfirmationDialog.parentPopup.close();
            removeContactConfirmationDialog.close();
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorColor:"#ffffff";formeditorZoom:1.25;height:770;width:1152}
}
##^##*/
