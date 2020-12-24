{ buildPythonPackage, fetchPypi, coverage, nose, pytz, tzlocal, python-dateutil, vobject }:

buildPythonPackage rec {
  pname = "remind";
  version = "0.15.0";

  buildInputs = [ coverage nose ];
  propagatedBuildInputs = [ pytz tzlocal python-dateutil vobject ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "28c4635a260dee0fd755fffd6dffd37b2855b09a27a11b23239aace49ec29688";
  };
}
