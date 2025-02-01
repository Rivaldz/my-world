{ config, pkgs, ... }:

{
  home.username = "rivaldo";
  home.homeDirectory = "/home/rivaldo";

  home.stateVersion = "24.11"; # Please read the comment before changing.
  
  imports = [
      /home/rivaldo/.config/home-manager/appearance/zsh.nix
  ];

  home.packages = with pkgs; [
   bat
   speedtest-cli
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
