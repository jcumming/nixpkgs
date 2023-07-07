{ lib, stdenv, fetchFromGitHub, cmake, neon, libdiscid, libxml2, pkg-config, validatePkgConfig }:

stdenv.mkDerivation rec {
  version = "5.1.0+220120-f5a31de";
  pname = "libmusicbrainz";

  nativeBuildInputs = [ cmake pkg-config validatePkgConfig ];
  buildInputs = [ neon libdiscid libxml2 ];

  src = fetchFromGitHub {
    owner  = "metabrainz";
    repo   = "libmusicbrainz";
    sha256 = "sha256-su+7kB5foGMCoVLTZsxt7m1/NT1fEeV6QbIOrtvhz1Q=";
    rev    = "f5a31ded2d9794e9e27bbdfc197636b3c46b39be";
  };

  dontUseCmakeBuildDir=true;

  meta = with lib; {
    homepage = "http://musicbrainz.org/doc/libmusicbrainz";
    description = "MusicBrainz Client Library (5.x version)";
    longDescription = ''
      The libmusicbrainz (also known as mb_client or MusicBrainz Client
      Library) is a development library geared towards developers who wish to
      add MusicBrainz lookup capabilities to their applications.'';
    platforms = platforms.all;
    license = licenses.lgpl21;
  };
}
