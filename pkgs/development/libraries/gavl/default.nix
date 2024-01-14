{ stdenv, fetchurl, doxygen, libpng }:

stdenv.mkDerivation rec {
  name = "gavl-${version}";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/gmerlin/gavl/${version}/gavl-${version}.tar.gz";
    sha256 = "1kikkn971a14zzm7svi7190ldc14fjai0xyhpbcmp48s750sraji";
  };

  configureFlags = [ "--without-cpuflags" ];

  buildInputs = [ doxygen libpng ];

  meta = {
    homepage = "http://gmerlin.sourceforge.net/gavl_frame.html";
    description = "a low level library, upon which multimedia APIs can be built -- handles all the details of audio and video formats like colorspaces, samplerates, multichannel configurations etc";
  };
}
