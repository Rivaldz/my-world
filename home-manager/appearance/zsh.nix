{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;

    # Enable Oh My Zsh
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "vi-mode"
      ];
      #theme = "powerlevel10k/powerlevel10k";
    };

    #initExtra = builtins.readFile ~/my-world/.zshrc;
    initExtra = ''
                  ${builtins.readFile ~/my-world/.zshrc}

                  # Load Powerlevel10k from Nix store
                  source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

                  # Load Powerlevel10k config if available
                  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
              '';

    shellAliases = {
      pas="php artisan serve";
      pas8001="php artisan serve --port=8001";
      clr="clear";
      dlocal="cd /mnt/c/Users/rivaa/";
      php82="sudo update-alternatives --set php /usr/bin/php8.2 && sudo update-alternatives --set phar /usr/bin/phar8.2 && sudo update-alternatives --set phar.phar /usr/bin/phar.phar8.2";
      php8="sudo update-alternatives --set php /usr/bin/php8.1 && sudo update-alternatives --set phar /usr/bin/phar8.1 && sudo update-alternatives --set phar.phar /usr/bin/phar.phar8.1";
      php7="sudo update-alternatives --set php /usr/bin/php7.4 && sudo update-alternatives --set phar /usr/bin/phar7.4 && sudo update-alternatives --set phar.phar /usr/bin/phar.phar7.4";
      php5="sudo update-alternatives --set php /usr/bin/php5.6 && sudo update-alternatives --set phar /usr/bin/phar5.6 && sudo update-alternatives --set phar.phar /usr/bin/phar.phar5.6";
      phpv="php -v";
      route="php artisan route:cache";
      php74="/usr/bin/php7.4";
      off-screen="xset dpms force off";
      hms="home-manager switch";
      hmb="home-manager build";
      cat="bat";
    };
  };

  # Ensure required packages are installed
  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];
}
