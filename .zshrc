# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# Load custom config files
ZINIT[CUSTOM_DIR]="${ZINIT[HOME_DIR]}/custom"

if [[ ! -d ${ZINIT[SNIPPETS_DIR]}/config && -d ${ZINIT[CUSTOM_DIR]}/config ]]; then
    mkdir -p ${ZINIT[SNIPPETS_DIR]}
    cp -r ${ZINIT[CUSTOM_DIR]}/* ${ZINIT[SNIPPETS_DIR]/}
fi

[[ ! -f ${ZINIT[SNIPPETS_DIR]}/config/config.plugin.zsh ]] || source ${ZINIT[SNIPPETS_DIR]}/config/config.plugin.zsh


###########
# Annexes #
###########

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-submods \
    NICHOLAS85/z-a-linkman \
    NICHOLAS85/z-a-linkbin

# A binary Zsh module which transparently and automatically compiles sourced scripts
module_path+=( "${HOME}/.zinit/bin/zmodules/Src" )
zmodload zdharma/zinit &>/dev/null

# Functions to make configuration less verbose
# zt() : First argument is a wait time and suffix, ie "0a". Anything that doesn't match will be passed as if it were an ice mod. Default ices depth'3' and lucid
zt(){ zinit depth'3' lucid ${1/#[0-9][a-c]/wait"${1}"} "${@:2}"; }

#########
# THEME #
#########

# p10k theme - configure with 'p10k' command
zinit depth'1' light-mode for \
    romkatv/powerlevel10k

###########
# Plugins #
###########

######################
# Trigger-load block #
######################

zt light-mode for \
    trigger-load'!x' svn \
        OMZ::plugins/extract \
    trigger-load'!man' \
        ael-code/zsh-colored-man-pages \
    trigger-load'!ga;!grh;!glo;!gd;!gcf;!gclean;!gss;!gcp' \
        wfxr/forgit \
    trigger-load'!gcomp' blockf \
    atclone'command rm -rf lib/*;git ls-files -z lib/ |xargs -0 git update-index --skip-worktree' \
    submods'RobSis/zsh-completion-generator -> lib/zsh-completion-generator; nevesnunes/sh-manpage-completions -> lib/sh-manpage-completions' \
    atload' gcomp(){gencomp "${@}" && zinit creinstall -q ${ZINIT[SNIPPETS_DIR]}/config 1>/dev/null}' \
         Aloxaf/gencomp

##################
# Wait'0a' block #
##################

zt 0a light-mode for \
        OMZP::systemd/systemd.plugin.zsh \
        OMZP::sudo/sudo.plugin.zsh \
    atload'zstyle ":completion:*" special-dirs false' \
        OMZL::completion.zsh \
    as'completion' atpull'zinit cclear' blockf \
        zsh-users/zsh-completions \
    as'completion' nocompile mv'*.zsh -> _git' patch"${pchf}/%PLUGIN%.patch" reset \
        felipec/git-completion \
    blockf compile'lib/*f*~*.zwc' \
        Aloxaf/fzf-tab \
    blockf atclone'lua ./z.lua --init zsh enhanced once fzf 1>/dev/null' \
    atpull'%atclone' atload'zstyle ":fzf-tab:complete:_zlua:*" query-string input' \
        skywind3000/z.lua \
    ver'develop' atload'_zsh_autosuggest_start' \
        zsh-users/zsh-autosuggestions

##################
# Wait'0b' block #
##################

zt 0b light-mode patch"${pchf}/%PLUGIN%.patch" reset nocompile'!' for \
    atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(autopair-insert)' \
        hlissner/zsh-autopair \
    pack'no-dir-color-swap' atload"zstyle ':completion:*' list-colors \${(s.:.)LS_COLORS}" \
        trapd00r/LS_COLORS \
    atload'add-zsh-hook chpwd @chwpd_dir-history-var;
    add-zsh-hook zshaddhistory @append_dir-history-var; @chwpd_dir-history-var' \
    src'per-directory-history.zsh' \
        kadaan/per-directory-history \
    compile'h*' \
        zdharma/history-search-multi-word \
    trackbinds bindmap'\e[1\;6D -> ^[[1\;5B; \e[1\;6C -> ^[[1\;5A' \
        michaelxmcbride/zsh-dircycle \
    blockf nocompletions compile'functions/*~*.zwc' \
        marlonrichert/zsh-edit

zt 0b light-mode for \
    autoload'#manydots-magic' \
        knu/zsh-manydots-magic \
        RobSis/zsh-reentry-hook \
    atinit'zicompinit_fast; zicdreplay' atload'FAST_HIGHLIGHT[chroma-man]=' \
    atclone'(){local f;cd -q →*;for f (*~*.zwc){zcompile -Uz -- ${f}};}' \
    compile'.*fast*~*.zwc' nocompletions atpull'%atclone' \
        zdharma/fast-syntax-highlighting \
    atload'bindkey "^[[A" history-substring-search-up; bindkey "^[[B" history-substring-search-down' \
        zsh-users/zsh-history-substring-search

##################
# Wait'0c' block #
##################
zt 0c light-mode binary from'gh-r' lman lbin for \
    bpick'*linux64*' \
        zyedidia/micro \
    lbin'%PLUGIN%*/%PLUGIN%' atclone'mv -f **/*.zsh _bat' atpull'%atclone' \
        @sharkdp/bat \
        @sharkdp/hyperfine \
        @sharkdp/fd
zt 0c light-mode binary for \
    lbin'bin/*' \
        laggardkernel/git-ignore \
    lbin'*/lsd' from'gh-r' atclone'wget -q https://raw.githubusercontent.com/Peltoche/lsd/master/doc/lsd.md -O lsd.1.ronn; ronn lsd.1.ronn' atpull'%atclone' lman \
        Peltoche/lsd \
    lbin'nnn* -> nnn' from'gh-r' bpick'*nerd*' atclone'wget -q https://raw.githubusercontent.com/jarun/nnn/master/nnn.1' atpull'%atclone' lman  \
        jarun/nnn
zt 0c light-mode null for \
    lbin'*d.sh;*n.sh' \
        bkw777/notify-send.sh \
    lbin'antidot* -> antidot' from'gh-r' atclone'./**/antidot* update 1>/dev/null' atpull'%atclone' \
        doron-cohen/antidot \
    lbin'git-open' \
        paulirish/git-open \
    lbin'*/delta' from'gh-r' patch"${pchf}/%PLUGIN%.patch" \
        dandavison/delta \
    lbin'rm-trash/rm-trash' lman patch"${pchf}/%PLUGIN%.patch" atload'alias rm=rm-trash' reset \
        nateshmbhat/rm-trash \
    lbin'fzf' from'gh-r' atclone'wget -q https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf.1' atpull'%atclone' lman \
        junegunn/fzf \
    id-as'Cleanup' nocd atinit'unset -f zt; _zsh_autosuggest_bind_widgets' \
        zdharma/null

[[ ! -d ${ZINIT[CUSTOM_DIR]} ]] || for f in ${ZINIT[CUSTOM_DIR]}/*.zsh; do source "$f"; done

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
