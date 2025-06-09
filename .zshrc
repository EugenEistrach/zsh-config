# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/eugeneistrach/completions:"* ]]; then export FPATH="/Users/eugeneistrach/completions:$FPATH"; fi
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
setopt HIST_FIND_NO_DUPS    # Don't show duplicates in search
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first when trimming history

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
bindkey '^[[1;3C' forward-word                   # Alt+Right (macOS)
bindkey '^[[1;3D' backward-word                  # Alt+Left (macOS)
bindkey '^R' history-incremental-search-backward # Ctrl+R for history search
bindkey '^S' history-incremental-search-forward  # Ctrl+S for forward history search

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

# Configure zsh-autosuggestions for better performance and less interference
if [ -f ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  # Use less aggressive strategy to avoid terminal interference
  export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  # Make autosuggestions appear faster (default is 0.15)
  export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
  export ZSH_AUTOSUGGEST_USE_ASYNC=true

  # Make suggestion style more visible but not intrusive
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
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
# if command -v eza &>/dev/null; then
#   alias ls='eza --icons'
#   alias ll='eza --icons -la'
#   alias la='eza --icons -a'
#   alias lt='eza --icons -T'
#   alias lg='eza --icons -la --git'
# else
#   # Fallback to exa if available
#   if command -v exa &>/dev/null; then
#     alias ls='exa --icons'
#     alias ll='exa --icons -la'
#     alias la='exa --icons -a'
#     alias lt='exa --icons -T'
#     alias lg='exa --icons -la --git'
#   else
#     alias ls='ls -G'
#     alias ll='ls -lah'
#     alias la='ls -A'
#     alias l='ls -CF'
#   fi
# fi

# Use bat instead of cat if available
# if command -v bat &>/dev/null; then
#   alias cat='bat'
# fi

# Use ripgrep instead of grep if available
# if command -v rg &>/dev/null; then
#   alias grep='rg'
# fi

# Use fd instead of find if available
# if command -v fd &>/dev/null; then
#   alias find='fd'
# fi

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
alias glog='git log --oneline --graph --decorate'
alias gstash='git stash'
alias gpop='git stash pop'


# Quick navigation
alias h='history | tail -20'  # Recent history
alias ports='lsof -i -P | grep LISTEN'  # Show listening ports
alias myip='curl -s ifconfig.me'        # Get external IP
alias localip='ipconfig getifaddr en0'  # Get local IP

# Development shortcuts
alias reload='source ~/.zshrc'
alias editrc='$EDITOR ~/.zshrc'
alias path='echo $PATH | tr ":" "\n"'  # Pretty print PATH

# ===== Functions =====

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


# Quick project switcher
function proj() {
  local project_dirs=("$HOME/Projects" "$HOME/projects" "$HOME/code" "$HOME/dev")
  local selected
  
  for dir in "${project_dirs[@]}"; do
    if [[ -d "$dir" ]]; then
      if command -v fzf &>/dev/null; then
        selected=$(find "$dir" -maxdepth 2 -type d -name ".git" | sed 's|/.git||' | fzf --prompt="Project: ")
        [[ -n "$selected" ]] && cd "$selected"
      else
        echo "Available projects in $dir:"
        ls -1 "$dir"
      fi
      return
    fi
  done
  echo "No project directories found"
}

# Weather function (non-intrusive)
function weather() {
  local location="${1:-}"
  curl -s "wttr.in/${location}?format=3"
}

# Git status for all repos in current directory
function gstatus_all() {
  for dir in */; do
    if [[ -d "$dir/.git" ]]; then
      echo "\n📁 $dir"
      git -C "$dir" status --porcelain | head -5
    fi
  done
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

# Task Master aliases added on 4/15/2025
alias tm='task-master'
alias taskmaster='task-master'

# Performance tweaks
# Disable global RCS files for faster startup
unsetopt GLOBAL_RCS

# Better job control
setopt LONG_LIST_JOBS     # List jobs in long format
setopt AUTO_RESUME        # Resume stopped jobs with command name
setopt NOTIFY             # Report status of background jobs immediately

# Smart case completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'

# Better file completion
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# Deno environment
. "/Users/eugeneistrach/.deno/env"
