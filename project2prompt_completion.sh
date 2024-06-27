#!/usr/bin/env bash

_script_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="-i --ignore -a --all -o --output -d --output-dir -s --scrub-comments -h --help"

    # Function to check if an option has been used
    option_used() {
        local opt="$1"
        for word in "${COMP_WORDS[@]}"; do
            if [[ "$word" == "$opt" ]]; then
                return 0
            fi
        done
        return 1
    }

    # Function to get unused options
    get_unused_opts() {
        local unused_opts=""
        for opt in $opts; do
            if ! option_used "$opt"; then
                unused_opts+="$opt "
            fi
        done
        echo "$unused_opts"
    }

    case "${prev}" in
        -i|--ignore)
            # Suggest file patterns or nothing
            COMPREPLY=()
            return 0
            ;;
        -o|--output)
            # Use filename completion
            COMPREPLY=( $(compgen -f "${cur}") )
            return 0
            ;;
        -d|--output-dir)
            # Use directory completion
            COMPREPLY=( $(compgen -d "${cur}") )
            return 0
            ;;
        *)
            ;;
    esac

    if [[ ${cur} == -* ]] ; then
        # Suggest only unused options
        COMPREPLY=( $(compgen -W "$(get_unused_opts)" -- "${cur}") )
        return 0
    fi

    # Check if we're completing the target directory argument
    local has_target_dir=false
    for word in "${COMP_WORDS[@]}"; do
        if [[ "$word" != -* && "$word" != "${COMP_WORDS[0]}" ]]; then
            has_target_dir=true
            break
        fi
    done

    if ! $has_target_dir; then
        # Suggest directories for the target directory argument
        COMPREPLY=( $(compgen -d "${cur}") )
    else
        # No more arguments to suggest
        COMPREPLY=()
    fi
}

complete -F _script_completion ./your_script_name.sh
