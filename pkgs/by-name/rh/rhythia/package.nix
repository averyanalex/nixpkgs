{ lib
, fetchFromGitHub
, stdenv
, unzip
, alsa-lib
, gcc-unwrapped
, git
, godot3-export-templates
, godot3-headless
, discord-gamesdk
, SDL2
, libudev-zero
, libGLU
, libX11
, libGL
, libXpm
, libXxf86vm
, libXcursor
, libXext
, libXfixes
, libXi
, libXinerama
, libXrandr
, libXrender
, libglvnd
, libpulseaudio
, zlib
}:

stdenv.mkDerivation {
  pname = "rhythia";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "David20122";
    repo = "sound-space-plus";
    rev = "june19-2024-a";
    hash = "sha256-UwWYiksdo4DGmahifptFG3RABdESc4Nj4myiXj65R94=";
  };

  nativeBuildInputs = [
    godot3-headless
    unzip
  ];

  buildInputs = [
    libX11 libGLU libGL libXpm libXext libXxf86vm alsa-lib SDL2
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR

    mkdir -p $HOME/.local/share/godot
    ln -s ${godot3-export-templates}/share/godot/templates $HOME/.local/share/godot

    mkdir -p addons/discord_game_sdk/bin/x86_64/
    # ln -s ${discord-gamesdk}/lib/discord_game_sdk.so addons/discord_game_sdk/bin/x86_64/libdiscord_game_sdk.so
    ln -s ../../libdiscord_game_sdk.so addons/discord_game_sdk/bin/x86_64/libdiscord_game_sdk.so

    ln -s ${./export_presets.cfg} ./export_presets.cfg
    mkdir -p $out/bin/
    godot3-headless --export "Linux/X11" $out/bin/rhythia

    runHook postBuild
  '';

  # dontInstall = true;
  # dontFixup = true;
  # dontStrip = true;

  strictDeps = true;

  meta = with lib; {
    platforms   = platforms.linux;
  };
}
