" load pathogen
call pathogen#infect()
syntax on
filetype plugin indent on

"ttowerline options
set guifont=Inconsolata\ for\ Powerline:h14
let g:Powerline_symbols = 'fancy'

color molokai

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

