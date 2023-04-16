{ self, system, pkgs }:
let
  pkgs = self.inputs.nixpkgs.legacyPackages.${system};
  inherit (pkgs) callPackage;

  python = pkgs.python310Packages;
  inherit (self.packages.${system}) frida;
  inherit (self.packages.${system}) capstone-src;
  inherit (self.packages.${system}) frida-core-bin;
in {
  capstone-src = callPackage ./capstone-src { };
  frida = callPackage ./frida {
    inherit python;
    frida-core = frida-core-bin;
  };
  frida-core = callPackage ./frida-core { };
  frida-core-bin = callPackage ./frida-core-bin { };
  frida-gum = callPackage ./frida-gum { inherit capstone-src; };
  frida-tools = callPackage ./frida-tools { inherit python; };
  vgpu-unlock = callPackage ./vgpu-unlock { inherit frida; };
}
