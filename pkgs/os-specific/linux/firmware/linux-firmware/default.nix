{ stdenvNoCC, fetchgit, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "linux-firmware";
  version = "20220209";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "refs/tags/${version}";
    sha256 = "sha256-QWGnaGQrDUQeYUIBq0/63YdHZgyaF4s9fdyLA9bb6qs=";
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
  outputHash = "sha256-ahXZK13wrcZW/8ZCgUTHU6N4QKsL3NV98eRbYGBp3jw=";

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
