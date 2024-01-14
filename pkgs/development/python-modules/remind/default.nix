{ buildPythonPackage, fetchPypi, coverage, nose, pytz, tzlocal, python-dateutil, vobject }:

buildPythonPackage rec {
  pname = "remind";
  version = "0.18.0";

  buildInputs = [ coverage nose ];
  propagatedBuildInputs = [ pytz tzlocal python-dateutil vobject ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FB831vi9Vpy6dJ5HROR8cv5CFa9PD4pwFru62Dnd+Kk=";
  };
}
