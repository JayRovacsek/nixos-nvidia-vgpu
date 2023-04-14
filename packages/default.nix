{ self, system, pkgs }:
let
  pkgs = self.inputs.nixpkgs.legacyPackages.${system};
  inherit (pkgs) callPackage;

  python = pkgs.python310Packages;
  inherit (self.packages.${system}) frida;
in {
  frida = callPackage ./frida { inherit python; };
  frida-core = callPackage ./frida-core { };
  frida-gum = callPackage ./frida-gum { };
  frida-tools = callPackage ./frida-tools { inherit python; };
  vgpu-unlock = callPackage ./vgpu-unlock { inherit frida; };
}
