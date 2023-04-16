{ self, runCommand, coreutils, xz, gnutar, gnused }:
let
  inherit (self.lib) requireFile;
  pname = "nvidia-vgpu-kvm-src";
  name = pname;

  vgpuVersion = "460.32.04";
  gridVersion = "460.32.03";
  guestVersion = "461.33";

  combinedZipName = "NVIDIA-GRID-Linux-KVM-${vgpuVersion}-${gridVersion}-${guestVersion}.zip";

in runCommand "nvidia-${vgpuVersion}-vgpu-kvm-src" {
  src = requireFile {
    name = "NVIDIA-Linux-x86_64-${vgpuVersion}-vgpu-kvm.run";
    sha256 = "00ay1f434dbls6p0kaawzc6ziwlp9dnkg114ipg9xx8xi4360zzl";
  };

  passthru = { inherit vgpuVersion gridVersion guestVersion combinedZipName; };
} ''
  ${coreutils}/bin/mkdir $out
  cd $out

  # From unpackManually() in builder.sh of nvidia-x11 from nixpkgs
  skip=$(${gnused}/bin/sed 's/^skip=//; t; d' $src)
  ${coreutils}/bin/tail -n +$skip $src | ${xz}/bin/xz -d | ${gnutar}/bin/tar xvf -
''
