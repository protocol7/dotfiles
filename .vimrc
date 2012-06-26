" Customize leader
let mapleader = ','

" Load pathogen
call pathogen#infect()

" Basic config
set nocompatible      " Use vim, no vi defaults

if exists("&relativenumber")
  set relativenumber    " User nifty relative line numbers
else
  set number            " Show line numbers
endif

set ruler             " Show line and column number
syntax enable         " Turn on syntax highlighting allowing local overrides
set encoding=utf-8    " Set default encoding to UTF-8
set autoread          " reload files (no local changes only)
set ttyfast           " Optimize for fast terminal connections
set cursorline        " Highlight current line

set showcmd           " show partial command as you type them

set vb t_vb=          " disable any beeping

" Don’t reset cursor to start of line when moving around.
set nostartofline

" We live in the future
set mouse=a

if exists("&colorcolumn")
  " Show column 80
  set colorcolumn=80
endif

set scrolloff=3               " keep at least n lines above/below

" make split and vsplit open window in sane ways
set splitright
set splitbelow

" Spelling
if v:version >= 700
  " Enable spell check for text files
  autocmd BufNewFile,BufRead *.txt setlocal spell spelllang=en
endif

set showmatch                   " show matching brackets
set formatoptions=tcrql         " t - autowrap to textwidth
                                " c - autowrap comments to textwidth
                                " r - autoinsert comment leader with <Enter>
                                " q - allow formatting of comments with :gq
                                " l - don't format already long lines

" Color scheme
color molokai

" Make the color column more subtle
highlight ColorColumn guibg='Gray 10'

" Don't dim comments
highlight Comment guifg=Gold3

" Whitespace
set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set backspace=indent,eol,start    " backspace through everything in insert mode

if exists("g:enable_mvim_shift_arrow")
  let macvim_hig_shift_movement = 1 " mvim shift-arrow-keys
endif

set list                          " Show invisible characters
" List chars
set listchars=""                  " Reset the listchars
set listchars=tab:\▸\             " a tab should display as "▸", trailing whitespace as "."
set listchars+=trail:.            " show trailing spaces as dots
set listchars+=extends:>          " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen
set listchars+=precedes:<         " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen

" Searching
set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter

" Keep search matches in the middle of the window:
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap n nzzzv
nnoremap N Nzzzv

" Wildmenu
set wildmenu          " Enhance command-line completion

" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.class,.svn,*.gem

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Disable temp and backup files
set wildignore+=*.swp,*~,._*

" Backup and swap files
function! InitBackupDir()
  let parent = $HOME .'/.vim/'
  let backup = parent . 'backup/'
  let tmp = parent . 'tmp/'
  if exists("*mkdir")
    if !isdirectory(parent)
      call mkdir(parent)
    endif
    if !isdirectory(backup)
      call mkdir(backup)
    endif
    if !isdirectory(tmp)
      call mkdir(tmp)
    endif
  endif
  let missing_dir = 0
  if isdirectory(tmp)
    execute 'set backupdir=' . escape(backup, " ") . "/,."
  else
    let missing_dir = 1
  endif
  if isdirectory(backup)
    execute 'set directory=' . escape(tmp, " ") . "/,."
  else
    let missing_dir = 1
  endif
  if missing_dir
    echo "Warning: Unable to create backup directories: " . backup ." and " . tmp
    echo "Try: mkdir -p " . backup
    echo "and: mkdir -p " . tmp
    set backupdir=.
    set directory=.
  endif
endfunction
call InitBackupDir()

" Powerline options
set guifont=Inconsolata\ for\ Powerline:h14
let g:Powerline_symbols = 'fancy'

" Disable toolbar
if has("gui_running")
  set guioptions-=T
endif

" enable sane text selection
if has("gui_macvim")
  let macvim_hig_shift_movement = 1
endif

" Enable sane file selection
set wildmode=list:longest

" Include a large command history
set history=1000

" Don't show swap alert, default value is filnxtToO
set shortmess=filnxtToOA

" Going hard core
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

filetype on
filetype plugin indent on " Turn on filetype plugins (:help filetype-plugin)

if has("autocmd")
  " In Makefiles, use real tabs, not tabs expanded to spaces
  au FileType make set noexpandtab

  " Treat JSON files like JavaScript
  au BufNewFile,BufRead *.json set ft=javascript

  " Make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
  au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif

if has("gui_running")
  if has("autocmd")
    " Automatically resize splits when resizing MacVim window
    autocmd VimResized * wincmd =
  endif
endif

" Statusline
if has("statusline") && !&cp
  set laststatus=2  " always show the status bar

  " Without setting this, ZoomWin restores windows in a way that causes
  " equalalways behavior to be triggered the next time CommandT is used.
  " This is likely a bludgeon to solve some other issue, but it works
  set noequalalways

  " Start the status line
  set statusline=%f\ %m\ %r

  " Add fugitive if enabled
  set statusline+=%{fugitive#statusline()}

  " Add syntastic if enabled
  "set statusline+=%#warningmsg#
  "set statusline+=%{SyntasticStatuslineFlag()}
  "set statusline+=%*

  " Finish the statusline
  set statusline+=Line:%l/%L[%p%%]
  set statusline+=Col:%v
  set statusline+=Buf:#%n
  set statusline+=[%b][0x%B]
endif

if has("gui_macvim")
  " Command-Shift-F on OSX
  map <D-F> :Ack<space>
  map <D-t> :CtrlP<CR>
  imap <D-F> <ESC>:CtrlP<CR>
else
  " Control-Shift-F on other systems
  map <C-F> :Ack<space>
  map <C-t> :CtrlP<CR>
  imap <C-F> <ESC>:CtrlP<CR>
endif

" Configure indent guides (toggle with ,ig)
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1

map <leader>zw :ZoomWin<CR>

map <Leader>rt :TagbarToggle<CR>

" Fugitive mappings
nmap <leader>gb :Gblame<CR>
nmap <leader>gs :Gstatus<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>gl :Glog<CR>
nmap <leader>gc :Gcommit<CR>
nmap <leader>gp :Git push<CR>
nmap <Leader>gD :diffoff!<cr><c-w>h:bd<cr>

" Move lines up and down
nmap <Leader><Down> ddp
nmap <Leader><Up> ddkkp

" Open pydoc window to the right
let g:pydoc_open_cmd = 'botright 60vsplit'

" Always copy to the system clipboard
set clipboard=unnamed

if has("gui_macvim")
  function! OnlineDoc()
    let s:wordUnderCursor = expand("<cword>")
    let s:cmd = "silent !open dash://" . s:wordUnderCursor
    execute s:cmd
  endfunction
  " Online doc search.
  map <silent> <Leader>d :call OnlineDoc()<CR>
endif
