# Modern Zsh Configuration

A minimal, performant Zsh configuration that provides a modern shell experience with features similar to Fish shell, but with the power and flexibility of Zsh.

## Features

- Fast startup time with lazy loading
- Modern prompt with Starship
- Syntax highlighting with Fast Syntax Highlighting
- Autosuggestions as you type (including file paths)
- Fuzzy finding with fzf
- Smart directory navigation with zoxide
- Modern CLI tools (eza, ripgrep, fd, bat)
- NVM integration with auto-switching
- Lazy loading for kubectl and other tools
- Useful aliases and functions
- Enhanced file path autocompletion
- Alias reminders with You-Should-Use plugin
- Beautiful icons with Nerd Fonts
- McFly for intelligent command history

## Prerequisites

- macOS with [Homebrew](https://brew.sh/) installed
- Basic familiarity with terminal usage
- Git installed

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

3. During installation, you'll be prompted to choose a Nerd Font:

   - Hack Nerd Font (recommended)
   - JetBrains Mono Nerd Font
   - Skip (if you already have a Nerd Font installed)

4. After installation, configure your terminal to use the selected Nerd Font:

   - For iTerm2: Preferences > Profiles > Text > Font
   - For Terminal.app: Preferences > Profiles > Text
   - For VS Code: Add `"terminal.integrated.fontFamily": "[Font Name] Nerd Font"` to settings.json

5. Restart your terminal or run `zsh` to start using your new shell.

## Configuration Files

- `.zshrc`: Main Zsh configuration file
- `setup-zsh.sh`: Installation script for plugins and tools
- `starship.toml`: Configuration for the Starship prompt

## Key Features Explained

### Enhanced File Path Completion

Type a partial file path and press TAB to see completion options. The configuration includes smart matching for partial paths, handling of special characters, and more.

### Auto-suggestions

As you type, you'll see ghost text suggestions based on:

- Your command history
- File paths (type `./` followed by part of a filename)
- Accept suggestions with the right arrow key

### Modern CLI Tools

The configuration replaces traditional Unix tools with modern alternatives:

- `ls` → `eza --icons` (colorized and with icons)
- `cat` → `bat` (syntax highlighting)
- `grep` → `ripgrep` (faster and more features)
- `find` → `fd` (simpler syntax and faster)

### Smart Navigation

- `cd` will automatically list directory contents
- `mkcd` creates a directory and navigates into it
- `zoxide` remembers your most used directories (`z [dir]`)

## Customization

Feel free to customize the configuration to your liking:

- **Adding Aliases**: Edit `.zshrc` and add to the Aliases section
- **Modifying the Prompt**: Edit `starship.toml` (see [Starship docs](https://starship.rs/config/))
- **Changing Key Bindings**: Edit the Key Bindings section in `.zshrc`
- **Adding Plugins**: Use the `update_plugin` function in `.zshrc`

## Troubleshooting

### Icons Not Displaying Properly

If icons appear as boxes or question marks:

1. Make sure you installed a Nerd Font during setup
2. Configure your terminal to use that Nerd Font
3. Restart your terminal application

### Performance Issues

If startup is slow:

1. Uncomment the `zmodload zsh/zprof` line at the top of `.zshrc`
2. Uncomment the `zprof` line at the bottom of `.zshrc`
3. Start a new Zsh session to see timing information
4. Look for slow plugins or commands

A well-optimized configuration should start in under 100ms.

### Auto-suggestions Not Working

If you don't see file path suggestions:

1. Make sure zsh-autosuggestions is installed: `ls ~/.zsh/plugins/zsh-autosuggestions`
2. Try running: `source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh`

## Updating

To update your configuration:

1. Pull the latest changes: `git pull`
2. Run the setup script again: `./setup-zsh.sh`
