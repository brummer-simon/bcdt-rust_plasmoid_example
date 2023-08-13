# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Author: Simon Brummer (simon.brummer@posteo.de)
# Description: CMake file building the QML Plugin.

# Rust backend build via Corrosion. The crate generates the QML Interfaces.
set(CRATE rust-backend)

find_package(Qt5 5.15 COMPONENTS Core Gui Qml QuickControls2 QmlImportScanner REQUIRED)
find_package(Corrosion QUIET)
if(NOT Corrosion_FOUND)
    include(FetchContent)
    FetchContent_Declare(
        Corrosion
        GIT_REPOSITORY https://github.com/corrosion-rs/corrosion.git
        GIT_TAG v0.4.2
    )

    FetchContent_MakeAvailable(Corrosion)
endif()

# Note: Pass QMake to the crate to ensure that the Rust - Qt interface is
# built with the same QMake version.
get_target_property(QMAKE Qt::qmake IMPORTED_LOCATION)
set(CXXQT_EXPORT_DIR "${CMAKE_CURRENT_BINARY_DIR}/cxxqt")

corrosion_import_crate(MANIFEST_PATH rust/Cargo.toml CRATES ${CRATE})
corrosion_set_env_vars(${CRATE}
    "CXXQT_EXPORT_DIR=${CXXQT_EXPORT_DIR}"
    "QMAKE=${QMAKE}"
)

add_library(${CRATE}_lib INTERFACE)
target_include_directories(${CRATE}_lib INTERFACE "${CXXQT_EXPORT_DIR}/${CRATE}")
target_link_libraries(${CRATE}_lib INTERFACE
    "$<LINK_LIBRARY:WHOLE_ARCHIVE,${CRATE}-static>"
    Qt5::Core
    Qt5::Gui
    Qt5::Qml
)

# Build QML Plugin and link Rust backend against it.
add_library(plugin SHARED plugin.cpp)
target_link_libraries(plugin
    ${CRATE}_lib
    Qt5::Gui
    Qt5::Qml
)

# Specify Plugin install path.
# NOTE: The paths must match the module path specified in plugin/qmldir!
install(TARGETS plugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/plasma/private/rust/backend)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/plasma/private/rust/backend)
