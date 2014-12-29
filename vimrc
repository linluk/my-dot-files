" author: lukas singer <lukas42singer (at) gmail (dot) com>
" list of plugins:
"   * clang_complete
"   * crefvim
"   * tabbar
"   * dragvisuals

" needed because i am on debian.
runtime! debian.vim

" needed to introduce the dragvisuals plugin (see vmaps left, right, up, down)
runtime plugin/dragvisuals.vim

set nocompatible

filetype plugin indent on
syntax on

" some coloring stuff.
if $COLORTERM == 'gnome-terminal'
  "enable 256 colors when in gnome-terminal (my debian machine)
  set t_Co=256
endif
colorscheme slate

" i want to highlight trailing whites
hi ExtraWhitespace ctermbg=darkred
match ExtraWhitespace /\s\+$/

" i want to highlight lines longer than 80 chars
" TODO : i am not happy with the colors and i dont want to match it a linebreak
" (if i am exactly 80 chars long).
hi ColorColumn ctermbg=white ctermfg=black
match ColorColumn '\%81v'

" some settings to highlight the current line and the linenumber
set cursorline
hi CursorLine term=none cterm=none ctermbg=black
set number
hi LineNr ctermbg=black
hi CursorLineNr ctermbg=black
set numberwidth=5

set pumheight=25             " so the complete menu doesn't get too big
set completeopt=menu,longest " menu, menuone, longest and preview
let g:clang_complete_auto=0  " I can start the autocompletion myself, thanks..
" let g:clang_snippets=1     " use a snippet engine for placeholders
" let g:clang_snippets_engine='ultisnips'
" let g:clang_auto_select=2  " automatically select and insert the first match

" set wildmenu
set noerrorbells

" i want to see the command i've executed
set showcmd

" some search options
set hlsearch
set ignorecase

" i want to use backspace like in any other editor
set backspace=indent,eol,start
" jeah i want this
set autoindent
set ruler
set laststatus=2

" tab settings
set shiftwidth=2
set softtabstop=2
set expandtab

" backup and swap settings
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/swap

" allow up to 50 tabs (default was 10, that was not enough for me)
set tabpagemax=50

" i want the current dir allways be the directory of the current file
set autochdir

" show buffer tabs in multiple lines (if they dont fit in one)
" tabbar.vim plugin
let g:Tb_TabWrap = 1
let g:Tb_MaxSize = 0
let g:Tb_MinSize = 1

" delete trailing whites if there were added some by dragging by dragvisuals
let g:DVB_TrimWS = 1

" allow to switch buffers even if the current buffer is not yet written.
set hidden

" gvim settings
if has("gui_running")
  " gui is running or is about to start
  set lines=50
  set columns=120
  set guifont=courier_new:h8:w5
endif

" when editing .vimrc it should be reloaded when saved
autocmd bufwritepost .vimrc source %

" set the <leader> to , (used by crefvim for example)
let mapleader = ","
" used in crefvim plugin. press and hold ',' and type 'cr', 'cc' or 'cw'
" to open the reference.

" use tab or ä to switch to next tab an ö to previos
nnoremap <silent> <TAB> :bn<CR>
" char-228 == ä
nnoremap <silent> <CHAR-228> :bn<CR>
" char-246 == ö
nnoremap <silent> <CHAR-246> :bN<CR>

" unhighlight search on enter
nnoremap <silent> <CR> :nohl<CR><CR>

" i often want to open my vimrc to look something up or to change something
nnoremap <leader>v :e ~/.vimrc<CR>

" use Ctrl and hjkl to navigate between split screen 'windows'
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" <C-@> is <C-Space> in terminal mode! (used for autocompletion)
inoremap <C-@> <C-x><C-u>

" let ß (on german keyboard next to zero) jump to last char of line
noremap ß $

" mappings for dragvisuals plugin
vmap <expr> <C-h> DVB_Drag('left')
vmap <expr> <C-l> DVB_Drag('right')
vmap <expr> <C-j> DVB_Drag('down')
vmap <expr> <C-k> DVB_Drag('up')
vmap <expr> D DVB_Duplicate()

