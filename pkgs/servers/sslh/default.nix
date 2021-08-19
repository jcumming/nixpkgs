{ lib, stdenv, fetchurl, libcap, libconfig, perl, tcp_wrappers, pcre, nixosTests }:

stdenv.mkDerivation rec {
  pname = "sslh";
  version = "1.21+20210702-bf57d63";

  src = fetchurl {
    url = "https://github.com/yrutschle/sslh/archive/bf57d63c3a91fa73fd37e1541c4446956b37148b.tar.gz";
    sha256 = "11wvjrp0i2d3zw05rjv9sfnwcb9kwgb3cwbdv3h938b1n081gds6";
  };

  postPatch = "patchShebangs *.sh";

  buildInputs = [ libcap libconfig perl tcp_wrappers pcre ];

  makeFlags = [ "USELIBCAP=1" "USELIBWRAP=1" ];

  installFlags = [ "PREFIX=$(out)" ];

  hardeningDisable = [ "format" ];

  passthru.tests = {
    inherit (nixosTests) sslh;
  };

  meta = with lib; {
    description = "Applicative Protocol Multiplexer (e.g. share SSH and HTTPS on the same port)";
    license = licenses.gpl2Plus;
    homepage = "https://www.rutschle.net/tech/sslh/README.html";
    maintainers = with maintainers; [ koral fpletz ];
    platforms = platforms.all;
  };
}
