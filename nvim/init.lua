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
			"gbprod/substitute.nvim",
			opts = {
				-- config options
				yank_substituted_text = false,
			},
		},
		{ "echasnovski/mini.icons", version = false },
		{
			"echasnovski/mini.icons",
			opts = {},
			lazy = true,
			specs = {
				{ "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
			},
			init = function()
				package.preload["nvim-web-devicons"] = function()
					require("mini.icons").mock_nvim_web_devicons()
					return package.loaded["nvim-web-devicons"]
				end
			end,
		},
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

		install = { colorscheme = { "catppuccin-frappe" } },
		-- automatically check for plugin updates
		checker = { enabled = true },
		highlight = { enabled = true },
	},
})
-- Custom Functions

-- Define a flag to track whether the autocmd is enabled
local autocmd_enabled = true
-- Function to create the CursorHold autocmd
local create_cursorhold_autocmd = function()
	vim.api.nvim_create_augroup("MyCursorHoldGroup", { clear = true })
	vim.api.nvim_create_autocmd("CursorHold", {
		group = "MyCursorHoldGroup",
		pattern = "*",
		callback = function()
			for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
				if vim.api.nvim_win_get_config(winid).zindex then
					return
				end
			end
			vim.diagnostic.open_float({
				scope = "cursor",
				focusable = false,
				close_events = {
					"CursorMoved",
					"CursorMovedI",
					"BufHidden",
					"InsertCharPre",
					"WinLeave",
					--"User toggle_cursorhold_autocmd", -- Custom event to toggle autocmd
				},
			})
		end,
	})
end
-- Function to toggle the CursorHold autocmd
local toggle_cursorhold_autocmd = function()
	if autocmd_enabled then
		vim.cmd("autocmd! MyCursorHoldGroup") -- Clear the autocmd group
		print("CursorHold autocmd disabled")
	else
		create_cursorhold_autocmd() -- Recreate the autocmd
		print("CursorHold autocmd enabled")
	end
	autocmd_enabled = not autocmd_enabled
end

-- Create the initial autocmd
create_cursorhold_autocmd()
-- Keymaps
-- Map <leader>H to toggle the autocmd
vim.keymap.set("n", "<leader>H", toggle_cursorhold_autocmd, { desc = "Toggle CursorHold autocmd" })
-- substitute Keymaps
vim.keymap.set("n", "m", require("substitute").operator, { noremap = true })
vim.keymap.set("n", "mm", require("substitute").line, { noremap = true })
vim.keymap.set("n", "M", require("substitute").eol, { noremap = true })
vim.keymap.set("x", "m", require("substitute").visual, { noremap = true })
-- Setup functions
require("mini.icons").setup()
require("hardtime").setup()
