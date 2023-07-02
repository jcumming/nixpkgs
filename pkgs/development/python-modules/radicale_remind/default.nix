{ buildPythonPackage, fetchPypi, coverage, nose, radicale, abook, icstask, remind }:

buildPythonPackage rec {
  pname = "radicale-remind";
  version = "0.5.0";

  buildInputs = [ coverage nose radicale ];

  # don't propagate radicale, so we can inject radicale_remind back into radicale
  # as a propagatedBuildInput without causing a loop in _addToPythonPath

  propagatedBuildInputs = [ remind abook icstask ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-l/mHyN1+Dyf18UDdP6b9AaUFG8+J0HclD6OPnU7aVAk=";
  };
}
