{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "iw_exporter";
  version = "2017-03-29-42ba0399e";

  src = fetchFromGitHub {
    rev = "8d6ae1bf4874504c4b58cdfb2a785885d22b579d";
    owner = "jcumming";
    repo = "iw_exporter";
    sha256 = "sha256:1gz9whmbsvh12sahmahjd9ckfcmvvly97n6vw8c7gj2xls10p6rv";
  };

  vendorSha256 = "sha256:0mj81xlyqfp3k2lgnjdggnqanksl5bx36byh5y7ir742qlqb7ic7";

  meta = with lib; {
    description = "Connected wireless station exporter for Prometheus";
    homepage = "https://github.com/jamessanford/iw_exporter";
    license = licenses.unfree;
    maintainers = with maintainers; [ jcumming ];
    platforms = platforms.linux;
  };
}
