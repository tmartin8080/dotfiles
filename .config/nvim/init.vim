" =============================================================================
" Interface
" =============================================================================
set autoread
" nnoremap c :bp\|bd #<CR>
au CursorHold * checktime
autocmd InsertEnter,InsertLeave * set cul!
set nocompatible
syntax on
filetype plugin indent on
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
set backupdir=.backup/,~/.backup/,/tmp//
set directory=.swp/,~/.swp/,/tmp//
set undodir=.undo/,~/.undo/,/tmp//

" =============================================================================
" Plugins
" =============================================================================
call plug#begin('~/.config/nvim/autoload/plugged')

  Plug 'tpope/vim-sensible'
  Plug 'sainnhe/edge'
  Plug 'scrooloose/nerdtree'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'itchyny/lightline.vim'
  Plug 'itchyny/vim-gitbranch'
  Plug 'macthecadillac/lightline-gitdiff'
  Plug 'ackyshake/vim-fist'                 " Gist handling
  Plug 'djoshea/vim-autoread'               " Auto read edited file
  Plug 'jiangmiao/auto-pairs'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-commentary'
  Plug 'machakann/vim-highlightedyank'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'mattn/emmet-vim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/completion-nvim'
  Plug 'elixir-editors/vim-elixir'
  Plug 'mhinz/vim-mix-format'
  Plug 'SirVer/ultisnips'
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'vim-ruby/vim-ruby'
  Plug 'hashivim/vim-terraform'
  Plug 'skanehira/docker-compose.vim'
  Plug 'voldikss/vim-floaterm'
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
  Plug 'Joorem/vim-haproxy'
  Plug 'ntpeters/vim-better-whitespace'

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
" auto-pairs
"
" https://github.com/jiangmiao/auto-pairs
" =============================================================================
" When the filetype is FILETYPE then make AutoPairs only match for parenthesis
au Filetype FILETYPE let b:AutoPairs = {"(": ")"}
au FileType php      let b:AutoPairs = AutoPairsDefine({'<?' : '?>', '<?php': '?>'})
au FileType html     let b:AutoPairs = AutoPairsDefine({'<%=' : '%>', '<%': '%>'})

" =============================================================================
" nvim-lsp
"
" INSTALL elixir-ls:
" rm -rf ~/.elixir-ls
" curl -fLO https://github.com/elixir-lsp/elixir-ls/releases/download/v0.7.0/elixir-ls-1.11.zip
" unzip elixir-ls-1.11.zip -d ~/.elixir-ls
" chmod +x ~/.elixir-ls/language_server.sh
"
" :checkhealth
"
" https://github.com/neovim/nvim-lspconfig/blob/a21a509417aa530fb7b54020f590fa5ccc67de77/CONFIG.md#elixirls
"
" Keybinging & Complettion:
" https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
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
  require'lspconfig'.elixirls.setup{
    cmd = { "/Users/mac/.elixir-ls/language_server.sh" };
  }
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
" let g:mix_format_elixir_bin_path = '~/.asdf/installs/elixir/1.11.3/bin'

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
