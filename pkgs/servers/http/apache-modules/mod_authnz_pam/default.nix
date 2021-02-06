{ lib, stdenv, apacheHttpd, fetchFromGitHub, pam }:

stdenv.mkDerivation rec {

  pname = "mod_authnz_pam";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "adelton";
    repo = "mod_authnz_pam";
    rev = "${pname}-${version}";
    sha256 = "12iqj29zngxrr6dvwjscc8fpmc0rrfkc7rw43zz6vzsypdgvvgxm";
  };

  buildInputs = [ apacheHttpd pam ];

  buildPhase = ''
    export APACHE_LIBEXECDIR=$out/modules
    export makeFlagsArray=(APACHE_LIBEXECDIR=$out/modules)
    apxs -ca mod_authnz_pam.c -lpam -Wall -pedantic
  '';

  installPhase = ''
    mkdir -p $out/modules
    cp .libs/mod_authnz_pam.so $out/modules
  '';

  meta = with lib; {
    homepage = "https://www.adelton.com/apache/mod_authnz_pam/";
    description = "An Apache auth module for using PAM";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jcumming ];
  };

}
