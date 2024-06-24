fn main() {
    cxx_build::bridge("src/lib.rs").compile("rust_backend_example_plugin_impl");

    println!("cargo:rerun-if-changed=src/lib.rs");
}
