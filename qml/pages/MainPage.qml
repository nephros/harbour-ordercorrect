/*
 * This file is part of OrderCorrect.
 * Copyright (c) 2026 Peter G. (nephros)
 * SPDX-License-Identifier: Apache-2.0
 */

import QtQuick 2.6
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0
import Nemo.Configuration 1.0

Page { id: page

    allowedOrientations: Orientation.All
    property bool inputValid: false
    property bool saveInput: config.value("disabled", false) == true
    function preview() {
        previewField.text = "Subject: " + formatSubject()
            + "\n\n\n"
            + formatBody()
    }
    function validate()
    {
        var ok =
               ((orderNo.text.length > 0)    && orderNo.acceptableInput)
            && ((orderMail.text.length > 0)  && orderMail.acceptableInput)
            && ((fullName.text.length > 0)   && fullName.acceptableInput)
            && (requestTitle.text.length > 0)
            && (requestText.text.length > 0)
        if (!ok) popup.publish()
        return ok
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
            "Name: .... " + fullName.text,
            "Email: ... " + orderMail.text,
            "Order: ... " + orderNo.text,
            "------------------",
            "Ref: ..... " + Qt.md5(orderMail.text + orderNo.text),
            "------------------",
        ].join('\n')
    }
    function formatSubject()
    {
        return "JollaPhoneOrderChanges|#" + orderNo.text + "|" + typeBox.value + "| " + requestTitle.text
    }
    function submit()
    {
        app.sendMail( formatSubject(), formatBody(), orderMail.text )
    }

    Notification { id: popup
        isTransient: true
        urgency: Notification.Critical
        body: qsTr("Some of the required fields are invalid or empty!")
         + " " + qsTr("Please Check your input")
    }

    ConfigurationGroup { id: config
        path: "/" + Qt.application.organization + "/" + Qt.application.name + "/user"
        Component.onDestruction: if(!saveInput) { clear(); sync(); setValue("disabled", true); }
    }

    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: col.height
        Column {
            id: col
            width: parent.width - Theme.horizontalPageMargin
            anchors.horizontalCenter: parent.horizontalCenter
            //spacing: Theme.paddingLarge
            bottomPadding: Theme.itemSizeLarge
            PageHeader { id: head ; title: qsTr("Jolla Order Change Request") }

            Label {
                width: parent.width - Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.Wrap
                text: qsTr("Please enter the details of your order change request below.")
                     + "\n" + qsTr("After you're finished, scroll down to review the email text, and use the PullUp menu at the bottom to submit.")
                     + "\n" + qsTr("Submitting will not send anything, but open your email app.")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall
            }

            TextSwitch {
                text: qsTr("Save Input")
                description: qsTr("For your convenience, order number, name, and email are saved and will be loaded on the next app launch.")
                     + "\n" + qsTr("If you do not want this, disable this switch.")
                checked: saveInput
                //automaticCheck: false
                //onClicked: { saveInput = !saveInput }
                onCheckedChanged: { saveInout = checked; config.setValue("disabled", !checked ) }
            }

            TextField { id: orderNo
                label: qsTr("Order Number")
                inputMethodHints: Qt.ImhDigitsOnly
                strictValidation: true
                acceptableInput: /^[0-9]{4,}$/.test(text)
                EnterKey.onClicked: orderMail.focus = true
                Component.onCompleted: {
                    var val =  config.value("orderNo", "unset")
                    if (val !== "unset") text = val
                }
                Component.onDestruction: if(acceptableInput && saveInput) config.setValue("orderNo",  text )
            }
            TextField { id: orderMail
                label: qsTr("Order Email address")
                description: qsTr("Make sure to use the email address that received the order confirmation.")
                inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhNoAutoUppercase
                acceptableInput: /^\S+@\S+\.\S+$/.test(text)

                EnterKey.onClicked: fullName.focus = true
                Component.onCompleted: {
                    var val =  config.value("orderEmail", "unset")
                    if (val !== "unset") text = val
                }
                Component.onDestruction: if(acceptableInput && saveInput) config.setValue("orderEmail", text )
            }

            TextField { id: fullName
                label: qsTr("Full Name")
                acceptableInput: /^\S{2,} \S{2,}/.test(text)
                EnterKey.onClicked: { focus = false; typeBox.menu.open(typeBox); preview() }
                Component.onCompleted: {
                    var val =  config.value("fullName", "unset")
                    if (val !== "unset") text = val
                }
                Component.onDestruction: if(acceptableInput && saveInput) config.setValue("fullName", text )
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
                    validate() && submit()
                }
            }
        }

        VerticalScrollDecorator {}
    }
}

// vim: expandtab ts=4 st=4 sw=4 filetype=javascript syntax=qml
