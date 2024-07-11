{
  lib,
  fetchPypi,
  buildPythonPackage,
  radicale,
  abook,
  icstask,
  remind,
}:
buildPythonPackage rec {
  pname = "radicale-remind";
  version = "0.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-l/mHyN1+Dyf18UDdP6b9AaUFG8+J0HclD6OPnU7aVAk=";
  };

  nativeBuildInputs = [ radicale ]; # prevent radicale from importing itself
  propagatedBuildInputs = [remind abook icstask];

  pythonImportsCheck = ["radicale"];

  meta = with lib; {
    homepage = "https://github.com/jspricke/radicale-remind";
    description = "Radicale storage backends for Remind and Abook";
    license = with licenses; [
      gpl3
    ];
    maintainers = with maintainers; [jcumming];
  };
}
