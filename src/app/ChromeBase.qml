/*
 * Copyright 2014-2016 Canonical Ltd.
 *
 * This file is part of webbrowser-app.
 *
 * webbrowser-app is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * webbrowser-app is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3

// use styled item otherwise Drawer button will steal focus from the AddressBar
StyledItem {
    id: chrome

    objectName: "chromeBase"

    property alias backgroundColor: backgroundRect.color

    property alias loading: progressBar.visible
    property alias loadProgress: progressBar.value

    states: [
        State {
            name: "shown"
            when: chrome.y == 0
        }
    ]

    Rectangle {
        id: backgroundRect

        anchors.fill: parent
        color: Theme.palette.normal.background

        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            height: units.dp(1)
            color: "#dedede"
        }
    }

    ThinProgressBar {
        id: progressBar

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        objectName: "chromeProgressBar"

        z: 2
    }
}
