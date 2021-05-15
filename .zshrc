# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Elixir IEX
export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=$(brew --prefix openssl)"
export ERL_AFLAGS="-kernel shell_history enabled"

if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

export HOMEBREW_EDITOR=nvim
export EDITOR=nvim

ZSH_THEME="robbyrussell"

# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
plugins=(git)

source $ZSH/oh-my-zsh.sh

# brew install z
. /usr/local/etc/profile.d/z.sh

# ASDF
. /usr/local/opt/asdf/asdf.sh
. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="/usr/local/sbin:$PATH"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# Custom Alias
alias ls="ls -la"
alias gpo="git push origin"
alias gph="git push heroku"
# https://blog.carbonfive.com/2017/08/28/always-squash-and-rebase-your-git-commits/
alias gl="git log --graph --decorate --pretty=oneline --abbrev-commit"
alias gbr="git branch | grep -v "master" | xargs git branch -D"
alias phx="iex -S mix phx.server"
alias xx="iex -S mix"
alias phx.install="mix archive.install hex phx_new"
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias lsplog="tail -f /Users/mac/.cache/nvim/lsp.log"
alias vimconfig="vim ~/.config/nvim/init.vim"
