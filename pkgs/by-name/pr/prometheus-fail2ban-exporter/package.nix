{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fail2ban-prometheus-exporter";
  version = "v0.10.1";

  src = fetchFromGitHub {
    rev = version;
    owner = "hectorjsmith";
    repo = "fail2ban-prometheus-exporter";
    sha256 = "sha256-zGEhDy3uXIbvx4agSA8Mx7bRtiZZtoDZGbNbHc9L+yI=";
  };

  vendorHash = "sha256-5o8p5p0U/c0WAIV5dACnWA3ThzSh2tt5LIFMb59i9GY=";

  meta = with lib; {
    description = "Collect and export metrics on Fail2Ban";
    homepage = "https://gitlab.com/hectorjsmith/fail2ban-prometheus-exporter";
    license = licenses.mit; 
    maintainers = with maintainers; [ jcumming ];
    platforms = platforms.linux;
  };
}
