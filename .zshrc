export EDITOR="vim"

### options
setopt CORRECT          #自动更正错误
setopt EXTENDEDGLOB     #扩展通配符
setopt NOCASEGLOB       #通配符不区分大小写
### options end

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

### keybindings from manjaro-gnome
bindkey -e
bindkey '^[[7~' beginning-of-line                               # Home key
bindkey '^[[H' beginning-of-line                                # Home key
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line                # [Home] - Go to beginning of line
fi
bindkey '^[[8~' end-of-line                                     # End key
bindkey '^[[F' end-of-line                                      # End key
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line                       # [End] - Go to end of line
fi
bindkey '^[[2~' overwrite-mode                                  # Insert key
bindkey '^[[3~' delete-char                                     # Delete key
bindkey '^[[C'  forward-char                                    # Right key
bindkey '^[[D'  backward-char                                   # Left key
bindkey '^[[5~' history-beginning-search-backward               # Page up key
bindkey '^[[6~' history-beginning-search-forward                # Page down key

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word
bindkey '^[Od' backward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                                             # Shift+tab undo last action
### keybindings end

### completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
#zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

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

### alias
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# cd
alias ..='cd ..'

# ls
alias ls='ls -F --color'
alias ll='ls -lh'
alias la='ll -A'

# other
alias grep='grep --color=auto'
alias proxy='export http_proxy=http://127.0.0.1:8889;export https_proxy=http://127.0.0.1:8889'
alias proxyoff='unset http_proxy;unset https_proxy'
### alias end
