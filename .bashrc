#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Execute fastfetch at startup
if command -v fastfetch >/dev/null; then
    fastfetch --logo-type kitty
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '


eval "$(starship init bash)"

export PATH=$PATH:/home/nightwing/.spicetify
