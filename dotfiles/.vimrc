filetype off 
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
filetype indent plugin on
syntax on
colorscheme underwater-mod
source $HOME/.vim/abbreviations
set sm
set ai
set ts=2
set sw=2
set expandtab
" run on command line for tags setup : 
" ctags -f ~/.tags -R workspace/.../src $JAVA_HOME/src
"
set tags=~/.tags
set complete=.,w,b,u,t,i

" Java stuff.
let java_highlight_all=1
let java_highlight_functions="style"
let java_allow_cpp_keywords=1

"completion
let g:rubycomplete_rails = 1

"columns after 80
"highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%81v.\+/

"templates
function! LoadTemplate()
  silent! 0r ~/.vim/skel/tmpl.%:e
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

