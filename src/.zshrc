# An initial zshrc...

###
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

alias vim=nvim
export EDITOR=nvim
export TERMINAL=alacritty
###

### (for python) basic conda like global envs with only venv...
func lsenvs()
{
    ls ~/pyenvs/
}

func mkenv()
{
    python -m venv ~/pyenvs/$1
}

func acenv()
{
    source ~/pyenvs/$1/bin/activate
}
###
