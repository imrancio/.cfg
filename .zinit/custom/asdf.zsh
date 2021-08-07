# hook asdf into zsh
source /opt/asdf-vm/asdf.sh

# Hook asdf-direnv into your shell.
eval "$(direnv hook zsh)"

# A shortcut for asdf managed direnv.
direnv() { asdf exec direnv "$@"; }
