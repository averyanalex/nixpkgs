{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.byedpi;
in
{
  options.services.byedpi = {
    enable = lib.mkEnableOption "ByeDPI, SOCKS proxy server implementing some of DPI bypass methods";

    package = lib.mkPackageOption pkgs "byedpi" { };

    extraArgs = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "--disorder 1 --auto=torst --tlsrec 1+s";
      description = "Extra arguments to pass to the ByeDPI server";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.byedpi = {
      description = "SOCKS proxy server implementing some of DPI bypass methods";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/ciadpi ${cfg.extraArgs}";

        DynamicUser = true;
        User = "byedpi";

        # Hardening
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateIPC = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ averyanalex ];
}
