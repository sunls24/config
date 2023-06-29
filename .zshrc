export EDITOR="vim"

### options
setopt EXTENDEDGLOB     #扩展通配符
setopt NOCASEGLOB       #通配符不区分大小写
### options end

### history
HISTFILE=~/.zsh_history
HISTSIZE=1024
SAVEHIST=1024
setopt SHARE_HISTORY
setopt APPEND_HISTORY

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
### history end

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

limit coredumpsize 0

### completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

autoload -Uz compinit
compinit
### completion end

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

bindkey -e

### alias
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ..='cd ..'

# ls
alias ls='ls -F --color'
alias ll='ls -lh'
alias la='ll -A'

# tmux
alias ta='tmux new -Asmain'
alias tc='tmux -CC new -Asmain'
alias td='tmux detach'

# other
alias grep='grep --color=auto'
alias dc='docker-compose'
### alias end
