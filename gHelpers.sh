#to be implemented in .bashrc

alias g_st='clear && git status'
alias g_ck='git checkout'
alias g_pl='git pull'
alias g_pop='git stash pop'
alias g_l='git log -1'
alias g_ll='git log -2'
alias g_mend='git commit --amend'
# pretty print (one-line) n last commits
alias gg_l='git log --pretty=oneline --abbrev-commit -n $1'

# TODO:
#    - implement a man (WIP)
#    - implement '-l | --list' option to list files before chosing (WIP)
#    - factorize methods ? (add & diff are almost the same)
g_add() {
  if [[ $1 = '-l' || $1 = '--list' ]]; then
    gg_shortstatus
    read -r -p "n ? " n
    local filename=`gg_getnthname $n`
  elif [[ $1 = '-h' || $1 = '--help' ]]; then
    echo 'TODO man single command'
    return
  else
    local filename=`gg_getnthname $1`
  fi

  if [[ ! -z "$filename" ]]; then
    git add $filename
    echo "added file: $filename"
  else
    gg_showsoftstatus
  fi
}

# TODO IDEM
g_diff() {
  if [[ $1 = '-l' || $1 = '--list' ]]; then
    gg_shortstatus
    read -r -p "n ? " n
    local filename=`gg_getnthname $n`
  elif [[ $1 = '-h' || $1 = '--help' ]]; then
    echo 'TODO man single command'
    return
  else
    local filename=`gg_getnthname $1`
  fi

  if [[ ! -z "$filename" ]]; then
    git diff $filename
    echo "added file: $filename"
  else
    gg_showsoftstatus
  fi
}

# TODO IDEM
g_reset() {
  local filename=`git status --porcelain | sed '/^ M\|??/d' | sed -n $1p | sed 's/M. //i'`
  if [[ ! -z "$filename" ]]; then
    git reset $filename
  else
    git__showsoftstatus
  fi
}


# Internal helpers
git__porcelain() {
  git status --porcelain
}

git__getnthname() {
  git status --porcelain | sed '/^M \|??/d' | sed -n $1p | sed 's/^.\{2\} //i'
}

git__showsoftstatus() {
  echo "no file found at index $1"
  read -r -p "Show status ? [y/n] " response
  case "$response" in ([yY][eE][sS]|[yY])
    echo ''
    echo -e "\033[0;31m$(git status --porcelain | sed '/^M /d')\033[0m"
    echo ''
    ;;
  *)
    ;;
  esac
}

git__letters() {
  echo -e '  X          Y     Meaning
-------------------------------------------------
            [MD]   not updated
  M        [ MD]   updated in index
  A        [ MD]   added to index
  D        [ MD]   deleted from index
  R        [ MD]   renamed in index
  C        [ MD]   copied in index
  [MARC]           index and work tree matches
  [ MARC]     M    work tree changed since index
  [ MARC]     D    deleted in work tree
  -------------------------------------------------
  D           D    unmerged, both deleted
  A           U    unmerged, added by us
  U           D    unmerged, deleted by them
  U           A    unmerged, added by them
  D           U    unmerged, deleted by us
  A           A    unmerged, both added
  U           U    unmerged, both modified
  -------------------------------------------------
  ?           ?    untracked
  -------------------------------------------------'
}

# missing stuff, needs update
g_man() {
  echo -e '
> g_ck
    equivalent to "git checkout" - supports -b and "-" parameter. provides auto-completion

> g_add <n>
    adds the nth file to the index, or all if not specified
	(n respects "git status" order; ignoring indexed and untracked files)

> g_diff <n>
    show diff of nth file, or all if not specified
	(n respects "git status" order; ignoring indexed files)

> g_res <n>
    reset nth file, or all if not specified
	(n respects "git status" order)

> gg_shortstatus
    display short version of git status

> gg_getnthname <n>
    diplay name of nth file
	(n respects "git status" order)

> gg_letters
    display help for short status letters
'
}
