{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      challengeResponseAuthentication = false;
      passwordAuthentication = false;
    };

    user.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCpYjYLUV9tz+oCG9JU1kkPtiCVTuPTaDfZsGAdeJzEDN5MxSK1TSNM1q22iOfWeaG/x7wOEb4HLPStrnUmnw4ZmgA4988YyH7p+/4RdkHu00+dbNt+x7JUBqkw0CWg+n6Low6XC8T6FqO41CedJOcyhbZtwLY88kwLoU5wswFBswS19btRzSbkIWPGKfSoK3AE1Ixlo9ln3W1SOqKOAztslhXGTJCVeoDsTbYjZsX61sdctBxbetKsCSO0OTnmXEQwS2SyhdMWUrLPitbNmNLXmDZvkGyoq4iUugkrCVy0JPOj2f/PKbV3kkYkRRZozcYiVle6giKbIRD8tjj+dun5sND+iTpuSjC5vrZmKO477XqNEI4XlO7Wk4Dk7/ZPOZBP4T+bsAu8abX2bRoyO1NKJX18dRQddUKPyu2lKkWkqzu3VQ8RiN9tMnhka3Pi3BZJ/3gEZSUBS/ItBtzULBx0ig6YeOrSabxohMHLjL0YAoHZWsabfWjkdJ74mKcQ18ibexSW60kcpx0DrekolozUEAXGn2ZS4A2em+FveJ9W5r6Y+oBxnAWGSCDYynWN/6ab1Ds2TyJ1SBCSVa1KKL//76+xhA9BjbmV9rgxdDOlC4lkCQ91Cif+2i2vp2nxUFZilqKPLaxpdvbI6PKaLT/xbmasiO1TTQ9D0Fy7LUF/kQ== cardno:000610540523"
    ];
  };
}
