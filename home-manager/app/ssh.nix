{ config, pkgs, ... }:


{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "ssh-idp" = {
        hostname = "103.226.139.14";
        user = "ideplex";
        port = 3311; 
        extraOptions = {
          ServerAliveInterval = "60";
        };
      };
      "ssh-idp-tunnel" = {
         hostname = "103.226.139.14";
         user = "ideplex";
         port = 3311;
         localForwards = [
            {
             bind.port = 3326;
             host.address = "localhost";
             host.port = 3306;
            }
         ];
         extraOptions = {
           ServerAliveInterval = "60";
         };
      };
      "ssh-gaia1" = {
        hostname = "194.233.77.133";
        user = "rivaldo";
        extraOptions = {
          ServerAliveInterval = "60";
        };
      };
      "ssh-acumen" = {
        hostname = "194.163.32.242";
        user = "u842193292";
        port = 65002;
        extraOptions = {
          ServerAliveInterval = "60";
        };
      };
      "ssh-niaga" = {
        hostname = "46.17.173.55";
        user = "u1378024";
        port = 65002;
        identityFile = "${config.home.homeDirectory}/ssh_key/niaga.pem";
        extraOptions = {
          ServerAliveInterval = "60";
        };
      };
      "ssh-my-vps" = {
        hostname = "103.226.138.133";
        user = "rivaldo";
        extraOptions = {
          ServerAliveInterval = "60";
        };
      };
      "ssh-stb" = {
        hostname = "192.168.0.115";
        user = "rivaldo";
        port = 2253;
        extraOptions = {
          ServerAliveInterval = "60";
        };
      };
      "ssh-gcp" = {
        hostname = "34.101.207.35";
        user = "rivaldo";
        extraOptions = {
          ServerAliveInterval = "60";
        };
      };
    };
  };
}

