{
  lib,
  stdenv,
  altair,
  blinker,
  buildPythonPackage,
  cachetools,
  click,
  fetchPypi,
  gitpython,
  importlib-metadata,
  numpy,
  packaging,
  pandas,
  pillow,
  protobuf,
  pyarrow,
  pydeck,
  pympler,
  python-dateutil,
  pythonOlder,
  setuptools,
  requests,
  rich,
  tenacity,
  toml,
  tornado,
  typing-extensions,
  tzlocal,
  validators,
  watchdog,
}:

buildPythonPackage rec {
  pname = "streamlit";
  version = "1.38.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xL82s++HFJntRZRXSDRYMRP5Pwd90wNdUW0pV4byrWM=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "packaging"
    "tenacity"
  ];

  dependencies = [
    altair
    blinker
    cachetools
    click
    gitpython
    importlib-metadata
    numpy
    packaging
    pandas
    pillow
    protobuf
    pyarrow
    pydeck
    pympler
    python-dateutil
    requests
    rich
    tenacity
    toml
    tornado
    typing-extensions
    tzlocal
    validators
  ] ++ lib.optionals (!stdenv.isDarwin) [ watchdog ];

  # pypi package does not include the tests, but cannot be built with fetchFromGitHub
  doCheck = false;

  pythonImportsCheck = [ "streamlit" ];

  postInstall = ''
    rm $out/bin/streamlit.cmd # remove windows helper
  '';

  meta = with lib; {
    homepage = "https://streamlit.io/";
    changelog = "https://github.com/streamlit/streamlit/releases/tag/${version}";
    description = "Fastest way to build custom ML tools";
    mainProgram = "streamlit";
    maintainers = with maintainers; [
      natsukium
      yrashk
    ];
    license = licenses.asl20;
  };
}
