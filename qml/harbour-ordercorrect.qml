/*
 * SPDX-License-Identifier: Apache-2.0
 *
 * Copyright (c) 2026 Peter G. (nephros)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import QtQuick 2.6
import Sailfish.Silica 1.0
import Nemo.DBus 2.0
import Nemo.Configuration 1.0
import "pages"
import "cover"

ApplicationWindow {
    id: app

    allowedOrientations: Orientation.All

    property bool saveInput: privacy ? false : saveData.value

    Component.onCompleted: {
        console.info("Initialized", Qt.application.name, "version", Qt.application.version, "by", Qt.application.organization );
        //console.debug("Parameters: " + Qt.application.arguments.join(" "))
    }

    initialPage: Component { MainPage{} }
    cover: CoverPage{}

    ConfigurationValue { id: attempts
        key: "/" + Qt.application.organization + "/" + Qt.application.name + "/count"
        defaultValue: 0
    }

    ConfigurationValue { id: stamp
        key: "/" + Qt.application.organization + "/" + Qt.application.name + "/stamp"
        defaultValue: -1
    }
    ConfigurationValue { id: saveData
        key: "/" + Qt.application.organization + "/" + Qt.application.name + "/saveData"
        defaultValue: true
    }
    ConfigurationGroup { id: config
        path: "/" + Qt.application.organization + "/" + Qt.application.name + "/user"
        Component.onDestruction: if(!saveInput) { clear(); sync(); }
    }

    DBusInterface { id: email
        service: "com.jolla.email.ui"
        path: "/com/jolla/email/ui"
        iface: "com.jolla.email.ui"
    }
    function checkSpam() {
        return false // needs testing
        const cutoff = 1000 * 60 * 60 * 6 // h
        var now = Date.now()
        if (stamp.value != -1) {
            if (now - stamp.value < cutoff) {
                console.warn("Spamming?", now, stamp)
                pageStack.replaceAbove(null, spammerPage, { "last": stamp.value } )
                return true
            }
        }
        return false
    }
    function sendMail(subject, body, cc) {
            if (checkSpam()) return
            email.call("compose", [ // sssss
                subject, // subject:
                '"Jolla Shop" <shop@jolla.com>"', // to:
                !!cc ? cc : "", // cc:
                "", // bcc:
                body,
            ],
                function(r) { if(!!r) console.debug("Email:", r); stamp.value = Date.now(); attempts.value += 1 },
                function(e,m) {console.warn("Could not activate jolla-email:", e, m, "- Falling back to URL.")
                    if ( e == "org.freedesktop.DBus.Error.ServiceUnknown") { //fallback
                        Qt.openUrlExternally("mailto:shop@jolla.com?"
                            + (!!cc ? ("cc=" + cc) : "")
                            + "&subject=" + encodeURIComponent(subject)
                            + "&body=" + encodeURI(body)
                        )
                        stamp.value = Date.now()
                    }
                }
            )

        }
    property bool privacy: false
    DBusInterface {
        service: "org.sailfishos.privacyswitch"
        path: "/privacyswitch"
        iface: "org.sailfishos.privacyswitch"
        Component.onCompleted: {
            call("privacyModeActive" , [],
                function(r) { privacy = r },
                function(e,m) {console.warn("Could determine switch state:", e, m)}
            )
        }
    }
    Page { id: spammerPage
        property int last
        Label {
            anchors.centerIn: parent
            text: qsTr("It looks like you're sending a lot of emails.")
             + "\n" + qsTr("Maybe give it a break...")
        }
    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4 syntax=qml
