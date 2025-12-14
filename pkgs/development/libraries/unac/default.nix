{ stdenv, lib, fetchgit, autoreconfHook, gettext, perl }:

stdenv.mkDerivation rec {
  name = "unac-1.8.0";

  src = fetchgit {
    url = "git://git.savannah.nongnu.org/unac.git/";
    sha256 = "12ag1fkzc9yzfn2f8jcmab6301xggbk69ikjsds7m4szjjdpw1iv";
    rev = "e29ef8789cfd6b70c2d099f8ec6765177cdbb166";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ perl gettext ];

  patches = [ 
    ./update-autotools.diff
    ./gcc-4-fix-bug-556379.patch
    ./gettext-0.25.patch
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "unac is a C library and command that removes accents from a string.";
    longDescription = ''
      unac is a C library and command that removes accents from a string. For
      instance the string été will become ete. It provides a command line interface
      that removes accents from a input flow or a string given in argument (unaccent
      command).
    '';
    homepage = "http://savannah.nongnu.org/projects/unac";
    maintainers = with lib.maintainers; [ jcumming ];
    license = lib.licenses.gpl2Plus;
  };
}
