{
  description = "NixOS module which provides NVIDIA vGPU functionality";

  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };
  };

  outputs = { self, flake-utils, ... }:
    let inherit (flake-utils.lib) defaultSystems;
    in flake-utils.lib.eachSystem defaultSystems (system: {
      checks = import ./checks { inherit self system; };
      devShells = import ./shells { inherit self system; };
      formatter = self.inputs.nixpkgs.legacyPackages.${system}.nixfmt;
      packages = import ./packages {
        inherit self system;
        pkgs = self.inputs.nixpkgs.legacyPackages.${system};
      };
    }) // {
      nixosModules = {
        nvidia-vgpu = import ./default.nix;
        default = self.outputs.nixosModules.nvidia-vgpu;
      };
    };
}
