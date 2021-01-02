
# Default configurations extracted from default ~/.bashrc (/etc/skel/.bashrc)

# Check the window size after each command and, if necessary, update the values
# of LINES and COLUMNS.
shopt -s checkwinsize

# Append to the history file, don't overwrite it
shopt -s histappend

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

HISTSIZE=1000
HISTFILESIZE=2000


# Custom configuration

[ -r /etc/bash_completion ] && source /etc/bash_completion
[ -r ~/.git-completion ] && source ~/.git-completion
[ -r ~/.git-prompt ] && source ~/.git-prompt

__has_parent_dir () {

    test -d "$1" && return 0;

    current="."
    while [ ! "$current" -ef "$current/.." ]; do
        if [ -d "$current/$1" ]; then
            return 0;
        fi
        current="$current/..";
    done

    return 1;
}

__vcs_name() {
    if [ -d .svn ]; then
        echo ' (svn)';
    elif __has_parent_dir '.git'; then
        echo " ($(__git_ps1 'git %s'))";
    elif __has_parent_dir ".hg"; then
        echo " (hg $(hg branch))"
    fi
}

black=$(tput -Txterm setaf 0)
red=$(tput -Txterm setaf 1)
green=$(tput -Txterm setaf 2)
yellow=$(tput -Txterm setaf 3)
blue=$(tput -Txterm setaf 4)
pink=$(tput -Txterm setaf 5)
cyan=$(tput -Txterm setaf 6)

bold=$(tput -Txterm bold)
reset=$(tput -Txterm sgr0)

# Same prompt format/colors as Git Bash
export PS1='\n\[$bold\]\[$blue\]\@ \[$green\]\u@\h \[$yellow\]\w\[$cyan\]$(__vcs_name)\n\[$reset\]\$ '

alias cp='cp -i'
alias grep='grep -in'
alias ls='ls -AFhl --color'
alias mv='mv -i'
alias rm='rm -i'
