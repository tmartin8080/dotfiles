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

  Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-ragtag'
  Plug 'sainnhe/edge'
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
  Plug 'nvim-lua/completion-nvim'
  Plug 'kabouzeid/nvim-lspinstall'

  " Elixir
  Plug 'elixir-editors/vim-elixir'
  Plug 'mhinz/vim-mix-format'
  Plug 'slime-lang/vim-slime-syntax'

  " Other
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'vim-ruby/vim-ruby'
  Plug 'hashivim/vim-terraform'
  Plug 'skanehira/docker-compose.vim'
  Plug 'voldikss/vim-floaterm'
  Plug 'Joorem/vim-haproxy'
  Plug 'ntpeters/vim-better-whitespace'
  " Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
  " :TSInstall query
  " :TSPlaygroundToggle
  " Plug 'nvim-treesitter/playground'
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
colorscheme edge
let g:edge_style = 'aura'
let g:edge_disable_italic_comment = 1
set background=dark
set t_Co=256
set laststatus=2
set noshowmode

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
  \   'colorscheme': 'edge',
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
" vim-gitbranch
"
" https://github.com/itchyny/vim-gitbranch
" =============================================================================

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
" nvim-lsp
"
" New: using 'kabouzeid/nvim-lspinstall'
" :LspInstall elixir | efm | xxx
"
" :checkhealth
"
" https://github.com/neovim/nvim-lspconfig/blob/a21a509417aa530fb7b54020f590fa5ccc67de77/CONFIG.md#elixirls
"
" Keybinging & Completion:
" https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
"
" EFM: install with nvim-lspinstall
" vim ~/.config/efm-langserver/config.yaml
"
" Debug LS:
" 1. :lua print(vim.lsp.get_log_path())
" 2. tail -f ~/.cache/nvim/lsp.log
" 3. Open language file project and see what happens
" =============================================================================
nnoremap <silent><space>D <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent><space>f <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent>gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent>gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent>K  <cmd>lua vim.lsp.buf.hover()<CR>
" method textDocument/rename is not supported by any of the servers registered for the current buffer
nnoremap <silent>rn <cmd>lua vim.lsp.buf.rename()<CR>

" must be absolute path to language server script
lua << END
  local function setup_servers()

    local lspinstall = require'lspinstall'
    lspinstall.setup()

    local servers = lspinstall.installed_servers()
    local lspconfig = require'lspconfig'

    -- Neovim doesn't support snippets out of the box, so we need to mutate the
    -- capabilities we send to the language server to let them know we want snippets.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    for _, server in pairs(servers) do
      lspconfig[server].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end
  end

  setup_servers()

  -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
  require'lspinstall'.post_install_hook = function ()
    setup_servers() -- reload installed servers
    vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
  end

END

" Completion
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" =============================================================================
" ultisnips
"
" =============================================================================
let g:completion_enable_snippet = 'UltiSnips'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

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
" nvim-lua/completion-nvim
" https://github.com/nvim-lua/completion-nvim
" :h ins-completion
" =============================================================================
let g:completion_enable_snippet = 'UltiSnips'

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

function! CleverTab()
   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
      return "\<Tab>"
   else
      return "\<C-N>"
   endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>

autocmd BufEnter * lua require'completion'.on_attach()

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
