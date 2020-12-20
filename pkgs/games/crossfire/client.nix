{stdenv, fetchurl, gtk, pkgconfig, curl, libGLU, SDL, SDL_mixer, makeDesktopItem}:

stdenv.mkDerivation rec{
  ver = "1.71.0";
  name = "crossfire-gtkv2-client-${ver}"; 

  desktopItem = makeDesktopItem { 
    name = "crossfire";
    exec = "crossfire-client-gtk2";
    comment = "Crossfire MMORPG client";
    desktopName = "Crossfire";
    genericName = "crossfire";
    categories = "Game;";
  };
  
  src = fetchurl {
    url = "mirror://sourceforge/crossfire/crossfire-client/${ver}/crossfire-client-${ver}.tar.bz2";
    sha256 = "17c1slc1krgybpgzy01ggzx1xf7s18hc778xbkkliyvgfmg6a9sl";
  };

  buildInputs = [gtk pkgconfig curl libGLU SDL SDL_mixer];

  postInstall = ''
    mkdir -p $out/share/applications
    cp -av ${desktopItem}/ $out
  '';
  
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
