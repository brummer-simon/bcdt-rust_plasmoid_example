# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Author: Simon Brummer (simon.brummer@posteo.de)

cmake_minimum_required(VERSION 3.24)

project(plasma_rust_backend)

set(KF6_MIN_VERSION "6.1.0")
set(QT6_MIN_VERSION "6.6.0")

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(FeatureSummary)
include(ECMFeatureSummary)

find_package(Corrosion REQUIRED)
find_package(Plasma REQUIRED)
find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS
    KCMUtils
    Config
)
find_package(Qt6 ${QT6_MIN_VERSION} CONFIG REQUIRED COMPONENTS
    Qml
    Gui
    Quick
    Core
)

# Project properties
set(PLASMOID_NAME        "bcdt.rust_backend_example")

set(PLUGIN_NAME          "plugin")
set(PLUGIN_URI           "${PLASMOID_NAME}")
set(PLUGIN_DIR           "${CMAKE_SOURCE_DIR}/${PLUGIN_NAME}/cpp")
set(PLUGIN_SOURCE_DIR    "${PLUGIN_DIR}/src")
set(PLUGIN_ARTIFACT_QML  "${PLUGIN_DIR}/qmldir")
set(PLUGIN_ARTIFACT      "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${PLUGIN_NAME}.so")
set(PLUGIN_INSTALL_DIR   "${KDE_INSTALL_QMLDIR}/bcdt/rust_backend_example")

set(BINDINGS_NAME        "cxxbridge_autogen")
set(BINDINGS_DIR         "${CMAKE_BINARY_DIR}/${BINDINGS_NAME}")
set(BINDINGS_INCLUDE_DIR "${BINDINGS_DIR}/include/cxxbridge")
set(BINDINGS_SOURCE_DIR  "${BINDINGS_DIR}/src")

set(CRATE_NAME           "plugin_impl")
set(CRATE_SOURCE_DIR     "${CMAKE_SOURCE_DIR}/plugin/rust/src")

if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    set(CRATE_PROFILE    "dev")
elseif(${CMAKE_BUILD_TYPE} STREQUAL "Release")
    set(CRATE_PROFILE    "release")
else()
    message(FATAL_ERROR "Unsupported build type ${CMAKE_BUILD_TYPE}" )
endif()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Rust <-> CPP binding targets
find_program(
    CXXBRIDGE cxxbridge REQUIRED
)

add_custom_target(
    ${BINDINGS_NAME}
    COMMAND rm -rf   ${BINDINGS_DIR}
    COMMAND mkdir -p ${BINDINGS_INCLUDE_DIR}
    COMMAND mkdir -p ${BINDINGS_SOURCE_DIR}
    COMMAND "${CXXBRIDGE}" "${CRATE_SOURCE_DIR}/backend.rs" --header --output "${BINDINGS_INCLUDE_DIR}/backend.rs.hpp"
    COMMAND "${CXXBRIDGE}" "${CRATE_SOURCE_DIR}/backend.rs"          --output "${BINDINGS_SOURCE_DIR}/backend.rs.cpp"
    BYPRODUCTS "${BINDINGS_SOURCE_DIR}/backend.rs.cpp"
)

# Plugin (Rust part) target

corrosion_import_crate(
    MANIFEST_PATH plugin/rust/Cargo.toml
    CRATES ${CRATE_NAME}
    PROFILE ${CRATE_PROFILE}
)

# Plugin (C++ part) target
add_library(
    ${PLUGIN_NAME}
    SHARED
        ${PLUGIN_SOURCE_DIR}/BackendProxy.cpp
        ${PLUGIN_SOURCE_DIR}/Plugin.cpp
        ${BINDINGS_SOURCE_DIR}/backend.rs.cpp
)

target_compile_definitions(
    ${PLUGIN_NAME}
    PRIVATE
        PLUGIN_URI="${PLUGIN_URI}"
)

target_include_directories(
    ${PLUGIN_NAME}
    PRIVATE
        "${BINDINGS_DIR}/include"
        "${PLUGIN_DIR}/include"
)

target_link_libraries(
    ${PLUGIN_NAME}
    ${CRATE_NAME}
    Qt6::Core
    Qt6::Qml
)

# Deployment
plasma_install_package(package ${PLASMOID_NAME})
install(FILES ${PLUGIN_ARTIFACT_QML} DESTINATION ${PLUGIN_INSTALL_DIR})
install(FILES ${PLUGIN_ARTIFACT}     DESTINATION ${PLUGIN_INSTALL_DIR})

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
ecm_feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
