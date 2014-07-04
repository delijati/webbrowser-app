/*
 * Copyright 2014 Canonical Ltd.
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

import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import webbrowserapp.private 0.1

Item {
    id: newTabView

    property QtObject bookmarksModel
    property QtObject historyModel

    signal bookmarkClicked(url url)
    signal historyEntryClicked(url url)

    QtObject {
        id: internal

        property int bookmarksCountLimit: 5
        property bool seeMoreBookmarksView: false
    }

    ListModel {
        id: sectionsModel

        Component.onCompleted: {
            if (bookmarksListModel && bookmarksListModel.count !== 0)
                sectionsModel.append({ section: "bookmarks" });
            if (historyListModel && historyListModel.count !== 0 && !internal.seeMoreBookmarksView )
                sectionsModel.append({ section: "topsites" });
        }
    }

    LimitProxyModel {
        id: bookmarksListModel

        sourceModel: newTabView.bookmarksModel

        limit: internal.seeMoreBookmarksView ? -1 : internal.bookmarksCountLimit
    }

    LimitProxyModel {
        id: historyListModel

        sourceModel: HistoryByVisitsModel {
            sourceModel: HistoryTimeframeModel {
                sourceModel: newTabView.historyModel
                // We only show sites visited on the last 60 days
                start: {
                    var date = new Date()
                    date.setDate(date.getDate() - 60)
                    return date
                }
                end: new Date()
            }
        }

        limit: 10
    }

    Rectangle {
        id: newTabBackground
        anchors.fill: parent
        color: "white"
    }

    ListView {
        id: newTabListView
        anchors.fill: parent

        model: sectionsModel

        delegate: Loader {
            anchors {
                left: parent.left
                right: parent.right
                margins: units.gu(2)
            }

            width: parent.width
            height: children.height

            sourceComponent: modelData == "bookmarks" ? bookmarksComponent : topSitesComponent
        }

        section.property: "section"
        section.delegate: Rectangle {
            anchors {
                left: parent.left
                right: parent.right
            }

            height: sectionHeader.height + units.gu(1)

            opacity: section == "topsites" && internal.seeMoreBookmarksView ? 0.0 : 1.0

            color: newTabBackground.color

            Behavior on opacity { UbuntuNumberAnimation {} }

            ListItem.Header {
                id: sectionHeader

                text: {
                    if (section == "bookmarks") {
                        return i18n.tr("Bookmarks")
                    } else if (section == "topsites") {
                        return i18n.tr("Top sites")
                    }
                }
            }
        }

        section.labelPositioning: ViewSection.InlineLabels | ViewSection.CurrentLabelAtStart
    }

    Component {
        id: bookmarksComponent

        BookmarksList {
            width: parent.width

            model: bookmarksListModel

            footerLabelText: internal.seeMoreBookmarksView ? i18n.tr("see less") : i18n.tr("see more")
            footerLabelVisible: bookmarksListModel.unlimitedCount > internal.bookmarksCountLimit

            onBookmarkClicked: newTabView.bookmarkClicked(url)
            onFooterLabelClicked: internal.seeMoreBookmarksView = !internal.seeMoreBookmarksView
        }
    }

    Component {
        id: topSitesComponent

        Flow {
            width: parent.width

            spacing: units.gu(1)

            opacity: internal.seeMoreBookmarksView ? 0.0 : 1.0

            Behavior on opacity { UbuntuNumberAnimation {} }

            Repeater {
                model: parent.opacity == 0.0 ? "" : historyListModel

                delegate: PageDelegate{
                    width: units.gu(18)
                    height: units.gu(25)

                    url: model.url
                    label: model.title ? model.title : model.url

                    onClicked: historyEntryClicked(model.url)
                }
            }
        }
    }
}
