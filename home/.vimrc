"----------------------------------------------------------------------------
" These must be first, because they change other options as a side effect.
"----------------------------------------------------------------------------

" Use Vim settings, rather then Vi settings
set nocompatible

let mapleader=","

" pathogen lets you keep all our plugins contained in their own directory under
" .vim/bundle. http://github.com/tpope/vim-pathogen
call pathogen#runtime_append_all_bundles()

"----------------------------------------------------------------------------
" Indentation: Tabs are for communists.
"----------------------------------------------------------------------------

set autoindent " default indentation to that of the previous line
filetype plugin indent on " enable filetype-based special indentation rules

" 4-space soft tabs by default
set expandtab
set softtabstop=4
set shiftwidth=4

" 2-spaces for some things
au FileType ruby,cucumber,markdown,javascript set softtabstop=2 shiftwidth=2

"----------------------------------------------------------------------------
" Code Folding
"----------------------------------------------------------------------------

set foldmethod=indent   " fold based on indent
set foldnestmax=10      " deepest fold is 10 levels
set nofoldenable        " dont fold by default

"----------------------------------------------------------------------------
" Layout: I can never decide if I want to roll light on dark or vice versa.
"----------------------------------------------------------------------------

syntax on         " enable syntax highlighting
set nowrap        " disable line wrapping by default
set number        " turn on line numbers
set cursorline    " highlight current line
set ruler         " show current line/column number in status line
set scrolloff=5   " keep 5 lines when scrolling
set t_Co=256      " use 256 colors
set laststatus=2  " always show the status line

" Status line has filepath + modified flag, then file type, ascii and hex
" codes for character under cursor, and cursor row/column position.
set statusline=%F%m\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%l,%v] 

" Use Gary Bernhardt's custom DAS theme:
" https://github.com/garybernhardt/dotfiles/blob/master/.vim/colors/grb256.vim
" High contrast without having offensive colors. Perfect for my sucky eyes.
" Especially nice using the Pastel color set with a large font in iTerm 2.
color grb256
set background=dark

" Highlight right margin bg dark gray at 80 chars
set colorcolumn=80
highlight ColorColumn ctermbg=233

"----------------------------------------------------------------------------
" Autocomplete: I should really expand on these...
"----------------------------------------------------------------------------

" Close ERB tags
:iab <%=   <%= %><Left><Left><Left>
:iab <%   <% %><Left><Left><Left>

" Close ruby method defs
au BufRead,BufNewFile *.rb :iab def 
\def
\<CR>end<Up>

" Remap the tab key to do autocompletion or indentation depending on the
" context (from http://bitbucket.org/garybernhardt/dotfiles/src/tip/.vimrc)
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

"----------------------------------------------------------------------------
" Set Custom Filetypes
"----------------------------------------------------------------------------

au BufNewFile,BufRead {Gemfile,Rakefile,config.ru} set filetype=ruby
au BufNewFile,BufRead {*.md} set filetype=markdown

"---------------------------------------------------------------------------
" Configure plugins
"---------------------------------------------------------------------------

" NERD tree
map <leader>d :NERDTreeToggle<cr>
let NERDTreeQuitOnOpen=1

" Tagbar (like NERD tree but for ctags)
map <leader>m :TagbarToggle<cr>

" vim-markdown-preview needs a redraw until this gets pulled:
" https://github.com/nelstrom/vim-markdown-preview/pull/3
map mm :Mm<cr>:redraw!<cr>

"----------------------------------------------------------------------------
" Misc Mappings
"----------------------------------------------------------------------------

" Exit insert mode with ;;
" Giving remapped capslock=>esc a shot.
" imap ;; <esc>

" Switch to alternate buffer
map <leader>a <C-^>

" Rewrap current paragraph
map q gq}

" Updating .vimrc
map <leader>ve :e ~/.vimrc<cr>
map <leader>vu :source ~/.vimrc<cr>:exe ":echo 'vimrc reloaded'"<cr>

" Viewport controls
map <leader>h <C-w>h
map <leader>j <C-w>j
map <leader>k <C-w>k
map <leader>l <C-w>l

" Run current file
map <leader>rr :w<cr>:!ruby %<cr>
map <leader>rp :w<cr>:!python %<cr>

" Toggle spellcheck
map <leader>s :set spell!<cr>

" retain selection after increasing/decreasing indent
vmap > >gv
vmap < <gv

" copy/paste using system clipboard
" thanks, bill!
map <leader>v "+gP
map <leader>c "+y

" Opens an edit command with the path of the currently edited file filled in
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

"----------------------------------------------------------------------------
" Misc Settings
"----------------------------------------------------------------------------

" Highlight search results. Turn off when hitting enter
set hlsearch
nmap <cr> :nohlsearch<cr>

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" turn off error beep/flash
set vb t_vb=

" never make a backup file ever
set nobackup      
set noswapfile    
set nowritebackup 

" smoother changes
set ttyfast

" configure wildmenu
set wildmode=list:longest,list:full
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.ds_store,*.db,.git,*.rbc,*.class,.svn

" Make searches case-sensitive only if they contain upper-case characters
set ignorecase
set smartcase

" Restore cursor position
if has("autocmd")
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Strip trailing whitespace on save
  autocmd FileType python,ruby autocmd BufWritePre <buffer> :%s/\s\+$//e
endif

" Make splits always the same size
set equalalways

" Include user/machine-specific vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

"-----------------------------------------------------------------------------
" Gui Settings
"-----------------------------------------------------------------------------
if has("gui_running")

    " use a big font and hide the toolbar
    set guifont=Monaco:h14
    set guioptions-=T

endif

