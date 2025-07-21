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

```bash
# Clone the repository
git clone https://github.com/yourusername/finder.git
cd finder

# Run the installer (auto-detects your shell)
./install.sh

# Or install for specific shell
./install.sh --fish-only
./install.sh --zsh-only
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

### Automatic Installation

The installer will automatically detect your shell and install the appropriate version:

```bash
./install.sh
```

### Manual Installation

#### Fish Shell

1. Copy the Fish function:
   ```bash
   mkdir -p ~/.config/fish/functions
   cp fish/finder.fish ~/.config/fish/functions/
   ```

2. Reload Fish or start a new session

#### Zsh Shell

1. Add to your `.zshrc`:
   ```bash
   echo 'source /path/to/finder/zsh/finder.zsh' >> ~/.zshrc
   ```

2. Reload your shell:
   ```bash
   source ~/.zshrc
   ```

### Installation Options

| Option | Description |
|--------|-------------|
| `--auto` | Auto-detect shells and install for all available (default) |
| `--fish-only` | Install only for Fish shell |
| `--zsh-only` | Install only for Zsh shell |
| `--help` | Show installation help |

## 🗑️ Uninstallation

Remove the finder extension from your system:

```bash
# Remove from all shells
./uninstall.sh

# Remove from specific shell
./uninstall.sh --fish-only
./uninstall.sh --zsh-only

# Force removal without confirmation
./uninstall.sh --force
```

The uninstaller will:
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