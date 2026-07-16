// Copyright (c) 2026 Peter G. (nephros)
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.6
import Sailfish.Silica 1.0

CoverBackground {
    id: coverPage

    CoverPlaceholder {
        text: Qt.application.name
        textColor: Theme.highlightColor
        icon.source: "image://theme/icon-m-sailfishos"
    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4 syntax=qml
