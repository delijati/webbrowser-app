/*
 * Copyright 2015 Canonical Ltd.
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
import QtTest 1.0
import "../../../src/app/webbrowser"
import webbrowserapp.private 0.1

Item {
    id: root

    width: 300
    height: 500

    BookmarksView {
        id: view
        anchors.fill: parent
        homepageUrl: "http://example.com/homepage"
    }

    SignalSpy {
        id: bookmarkEntryClickedSpy
        target: view
        signalName: "bookmarkEntryClicked"
    }

    SignalSpy {
        id: doneSpy
        target: view
        signalName: "done"
    }

    SignalSpy {
        id: newTabClickedSpy
        target: view
        signalName: "newTabClicked"
    }

    WebbrowserTestCase {
        name: "BookmarksView"
        when: windowShown

        function init() {
            BookmarksModel.databasePath = ":memory:"
            populate()
            view.forceActiveFocus()
            compare(bookmarkEntryClickedSpy.count, 0)
            compare(doneSpy.count, 0)
            compare(newTabClickedSpy.count, 0)
        }

        function populate() {
            BookmarksModel.add("http://example.com", "Example", "", "")
            BookmarksModel.add("http://example.org/a", "Example a", "", "FolderA")
            BookmarksModel.add("http://example.org/b", "Example b", "", "FolderB")
            compare(BookmarksModel.count, 3)
        }

        function cleanup() {
            BookmarksModel.databasePath = ""
            bookmarkEntryClickedSpy.clear()
            doneSpy.clear()
            newTabClickedSpy.clear()
        }

        function test_done() {
            var button = findChild(view, "doneButton")
            clickItem(button)
            compare(doneSpy.count, 1)
        }

        function test_new_tab() {
            var action = findChild(view, "newTabAction")
            clickItem(action)
            compare(newTabClickedSpy.count, 1)
        }

        function test_click_bookmark() {
            var items = getListItems(findChild(view, "bookmarksFolderListView"),
                                     "bookmarkFolderDelegateLoader")

            clickItem(findChild(items[0], "urlDelegate_0"))
            compare(bookmarkEntryClickedSpy.count, 1)
            compare(bookmarkEntryClickedSpy.signalArguments[0][0], view.homepageUrl)

            clickItem(findChild(items[0], "urlDelegate_1"))
            compare(bookmarkEntryClickedSpy.count, 2)
            compare(bookmarkEntryClickedSpy.signalArguments[1][0], "http://example.com")
        }

        function test_delete_bookmark() {
            var items = getListItems(findChild(view, "bookmarksFolderListView"),
                                     "bookmarkFolderDelegateLoader")
            var bookmark = findChild(items[0], "urlDelegate_1")
            swipeToDeleteAndConfirm(bookmark)
            tryCompare(BookmarksModel, "count", 2)
        }
    }
}