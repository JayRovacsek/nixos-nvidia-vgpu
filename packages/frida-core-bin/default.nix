{ lib, stdenv, fetchurl, gnutar, ... }:
let
  pname = "frida-core";
  name = pname;
  version = "16.0.11";

  meta = with lib; {
    description = "Frida core library intended for static linking into bindings.";
    platforms = platforms.all;
    homepage = "https://github.com/frida/frida-core";
    downloadPage = "https://github.com/frida/frida/releases";
    license = licenses.wxWindows;
  };

  buildInputs = [ gnutar ];

  src = fetchurl {
    url = "https://github.com/frida/frida/releases/download/16.0.11/frida-core-devkit-16.0.11-linux-x86_64.tar.xz";
    sha256 = "sha256-bwnWEhA/ZUYuXZMWXMwbp+YGGa7Bxyljdq9wlXURulA=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share 
    ${gnutar}/bin/tar -xf $src
    mv frida* $out/share
    mv libfrida* $out/share
  '';

in stdenv.mkDerivation { inherit installPhase phases src pname name version meta buildInputs; }
