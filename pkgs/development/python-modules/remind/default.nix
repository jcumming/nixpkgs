{ buildPythonPackage, fetchPypi, coverage, pytz, tzlocal, python-dateutil, vobject }:

buildPythonPackage rec {
  pname = "remind";
  version = "0.19.1";

  buildInputs = [ coverage ];
  propagatedBuildInputs = [ pytz tzlocal python-dateutil vobject ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6yi4AQ0EOFfe8UQNRuTnwbBPQpBwUip9CkcSG338VVg=";
  };
}
