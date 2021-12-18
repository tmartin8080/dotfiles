" =============================================================================
" Wishlist
" =============================================================================
" - auto complete #{} interpolation in elixir.
" - Markdown completion - https://github.com/ellisonleao/glow.nvim

" =============================================================================
" Interface
" =============================================================================
set autoread

" nnoremap c :bp\|bd #<CR>
au CursorHold * checktime
autocmd InsertEnter,InsertLeave * set cul!
set nocompatible
syntax on
" not necessary on nvim
" filetype plugin indent on
set laststatus=2
set wildmenu
set nu
set nowrap
set tabstop=2
set shiftwidth=2
set expandtab
set endofline
if (has("termguicolors"))
  set termguicolors
endif

" nnoremap <Leader>r :RunInInteractiveShell<Space>
" nnoremap <silent> <F4> :set cursorline! <CR>
inoremap jk <esc>
nnoremap <silent> <CR> :nohlsearch<CR><CR>

autocmd BufWritePost *.exs,*.ex silent :!mix format %

" =============================================================================
" Swp and temp files
" =============================================================================
set nobackup
set nowritebackup
set backupdir=.backup/,~/.backup/,/tmp//
set directory=.swp/,~/.swp/,/tmp//
set undodir=.undo/,~/.undo/,/tmp//

" =============================================================================
" Plugins
" =============================================================================
call plug#begin('~/.config/nvim/autoload/plugged')

  " Theme
  Plug 'sainnhe/edge'
  Plug 'Mofiqul/vscode.nvim'
  Plug 'joshdick/onedark.vim'
  " Plug 'EdenEast/nightfox.nvim'

  " Misc
  Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-ragtag'
  Plug 'scrooloose/nerdtree'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'itchyny/lightline.vim'
  Plug 'itchyny/vim-gitbranch'
  Plug 'macthecadillac/lightline-gitdiff'
  Plug 'ackyshake/vim-fist'                 " Gist handling
  Plug 'djoshea/vim-autoread'               " Auto read edited file
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-commentary'
  Plug 'machakann/vim-highlightedyank'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'mattn/emmet-vim'
  Plug 'gregsexton/MatchTag', { 'for': 'html' }

  " LSP
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'

  " Completion and snips
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'

  " Elixir
  Plug 'mhinz/vim-mix-format'
  Plug 'slime-lang/vim-slime-syntax'

  " Other
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'voldikss/vim-floaterm'
  Plug 'Joorem/vim-haproxy'
  Plug 'ntpeters/vim-better-whitespace'

  " Treesitter - syntax and highlighting
  " :TSInstall query
  " :TSPlaygroundToggle
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
  Plug 'nvim-treesitter/playground'

  " single/multi line code handler: gS - split one line into multiple, gJ - combine multiple lines into one
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'tpope/vim-markdown', { 'for': 'markdown' }
  " Open markdown files in Marked.app - mapped to <leader>m
  Plug 'itspriddle/vim-marked', { 'for': 'markdown', 'on': 'MarkedOpen' }
  Plug 'windwp/nvim-autopairs'

call plug#end()

" =============================================================================
" sainnhe/edge https://vimawesome.com/plugin/edge
"
" Copy edge theme to lightline:
" cp ~/.config/nvim/autoload/plugged/edge/autoload/lightline/colorscheme/edge.vim ~/.config/nvim/autoload/plugged/lightline.vim/autoload/lightline/colorscheme
" =============================================================================
let g:onedark_style = 'warm'
let g:onedark_transparent_background = v:true
colorscheme onedark
set background=dark
set t_Co=256
set laststatus=2
set noshowmode

" =============================================================================
" nvim-treesitter
"
" Syntax parsing and highlighting
" https://github.com/nvim-treesitter/nvim-treesitter
"
" Issues:
" https://github.com/nvim-treesitter/nvim-treesitter/issues/1957
"
" =============================================================================
lua <<EOF
  require'nvim-treesitter.configs'.setup {
    ensure_installed = {"elixir", "yaml", "heex", "markdown", "query", "javascript", "vim", "dockerfile", "bash", "lua", "html", "scss", "css", "json", "json5"},
    sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
    -- ignore_install = { "elixir"}, -- List of parsers to ignore installing
    highlight = {
      enable = true,              -- false will disable the whole extension
      -- disable = { "c", "rust" },  -- list of language that will be disabled
      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = 'o',
        toggle_hl_groups = 'i',
        toggle_injected_languages = 't',
        toggle_anonymous_nodes = 'a',
        toggle_language_display = 'I',
        focus_language = 'f',
        unfocus_language = 'F',
        update = 'R',
        goto_node = '<cr>',
        show_help = '?',
      },
    }
  }
EOF

" =============================================================================
" scrooloose/nerdtree
" https://github.com/preservim/nerdtree
" =============================================================================
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
nnoremap <Leader>v :NERDTreeFind<Enter>
nnoremap <silent> <Leader>f :NERDTreeFocus<CR>
let NERDTreeIgnore = ['\.pyc$', '\.swp$', '\.swo$', '\.DS_Store$']
call add(NERDTreeIgnore, '.git$[[dir]]')
call add(NERDTreeIgnore, 'node_modules$[[dir]]')
call add(NERDTreeIgnore, '_build$[[dir]]')
call add(NERDTreeIgnore, 'deps$[[dir]]')
call add(NERDTreeIgnore, '.elixir_ls$[[dir]]')
call add(NERDTreeIgnore, '.pytest_cache$[[dir]]')
call add(NERDTreeIgnore, '__pycache__$[[dir]]')
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1

"Automatically delete the buffer after deleting or renaming a file
if !exists('g:NERDTreeAutoDeleteBuffer')
  let g:NERDTreeAutoDeleteBuffer = 0
endif

" =============================================================================
" Lightline
" https://github.com/itchyny/lightline.vim
" =============================================================================
let g:lightline = {}
let g:lightline = {
  \   'colorscheme': 'onedark',
  \   'active': {
  \     'left': [['mode', 'paste'],
  \              ['gitbranch', 'gitstatus', 'filename']],
  \     'right': [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok', 'asyncrun_status' ]],
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
  \   },
  \   'component': {
  \     'gitstatus': '%<%{lightline_gitdiff#get_status()}',
  \   },
  \   'component_visible_condition': {
  \     'gitstatus': 'lightline_gitdiff#get_status() !=# ""',
  \   },
  \ }

" =============================================================================
" lightline-gitdiff
"
" https://github.com/macthecadillac/lightline-gitdiff
" =============================================================================
let g:lightline_gitdiff#indicator_added ='+'
let g:lightline_gitdiff#indicator_deleted = '-'
let g:lightline_gitdiff#indicator_modified = '!'
let g:lightline_gitdiff#min_winwidth = '70'

" =============================================================================
" vim-commentary
"
" https://github.com/tpope/vim-commentary
" =============================================================================
autocmd FileType apache setlocal commentstring=#\ %s

" =============================================================================
" autopairs
"
" https://github.com/windwp/nvim-autopairs
" =============================================================================
lua << END
  require('nvim-autopairs').setup()
END

" =============================================================================
"
" New: using williamboman/nvim-lsp-installer
" :LspInstall elixir | efm | xxx
"
" :checkhealth
" =============================================================================
nnoremap <silent><space>D <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent><space>f <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent>gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent>gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent>K  <cmd>lua vim.lsp.buf.hover()<CR>
" method textDocument/rename is not supported by any of the servers registered for the current buffer
nnoremap <silent>rn <cmd>lua vim.lsp.buf.rename()<CR>

" Completion Configuration
set completeopt=menu,menuone,noselect

lua << EOF
  local lsp_installer = require("nvim-lsp-installer")

  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cm.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- Register a handler that will be called for all installed servers.
  -- Alternatively, you may also register handlers on specific server instances instead (see example below).
  lsp_installer.on_server_ready(function(server)
      local opts = {
        capabilities = capabilities
      }

      -- (optional) Customize the options passed to the server
      -- if server.name == "tsserver" then
      --     opts.root_dir = function() ... end
      -- end

      -- This setup() function is exactly the same as lspconfig's setup function.
      -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      server:setup(opts)
  end)
EOF

" =============================================================================
" fzf
" =============================================================================
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
let g:fzf_buffers_jump = 1
nnoremap <c-p> :FZF<cr>
augroup fzf
  autocmd!
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

" =============================================================================
" https://github.com/skanehira/docker-compose.vim
" =============================================================================
" let g:docker_compose_open_terminal_way = 'top'

" =============================================================================
" https://github.com/iamcco/markdown-preview.nvim
" =============================================================================
" nmap <C-p> <Plug>MarkdownPreviewToggle
"
" =============================================================================
" https://github.com/ntpeters/vim-better-whitespace
" =============================================================================
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

" =============================================================================
" markdown
" =============================================================================
let g:markdown_fenced_languages = [ 'tsx=typescript.tsx' ]
nmap <leader>m :MarkedOpen!<cr>
nmap <leader>mq :MarkedQuit<cr>
nmap <leader>* *<c-o>:%s///gn<cr>

" =============================================================================
" Plug 'elixir-editors/vim-elixir'
" =============================================================================
let g:eelixir_default_subtype = "html"
