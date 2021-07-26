
" Bootstrap vim-plug if necessary
if !filereadable(stdpath('data') . '/site/autoload/plug.vim')
  silent execute '!curl -fLo ' . stdpath('data') . '/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Set the mapleader before any mappings that reference it are created.
let mapleader = ','

call plug#begin(stdpath('data') . '/site/plugged')

Plug 'neovim/nvim-lspconfig'                " common config for builtin lsp client
Plug 'kabouzeid/nvim-lspinstall'            " conveniently install language servers
Plug 'hrsh7th/nvim-compe'                   " auto completion plugin for neovim

Plug 'nvim-lua/popup.nvim'                  " telescope dependency
Plug 'nvim-lua/plenary.nvim'                " telescope dependency
Plug 'nvim-telescope/telescope.nvim'        " fuzzy-finder on steroids

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " AST based syntax highlighting
Plug 'nvim-treesitter/playground'           " view treesitter info

Plug 'bling/vim-airline'                    " improved status bar
Plug 'fatih/molokai'                        " color scheme
Plug 'w0ng/vim-hybrid'                      " color scheme
Plug 'bluz71/vim-nightfly-guicolors'        " color scheme that supports treesitter
Plug 'vim-airline/vim-airline-themes'       " color schemes for vim-airline

Plug 'tpope/vim-commentary'                 " extended commenting of blocks and objects
Plug 'tpope/vim-fugitive'                   " git integration
Plug 'tpope/vim-repeat'                     " extend '.' to plugin map
Plug 'tpope/vim-surround'                   " change surrounding quotes and tags

Plug 'andymass/vim-matchup'                 " extended matching
Plug 'fatih/vim-hclfmt'                     " hashicorp configuration language
Plug 'fatih/vim-nginx', {'for': 'nginx'}    " nginx config
Plug 'hashivim/vim-hashicorp-tools'
Plug 'majutsushi/tagbar'                    " code tree
Plug 'mhinz/vim-signify'                    " line markers for changes
Plug 'plasticboy/vim-markdown'              " extended markdown
Plug 'rust-lang/rust.vim', {'for': 'rust'}  " rust language stuff
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}

call plug#end()

lua require("sykesm")

"=====================================================
"===================== SETTINGS ======================
set autoindent                         " always turn on auto indent
set autoread                           " automatically re-read changed files
set backspace=indent,eol,start         " allow backspacing over everything in insert mode
set backup                             " keep a backup file (restore to previous version)
set cursorline                         " highlight the current line
set clipboard^=unnamed                 " yank to and paste from the system clipboard by default
set clipboard^=unnamedplus             " yank to and paste from the system clipboard by default
set complete-=i                        " don't search included files for completion
set completeopt=menuone,noselect       " use popup menu for one or more matches, force selection
set display+=lastline                  " display as much as possible of the last line
set expandtab                          " use spaces instead of tabs in insert mode
set foldmethod=indent                  " syntax highlighting items specify folds
set foldlevel=20                       " folds with a higher level than this will be closed
set formatoptions+=r                   " insert the comment leader after enter in insert mode
set guioptions+=c                      " use console dialogs instead of popups
set guioptions-=L                      " remove left scrollbar
set guioptions-=r                      " remove right scrollbar
set history=1000                       " keep 1000 lines of command line history
set hlsearch                           " highlight the found search string
set ignorecase                         " ignore case when matching search string
set incsearch                          " incremental search
set laststatus=2                       " always show a status line
set lazyredraw                         " skip redraw when running macros
set maxmempattern=20000                " max memory for highlighting large files
set modeline                           " support modelines in files
set modelines=5                        " number of lines checked for set commands
set mouse=a                            " enable mouse in all modes
set number                             " turn on line numbers
set numberwidth=5                      " minimum number columns to use for line number
set noswapfile                         " disable swap files
set pumheight=10                       " max size of completion popup
set ruler                              " show the cursor position all the time
set shiftround                         " round indent to a multiple of shiftwidth
set shiftwidth=4                       " number of spaces to use for each step of autoindent
set scrolloff=2                        " minimum screen lines to keep above/below cursor
set shortmess+=c                       " turn off completion messages
set showcmd                            " display incomplete commands
set showmatch                          " when bracket is inserted, briefly jump to matching bracket
set smartcase                          " override ignorecase if search contains an upper case char
set smartindent                        " smart indenting when starting a new line
set smarttab                           " insrt blanks on <tab> according to shiftwidth
set softtabstop=2                      " spaces that a <tab> counts for while editing
set tabstop=4                          " treat a tab as 4 spaces
set undofile                           " keep an undo file (undo changes after closing)
set updatetime=300                     " write to swap after 300ms
set wildmenu                           " enhanced mode of command line completion
set wildmode=list:longest              " tab complete file names and list conflicts for select
if &encoding =~? 'utf-8'
  set showbreak=↪
endif

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

" enable 24 bit colors
if ($COLORTERM =~ 'truecolor')
  set termguicolors
endif

" silent! colorscheme molokai
" silent! colorscheme hybrid

" nightfly is a 24-bit color scheme with LSP support
silent! colorscheme nightfly
let g:nightflyUndercurls = 1

" Setup default highlighting for references.
" Go only responds with LspReferenceText.
highlight default link LspReferenceText  CursorLine
highlight default link LspReferenceWrite CursorLine
highlight default link LspReferenceRead  Cursorline

" Use curly underline for spelling
highlight SpellBad term=underline cterm=undercurl gui=undercurl guifg=NONE guibg=NONE guisp=Red

"=====================================================
"================ Powerline Fonts ====================
if !empty($POWERLINE)
  let g:airline_powerline_fonts = 1
endif
let g:airline#extensions#tabline#enabled = 1

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
if has('mac') || has('macunix') || (has('unix') && system('uname') =~ 'Darwin')
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
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" briefly flash what's beeen yanked
augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua require('vim.highlight').on_yank({timeout = 100})
augroup end

" https://stackoverflow.com/questions/4097259/in-vim-how-do-i-highlight-todo-and-fixme
augroup vimrc_todo
  autocmd!
  autocmd Syntax * syn match MyTodo /\v<(FIXME|NOTE|TODO|OPTIMIZE|XXX|MJS)/ containedin=.*Comment,vimCommentTitle
augroup END
" This does not seem to play well with TreeSitter and highlights the matches
" everywhere: identifiers, strings, and comments.
" hi def link MyTodo Todo

"=====================================================
"===================== Airline =======================
if !empty($POWERLINE)
  let g:airline_powerline_fonts = 1
endif
let g:airline#extensions#tabline#enabled = 1

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

"=====================================================
"====== https://github.com/hrsh7th/nvim-compe ========
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

if !empty($TMUX)
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
endif
