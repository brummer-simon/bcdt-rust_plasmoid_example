# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Author: Simon Brummer (simon.brummer@posteo.de)
# Description: CMake file building the entire project.

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

# Install plasmoid
plasma_install_package(package org.kde.plasma.rust_backend.example)

# Install qml plugin
#add_subdirectory(plugin)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
ecm_feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
