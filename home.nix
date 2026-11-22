{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/Documents/git/dotfiles";
in
{
  home.username = "lollodo";
  home.homeDirectory = "/home/lollodo";

  # Versione iniziale di Home Manager
  home.stateVersion = "24.11";

  # Permetti a Home Manager di autogestirsi
  programs.home-manager.enable = true;

  # Pacchetti CLI sempre a portata di mano
  home.packages = with pkgs; [
    # Utility essenziali
    age            # Per cifrare/decifrare le chiavi SSH e segreti
    fzf            # Fuzzy finder interattivo
    ripgrep        # Ricerca ultra-veloce nel codice (rg)
    fd             # Alternativa veloce a find
    jq             # Parser JSON da riga di comando
    tree           # Visualizzatore alberi cartelle
    fastfetch      # Info di sistema nel terminale
    btop           # Monitor di risorse avanzato
    bat            # Cat con syntax highlighting
    zoxide         # Navigazione smart directory (usato in .zshrc)

    # Desktop Shell & Temi
    matugen        # Generatore colori Material You (per DankMaterialShell)

    # Strumenti di sviluppo e Cloud
    neovim         # Editor Neovim
    lazygit        # UI da terminale per Git
    git            # Controllo versione Git
    gh             # GitHub CLI
    kubectl        # Gestione cluster Kubernetes
    k9s            # TUI per Kubernetes
    docker-compose # Gestione container
  ];

  # Collegamento dichiarativo dei tuoi dotfiles
  # Usiamo mkOutOfStoreSymlink per permettere a DMS e alle app di salvare file e impostazioni al volo
  xdg.configFile."hypr".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/configs/hypr";
  xdg.configFile."kitty".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/configs/kitty";
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/configs/nvim";
  xdg.configFile."waybar".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/configs/waybar";
  xdg.configFile."DankMaterialShell".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/configs/DankMaterialShell";

  # Zsh configuration
  home.file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/configs/zsh/.zshrc";

  # Servizio Syncthing in background
  services.syncthing.enable = true;
}
