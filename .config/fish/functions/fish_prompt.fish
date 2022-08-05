function fish_prompt --description 'Write out the prompt'
    set -l last_status $status
    echo
    echo -n '|'
    set_color normal

    echo_vim_mode
    echo -n '|'
    set_color normal

    set_color '#aed3ae'
    echo -n (date +%H:%M:%S'')

    echo -n '|'
    set_color normal

    # PWD
    set_color --bold '#c0b2de'
    echo -n (pwd -L)
    set_color '#cfa488'
    __terlar_git_prompt
    __fish_hg_prompt
    echo

    if not test $last_status -eq 0
        set_color $fish_color_error
    end

    if set -q SSH_TTY
        echo -n "$hostname "
    end
    echo -n 'λ '
    set_color normal
end

function fish_mode_prompt
  # NOOP - Disable vim mode indicator
end

function echo_vim_mode
    switch $fish_bind_mode
    case default
      set_color --bold '#D3C899'
      echo -n 'N'
    case insert
      set_color --bold '#70AEB1'
      echo -n 'I'
    case replace_one
      set_color --bold green
      echo -n 'R'
    case visual
      set_color --bold brmagenta
      echo -n 'V'
    case '*'
      set_color --bold red
      echo '?'
  end
  set_color normal
end
