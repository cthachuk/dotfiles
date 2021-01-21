{ ... }:
{
  imports = [
    ../personal.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    desktop = {
      bspwm.enable = false;
      plasma.enable = true;
      apps = {
        # discord.enable = true;
        rofi.enable = true;
        # slack.enable = true;
        # teams.enable = true;
        zoom.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox.enable = true;
      };
      gaming = {
        # steam.enable = true;
        # emulators.enable = true;
        # emulators.psx.enable = true;
      };
      media = {
        # daw.enable = true;
        documents = {
          enable = true;
          pdf.enable = true;
        };
        graphics.enable = true;
        # mpv.enable = true;
        # recording.enable = true;
        spotify.enable = true;
      };
      term = {
        default = "alacritty";
        alacritty.enable = true;
      };
      vm = {
        # qemu.enable = true;
      };
    };
    editors = {
      default = "nvim";
      emacs.enable = true;
      vim.enable = true;
    };
    dev = {
      cc.enable = true;
      rust.enable = true;
      shell.enable = true;
      nix.enable = true;
    };
    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      # ergodox.enable = true;
      fs = {
        enable = false;
        # zfs.enable = false;
        ssd.enable = true;
      };
      # nvidia.enable = false;
      sensors.enable = true;
    };
    shell = {
      direnv.enable = true;
      git.enable    = true;
      gnupg = {
        enable = true;
        yubikey.enable = true;
      };
      pass.enable   = true;
      tmux.enable   = true;
      zsh.enable    = true;
    };
    services = {
      ssh.enable = true;
      syncthing.enable = true;
      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    theme.active = "alucard";
  };


  ## Local config
  # programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;
  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  networking.useDHCP = false;
}
