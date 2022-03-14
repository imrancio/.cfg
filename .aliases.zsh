# configs
alias bashrc='$EDITOR ~/.bashrc'
alias bashreset='source ~/.bashrc'
alias zshrc='$EDITOR ~/.zshrc'
alias zshreset='source ~/.zshrc'
alias aliasrc='$EDITOR ~/.aliases.zsh'
alias funcrc='$EDITOR ~/.functions.zsh'
alias powerlevel10k='p10k'
alias devenv='deactivate'

# git
alias g='git'
alias gi='git-ignore'
alias gcam='git commit -a -m'
alias gst='git status'
alias gl='git pull'
alias gp='git push'

# linux helpers and shorteners
alias t='tail -f'
alias open='xdg-open'
alias h='history'
alias mkdirp='mkdir -p'    # make parent dirs as well (no errors)
alias rmrf='rm -rf'        # recursive remove (directories)
alias ls='ls --color=auto' # colorise ls output
alias ll='ls -lh'
alias la='ls -lah'
alias py='python'
alias quit='exit'
alias q='exit'
alias hd='hexdump'
alias ..='cd .. 2>/dev/null || cd "$(dirname $PWD)"' # Allows leaving from deleted directories

# network helpers
alias ping4='ping -4'
alias ping6='ping -6'
alias ssh4='ssh -4'
alias ssh6='ssh -6'

# dotfile management (see: https://www.atlassian.com/git/tutorials/dotfiles)
alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
