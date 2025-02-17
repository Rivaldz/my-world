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
      phpv="php -v";
      route="php artisan route:cache";
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
