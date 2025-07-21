# Finder Shell Extension

A simple, elegant shell extension that adds a `finder` command to open Finder windows on macOS. Supports both Fish shell and Zsh with comprehensive error handling and user-friendly features.

## ✨ Features

- 🚀 **Easy to use**: Simple `finder` command to open Finder windows
- 🔄 **Multiple shells**: Support for both Fish and Zsh
- 📁 **Smart path handling**: Works with files, directories, relative paths, and tilde expansion
- 🎯 **File revealing**: Automatically reveals files in Finder or opens directories
- 🔍 **Multiple paths**: Open multiple locations at once
- 🛡️ **Error handling**: Comprehensive validation and helpful error messages
- 🍎 **macOS native**: Built specifically for macOS using native `open` command
- 📖 **Tab completion**: Built-in shell completion support

## 🚀 Quick Start

### Installation

#### Fish Shell (Recommended: Fisher)

```bash
# Install using Fisher (recommended)
fisher install iamrajjoshi/finder
```

#### Zsh Shell (Recommended: Oh My Zsh)

```bash
# Clone to Oh My Zsh custom plugins directory
git clone https://github.com/iamrajjoshi/finder.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/finder

# Add to your ~/.zshrc plugins list
plugins=(... finder)

# Reload your shell
source ~/.zshrc
```

#### Alternative Installation Methods

```bash
# Clone the repository
git clone https://github.com/iamrajjoshi/finder.git
cd finder

# Auto-detect and install appropriately
./install.sh

# Manual installation options
./install.sh --fish-fisher      # Fish with Fisher
./install.sh --fish-manual      # Fish manual installation
./install.sh --zsh-ohmyzsh      # Zsh with Oh My Zsh
./install.sh --zsh-manual       # Zsh manual installation
```

### Basic Usage

```bash
# Open current directory in Finder
finder

# Open specific directory
finder ~/Desktop

# Open multiple directories
finder ~/Documents ~/Downloads

# Reveal a file in Finder
finder /path/to/file.txt

# Open parent directory
finder ..

# Get help
finder --help
```

## 📖 Usage Examples

### Opening Directories
```bash
# Current directory
finder

# Home directory
finder ~

# Specific paths
finder /Applications
finder ~/Desktop ~/Documents

# Relative paths
finder .
finder ..
finder ./subfolder
```

### Revealing Files
```bash
# Reveal any file type in Finder
finder ~/Documents/report.pdf
finder /path/to/image.jpg
finder ./README.md
```

### Advanced Usage
```bash
# Multiple mixed paths
finder ~/Desktop file.txt ../parent-dir

# With wildcards (shell expands them)
finder ~/Pictures/*.jpg

# Complex paths with spaces (automatically handled)
finder "~/My Documents/Project Files"
```

## 🔧 Installation

### Recommended Installation Methods

#### Fish Shell with Fisher

Fisher is the recommended package manager for Fish shell:

1. **Install Fisher** (if not already installed):
   ```bash
   curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
   ```

2. **Install Finder**:
   ```bash
   fisher install iamrajjoshi/finder
   ```

3. **Uninstall** (if needed):
   ```bash
   fisher remove iamrajjoshi/finder
   ```

#### Zsh Shell with Oh My Zsh

Oh My Zsh is the recommended framework for Zsh:

1. **Install Oh My Zsh** (if not already installed):
   ```bash
   sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

2. **Install Finder as a custom plugin**:
   ```bash
   git clone https://github.com/iamrajjoshi/finder.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/finder
   ```

3. **Add to plugins** in `~/.zshrc`:
   ```bash
   plugins=(git ... finder)
   ```

4. **Reload your shell**:
   ```bash
   source ~/.zshrc
   ```

### Alternative Installation Methods

If you prefer not to use package managers, you can use the installation script:

```bash
git clone https://github.com/iamrajjoshi/finder.git
cd finder
./install.sh
```

#### Installation Script Options

| Option | Description |
|--------|-------------|
| `--auto` | Auto-detect shells and package managers (default) |
| `--fish-fisher` | Install for Fish using Fisher |
| `--fish-manual` | Install for Fish manually |
| `--zsh-ohmyzsh` | Install for Zsh using Oh My Zsh |
| `--zsh-manual` | Install for Zsh manually |
| `--help` | Show installation help |

#### Manual Installation

**Fish Shell:**
```bash
# Copy function and completion files
mkdir -p ~/.config/fish/{functions,completions}
cp functions/finder.fish ~/.config/fish/functions/
cp completions/finder.fish ~/.config/fish/completions/
```

**Zsh Shell:**
```bash
# Add to your .zshrc
echo 'source /path/to/finder/plugins/finder/finder.plugin.zsh' >> ~/.zshrc
source ~/.zshrc
```

## 🗑️ Uninstallation

### Using Package Managers (Recommended)

#### Fisher (Fish)
```bash
fisher remove iamrajjoshi/finder
```

#### Oh My Zsh (Zsh)
```bash
# Remove plugin directory
rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/finder

# Remove 'finder' from plugins list in ~/.zshrc
# Then reload: source ~/.zshrc
```

### Using Uninstall Script

```bash
# Remove all detected installations
./uninstall.sh

# Remove specific installation method
./uninstall.sh --fish-manual    # Fish manual installation
./uninstall.sh --zsh-ohmyzsh    # Oh My Zsh plugin
./uninstall.sh --zsh-manual     # Zsh manual installation

# Force removal without confirmation
./uninstall.sh --force
```

The uninstaller will:
- Detect current installation methods
- Remove shell functions and configurations
- Create backups before modifying files
- Clean up empty directories (with confirmation)
- Provide detailed feedback

## 🛠️ Requirements

- **Operating System**: macOS (any version with `open` command)
- **Shell**: Fish shell 3.0+ or Zsh 5.0+
- **Dependencies**: None (uses built-in macOS tools)

## 📚 Command Reference

### Options

| Flag | Description |
|------|-------------|
| `-h, --help` | Show help message and usage examples |
| `--version` | Display version information |

### Arguments

| Argument | Description |
|----------|-------------|
| `PATH` | File or directory path to open (optional, defaults to current directory) |

### Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Error (invalid path, not macOS, etc.) |

### Shell Completion

Both Fish and Zsh versions include built-in tab completion:

- **Fish**: Completes directories and shows descriptions
- **Zsh**: Completes files and directories with Zsh's powerful completion system

## 🐛 Troubleshooting

### Common Issues

**Command not found**
```bash
# For Fish: ensure function is in the right location
ls ~/.config/fish/functions/finder.fish

# For Zsh: ensure sourcing is in .zshrc
grep finder ~/.zshrc
```

**Permission denied**
```bash
# Make sure you have permission to access the path
ls -la /path/to/directory
```

**Not working on non-macOS**
- This extension only works on macOS and will show an error on other systems

### Debug Mode

For troubleshooting, you can manually inspect the shell functions:

```bash
# Fish: View the function
functions finder

# Zsh: Check if function is loaded
which finder
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Quick Development Setup

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Test with both Fish and Zsh (if available)
5. Submit a pull request

### Testing

Test the installation and functionality:

```bash
# Test installation
./install.sh --auto

# Test basic functionality
finder --help
finder --version
finder .

# Test uninstallation
./uninstall.sh --force
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by the need for simple Finder integration in terminal workflows
- Built with love for the macOS and shell scripting community
- Thanks to all contributors and users who help improve this tool

## 📞 Support

- 🐛 **Bug Reports**: [Open an issue](https://github.com/yourusername/finder/issues)
- 💡 **Feature Requests**: [Open an issue](https://github.com/yourusername/finder/issues)
- ❓ **Questions**: [Start a discussion](https://github.com/yourusername/finder/discussions)

---

**Made with ❤️ for macOS terminal users**