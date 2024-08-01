{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "amneziawg";
  version = "1.0.20240711";

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amneziawg-linux-kernel-module";
    rev = "v${version}";
    hash = "sha256-WOcBTxetVz2Sr62c+2aGNyohG2ydi+R+az+4qHbKprI=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preBuild = ''
    cd src
    ln -s ${kernel.src} kernel
  '';

  buildFlags = [
    "apply-patches"
    "module"
  ];

  makeFlags = kernel.makeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  INSTALL_MOD_PATH = placeholder "out";
  installFlags = [ "DEPMOD=true" ];
  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kernel module for the AmneziaWG";
    homepage = "https://amnezia.org/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ averyanalex ];
    platforms = lib.platforms.linux;
  };
}
