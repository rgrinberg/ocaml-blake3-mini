{
  description = "ocaml-blake3-mini Nix Flake";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.dune.url = "github:ocaml/dune";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      dune,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        applyDuneOverride =
          ocamlPackages_set:
          ocamlPackages_set.overrideScope (oself: osuper: { dune_3 = dune.packages.${system}.default; });

        buildMyPackage =
          { ocamlPackages }:
          ocamlPackages.buildDunePackage {
            pname = "ocaml-blake3-mini";
            version = "n/a";
            src = ./.;
            duneVersion = "3";
            propagatedBuildInputs = [ ];
            checkInputs = with ocamlPackages; [
              ppx_inline_test
              ppx_expect
            ];
            doCheck = true;
          };

        setupDevShell =
          { pkgs, ocamlPackages }:
          pkgs.mkShell {
            inputsFrom = [ (buildMyPackage { inherit ocamlPackages; }) ];
            buildInputs = with ocamlPackages; [
              ocaml-lsp
              ocamlformat
              pkgs.ccls
            ];
          };

      in
      {
        packages = rec {
          default = buildMyPackage {
            ocamlPackages = applyDuneOverride pkgs.ocamlPackages;
          };
          ocaml-blake3-mini = default;
        };

        devShells = {
          default = setupDevShell {
            inherit pkgs;
            ocamlPackages = applyDuneOverride pkgs.ocamlPackages;
          };

          ocaml_4_14 = setupDevShell {
            inherit pkgs;
            ocamlPackages = applyDuneOverride pkgs.ocaml-ng.ocamlPackages_4_14;
          };

          ocaml_4_08 = setupDevShell {
            inherit pkgs;
            ocamlPackages = applyDuneOverride pkgs.ocaml-ng.ocamlPackages_4_08;
          };
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
