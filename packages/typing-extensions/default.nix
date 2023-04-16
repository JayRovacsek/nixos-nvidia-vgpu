{ lib, fetchurl, python, ... }:
let
  pname = "typing-extensions";
  name = pname;
  version = "3.10.0.2";

  meta = with lib; {
    description = "Backported and Experimental Type Hints for Python";
    platforms = platforms.all;
    homepage = "https://github.com/python/typing";
    downloadPage = "https://github.com/python/typing/releases";
    license = licenses.psfl;
  };

  inherit (python) buildPythonPackage;

  src = fetchurl {
    url =
      "https://files.pythonhosted.org/packages/ed/12/c5079a15cf5c01d7f4252b473b00f7e68ee711be605b9f001528f0298b98/typing_extensions-3.10.0.2.tar.gz";
    sha256 = "sha256-SfddFv8R8c0ljhuYjM/4KjylVwIX162MX0ggXdmaZ34=";
  };

in buildPythonPackage { inherit pname name version meta src; }
