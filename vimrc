" author: lukas singer <lukas42singer (at) gmail (dot) com>
" 
" how to install vim plugins:
"   apt-get install clang
"   mkdir ~/.vim/tmp/backup
"   mkdir ~/.vim/tmp/undo
"   mkdir ~/.vim/tmp/swap
"   mkdir ~/.vim/bundle
"   git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"   vim
"   :PluginInstall
" done.
"

" needed because i am on debian.
runtime! debian.vim

" needed to run vundle (but i want this anyways)
set nocompatible

" vundle needs filtype plugins off
" i turn it on later
filetype plugin indent off
syntax off

" set the runtime path for vundle
set rtp+=~/.vim/bundle/Vundle.vim

" start vundle environment
call vundle#begin()

" let Vundle manage Vundle (this is required)
Plugin 'gmarik/Vundle.vim'

" to install a plugin add it here and run :PluginInstall.
" to update the plugins run :PluginInstall! or :PluginUpdate
" to delete a plugin remove it here and run :PluginClean
"

Plugin 'Rip-Rip/clang_complete'
Plugin 'vim-scripts/CRefVim'
Plugin 'jondkinney/dragvisuals.vim'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/syntastic'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-session'
Plugin 'flazz/vim-colorschemes'

"
" add plugins before this
call vundle#end()

" now (after vundle finished) it is save to turn filetype plugins on
filetype plugin indent on
syntax on

" fix the c-switch-case{} indendation:
" <http://stackoverflow.com/questions/19990835/issue-with-cindent-indentation-
"      based-on-scope-in-switch-case-statements-in-vim>
set cinoptions=l1

" spell options
set spelllang=de,en

" some coloring stuff.
" try <http://bytefluent.com/vivify/> to test colorschemes
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
" cterm=none is needed to get rid of the ugly underlining of the current line.
hi CursorLine cterm=none ctermbg=black
set number
hi LineNr ctermbg=black
hi CursorLineNr ctermbg=black
set numberwidth=6

" i want to use the airline tabs
let g:airline#extensions#tabline#enabled=1

set pumheight=25             " so the complete menu doesn't get too big
set completeopt=menu,longest " menu, menuone, longest and preview
let g:clang_complete_auto=0  " I can start the autocompletion myself, thanks..
" let g:clang_snippets=1     " use a snippet engine for placeholders
" let g:clang_snippets_engine='ultisnips'
" let g:clang_auto_select=2  " automatically select and insert the first match

" i want to autosave the last session as 'default'
let g:session_autosave = 'yes'
" but i dont want to restore the last session automaticaly
let g:session_autoload = 'no'
" every instance of vim should overwrite the default session when closed.
let g:session_default_overwrite = 1
" i dont need my colorsettings saved to the session.
let g:session_persist_colors = 0

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

" the double slash at the end of the paths makes filenames include the path
" with slashes replaced by percent sign.
"
" undo settings
set undodir=~/.vim/tmp/undo//
" backup and swap settings
set backupdir=~/.vim/tmp/backup//
set backupskip=*/tmp/*
set directory=~/.vim/tmp/swap//
set backup

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
" <https://github.com/bling/vim-airline/issues/539>
augroup reload_vimrc " {
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC | AirlineRefresh
  autocmd BufWritePost $MYVIMRC AirlineRefresh
augroup END " }
"autocmd bufwritepost .vimrc source %

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

