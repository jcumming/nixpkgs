{ lib, stdenv, fetchFromGitHub, cmake, neon, libxml2, jansson, pkg-config, validatePkgConfig }:

stdenv.mkDerivation rec {
  version = "1.0.0+230223-0983ff7";
  pname = "libcoverart";

  nativeBuildInputs = [ cmake pkg-config validatePkgConfig ];
  buildInputs = [ neon libxml2 jansson ];

  src = fetchFromGitHub {
    owner  = "metabrainz";
    repo   = "libcoverart";
    sha256 = "sha256-ezo9ltW7DTvnW20PAOYyld+moV67xwqSrUOUf+IbpkA=";
    rev    = "0983ff7b104dc864af56409de5f7c66b061c5857";
  };

  dontUseCmakeBuildDir=true;

  meta = with lib; {
    homepage = "http://musicbrainz.org/doc/libcoverart";
    description = "MusicBrainz Cover Art Library";
    longDescription = "C/C++ library for accessing the MusicBrainz Cover Art Archive";
    platforms = platforms.all;
    license = licenses.lgpl21;
  };
}
