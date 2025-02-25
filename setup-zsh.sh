#!/bin/bash

# Setup script for minimal, performant Zsh configuration that matches your Fish setup
echo "Setting up a minimal, performant Zsh configuration..."

# Copy configuration files
echo "Copying configuration files..."
cp .zshrc ~/.zshrc
mkdir -p ~/.config
cp starship.toml ~/.config/starship.toml

# Create necessary directories
mkdir -p ~/.zsh/plugins
mkdir -p ~/.zsh/cache

# Install essential plugins
echo "Installing essential plugins..."
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/plugins/zsh-autosuggestions
git clone --depth 1 https://github.com/zsh-users/zsh-completions.git ~/.zsh/plugins/zsh-completions
git clone --depth 1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git ~/.zsh/plugins/fast-syntax-highlighting

# Install fzf for fuzzy finding (similar to fzf.fish)
echo "Installing fzf for fuzzy finding..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc

# Install modern CLI tools
echo "Installing modern CLI tools..."
brew install zoxide bat fd eza ripgrep starship

# Install Starship prompt
echo "Installing Starship prompt..."
if ! command -v starship &>/dev/null; then
  brew install starship
fi

# Install zoxide for smart directory navigation
echo "Installing zoxide for smart directory navigation..."
if ! command -v zoxide &>/dev/null; then
  brew install zoxide
fi

# Install bat (alternative to cat)
echo "Installing bat..."
if ! command -v bat &>/dev/null; then
  brew install bat
fi

# Install fd for faster file finding with fzf
echo "Installing fd..."
if ! command -v fd &>/dev/null; then
  brew install fd
fi

# Uncomment the plugin installation lines in .zshrc (macOS compatible version)
echo "Configuring .zshrc..."
sed -i '' 's/# update_plugin/update_plugin/g' ~/.zshrc

# Set Zsh as the default shell
echo "Setting Zsh as the default shell..."
chsh -s $(which zsh)

echo "Installation complete! Please restart your terminal or run 'zsh' to start using your new shell."
echo "Your Zsh configuration now includes:"
echo "- Fast syntax highlighting"
echo "- Autosuggestions"
echo "- Fuzzy finding with fzf"
echo "- Smart directory navigation with zoxide"
echo "- Starship prompt for a modern look"
echo "- Modern CLI tools (eza, ripgrep, fd, bat)"
echo "- NVM integration with auto-switching"
echo "- Homebrew, pnpm, and bun configurations"
echo "- kubectl completion with lazy loading"
