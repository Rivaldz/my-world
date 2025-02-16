{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nodePackages.prettier  # Install Prettier secara global
  ];
}
