{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.gnupg;
in {
  options.modules.shell.gnupg = with types; {
    enable   = mkBoolOpt false;
    yubikey = {
      enable  = mkBoolOpt false;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    ({
      environment.variables.GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";
      programs.gnupg.agent.enable = true;
      user.packages = [ pkgs.tomb ];
      home.configFile = {
        "gnupg/gpg-agent.conf".source = "${configDir}/gnupg/gpg-agent.conf";
        "gnupg/gpg.conf".source = "${configDir}/gnupg/gpg.conf";
      };
    })
    (mkIf cfg.yubikey.enable {
      programs.ssh.startAgent = false;
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      services.pcscd.enable = true;
      services.udev.packages = [ pkgs.yubikey-personalization ];

      environment.systemPackages = with pkgs; [
        yubikey-personalization
      ];

      environment.shellInit = ''
        export GPG_TTY="$(tty)"
        gpg-connect-agent /bye
        #export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      '';
    })
  ]);
}
