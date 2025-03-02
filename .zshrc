# Performance profiling (uncomment to enable)
# zmodload zsh/zprof

# ===== Core Zsh Configuration =====
# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY        # Share history between sessions
setopt HIST_IGNORE_ALL_DUPS # Don't record duplicates
setopt HIST_SAVE_NO_DUPS    # Don't save duplicates
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks
setopt HIST_VERIFY          # Verify history expansion
setopt EXTENDED_HISTORY     # Record timestamp of command
setopt HIST_IGNORE_SPACE    # Don't record commands starting with space

# Directory navigation (similar to Fish)
setopt AUTO_CD           # cd by typing directory name
setopt AUTO_PUSHD        # Push the current directory onto the stack
setopt PUSHD_IGNORE_DUPS # Don't store duplicates in the stack
setopt PUSHD_SILENT      # Don't print directory stack

# Completion system
autoload -Uz compinit
# Only check completion dump once a day
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null) ]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' menu select
# Fix for list-colors parameter expansion
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
zstyle ':completion:*' list-colors "${LS_COLORS}" # Colored completion
zstyle ':completion:*' rehash true                # Automatically find new executables
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Enhanced file path completion
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' expand prefix suffix
setopt COMPLETE_IN_WORD # Complete from both ends of a word
setopt PATH_DIRS        # Perform path search even on command names with slashes
setopt AUTO_MENU        # Show completion menu on a successive tab press
setopt AUTO_LIST        # Automatically list choices on ambiguous completion
setopt AUTO_PARAM_SLASH # If completed parameter is a directory, add a trailing slash
setopt ALWAYS_TO_END    # Move cursor to the end of a completed word

setopt COMPLETE_ALIASES

# Key bindings
bindkey -e                                       # Emacs key bindings
bindkey '^[[A' history-beginning-search-backward # Up arrow
bindkey '^[[B' history-beginning-search-forward  # Down arrow
bindkey '^[[H' beginning-of-line                 # Home key
bindkey '^[[F' end-of-line                       # End key
bindkey '^[[3~' delete-char                      # Delete key
bindkey '^[[1;5C' forward-word                   # Ctrl+Right
bindkey '^[[1;5D' backward-word                  # Ctrl+Left

# ===== Plugin Management =====
# Using a minimal approach with git submodules
# Create plugins directory if it doesn't exist
mkdir -p ~/.zsh/plugins

# Function to clone or update plugins
update_plugin() {
  local repo=$1
  local dest="$HOME/.zsh/plugins/$(basename $repo)"

  if [ -d "$dest" ]; then
    echo "Updating $repo..."
    git -C "$dest" pull
  else
    echo "Cloning $repo..."
    git clone --depth 1 "https://github.com/$repo.git" "$dest"
  fi
}

# Install/update plugins (uncomment to run)
#update_plugin "zsh-users/zsh-autosuggestions"
#update_plugin "zsh-users/zsh-completions"
#update_plugin "zdharma-continuum/fast-syntax-highlighting"

# Source plugins if they exist
[ -f ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.zsh/plugins/zsh-completions/zsh-completions.plugin.zsh ] && source ~/.zsh/plugins/zsh-completions/zsh-completions.plugin.zsh
# Use fast-syntax-highlighting instead of regular syntax highlighting
[ -f ~/.zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ] && source ~/.zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Configure zsh-autosuggestions for better file path handling
if [ -f ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  # Use more aggressive completion approach
  export ZSH_AUTOSUGGEST_STRATEGY=(history completion path_completion)
  # Make autosuggestions appear faster (default is 0.15)
  export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
  export ZSH_AUTOSUGGEST_USE_ASYNC=true

  # Custom strategy to suggest files in current directory
  _zsh_autosuggest_strategy_path_completion() {
    # Only attempt path completion if buffer starts with ./
    if [[ $1 == ./* ]]; then
      local prefix="${1##*/}"
      local dir="$(pwd)"
      local files=("$dir"/*(N))
      local file
      for file in "${files[@]}"; do
        file="${file##*/}"
        if [[ "$file" == "$prefix"* && "$file" != "$prefix" ]]; then
          echo "./$file"
          return
        fi
      done
    fi
  }

  # Make suggestion style more visible
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8,bold"
fi

# fzf configuration (similar to fzf.fish)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Use fd (if available) for faster file finding
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# ===== Modern CLI Tools =====
# Use eza instead of ls if available
if command -v eza &>/dev/null; then
  alias ls='eza --icons'
  alias ll='eza --icons -la'
  alias la='eza --icons -a'
  alias lt='eza --icons -T'
  alias lg='eza --icons -la --git'
else
  # Fallback to exa if available
  if command -v exa &>/dev/null; then
    alias ls='exa --icons'
    alias ll='exa --icons -la'
    alias la='exa --icons -a'
    alias lt='exa --icons -T'
    alias lg='exa --icons -la --git'
  else
    alias ls='ls -G'
    alias ll='ls -lah'
    alias la='ls -A'
    alias l='ls -CF'
  fi
fi

# Use bat instead of cat if available
if command -v bat &>/dev/null; then
  alias cat='bat'
fi

# Use ripgrep instead of grep if available
if command -v rg &>/dev/null; then
  alias grep='rg'
fi

# Use fd instead of find if available
if command -v fd &>/dev/null; then
  alias find='fd'
fi

# ===== Aliases =====
# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -p'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# ===== Functions =====
# Fish-like directory listing when changing directories
function cd {
  builtin cd "$@" && ls
}

# Create a directory and cd into it
function mkcd {
  mkdir -p "$@" && cd "$@"
}

# Extract various archive formats
function extract {
  if [ -f $1 ]; then
    case $1 in
    *.tar.bz2) tar xjf $1 ;;
    *.tar.gz) tar xzf $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) unrar e $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xf $1 ;;
    *.tbz2) tar xjf $1 ;;
    *.tgz) tar xzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Interactive alias explorer
function aliases() {
  alias | fzf --height 50% | cut -d= -f1 | tr -d "'" | xargs -I{} echo "💡 {} is defined as: $(alias {} | cut -d= -f2 | tr -d "'")"
}

# ===== Environment Variables =====
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Add local bin directories to PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# Homebrew (matching your Fish setup)
eval "$(/opt/homebrew/bin/brew shellenv)"

# ===== Lazy Loading =====
# Node Version Manager with lazy loading
export NVM_DIR="$HOME/.nvm"

[ -s "$(brew --prefix nvm)/nvm.sh" ] && source "$(brew --prefix nvm)/nvm.sh"

# Auto-switch nvm version on directory change
autoload -U add-zsh-hook
load-nvmrc() {
  local nvmrc_path="$(pwd)/.nvmrc"
  local node_version_path="$(pwd)/.node-version"

  if [[ -f "$nvmrc_path" || -f "$node_version_path" ]]; then
    # Lazy load nvm if needed
    if ! type nvm >/dev/null; then
      [ -s "$(brew --prefix nvm)/nvm.sh" ] && source "$(brew --prefix nvm)/nvm.sh" --no-use
    fi
    nvm use >/dev/null 2>&1
  fi
}
add-zsh-hook chpwd load-nvmrc
# Run once at startup
load-nvmrc

# Lazy load kubectl
kubectl() {
  unfunction "$0"
  source <(command kubectl completion zsh)
  $0 "$@"
}

# pnpm (matching your Fish setup)
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# bun (matching your Fish setup)
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# zoxide for smart directory navigation
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# Load zsh-you-should-use for alias reminders
if [ -f ~/.zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh ]; then
  source ~/.zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh
fi

# ===== Starship Prompt =====
# Initialize Starship prompt if installed
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  # Fallback to simple prompt if Starship is not installed
  autoload -Uz vcs_info
  function precmd() {
    vcs_info
  }
  zstyle ':vcs_info:git:*' formats '%b'
  setopt PROMPT_SUBST
  PROMPT='%F{cyan}%~%f %F{green}${vcs_info_msg_0_:+(%F{blue}${vcs_info_msg_0_}%F{green})}%f %F{yellow}❯%f '
fi

# Performance profiling (uncomment to enable)
# zprof
