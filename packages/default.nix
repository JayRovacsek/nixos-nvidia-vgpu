{ self, system, pkgs }:
let
  pkgs = self.inputs.nixpkgs.legacyPackages.${system};
  inherit (pkgs) callPackage;

  python = pkgs.python310Packages;
in rec {
  capstone-src = callPackage ./capstone-src { };
  frida = callPackage ./frida {
    inherit python;
    frida-core = frida-core-bin;
  };
  frida-core = callPackage ./frida-core { };
  frida-core-bin = callPackage ./frida-core-bin { };
  frida-gum = callPackage ./frida-gum { inherit capstone-src; };
  frida-tools = callPackage ./frida-tools { inherit python frida; };
  nvidia-vgpu-kvm-src = callPackage ./nvidia-vgpu-kvm-src { inherit self; };
  vgpu-unlock = callPackage ./vgpu-unlock { inherit python frida-tools; };
}
