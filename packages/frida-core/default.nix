{ lib, stdenv, fetchFromGitHub, meson, vala, pkg-config, glib, cmake, libgee, json-glib, libsoup_3, gnumake, ... }:
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

  # Failing on frida-gum - which is failing itself.
  buildInputs = [ meson vala pkg-config glib cmake libgee json-glib libsoup_3 ];

  src = fetchFromGitHub {
    owner = "frida";
    repo = "frida-core";
    rev = "8c4403bad63ca5db37e99a46e62e3d1facd94a12";
    sha256 = "sha256-mDXHJZ1RKbGmHjdhjZNmuD9fQCyWMoewjpBbIA5FAO0=";
    fetchSubmodules = true;
  };

  installPhase = "${gnumake}/bin/make";

in stdenv.mkDerivation { inherit installPhase src pname name version meta buildInputs; }
