{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {

      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh.enable = true;
      users.users.aj.shell = pkgs.zsh;
      users.knownUsers = [ "aj" ];
      users.users.aj.uid = 501;


      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.stateVersion = 6;

      environment.systemPackages = [
        pkgs.wezterm
        pkgs.tldr
        pkgs.mutt
        pkgs.tmux
      ];

      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."Andrews-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
