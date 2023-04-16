{ lib, fetchPypi, python, frida, ... }:
let
  pname = "frida-tools";
  name = pname;
  version = "12.1.1";

  meta = with lib; {
    description = "CLI tools for Frida.";
    platforms = platforms.all;
    homepage = "https://frida.re/";
    downloadPage = "https://github.com/frida/frida-tools/tags";
    license = licenses.wxWindows;
  };

  inherit (python) buildPythonPackage pygments colorama prompt-toolkit typing-extensions;

  propagatedBuildInputs = [ frida typing-extensions pygments colorama prompt-toolkit ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Irjs7Gy7r77MWAOs7+kQb7dpqzEdXPUILrtmXuvURUk=";
  };

in buildPythonPackage { inherit pname name version meta propagatedBuildInputs src; }
