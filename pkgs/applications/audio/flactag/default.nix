{stdenv, lib, fetchFromGitHub, libmusicbrainz, libcoverart, jansson, libxml2, libogg, flac, slang, neon, unac, libjpeg, asciidoc, libdiscid, pkg-config, cmake, imagemagick}:

stdenv.mkDerivation rec {
  ver = "3.0.0-230108-cmake";
  name = "flactag-${ver}";

  src = fetchFromGitHub {
    owner = "adhawkins";
    repo = "flactag";
    rev = "1e62eef87acb1b817b3b9f94dbe2fc8f591e2ec3";
    sha256 = "sha256-2TFgtidIh+znGoOPpL6lgJB6p2Vhv0cINzPR0mTWhJo=";
  };

  patches = [ ./no_progress_retval.patch ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libmusicbrainz libcoverart jansson libxml2 libogg flac slang neon unac libjpeg asciidoc libdiscid imagemagick ];

  meta = {
    description = "A utility for maintaining single album FLAC file (with embedded CUE sheets) metadata from MusicBrainz. ";
    longDescription = ''
      A common mechanism for backing up audio cds is to extract them from the media
      into a single flac file, and embed the cue sheet into the flac file. This means
      that the cd can be exactly reproduced at a later date. 

      flactag uses the embedded CUE sheet to create a musicbrainz 'discid', and
      queries the musicbrainz server for track lists, and other album metadata. 
    '';
    homepage = "http://flactag.sourceforge.net/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ jcumming ];
  };
}
