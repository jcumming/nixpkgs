{ buildPythonPackage, fetchPypi, coverage, nose, vobject }:

buildPythonPackage rec {
  pname = "abook";
  version = "0.8.0";

  buildInputs = [ coverage nose ];
  propagatedBuildInputs = [ vobject ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-F/etAdBerByPU8weklbCk31x8l7iGLV7xuAIxPNpROs=";
  };
}
