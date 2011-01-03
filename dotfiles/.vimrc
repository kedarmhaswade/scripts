set nocompatible
filetype off 
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
syntax on 
filetype plugin indent on
set expandtab
set ignorecase
set infercase
set nowrap
set smartcase
set shiftwidth=2
set softtabstop=2
set smarttab
set tabstop=4
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set number " show line numbers
" ruby standard 2 spaces, always
au BufRead,BufNewFile *.rb,*.rhtml set shiftwidth=2 
au BufRead,BufNewFile *.rb,*.rhtml set softtabstop=2 
"" encodings configure
:set fileencoding=utf-8
:set encoding=utf-8
""setting about indent
:set autoindent
:set smartindent
" set foldenable
" set foldmethod=indent
" To save, ctrl-s.
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>a
let java_highlight_all=1
let java_highlight_functions="style"
let java_allow_cpp_keywords=1
"set tags=~/.javatags
set complete=.,w,b,u,t,i
"set foldmethod=indent
set autowriteall "useful when moving between files
colorscheme vividchalk
"ruby
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold
"ragtag
let g:ragtag_global_maps = 1
"templates related
function! LoadTemplate()
  silent! 0r ~/.vim/skel/template.%:e
  " Highlight %VAR% placeholders with the Todo colour group
  syn match Todo "%\u\+%" containedIn=ALL
endfunction
autocmd! BufNewFile * call LoadTemplate()
"Jump between %VAR% placeholders in Normal mode with
" <Ctrl-p>
nnoremap <c-p> /%\u.\{-1,}%<cr>c/%/e<cr>
"Jump between %VAR% placeholders in Insert mode with
" <Ctrl-p>
inoremap <c-p> <ESC>/%\u.\{-1,}%<cr>c/%/e<cr>
"source abbreviations
source ${HOME}/.vim/abbreviations
"make scripts executable by default
"au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent !chmod a+x <afile> | endif | endif

