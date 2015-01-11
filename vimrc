" comment {{{1
" filename: ~/.vimrc  (on windows its $VIM/_vimrc)
" author: lukas singer <lukas42singer (at) gmail (dot) com>
" Copyright (C) 2015 Lukas Singer
"
" how to install vim plugins:
"   apt-get install clang
"   mkdir ~/.vim/tmp
"   mkdir ~/.vim/tmp/backup
"   mkdir ~/.vim/tmp/undo
"   mkdir ~/.vim/tmp/swap
"   mkdir ~/.vim/bundle
"   git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"   vim
"   :PluginInstall
" done.
"
" on windows: vundle didn't work for me.
"   just add a plugin to the folder $VIM/vimfiles/bundle
"   i ll set the rtp for you, but i cant run :helptags !
"
"

" os {{{1
if has("win32")
  " i am a windows machine
  let s:os = "windows"
elseif has("unix")
  let s:uname = system("uname -a")
  if s:uname =~ "Debian"
    let s:os = "debian"
  else
    let s:os = "unix"
  endif
endif


" debian {{{2
if s:os == "debian"
  runtime! debian.vim
endif

" windows {{{2



" plugins {{{1

" needed to run vundle (but i want this anyways)
set nocompatible

" vundle needs filtype plugins off
" i turn it on later
filetype plugin indent off
syntax off

" load the plugins
if s:os == "windows"
  " sadly i cannot use vundle on windows (due to proxy settings of the company
  " they dont allow git --> WTF ?!
  for s:entry in split(expand('$VIM/vimfiles/wtf/*'))
    if isdirectory(s:entry)
      execute 'set rtp+='.s:entry
    endif
  endfor
else
  " yes! i am not on windows. i am so happy !!
  " have i mentioned that i don't like windows.

  " anyways, set the runtimepath for vundle
  set rtp+=~/.vim/bundle/Vundle.vim

  " start vundle environment
  " the default is ~/.vim/bundle
  call vundle#begin()

  " list of plugins {{{2
  " let Vundle manage Vundle (this is required)
  Plugin 'gmarik/Vundle.vim'

  " to install a plugin add it here and run :PluginInstall.
  " to update the plugins run :PluginInstall! or :PluginUpdate
  " to delete a plugin remove it here and run :PluginClean

  Plugin 'Rip-Rip/clang_complete'
  Plugin 'vim-scripts/CRefVim'
  Plugin 'sjl/gundo.vim'
  Plugin 'jondkinney/dragvisuals.vim'
  Plugin 'bling/vim-airline'
  Plugin 'scrooloose/syntastic'
  Plugin 'xolox/vim-misc'
  Plugin 'xolox/vim-session'
  Plugin 'flazz/vim-colorschemes'

  " add plugins before this
  call vundle#end()

  " local plugins
  set rtp+=~/.vim/own/vim-websearch
endif

" filetype syntax {{{1
" now (after vundle finished) it is save to turn filetype plugins on
filetype plugin indent on
syntax on

" plugin settings {{{1
" here are settings for my plugins.
" see fold area 'plugins' for a list of plugins.

" gundo {{{2
" i want the preview window under my file, not under the undo tree.
" like this:          not like this (default):
"   +-+-------+         +-+-------+
"   |g| file  |         |g| file  |
"   |g|       |         |g|       |
"   |g+-------+         +-+       |
"   |g|preview|         |p|       |
"   +-+-------+         +-+-------+
"
let g:gundo_preview_bottom = 1
" vim-websearch {{{2
let g:web_search_engine = "google"
if s:os == "windows"
  " TODO : fix windows incompatibility in the plugin!
  "let g:web_search_command = "C:\\Program Files\ \(x86\)\\Google\\Chrome\\Application\\chrome.exe"
  "let g:web_search_command = "C:\\Program Files\\Internet Explorer\\iexplore.exe"
else
  let g:web_search_browser = "chromium"
endif


" vim-airline {{{2
" i want to use the airline tabs
let g:airline#extensions#tabline#enabled=1

" clang_complete {{{2
let g:clang_complete_auto=0  " I can start the autocompletion myself, thanks..
" let g:clang_snippets=1     " use a snippet engine for placeholders
" let g:clang_snippets_engine='ultisnips'
" let g:clang_auto_select=2  " automatically select and insert the first match

" vim-session {{{2
" i want to autosave the last session as 'default'
let g:session_autosave = 'yes'
" but i dont want to restore the last session automaticaly
let g:session_autoload = 'no'
" every instance of vim should overwrite the default session when closed.
let g:session_default_overwrite = 1
" i dont need my colorsettings saved to the session.
let g:session_persist_colors = 0

" dragvisuals.vim {{{2
" delete trailing whites if there were added some by dragging by dragvisuals
let g:DVB_TrimWS = 1

" gui {{{1
if has("gui_running")
  set guifont=courier_new:h9
  set lines=50
  set columns=120
  " i dont want/need the menu and toolbar or the scollbar.
  set guioptions=
endif

" colors {{{1
"enable 256 colors when in gnome-terminal (my debian machine)
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
 " looks nice on my terminal, it keeps my transparent terminal background!

  colorscheme slate
else
  colorscheme jelleybeans  " looks nice in gui.
endif
" try <http://bytefluent.com/vivify/> to test colorschemes

" i want to highlight trailing whites
hi TrailingWhitespace ctermbg=darkred ctermfg=darkred guifg=darkred guibg=darkred
call matchadd('TrailingWhitespace', '\s\+$')

" i want to highlight lines longer than 80 chars in some way
" TODO : i dont want to match it a linebreak (if i am exactly 80 chars long).
hi ColorColumn80 ctermbg=darkmagenta ctermfg=white guibg=darkmagenta guifg=white
call matchadd('ColorColumn80', '\%81v')

" some settings to highlight the current line and the linenumber
" cterm=none is needed to get rid of the ugly underlining of the current line.
hi CursorLine cterm=none ctermbg=black
hi LineNr ctermbg=black
hi CursorLineNr ctermbg=black

" options {{{1
" spelling {{{2
set spelllang=de,en

" linenumbers & cursorline {{{2
set number
set numberwidth=6
set cursorline

" completion & popups {{{2
set pumheight=25             " so the complete menu doesn't get too big
set completeopt=menu,longest " menu, menuone, longest and preview

" interface {{{2
set ruler
set laststatus=2
" i want to see the command i've executed
set showcmd
set noerrorbells

" search {{{2
set hlsearch
set ignorecase

" tabs, indent & backspace {{{2
" i want to use backspace like in any other editor
set backspace=indent,eol,start
set autoindent
" try smartindent, do i like this?
set smartindent
set shiftwidth=2
set softtabstop=2
set expandtab
" fix the c-switch-case{} indendation:
" <http://stackoverflow.com/questions/19990835/issue-with-cindent-indentation-
"      based-on-scope-in-switch-case-statements-in-vim>
set cinoptions=l1

" undo, backup & swap {{{2
" the double slash at the end of the paths makes filenames include the path
" with slashes replaced by percent sign.
if s:os != "windows"
  set undodir=~/.vim/tmp/undo//
  set backupdir=~/.vim/tmp/backup//
  set directory=~/.vim/tmp/swap//
else
  set undodir=$VIM/vimfiles/tmp/undo//
  set backupdir=$VIM/vimfiles/tmp/backup//
  set directory=$VIM/vimfiles/tmp/swap//
endif
set backupskip=*/tmp/*
set backup
set undofile
set undolevels=1000
set undoreload=10000

" folding {{{2
set foldmethod=marker
set foldmarker={{{,}}}

" other stuff {{{2
" i want the current dir allways be the directory of the current file
set autochdir
" allow to switch buffers even if the current buffer is not yet written.
set hidden

" show list of completions and complete as much as possible
set wildmode=list:longest

" autocommands {{{1

augroup myvimrcstuff "{{{2
  autocmd!
  " reload vimrc when saved (and refresh airline due to:
  "     <https://github.com/bling/vim-airline/issues/539> )
  autocmd BufWritePost $MYVIMRC source $MYVIMRC | AirlineRefresh
  autocmd BufWritePost $MYVIMRC AirlineRefresh
augroup END


augroup mylatexstuff "{{{2
  autocmd!
  " replace umlauts in latex
  " i use mapping for this, because i want to replace them always not only
  " when they are a single char (thats what iabbrev does).
  autocmd Filetype tex,latex inoremap <buffer> ü {\"u}
  autocmd Filetype tex,latex inoremap <buffer> Ü {\"U}
  autocmd Filetype tex,latex inoremap <buffer> ä {\"a}
  autocmd Filetype tex,latex inoremap <buffer> Ä {\"A}
  autocmd Filetype tex,latex inoremap <buffer> ö {\"o}
  autocmd Filetype tex,latex inoremap <buffer> Ö {\"O}
  autocmd Filetype tex,latex inoremap <buffer> ß {\ss}
augroup END

" abbreviations {{{1
" f.e. type <@><@><space> in insert mode and it get replaced by
"   < lukas42singer (at) gmail (dot) com >
inoreabbrev (f) <C-R>=expand("%:t")<CR>
inoreabbrev @@ <lukas42singer (at) gmail (dot) com>
inoreabbrev (c) Copyright (C) <C-R>=strftime("%Y")<CR> Lukas Singer
inoreabbrev (d) <C-R>=strftime("%Y/%m/%d")<CR>

" mappings {{{1

" set the <leader> to
let mapleader = ","

" buffers, windows & tabs {{{2
" use ä to switch to next tab an ö to previos
" char-228 == ä
nnoremap <silent> <CHAR-228> :bn<CR>
" char-246 == ö
nnoremap <silent> <CHAR-246> :bN<CR>

" use Ctrl and hjkl to navigate between split screen 'windows'
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" searching {{{2
" unhighlight search on enter
nnoremap <silent> <CR> :nohl<CR><CR>

" make the cursor stay where it is when using the * command
nnoremap <silent> * *N

" :help, man & websearch {{{2
" i want to use <leader>h for lookup the current word in the vim help
"nnoremap <expr> <leader>h (":help " . fnameescape(expand('<cword>')) . "\n")
nnoremap <leader>h :help <C-r><C-w><CR>

" i want to use <leader>m for lookup the current word in man pages (this is the
" default of upper K, but i use upper K to split lines)
nnoremap <leader>m K

" search for word under cursor in normal mode
nnoremap <leader>w :WebSearchCursor<CR>
" search for selection in visual mode
vnoremap <leader>w :WebSearchVisual<CR>

" open my cheatsheat
" open the cheatsheet in a new window on the right, turn of cursorline and
" linenumber, search for CHEATSHEETSTARTSHERE, go to next line, make this line
" the top line of the buffer and jump back to the last window!
" THIS IS AWESOME WOHOO !!
nnoremap <leader>cs :botright 60 vnew ~/.vimcheatsheet<CR>:setlocal nocursorline nonumber<CR>gg/CHEATSHEETSTARTSHERE<CR>jzt<C-w><C-p>

" editing, modifying {{{2
" upper J joins 2 lines, so upper K should split them imho.
nnoremap <silent> K i<CR><ESC>k$

" autocompletion
if has("gui_running")
  inoremap <C-SPACE> <C-x><C-u>
else
  " <C-@> is <C-Space> in terminal mode!
  inoremap <C-@> <C-x><C-u>
endif

" mappings for dragvisuals plugin
vmap <expr> <C-h> DVB_Drag('left')
vmap <expr> <C-l> DVB_Drag('right')
vmap <expr> <C-j> DVB_Drag('down')
vmap <expr> <C-k> DVB_Drag('up')
vmap <expr> D DVB_Duplicate()

" force my self to use o instead of A<CR>
nnoremap A<CR> <nop>

" open files {{{2
" i often want to open my vimrc to look something up or to change something
if s:os == "windows"
  nnoremap <leader>v :e $VIM/_vimrc<CR>
else
  nnoremap <leader>v :e ~/.vimrc<CR>
endif

" folding {{{2
" use <space> to toggle fold under cursor
nnoremap <SPACE> za
" use <leader><space> to fold all except the current cursor position
nnoremap <leader><SPACE> zMzvzz
" use Ctrl Space in normal mode to open all folds
if has("gui_running")
  nnoremap <C-SPACE> zR
else
  nnoremap <C-@> zR
endif

" gundo {{{2
" TODO: install python 2.7 on windows and test again. (python3 didn't work)
nnoremap <leader>u :GundoToggle<CR>

" navigation {{{2
" let ß (on german keyboard next to zero) jump to last char of line
noremap ß $
" i want to use <TAB> to jump between opening/closing brackets
noremap <TAB> %

" jump in (<C-]> is 'finger-yoga' on german keyboards)
nnoremap <C-i> <C-]>
" jump out
nnoremap <C-o> <C-T>

" if i have wraped lines i want to go to next/previous visual line
" not next/previous physical line!
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" use H as page down and L as page up.
noremap H <PageDown>zz
noremap L <PageUp>zz

" force myself to use hjkl!
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>
inoremap <Left>  <NOP>
inoremap <Right> <NOP>
nnoremap <Up>    <NOP>
nnoremap <Down>  <NOP>
nnoremap <Left>  <NOP>
nnoremap <Right> <NOP>
vnoremap <Up>    <NOP>
vnoremap <Down>  <NOP>
vnoremap <Left>  <NOP>
vnoremap <Right> <NOP>

" misc {{{2
if s:os != "windows"
" show the date and time when press <leader>dt
  nnoremap <leader>dt :echom substitute(system("date"), '\n$', '', 'g')<CR>
endif

" use <C-s> to save a file. ctrl-s doesnt work in terminals by default.
" add the following line to ~/.bashrc
"   stty stop undef
" this disables the handling of ctrl-s by the terminal.
inoremap <C-s> <esc>:w<CR>a
vnoremap <C-s> <esc>:w<CR>gv
nnoremap <C-s> :w<CR>
" use ctrl-shift-s to save all files.
inoremap <C-S> <esc>:wa<CR>a
vnoremap <C-S> <esc>:wa<CR>gv
nnoremap <C-S> :wa<CR>

