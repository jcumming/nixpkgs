{ lib, stdenv, fetchFromGitHub, cmake, neon, libdiscid, libxml2, pkg-config, validatePkgConfig }:
stdenv.mkDerivation rec {
  version = "5.1.0+231009-4655b57";
  pname = "libmusicbrainz";

  nativeBuildInputs = [ cmake pkg-config validatePkgConfig ];
  buildInputs = [ neon libdiscid libxml2 ];

  src = fetchFromGitHub {
    owner  = "metabrainz";
    repo   = "libmusicbrainz";
    sha256 = "sha256-YJkcRJjXx2obN7bleu2Zz+zxAxcv8lEBLhh6vV6Ikqw=";
    rev    = "4655b571a70d73d41467091f59c518517c956198";
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
