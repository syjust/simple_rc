" line numbers
se number
" column number
se ruler
" color for dark backgrounds
se background=dark
" txt colorization
syntax on
" undo history by file
se undofile
" undo history storage
se undodir=~/.vim/undo
" line jump indentation
se autoindent
" tab as space
se expandtab
" filname in status line
"se statusline=2
" command mode & search mode history
se history=1000
" tab indentation space
se tabstop=4
se shiftwidth=4
se softtabstop=4
" fold sections between {{{,}}}
set foldmethod=marker
" ^P encapsulate bash function with fold markers & export funcname
map  ^ywO# {{{ function po#j$%opIexport -f o# }}}%zc
