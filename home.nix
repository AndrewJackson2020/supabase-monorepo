# home.nix

{ config, pkgs, ... }:

{
  home.stateVersion = "26.05"; # Please read the comment before changing.

  home.file = {
    ".zshrc".source = ./home/.zshrc;
    ".wezterm.lua".source = ./home/.wezterm.lua;
    "Pictures/wezterm_background.jpg".source = ./home/Pictures/wezterm_background.jpg;
    ".config/nvim/init.lua".source = ./home/.config/nvim/init.lua;
    ".config/nvim/lua/config/lazy.lua".source = ./home/.config/nvim/lua/config/lazy.lua;
    ".config/nvim/lua/plugins/telescope.lua".source = ./home/.config/nvim/lua/plugins/telescope.lua;
    ".config/nvim/lua/plugins/tokyonight.lua".source = ./home/.config/nvim/lua/plugins/tokyonight.lua;

  };
  home.username = "aj";

  programs.home-manager.enable = true;
}
