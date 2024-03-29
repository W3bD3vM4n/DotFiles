# Simple Bash prompt with Git status
# https://github.com/romkatv/gitstatus#using-from-bash

# Source gitstatus.plugin.sh from $GITSTATUS_DIR or from the same directory
# in which the current script resides if the variable isn't set
if [[ -n "${GITSTATUS_DIR:-}" ]]; then
  source "$GITSTATUS_DIR"                           || return
elif [[ "${BASH_SOURCE[0]}" == */* ]]; then
  source "${BASH_SOURCE[0]%/*}/gitstatus.plugin.sh" || return
else
  source gitstatus.plugin.sh                        || return
fi

# Sets GITSTATUS_PROMPT to reflect the state of the current git repository
function gitstatus_prompt_update() {
  GITSTATUS_PROMPT=""

  gitstatus_query "$@"                  || return 1  # error
  [[ "$VCS_STATUS_RESULT" == ok-sync ]] || return 0  # not a git repo

  local      reset=$'\001\e[0m\002'         # no color
  local      clean=$'\001\e[38;5;076m\002'  # green foreground
  local  untracked=$'\001\e[38;5;014m\002'  # teal foreground
  local   modified=$'\001\e[38;5;011m\002'  # yellow foreground
  local conflicted=$'\001\e[38;5;196m\002'  # red foreground

  local p

  local where  # branch name, tag or commit
  if [[ -n "$VCS_STATUS_LOCAL_BRANCH" ]]; then
    where="$VCS_STATUS_LOCAL_BRANCH"
  elif [[ -n "$VCS_STATUS_TAG" ]]; then
    p+="${reset}#"
    where="$VCS_STATUS_TAG"
  else
    p+="${reset}@"
    where="${VCS_STATUS_COMMIT:0:8}"
  fi

  (( ${#where} > 32 )) && where="${where:0:12}…${where: -12}"  # truncate long branch names and tags
  p+="${clean}${where}"

  # current branch:
  # '▼' behind the remote
  (( VCS_STATUS_COMMITS_BEHIND )) && p+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
  # '▲' ahead of the remote; if behind the remote '▼▲'
  (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && p+=" "
  (( VCS_STATUS_COMMITS_AHEAD  )) && p+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
  # '◄' behind the push remote
  (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
  (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" "
  # '►' ahead of the push remote; if behind the remote '◄ ►'
  (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && p+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
  # '*' have stashes
  (( VCS_STATUS_STASHES        )) && p+=" ${clean}*${VCS_STATUS_STASHES}"
  
  # merge in progress:
  # 'merge' repo in unusual state
  [[ -n "$VCS_STATUS_ACTION"   ]] && p+=" ${conflicted}${VCS_STATUS_ACTION}"
  # '~' merge conflicts
  (( VCS_STATUS_NUM_CONFLICTED )) && p+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
  # '+' staged changes
  (( VCS_STATUS_NUM_STAGED     )) && p+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
  # '!' unstaged changes
  (( VCS_STATUS_NUM_UNSTAGED   )) && p+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
  # '?' untracked files
  (( VCS_STATUS_NUM_UNTRACKED  )) && p+=" ${untracked}?${VCS_STATUS_NUM_UNTRACKED}"

  GITSTATUS_PROMPT="${p}${reset}"
}

# Start gitstatusd in the background
gitstatus_stop && gitstatus_start -s -1 -u -1 -c -1 -d -1

# On every prompt, fetch git status and set GITSTATUS_PROMPT
PROMPT_COMMAND=gitstatus_prompt_update
PROMPT_DIRTRIM=3

# Enable promptvars so that ${GITSTATUS_PROMPT} in PS1 is expanded
shopt -s promptvars

# Sections of the custome prompt:
# green user@host
PS1='\[\033[01;32m\][\u >\[\033[00m\]'
# blue current working directory
PS1+='\[\033[01;34m\]\W\[\033[00m\]'
# git status (requires promptvars option)
PS1+='${GITSTATUS_PROMPT:+ \[\033[01;32m\](\[\033[00m\]$GITSTATUS_PROMPT\[\033[01;32m\])}\[\033[01;32m\]]\[\033[00m\]'
# green/red (success/error) $/# (normal/root)
PS1+=' \[\033[01;$((31+!$?))m\]\$\[\033[00m\] '
# terminal title: user@host: dir
PS1+='\[\e]0;\u@\h: \W\a\]'