local vim = vim
local Plug = vim.fn['plug#']

vim.wo.number = true

-- Shortcuts
vim.cmd([[

nnoremap <leader>e :NvimTreeToggle<CR>
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

set relativenumber
set rnu
set tabstop=2
set shiftwidth=2
set expandtab

]])

vim.call('plug#begin')

vim.cmd([[
Plug 'nvim-tree/nvim-web-devicons' " optional
Plug 'nvim-tree/nvim-tree.lua'
Plug 'EdenEast/nightfox.nvim' " Vim-Plug
Plug 'folke/tokyonight.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
]])



vim.call('plug#end')

-- nvim tree setup
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  view = {
    relativenumber = true
  },
})

vim.cmd [[colorscheme carbonfox]]
