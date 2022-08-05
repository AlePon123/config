if status is-interactive
    # Commands to run in interactive sessions can go here
end
if type -q exa
    alias ls "exa -l -g --icons"
    alias la "ll -a"
end

alias cfg "cd ~/.config"
alias nixcfg "sudo nvim /etc/nixos/configuration.nix"
alias nixrb "sudo nixos-rebuild switch"

fish_vi_key_bindings
