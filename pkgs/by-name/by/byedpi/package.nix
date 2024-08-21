{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "byedpi";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "hufrea";
    repo = "byedpi";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-LS4Dy2xTssYtN7EqWlGRh2MLTlf0kokJ2rHWuarokPE=";
  };

  installPhase = ''
    install -Dm755 ciadpi $out/bin/ciadpi
  '';

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SOCKS proxy server implementing some of DPI bypass methods";
    homepage = "https://github.com/hufrea/byedpi";
    changelog = "https://github.com/hufrea/byedpi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ averyanalex ];
    platforms = lib.platforms.all;
    mainProgram = "ciadpi";
  };
})
