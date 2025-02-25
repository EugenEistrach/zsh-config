# Modern Zsh Configuration

A minimal, performant Zsh configuration that provides a modern shell experience with features similar to Fish shell.

## Features

- Fast startup time with lazy loading
- Modern prompt with Starship
- Syntax highlighting with Fast Syntax Highlighting
- Autosuggestions as you type
- Fuzzy finding with fzf
- Smart directory navigation with zoxide
- Modern CLI tools (exa, ripgrep, fd, bat)
- NVM integration with auto-switching
- Lazy loading for kubectl and other tools
- Useful aliases and functions

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/zsh-config.git
   ```

2. Run the setup script:
   ```bash
   cd zsh-config
   chmod +x setup-zsh.sh
   ./setup-zsh.sh
   ```

3. Restart your terminal or run `zsh` to start using your new shell.

## Configuration Files

- `.zshrc`: Main Zsh configuration file
- `setup-zsh.sh`: Installation script for plugins and tools
- `starship.toml`: Configuration for the Starship prompt

## Customization

Feel free to customize the configuration to your liking:

- Edit `.zshrc` to add or remove features
- Modify `starship.toml` to customize your prompt
- Add your own aliases and functions

## Performance

This configuration is designed to be fast and efficient. To check the startup time:

1. Uncomment the `zmodload zsh/zprof` line at the top of `.zshrc`
2. Uncomment the `zprof` line at the bottom of `.zshrc`
3. Start a new Zsh session to see timing information

A well-optimized configuration should start in under 100ms.
