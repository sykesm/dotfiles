-- options.lua

-- set mapleader before any mappings that reference it are created.
vim.g.mapleader = ','

-- core vim options
vim.opt.autoindent = true                         -- always turn on auto indent
vim.opt.autoread = true                           -- automatically re-read changed files
vim.opt.background = 'dark'                       -- tell syntax we're using a dark background
vim.opt.backspace = 'indent,eol,start'            -- allow backspacing over everything in insert mode
vim.opt.backup = true                             -- keep a backup file (restore to previous version)
vim.opt.cursorline = true                         -- highlight the current line
vim.opt.clipboard:prepend('unnamed')              -- yank to and paste from the system clipboard by default
vim.opt.clipboard:prepend('unnamedplus')          -- yank to and paste from the system clipboard by default
vim.opt.cmdheight = 1                             -- height of cmd line area (0 is experimental and disables)
vim.opt.complete:remove('i')                      -- don't search included files for completion
vim.opt.completeopt = 'menuone,noinsert,noselect' -- use popup menu for one or more matches, no selection
vim.opt.display:append('lastline')                -- display as much as possible of the last line
vim.opt.expandtab = true                          -- use spaces instead of tabs in insert mode
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- treesitter determines fold level
vim.opt.foldlevel = 20                            -- folds with a higher level than this will be closed
vim.opt.foldmethod = 'expr'                       -- foldexpr determines fold level
vim.opt.formatoptions:append('r')                 -- insert the comment leader after enter in insert mode
vim.opt.history = 1000                            -- keep 1000 lines of command line history
vim.opt.hlsearch = true                           -- highlight the found search string
vim.opt.ignorecase = true                         -- ignore case when matching search string
vim.opt.incsearch = true                          -- incremental search
vim.opt.laststatus = 2                            -- always show a status line
vim.opt.lazyredraw = true                         -- skip redraw when running macros
vim.opt.maxmempattern = 20000                     -- max memory for highlighting large files
vim.opt.modeline = true                           -- support modelines in files
vim.opt.modelines = 5                             -- number of lines checked for set commands
vim.opt.mouse = 'a'                               -- enable mouse in all modes
vim.opt.number = true                             -- turn on line numbers
vim.opt.numberwidth = 5                           -- minimum number columns to use for line number
vim.opt.swapfile = false                          -- disable swap files
vim.opt.pumheight = 10                            -- max size of completion popup
vim.opt.ruler = true                              -- show the cursor position all the time
vim.opt.shiftround = true                         -- round indent to a multiple of shiftwidth
vim.opt.shiftwidth = 4                            -- number of spaces to use for each step of autoindent
vim.opt.scrolloff = 2                             -- minimum screen lines to keep above/below cursor
vim.opt.shortmess:append('c')                     -- turn off completion messages
vim.opt.showbreak = '↪'                           -- show at start of wrapped lines
vim.opt.showcmd = true                            -- display incomplete commands
vim.opt.showmatch = true                          -- when bracket is inserted, briefly jump to matching bracket
vim.opt.smartcase = true                          -- override ignorecase if search contains an upper case char
vim.opt.smartindent = true                        -- smart indenting when starting a new line
vim.opt.smarttab = true                           -- insrt blanks on <tab> according to shiftwidth
vim.opt.softtabstop = 2                           -- spaces that a <tab> counts for while editing
vim.opt.spelllang = 'en_us'                       -- default to US English
vim.opt.spelloptions = 'camel,noplainbuffer'      -- on syntax highlighting enabled, check camel case as separate words
if string.find(vim.env.COLORTERM or '', 'truecolor') then
  vim.opt.termguicolors = true                    -- enable 24 bit colors
end
vim.opt.tabstop = 4                               -- treat a tab as 4 spaces
vim.opt.timeout = true                            -- wait timeoutlen for a key in a mapping
vim.opt.ttimeout = true                           -- wait tor a TUI keycode character
vim.opt.ttimeoutlen = 25                          -- wait up to 25ms for a TUI keycode
vim.opt.undofile = true                           -- keep an undo file (undo changes after closing)
vim.opt.updatetime = 300                          -- write to swap after 300ms
vim.opt.wildmenu = true                           -- enhanced mode of command line completion
vim.opt.wildmode = 'list:longest'                 -- tab complete file names and list conflicts for select

-- keep backups and swaps in one place
vim.opt.backupdir = vim.fn.stdpath('data')..'/backups//'
vim.opt.directory = vim.fn.stdpath('data')..'/swaps//'
vim.opt.undodir   = vim.fn.stdpath('data')..'/undo'
for _, path in ipairs({ 'backupdir', 'directory', 'undodir' }) do
  for _, dir in ipairs(vim.opt[path]:get()) do
    vim.fn.mkdir(dir, 'p')
  end
end
