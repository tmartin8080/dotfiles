# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/mac/.oh-my-zsh"

# Elixir IEX
export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=$(brew --prefix openssl)"
export ERL_AFLAGS="-kernel shell_history enabled"

# Alias
alias ls="ls -la"
alias gpo="git push origin"
alias gph="git push heroku"
alias ga="git add ."
alias gs="git status"
alias gd="git diff"
alias gc="git commit -am"
alias cpd="cap production deploy"
alias gb="git branch"
alias gco="git checkout"
# https://blog.carbonfive.com/2017/08/28/always-squash-and-rebase-your-git-commits/
alias gl="git log --graph --decorate --pretty=oneline --abbrev-commit"
alias gbr="git branch | grep -v "master" | xargs git branch -D"
alias phx="iex -S mix phx.server"
alias xx="iex -S mix"
alias phx.install="mix archive.install hex phx_new"
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"

if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

export HOMEBREW_EDITOR=nvim

ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh
