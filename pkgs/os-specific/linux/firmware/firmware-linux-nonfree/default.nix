{ stdenv, fetchgit, lib }:

stdenv.mkDerivation rec {
  pname = "firmware-linux-nonfree";
  version = "2020-11-18";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = lib.replaceStrings ["-"] [""] version;
    sha256 = "107p7h13gncsxqhixqq9zmmswvs910sck54ab10s4m5cafvnaf94";
  };

  #  8.307821] brcmfmac 0000:04:00.0: Direct firmware load for brcm/brcmfmac4366c-pcie.Supermicro-Super Server.txt failed with error -2
  postInstall = ''
    mkdir -p $out/lib/firmware/brcm/
    cp ${brcm4366c} $out/lib/firmware/brcm/brcmfmac4366c-pcie.bin
  '';

  # http://forums.fedoraforum.org/showthread.php?t=310626
  brcm4366c = ./brcmfmac4366c-pcie.bin;

  installFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  meta = with stdenv.lib; {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = "http://packages.debian.org/sid/firmware-linux-nonfree";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    priority = 6; # give precedence to kernel firmware
  };

  passthru = { inherit version; };
}
