#!/usr/bin/env fish

function finder --description "Open Finder windows on macOS"
    # Check if running on macOS
    if test (uname) != "Darwin"
        echo "Error: finder command only works on macOS" >&2
        return 1
    end

    # Show help if requested
    if contains -- --help $argv; or contains -- -h $argv
        echo "Usage: finder [PATH...]"
        echo ""
        echo "Open Finder windows on macOS"
        echo ""
        echo "Arguments:"
        echo "  PATH    Path to open in Finder (default: current directory)"
        echo "          Can be a file (reveals in Finder) or directory (opens in Finder)"
        echo "          Supports multiple paths, relative paths, and tilde expansion"
        echo ""
        echo "Options:"
        echo "  -h, --help    Show this help message"
        echo "  --version     Show version information"
        echo ""
        echo "Examples:"
        echo "  finder                    # Open current directory"
        echo "  finder ~/Desktop          # Open Desktop folder"
        echo "  finder . ..               # Open current and parent directories"
        echo "  finder /path/to/file.txt  # Reveal file in Finder"
        echo "  finder ~/Documents ~/Downloads  # Open multiple directories"
        return 0
    end

    # Show version if requested
    if contains -- --version $argv
        echo "finder 1.0.0"
        echo "A simple shell extension to open Finder windows on macOS"
        return 0
    end

    # Use current directory if no arguments provided
    set -l paths $argv
    if test (count $paths) -eq 0
        set paths "."
    end

    # Process each path
    for path in $paths
        # Expand tilde and resolve path
        set -l expanded_path (eval echo $path)
        set -l resolved_path (realpath $expanded_path 2>/dev/null)
        
        # Check if path exists
        if not test -e $expanded_path
            echo "Error: Path does not exist: $path" >&2
            continue
        end

        # Use resolved path if available, otherwise use expanded path
        if test -n "$resolved_path"
            set expanded_path $resolved_path
        end

        # Check if it's a file or directory and open accordingly
        if test -f $expanded_path
            # It's a file - reveal it in Finder
            open -R $expanded_path
            if test $status -eq 0
                echo "Revealed file in Finder: $path"
            else
                echo "Error: Failed to reveal file: $path" >&2
            end
        else if test -d $expanded_path
            # It's a directory - open it in Finder
            open $expanded_path
            if test $status -eq 0
                echo "Opened directory in Finder: $path"
            else
                echo "Error: Failed to open directory: $path" >&2
            end
        else
            echo "Error: Path is neither a file nor directory: $path" >&2
        end
    end
end

