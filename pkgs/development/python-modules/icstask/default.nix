{ buildPythonPackage, fetchPypi, coverage, vobject, setuptools }:

buildPythonPackage rec {
  pname = "icstask";
  version = "0.5.0";

  pyproject = true;
  build-system = [ setuptools ];

  buildInputs = [ coverage ];
  propagatedBuildInputs = [ vobject ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ckoVaGZJZ2L6d6eX17ZRtE/kH98l6rh8lSjzJxLVww8=";
  };
}
