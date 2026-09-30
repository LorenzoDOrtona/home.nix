{
  description = "Lollodo's Nix Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      # Supporto sia per Apple Silicon (aarch64) che per normali PC x86_64
      mkHome = system: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [ ./home.nix ];
      };
    in {
      homeConfigurations = {
        # Configurazione principale per Mac M2 (Fedora Asahi aarch64)
        "lollodo" = mkHome "aarch64-linux";

        # Configurazione di backup per macchine x86_64
        "lollodo-x86" = mkHome "x86_64-linux";
      };
    };
}
