{ self, pkgs ? self.inputs.nixpkgs.legacyPackages.x86_64-linux, ... }:
let
  inherit (pkgs) system;
  inherit (self.packages.${system}) nvidia-vgpu-kvm-src;
  inherit (nvidia-vgpu-kvm-src.passthru) combinedZipName;
in {
  requireFile = { name, ... }@args:
    pkgs.requireFile (rec {
      inherit name;
      url = "https://www.nvidia.com/object/vGPU-software-driver.html";
      message = ''
        Unfortunately, we cannot download file ${name} automatically.
        This file can be extracted from ${combinedZipName}.
        Please go to ${url} to download it yourself, and add it to the Nix store
        using either
          nix-store --add-fixed sha256 ${name}
        or
          nix-prefetch-url --type sha256 file:///path/to/${name}
      '';
    } // args);
}
