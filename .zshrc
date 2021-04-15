export EDITOR="vim"

### history
HISTFILE=~/.zsh_history
HISTSIZE=512
SAVEHIST=512
setopt SHARE_HISTORY
setopt APPEND_HISTORY
#setopt INC_APPEND_HISTORY

setopt HIST_IGNORE_DUPS
#setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
### history end

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

limit coredumpsize 0

#bindkey -v

### completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

autoload -Uz compinit
compinit
### completion

### sudo
sudo-command-line() {
[[ -z $BUFFER ]] && zle up-history
[[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
zle end-of-line
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line
### sudo end

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### alias
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# cd
alias ..='cd ..'

# ls
alias ls='ls -F --color'
alias ll='ls -l'
alias la='ls -lA'

# git
alias gl='git pull'
alias gp='git push'
alias gd='git diff'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status'

# other
alias grep='grep --color=auto'
alias docker='sudo docker'
### alias end
