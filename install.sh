#!/bin/bash

# Finder Shell Extension Installer
# Installs the finder command for Fish and/or Zsh shells

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
check_macos() {
    if [[ $(uname) != "Darwin" ]]; then
        print_error "This extension only works on macOS"
        exit 1
    fi
}

# Detect available shells
detect_shells() {
    local shells=()
    
    # Check for Fish
    if command -v fish >/dev/null 2>&1; then
        shells+=("fish")
    fi
    
    # Check for Zsh
    if command -v zsh >/dev/null 2>&1; then
        shells+=("zsh")
    fi
    
    echo "${shells[@]}"
}

# Install for Fish shell
install_fish() {
    print_status "Installing finder command for Fish shell..."
    
    local fish_config_dir="$HOME/.config/fish"
    local fish_functions_dir="$fish_config_dir/functions"
    
    # Create Fish directories if they don't exist
    if [[ ! -d "$fish_functions_dir" ]]; then
        print_status "Creating Fish functions directory: $fish_functions_dir"
        mkdir -p "$fish_functions_dir"
    fi
    
    # Copy the Fish function
    if cp "fish/finder.fish" "$fish_functions_dir/finder.fish"; then
        print_success "Fish function installed to: $fish_functions_dir/finder.fish"
        return 0
    else
        print_error "Failed to install Fish function"
        return 1
    fi
}

# Install for Zsh shell
install_zsh() {
    print_status "Installing finder command for Zsh shell..."
    
    local zsh_config_file="$HOME/.zshrc"
    local finder_source_line="source \"$(pwd)/zsh/finder.zsh\""
    
    # Check if already installed
    if grep -q "finder.zsh" "$zsh_config_file" 2>/dev/null; then
        print_warning "Finder function already appears to be installed in $zsh_config_file"
        return 0
    fi
    
    # Add source line to .zshrc
    echo "" >> "$zsh_config_file"
    echo "# Finder shell extension" >> "$zsh_config_file"
    echo "$finder_source_line" >> "$zsh_config_file"
    
    print_success "Zsh function installed. Added source line to: $zsh_config_file"
    print_status "Please reload your shell or run: source $zsh_config_file"
    return 0
}

# Show usage
show_usage() {
    cat << 'EOF'
Usage: ./install.sh [OPTIONS]

Install the finder shell extension for Fish and/or Zsh shells.

Options:
  --fish-only     Install only for Fish shell
  --zsh-only      Install only for Zsh shell
  --auto          Auto-detect shells and install for all available (default)
  -h, --help      Show this help message

Examples:
  ./install.sh              # Auto-detect and install for all available shells
  ./install.sh --fish-only   # Install only for Fish
  ./install.sh --zsh-only    # Install only for Zsh

The installer will:
- Detect your operating system (macOS required)
- Detect available shells (Fish and/or Zsh)
- Install the appropriate shell functions
- Provide instructions for activation
EOF
}

# Main installation function
main() {
    local install_fish=false
    local install_zsh=false
    local auto_detect=true
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --fish-only)
                install_fish=true
                auto_detect=false
                shift
                ;;
            --zsh-only)
                install_zsh=true
                auto_detect=false
                shift
                ;;
            --auto)
                auto_detect=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Check prerequisites
    check_macos
    
    print_status "Starting Finder shell extension installation..."
    
    # Auto-detect shells if not manually specified
    if [[ "$auto_detect" == true ]]; then
        local available_shells
        available_shells=($(detect_shells))
        
        if [[ ${#available_shells[@]} -eq 0 ]]; then
            print_error "No supported shells found (Fish or Zsh required)"
            exit 1
        fi
        
        print_status "Detected shells: ${available_shells[*]}"
        
        for shell in "${available_shells[@]}"; do
            case $shell in
                fish) install_fish=true ;;
                zsh) install_zsh=true ;;
            esac
        done
    fi
    
    # Perform installations
    local success_count=0
    local total_count=0
    
    if [[ "$install_fish" == true ]]; then
        if ! command -v fish >/dev/null 2>&1; then
            print_error "Fish shell not found but requested for installation"
            exit 1
        fi
        total_count=$((total_count + 1))
        if install_fish; then
            success_count=$((success_count + 1))
        fi
    fi
    
    if [[ "$install_zsh" == true ]]; then
        if ! command -v zsh >/dev/null 2>&1; then
            print_error "Zsh shell not found but requested for installation"
            exit 1
        fi
        total_count=$((total_count + 1))
        if install_zsh; then
            success_count=$((success_count + 1))
        fi
    fi
    
    # Installation summary
    echo ""
    print_status "Installation Summary:"
    print_status "====================="
    
    if [[ $success_count -eq $total_count ]]; then
        print_success "Successfully installed for $success_count/$total_count shell(s)"
        echo ""
        print_status "You can now use the 'finder' command to open Finder windows!"
        print_status "Try: finder --help"
        echo ""
        
        if [[ "$install_zsh" == true ]]; then
            print_status "Note: For Zsh, please reload your shell or run:"
            echo "  source ~/.zshrc"
        fi
    else
        print_error "Installation completed with errors: $success_count/$total_count successful"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"