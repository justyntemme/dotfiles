{
  description = "Darwin-laptop-earth";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs, ... }:
  let
	#   darwinConfigurations = {
	# hostname = nix-darwin.lib.darwinSystem {
	# system = "aarch64-darwin";
	# modules = [
	# ./configurations.nix
	# home-manager.darwinModules.home-manager
	# {
	#   home-manager.useGlobalPkgs = true;
	#   home-manager.useUserPackages = true;
	#   home-manager.users.justyntemme = import ./home.nix;
	#   }
	#   ];
	#   };
	#
	#
	#   }
	#
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
        [ neofetch vim git wget curl zsh-powerlevel10k];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;
     # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";
     # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      security.pam.enableSudoTouchIdAuth = true;


      system.defaults = {
          dock.autohide = false;
          finder.AppleShowAllExtensions = true;
      };

      homebrew = {
        enable = true;
        onActivation = {
          autoUpdate = true;
          cleanup = "uninstall";
          upgrade = true;
        };
        casks = [
          "cocoapods"
          "visual-studio-code"
          "postman"
          "android-platform-tools"
          "firefox"
          "google-chrome"
          "kitty"
          "notion"
        ];

        brews = [
              "zsh-autosuggestions"
              "tailscale"
              "imagemagick"
              "rust"
              "sqlite"
              "python"
              "gnupg"
              "git"
              "go"
              "gcc"
              "node"
              "llvm"
              "neovim"
              "cmake"
              "tree-sitter"
              "zsh"
          ];

      };

    };
    homeconfig = {pkgs, fetchgit, ...} : {
      home.stateVersion = "24.05";
      programs.home-manager.enable = true;

      home.file.".config/nvim/init.lua" = {
        source = builtins.fetchGit {
	  url = "https://github.com/justyntemme/dotfiles";
	  sparseCheckout = [
	    ".config/init.lua"
	  ];
	  
	};
      };
      home.packages = with pkgs; [];

      home.sessionVariables = {
      EDITOR = "nvim";
      };

      };

  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#earth
    darwinConfigurations."earth" = nix-darwin.lib.darwinSystem {
      modules = [ 
      	configuration
	home-manager.darwinModules.home-manager {
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.verbose = true;
	  #home-manager.users.justyntemme = homeconfig;
	  }
	];
      specialArgs = { inherit inputs; };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."earth".pkgs;
  
    environment.systemPackages = [ 
      ];

    fonts.packages = [
    "fira-code-nerdfont"
    ];
    };

}
