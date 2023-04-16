{ lib, fetchPypi, python, frida-core, ... }:
let
  pname = "frida";
  name = pname;
  version = "16.0.11";

  meta = with lib; {
    description = "Python bindings for Frida.";
    platforms = platforms.all;
    homepage = "https://frida.re/";
    downloadPage = "https://github.com/frida/frida/releases";
    license = licenses.wxWindows;
  };

  inherit (python) buildPythonPackage;

  # This is failing because it needs frida core:
  #  > Download one from https://github.com/frida/frida/releases, extract it to a directory,
  #  > and then add an environment variable named FRIDA_CORE_DEVKIT pointing at the directory.
  # core is failing due to gum and gum due to capstone :)
  # TODO: come back when I care more 
in buildPythonPackage {
  inherit pname name version meta;

  FRIDA_CORE_DEVKIT = "${frida-core}/share";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-73eTS0OBcfexc5NuLqHnjE5+U9iTVeWkUyL+H23rcHk=";
  };

  doCheck = false;
}
