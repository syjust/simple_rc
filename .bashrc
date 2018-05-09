[ -e ~/.colors ] && source ~/.colors
export LS_OPTIONS='--color=auto'
alias ls="ls $LS_OPTIONS"
alias ll="ls $LS_OPTIONS -l"
alias l="ls $LS_OPTIONS -lA"
alias grep="grep --color=auto"
alias cgrep="grep --color=always"
export HISTTIMEFORMAT="%F %T "
export EDITOR=vim
