{ config, pkgs, ... }:

{

  # Dynamically set username and home directory
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  imports = [
      "${builtins.getEnv "HOME"}/.config/home-manager/appearance/zsh.nix"
      ./appearance/lsp_package.nix
  ];

  home.packages = with pkgs; [
   bat
   speedtest-cli
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
