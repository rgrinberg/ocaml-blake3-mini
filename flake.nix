{
  description = "ocaml-blake3-mini Nix Flake";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.dune.url = "github:alizter/dune/foreign_objects";

  outputs = { self, nixpkgs, flake-utils, dune }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs =
      nixpkgs.legacyPackages.${system}.appendOverlays [
        (self: super: {
          ocamlPackages = super.ocaml-ng.ocamlPackages.overrideScope (oself: osuper: {
            dune_3 = dune.packages.${system}.default;
          });
        })
      ];

    inherit (pkgs.ocamlPackages) buildDunePackage;
  in
  rec {
    packages = rec {
      default = ocaml-blake3-mini;
      ocaml-blake3-mini = buildDunePackage {
        pname = "ocaml-blake3-mini";
        version = "n/a";
        src = ./.;
        duneVersion = "3";
        propagatedBuildInputs = [];
        checkInputs = with pkgs.ocamlPackages; [
          ppx_inline_test
          ppx_expect
        ];
        doCheck = true;
      };
    };
    devShells.default = pkgs.mkShell {
      inputsFrom = pkgs.lib.attrValues packages;
      buildInputs = with pkgs.ocamlPackages; [
        pkgs.ccls
        pkgs.ocamlformat
        ocaml-lsp
      ];
    };
  });
}
