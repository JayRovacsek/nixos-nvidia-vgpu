{ self, system }:
let
  name = "dev-shell";
  pkgs = self.inputs.nixpkgs.legacyPackages.${system};

  shell = {
    inherit name;
    packages = with pkgs; [ nixfmt statix nil ];
    inherit (self.checks.${system}.pre-commit) shellHook;
  };

in {
  "${name}" = pkgs.mkShell shell;
  default = self.outputs.devShells.${system}.${name};
}
