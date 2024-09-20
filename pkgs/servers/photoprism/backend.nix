{ lib, buildGoModule, coreutils, pkg-config, vips, libtensorflow, src, version, ... }:

buildGoModule rec {
  inherit src version;
  pname = "photoprism-backend";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    vips
    coreutils
    libtensorflow
    vips
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postPatch = ''
    substituteInPlace internal/commands/passwd.go --replace '/bin/stty' "${coreutils}/bin/stty"
  '';

  vendorHash = "sha256-e7lLlMjmDmQeVaVYfdFWRO8inNIjLaVVyIz12ZaPjEU=";

  subPackages = [ "cmd/photoprism" ];

  # https://github.com/mattn/go-sqlite3/issues/822
  CGO_CFLAGS = "-Wno-return-local-addr";

  # https://github.com/tensorflow/tensorflow/issues/43847
  CGO_LDFLAGS = "-fuse-ld=gold";

  meta = with lib; {
    homepage = "https://photoprism.app";
    description = "Photoprism's backend";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ benesim ];
  };
}
