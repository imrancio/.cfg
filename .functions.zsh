# Networking
abyss_vpn() {
  if [ $# -eq 1 ]; then
    sudo wg-quick $1 abyss
  else
    echo "usage: abyss_vpn <up/down>"
  fi
}

# kill process in port
portkill() {
  if [ $# -eq 1 ]; then
    fuser -k $1/tcp
  fi
}

venv() {
  if [ $# -eq 1 ]; then
    source ~/venvs/$1/bin/activate
  fi
}

# interactive rebase all commits in feature branch from target branch
rebase() {
  if [ $# -eq 1 ]; then
    git rebase -i $(git merge-base ${1:-master} HEAD)
  else
    echo "Usage: rebase <target branch>"
  fi
}

# decode bas64
b64decode() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: b64decode <base64 encoded text>"
  else
    echo "$1" | base64 --decode
  fi
}

# encode base64
b64encode() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: b64encode <plain text>"
  else
    echo "$1" | base64 --encode
  fi
}

# run git command on all subdirectories (depth 1)
git-all(){
  if command -v fd &> /dev/null; then
    fd -td -d1 -x git --git-dir={}/.git --work-tree=$PWD/{} "$@"
  else
    find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$PWD/{} "$@" \;
  fi
}

# pull all git subdirectories (depth 1)
git-pull-all() {
  git-all pull
}
