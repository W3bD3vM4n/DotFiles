# My Zsh configuration

# History in cache directory
HISTSIZE=300
SAVEHIST=300
HISTFILE=~/.zsh_history
setopt nomatch notify

#
# # Turn off error sound
# Turn off error sound
unsetopt autocd beep extendedglob

# Git prompt
# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }
# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats ' ((%b))'
# Set up the prompt (with git branch name)
setopt PROMPT_SUBST

# Color prompt display 
LS_COLORS='ow=01;95:di=01;95'
export LS_COLORS

# Custom prompt
PROMPT='%B%F{202}[%n >%1~]%f%b%F{011}${vcs_info_msg_0_}%f %F{209}%#%f '

# Basic auto/tab complete
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # include hidden files

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Load aliases
if [ -f ~/.zsh_alias ]; then
    source ~/.zsh_alias
else
    print "404: ~/.zsh_alias not found."
fi
