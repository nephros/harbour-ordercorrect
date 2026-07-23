/*
 * This file is part of OrderCorrect.
 * Copyright (c) 2026 Peter G. (nephros)
 * SPDX-License-Identifier: Apache-2.0
 */

import QtQuick 2.6
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0

Page { id: page

    allowedOrientations: Orientation.All
    property bool inputValid: false
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
            "~~~~ please do not edit anything below this line ~~~~",
            "------------------",
            "Name: .... " + fullName.text,
            "Email: ... " + orderMail.text,
            "Order: ... " + orderNo.text,
            "------------------",
            "Ref: ..... " + Qt.md5(orderMail.text + orderNo.text),
            "Stamp: ... " + Math.floor(stamp.value/1000),
            "Sequence:. " + attempts.value,
            "------------------",
            "Created by: "   + Qt.application.name + " " + Qt.application.version,
            "------------------",
        ].join('\n')
    }
    function formatSubject()
    {
        return "JollaPhoneOrderChanges|#" + orderNo.text + "|" + typeBox.nonLocalizedValue + "| " + requestTitle.text
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
    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: col.height
        Column {
            id: col
            width: parent.width - Theme.horizontalPageMargin
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.paddingSmall
            bottomPadding: Theme.itemSizeLarge

            PageHeader { id: head ; title: qsTr("Jolla Order Change Request") }

            Row {
                visible: (Date.now() - stamp.value) < mailThreshold
                Icon { id: warningIcon
                    source: "image://theme/icon-lock-warning?" + Theme.presenceColor(Theme.PresenceAway)
                    anchors.verticalCenter: spamWarning.verticalCenter
                }
                Label { id: spamWarning
                    width: parent.width - warningIcon
                    wrapMode: Text.Wrap
                    text: qsTr("Your last email was less than %1 hours ago.").arg(Math.floor(mailThreshold))
                         + "\n" + qsTr("Are you sure you need to send another one?")
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                }
            }
            Label {
                width: parent.width - Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.Wrap
                text: qsTr("Please enter the details of your order change request below.")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall
            }

            Separator { width: parent.width; color: Theme.highlightColor }

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
                Component.onDestruction: if(acceptableInput && !doNotSave) config.setValue("orderNo",  text )
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
                Component.onDestruction: if(acceptableInput && !doNotSave) config.setValue("orderEmail", text )
            }

            TextField { id: fullName
                label: qsTr("Full Name")
                acceptableInput: /^\S{2,} \S{2,}/.test(text)
                EnterKey.onClicked: { focus = false; typeBox.menu.open(typeBox); preview() }
                Component.onCompleted: {
                    var val =  config.value("fullName", "unset")
                    if (val !== "unset") text = val
                }
                Component.onDestruction: if(acceptableInput && !doNotSave) config.setValue("fullName", text )
            }


            ComboBox{ id: typeBox
                label: qsTr("Request Type")
                //property string nonLocalizedValue: { var i = currentItem; return i.nonLocalizedValue }
                property string nonLocalizedValue: currentItem.nonLocalizedValue
                menu: ContextMenu {
                    MenuItem { text: qsTr("Other");                   readonly property string nonLocalizedValue: "other" }
                    MenuItem { text: qsTr("Delivery Address Change"); readonly property string nonLocalizedValue: "address-change"}
                    MenuItem { text: qsTr("Order/Item Change");       readonly property string nonLocalizedValue: "order-change"}
                    MenuItem { text: qsTr("Payment/Refund/VAT");      readonly property string nonLocalizedValue: "payment" }
                }
            }
            TextField { id: requestTitle
                text: ""
                label: qsTr("Request Title (optional)")
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

        PullDownMenu { id: pdm
            MenuItem { text: qsTr("Delete personal information"); onClicked: { config.clear(); config.sync() } }
            MenuItem { text: qsTr("Copy Subject to Clipboard"); onClicked: { if (validate()) Clipboard.text = formatSubject() } }
            MenuItem { text: qsTr("Copy Body to Clipboard"); onClicked: {    if (validate())  Clipboard.text = formatBody()  } }
        }

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
    /*
     * ***** WELCOME DIALOG *****
     *
     * show a welcome popup on launch
     */
    property bool welcomeShown: false
    onStatusChanged: {
        if (status == PageStatus.Active) showWelcomeDialog();
    }
    function showWelcomeDialog() {
        if (welcomeShown) return;
        var dialog = pageStack.push(welcome)
        dialog.done.connect(function() { page.welcomeShown = true; })
    }

    Component { id: welcome
        Dialog {
            allowedOrientations: Orientation.All

            canAccept: false
            forwardNavigation: false
            SilicaFlickable {
                anchors.fill: parent
                contentHeight: content.height
                Column { id: content
                    width: parent.width
                    spacing: Theme.paddingLarge
                    DialogHeader {
                        title: qsTr("Welcome")
                        cancelText: qsTr("Dismiss")
                        acceptText: ""
                    }
                    Label {
                        width:  parent.width - Theme.horizontalPageMargin
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: Theme.secondaryHighlightColor
                        font.pixelSize: Theme.fontSizeSmall
                        wrapMode: Text.WordWrap
                        text: qsTr('Welcome to the unofficial Sailfish OS order change request tool.')
                    }
                    Label {
                        width:  parent.width - Theme.horizontalPageMargin
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignJustify
                        color: Theme.secondaryHighlightColor
                        font.pixelSize: Theme.fontSizeSmall
                        wrapMode: Text.Wrap
                        text: qsTr("Please enter the details of your order change on the main page.")
                             + "\n" + qsTr("After you're finished, scroll down to review the email text, and use the PullUp menu at the bottom to submit.")
                             + "\n" + qsTr("Submitting will not send anything, but open your email app.")
                             + "\n" + qsTr("Final sending must be done from the email app. Please leave the subject line, and the bottom (after the signature) intact.")
                    }
                    Label {
                        width:  parent.width - Theme.horizontalPageMargin
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: Theme.secondaryHighlightColor
                        font.pixelSize: Theme.fontSizeSmall
                        horizontalAlignment: Text.AlignJustify
                        wrapMode: Text.WordWrap
                        text: qsTr('Notice: Even though %1 offers localized versions, please keep your communication in English if at all possible.').arg(Qt.application.name)
                    }

                    IconTextSwitch {
                        text: qsTr("Save Basic Information")
                        icon.source: "image://theme/icon-m-incognito"
                        description: qsTr("For your convenience, order number, name, and email address are saved and will be loaded on the next app launch.")
                             + "\n" + qsTr("If you do not want this, disable this switch.")
                        checked: !doNotSave
                        onCheckedChanged: { doNotSave.value = !checked; }
                    }


                }
            }
        }
    }
    /* END WELCOME DIALOG */
}

// vim: expandtab ts=4 st=4 sw=4 filetype=javascript syntax=qml
