{
  lib,
  buildPythonPackage,
  cryptography,
  defusedxml,
  fetchFromGitHub,
  paste,
  poetry-core,
  pyasn1,
  pymongo,
  pytestCheckHook,
  python-dateutil,
  repoze-who,
  requests,
  responses,
  setuptools,
  replaceVars,
  xmlschema,
  xmlsec,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "pysaml2";
  version = "7.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = "pysaml2";
    tag = "v${version}";
    hash = "sha256-DDs0jWONZ78995p7bbyIyZTWHnCI93SsbECqyeo0se8=";
  };

  # FAILED tests/test_50_server.py::TestServer1::test_encrypted_response_6 - saml2.cert.CertificateError: Invalid certificate for encryption!
  # FAILED tests/test_50_server.py::TestServer1NonAsciiAva::test_encrypted_response_6 - saml2.cert.CertificateError: Invalid certificate for encryption!
  # FAILED tests/test_81_certificates.py::TestGenerateCertificates::test_validate_cert_chains - AssertionError: False is not true
  # FAILED tests/test_81_certificates.py::TestGenerateCertificates::test_validate_with_root_cert - AssertionError: False is not true

  doCheck = false;

  patches = [
    (replaceVars ./hardcode-xmlsec1-path.patch {
      inherit xmlsec;
    })
    # Replaces usages of deprecated/removed pyopenssl APIs
    # https://github.com/IdentityPython/pysaml2/pull/977
    ./replace-pyopenssl-with-cryptography.patch
  ];

  postPatch = ''
    # Fix failing tests on systems with 32bit time_t
    sed -i 's/2999\(-.*T\)/2029\1/g' tests/*.xml
  '';

  pythonRelaxDeps = [ "xmlschema" ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    cryptography
    defusedxml
    requests
    xmlschema
  ];

  optional-dependencies = {
    s2repoze = [
      paste
      repoze-who
      zope-interface
    ];
  };

  nativeCheckInputs = [
    pyasn1
    pymongo
    pytestCheckHook
    python-dateutil
    responses
  ];

  disabledTests = [
    # Disabled tests try to access the network
    "test_load_extern_incommon"
    "test_load_remote_encoding"
    "test_load_external"
    "test_conf_syslog"

    # Broken XML schema check in 7.5.2
    "test_namespace_processing"
  ];

  pythonImportsCheck = [ "saml2" ];

  meta = {
    # https://github.com/IdentityPython/pysaml2/issues/947
    broken = lib.versionAtLeast xmlschema.version "4.2.0";
    description = "Python implementation of SAML Version 2 Standard";
    homepage = "https://github.com/IdentityPython/pysaml2";
    changelog = "https://github.com/IdentityPython/pysaml2/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
