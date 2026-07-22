{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    git-repo-manager = {
      url = "github:hakoerber/git-repo-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, git-repo-manager}:
  let
    configuration = { pkgs, ... }: {

      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh.enable = true;
      users.users.aj.shell = pkgs.zsh;
      users.users.aj.home = "/Users/aj";
      users.knownUsers = [ "aj" ];
      users.users.aj.uid = 501;

      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.stateVersion = 6;

      environment.systemPackages = [
        pkgs.wezterm
        pkgs.tldr
        pkgs.pass
        pkgs.gnupg
        pkgs.mutt
        pkgs.tmux
        pkgs.neovim
        pkgs.gh
        pkgs.podman
        pkgs.fzf
        pkgs.ripgrep
        pkgs.tree
        git-repo-manager.packages.aarch64-darwin.git-repo-manager
      ];

      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."Andrews-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ 
	configuration 
        home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aj = import ./home.nix;

          }
      ];
    };
  };
}
