{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    (python312.withPackages (ps: with ps; [
      pip
      black
      isort
      flake8
    ]))
    gcc.cc.lib
  ];

  # optional: ensure library path is set
  home.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.gcc.cc.lib}/lib";
  };
}

