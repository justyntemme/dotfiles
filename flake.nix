{
  description = "Darwin-laptop-earth";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
    LazyVim.url = "github:matadaniel/LazyVim-module";
    LazyVim.inputs.nixpkgs.follows = "nixpkgs";
    nixneovimplugins.url = github:jooooscha/nixpkgs-vim-extra-plugins;
  };

  outputs = inputs@{self, catppuccin, nix-darwin, LazyVim, home-manager, nixpkgs, ... }:
  let
    configuration = { pkgs, ... }: {
     # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
        [nerdfonts ripgrep kitty neofetch git wget curl zsh-powerlevel10k LazyVim];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      environment.variables = {
       #TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
      };
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
      nixpkgs.overlays = [
        inputs.nixneovimplugins.overlays.default
	    ];




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
              # "neovim"
              "cmake"
              "tree-sitter"
              "zsh"
          ];

      };

    };
    homeconfig = {pkgs, ...} : {
      home.username = "justyntemme";
      home.stateVersion = "24.05";
      imports = [
              catppuccin.homeManagerModules.catppuccin
	            inputs.LazyVim.homeManagerModules.default
      ];
      programs.home-manager.enable = true;
      programs.lazyvim = {
         enable = true;
      };
      fonts.fontconfig.enable = true;
      
      #home.fonts.fontsconfig.enable = true;

      # programs.neovim = {
      #   plugins =  with pkgs.vimPlugins; [
      #   "ruff"
      #   "clangd_extensions"
      #   ];
      # };
      programs.git = {
	      enable = true;
	      userName = "Justyn Temme";
	      userEmail = "justyntemme@gmail.com";
	      extraConfig = {
	        pull = {
	          rebase = true;
	        };
	      };

      };

      programs.zsh = {
        enable = true;
        oh-my-zsh = {
            enable = true;
            plugins = ["git"];
            theme = "powerlevel10k";
          };
      };

      programs.kitty = {
        enable = true;
	      catppuccin.enable = true;
        catppuccin.flavor = "frappe";
        font = {
            name = "FiraCode Nerd Font Mono";
            package = pkgs.fira-code;
            size = 12;
          };
        #font = pkgs.nerdfonts;
        #font = "FiraCode Nerd Font Mono";
        # font = {
        #   #package = "FiraCode Nerd Font Mono";
        # };
      };

	    programs.neovim = {
	      defaultEditor = true;
	      vimAlias = true;
	      vimdiffAlias = true;
	      plugins = [
	        # nvim-lspconfig
	        # nvim-treesitter.withAllGrammars
	        # pkgs.vimExtraPlugins.catppuccin-nvim
	        pkgs.vimExtraPlugins.lazy-nvim
          pkgs.vimExtraPlugins.mason-nvim
	        pkgs.vimExtraPlugins.catppuccin
	     ];
	    };

      
      home.packages = with pkgs; [
      (pkgs.nerdfonts.override { fonts = ["FiraCode"]; })
      ];

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
      	  users.users.justyntemme.home = "/Users/justyntemme";
	        home-manager.users.justyntemme = homeconfig;
	    }
	];
      specialArgs = { inherit inputs;  };


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
