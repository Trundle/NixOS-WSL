{
  description = "NixOS WSL";

  inputs.nixpkgs.url = "nixpkgs/nixos-20.09";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, ... }:
    {
      nixosModules = [
        (import ./module.nix)
        (import ./build-tarball.nix)
      ];
      nixosConfigurations.mysystem = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (import ./module.nix)
          (import ./build-tarball.nix)
          (import ./configuration.nix)
        ];
        specialArgs = { inherit nixpkgs; };
      };
    } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        checks.check-format = pkgs.runCommand "check-format"
          {
            buildInputs = with pkgs; [ nixpkgs-fmt ];
          } ''
          nixpkgs-fmt --check ${./.}
          mkdir $out # success
        '';

        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ nixpkgs-fmt ];
        };
      }
    );
}
