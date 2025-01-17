import QtQuick 2.14
import "../../../../../shared"
import "../../../../../shared/status"
import "../../../../../imports"

StyledText {
    id: chatTime
    visible: isMessage
    color: Style.current.secondaryText
    text: Utils.formatTime(timestamp)
    font.pixelSize: Style.current.asideTextFontSize
    
    StatusToolTip {
        visible: hhandler.hovered
        text: new Date(parseInt(timestamp, 10)).toLocaleString(Qt.locale(globalSettings.locale))
        maxWidth: 350
    }

    HoverHandler {
        id: hhandler
    }
}
