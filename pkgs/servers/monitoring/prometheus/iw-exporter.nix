{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "iw_exporter";
  version = "2023-09-09-2b17fb9d";

  src = fetchFromGitHub {
    rev = "8a7d1d0f80b31038f54d05b06138ae1f2b17fb9d";
    owner = "jcumming";
    repo = "iw_exporter";
    sha256 = "sha256-S9Q4AlEMd6GCpfhd29KiQGigW+6gyCXX0dD03x50WMg=";
  };

  vendorHash = "sha256-cS9S+yQoLLIC1ZcVDB35S4drYfAOOp6kvT7OuIcOypo=";

  meta = with lib; {
    description = "Connected wireless station exporter for Prometheus";
    homepage = "https://github.com/jamessanford/iw_exporter";
    license = licenses.wtfpl; # XXX: dunno
    maintainers = with maintainers; [ jcumming ];
    platforms = platforms.linux;
  };
}
