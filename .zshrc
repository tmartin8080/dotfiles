# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Elixir IEX
export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=$(brew --prefix openssl)"
export ERL_AFLAGS="-kernel shell_history enabled"

export HOMEBREW_EDITOR=nvim
export EDITOR=nvim

ZSH_THEME="robbyrussell"

# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
plugins=(git asdf)

source $ZSH/oh-my-zsh.sh

# brew install z
. /usr/local/etc/profile.d/z.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="/usr/local/sbin:$PATH"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

# Custom Alias
alias vim='nvim'
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
alias lsplog="tail -f ~/.cache/nvim/lsp.log"
alias vimconfig="vim ~/.config/nvim/init.vim"
alias efmconfig="vim ~/.config/efm-langserver/config.yaml"
alias update-nvim-nightly='asdf uninstall neovim nightly && asdf install neovim nightly'
export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

function nukedocker() {
	docker stop `docker ps -qa` 2>/dev/null ; true
	docker rm `docker ps -qa` 2>/dev/null ; true
	docker rmi `docker image ls -qa` 2>/dev/null ; true
	docker system prune -af
	docker volume prune -f
}

