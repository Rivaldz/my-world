{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    (pkgs.runCommand "php81-custom" {} ''
      mkdir -p $out/bin
      ln -s ${pkgs.php81}/bin/php $out/bin/php81
      ln -s ${pkgs.php81}/bin/php-fpm $out/bin/php81-fpm
    '')

    (pkgs.runCommand "php82-custom" {} ''
      mkdir -p $out/bin
      ln -s ${pkgs.php82}/bin/php $out/bin/php82
      ln -s ${pkgs.php82}/bin/php-fpm $out/bin/php82-fpm
    '')
  ];
}

