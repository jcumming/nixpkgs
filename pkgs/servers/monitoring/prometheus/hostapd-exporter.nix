{ lib, fetchgit, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "hostapd_prometheus_exporter-${version}";
  version = "1.4";

  # Just a single .py file to use as the application's main entry point.
  format = "other";

  src = fetchgit {
    rev = "v${version}";
    url = "https://bitbucket.i2cat.net/scm/~miguel_catalan/hostapd_prometheus_exporter.git";
    sha256 = "0zgblxk2qkqcskf4g7ysy518kcyf8k3s63cavabq7jbq8i95wpcf";
  };

  propagatedBuildInputs = with python3Packages; [ prometheus_client ];

  installPhase = ''
    mkdir -p $out/share/
    cp hostapd_exporter.py $out/share/
  '';

  fixupPhase = ''
    makeWrapper "${python3Packages.python.interpreter}" "$out/bin/hostapd_exporter" \
          --set PYTHONPATH "$PYTHONPATH" \
          --add-flags "$out/share/hostapd_exporter.py"
  '';

  meta = with lib; {
    description = "Prometheus exporter that exposes metrics from a hostapd daemon";
    homepage = "https://bitbucket.i2cat.net/users/miguel_catalan/repos/hostapd_prometheus_exporter/";
    license = licenses.mit;
    maintainers = with maintainers; [ jcumming ];
    platforms = platforms.unix;
  };
}
