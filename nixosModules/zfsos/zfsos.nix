{ lib, config, self, ... }:
let
  cfg = config.nixOnZfsos;
in {
  imports = [
    self.nixosModules.zfs-rollback
  ];
  config = lib.mkIf cfg.enable {
    boot = {
      kernelParams = [ "nohibernate" ];
      tmp.cleanOnBoot = true;
    };
    fileSystems = {
      "/" = { neededForBoot = true; };
      "/persist" = { neededForBoot = true; };
      "/mnt/${cfg.diskName}" = { neededForBoot = true; };
    };
    zfs-rollback = {
      enable = true;
      snapshot = "blank";
      volume = "${cfg.diskName}-zfsos/faketmpfs";
    };
    environment.persistence."/persist" = {
      enable = true;
      hideMounts = true;
      directories = [
        "/var/lib/nixos"
        "/var/log"
        "/var/lib/systemd/coredump"
      ];
    };
  } // (import ./templates/zfsos.nix {
    inherit (cfg) diskName device ashift swapSize;
  });
}

