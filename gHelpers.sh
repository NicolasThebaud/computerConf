#to be implemented in .bashrc

alias g_st='clear && git status'
alias g_ck='git checkout'
alias g_pl='git pull'

# TODO:
#    - implement a man
#    - implement '-l | --list' option to list files before chosing 
g_add() {
  local filename=`git__getnthname $1`
  if [[ ! -z "$filename" ]]; then
    git add $filename
    echo "added file: $filename"
  else
    git__showsoftstatus
  fi
}

# TODO IDEM
g_diff() {
  local filename=`git__getnthname $1`
  if [[ ! -z "$filename" ]]; then
    git diff $filename
  else
    git__showsoftstatus
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
