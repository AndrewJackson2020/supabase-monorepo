# home.nix

{ config, pkgs, ... }:

{
  home.stateVersion = "26.05"; # Please read the comment before changing.

  home.file = {
    ".zshrc".source = ./home/.zshrc;

  };
  home.username = "aj";

  programs.home-manager.enable = true;
}
