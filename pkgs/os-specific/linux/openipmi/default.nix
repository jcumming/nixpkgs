{ fetchurl, stdenv, popt, ncurses, readline }:

# https://sourceforge.net/projects/openipmi/files/OpenIPMI%202.0%20Library/OpenIPMI-2.0.29.tar.gz/download
stdenv.mkDerivation rec {
  pname = "OpenIPMI";
  ver = "2.0.29";
  name = "${pname}-${ver}";

  src = fetchurl {
    url = "mirror://sourceforge/openipmi/OpenIPMI%202.0%20Library/${name}.tar.gz";
    sha256 = "1kcmws62mhf1sb0fba7znql8lr8yqsd3wf9lkxb4xcdgg52i4i12";
  };

  buildInputs = [ popt ncurses readline ];

  configureFlags = [ 
    "--without-python"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "library and daemon for high level IPMI access";
    homepage = "http://openipmi.sourceforge.net/";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
