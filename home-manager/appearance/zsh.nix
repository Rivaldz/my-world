{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    initExtra = builtins.readFile ~/my-world/.zshrc;
    oh-my-zsh.enable = true;
  };
}
