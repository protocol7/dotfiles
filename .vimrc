" load pathogen
call pathogen#infect()

" basic config
set nocompatible      " Use vim, no vi defaults
set number            " Show line numbers
set ruler             " Show line and column number
syntax enable         " Turn on syntax highlighting allowing local overrides
set encoding=utf-8    " Set default encoding to UTF-8

" Enhance command-line completion
set wildmenu

" Optimize for fast terminal connections
set ttyfast

" Highlight current line
set cursorline

" Don’t reset cursor to start of line when moving around.
set nostartofline

if exists("colorcolumn")
" We live in the future
set mouse=a

  " show column 80
  set colorcolumn=80
endif

set scrolloff=5               " keep at least 5 lines above/below

" spelling
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

" color scheme
color molokai

" make the color column more subtle
highlight ColorColumn guibg='Gray 10'

" don't dim comments
highlight Comment guifg=Gold3

"" Whitespace
set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " backspace through everything in insert mode

if exists("g:enable_mvim_shift_arrow")
  let macvim_hig_shift_movement = 1 " mvim shift-arrow-keys
endif

" List chars
set listchars=""                  " Reset the listchars
set listchars=tab:\▸\             " a tab should display as "▸", trailing whitespace as "."
set listchars+=trail:.            " show trailing spaces as dots
set listchars+=extends:>          " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen
set listchars+=precedes:<         " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen

"" Searching
set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter

"" Wild settings
" TODO: Investigate the precise meaning of these settings
" set wildmode=list:longest,list:full

" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.class,.svn,*.gem

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Ignore bundler and sass cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

" Disable temp and backup files
set wildignore+=*.swp,*~,._*

"" Backup and swap files
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

"Powerline options
set guifont=Inconsolata\ for\ Powerline:h14
let g:Powerline_symbols = 'fancy'

cmap w!! %!sudo tee > /dev/null %

" disable toolbar
if has("gui_running")
  set guioptions-=T
endif

" enable sane text selection
if has("gui_macvim")
  let macvim_hig_shift_movement = 1
endif

" enable sane file selection
"set wildmode
set wildmode=list:longest

" map leader
let mapleader = ','

set history=1000

" Don't show swap alert, default value is filnxtToO
set shortmess=filnxtToOA

" going hard core
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

  " make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
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

map <leader>zw :ZoomWin<CR>

map <Leader>rt :TagbarToggle<CR>

" fugitive mappings
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
