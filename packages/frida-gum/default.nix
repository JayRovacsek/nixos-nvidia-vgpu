{ lib, stdenv, fetchFromGitHub, meson, vala, pkg-config, glib, cmake, libgee, json-glib, capstone, ... }:
let
  pname = "frida-gum";
  name = pname;
  version = "16.0.11";

  meta = with lib; {
    description = "Cross-platform instrumentation and introspection library written in C ";
    platforms = platforms.all;
    homepage = "https://github.com/frida/frida-gum";
    downloadPage = "https://github.com/frida/frida/releases";
    license = licenses.wxWindows;
  };

  # Broken on > meson.build:397:0: ERROR: Automatic wrap-based subproject downloading is disabled
  # in relation to capstone - todo look into it in the future.
  buildInputs = [ meson vala pkg-config glib cmake libgee json-glib capstone ];

  src = fetchFromGitHub {
    owner = "frida";
    repo = "frida-gum";
    rev = "434914c04e0b1e14884bd73efadfc79e055aa615";
    sha256 = "sha256-HiTCqhGUDHfu5Za9FmYYZeU5fY4aFLEvdYo+4ujHBsU=";
  };

in stdenv.mkDerivation { inherit src pname name version meta buildInputs; }
