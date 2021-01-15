{ lib, stdenv, fetchsvn, boost, cmake, ffmpeg_3, freeglut, glib,
  gtk2, libjpeg, libpng, libpthreadstubs, libvorbis, libXau, libXdmcp,
  libXmu, libGLU, libGL, openal, pixman, pkg-config, python27, SDL }:

stdenv.mkDerivation {
  name = "privateer-1.03";

  src = fetchsvn {
    #url = "mirror://sourceforge/project/privateer/Wing%20Commander%20Privateer/Privateer%20Gemini%20Gold%201.03/PrivateerGold1.03.bz2.bin";
    url = "https://privateer.svn.sourceforge.net/svnroot/privateer/privgold/trunk/engine";
    rev = 297;
    sha256 = "0qsc2k6z7mbfqmg6kigypvajqszkvpvd11swbv4kypansj3r0xg1";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs =
    [ boost ffmpeg_3 freeglut glib gtk2 libjpeg libpng
      libpthreadstubs libvorbis libXau libXdmcp libXmu libGLU libGL openal
      pixman python27 SDL ];

  hardeningDisable = [ "format" ]; 

  patches = [ ./0001-fix-VSFile-constructor.patch ./0002-misc_cpp_fixes.patch ];

  preConfigure = ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags gtk+-2.0)"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp vegastrike $out/bin
    cp vegaserver $out/bin
  '';

  meta = with lib; {
    homepage = "http://privateer.sourceforge.net/";
    description = "Adventure space flight simulation computer game";
    license = licenses.gpl2Plus; # and a special license for art data
    # https://sourceforge.net/p/privateer/code/HEAD/tree/privgold/trunk/data/art-license.txt

    maintainers = with maintainers; [ ];
    platforms = with platforms; linux ++ darwin;
    hydraPlatforms = [];
    broken = true; # it won't build
  };
}
