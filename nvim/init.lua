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

	spec = { -- add your plugins here
		{ "neovim/nvim-lspconfig" },
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		{ import = "lazyvim.plugins.extras.lang.python" },
		--	{"nvim-treesitter/nvim-treesitter"},
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
-- Add custom LSP keybindings
local lspconfig = require("lspconfig")

-- Setup rust-analyzer with a keybinding for RustRun
lspconfig.rust_analyzer.setup({
	on_attach = function(_, bufnr)
		-- Keybinding specific to Rust buffers
		vim.keymap.set("n", "gb", "<cmd>RustRun<cr>", { buffer = bufnr })
		vim.keymap.set("n", "gF", "<cmd>RustFmt<cr>", { buffer = bufnr })
		vim.keymap.set("n", "g<leader>", "<cmd>RustTest<cr>", { buffer = bufnr })
	end,
})
--
--require'lspconfig'.pyright.setup{}
require("lspconfig").ruff.setup({
	on_attach = function(client, bufnr)
		vim.keymap.set("n", "gb", "<cmd>!python3 %<cr>", { buffer = bufnr })
	end,
})
