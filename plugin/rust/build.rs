// TODO: Rename bindings crate

fn main() {
    let binding_files = vec!["src/backend.rs"];

    cxx_build::CFG.doxygen = true;
    cxx_build::CFG.include_prefix = "rust";
    cxx_build::bridges(binding_files).compile("plugin_impl");
}
