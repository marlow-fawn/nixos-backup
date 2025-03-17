alias config="vim .config/nixos/configuration.nix"
alias rebuild="sudo nixos-rebuild switch -I nixos-config=.config/nixos/configuration.nix"
alias dotfiles='$(which git) --git-dir=$HOME/.cfg/ --work-tree=$HOME'

