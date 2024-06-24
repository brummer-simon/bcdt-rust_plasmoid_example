// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
// Author: Simon Brummer (simon.brummer@posteo.de)
// Description: Rust backend library entry point

use qmetaobject::{prelude::*, qml_register_singleton_type, QSingletonInit};
use std::ffi::{CStr, CString};

#[derive(Default, QObject)]
struct QmlPlugin {
    base: qt_base_class!(trait QQmlExtensionPlugin),
    plugin: qt_plugin!("org.qt-project.Qt.QQmlExtensionInterface"),
}

impl QQmlExtensionPlugin for QmlPlugin {
    fn register_types(&mut self, uri: &CStr) {
        let expected_uri = CString::new("org.kde.plasma.private.rust_backend_example_plugin").unwrap();
        if expected_uri.as_c_str() != uri {
            panic!(
                "Error: Module URI is unexpected. Expected URI: {}, actual URI: {}",
                expected_uri.to_str().unwrap(),
                uri.to_str().unwrap()
            );
        }

        let qml_name = CString::new("Backend").unwrap();
        qml_register_singleton_type::<Backend>(uri, 1, 0, qml_name.as_c_str());

        // Delegate QML logs to log 
        qmetaobject::log::init_qt_to_rust();
    }
}

#[allow(non_snake_case)]
#[derive(Default, QObject)]
pub struct Backend {
    // Define "base" - class
    base: qt_base_class!(trait QObject),

    // Properties
    number: qt_property!(i32; NOTIFY numberChanged),
    numberChanged: qt_signal!(),

    // Examples
    incrementNumber: qt_method!(fn(&mut self) -> ()),
}

impl Backend {
    #[allow(non_snake_case)]
    pub fn incrementNumber(&mut self) {
        self.number += 1;
        self.numberChanged();
    }
}

impl QSingletonInit for Backend {
    fn init(&mut self) {
    }
}
