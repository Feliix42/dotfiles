{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    borgbackup
  ];

  services.borgbackup.jobs.rootBackup = {
    paths = "/";
    exclude = [ "/nix" "/home/felix/mnt" "/home/*/.cache" "/home/*/.stack" "/home/**/.stack_work" ];
    repo = "/home/felix/mnt/entropy-backup";
    removableDevice = true;
    doInit = true;

    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /home/felix/.config/entropy-backup";
    };
    compression = "auto,lzma";
    startAt = [ ];
    # startAt = "weekly";

    prune.keep = {
      within = "1d"; # Keep all archives from the last day
      daily = 7;
      weekly = 4;
      monthly = -1;  # Keep at least one archive for each month
    };

  };
}
