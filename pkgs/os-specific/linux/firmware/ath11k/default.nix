{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ath11k-QCN9074";
  # XXX: there is other fw in this repo, but I'm just gonna cherry-pick the stuff I want
  version = "2.7.0.1";

  src = fetchFromGitHub {
#https://github.com/kvalo/ath11k-firmware
    owner = "kvalo";
    repo = "ath11k-firmware";
    rev = "5f72c2124a9b29b9393fb5e8a0f2e0abb130750f";    
    sha256="sha256-l7tAxG7udr7gRHZuXRQNzWKtg5JJS+vayk44ZmisfKg=";
  };

  phases = "installPhase"; 

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/firmware/ath11k/QCN9074/hw1.0

    cp $src/QCN9074/hw1.0/2.7.0.1/WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1/* .
    cp $src/QCN9074/hw1.0/board-2.bin . 

    xz * 

    cp *.xz $out/lib/firmware/ath11k/QCN9074/hw1.0

    runHook postInstall
  '';

  meta = {
    description = "firmware for ath11k.ko";
    homepage = "https://github.com/kvalo/ath11k-firmware";
  };
})
