require "core"
-- Install vim-plug if not already installed
local plug_path = vim.fn.stdpath('data') .. '/site/autoload/plug.vim'
if vim.fn.filereadable(plug_path) == 0 then
  vim.fn.system({ 'curl', '-fLo', plug_path, '--create-dirs',
    'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' })
end

-- Load vim-plug and define plugins
vim.cmd([[call plug#begin('~/.local/share/nvim/plugged')]])
vim.cmd([[Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }]])
vim.cmd([[Plug 'neovim/nvim-lspconfig']])
vim.cmd([[Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }]])
vim.cmd([[call plug#end()]])
-- vim.call('deoplete#custom#option', 'omni_patterns', {
--   ['go'] = '[^. *\t]\\.[[:alnum:]_]*'
-- })
--“ Go syntax highlighting
vim.g.go_highlight_fields = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_extra_types = 1
vim.g.go_highlight_operators = 1

-- “ Auto formatting and importin
vim.g.go_fmt_autosave = 1
vim.g.go_fmt_command = "goimports"
--
--
vim.call('deoplete#custom#option', 'omni_patterns', {
 ['go'] = '[^. *\t]\\.\\w*',
})

vim.cmd([[call deoplete#enable()]])
-- vim.g.deoplete.sources.jedi.python_path = "/opt/homebrew/opt/python@3.11/bin/python3.11
-- Enable deoplete
vim.g['deoplete#enable_at_startup'] = 1
-- vim.g.deoplete.enable_at_startup = 1
vim.g.python3_host_prog = "/opt/homebrew/opt/python@3.11/bin/python3.11"
vim.g.go_def_mode = 'gopls'
vim.g.go_info_mode = 'gopls'
require'lspconfig'.gopls.setup{}
local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"
