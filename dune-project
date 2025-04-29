(lang dune 3.19)

(name blake3-mini)

(generate_opam_files true)

(license BSD-2-Clause)
(maintainers "Rudi Grinberg <me@rgrinberg.com>")
(authors "Rudi Grinberg <me@rgrinberg.com>" "Ali Caglayan <alizter@gmail.com>")
(source (github rgrinberg/ocaml-blake3-mini))

(implicit_transitive_deps false)

(package
 (synopsis "Blake3 Bindings without Rust dependencies")
 (description "Blake3 Bindings without Rust dependencies")
 (name blake3-mini)
 (depends
  base-unix
  (ppx_expect :with-test)))
