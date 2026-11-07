" --- General Settings ---
filetype plugin indent on
syntax enable
set backspace=indent,eol,start
set hidden
set autoread
set updatetime=300
set timeoutlen=500
set ttimeoutlen=50

" --- Colors & Gruvbox Material ---
if has('termguicolors')
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set background=dark
let g:gruvbox_material_background = 'medium'
let g:gruvbox_material_better_performance = 1
silent! colorscheme gruvbox-material

" --- UI & Display ---
set number
set relativenumber
set cursorline
set signcolumn=yes
set scrolloff=8
set sidescrolloff=8
set showcmd
set ruler
set wildmenu
set wildmode=longest:full,full
set laststatus=2
set splitbelow
set splitright
set showmatch

" --- Indentation & Formatting ---
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set wrap
set linebreak

" --- Search ---
set incsearch
set hlsearch
set ignorecase
set smartcase

" --- Clipboard & Mouse ---
set mouse=a

" --- Persistent Undo & Swap Protection ---
set undofile
set undodir=~/.vim/undo//
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//

if !isdirectory(expand('~/.vim/undo'))
  call mkdir(expand('~/.vim/undo'), 'p')
endif
if !isdirectory(expand('~/.vim/backup'))
  call mkdir(expand('~/.vim/backup'), 'p')
endif
if !isdirectory(expand('~/.vim/swap'))
  call mkdir(expand('~/.vim/swap'), 'p')
endif

" --- Key Mappings ---
nnoremap <silent> <Esc> :nohlsearch<CR><Esc>

if has('autocmd')
  augroup AutoChecktime
    autocmd!
    autocmd FocusGained,BufEnter * checktime
  augroup END
endif
