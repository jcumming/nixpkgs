{ buildPythonPackage, fetchPypi, coverage, nose, radicale, abook, icstask, remind }:

buildPythonPackage rec {
  pname = "radicale-remind";
  version = "0.5.0";

  buildInputs = [ coverage nose ];
  propagatedBuildInputs = [ radicale abook icstask remind ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-l/mHyN1+Dyf18UDdP6b9AaUFG8+J0HclD6OPnU7aVAk=";
  };
}
