/* === This file is part of Calamares - <https://github.com/calamares> ===
 *
 *   SPDX-FileCopyrightText: 2021 - 2023 Anke Boersma <demm@kaosx.us>
 *   SPDX-FileCopyrightText: 2024 XeroLinux <xerolinux@pm.me>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *   License-Filename: LICENSE
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

import io.calamares.core 1.0
import io.calamares.ui 1.0

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import QtQuick.Window

Page {
    id: finished

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20
        width: Math.min(parent.width * 0.8, 600)

        // Status Icon
        Kirigami.Icon {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: 80
            implicitHeight: 80
            source: config.failed ? "dialog-error" : "dialog-ok-apply"
            color: config.failed ? Kirigami.Theme.negativeTextColor : Kirigami.Theme.positiveTextColor
        }

        // Title
        Kirigami.Heading {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            level: 1
            color: config.failed ? Kirigami.Theme.negativeTextColor : "white"
            text: config.failed
                ? qsTr("Installation Failed", "@title")
                : qsTr("Installation Completed", "@title")
        }

        // Subtitle
        Label {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: "white"
            text: config.failed
                ? qsTr("%1 could not be installed. Please check the log for details.")
                    .arg(Branding.string(Branding.ProductName))
                : qsTr("%1 has been installed on your computer.")
                    .arg(Branding.string(Branding.ProductName))
        }

        // Failure details box (only shown on failure with details)
        Rectangle {
            id: failureBox
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.maximumWidth: 500
            Layout.preferredHeight: failureContent.implicitHeight + 24
            visible: config.failed && (config.failureMessage !== "" || config.failureDetails !== "")
            color: Qt.rgba(1, 0.3, 0.3, 0.2)
            radius: 8
            border.color: Kirigami.Theme.negativeTextColor
            border.width: 1

            ColumnLayout {
                id: failureContent
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Label {
                    Layout.fillWidth: true
                    text: config.failureMessage
                    color: Kirigami.Theme.negativeTextColor
                    font.bold: true
                    wrapMode: Text.WordWrap
                    visible: config.failureMessage !== ""
                }

                Label {
                    Layout.fillWidth: true
                    text: config.failureDetails
                    color: "white"
                    font.pointSize: 10
                    wrapMode: Text.WordWrap
                    visible: config.failureDetails !== ""
                }
            }
        }

        // Success message (only shown on success)
        Label {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            visible: !config.failed
            color: Qt.rgba(1, 1, 1, 0.7)
            text: qsTr("You may now restart into your new system, or continue using the Live environment.")
        }

        // Spacer
        Item {
            Layout.preferredHeight: 20
        }

        // Action buttons
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 12

            Button {
                id: closeButton
                text: qsTr("Close Installer", "@button")
                icon.name: "application-exit"
                onClicked: ViewManager.quit()
            }

            Button {
                id: restartButton
                text: qsTr("Restart Now", "@button")
                icon.name: "system-reboot"
                visible: !config.failed
                highlighted: true
                onClicked: config.doRestart(true)
            }
        }

        // Spacer
        Item {
            Layout.preferredHeight: 10
        }

        // Log file info
        Label {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.pointSize: 9
            color: Qt.rgba(1, 1, 1, 0.5)
            text: qsTr("A full log is available at ~/installation.log and /var/log/installation.log")
        }
    }

    function onActivate() { }
    function onLeave() { }
}
