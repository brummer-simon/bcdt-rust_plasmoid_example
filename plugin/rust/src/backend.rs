// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
// Author: Simon Brummer (simon.brummer@posteo.de)
// Description: Implementation of the Rust backend.

#[cxx_qt::bridge(cxx_file_stem = "rust_backend", namespace = "rust")]
pub mod backend {
    #[cxx_qt::qobject]
    pub struct Backend {
        #[qproperty]
        number: i32,
    }

    impl Default for Backend {
        fn default() -> Self {
            Self { number: 0 }
        }
    }

    impl qobject::Backend {
        #[qinvokable]
        pub fn increment_number(self: Pin<&mut Self>) {
            let value = *self.number();
            self.set_number(value + 1);
        }
    }
}
