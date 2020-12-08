{ config, lib, ... }:

with lib;
{
  networking.hosts =
    # TODO: update for LAN
    let hostConfig = {
          "192.168.1.2"  = [ "nasa" ];
          "192.168.1.4"  = [ "tuvok" ];
        };
        hosts = flatten (attrValues hostConfig);
        hostName = config.networking.hostName;
    in mkIf (builtins.elem hostName hosts) hostConfig;

  ## Location config -- since Seattle is my 127.0.0.1
  time.timeZone = mkDefault "America/Los_Angeles";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  # For redshift, mainly
  location = (if config.time.timeZone == "America/Los_Angeles" then {
    latitude = 47.6062;
    longitude = 122.3321;
  } else {});
}
