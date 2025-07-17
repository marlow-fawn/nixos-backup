#!/usr/bin/env bash

_powerctl_completions() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD - 1]}"

  local commands="enable disable"
  local groups="bluetooth printing ssh tailscale fail2ban all"

  if [[ $COMP_CWORD == 1 ]]; then
    COMPREPLY=($(compgen -W "$commands" -- "$cur"))
  elif [[ $COMP_CWORD == 2 ]]; then
    COMPREPLY=($(compgen -W "$groups" -- "$cur"))
  fi
}

complete -F _powerctl_completions powerctl
