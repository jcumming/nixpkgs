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
  version = "20240927-cfabc28d11ca72e523ccea943e15b81df96073af";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jspricke";
    repo = "radicale-remind";
    rev = "cfabc28d11ca72e523ccea943e15b81df96073af";
    hash = "sha256-P1Uh00+9RlO2XP9ZILgNLbkFU3z10E72zxnjVuUTtEY=";
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
