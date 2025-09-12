{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    go
    go-swag
    go-migrate
  ];
}
