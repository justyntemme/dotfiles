-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({

	spec = {
		-- lazy.nvim
		{
			"m4xshen/hardtime.nvim",
			dependencies = { "MunifTanjim/nui.nvim" },
			opts = {},
		},
		{
			"ray-x/go.nvim",
			dependencies = { -- optional packages
				"ray-x/guihua.lua",
				"neovim/nvim-lspconfig",
				"nvim-treesitter/nvim-treesitter",
			},
			config = function()
				require("go").setup()
			end,
			event = { "CmdlineEnter" },
			ft = { "go", "gomod" },
			build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
		},
		{ "williamboman/mason.nvim", opts = {
			ensure_installed = { "goimports", "gofumpt" },
		} },
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		{
			"catppuccin/nvim",
			lazy = false, -- make sure we load this during startup if it is your main colorscheme
			priority = 1000, -- make sure to load this before all the other start plugins
			config = function()
				-- load the colorscheme here
				vim.cmd([[colorscheme catppuccin-frappe]])
			end,
		},
		-- Configure any other settings here. See the documentation for more details.
		-- colorscheme that will be used when installing plugins.

		install = { colorscheme = { "catppuccin-frappe" } },
		-- automatically check for plugin updates
		checker = { enabled = true },
		highlight = { enabled = true },
	},
})
vim.keymap.set("n", "<leader>H", "<cmd>lua vim.diagnostic.open_float()<cr>", { buffer = bufnr })
-- Global Keybindings
require("hardtime").setup()
