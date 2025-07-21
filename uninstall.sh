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
    local installations=()
    
    # Check Fish manual installation
    local fish_functions_dir="$HOME/.config/fish/functions"
    local fish_completions_dir="$HOME/.config/fish/completions"
    if [[ -f "$fish_functions_dir/finder.fish" ]] || [[ -f "$fish_completions_dir/finder.fish" ]]; then
        installations+=("fish-manual")
    fi
    
    # Check Zsh Oh My Zsh installation
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local plugin_dir="$zsh_custom/plugins/finder"
    if [[ -f "$plugin_dir/finder.plugin.zsh" ]]; then
        installations+=("zsh-ohmyzsh")
    fi
    
    # Check Zsh manual installation
    local zsh_config_file="$HOME/.zshrc"
    if [[ -f "$zsh_config_file" ]] && grep -q "finder.plugin.zsh" "$zsh_config_file" 2>/dev/null; then
        installations+=("zsh-manual")
    fi
    
    echo "${installations[@]}"
}

# Uninstall Fish manual installation
uninstall_fish_manual() {
    print_status "Uninstalling finder command from Fish shell (manual installation)..."
    
    local fish_functions_dir="$HOME/.config/fish/functions"
    local fish_completions_dir="$HOME/.config/fish/completions"
    local fish_function_file="$fish_functions_dir/finder.fish"
    local fish_completion_file="$fish_completions_dir/finder.fish"
    local removed_count=0
    
    # Remove function file
    if [[ -f "$fish_function_file" ]]; then
        if rm "$fish_function_file"; then
            print_success "Removed Fish function: $fish_function_file"
            removed_count=$((removed_count + 1))
        else
            print_error "Failed to remove Fish function: $fish_function_file"
            return 1
        fi
    fi
    
    # Remove completion file
    if [[ -f "$fish_completion_file" ]]; then
        if rm "$fish_completion_file"; then
            print_success "Removed Fish completion: $fish_completion_file"
            removed_count=$((removed_count + 1))
        else
            print_error "Failed to remove Fish completion: $fish_completion_file"
            return 1
        fi
    fi
    
    if [[ $removed_count -eq 0 ]]; then
        print_warning "No Fish installation files found"
        return 0
    fi
    
    # Clean up empty directories if they exist and are empty
    for dir in "$fish_completions_dir" "$fish_functions_dir" "$HOME/.config/fish"; do
        if [[ -d "$dir" ]] && [[ -z "$(ls -A "$dir")" ]]; then
            if confirm_action "Remove empty directory ($dir)?"; then
                rmdir "$dir"
                print_success "Removed empty directory: $dir"
            fi
        fi
    done
    
    return 0
}

# Uninstall Fish Fisher installation
uninstall_fish_fisher() {
    print_status "Uninstalling finder command from Fish shell (Fisher installation)..."
    
    if ! command -v fish >/dev/null 2>&1; then
        print_warning "Fish shell not found"
        return 0
    fi
    
    if ! fish -c "fisher --version" >/dev/null 2>&1; then
        print_warning "Fisher not found - cannot uninstall Fisher plugin automatically"
        print_status "If you installed via Fisher, run: fisher remove iamrajjoshi/finder"
        return 0
    fi
    
    print_status "Use Fisher to uninstall:"
    echo "  fisher remove iamrajjoshi/finder"
    print_warning "Note: You need to run this command manually"
    return 0
}

# Uninstall Zsh Oh My Zsh installation
uninstall_zsh_ohmyzsh() {
    print_status "Uninstalling finder command from Zsh (Oh My Zsh plugin)..."
    
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local plugin_dir="$zsh_custom/plugins/finder"
    
    if [[ ! -d "$plugin_dir" ]]; then
        print_warning "Oh My Zsh plugin directory not found: $plugin_dir"
        return 0
    fi
    
    if rm -rf "$plugin_dir"; then
        print_success "Removed Oh My Zsh plugin directory: $plugin_dir"
        print_status "Remember to remove 'finder' from your plugins list in ~/.zshrc"
        print_status "Then reload your shell: source ~/.zshrc"
        return 0
    else
        print_error "Failed to remove Oh My Zsh plugin directory"
        return 1
    fi
}

# Uninstall Zsh manual installation
uninstall_zsh_manual() {
    print_status "Uninstalling finder command from Zsh (manual installation)..."
    
    local zsh_config_file="$HOME/.zshrc"
    
    if [[ ! -f "$zsh_config_file" ]]; then
        print_warning "Zsh config file not found: $zsh_config_file"
        return 0
    fi
    
    # Check if finder.plugin.zsh is referenced
    if ! grep -q "finder.plugin.zsh" "$zsh_config_file"; then
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
    
    # Remove lines containing finder.plugin.zsh and the comment line before it
    awk '
        /# Finder shell extension/ { skip_next = 1; next }
        /finder\.plugin\.zsh/ { if (skip_next) skip_next = 0; next }
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
  --fish-manual   Uninstall Fish manual installation
  --fish-fisher   Show instructions for Fisher uninstall
  --zsh-ohmyzsh   Uninstall Oh My Zsh plugin
  --zsh-manual    Uninstall Zsh manual installation
  --all           Uninstall all detected installations (default)
  --force         Skip confirmation prompts
  -h, --help      Show this help message

Examples:
  ./uninstall.sh                # Uninstall all detected installations
  ./uninstall.sh --fish-manual  # Uninstall only Fish manual installation
  ./uninstall.sh --zsh-ohmyzsh  # Uninstall only Oh My Zsh plugin
  ./uninstall.sh --force        # Uninstall without confirmation prompts

The uninstaller will:
- Detect current installations
- Remove shell functions and configurations
- Clean up empty directories (with confirmation)
- Create backups before modifying configuration files
EOF
}

# Main uninstallation function
main() {
    local uninstall_method=""
    local force_mode=false
    local target_all=true
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --fish-manual)
                uninstall_method="fish-manual"
                target_all=false
                shift
                ;;
            --fish-fisher)
                uninstall_method="fish-fisher"
                target_all=false
                shift
                ;;
            --zsh-ohmyzsh)
                uninstall_method="zsh-ohmyzsh"
                target_all=false
                shift
                ;;
            --zsh-manual)
                uninstall_method="zsh-manual"
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
    local installations
    installations=($(check_installation))
    
    if [[ ${#installations[@]} -eq 0 ]]; then
        print_warning "Finder extension does not appear to be installed"
        exit 0
    fi
    
    print_status "Current installations detected:"
    for installation in "${installations[@]}"; do
        case $installation in
            fish-manual) print_status "  ✓ Fish shell: manual installation" ;;
            zsh-ohmyzsh) print_status "  ✓ Zsh shell: Oh My Zsh plugin" ;;
            zsh-manual) print_status "  ✓ Zsh shell: manual installation" ;;
        esac
    done
    echo ""
    
    # Determine what to uninstall
    local methods_to_uninstall=()
    if [[ "$target_all" == true ]]; then
        methods_to_uninstall=("${installations[@]}")
    else
        # Check if specified method is actually installed
        for installation in "${installations[@]}"; do
            if [[ "$installation" == "$uninstall_method" ]]; then
                methods_to_uninstall=("$uninstall_method")
                break
            fi
        done
        
        if [[ ${#methods_to_uninstall[@]} -eq 0 ]]; then
            print_warning "Specified installation method '$uninstall_method' not found"
            exit 0
        fi
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
    local total_count=${#methods_to_uninstall[@]}
    
    for method in "${methods_to_uninstall[@]}"; do
        case $method in
            fish-manual)
                if uninstall_fish_manual; then
                    success_count=$((success_count + 1))
                fi
                ;;
            fish-fisher)
                if uninstall_fish_fisher; then
                    success_count=$((success_count + 1))
                fi
                ;;
            zsh-ohmyzsh)
                if uninstall_zsh_ohmyzsh; then
                    success_count=$((success_count + 1))
                fi
                ;;
            zsh-manual)
                if uninstall_zsh_manual; then
                    success_count=$((success_count + 1))
                fi
                ;;
        esac
    done
    
    # Uninstallation summary
    echo ""
    print_status "Uninstallation Summary:"
    print_status "======================="
    
    if [[ $success_count -eq $total_count ]]; then
        print_success "Successfully uninstalled $success_count/$total_count installation(s)"
        print_status "The finder command has been removed from your system"
    else
        print_error "Uninstallation completed with errors: $success_count/$total_count successful"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"