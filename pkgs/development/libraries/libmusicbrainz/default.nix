{ stdenv, fetchurl, cmake, neon, libdiscid }:

stdenv.mkDerivation rec {
  name = "libmusicbrainz-5.0.1";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ neon libdiscid ];

  # this probably can be removed after 5.0.1: https://github.com/metabrainz/libmusicbrainz/issues/1
  dontUseCmakeBuildDir=true;

  src = fetchurl {
    url = "ftp://ftp.musicbrainz.org/pub/musicbrainz/${name}.tar.gz";
    sha256 = "1i9qly13bwwmgj68vma766hgvsd1m75236haqsp9zgh5znlmkm3z";
  };

  meta = with stdenv.lib; {
    homepage = "http://musicbrainz.org/doc/libmusicbrainz";
    description = "MusicBrainz Client Library (3.x version)";
    longDescription = ''
      The libmusicbrainz (also known as mb_client or MusicBrainz Client
      Library) is a development library geared towards developers who wish to
      add MusicBrainz lookup capabilities to their applications.'';
    maintainers = [ stdenv.lib.maintainers.jcumming ];
    platforms = platforms.all;
    license = licenses.lgpl21;
  };
}
