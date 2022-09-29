{ fetchurl, lib, stdenv, autoreconfHook, pkg-config, perl, python3
, db, libgcrypt, avahi, libiconv, pam, openssl, acl
, ed, libtirpc, libevent, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "netatalk";
  release = "3.1.13";
  patch = "3";
  version = "${release}_${patch}";

  src = fetchurl {
    url = "mirror://sourceforge/netatalk/netatalk/netatalk-${release}.tar.bz2";
    sha256 = "0pg0slvvvq3l6f5yjz9ybijg4i6rs5a6c8wcynaasf8vzsyadbc9";
  };

  patches = [
    ./no-suid.patch
    ./omitLocalstatedirCreation.patch
    (fetchpatch {
      name = "make-afpstats-python3-compatible.patch";
      url = "https://github.com/Netatalk/Netatalk/commit/916b515705cf7ba28dc53d13202811c6e1fe6a9e.patch";
      sha256 = "sha256-DAABpYjQPJLsQBhmtP30gA357w0Qn+AsnFgAeyDC/Rg=";
    })
  ];

  freeBSDPatches = [
    # https://bugs.freebsd.org/263123
    (fetchpatch {
      name = "patch-etc_afpd_directory.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-etc_afpd_directory.c";
      sha256 = "03zgijjaxpqdsrhavmsingx7i8a5v5869nqxrxyczkzknr20fw55";
    })
    (fetchpatch {
      name = "patch-etc_afpd_file.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-etc_afpd_file.c";
      sha256 = "1i3blw41sm1a70mpy08qy329gp8nzsn1y64w92wchlalffmqbksz";
    })
    (fetchpatch {
      name = "patch-etc_afpd_volume.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-etc_afpd_volume.c";
      sha256 = "053pci9m3kpbvk2hshq0c92js2pxv6dcxp6yk8nxcp0ak9lvkbfw";
    })
    (fetchpatch {
      name = "patch-etc_cnid__dbd_cmd__dbd__scanvol.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-etc_cnid__dbd_cmd__dbd__scanvol.c";
      sha256 = "0k8h0fhv29dx1ddgsqrg66nm4xhfyr10hpbnzlainkhrh5wxiknl";
    })
    (fetchpatch {
      name = "patch-libatalk_adouble_ad__attr.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-libatalk_adouble_ad__attr.c";
      sha256 = "1fjrnh1n7rnh0l6dn26xgwbv5fyyj36r8i4rjax1hh39mqd59avp";
    })
    (fetchpatch {
      name = "patch-libatalk_adouble_ad__conv.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-libatalk_adouble_ad__conv.c";
      sha256 = "1n6h3j3pid4xzi5ip1f8wa9iwwwkb807hrajj28d5za27fxskhz0";
    })
    (fetchpatch {
      name = "patch-libatalk_adouble_ad__date.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-libatalk_adouble_ad__date.c";
      sha256 = "0ci88l5yjgasvic992wvh17sv41qpaxkz0s8wb2x52x2ylcrcsyv";
    })
    (fetchpatch {
      name = "patch-libatalk_adouble_ad__flush.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-libatalk_adouble_ad__flush.c";
      sha256 = "0nhxndb50d6fw8pwl0dzs8a8nw8r9imj8xkjhwqqwy9hz94h93f8";
    })
    (fetchpatch {
      name = "patch-libatalk_adouble_ad__open.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-libatalk_adouble_ad__open.c";
      sha256 = "0r5zwwwjqp9052cy3qg33w99cyisfm65ymgrpm162y8jripah6wa";
    })
    # https://bugs.freebsd.org/251203
    (fetchpatch {
      name = "patch-libatalk_vfs_extattr.c";
      url = "https://cgit.freebsd.org/ports/plain/net/netatalk3/files/patch-libatalk_vfs_extattr.c";
      sha256 = "0m9p6qm8iza7la3vnms5ifxjwf0brh4cdphqyj1lf8xl7d6a9i3l";
    })
  ];

  postPatch = ''
    # freeBSD patches are -p0
    for i in $freeBSDPatches ; do
      patch -p0 < $i
    done
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config perl python3 python3.pkgs.wrapPython ];

  buildInputs = [ db libgcrypt avahi libiconv pam openssl acl libevent ];

  configureFlags = [
    "--with-bdb=${db.dev}"
    "--with-ssl-dir=${openssl.dev}"
    "--with-lockfile=/run/lock/netatalk"
    "--with-libevent=${libevent.dev}"
    "--localstatedir=/var/lib"
  ];

  # Expose librpcsvc to the linker for afpd
  # Fixes errors that showed up when closure-size was merged:
  # afpd-nfsquota.o: In function `callaurpc':
  # netatalk-3.1.7/etc/afpd/nfsquota.c:78: undefined reference to `xdr_getquota_args'
  # netatalk-3.1.7/etc/afpd/nfsquota.c:78: undefined reference to `xdr_getquota_rslt'
  postConfigure = ''
    ${ed}/bin/ed -v etc/afpd/Makefile << EOF
    /^afpd_LDADD
    /am__append_2
    a
      ${libtirpc}/lib/libtirpc.so \\
    .
    w
    EOF
  '';

  postInstall = ''
    buildPythonPath ${python3.pkgs.dbus-python}
    patchPythonScript $out/bin/afpstats
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Apple Filing Protocol Server";
    homepage = "http://netatalk.sourceforge.net/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jcumming ];
  };
}
