" comment {{{1
" filename: ~/.vimrc  (on windows its $VIM/_vimrc)
" author: lukas singer <lukas42singer (at) gmail (dot) com>
" Copyright (C) 2016 Lukas Singer
"
" how to install vim plugins:
"   mkdir ~/.vim/tmp
"   mkdir ~/.vim/tmp/backup
"   mkdir ~/.vim/tmp/undo
"   mkdir ~/.vim/tmp/swap
"   mkdir ~/.vim/bundle
"   git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"   vim
"   :PluginInstall
" done.
"
" on windows: vundle didn't work for me.
"   just add a plugin to the folder $VIM/vimfiles/bundle
"   i ll set the rtp for you, but i cant run :helptags automatically!
"   (or can i?)
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
  elseif s:uname =~ "Ubuntu"
    let s:os = "ubuntu"
  else
    let s:os = "unix"
  endif
endif


" debian {{{2
if s:os == "debian"
  runtime! debian.vim
endif




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
  Plugin 'VundleVim/Vundle.vim'

  " to install a plugin add it here and run :PluginInstall.
  " to update the plugins run :PluginInstall! or :PluginUpdate
  " to delete a plugin remove it here and run :PluginClean

  Plugin 'jondkinney/dragvisuals.vim'
  Plugin 'xolox/vim-misc'
  Plugin 'flazz/vim-colorschemes'
  Plugin 'davidhalter/jedi-vim'
  Plugin 'justmao945/vim-clang'

  " my own plugins
  Plugin 'linluk/vim-websearch'
  Plugin 'linluk/vim-c2h'

  " add plugins before this
  call vundle#end()

endif

" filetype syntax {{{1
" now (after vundle finished) it is save to turn filetype plugins on
filetype plugin indent on
syntax on

" plugin settings {{{1
" here are settings for my plugins.
" see fold area 'plugins' for a list of plugins.

" vim-websearch {{{2
let g:web_search_engine = "google"
if s:os == "windows"
  " TODO : fix windows incompatibility in the plugin!
  "let g:web_search_command = "C:\\Program Files\ \(x86\)\\Google\\Chrome\\Application\\chrome.exe"
  "let g:web_search_command = "C:\\Program Files\\Internet Explorer\\iexplore.exe"
else
  let g:web_search_browser = "lynx"
endif


" dragvisuals.vim {{{2
" delete trailing whites if there were added some by dragging by dragvisuals
let g:DVB_TrimWS = 1

" vim-jedi {{{2
" i can start completion myself!
let g:jedi#popup_on_dot = 0
" and i dont want you to select the first item
let g:jedi#popup_select_first = 0

"
let g:jedi#show_call_signatures = "1"

let g:jedi#goto_assignments_command = "<C-i>"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = ""
let g:jedi#usages_command = ""
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = ""
"""let g:jedi#force_py_version = 3
let g:jedi#auto_vim_configuration = 0

autocmd FileType python setlocal completeopt-=preview

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
"if $COLORTERM == 'gnome-terminal'
"if s:os == "debian"
"  set t_Co=256
" " looks nice on my terminal, it keeps my transparent terminal background!
"  colorscheme slate
"elseif s:os == "ubuntu"
  colorscheme jellybeans
"else
"  if has("gui_running")
"    colorscheme jelleybeans  " looks nice in gui.
"  else
"    colorscheme default
"  endif
"endif
"" try <http://bytefluent.com/vivify/> to test colorschemes

" i want to highlight trailing whites
hi TrailingWhitespace ctermbg=darkred ctermfg=darkred guifg=darkred guibg=darkred
call matchadd('TrailingWhitespace', '\s\+$')

" i want to highlight lines longer than 80 chars in some way
" TODO : i dont want to match it a linebreak (if i am exactly 80 chars long).
"hi ColorColumn80 ctermbg=darkmagenta ctermfg=white guibg=darkmagenta guifg=white
"call matchadd('ColorColumn80', '\%81v')

" some settings to highlight the current line and the linenumber
" cterm=none is needed to get rid of the ugly underlining of the current line.
hi CursorLine cterm=none ctermbg=black
hi LineNr ctermbg=black
hi CursorLineNr ctermbg=black

" options {{{1
" encoding {{{2
set encoding=utf-8
set fileencoding=utf-8

" spelling {{{2
set spelllang=de,en
if s:os != "windows"
  set spellfile=~/.vim/spell/linluk.utf-8.add
endif

" linenumbers & cursorline {{{2
set number
set numberwidth=6
set relativenumber
set cursorline

" completion & popups {{{2
set pumheight=30             " so the complete menu doesn't get too big
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
" try cindent, do i like this?
set cindent
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

" see: https://github.com/bling/vim-airline/issues/539#issuecomment-70247140
"command! AirlineForceRefresh call airline#load_theme() | call airline#update_statusline() | call airline#load_theme() | call airline#update_statusline()
augroup myvimrcstuff "{{{2
  autocmd!
  " reload vimrc when saved (and refresh airline due to:
  "     <https://github.com/bling/vim-airline/issues/539> )
"  autocmd BufWritePost $MYVIMRC source $MYVIMRC | AirlineRefresh
"  autocmd BufWritePost $MYVIMRC AirlineRefresh
  "autocmd BufwritePost $MYVIMRC source $MYVIMRC | AirlineForceRefresh
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

augroup myhelpstuff "{{{2
  autocmd!
  " open help in a vertical split window
  autocmd Filetype help call CurrentWindowToRightMost()
augroup END

augroup mycssstuff "{{{2
  autocmd!
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS
augroup END

augroup mypythonstuff "{{{2
  autocmd!
  autocmd FileType python set cindent
  autocmd FileType python set shiftwidth=4
  autocmd FileType python set softtabstop=4
  autocmd FileType python set expandtab
  autocmd FileType python set omnifunc=jedi#completions
  autocmd FileType python map <F5> <ESC>:w<CR>:!python % <CR>
augroup END

augroup mycstuff "{{{2
  autocmd!
  autocmd FileType c map <F5> <ESC>:wa<CR>:make<CR>
augroup END

augroup mymdstuff "{{{2
  autocmd!
  autocmd FileType markdown set textwidth=80
augroup END

" abbreviations {{{1
" f.e. type <@><@><space> in insert mode and it get replaced by
"   < lukas42singer (at) gmail (dot) com >
inoreabbrev (f) <C-R>=expand("%:t")<CR>
inoreabbrev @@ <lukas42singer (at) gmail (dot) com>
inoreabbrev (c) Copyright (C) <C-R>=strftime("%Y")<CR> Lukas Singer
inoreabbrev (d) <C-R>=strftime("%Y/%m/%d")<CR>
inoreabbrev (l) <C-R>=AddGpl3License()<CR>
inoreabbrev (c-header) <C-R>=AddCHeader()<CR>
inoreabbrev #i #include
inoreabbrev #d #define

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
nnoremap <silent> * *Nzz

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
nnoremap <leader>cs :botright 60 vnew ~/.vimcheatsheet<CR>:setlocal nocursorline nonumber<CR>gg/CHEATSHEETSTARTSHERE<CR>:nohl<CR>jzt<C-w><C-p>

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

" remove trailing whitespaces of current line when insert linebreak
"inoremap <CR> <CR><ESC>k:s/\s\+$//e<CR>jI

" indent hole buffer when pressed =
nnoremap = gg=G'`

" mappings for dragvisuals plugin
vmap <expr> <C-h> DVB_Drag('left')
vmap <expr> <C-l> DVB_Drag('right')
vmap <expr> <C-j> DVB_Drag('down')
vmap <expr> <C-k> DVB_Drag('up')
vmap <expr> D DVB_Duplicate()

" force my self to use o instead of A<CR>
nnoremap A<CR> <nop>

" let ~ toggle case of whole words
nnoremap ~ bve~

" spelling {{{2

" toggle spell
nnoremap <leader>s :setlocal spell! spelllang=de,en<cr>
" suggest spelling (its just so much easier to type!)
nnoremap z0 z=
" next/previous mistake
" they hide fold none and fold normal!
nnoremap zn ]s
nnoremap zN ]s

" open files {{{2
" I often want to open my vimrc to look something up or to change something
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
" use Ctrl Space in normal mode to kind of toggle all folds
if has("gui_running")
  nnoremap <C-SPACE> zi
else
  nnoremap <C-@> zi
endif

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

" use <C-s> to save a file. ctrl-s doesn't work in terminals by default.
" add the following line to ~/.bashrc
"   stty stop undef
" this disables the handling of Ctrl-s by the terminal.
inoremap <C-s> <esc>:w<CR>a
vnoremap <C-s> <esc>:w<CR>gv
nnoremap <C-s> :w<CR>
" use ctrl-shift-s to save all files.
inoremap <C-S> <esc>:wa<CR>a
vnoremap <C-S> <esc>:wa<CR>gv
nnoremap <C-S> :wa<CR>

" commands {{{1
" use :wm for :write + :make
command! WM wall | make
cnoreabbrev wm WM

" functions {{{1


function! AddGpl3License() "{{{2
  let l:progname = input("program to create the license for?\n")
  while l:progname == ""
    let l:progname = input("")
  endwhile
  let l:filename = expand("%:t")
  let l:license = l:filename . " is part of " . l:progname . ".\n\n" .
      \ l:progname . " is free software: you can redistribute it and/or modify\n" .
      \"it under the terms of the GNU General Public License as published by\n" .
      \"the Free Software Foundation, either version 3 of the License, or\n" .
      \"(at your option) any later version.\n\n" .
      \ l:progname . " is distributed in the hope that it will be useful,\n" .
      \"but WITHOUT ANY WARRANTY; without even the implied warranty of\n" .
      \"MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n" .
      \"GNU General Public License for more details.\n\n" .
      \"You should have received a copy of the GNU General Public License\n" .
      \"along with " . l:progname . ".  If not, see <http://www.gnu.org/licenses/>.\n"
  return l:license
endfunction

function! AddCHeader() "{{{2
  let l:def = "__" . toupper(substitute(expand("%:t"), '\.', "_", "")) . "__"
  let l:header =
    \ "#ifndef " . l:def . "\n" .
    \ "#define " . l:def . "\n\n\n" .
    \ "#endif /* " . l:def . " */"
  return l:header
endfunction

function! CurrentWindowToRightMost() "{{{2
  " i use this in an autocmd for help.
  if !exists("w:is_right")
    wincmd L
    vertical resize 80
    let w:is_right = 1
  endif
endfunction

" Save/Restore gvim Window Postition {{{2
" settings:
" To enable the saving and restoring of screen positions.
let g:screen_size_restore_pos = 1

" To save and restore screen for each Vim instance.
" This is useful if you routinely run more than one Vim instance.
" For all Vim to use the same settings, change this to 0.
let g:screen_size_by_vim_instance = 0
" http://vim.wikia.com/wiki/Restore_screen_size_and_position
if has("gui_running")
  function! ScreenFilename()
    if has('amiga')
      return "s:.vimsize"
    elseif has('win32')
      return $HOME.'\_vimsize'
    else
      return $HOME.'/.vimsize'
    endif
  endfunction

  function! ScreenRestore()
    " Restore window size (columns and lines) and position
    " from values stored in vimsize file. Must set font first
    " so columns and lines are based on font size.
    let f = ScreenFilename()
    if has("gui_running") && g:screen_size_restore_pos && filereadable(f)
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      for line in readfile(f)
        let sizepos = split(line)
        if len(sizepos) == 5 && sizepos[0] == vim_instance
          silent! execute "set "columns=".sizepos[1]." "lines=".sizepos[2]
          silent! execute "winpos ".sizepos[3]." ".sizepos[4]
          return
        endif
      endfor
    endif
  endfunction

  function! ScreenSave()
    " Save window size and position.
    if has("gui_running") && g:screen_size_restore_pos
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      let data = vim_instance .  ' ' .  &columns .  ' ' .  &lines .  ' ' .
            \ (getwinposx()<0?0:getwinposx()) .  ' ' .
            \ (getwinposy()<0?0:getwinposy())
      let f = ScreenFilename()
      if filereadable(f)
        let lines = readfile(f)
        call filter(lines, "v:val !~ '^" . vim_instance . "\\>'")
        call add(lines, data)
      else
        let lines = [data]
      endif
      call writefile(lines, f)
    endif
  endfunction

  if !exists('g:screen_size_restore_pos')
    let g:screen_size_restore_pos = 1
  endif
  if !exists('g:screen_size_by_vim_instance')
    let g:screen_size_by_vim_instance = 1
  endif
  autocmd VimEnter * if g:screen_size_restore_pos == 1 | call ScreenRestore() | endif
  autocmd VimLeavePre * if g:screen_size_restore_pos == 1 | call ScreenSave() | endif
endif

