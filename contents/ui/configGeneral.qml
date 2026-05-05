import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.iconthemes as KIconThemes

Item {
    id: page
    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight

    property string cfg_customCommands: "[]"
    property string cfg_iconLock: "system-lock-screen"
    property string cfg_iconLogout: "system-log-out"
    property string cfg_iconSleep: "system-suspend"
    property string cfg_iconRestart: "system-reboot"
    property string cfg_iconShutdown: "system-shutdown"

    Component.onCompleted: {
        try {
            var raw = cfg_customCommands;
            if (!raw) raw = "[]";
            var commandList = JSON.parse(raw);
            commandModel.clear();
            for (var i = 0; i < commandList.length; i++) {
                commandModel.append(commandList[i]);
            }
        } catch (e) {
            console.error("Parse error:", e);
            commandModel.clear();
        }
    }

    function saveCommands() {
        var arr = [];
        for (var i = 0; i < commandModel.count; i++) {
            arr.push({
                "name": commandModel.get(i).name,
                "icon": commandModel.get(i).icon,
                "command": commandModel.get(i).command
            });
        }
        cfg_customCommands = JSON.stringify(arr);
    }

    ListModel {
        id: commandModel
    }

    KIconThemes.IconDialog {
        id: iconPickerPopup
        title: "Select an Icon"

        property var targetInput: null

        onIconNameChanged: {
            if (targetInput && iconName !== "") {
                targetInput.text = iconName;
                targetInput.editingFinished();
                // Optionally reset iconName if needed, but usually closing is enough
            }
        }
    }

    ColumnLayout {
        id: mainLayout
        anchors.left: parent.left
        anchors.right: parent.right

        QQC2.Label {
            text: "Standard Icons"
            font.bold: true
        }

        GridLayout {
            columns: 4
            Layout.fillWidth: true
            rowSpacing: Kirigami.Units.smallSpacing
            columnSpacing: Kirigami.Units.smallSpacing

            // Lock Screen
            QQC2.Label { text: "Lock Screen"; Layout.preferredWidth: 100 }
            Kirigami.Icon { source: cfg_iconLock; Layout.preferredWidth: Kirigami.Units.iconSizes.medium; Layout.preferredHeight: Kirigami.Units.iconSizes.medium }
            QQC2.TextField { id: txtLock; Layout.fillWidth: true; text: cfg_iconLock; onEditingFinished: cfg_iconLock = text }
            QQC2.Button { icon.name: "document-open"; onClicked: { iconPickerPopup.targetInput = txtLock; iconPickerPopup.open() } }

            // Log Out
            QQC2.Label { text: "Log Out"; Layout.preferredWidth: 100 }
            Kirigami.Icon { source: cfg_iconLogout; Layout.preferredWidth: Kirigami.Units.iconSizes.medium; Layout.preferredHeight: Kirigami.Units.iconSizes.medium }
            QQC2.TextField { id: txtLogout; Layout.fillWidth: true; text: cfg_iconLogout; onEditingFinished: cfg_iconLogout = text }
            QQC2.Button { icon.name: "document-open"; onClicked: { iconPickerPopup.targetInput = txtLogout; iconPickerPopup.open() } }

            // Sleep
            QQC2.Label { text: "Sleep"; Layout.preferredWidth: 100 }
            Kirigami.Icon { source: cfg_iconSleep; Layout.preferredWidth: Kirigami.Units.iconSizes.medium; Layout.preferredHeight: Kirigami.Units.iconSizes.medium }
            QQC2.TextField { id: txtSleep; Layout.fillWidth: true; text: cfg_iconSleep; onEditingFinished: cfg_iconSleep = text }
            QQC2.Button { icon.name: "document-open"; onClicked: { iconPickerPopup.targetInput = txtSleep; iconPickerPopup.open() } }

            // Restart
            QQC2.Label { text: "Restart"; Layout.preferredWidth: 100 }
            Kirigami.Icon { source: cfg_iconRestart; Layout.preferredWidth: Kirigami.Units.iconSizes.medium; Layout.preferredHeight: Kirigami.Units.iconSizes.medium }
            QQC2.TextField { id: txtRestart; Layout.fillWidth: true; text: cfg_iconRestart; onEditingFinished: cfg_iconRestart = text }
            QQC2.Button { icon.name: "document-open"; onClicked: { iconPickerPopup.targetInput = txtRestart; iconPickerPopup.open() } }

            // Shutdown
            QQC2.Label { text: "Shut Down"; Layout.preferredWidth: 100 }
            Kirigami.Icon { source: cfg_iconShutdown; Layout.preferredWidth: Kirigami.Units.iconSizes.medium; Layout.preferredHeight: Kirigami.Units.iconSizes.medium }
            QQC2.TextField { id: txtShutdown; Layout.fillWidth: true; text: cfg_iconShutdown; onEditingFinished: cfg_iconShutdown = text }
            QQC2.Button { icon.name: "document-open"; onClicked: { iconPickerPopup.targetInput = txtShutdown; iconPickerPopup.open() } }
        }

        Kirigami.Separator {
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.bottomMargin: Kirigami.Units.largeSpacing
        }

        QQC2.Label {
            text: "Custom Commands"
            font.bold: true
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            implicitHeight: Math.max(100, contentHeight)
            clip: true
            model: commandModel
            spacing: Kirigami.Units.smallSpacing

            delegate: RowLayout {
                width: listView.width
                spacing: Kirigami.Units.smallSpacing

                Kirigami.Icon {
                    source: model.icon || "utilities-terminal"
                    Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                    Layout.preferredHeight: Kirigami.Units.iconSizes.medium
                }

                QQC2.TextField {
                    Layout.preferredWidth: 100
                    text: model.name
                    placeholderText: "Name"
                    onEditingFinished: {
                        commandModel.setProperty(index, "name", text);
                        page.saveCommands();
                    }
                }

                QQC2.TextField {
                    id: rowIconInput
                    Layout.preferredWidth: 120
                    text: model.icon
                    placeholderText: "Icon Name"
                    onEditingFinished: {
                        commandModel.setProperty(index, "icon", text);
                        page.saveCommands();
                    }
                }

                QQC2.Button {
                    icon.name: "document-open"
                    onClicked: {
                        iconPickerPopup.targetInput = rowIconInput;
                        iconPickerPopup.open();
                    }
                }

                QQC2.TextField {
                    Layout.fillWidth: true
                    text: model.command
                    placeholderText: "Command"
                    onEditingFinished: {
                        commandModel.setProperty(index, "command", text);
                        page.saveCommands();
                    }
                }

                QQC2.Button {
                    icon.name: "list-remove"
                    onClicked: {
                        commandModel.remove(index);
                        page.saveCommands();
                    }
                }
            }
        }

        Kirigami.Separator {
            Layout.fillWidth: true
        }

        QQC2.Label {
            text: "Add New Command"
            font.bold: true
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            Kirigami.Icon {
                source: newIcon.text || "utilities-terminal"
                Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                Layout.preferredHeight: Kirigami.Units.iconSizes.medium
            }

            QQC2.TextField {
                id: newName
                Layout.preferredWidth: 100
                placeholderText: "Name"
            }

            QQC2.TextField {
                id: newIcon
                Layout.preferredWidth: 120
                placeholderText: "Icon Name"
            }

            QQC2.Button {
                icon.name: "document-open"
                onClicked: {
                    iconPickerPopup.targetInput = newIcon;
                    iconPickerPopup.open();
                }
            }

            QQC2.TextField {
                id: newCommand
                Layout.fillWidth: true
                placeholderText: "Command to execute"
            }

            QQC2.Button {
                icon.name: "list-add"
                text: "Add"
                enabled: newName.text !== "" && newCommand.text !== ""
                onClicked: {
                    commandModel.append({
                        "name": newName.text,
                        "icon": newIcon.text,
                        "command": newCommand.text
                    });
                    page.saveCommands();
                    newName.text = "";
                    newIcon.text = "";
                    newCommand.text = "";
                }
            }
        }
    }
}
