#!/usr/bin/env zsh

# Finder shell extension for Zsh
# Opens Finder windows on macOS

finder() {
    # Check if running on macOS
    if [[ $(uname) != "Darwin" ]]; then
        echo "Error: finder command only works on macOS" >&2
        return 1
    fi

    # Show help if requested
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        cat << 'EOF'
Usage: finder [PATH...]

Open Finder windows on macOS

Arguments:
  PATH    Path to open in Finder (default: current directory)
          Can be a file (reveals in Finder) or directory (opens in Finder)
          Supports multiple paths, relative paths, and tilde expansion

Options:
  -h, --help    Show this help message
  --version     Show version information

Examples:
  finder                    # Open current directory
  finder ~/Desktop          # Open Desktop folder
  finder . ..               # Open current and parent directories
  finder /path/to/file.txt  # Reveal file in Finder
  finder ~/Documents ~/Downloads  # Open multiple directories
EOF
        return 0
    fi

    # Show version if requested
    if [[ "$1" == "--version" ]]; then
        echo "finder 1.0.0"
        echo "A simple shell extension to open Finder windows on macOS"
        return 0
    fi

    # Use current directory if no arguments provided
    local paths=("$@")
    if [[ ${#paths[@]} -eq 0 ]]; then
        paths=(".")
    fi

    # Process each path
    local path expanded_path resolved_path
    for path in "${paths[@]}"; do
        # Expand tilde and resolve path
        expanded_path="${path/#\~/$HOME}"
        
        # Check if path exists
        if [[ ! -e "$expanded_path" ]]; then
            echo "Error: Path does not exist: $path" >&2
            continue
        fi

        # Try to get the real path
        if command -v realpath >/dev/null 2>&1; then
            resolved_path=$(realpath "$expanded_path" 2>/dev/null)
            if [[ -n "$resolved_path" ]]; then
                expanded_path="$resolved_path"
            fi
        fi

        # Check if it's a file or directory and open accordingly
        if [[ -f "$expanded_path" ]]; then
            # It's a file - reveal it in Finder
            if open -R "$expanded_path"; then
                echo "Revealed file in Finder: $path"
            else
                echo "Error: Failed to reveal file: $path" >&2
            fi
        elif [[ -d "$expanded_path" ]]; then
            # It's a directory - open it in Finder
            if open "$expanded_path"; then
                echo "Opened directory in Finder: $path"
            else
                echo "Error: Failed to open directory: $path" >&2
            fi
        else
            echo "Error: Path is neither a file nor directory: $path" >&2
        fi
    done
}

# Add completion for finder command
if [[ -n "$ZSH_VERSION" ]]; then
    # Zsh completion function
    _finder() {
        local context state state_descr line
        typeset -A opt_args

        _arguments -C \
            '(-h --help)'{-h,--help}'[Show help message]' \
            '--version[Show version information]' \
            '*:file or directory:_files'
    }

    # Register the completion function
    compdef _finder finder
fi