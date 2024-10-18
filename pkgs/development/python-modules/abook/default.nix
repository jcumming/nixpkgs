{ buildPythonPackage, fetchPypi, coverage, vobject }:

buildPythonPackage rec {
  pname = "abook";
  version = "0.9.1";

  buildInputs = [ coverage ];
  propagatedBuildInputs = [ vobject ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Kgirzv96NuWgmKcdjA7TRu3kQLzdXZ6ojwOZaa8DZgE=";
  };
}
