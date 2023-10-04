# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Author: Simon Brummer (simon.brummer@posteo.de)
# Description: CMake file building the QML Plugin.

# Rust backend build via Corrosion. The crate generates the QML Interfaces.
set(CRATE rust_backend)
set(CRATE_ARTIFACT ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${CRATE}.so)

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

corrosion_import_crate(MANIFEST_PATH Cargo.toml CRATES ${CRATE})
corrosion_set_env_vars(${CRATE}
    "QMAKE=${QMAKE}"
)

# Specify Plugin install path.
# NOTE: The paths must match the module path specified in plugin/qmldir!
install(FILES ${CRATE_ARTIFACT} DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/plasma/private/rust/backend)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/plasma/private/rust/backend)
