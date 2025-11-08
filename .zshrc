# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export HOMEBREW_EDITOR=nvim
export EDITOR=nvim

ZSH_THEME="robbyrussell"

# brew install z
. "$(brew --prefix)/etc/profile.d/z.sh"

# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
plugins=(git mise)

. $ZSH/oh-my-zsh.sh

# mise activation
eval "$(mise activate zsh)"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="rg --files --glob '!_build/' --glob '!node_modules/' --glob '!.git/'"

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
alias gbr="git branch | grep -v "main" | xargs git branch -D"
alias phx.install="mix archive.install hex phx_new"
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias lsplog="tail -f ~/.cache/nvim/lsp.log"
alias vimconfig="vim ~/.config/nvim/init.vim"
alias efmconfig="vim ~/.config/efm-langserver/config.yaml"
alias ngrokconfig="vim ~/.ngrok2/ngrok.yml"
alias update-nvim='mise install neovim@latest'
alias lzd='lazydocker'
# Kubernetes
alias k='kubectl'
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# usage:
# - exd '{Module, :function}'
# - exd Module
function exd() {
  elixir -S mix run --no-start -e "IEx.Introspection.h $1"
}

function nukedocker-all() {
	docker stop `docker ps -qa` 2>/dev/null ; true
	docker rm `docker ps -qa` 2>/dev/null ; true
	docker rmi `docker image ls -qa` 2>/dev/null ; true
	docker system prune -af
	docker volume prune -f
}
function nukedocker-volumes() {
	docker stop `docker ps -qa` 2>/dev/null ; true
	docker volume rm `docker volume ls -q`
}

. "$HOME/.cargo/env"
