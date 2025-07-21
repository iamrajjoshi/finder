#!/bin/bash

# Finder Shell Extension Uninstaller
# Removes the finder command from Fish and/or Zsh shells

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

# Prompt for confirmation
confirm_action() {
    local message="$1"
    local response
    
    echo -e "${YELLOW}[CONFIRM]${NC} $message (y/N): "
    read -r response
    case "$response" in
        [yY]|[yY][eE][sS])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Check what's currently installed
check_installation() {
    local fish_installed=false
    local zsh_installed=false
    
    # Check Fish installation
    local fish_functions_dir="$HOME/.config/fish/functions"
    if [[ -f "$fish_functions_dir/finder.fish" ]]; then
        fish_installed=true
    fi
    
    # Check Zsh installation
    local zsh_config_file="$HOME/.zshrc"
    if [[ -f "$zsh_config_file" ]] && grep -q "finder.zsh" "$zsh_config_file" 2>/dev/null; then
        zsh_installed=true
    fi
    
    echo "$fish_installed $zsh_installed"
}

# Uninstall from Fish shell
uninstall_fish() {
    print_status "Uninstalling finder command from Fish shell..."
    
    local fish_functions_dir="$HOME/.config/fish/functions"
    local fish_function_file="$fish_functions_dir/finder.fish"
    
    if [[ ! -f "$fish_function_file" ]]; then
        print_warning "Fish function not found at: $fish_function_file"
        return 0
    fi
    
    if rm "$fish_function_file"; then
        print_success "Removed Fish function: $fish_function_file"
        
        # Clean up empty directories if they exist and are empty
        if [[ -d "$fish_functions_dir" ]] && [[ -z "$(ls -A "$fish_functions_dir")" ]]; then
            if confirm_action "Remove empty Fish functions directory ($fish_functions_dir)?"; then
                rmdir "$fish_functions_dir"
                print_success "Removed empty directory: $fish_functions_dir"
                
                # Check if parent config directory is empty
                local fish_config_dir="$HOME/.config/fish"
                if [[ -d "$fish_config_dir" ]] && [[ -z "$(ls -A "$fish_config_dir")" ]]; then
                    if confirm_action "Remove empty Fish config directory ($fish_config_dir)?"; then
                        rmdir "$fish_config_dir"
                        print_success "Removed empty directory: $fish_config_dir"
                    fi
                fi
            fi
        fi
        
        return 0
    else
        print_error "Failed to remove Fish function"
        return 1
    fi
}

# Uninstall from Zsh shell
uninstall_zsh() {
    print_status "Uninstalling finder command from Zsh shell..."
    
    local zsh_config_file="$HOME/.zshrc"
    
    if [[ ! -f "$zsh_config_file" ]]; then
        print_warning "Zsh config file not found: $zsh_config_file"
        return 0
    fi
    
    # Check if finder.zsh is referenced
    if ! grep -q "finder.zsh" "$zsh_config_file"; then
        print_warning "Finder extension not found in: $zsh_config_file"
        return 0
    fi
    
    # Create backup
    local backup_file="${zsh_config_file}.backup.$(date +%Y%m%d_%H%M%S)"
    if cp "$zsh_config_file" "$backup_file"; then
        print_status "Created backup: $backup_file"
    else
        print_error "Failed to create backup of $zsh_config_file"
        return 1
    fi
    
    # Remove finder-related lines
    local temp_file
    temp_file=$(mktemp)
    
    # Remove lines containing finder.zsh and the comment line before it
    awk '
        /# Finder shell extension/ { skip_next = 1; next }
        /finder\.zsh/ { if (skip_next) skip_next = 0; next }
        { skip_next = 0; print }
    ' "$zsh_config_file" > "$temp_file"
    
    # Replace original file
    if mv "$temp_file" "$zsh_config_file"; then
        print_success "Removed finder extension from: $zsh_config_file"
        print_status "Backup saved as: $backup_file"
        print_status "Please reload your shell or run: source $zsh_config_file"
        return 0
    else
        print_error "Failed to update $zsh_config_file"
        # Restore from backup
        mv "$backup_file" "$zsh_config_file"
        rm -f "$temp_file"
        return 1
    fi
}

# Show usage
show_usage() {
    cat << 'EOF'
Usage: ./uninstall.sh [OPTIONS]

Uninstall the finder shell extension from Fish and/or Zsh shells.

Options:
  --fish-only     Uninstall only from Fish shell
  --zsh-only      Uninstall only from Zsh shell
  --all           Uninstall from all shells (default)
  --force         Skip confirmation prompts
  -h, --help      Show this help message

Examples:
  ./uninstall.sh              # Uninstall from all detected shells
  ./uninstall.sh --fish-only   # Uninstall only from Fish
  ./uninstall.sh --zsh-only    # Uninstall only from Zsh
  ./uninstall.sh --force       # Uninstall without confirmation prompts

The uninstaller will:
- Detect current installations
- Remove shell functions and configurations
- Clean up empty directories (with confirmation)
- Create backups before modifying configuration files
EOF
}

# Main uninstallation function
main() {
    local uninstall_fish=false
    local uninstall_zsh=false
    local force_mode=false
    local target_all=true
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --fish-only)
                uninstall_fish=true
                target_all=false
                shift
                ;;
            --zsh-only)
                uninstall_zsh=true
                target_all=false
                shift
                ;;
            --all)
                target_all=true
                shift
                ;;
            --force)
                force_mode=true
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
    
    print_status "Starting Finder shell extension uninstallation..."
    
    # Check current installation status
    local installation_status
    installation_status=($(check_installation))
    local fish_installed="${installation_status[0]}"
    local zsh_installed="${installation_status[1]}"
    
    if [[ "$fish_installed" == false && "$zsh_installed" == false ]]; then
        print_warning "Finder extension does not appear to be installed"
        exit 0
    fi
    
    print_status "Current installation status:"
    [[ "$fish_installed" == true ]] && print_status "  ✓ Fish shell: installed"
    [[ "$zsh_installed" == true ]] && print_status "  ✓ Zsh shell: installed"
    echo ""
    
    # Determine what to uninstall
    if [[ "$target_all" == true ]]; then
        uninstall_fish="$fish_installed"
        uninstall_zsh="$zsh_installed"
    fi
    
    # Confirmation prompt (unless force mode)
    if [[ "$force_mode" == false ]]; then
        local confirm_message="Are you sure you want to uninstall the finder extension?"
        if ! confirm_action "$confirm_message"; then
            print_status "Uninstallation cancelled"
            exit 0
        fi
    fi
    
    # Perform uninstallation
    local success_count=0
    local total_count=0
    
    if [[ "$uninstall_fish" == true ]]; then
        total_count=$((total_count + 1))
        if uninstall_fish; then
            success_count=$((success_count + 1))
        fi
    fi
    
    if [[ "$uninstall_zsh" == true ]]; then
        total_count=$((total_count + 1))
        if uninstall_zsh; then
            success_count=$((success_count + 1))
        fi
    fi
    
    # Uninstallation summary
    echo ""
    print_status "Uninstallation Summary:"
    print_status "======================="
    
    if [[ $success_count -eq $total_count ]]; then
        print_success "Successfully uninstalled from $success_count/$total_count shell(s)"
        print_status "The finder command has been removed from your system"
    else
        print_error "Uninstallation completed with errors: $success_count/$total_count successful"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"