
set number
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set laststatus=2

nmap <space>e <Cmd>CocCommand explorer<CR>

call plug#begin('/Users/anseljohn/.local/share/nvim/site/autoload')

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" <Tab>: completion
"inoremap <silent><expr> <Tab>
"    \ pumvisible() ? "\<C-N>" :
"    \ coc#refresh()
" <S-Tab>: completion back
"inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<C-H>"
" <CR>: confirm completion, or insert <CR>
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

Plug 'vim-syntastic/syntastic'
execute pathogen#infect()

"Plug 'zxqfl/tabnine-vim'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'
"Plug 'nvim-lua/completion-nvim'
"Plug 'neovim/nvim-lspconfig'
"Plug 'hrsh7th/cmp-nvim-lsp'
"Plug 'hrsh7th/cmp-buffer'
"Plug 'hrsh7th/nvim-cmp'
"Plug 'L3MON4D3/LuaSnip'
"Plug 'saadparwaiz1/cmp_luasnip'
Plug 'navarasu/onedark.nvim'
" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'ludovicchabant/vim-gutentags'

" Or build from source code by using yarn: https://yarnpkg.com
"Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}

call plug#end()

"set completeopt=menu,menuone,noselect

"lua <<EOF
"-- Setup nvim-cmp.
"local cmp = require'cmp'
"
"cmp.setup({
"snippet = {
"	expand = function(args)
"	require('luasnip').lsp_expand(args.body)
"end,
"},
"    mapping = {
"	    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
"	    ['<C-f>'] = cmp.mapping.scroll_docs(4),
"	    ['<C-Space>'] = cmp.mapping.complete(),
"	    ['<C-e>'] = cmp.mapping.close(),
"	    ['<CR>'] = cmp.mapping.confirm({ select = true }),
"	    },
"    sources = {
"	    { name = 'nvim_lsp' },
"	    { name = 'luasnip' },
"	    { name = 'buffer' },
"	    }
"    })
"
"  -- Setup lspconfig.
"  local capabilities = vim.lsp.protocol.make_client_capabilities()
"  capabilities.textDocument.completion.completionItem.snippetSupport = true;
"  require'lspconfig'.gopls.setup{capabilities = capabilities}
"
"  local function map(args)
"  args = vim.tbl_extend("keep", args, {
"	  mode = "", -- The vim mode for this map
"	  keys = nil, -- The input sequence of keys to activate this mapping
"	  to = nil, -- Sequence to keys to 'type' into the editor
"
"	  recurse = false, -- set to true to not include noremap
"	  silent = true, -- set to false to not include <silent>, e.g. the map will not be echoed to the command line
"	  expression = false, -- set to true if the output is to be evaluated rather than typed
"	  plugins = false, -- set to true if the mapping requires plugins and should be disabled when packer wasn't loaded
"	  })
"
"  if (args.plugins) and (not packer_exists) then
"	  return
"  end
"
"  vim.api.nvim_set_keymap(args.mode, args.keys, args.to, { noremap = not args.recurse, silent = args.silent, expr = args.expression })
"end
"
"local function plug_map(args)
"map{keys = args.keys, to = '<Plug>(' .. args.command .. ')', mode = args.mode or 'n', silent = true, recurse = true, plugins = true}
"end
"local function cmd_map(args)
"map{keys = args.keys, to = '<cmd>' .. args.command .. '<CR>', mode = args.mode or 'n', silent = true, plugins = args.plugins == nil and true or args.plugins}
"end
"
"-- TODO: what are these even useful for?
"-- map{mode = 'i', keys = "<C-f>", to = [[compe#scroll({ 'delta': +4 })]], expression = true}
"-- map{mode = 'i', keys = "<C-b>", to = [[compe#scroll({ 'delta': -4 })]], expression = true}
"
"-- Inspired by tpope's rsi.vim, buch much more constrained:
"-- jump to the beginning of the line
"map{mode = 'i', keys = "<C-a>", to = "<C-o>H", recurse = true}
"map{mode = 'c', keys = "<C-a>", to = "<Home>"}
"-- jump to the end of the line
"-- (command mode already has this binding)
"-- (insert mode is covered by compe falling back to <End> in the mapping above)
"
"local is_prior_char_whitespace = function()
"local col = vim.fn.col('.') - 1
"if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
"	return true
"else
"	return false
"end
"end
"
"-- Use (shift-)tab to:
"--- move to prev/next item in completion menu
"--- jump to the prev/next snippet placeholder
"--- insert a simple tab
"--- start the completion menu
"_G.tab_completion = function()
"if vim.fn.pumvisible() == 1 then
"	return vim.api.nvim_replace_termcodes("<C-n>", true, true, true)
"
"elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
"	return vim.api.nvim_replace_termcodes("<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>", true, true, true)
"
"elseif is_prior_char_whitespace() then
"	return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
"
"else
"	return vim.fn['compe#complete']()
"end
"end
"_G.shift_tab_completion = function()
"if vim.fn.pumvisible() == 1 then
"	return vim.api.nvim_replace_termcodes("<C-p>", true, true, true)
"
"elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
"	return vim.api.nvim_replace_termcodes("<C-R>=UltiSnips#JumpBackwards()<CR>", true, true, true)
"
"else
"	return vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true)
"end
"end
"
"map{mode = 'i', keys = "<Tab>", to = [[v:lua.tab_completion()]], expression = true, plugins = true}
"map{mode = 's', keys = "<Tab>", to = [[v:lua.tab_completion()]], expression = true, plugins = true}
"map{mode = 'i', keys = "<S-Tab>", to = [[v:lua.shift_tab_completion()]], expression = true, plugins = true}
"map{mode = 's', keys = "<S-Tab>", to = [[v:lua.shift_tab_completion()]], expression = true, plugins = true}
"
"EOF

"let g:onedark_style = 'warmer'
colorscheme onedark
highlight Normal ctermbg=none
