#########################
#       Aliases         #
#########################

# configs
alias bashrc='$EDITOR ~/.bashrc'
alias bashreset='source ~/.bashrc'
alias zshrc='$EDITOR ~/.zshrc'
alias zshreset='source ~/.zshrc'
alias aliasrc='$EDITOR ${ZINIT[CUSTOM_DIR]}/aliases.zsh'
alias funcrc='$EDITOR ${ZINIT[CUSTOM_DIR]}/functions.zsh'
alias conkyrc='$EDITOR ~/.conky/Conky-Skeleton/conkyrc.lua'
alias xfkeyboardrc='$EDITOR "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml"'
alias powerlevel10k='p10k'

# git
alias g='git'
alias gi='git-ignore'
alias gcam='git commit -a -m'
alias gst='git status'
alias gl='git pull'
alias gp='git push'

# helpers and shorteners
alias t='tail -f'
alias open='xdg-open'
alias h='history'
alias mkdirp='mkdir -p' # make parent dirs as well (no errors)
alias rmrf='rm -rf' # recursive remove (directories)
alias ll='ls -lh'
alias la='ls -lah'
alias py='python'
alias quit='exit'
alias q='exit'
alias hd='hexdump'
alias ..='cd .. 2>/dev/null || cd "$(dirname $PWD)"' # Allows leaving from deleted directories

alias ping4='ping -4'
alias ping6='ping -6'
alias ssh4='ssh -4'
alias ssh6='ssh -6'

# aircrack
alias airmon='sudo airmon-ng'
alias aircrack='sudo aircrack-ng'
alias airodump='sudo airodump-ng'
alias aireplay='sudo aireplay-ng'

# personal pereferences
alias yaourt='yay' # deprecated - use yay instead (same flags)
alias yay='yay -a' # yay only for AUR, pacman for everything else
alias fetch='neofetch'
alias devenv='deactivate'
alias tree='lsd --tree'
alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
