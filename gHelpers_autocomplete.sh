#to be save in /etc/bash_completion.d/

_git__listbranches() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    # opts => list of possible options to display (space separated; no newline)
    opts=`git branch | sed 's/*//' | sed 's/^\s\+/ /' | sed ':a;N;$!ba;s/\n/ /g'`

    COMPREPLY=( $(compgen -W "${opts}" ${cur}) )
    return 0
}
complete -F _git__listbranches g_ck
