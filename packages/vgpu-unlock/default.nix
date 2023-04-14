{ fetchFromGitHub, stdenv, bash, frida }:
stdenv.mkDerivation {
  name = "nvidia-vgpu-unlock";
  version = "unstable-2021-04-22";

  src = fetchFromGitHub {
    owner = "DualCoder";
    repo = "vgpu_unlock";
    rev = "f432ffc8b7ed245df8858e9b38000d3b8f0352f4";
    sha256 = "0s8bmscb8irj1sggfg1fhacqd1lh59l326bnrk4a2g4qngsbkix3";
  };

  buildInputs = [ frida ];

  postPatch = ''
    substituteInPlace vgpu_unlock \
      --replace /bin/bash ${bash}/bin/bash
  '';

  installPhase = "install -Dm755 vgpu_unlock $out/bin/vgpu_unlock";
}
