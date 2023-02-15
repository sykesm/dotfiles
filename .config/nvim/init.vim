" Bootstrap vim-plug if necessary
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
 endif

" Set mapleader before any mappings that reference it are created.
let g:mapleader = ','
let g:nightflyTransparent = 1
let g:nightflyUndercurls = 1

call plug#begin(stdpath('data') . '/site/plugged')

Plug 'williamboman/mason.nvim'              " Installer for LSPs (and more)
Plug 'williamboman/mason-lspconfig.nvim'    " mason extensions for LSPs
Plug 'neovim/nvim-lspconfig'                " common config for builtin lsp client

Plug 'hrsh7th/cmp-buffer'                   " comletion from buffers
Plug 'hrsh7th/cmp-nvim-lsp'                 " LSP completion
Plug 'hrsh7th/cmp-path'                     " completion from paths
Plug 'hrsh7th/cmp-vsnip'                    " completion from snippets
Plug 'hrsh7th/vim-vsnip'                    " snippets engine required by nvim-cmp
Plug 'hrsh7th/nvim-cmp'                     " auto completion plugin for neovim
Plug 'ray-x/lsp_signature.nvim'             " provide function signature help

Plug 'nvim-lua/popup.nvim'                  " telescope dependency
Plug 'nvim-lua/plenary.nvim'                " telescope dependency
Plug 'nvim-telescope/telescope.nvim'        " fuzzy-finder on steroids

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " AST based syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter-textobjects' " text objects
Plug 'nvim-treesitter/playground'           " view treesitter info
Plug 'p00f/nvim-ts-rainbow'                 " rainbow parens

Plug 'bling/vim-airline'                    " improved status bar
Plug 'fatih/molokai'                        " color scheme
Plug 'w0ng/vim-hybrid'                      " color scheme
Plug 'bluz71/vim-nightfly-guicolors'        " color scheme that supports treesitter
Plug 'vim-airline/vim-airline-themes'       " color schemes for vim-airline

Plug 'tpope/vim-commentary'                 " extended commenting of blocks and objects
Plug 'tpope/vim-fugitive'                   " git integration
Plug 'tpope/vim-repeat'                     " extend '.' to plugin map
Plug 'tpope/vim-surround'                   " change surrounding quotes and tags

Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'

Plug 'andymass/vim-matchup'                 " extended matching
Plug 'fatih/vim-nginx', {'for': 'nginx'}    " nginx config
Plug 'hashivim/vim-hashicorp-tools'
Plug 'majutsushi/tagbar'                    " code tree
Plug 'lewis6991/gitsigns.nvim'              " line markers for git changes
Plug 'plasticboy/vim-markdown'              " extended markdown
" ray-x/go.nvim commit 470349c does something weird with defer_fn that clears the
" screen during startup. It got reverted in cfa1089 and then restored in 1b3d21a.
Plug 'ray-x/go.nvim', {'commit': 'cfa1089'} " go language stuff w/o vim-go
Plug 'ray-x/guihua.lua'                     " float term, go.nvim gui support
Plug 'rust-lang/rust.vim', {'for': 'rust'}  " rust language stuff
Plug 'folke/neodev.nvim'                    " LSP configuration for nvim lua
Plug 'elixir-editors/vim-elixir', {'for': 'elixir'}

Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}

call plug#end()

lua require("options")
lua require("sykesm")

" Keep vim gemerated artifacts in ~/.vim
let &backupdir=stdpath('data').'/backups//'
let &directory=stdpath('data').'/swaps//'
let &undodir=stdpath('data').'/undo'
if !isdirectory(&backupdir) | call mkdir(&backupdir, 'p') | endif
if !isdirectory(&directory) | call mkdir(&directory, 'p') | endif
if !isdirectory(&undodir)   | call mkdir(&undodir, 'p') | endif

"=====================================================
"=====================  Colors  ======================
" Tell syntax we're using a dark background
set background=dark

" silent! colorscheme molokai
" silent! colorscheme hybrid

" nightfly is a 24-bit color scheme with LSP support
silent! colorscheme nightfly

" Use curly underline for spelling
highlight SpellBad term=underline cterm=undercurl gui=undercurl guifg=NONE guibg=NONE guisp=Red

"=====================================================
"===================== MAPPINGS ======================
" space clears search string highlighting
nnoremap <silent> <space> :nohl<cr><space>

" make Y consistent with C and D
nnoremap Y y$

" <Control>-{hjkl} to change active window
nnoremap <silent> <C-l> <c-w>l
nnoremap <silent> <C-h> <c-w>h
nnoremap <silent> <C-k> <c-w>k
nnoremap <silent> <C-j> <c-w>j

" Close all but the current one
nnoremap <leader>o :only<CR>

" macOS dictionary
if has('macunix') || (has('unix') && system('uname') =~ 'Darwin')
  nmap <silent> <Leader>d :!open dict://<cword><CR><CR>
endif

" Terminal settings
if has('terminal')
  " Kill job and close terminal window
  tnoremap <Leader>q <C-w><C-C><C-w>c<cr>

  " switch to normal mode with esc
  tnoremap <Esc> <C-W>N

  " mappings to move out from terminal to other views
  tnoremap <C-h> <C-w>h
  tnoremap <C-j> <C-w>j
  tnoremap <C-k> <C-w>k
  tnoremap <C-l> <C-w>l

  " Open terminal in vertical, horizontal and new tab
  nnoremap <leader>tv :vsplit<cr>:term ++curwin<CR>
  nnoremap <leader>ts :split<cr>:term ++curwin<CR>
  nnoremap <leader>tt :tabnew<cr>:term ++curwin<CR>

  tnoremap <leader>tv <C-w>:vsplit<cr>:term ++curwin<CR>
  tnoremap <leader>ts <C-w>:split<cr>:term ++curwin<CR>
  tnoremap <leader>tt <C-w>:tabnew<cr>:term ++curwin<CR>
endif

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
if !has('gui_running')
  set notimeout
  set ttimeout
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

" save on focus loss in tmux and gui
augroup SaveFocusLost
  autocmd!
  autocmd FocusLost * silent! wa
augroup END

" Return to last edit position when opening files
augroup restore_position
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
  autocmd FileType gitcommit autocmd! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
augroup END

" briefly flash what's beeen yanked
if has('nvim')
  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require('vim.highlight').on_yank({timeout = 100})
  augroup end
endif

"=====================================================
"===================== Airline =======================
if !empty($POWERLINE)
  let g:airline_powerline_fonts = 1
endif
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 0

"====================================================
"==================== matchup =======================
let g:matchup_matchparen_enabled = 1 " override with :DoMatchParen,:NoMatchParen
let g:matchup_matchparen_offscreen = {}

"====================================================
" =================== NERDTree ======================
noremap <Leader>n :NERDTreeToggle<cr>
noremap <F9> :NERDTreeFind<CR>

let NERDTreeShowBookmarks=1
let NERDTreeShowHidden=1

"====================================================
"==================== markdown ======================
let g:vim_markdown_conceal = 0
let g:vim_markdown_fenced_languages = ['go=go', 'viml=vim', 'bash=sh']
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_extensions_in_markdown = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_toml_frontmatter = 1

"====================================================
"====================== tagbar ======================
nmap <F8> :TagbarToggle<CR>

"====================================================
"==================== Terraform =====================
let g:terraform_align=1
let g:terraform_fmt_on_save=1

"====================================================
"===================== ToHTML =======================
let html_use_css=1
let use_xhtml=1

"====================================================
" Shrug ¯\_(ツ)_/¯
inoremap <leader>S ¯\_(ツ)_/¯

"=====================================================
" TMUX clipboard configuration
"
" Try to use tmux buffers instead GUI for clipboard
" integration when running in tmux. If the tmux version
" is new enough, send copied text to the terminal client
" with OSC 52.
if !empty($TMUX) && executable('tmux') && system('tmux -V') =~ '3\.[2-9]'
  let g:clipboard = {
    \   'name': 'myClipboard',
    \   'copy': {
    \      '+': ['tmux', 'load-buffer', '-w', '-'],
    \      '*': ['tmux', 'load-buffer', '-w', '-'],
    \    },
    \   'paste': {
    \      '+': ['tmux', 'save-buffer', '-'],
    \      '*': ['tmux', 'save-buffer', '-'],
    \   },
    \   'cache_enabled': 1,
    \ }
elseif !empty($TMUX) && executable('tmux')
  let g:clipboard = {
    \   'name': 'myClipboard',
    \   'copy': {
    \      '+': ['tmux', 'load-buffer', '-'],
    \      '*': ['tmux', 'load-buffer', '-'],
    \    },
    \   'paste': {
    \      '+': ['tmux', 'save-buffer', '-'],
    \      '*': ['tmux', 'save-buffer', '-'],
    \   },
    \   'cache_enabled': 1,
    \ }
endif
