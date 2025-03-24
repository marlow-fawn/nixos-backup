alias config="vim /home/marlow/.config/nixos/configuration.nix"
alias rebuild="sudo nixos-rebuild switch -I nixos-config=/home/marlow/.config/nixos/configuration.nix"
alias dotfiles='$(which git) --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias open='xdg-open'
alias ignore='echo "$1" >> .gitignore && echo "Added $1 to .gitignore"'

