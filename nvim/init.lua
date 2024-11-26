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
		{
			"nvim-telescope/telescope.nvim",
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = "gosum",
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		},
		{ "williamboman/mason.nvim", opts = {
			ensure_installed = { "goimports", "gofumpt" },
		} },
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		{ import = "lazyvim.plugins.extras.lang.python" },
		{ import = "lazyvim.plugins.extras.lang.go" },
		{
			"nvim-treesitter/nvim-treesitter",
			opts = {
				ensure_installed = { "go", "gomod", "gowork", "gosum" },
			},
		},
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
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				gopls = {
					settings = {
						gopls = {
							gofumpt = true,
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							analyses = {
								fieldalignment = true,
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							staticcheck = true,
							directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
							semanticTokens = true,
						},
					},
				},
			},
			setup = {
				gopls = function(_, opts)
					-- workaround for gopls not supporting semanticTokensProvider
					-- https://github.com/golang/go/issues/54531#issuecomment-1464982242
					LazyVim.lsp.on_attach(function(client, _)
						if not client.server_capabilities.semanticTokensProvider then
							local semantic = client.config.capabilities.textDocument.semanticTokens
							client.server_capabilities.semanticTokensProvider = {
								full = true,
								legend = {
									tokenTypes = semantic.tokenTypes,
									tokenModifiers = semantic.tokenModifiers,
								},
								range = true,
							}
						end
					end, "gopls")
					-- end workaround
				end,
				vim.keymap.set("n", "gb", "<cmd>GoRun<cr>", { buffer = bufnr }),
			},
		},
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
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("fzf")
--require'lspconfig'.pyright.setup{}
require("lspconfig").ruff.setup({
	on_attach = function(client, bufnr)
		vim.keymap.set("n", "gb", "<cmd>!python3 %<cr>", { buffer = bufnr })
	end,
})
