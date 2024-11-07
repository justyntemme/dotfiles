{
  description = "Darwin-laptop-earth";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
    #nixvim.url = "github:nix-community/nixvim";
    #nixvim.inputs.nikpkgs.follows = "nikpgs";
  };

  outputs = inputs@{self, catppuccin, nix-darwin, home-manager, nixpkgs, ... }:
  let
    configuration = { pkgs, ... }: {
     # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
        [lua-language-server ruff black zsh-autosuggestions zsh-autocomplete zsh clang-tools clang nerdfonts ripgrep kitty neofetch git wget curl zsh-powerlevel10k];

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


      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      security.pam.enableSudoTouchIdAuth = true;
      nixpkgs.overlays = [
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
	      "luarocks"
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
              "cmake"
              "tree-sitter"
          ];

      };

    };
    homeconfig = {lib, pkgs, ...} : {
      home.username = "justyntemme";
      home.stateVersion = "24.05";
      imports = [
              catppuccin.homeManagerModules.catppuccin
      ];
      programs.home-manager.enable = true;
      
      fonts.fontconfig.enable = true;
      programs.neovim = {
	      enable = true;
	      defaultEditor = true;
	      vimAlias = true;
	      vimdiffAlias = true;
	      extraPackages = [
	      	pkgs.lua-language-server
		      pkgs.ansible-language-server
		      pkgs.terraform-ls
		      pkgs.ripgrep
          pkgs.vimPlugins.nvim-lspconfig
		];
	      plugins = [
                pkgs.vimPlugins.lazy-nvim
                pkgs.vimPlugins.nvim-tree-lua
		            pkgs.vimPlugins.catppuccin-nvim
                pkgs.vimPlugins.nerdtree
                pkgs.vimPlugins.fzf-vim
                pkgs.vimPlugins.pretty-fold-nvim
                pkgs.vimPlugins.smartcolumn-nvim
                pkgs.vimPlugins.vim-dotenv
                pkgs.vimPlugins.stabilize-nvim
	     ];
	     extraLuaConfig =
	      let
		plugins = with pkgs.vimPlugins; [
		  # LazyVim
		  LazyVim
		  bufferline-nvim
		  cmp-buffer
		  cmp-nvim-lsp
		  cmp-path
		  cmp_luasnip
		  conform-nvim
		  dashboard-nvim
		  dressing-nvim
		  flash-nvim
		  friendly-snippets
		  gitsigns-nvim
		  indent-blankline-nvim
		  lualine-nvim
		  neo-tree-nvim
		  neoconf-nvim
		  neodev-nvim
		  noice-nvim
		  nui-nvim
		  nvim-cmp
		  nvim-lint
		  nvim-lspconfig
		  nvim-notify
		  nvim-spectre
		  nvim-treesitter
		  nvim-treesitter-context
		  nvim-treesitter-textobjects
		  nvim-ts-autotag
		  nvim-ts-context-commentstring
		  nvim-web-devicons
		  persistence-nvim
		  plenary-nvim
		  telescope-fzf-native-nvim
		  telescope-nvim
		  todo-comments-nvim
		  tokyonight-nvim
		  trouble-nvim
		  vim-illuminate
		  vim-startuptime
		  which-key-nvim
		  { name = "LuaSnip"; path = luasnip; }
		  { name = "mini.ai"; path = mini-nvim; }
		  { name = "mini.bufremove"; path = mini-nvim; }
		  { name = "mini.comment"; path = mini-nvim; }
		  { name = "mini.indentscope"; path = mini-nvim; }
		  { name = "mini.pairs"; path = mini-nvim; }
		  { name = "mini.surround"; path = mini-nvim; }
		];
		mkEntryFromDrv = drv:
		  if lib.isDerivation drv then
		    { name = "${lib.getName drv}"; path = drv; }
		  else
		    drv;
		lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
	      in
	      ''
		require("lazy").setup({
		  defaults = {
		    lazy = true,
		  },
		  dev = {
		    -- reuse files from pkgs.vimPlugins.*
		    path = "${lazyPath}",
		    patterns = { "." },
		    -- fallback to download
		    fallback = true,
		  },
		  spec = {
		    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
		    -- The following configs are needed for fixing lazyvim on nix
		    -- force enable telescope-fzf-native.nvim
		    { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
		    -- disable mason.nvim, use programs.neovim.extraPackages
		    { "williamboman/mason-lspconfig.nvim", enabled = false },
		    { "williamboman/mason.nvim", enabled = false },
		    -- import/override with your plugins
		    { import = "plugins" },
		    -- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
		    { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } },
		  },
		})
	      '';

		#     extraLuaConfig = ''
		#     	vim.g.mapleader = " "
		# -- Open help in a new buffer instead of a vsplit
		# vim.api.nvim_create_autocmd('BufWinEnter', {
		#   		  pattern = '*',
		#   		  callback = function(event)
		#     		    if vim.bo[event.buf].filetype == 'help' then vim.cmd.only() vim.bo.buflisted=true end
		#   		  end,
		# 		  })
		# -- Bootstrapping lazy.nvim
		# local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
		# if not vim.loop.fs_stat(lazypath) then
		#   vim.fn.system({
		# 	    "git",
		# 	    "clone",
		# 	    "--filter=blob:none",
		# 	    "https://github.com/folke/lazy.nvim.git",
		# 	    "--branch=stable", -- latest stable release
		# 	    lazypath,
		# 	  })
		# 	end
		# 	vim.opt.rtp:prepend(lazypath)
		# 	-- Lazy.nvim setup function
		# 	local opts = {
		# 		ui = {
		# 			-- a number <1 is a percentage., >1 is a fixed size
		# 			size = { width = 0.9, height = 0.8 },
		# 			wrap = true,
		# 			-- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
		# 			border = "none",
		# 		},
		# 	}
		# 	require("lazy").setup("plugins", opts)
		#     	      '';
      	};

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
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        oh-my-zsh = {
            enable = true;
            plugins = ["sudo" "git"];
            theme = "robbyrussell";
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
      };

#    programs.nixvim = {
#      extraPlugins = with pkgs; ["neotree" "lsp-format" "nix"];
#      defaultEditor = true;
#      vimAlias = true;
#      vimdiffAlias = true;
#      colorschemes.catppuccin = {
#        enable = true;
#        settings.flavour = "frappe";
#      };
      #plugins  {
      #neo-tree.enable = true;
      #  neo-tree.sources = ["filesystem" "buffers" "git_status" "document_symbols"];
      #  neo-tree.addBlankLineAtTop = false;
      #};
        
      #colorscheme = "catppuccin-frappe";
      
 #   };

      
      home.packages = with pkgs; [ vimPlugins.lazy-nvim kitty
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
