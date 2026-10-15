# Setup fzf
# ---------
if [ -d /opt/homebrew/opt/fzf ]; then
  FZF_BASE="/opt/homebrew/opt/fzf"
elif [ -d /usr/local/opt/fzf ]; then
  FZF_BASE="/usr/local/opt/fzf"
elif command -v brew >/dev/null 2>&1 && [ -d "$(brew --prefix)/opt/fzf" ]; then
  FZF_BASE="$(brew --prefix)/opt/fzf"
fi

if [ -n "$FZF_BASE" ]; then
  if [[ ! "$PATH" == *"$FZF_BASE/bin"* ]]; then
    export PATH="${PATH:+${PATH}:}$FZF_BASE/bin"
  fi

  # Auto-completion
  # ---------------
  [[ $- == *i* ]] && [ -f "$FZF_BASE/shell/completion.zsh" ] && source "$FZF_BASE/shell/completion.zsh" 2> /dev/null

  # Key bindings
  # ------------
  [ -f "$FZF_BASE/shell/key-bindings.zsh" ] && source "$FZF_BASE/shell/key-bindings.zsh"
fi

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
