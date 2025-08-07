{ config, pkgs, ... }:

{

  # Dynamically set username and home directory
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  imports = [
      "${builtins.getEnv "HOME"}/.config/home-manager/appearance/zsh.nix"
      ./appearance/lsp_package.nix
      ./app/ssh.nix
      ./app/php.nix
      ./app/go.nix
  ];

  home.packages = with pkgs; [
    bat
    speedtest-cli
    go-swag
    go-migrate
    air
    fzf
    kubectl
    stern
    google-cloud-sdk
    libxml2
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
