#!/bin/bash

# Finder Shell Extension Installer
# Installs the finder command for Fish and/or Zsh shells using their respective package managers

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

# Detect available shells and their package managers
detect_shells() {
    local shells=()
    
    # Check for Fish with Fisher
    if command -v fish >/dev/null 2>&1; then
        if fish -c "fisher --version" >/dev/null 2>&1; then
            shells+=("fish-fisher")
        else
            shells+=("fish-manual")
        fi
    fi
    
    # Check for Zsh with Oh My Zsh
    if command -v zsh >/dev/null 2>&1; then
        if [[ -d "$HOME/.oh-my-zsh" ]]; then
            shells+=("zsh-ohmyzsh")
        else
            shells+=("zsh-manual")
        fi
    fi
    
    echo "${shells[@]}"
}

# Install for Fish shell using Fisher
install_fish_fisher() {
    print_status "Installing finder command for Fish shell using Fisher..."
    
    if ! command -v fish >/dev/null 2>&1; then
        print_error "Fish shell not found"
        return 1
    fi
    
    if ! fish -c "fisher --version" >/dev/null 2>&1; then
        print_error "Fisher not found. Please install Fisher first:"
        echo "  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
        return 1
    fi
    
    # Install using Fisher (assuming this will be published as a Fisher plugin)
    print_status "Use Fisher to install from GitHub:"
    echo "  fisher install iamrajjoshi/finder"
    print_warning "Note: This requires the plugin to be published on GitHub"
    return 0
}

# Install for Fish shell manually
install_fish_manual() {
    print_status "Installing finder command for Fish shell manually..."
    
    local fish_config_dir="$HOME/.config/fish"
    local fish_functions_dir="$fish_config_dir/functions"
    local fish_completions_dir="$fish_config_dir/completions"
    
    # Create Fish directories if they don't exist
    mkdir -p "$fish_functions_dir" "$fish_completions_dir"
    
    # Copy the Fish function and completion
    if cp "functions/finder.fish" "$fish_functions_dir/finder.fish" && \
       cp "completions/finder.fish" "$fish_completions_dir/finder.fish"; then
        print_success "Fish function and completion installed"
        print_status "Function: $fish_functions_dir/finder.fish"
        print_status "Completion: $fish_completions_dir/finder.fish"
        return 0
    else
        print_error "Failed to install Fish function"
        return 1
    fi
}

# Install for Zsh with Oh My Zsh
install_zsh_ohmyzsh() {
    print_status "Installing finder command for Zsh using Oh My Zsh..."
    
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        print_error "Oh My Zsh not found. Please install Oh My Zsh first:"
        echo '  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
        return 1
    fi
    
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local plugin_dir="$zsh_custom/plugins/finder"
    
    # Create plugin directory
    mkdir -p "$plugin_dir"
    
    # Copy the plugin file
    if cp "plugins/finder/finder.plugin.zsh" "$plugin_dir/finder.plugin.zsh"; then
        print_success "Oh My Zsh plugin installed to: $plugin_dir"
        print_status "Add 'finder' to your plugins list in ~/.zshrc:"
        echo "  plugins=(... finder)"
        print_status "Then reload your shell: source ~/.zshrc"
        return 0
    else
        print_error "Failed to install Oh My Zsh plugin"
        return 1
    fi
}

# Install for Zsh manually
install_zsh_manual() {
    print_status "Installing finder command for Zsh manually..."
    
    local zsh_config_file="$HOME/.zshrc"
    local finder_source_line="source \"$(pwd)/plugins/finder/finder.plugin.zsh\""
    
    # Check if already installed
    if grep -q "finder.plugin.zsh" "$zsh_config_file" 2>/dev/null; then
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
  --fish-fisher   Install for Fish using Fisher (recommended for Fish)
  --fish-manual   Install for Fish manually
  --zsh-ohmyzsh   Install for Zsh using Oh My Zsh (recommended for Zsh)
  --zsh-manual    Install for Zsh manually  
  --auto          Auto-detect shells and package managers (default)
  -h, --help      Show this help message

Examples:
  ./install.sh                    # Auto-detect and install appropriately
  ./install.sh --fish-fisher      # Install for Fish using Fisher
  ./install.sh --zsh-ohmyzsh      # Install for Zsh using Oh My Zsh

The installer will:
- Detect your operating system (macOS required)
- Detect available shells and package managers
- Install using the appropriate method for each shell
- Provide setup instructions for each method
EOF
}

# Main installation function
main() {
    local install_method=""
    local auto_detect=true
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --fish-fisher)
                install_method="fish-fisher"
                auto_detect=false
                shift
                ;;
            --fish-manual)
                install_method="fish-manual"
                auto_detect=false
                shift
                ;;
            --zsh-ohmyzsh)
                install_method="zsh-ohmyzsh"
                auto_detect=false
                shift
                ;;
            --zsh-manual)
                install_method="zsh-manual"
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
        
        print_status "Detected installation methods: ${available_shells[*]}"
        
        # Install for all detected methods
        local success_count=0
        local total_count=${#available_shells[@]}
        
        for method in "${available_shells[@]}"; do
            case $method in
                fish-fisher) 
                    if install_fish_fisher; then
                        success_count=$((success_count + 1))
                    fi
                    ;;
                fish-manual) 
                    if install_fish_manual; then
                        success_count=$((success_count + 1))
                    fi
                    ;;
                zsh-ohmyzsh) 
                    if install_zsh_ohmyzsh; then
                        success_count=$((success_count + 1))
                    fi
                    ;;
                zsh-manual) 
                    if install_zsh_manual; then
                        success_count=$((success_count + 1))
                    fi
                    ;;
            esac
        done
    else
        # Install for specific method
        local success_count=0
        local total_count=1
        
        case $install_method in
            fish-fisher)
                if install_fish_fisher; then
                    success_count=1
                fi
                ;;
            fish-manual)
                if install_fish_manual; then
                    success_count=1
                fi
                ;;
            zsh-ohmyzsh)
                if install_zsh_ohmyzsh; then
                    success_count=1
                fi
                ;;
            zsh-manual)
                if install_zsh_manual; then
                    success_count=1
                fi
                ;;
            *)
                print_error "Invalid installation method: $install_method"
                exit 1
                ;;
        esac
    fi
    
    # Installation summary
    echo ""
    print_status "Installation Summary:"
    print_status "====================="
    
    if [[ $success_count -eq $total_count ]]; then
        print_success "Successfully installed using $success_count/$total_count method(s)"
        echo ""
        print_status "You can now use the 'finder' command to open Finder windows!"
        print_status "Try: finder --help"
    else
        print_error "Installation completed with errors: $success_count/$total_count successful"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"