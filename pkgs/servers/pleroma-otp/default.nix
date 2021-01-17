{ stdenv
, autoPatchelfHook
, fetchurl
, file
, makeWrapper
, ncurses
, nixosTests
, openssl
, unzip
, zlib
}:
stdenv.mkDerivation {
  pname = "pleroma-otp";
  version = "2.2.1";

  # To find the latest binary release stable link, have a look at
  # the CI pipeline for the latest commit of the stable branch
  # https://git.pleroma.social/pleroma/pleroma/-/tree/stable
  src = {
    aarch64-linux = fetchurl {
      url = "https://git.pleroma.social/pleroma/pleroma/-/jobs/171765/artifacts/download";
      sha256 = "14yc53vs7wyws2ni5phl6j025bgcggk5cwnsxsx2cnfqlzz9rhww";
    };
    x86_64-linux = fetchurl {
      url = "https://git.pleroma.social/pleroma/pleroma/-/jobs/171761/artifacts/download";
      sha256 = "0z93qvyda5kh794svk00pgbzhm5pv663rjkzkwwb6sfk7f9287ir";
    };
  }."${stdenv.hostPlatform.system}";

  nativeBuildInputs = [ unzip ];

  buildInputs = [
    autoPatchelfHook
    file
    makeWrapper
    ncurses
    openssl
    zlib
  ];

  # mkDerivation fails to detect the zip nature of $src due to the
  # missing .zip extension.
  # Let's unpack the archive explicitely.
  unpackCmd = "unzip $curSrc";

  installPhase = ''
    mkdir $out
    cp -r * $out'';

  # Pleroma is using the project's root path (here the store path)
  # as its TMPDIR.
  # Patching it to move the tmp dir to the actual tmpdir
  postFixup = ''
    wrapProgram $out/bin/pleroma \
      --set-default RELEASE_TMP "/tmp"
    wrapProgram $out/bin/pleroma_ctl \
      --set-default RELEASE_TMP "/tmp"'';

  passthru.tests = {
    pleroma = nixosTests.pleroma;
  };

  meta = {
    description = "ActivityPub microblogging server";
    homepage = https://git.pleroma.social/pleroma/pleroma;
    license = stdenv.lib.licenses.agpl3;
    maintainers = with stdenv.lib.maintainers; [ ninjatrappeur ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
