{stdenv, fetchurl, autoconf, sqlite, flex, bison, curl, perl}:

stdenv.mkDerivation rec{
  ver = "1.71.0";
  name = "crossfire-server-${ver}"; 
  
  src = fetchurl {
    url = "mirror://sourceforge/crossfire/crossfire-server/${ver}/crossfire-${ver}.tar.bz2";
    sha256 = "078yzsadnlwskgjcjfxchpqp47s82v2bdw92496w6a3n43dif6fc";
  };

  arch = fetchurl {
    url = "mirror://sourceforge/crossfire/crossfire-arch/${ver}/crossfire-${ver}.arch.tar.bz2";
    sha256 = "0k86bws463w05jwdcfrzkfk3v7pf0ffj1a9j97hrd6l72lxy6vh1";
  };

  maps = fetchurl {
    url = "mirror://sourceforge/crossfire/crossfire-maps/${ver}/crossfire-${ver}.maps.tar.bz2";
    sha256 = "1nhpvkz553ydb3qbx4xfdyg5c29v8j806wxaw7f86fyx0pb5zpzn";
  };

  enableParallelBuilding = false; 

  hardeningDisable = [ "format" ];

  postUnpack = ''
    tar xf ${arch}
    mv arch crossfire-server-${ver}/lib/

    mkdir -p $out/share/crossfire
    tar xf ${maps} -C $out/share/crossfire
  '';

  buildInputs = [ autoconf sqlite flex bison curl perl ];

  meta = {
    homepage = http://crossfire.real-time.com/;
    license = stdenv.lib.licenses.gpl2;
    description = "graphical multi-user dungeon";
    longDescription = ''
      A graphical multi-user 2d tile-based role playing game similar to Moria,
      Angband, Omega, Nethack, Rogue, Gauntlet, and MUDs.
    '';
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
