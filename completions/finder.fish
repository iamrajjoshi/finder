# Completions for finder command
complete -c finder -s h -l help -d "Show help message"
complete -c finder -l version -d "Show version information"
complete -c finder -a "(__fish_complete_directories)" -d "Directory to open"