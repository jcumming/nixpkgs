{ lib, stdenv, kernel }:

stdenv.mkDerivation {
  name = "turbostat-linux-${kernel.version}";

  inherit (kernel) src patches;

  preConfigure = ''
    cd tools/power/x86/turbostat/
    export makeFlags="DESTDIR=$out PREFIX= $makeFlags"
  '';

  meta = {
    description = "Linux tools to watch x86 processor core frequencies";
    maintainers = with stdenv.lib.maintainers; [jcumming];
    platforms = with stdenv.lib.platforms; linux;
  };
}
