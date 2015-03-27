/*
 * Copyright 2013-2015 Canonical Ltd.
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

// local
#include "settings.h"
#include "config.h"

// Qt
#include <QtCore/QSettings>

Settings::Settings(QObject* parent)
    : QObject(parent)
{
    QSettings settings(QCoreApplication::applicationName(), "settings");
    m_homepage = settings.value("homepage", QUrl(DEFAULT_HOMEPAGE)).toUrl();
    m_searchengine = settings.value("searchengine", QString(DEFAULT_SEARCH_ENGINE)).toString();
    m_allowOpenInBackgroundTab = settings.value("allowOpenInBackgroundTab", "default").toString().toLower();
    m_restoreSession = settings.value("restoreSession", true).toBool();
}

const QUrl& Settings::homepage() const
{
    return m_homepage;
}

const QString& Settings::searchEngine() const
{
    return m_searchengine;
}

const QString& Settings::allowOpenInBackgroundTab() const
{
    return m_allowOpenInBackgroundTab;
}

bool Settings::restoreSession() const
{
    return m_restoreSession;
}
