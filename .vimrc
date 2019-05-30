set nocompatible      " Use vim, no vi defaults. Set first as it has side
                      " effects on other settings

filetype off    " vundle required

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" vundle required
Bundle 'gmarik/vundle'

Bundle 'tpope/vim-sensible'
Bundle 'ajf/puppet-vim'
Bundle 'ervandew/supertab'
Bundle 'tpope/vim-fugitive'
Bundle 'bling/vim-airline'
Bundle 'bling/vim-bufferline'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-git'
Bundle 'vim-scripts/molokai'
Bundle 'bitc/vim-bad-whitespace'
Bundle 'Raimondi/delimitMate'
Bundle 'vim-scripts/ShowMarks'
Bundle 'tpope/vim-vividchalk'
Bundle 'guns/vim-clojure-static'
Bundle 'rizzatti/funcoo.vim'
Bundle 'rizzatti/dash.vim'
Bundle 'terryma/vim-expand-region'
Plugin 'rust-lang/rust.vim'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'henrik/git-grep-vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'scrooloose/nerdcommenter'
Bundle 'hashivim/vim-terraform'
Bundle 'flazz/vim-colorschemes'

let g:expand_region_text_objects_clojure = {
      \ 'a)' :1,
      \ }

if v:version >= '702'
    Bundle 'majutsushi/tagbar'
    Bundle 'scrooloose/syntastic'
endif

filetype plugin indent on     " vundle required

" Customize leader
let mapleader = ' '

" Load pathogen
call pathogen#infect()

" Basic config

if exists("&relativenumber")
  set relativenumber    " User nifty relative line numbers
else
  set number            " Show line numbers
endif

set ttyfast           " Optimize for fast terminal connections
set cursorline        " Highlight current line

set showcmd           " show partial command as you type them

set updatetime=250    " timeout for writing swap file, also affect showmarks
                      " updates

set vb t_vb=          " disable any beeping

" Don’t reset cursor to start of line when moving around.
set nostartofline

" We live in the future
set mouse=a

if exists("&colorcolumn")
  " Show column 80
  set colorcolumn=80
endif

" make split and vsplit open window in sane ways
set splitright
set splitbelow

" Spelling
if v:version >= 700
  " Enable spell check for text files
  autocmd BufNewFile,BufRead *.txt,*.md setlocal spell spelllang=en

  "spell check when writing commit logs
  autocmd filetype svn,*commit* setlocal spell spelllang=en
endif

set showmatch                   " show matching brackets
set formatoptions=tcrql         " t - autowrap to textwidth
                                " c - autowrap comments to textwidth
                                " r - autoinsert comment leader with <Enter>
                                " q - allow formatting of comments with :gq
                                " l - don't format already long lines

" Color scheme
colorscheme molokai

" Whitespace
set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs

if exists("g:enable_mvim_shift_arrow")
  let macvim_hig_shift_movement = 1 " mvim shift-arrow-keys
endif

set list                          " Show invisible characters

" Searching
set hlsearch    " highlight matches
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter

" Keep search matches in the middle of the window:
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap n nzzzv
nnoremap N Nzzzv

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

set guifont=Inconsolata\ for\ Powerline:h14

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

let g:showmarks_include = "abcdefghijklmnopqrstuvwxyz"

" Give this a try perhaps
nnoremap <Left> :bprev<CR>
nnoremap <Right> :bnext<CR>
nnoremap <Up> :buffers<CR>:buffer<SPACE>
nnoremap <Down> <C-^>

let g:airline_right_sep = ''
let g:airline_left_sep = ''
"let g:airline_linecolumn_prefix = '␊ '
"let g:airline_linecolumn_prefix = '␤ '
let g:airline_symbols#linenr = '¶ '
let g:airline_symbols#branch = '⎇ '

let g:bufferline_echo=0
autocmd VimEnter * let &statusline='%{bufferline#refresh_status()}' .bufferline#get_status_string()

au BufEnter /private/tmp/crontab.* setl backupcopy=yes

au BufNewFile,BufRead *.md set filetype=markdown

au BufNewFile,BufRead *.clj RainbowParenthesesToggle
