{ buildPythonPackage, fetchPypi, coverage, nose, vobject }:

buildPythonPackage rec {
  pname = "icstask";
  version = "0.4.0";

  buildInputs = [ coverage nose ];
  propagatedBuildInputs = [ vobject ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-h1mu+5cGodRhjRfEIxMgMbOzFZ3nczLF7MFckshjmoU=";
  };
}
