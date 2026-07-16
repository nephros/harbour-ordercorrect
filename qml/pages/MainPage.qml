/*
 * This file is part of OrderCorrect.
 * Copyright (c) 2026 Peter G. (nephros)
 * SPDX-License-Identifier: Apache-2.0
 */

import QtQuick 2.6
import Sailfish.Silica 1.0

Page { id: page

    allowedOrientations: Orientation.All
    property bool inputValid: false
    function preview() {
        previewField.text = "Subject: " + "JollaPhoneOrderChanges: "
            + formatSubject()
            + "\n\n\n"
            + formatBody()
    }
    function validate()
    {
        return true
    }
    function formatBody()
    {
        return [
            "Ahoy Sailors!",
            "",
            requestText.text,
            "",
            "Thank you,",
            "  " + fullName.text,
            "",
            "-- ",
            "------------------",
            "Name: " + fullName.text,
            "Email: " + orderMail.text,
            "Order: #" + orderNo.text,
            "------------------",
        ].join('\n')
    }
    function formatSubject()
    {
        return "#" + orderNo.text + "|" + typeBox.value + "|" + requestTitle.text
    }
    function submit()
    {
        Qt.openUrlExternally("mailto:shop@jolla.com?subject=JollaPhoneOrderChanges: "
            + encodeURIComponent( formatSubject())
            + "&body=" + encodeURIComponent( formatBody() )
        )
    }
    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: col.height
        Column {
            id: col
            width: parent.width - Theme.horizontalPageMargin
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.paddingLarge
            bottomPadding: Theme.itemSizeLarge
            PageHeader { id: head ; title: qsTr("Jolla Order Change Request") }

            TextField { id: orderNo
                label: qsTr("Order Number")
                placeholderText: "9999999"
                inputMethodHints: Qt.ImhDigitsOnly
                strictValidation: true
                acceptableInput: /[0-9]{4,}/.test(text)
                EnterKey.onClicked: orderMail.focus = true
            }
            TextField { id: orderMail
                label: qsTr("Order Email address")
                description: qsTr("Make sure to use the email address that received the order confirmation.")
                inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhNoAutoUppercase
                acceptableInput: /^\S+@\S+\.\S+$/.test(text)

                EnterKey.onClicked: fullName.focus = true
            }

            TextField { id: fullName
                label: qsTr("Full Name")
                acceptableInput: /^\S+ \S+$/.test(text)
                EnterKey.onClicked: { focus = false; typeBox.menu.open(typeBox); preview() }
            }


            ComboBox{ id: typeBox
                label: qsTr("Request Type")
                menu: ContextMenu {
                    MenuItem { text: qsTr("Other") }
                    MenuItem { text: qsTr("Delivery Address Change") }
                    MenuItem { text: qsTr("Item Change") }
                }

            }
            TextField { id: requestTitle
                label: qsTr("Request Title")
                description: qsTr("Describe your request briefly.")
                EnterKey.onClicked: { requestText.focus = true; preview() }
            }

            TextArea { id: requestText
                label: qsTr("Request")
                description: qsTr("Describe your issue or wishes. Try to be clear and to the point.")
                EnterKey.onClicked: { preview() }
                onFocusChanged: { if (!focus) preview() }
            }

            Separator { width: parent.width; color: Theme.primaryColor }
            SectionHeader { text: qsTr("Email Preview") }
            TextArea { id: previewField
                readOnly: true
                color: Theme.secondaryColor
                font.family: "monospace"
                font.pixelSize: Theme.fontSizeSmall
            }

        }
        /*
        PullDownMenu { id: pdm
            MenuItem { text: qsTr("About"); onClicked: { pageStack.push(Qt.resolvedUrl("AboutPage.qml")) } }
            MenuItem { text: qsTr("Settings"); onClicked: { pageStack.push(Qt.resolvedUrl("SettingsPage.qml")) } }
        }
        */
        PushUpMenu { id: pum
            quickSelect: false
            MenuItem  { text: qsTr("Submit")
                onClicked: {
                    validate()
                    submit()
                }
            }
        }

        VerticalScrollDecorator {}
    }
}

// vim: expandtab ts=4 st=4 sw=4 filetype=javascript syntax=qml
