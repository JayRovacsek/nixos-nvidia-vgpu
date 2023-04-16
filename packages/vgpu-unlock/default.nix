{ fetchFromGitHub, stdenv, lib, bash, python, frida-tools }:
stdenv.mkDerivation {
  name = "nvidia-vgpu-unlock";
  version = "unstable-2021-04-24";

  meta = with lib; {
    description = "Unlock vGPU functionality for consumer grade GPUs";
    platforms = platforms.unix;
    homepage = "https://github.com/dualcoder/vgpu_unlock";
    license = licenses.mit;
  };

  src = fetchFromGitHub {
    owner = "DualCoder";
    repo = "vgpu_unlock";
    rev = "f432ffc8b7ed245df8858e9b38000d3b8f0352f4";
    sha256 = "sha256-o+8j82Ts8/tEREqpNbA5W329JXnwxfPNJoneNE8qcsU=";
  };

  buildInputs = [ (python.python.withPackages (_p: [ frida-tools ])) ];

  postPatch = ''
    substituteInPlace vgpu_unlock \
      --replace /bin/bash ${bash}/bin/bash
  '';

  installPhase = "install -Dm755 vgpu_unlock $out/bin/vgpu_unlock";
}
