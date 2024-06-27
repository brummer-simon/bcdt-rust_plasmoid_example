// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
// Author: Simon Brummer (simon.brummer@posteo.de)
// Description: Rust backend library entry point

#[cxx::bridge(namespace = "rust")]
mod ffi {
    extern "Rust" {
        type Backend;

        fn number(&self) -> i32;
        fn set_number(&mut self, number: i32);
        fn increment_number(&mut self);

        fn make_backend() -> Box<Backend>;
    }
}

#[derive(Default)]
pub struct Backend {
    number: i32,
}

impl Backend {
    pub fn number(&self) -> i32 {
        self.number
    }

    pub fn set_number(&mut self, number: i32) {
        self.number = number
    }

    pub fn increment_number(&mut self) {
        self.set_number(self.number + 1)
    }
}

pub fn make_backend() -> Box<Backend> {
    Box::<Backend>::default()
}

