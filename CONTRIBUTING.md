# Contributing to Finder Shell Extension

Thank you for your interest in contributing to the Finder Shell Extension! We welcome contributions from the community and are grateful for any help you can provide.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Reporting Issues](#reporting-issues)
- [Feature Requests](#feature-requests)

## 🤝 Code of Conduct

This project adheres to a code of conduct that we expect all contributors to follow:

- **Be respectful**: Treat everyone with respect and kindness
- **Be inclusive**: Welcome newcomers and help them get started
- **Be constructive**: Provide helpful feedback and suggestions
- **Be collaborative**: Work together towards common goals

## 🚀 Getting Started

### Prerequisites

- macOS (required for testing)
- Fish shell and/or Zsh
- Git
- Basic knowledge of shell scripting

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/yourusername/finder.git
   cd finder
   ```

3. Add the upstream repository as a remote:
   ```bash
   git remote add upstream https://github.com/originalowner/finder.git
   ```

## 🛠️ Development Setup

1. **Test the current installation**:
   ```bash
   ./install.sh --auto
   finder --help
   ```

2. **Make your changes** to the appropriate files:
   - `functions/finder.fish` - Fish shell function
   - `completions/finder.fish` - Fish shell completions
   - `plugins/finder/finder.plugin.zsh` - Zsh implementation
   - `install.sh` - Installation script
   - `uninstall.sh` - Uninstallation script

3. **Test your changes**:
   ```bash
   # Uninstall current version
   ./uninstall.sh --force
   
   # Install your modified version
   ./install.sh --auto
   
   # Test functionality
   finder .
   finder --help
   finder ~/Desktop
   ```

## 🔄 How to Contribute

### Types of Contributions

We welcome several types of contributions:

- **Bug fixes**: Fix issues or improve error handling
- **Feature enhancements**: Add new functionality
- **Documentation**: Improve README, comments, or help text
- **Shell support**: Add support for additional shells
- **Testing**: Improve test coverage or add test cases
- **Performance**: Optimize existing code

### Before You Start

1. **Check existing issues**: Look for existing issues or discussions
2. **Create an issue**: For significant changes, create an issue first to discuss
3. **Keep changes focused**: One feature/fix per pull request

## 📝 Pull Request Process

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/issue-description
```

### 2. Make Your Changes

- Follow the [coding standards](#coding-standards)
- Add tests if applicable
- Update documentation as needed
- Ensure your changes work with both Fish and Zsh (if applicable)

### 3. Commit Your Changes

Use conventional commit messages with the specified prefixes:

```bash
git commit -m ":sparkles: feat: add support for opening multiple finder windows"
git commit -m ":bug: fix: handle paths with spaces correctly"
git commit -m ":books: docs: update installation instructions"
git commit -m ":recycle: refactor: simplify path resolution logic"
git commit -m ":wrench: chore: update dependencies"
git commit -m ":test_tube: test: add tests for edge cases"
```

#### Commit Message Prefixes

| Prefix | Type | Description |
|--------|------|-------------|
| `:sparkles: feat:` | Feature | New feature or functionality |
| `:bug: fix:` | Bug Fix | Bug fixes and error corrections |
| `:books: docs:` | Documentation | Documentation changes |
| `:recycle: refactor:` | Refactoring | Code refactoring without functional changes |
| `:wrench: chore:` | Chore | Maintenance tasks, build changes |
| `:mag: nit:` | Minor | Small fixes, typos, formatting |
| `:test_tube: test:` | Testing | Adding or updating tests |

### 4. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a pull request on GitHub with:

- **Clear title**: Describe what the PR does
- **Detailed description**: Explain the changes and why they're needed
- **Testing notes**: How you tested the changes
- **Screenshots**: If applicable, especially for UI changes

### 5. Pull Request Review

- Address review feedback promptly
- Keep the conversation constructive
- Update your branch if requested
- Squash commits if asked

## 📏 Coding Standards

### Shell Script Guidelines

#### General Principles

- **Readability**: Code should be easy to read and understand
- **Robustness**: Handle errors gracefully with meaningful messages
- **Portability**: Work across different macOS versions
- **Consistency**: Follow existing patterns in the codebase

#### Fish Shell Standards

```fish
# Use descriptive function names
function finder --description "Open Finder windows on macOS"

# Validate arguments early
if test (count $argv) -eq 0
    set argv "."
end

# Use proper error handling
if not test -e $path
    echo "Error: Path does not exist: $path" >&2
    return 1
end

# Use Fish-specific features appropriately
set -l paths $argv
for path in $paths
    # process each path
end
```

#### Zsh Standards

```zsh
# Use proper variable declarations
local paths=("$@")
local expanded_path resolved_path

# Use proper conditionals
if [[ $(uname) != "Darwin" ]]; then
    echo "Error: macOS required" >&2
    return 1
fi

# Handle arrays properly
for path in "${paths[@]}"; do
    # process each path
done
```

#### Bash Scripts (install/uninstall)

```bash
#!/bin/bash
set -e  # Exit on error

# Use proper variable quoting
local config_file="$HOME/.zshrc"

# Use proper conditionals
if [[ ! -f "$config_file" ]]; then
    echo "Config file not found"
    return 1
fi

# Use meaningful function names
install_fish() {
    # Implementation
}
```

### Documentation Standards

- **Comments**: Explain complex logic, not obvious operations
- **Help text**: Keep it concise but comprehensive
- **Examples**: Provide realistic usage examples
- **Error messages**: Be specific and actionable

### File Organization

```
finder/
├── functions/finder.fish          # Fish function (Fisher-compatible)
├── completions/finder.fish        # Fish completions (Fisher-compatible)
├── plugins/finder/                # Oh My Zsh plugin structure
│   └── finder.plugin.zsh         # Zsh implementation
├── install.sh                     # Installation script
├── uninstall.sh                   # Uninstallation script
├── README.md                      # Main documentation
├── CONTRIBUTING.md                # This file
├── LICENSE                        # MIT license
└── .github/                       # GitHub templates
    ├── ISSUE_TEMPLATE/
    └── workflows/
```

## 🧪 Testing

### Manual Testing Checklist

Before submitting a pull request, test the following scenarios:

#### Basic Functionality
- [ ] `finder` (no arguments) - opens current directory
- [ ] `finder ~/Desktop` - opens specific directory
- [ ] `finder file.txt` - reveals file in Finder
- [ ] `finder --help` - shows help message
- [ ] `finder --version` - shows version info

#### Edge Cases
- [ ] `finder nonexistent/path` - shows appropriate error
- [ ] `finder "path with spaces"` - handles spaces correctly
- [ ] `finder ~/` - handles tilde expansion
- [ ] `finder . ..` - handles multiple paths
- [ ] `finder /usr/bin/ls` - reveals system files

#### Installation/Uninstallation
- [ ] `./install.sh --fish-only` - Fish installation works
- [ ] `./install.sh --zsh-only` - Zsh installation works
- [ ] `./install.sh --auto` - Auto-detection works
- [ ] `./uninstall.sh --force` - Uninstallation works
- [ ] Reinstallation after uninstallation works

#### Shell-Specific Testing

**Fish Shell**:
- [ ] Tab completion works for directories
- [ ] Function shows up in `functions` list
- [ ] No conflicts with existing Fish functions

**Zsh Shell**:
- [ ] Tab completion works for files and directories
- [ ] Compatible with Oh My Zsh
- [ ] Works in both Zsh and Oh My Zsh environments

### Test Environment Setup

```bash
# Create test directories
mkdir -p ~/test-finder/subdir
touch ~/test-finder/testfile.txt
touch ~/test-finder/file\ with\ spaces.txt

# Test basic functionality
finder ~/test-finder
finder ~/test-finder/testfile.txt
finder ~/test-finder/file\ with\ spaces.txt

# Clean up
rm -rf ~/test-finder
```

## 🐛 Reporting Issues

When reporting issues, please include:

### Bug Reports

1. **Environment Information**:
   - macOS version
   - Shell type and version
   - Installation method used

2. **Steps to Reproduce**:
   - Exact commands run
   - Expected vs. actual behavior
   - Error messages (if any)

3. **Additional Context**:
   - Screenshots or terminal output
   - Any relevant system information

### Issue Template

```markdown
**Bug Description**
A clear description of what the bug is.

**Environment**
- macOS version: [e.g., macOS Sonoma 14.1]
- Shell: [e.g., Fish 3.6.1, Zsh 5.9]
- Installation method: [e.g., ./install.sh --auto]

**Steps to Reproduce**
1. Run command '...'
2. See error

**Expected Behavior**
What you expected to happen.

**Actual Behavior**
What actually happened.

**Additional Context**
Any other context or screenshots.
```

## 💡 Feature Requests

We welcome feature requests! When suggesting new features:

1. **Check existing issues** to avoid duplicates
2. **Describe the use case** and why it would be valuable
3. **Consider implementation** complexity and maintainability
4. **Provide examples** of how the feature would be used

### Feature Request Template

```markdown
**Feature Description**
A clear description of the feature you'd like to see.

**Use Case**
Describe the problem this feature would solve.

**Proposed Solution**
How you envision this feature working.

**Alternatives Considered**
Other approaches you've considered.

**Additional Context**
Any other context or examples.
```

## 🎉 Recognition

Contributors will be recognized in the following ways:

- Listed in the repository contributors
- Mentioned in release notes for significant contributions
- Added to a contributors file (if we create one)

## 📞 Getting Help

If you need help with contributing:

- 💬 **Discussions**: Use GitHub Discussions for questions
- 🐛 **Issues**: Create an issue for bug reports
- 📧 **Contact**: Reach out to maintainers for complex questions

Thank you for contributing to the Finder Shell Extension! 🎉