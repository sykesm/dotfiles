set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'AndrewRadev/splitjoin.vim'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'cespare/vim-toml', {'for': 'toml'}
Plug 'corylanou/vim-present', {'for': 'present'}
Plug 'ekalinin/Dockerfile.vim', {'for': 'Dockerfile'}
Plug 'elzr/vim-json', {'for': 'json'}
Plug 'fatih/vim-go', {'tag': '*', 'for': ['go', 'gomod', 'gotexttmpl', 'gohtmltmpl']}
Plug 'fatih/vim-hclfmt'
Plug 'fatih/vim-nginx', {'for': 'nginx'}
Plug 'godlygeek/tabular'
Plug 'hashivim/vim-hashicorp-tools'
Plug 'mileszs/ack.vim'
Plug 'plasticboy/vim-markdown'
Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'racer-rust/vim-racer', {'for': 'rust'}
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}
Plug 'sykesm/vim-osc52'
Plug 't9md/vim-choosewin'
if !has('gui_running')
  Plug 'roxma/vim-tmux-clipboard'
endif
Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

Plug 'ervandew/supertab'

Plug 'bling/vim-airline'                    " improved status bar
Plug 'vim-airline/vim-airline-themes'       " color schemes for vim-airline
Plug 'vim-scripts/matchit.zip'              " extending matching
Plug 'majutsushi/tagbar'                    " code tree
Plug 'mhinz/vim-signify'                    " line markers
Plug 'scrooloose/syntastic'                 " syntax checking
Plug 'altercation/vim-colors-solarized'     " color scheme
Plug 'fatih/molokai'                        " color scheme
Plug 'w0ng/vim-hybrid'                      " color scheme

Plug 'kien/ctrlp.vim'                       " fuzzy file open
call plug#end()

"=====================================================
"===================== SETTINGS ======================

" Keep vim gemerated artifacts in ~/.vim
if exists('*mkdir')
  if !isdirectory($HOME . '/.vim/backups')
    call mkdir($HOME . '/.vim/backups', 'p')
  endif
  if !isdirectory($HOME . '/.vim/swaps')
    call mkdir($HOME . '/.vim/swaps', 'p')
  endif
  if !isdirectory($HOME . '/.vim/undo')
    call mkdir($HOME . '/.vim/undo', 'p')
  endif
endif
set backupdir=$HOME/.vim/backups,$TMPDIR,/tmp
set directory=$HOME/.vim/swaps,$TMPDIR,/tmp
set undodir=$HOME/.vim/undo,$TMPDIR,/tmp

set autoindent                         " always turn on auto indent
set autoread                           " automatically re-read changed files
set backspace=indent,eol,start         " allow backspacing over everything in insert mode
set backup                             " keep a backup file (restore to previous version)
set cursorline                         " highlight the current line
set clipboard^=unnamed                 " yank to and paste from the system clipboard by default
set clipboard^=unnamedplus             " yank to and paste from the system clipboard by default
set complete-=i                        " don't search included files for completion
set completeopt=menu,menuone           " use popup menu for one or more matches
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
set number                             " turn on line numbers
set numberwidth=5                      " minimum number columns to use for line number
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
if has('multi_byte') && &encoding =~? 'utf-8'
  set showbreak=↪
endif

"=====================================================
"=====================  Colors  ======================
" Force 256 colors and fast tty for gui and mac terminal
if has('gui_running') || (&term =~ 'xterm')
  set t_Co=256
  set t_Sb=[4%dm
  set t_Sf=[3%dm
  set ttyfast
endif

" Switch syntax highlighting on when the terminal has colors.
if &t_Co > 2 || has('gui_running')
  syntax on
endif

" enable 24 bit colors in iTerm
if has('termguicolors') && ($LC_TERMINAL =~ 'iTerm' || !empty($WT_SESSION))
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

if !has('nvim')
  set ttymouse=xterm2
  set ttyscroll=3
endif

" Tell syntax we're using a dark background
highlight Normal guibg=black guifg=white
set background=dark

" Alter colorscheme based on available terminal colors
if &t_Co >= 256
  " let g:molokai_original = 1
  " let g:rehash256 = 1
  " silent! colorscheme molokai
  silent! colorscheme hybrid
else
  colorscheme default
  highlight LineNr ctermfg=DarkGrey
  highlight CursorLineNr cterm=bold ctermfg=Yellow
  highlight CursorLine cterm=none
endif

" Configuration for all graphical front ends
if has('gui_running')
  " Use curly underline for spelling
  highlight SpellBad term=underline gui=undercurl guifg=NONE guibg=NONE guisp=Red
  set vb t_vb= " no visual bell & flash
  set mouse=a
  behave xterm
end

"=====================================================
"============== FILETYPE DETECTION ===================
filetype plugin indent on

augroup filetypedetect
  autocmd BufNewFile,BufRead *.hcl    setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.html   setlocal expandtab ts=2 sw=2
  autocmd BufNewFile,BufRead *.ino    setlocal noet ts=4 sw=4 sts=4
  autocmd BufNewFile,BufRead *.proto  setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.txt    setlocal noet ts=4 sw=4

  autocmd BufNewFile,BufRead .envrc   setfiletype sh
  autocmd BufNewFile,BufRead *.gotmpl setfiletype gotexttmpl
  autocmd BufNewFile,BufRead *.hcl    setfiletype conf
  autocmd BufNewFile,BufRead .nginx.conf*,nginx.conf* setfiletype nginx
  autocmd BufNewFile,BufRead .tmux.conf*,tmux.conf* setfiletype tmux

  autocmd FileType json     setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType markdown setlocal expandtab shiftwidth=4 tabstop=4 spell textwidth=78
  autocmd FileType proto    setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType python   setlocal expandtab shiftwidth=4 tabstop=4
  autocmd FileType ruby     setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType sh       setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType text     setlocal noet      shiftwidth=4 tabstop=4 softtabstop=4 spell textwidth=78
  autocmd FileType vim      setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType xml      setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
  autocmd FileType yaml     setlocal expandtab shiftwidth=2 tabstop=2

  autocmd FileType gitcommit setlocal spell
  autocmd FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
augroup END

"=====================================================
"===================== MAPPINGS ======================
let mapleader = ','

" space clears search string highlighting
nnoremap <silent> <space> :nohl<cr><space>

" make Y consistent with C and D
nnoremap Y y$

" <Control>-{hjkl} to change active window
nnoremap <silent> <C-l> <c-w>l
nnoremap <silent> <C-h> <c-w>h
nnoremap <silent> <C-k> <c-w>k
nnoremap <silent> <C-j> <c-w>j

" put quickfix window always to the bottom
augroup quickfix
  autocmd!
  autocmd FileType qf wincmd J
  autocmd FileType qf setlocal wrap
augroup END

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

"=====================================================
"===================== PLUGINS ======================

" ================== vim-ariline ====================
" Setup a good font for macvim
if has('gui_macvim')
  set antialias
  set guifont=Inconsolata-dz\ for\ Powerline:h12
  let g:airline_powerline_fonts = 1
elseif !empty($POWERLINE)
  let g:airline_powerline_fonts = 1
endif
let g:airline#extensions#tabline#enabled = 1

" ====================== ctrl-p ======================
let g:ctrlp_working_path_mode = '0'
let g:ctrlp_show_hidden = 1
nnoremap <leader>e :CtrlPBuffer<cr>

" ======================= niji =======================
let g:niji_matching_filetypes = ['lisp', 'ruby', 'python', 'go', 'java']

" ==================== NERDTree ====================
" For toggling
noremap <Leader>n :NERDTreeToggle<cr>
noremap <Leader>f :NERDTreeFind<cr>
nmap <F9> :NERDTreeFind<CR>

let NERDTreeShowBookmarks=1
let NERDTreeShowHidden=1

" ==================== Fugitive ====================
vnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gb :Gblame<CR>

" =================== syntastic ====================
let g:syntastic_go_checkers=['go', 'govet', 'errcheck']
let g:syntastic_sh_shellcheck_args='-x -e SC1090 -e SC1091'

" ===================== tagbar  ====================
nmap <F8> :TagbarToggle<CR>

" ===================== ToHTML  ====================
let html_use_css=1
let use_xhtml=1

" =====================  netrw  ====================
let g:netrw_ftpmode='ascii'

" ==================== vim-json ====================
let g:vim_json_syntax_conceal=0        " Disable double quote hiding

" =================== Terraform ====================
let g:terraform_align=1

" ==================== supertab ====================
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextTextOmniPrecedence = ['&completefunc', '&omnifunc']
let g:SuperTabContextDefaultCompletionType = '<c-p>'
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextDiscoverDiscovery = ['&omnifunc:<c-x><c-o>']

" save on focus loss in gui
autocmd FocusLost * silent! wa

" Return to last edit position when opening files
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

" ==================== vim-go ====================
" disables the 197 return code on focus
let $GINKGO_EDITOR_INTEGRATION = 'true'

let g:go_bin_path = expand('~/.gotools')
if has('unix')
  let $PATH = g:go_bin_path . ':' . $PATH
else
  let $PATH = g:go_bin_path . ';' . $PATH
endif

let g:go_autodetect_gopath = 0
let g:go_auto_sameids = 0
let g:go_auto_type_info = 0
let g:go_diagnostics_enabled = 1
let g:go_doc_popup_window = 0
let g:go_echo_command_info = 1
let g:go_fmt_command = 'goimports'
let g:go_fmt_options = '-local github.ibm.com'
let g:go_fmt_fail_silently = 1
let g:go_gocode_propose_source = 1
let g:go_gopls_complete_unimported = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_functions = 0
let g:go_highlight_generate_tags = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_string_spellcheck = 0
let g:go_highlight_structs = 0
let g:go_implements_mode='gopls'
let g:go_info_mode = 'gopls'
let g:go_list_type = 'quickfix'
let g:go_rename_command='gopls'
let g:go_test_prepend_name = 1
let g:go_test_timeout = '30s'
let g:go_debug_windows = {
      \ 'vars':  'leftabove 35vnew',
      \ 'stack': 'botright 10new',
\ }

augroup golang
  autocmd!
  autocmd FileType go compiler go
  autocmd FileType go setlocal noexpandtab shiftwidth=2 tabstop=2 softtabstop=2
  autocmd Filetype go set makeprg=go\ build\ ./...
  autocmd Filetype go nnoremap <buffer> <leader>i :exe 'GoImport ' . expand('<cword>')<CR>
  autocmd Filetype go nnoremap <buffer>gd :GoDef<CR>
  autocmd Filetype go nnoremap <leader>r :GoRun %<CR>
  autocmd Filetype go nnoremap <leader>gd :GoDescribe<CR>
  autocmd Filetype go nnoremap <leader>gs :sp <CR>:exe 'GoDef'<CR>
  autocmd Filetype go nnoremap <leader>gt :tab split <CR>:exe 'GoDef'<CR>
  autocmd Filetype go nnoremap <leader>gv :vsp <CR>:exe 'GoDef' <CR>
augroup END

" ====================== rust ======================
let g:racer_experimental_completer = 1
let g:rust_cargo_check_tests = 1
let g:rustfmt_autosave = 1
let g:rustfmt_autosave_if_config_present = 1
let g:rustfmt_fail_silently = 0

augroup Racer
  autocmd!
  autocmd FileType rust nmap <buffer> gd         <Plug>(rust-def)
  autocmd FileType rust nmap <buffer> gs         <Plug>(rust-def-split)
  autocmd FileType rust nmap <buffer> gx         <Plug>(rust-def-vertical)
  autocmd FileType rust nmap <buffer> gt         <Plug>(rust-def-tab)
  autocmd FileType rust nmap <buffer> K          <Plug>(rust-doc)
  autocmd FileType rust nmap <buffer> <leader>gd <Plug>(rust-doc)
  autocmd FileType rust nmap <buffer> <leader>gD <Plug>(rust-doc-tab)
augroup END

" ======================= ag =======================
let g:ackprg = 'ag --vimgrep --smart-case'

" ==================== markdown ====================
let g:vim_markdown_conceal = 0
let g:vim_markdown_fenced_languages = ['go=go', 'viml=vim', 'bash=sh']
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_extensions_in_markdown = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_toml_frontmatter = 1

" ==================== Various other plugin settings ====================
nmap - <Plug>(choosewin)

" https://stackoverflow.com/questions/4097259/in-vim-how-do-i-highlight-todo-and-fixme
augroup vimrc_todo
    autocmd!
    autocmd Syntax * syn match MyTodo /\v<(FIXME|NOTE|TODO|OPTIMIZE|XXX|MJS)/ containedin=.*Comment,vimCommentTitle
augroup END
hi def link MyTodo Todo

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(':DiffOrig')
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
endif

if !has('gui_running') && !empty($SSH_CLIENT) && empty($TMUX)
  nnoremap <silent> yy :<C-U>call YankToTerminalClipboard('yy')<CR>
  nnoremap <silent> y :set operatorfunc=YankToTerminalClipboard<CR>g@
  vnoremap <silent> y :<C-U>call YankToTerminalClipboard(visualmode(), 1)<CR>
endif

" vim: sw=2 sw=2 et
