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
