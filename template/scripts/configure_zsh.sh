#!/bin/sh

#
#  zsh configration
#

# Configure debugging
set -eux
set -o pipefail
command -v bc || dnf install -yq bc
command -v tput || dnf install -yq ncurses
PS4='$(tput setaf 4)$(printf "%-12s\\t%.3fs\\t@line\\t%-10s" $(date +%T) $(echo $(date "+%s.%3N")-'$(date "+%s.%3N")' | bc ) $LINENO)$(tput sgr 0)'

ZSH_CUSTOM_DIR=/etc/zsh

if ! rpm -q zsh >/dev/null; then
  dnf install -yq zsh
fi
if ! rpm -q git >/dev/null; then
  dnf install -yq git
fi
if ! rpm -q util-linux-user >/dev/null; then
  dnf install -yq util-linux-user
fi


mkdir -p $ZSH_CUSTOM_DIR
git clone https://github.com/sindresorhus/pure.git "$ZSH_CUSTOM_DIR/pure"

cat >> /etc/zshrc <<'EOF'
unsetopt BEEP

setopt autocd
setopt autopushd

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# CTRL+UP, CTRL+DOWN search history forwards and backwards respectively
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# CTRL+j, CTRL+k search history forwards and backwards respectively
bindkey "^k" history-beginning-search-backward-end
bindkey "^j" history-beginning-search-forward-end

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

autoload -U +X bashcompinit && bashcompinit
source /etc/bash_completion.d
source /usr/share/bash-completion/completions

# configure history retention
HISTSIZE=10000              # How many lines of history to keep in memory
SAVEHIST=10000              # Number of history entries to save to disk
HISTFILE=~/.zsh_history      # Where to save history to disk
setopt appendhistory        # Append history to the history file (no overwriting)
setopt sharehistory         # Share history across terminals, e.g. when using tmux
setopt incappendhistory     # Immediately append to the history file, not just when a term is killed

alias ll='ls -lh -F --group-directories-first --color=auto'
alias ls='ls -F --color=auto'
alias l='ls -F --color=auto'
alias vi='vim'

alias -g G='| grep -i'
alias -g H='| grep -zi'
alias -g L='| less'

alias d='dirs -v | head -10'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

# Edit line in vim with ctrl-v:
autoload edit-command-line; zle -N edit-command-line
bindkey '^[v' edit-command-line

fpath+=(/etc/zsh /etc/zsh/pure)

export LANG=en_US.UTF-8
autoload -U promptinit; promptinit
prompt pure
EOF

command -v chsh &>/dev/null || dnf install -y util-linux-user
chsh -s /usr/bin/zsh
echo '# ~/.zshrc' > /root/.zshrc
echo '# ~/.zshrc' > /etc/skel/.zshrc

echo "Succesfully installed / configured zsh!"
echo "Successfully configured zsh!"
