{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  radicale,
  abook,
  icstask,
  remind,
}:
buildPythonPackage rec {
  pname = "radicale-remind";
  version = "0.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jspricke";
    repo = "radicale-remind";
    rev = "v${version}";
    hash = "sha256-d4kLUC++mCc73pMXTJLpDIkV6eZ61CGXkeqcaaDgLdo=";
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
