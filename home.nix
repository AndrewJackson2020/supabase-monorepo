# home.nix

{ config, pkgs, ... }:

{
  home.stateVersion = "26.05"; # Please read the comment before changing.

  home.file = {
    ".zshrc".source = ./home/.zshrc;
    ".wezterm.lua".source = ./home/.wezterm.lua;
    "Pictures/wezterm_background.jpg".source = ./home/Pictures/wezterm_background.jpg;

  };
  home.username = "aj";

  programs.home-manager.enable = true;
}
