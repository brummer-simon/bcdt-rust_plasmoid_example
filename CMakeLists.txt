# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Author: Simon Brummer (simon.brummer@posteo.de)
# Description: CMake file building the entire project.

# TODO: centralize paths???
cmake_minimum_required(VERSION 3.24)

project(plasma_rust_backend)

set(KF6_MIN_VERSION "6.1.0")
set(QT6_MIN_VERSION "6.6.0")

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(FeatureSummary)
include(ECMFeatureSummary)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
ecm_feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)

find_package(Plasma REQUIRED)

find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS
    Config
    KCMUtils
    I18n
)

find_package(Qt6 ${QT6_MIN_VERSION} CONFIG REQUIRED COMPONENTS
    Qml
    Gui
    Quick
    Core
)

find_package(Corrosion REQUIRED)

# Build rust based qml plugin
set(CRATE rust_backend_example_plugin)
set(CRATE_ARTIFACT ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${CRATE}.so)
set(PLUGIN_INSTALL_DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/plasma/private/rust_backend_example)

get_target_property(QMAKE Qt6::qmake IMPORTED_LOCATION)

corrosion_import_crate(
    MANIFEST_PATH plugin/Cargo.toml
    CRATE_TYPES cdylib
    CRATES ${CRATE}
)

corrosion_set_env_vars(${CRATE}
    "QMAKE=${QMAKE}"
)

# Installation paths
plasma_install_package(package org.kde.plasma.rust_backend_example)
install(FILES ${CRATE_ARTIFACT} DESTINATION ${PLUGIN_INSTALL_DESTINATION})
install(FILES plugin/qmldir DESTINATION ${PLUGIN_INSTALL_DESTINATION})
