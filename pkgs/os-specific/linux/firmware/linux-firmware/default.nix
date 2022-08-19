{ stdenvNoCC, fetchzip, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "linux-firmware";
  version = "20220815";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-${version}.tar.gz";
    sha256 = "sha256-StPlnwn4KOvOf4fRblDzJQqyI8iIz8e9fo/BsTyCKjI=";
  };

  #  8.307821] brcmfmac 0000:04:00.0: Direct firmware load for brcm/brcmfmac4366c-pcie.Supermicro-Super Server.txt failed with error -2
 # postInstall = ''
 #   mkdir -p $out/lib/firmware/brcm/
 #   cp ${brcm4366c} $out/lib/firmware/brcm/brcmfmac4366c-pcie.bin
 # '';

  # http://forums.fedoraforum.org/showthread.php?t=310626
 # brcm4366c = ./brcmfmac4366c-pcie.bin;

  installFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-VTRrOOkdWepUCKAkziO/0egb3oaQEOJCtsuDEgs/W78=";

  meta = with lib; {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    priority = 6; # give precedence to kernel firmware
  };

  passthru = { inherit version; };
}
