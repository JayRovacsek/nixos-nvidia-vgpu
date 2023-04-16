{ lib, stdenv, fetchFromGitHub, coreutils }:
let
  pname = "capstone-src";
  name = pname;
  version = "22d317042ee4d251280d2960f5cf294433977db4";

  meta = with lib; {
    description = "Frida depends on the excellent Capstone disassembly framework";
    platforms = platforms.all;
    homepage = "https://github.com/frida/capstone";
    downloadPage = "https://github.com/frida/capstone/releases";
    license = licenses.bsd3;
  };

  src = fetchFromGitHub {
    owner = "frida";
    repo = "capstone";
    rev = version;
    sha256 = "sha256-mDXHJZ1RKbGmHjdhjZNmuD9fQCyWMoewjpBbIA5FAO0=";
  };

  installPhase = ''
    ${coreutils}/bin/mkdir -p $out/share
    ${coreutils}/bin/cp -r $src/* $out/share
  '';

in stdenv.mkDerivation { inherit version installPhase src pname name meta; }
