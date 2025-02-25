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

# Install Nerd Font for proper icon display
echo "Installing Nerd Font for proper icon display..."

# Prompt user to choose a Nerd Font
echo "Choose a Nerd Font to install (required for icons):"
echo "1) Hack Nerd Font (recommended)"
echo "2) JetBrains Mono Nerd Font"
echo "3) Skip font installation (if you already have a Nerd Font installed)"
read -p "Enter your choice (1-3): " font_choice

case $font_choice in
1)
  # Install Hack Nerd Font
  if ! brew list --cask font-hack-nerd-font &>/dev/null; then
    echo "Installing Hack Nerd Font..."
    brew install --cask font-hack-nerd-font
    echo "✅ Hack Nerd Font installed. Please configure your terminal to use 'Hack Nerd Font' for proper icon display."
  else
    echo "✅ Hack Nerd Font is already installed."
  fi
  ;;
2)
  # Install JetBrains Mono Nerd Font
  if ! brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
    echo "Installing JetBrains Mono Nerd Font..."
    brew install --cask font-jetbrains-mono-nerd-font
    echo "✅ JetBrains Mono Nerd Font installed. Please configure your terminal to use 'JetBrainsMono Nerd Font' for proper icon display."
  else
    echo "✅ JetBrains Mono Nerd Font is already installed."
  fi
  ;;
3)
  echo "Skipping Nerd Font installation. Make sure your terminal uses a Nerd Font for proper icon display."
  ;;
*)
  echo "Invalid choice. Installing Hack Nerd Font by default..."
  brew install --cask font-hack-nerd-font
  ;;
esac

# Install McFly for intelligent shell history
echo "Installing McFly for intelligent command history..."
if ! command -v mcfly &>/dev/null; then
  brew install mcfly
  # Add McFly initialization to .zshrc if not already present
  if ! grep -q "mcfly init zsh" ~/.zshrc; then
    echo -e "\n# Initialize McFly for intelligent history search\neval \"\$(mcfly init zsh)\"" >>~/.zshrc
  fi
fi

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

# Ensure autosuggestions plugin is properly installed and configured
echo "Making sure autosuggestions are properly installed..."
if [ ! -d ~/.zsh/plugins/zsh-autosuggestions ]; then
  git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/plugins/zsh-autosuggestions
fi

# Set Zsh as the default shell
echo "Setting Zsh as the default shell..."
chsh -s $(which zsh)

# Install zsh-you-should-use for alias reminders
echo "Installing zsh-you-should-use..."
git clone https://github.com/MichaelAquilina/zsh-you-should-use ~/.zsh/plugins/zsh-you-should-use
# Add to .zshrc if not already present
if ! grep -q "zsh-you-should-use" ~/.zshrc; then
  echo -e "\n# Load zsh-you-should-use for alias reminders\nsource ~/.zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh" >>~/.zshrc
fi

echo "Installation complete! Please restart your terminal or run 'zsh' to start using your new shell."
echo "Your Zsh configuration now includes:"
echo "- Fast syntax highlighting"
echo "- Autosuggestions"
echo "- Fuzzy finding with fzf"
echo "- Smart directory navigation with zoxide"
echo "- Starship prompt for a modern look"
echo "- Modern CLI tools (eza, ripgrep, fd, bat)"
echo "- McFly for intelligent command history"
echo "- NVM integration with auto-switching"
echo "- Homebrew, pnpm, and bun configurations"
echo "- kubectl completion with lazy loading"
echo "- Nerd Font for proper icon display"
echo ""
echo "IMPORTANT: To see icons correctly, make sure to set your terminal font to a Nerd Font"
echo "in your terminal preferences/settings (like the one you selected during installation)."
