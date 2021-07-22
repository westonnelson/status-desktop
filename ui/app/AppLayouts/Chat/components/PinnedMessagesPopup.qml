import QtQuick 2.13
import "../../../../imports"
import "../../../../shared"
import "../../../../shared/status"
import "../data"
import "../ChatColumn"

ModalPopup {
    property bool userCanPin: {
        switch (chatsModel.channelView.activeChannel.chatType) {
        case Constants.chatTypePublic: return false
        case Constants.chatTypeStatusUpdate: return false
        case Constants.chatTypeOneToOne: return true
        case Constants.chatTypePrivateGroupChat: return chatsModel.channelView.activeChannel.isAdmin(profileModel.profile.pubKey)
        case Constants.chatTypeCommunity: return chatsModel.communities.activeCommunity.admin
        default: return false
        }
    }
    property bool canStillPin: {
        if (!userCanPin) {
            return false
        }
        const nbPinnedMessages = chatsModel.messageView.pinnedMessagesList.count

        return nbPinnedMessages < Constants.maxNumberOfPins
    }
    property bool showPinLimit: userCanPin && !canStillPin
    property var messagesToUnpin: ([])


    id: popup

    header: Item {
        height: childrenRect.height
        width: parent.width

        StyledText {
            id: title
            text: showPinLimit ? qsTr("Pin limit reached") :
                                               //% "Pinned messages"
                                               qsTrId("pinned-messages")
            anchors.top: parent.top
            anchors.left: parent.left
            font.bold: true
            font.pixelSize: 17
        }

        StyledText {
            property int nbMessages: pinnedMessageListView.count

            id: nbPinnedMessages
            text: {
                if (showPinLimit) {
                    return qsTr("Unpin a previous message first")
                }

                //% "%1 messages"
                return nbMessages > 1 ? qsTrId("-1-messages").arg(nbMessages) :
                                        //% "%1 message"
                                        qsTrId("-1-message").arg(nbMessages)
            }
            anchors.left: parent.left
            anchors.top: title.bottom
            anchors.topMargin: 2
            font.pixelSize: 15
            color: Style.current.secondaryText
        }

        Separator {
            anchors.top: nbPinnedMessages.bottom
            anchors.topMargin: Style.current.padding
            anchors.left: parent.left
            anchors.leftMargin: -Style.current.padding
            anchors.right: parent.right
            anchors.rightMargin: -Style.current.padding
        }
    }

    Item {
        anchors.fill: parent

        StyledText {
            visible: pinnedMessageListView.count === 0
            //% "Pinned messages will appear here."
            text: qsTrId("pinned-messages-will-appear-here-")
            anchors.centerIn: parent
            color: Style.current.secondaryText
        }

        MessageContextMenu {
            id: msgContextMenu
            reactionModel: EmojiReactions {}
        }

        ListView {
            id: pinnedMessageListView
            model: chatsModel.messageView.pinnedMessagesList
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: -Style.current.padding
            anchors.right: parent.right
            anchors.rightMargin: -Style.current.padding
            topMargin: Style.current.halfPadding
            anchors.top: parent.top
            anchors.topMargin: -Style.current.halfPadding
            clip: true

            delegate: Item {
                width: parent.width
                height: msgItem.height

                Message {
                    id: msgItem
                    fromAuthor: model.fromAuthor
                    chatId: model.chatId
                    userName: model.userName
                    alias: model.alias
                    localName: model.localName
                    message: model.message
                    plainText: model.plainText
                    identicon: model.identicon
                    isCurrentUser: model.isCurrentUser
                    timestamp: model.timestamp
                    sticker: model.sticker
                    contentType: model.contentType
                    outgoingStatus: model.outgoingStatus
                    responseTo: model.responseTo
                    imageClick: imagePopup.openPopup.bind(imagePopup)
                    messageId: model.messageId
                    emojiReactions: model.emojiReactions
                    linkUrls: model.linkUrls
                    communityId: model.communityId
                    hasMention: model.hasMention
                    stickerPackId: model.stickerPackId
                    timeout: model.timeout
                    pinnedMessage: true
                    pinnedBy: model.pinnedBy
                    forceHoverHandler: !showPinLimit
                    isEdited: model.isEdited
                    showEdit: false
                    messageContextMenu: msgContextMenu
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: showPinLimit
                    cursorShape: Qt.PointingHandCursor
                    z: 55
                    onClicked: radio.toggle()
                }

                StatusRadioButton {
                    id: radio
                    visible: showPinLimit
                    anchors.right: parent.right
                    anchors.rightMargin: 18
                    anchors.verticalCenter: parent.verticalCenter
                    function toggle() {
                        radio.checked = !radio.checked
                        const messages = Object.assign([], messagesToUnpin)
                        if (radio.checked) {
                            messages.push(model.messageId)
                            messagesToUnpin = messages
                        } else {
                            const index = messagesToUnpin.indexOf(model.messageId)
                            if (index > -1) {
                                messages.splice(index, 1)
                                messagesToUnpin = messages
                            }
                        }
                    }
                }
            }
        }
    }


    footer: Item {
        width: parent.width
        height: btnBack.height

        StatusRoundButton {
            id: btnBack
            anchors.left: parent.left
            icon.name: "arrow-right"
            icon.width: 20
            icon.height: 16
            rotation: 180
            onClicked: popup.close()
        }

        StatusButton {
            id: btnUnpin
            visible: showPinLimit
            enabled: messagesToUnpin.length > 0
            text: qsTr("Unpin")
            anchors.right: parent.right
            onClicked: {
                const chatId = chatsModel.channelView.activeChannel.id
                messagesToUnpin.forEach(function (messageId) {
                    chatsModel.messageView.unPinMessage(messageId, chatId)
                })
            }
        }
    }
}
