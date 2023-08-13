// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
// Author: Simon Brummer (simon.brummer@posteo.de)
// Description: The QML Plugin glue code implementation.

#include "plugin.hpp"

// Qt headers
#include <QtGlobal>
#include <QJSEngine>
#include <QQmlEngine>

// Generate Rust - QT interface headers
#include "cxx-qt-gen/rust_backend.cxxqt.h"

namespace
{
// URI must match the module definition in "plugin/qmldir"
const auto expectedModuleUri = QString::fromUtf8("org.kde.plasma.private.rust.backend");
}

void Plugin::registerTypes(const char* uri)
{
    // Ensure that given module uri meets our expectation
    Q_ASSERT(expectedModuleUri == QString::fromUtf8(uri));

    // Note: The according to the KDE documentation, the QML interpreter
    // is taking the ownership of the backend instance. Passing a raw pointer
    // is supposedly fine.
    auto func = [](QQmlEngine *, QJSEngine *) -> QObject * {
        return new rust::Backend{};
    };
    qmlRegisterSingletonType<rust::Backend>(uri, 1, 0, "Backend", func);
}
