{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, lib, ... }: {
      #Apple Silicon Macs: Compile Intel Binaries
      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';


      #Unlocking sudo via fingerprint
      security.pam.services.sudo_local.touchIdAuth = true;

      #Turn off nix-darwin’s management of the Nix installation, set:
      nix.enable = false;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.vim
          pkgs.cowsay
          pkgs.fortune
          pkgs.fastfetch
          pkgs.magic-wormhole
          pkgs.mosh
          pkgs.claude-code
        ];

      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "claude-code"
      ];

      system.primaryUser ="pedrocosta";
      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";

        taps = [ "tw93/tap" ];
        brews = [ "mole" ];
        casks = [];
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."Macaco" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
