# Build with
#   nix-build -A system -A config.system.build.tarball ./nixos.nix

import <nixpkgs/nixos> {
  configuration = {
    imports = [
      ./module.nix
      ./build-tarball.nix
      ./configuration.nix
    ];
  };

  system = "x86_64-linux";
}
