#!/usr/bin/env bash

# Search priority for commands file
COMMANDS_FILE=""
SEARCH_LOCATIONS=(
    "$XDG_DATA_HOME/uc/useful_commands"
    "/home/$USER/.local/share/uc/useful_commands"
    "/home/$USER/.useful_commands"
    "/home/$USER/useful_commands"
)

# Find the first existing file
for FILE in "${SEARCH_LOCATIONS[@]}"; do
    if [ -f "$FILE" ]; then
        COMMANDS_FILE="$FILE"
        break
    fi
done

# Ensure a valid file has been found
if [ -z "$COMMANDS_FILE" ]; then
    echo "Input file not found in any expected location." >&2
    exit 1
fi

# If no args given, print entire file
if [ "$#" -eq 0 ]; then
    cat "$COMMANDS_FILE"
    exit 0
fi

# Determine search mode
if [ "$1" == "-c" ]; then
    if [ -z "$2" ]; then
        echo "Error: Missing search pattern for category match." >&2
        exit 1
    fi
    SEARCH_PATTERN="$2"
    MATCH_CATEGORY=true
else
    SEARCH_PATTERN="$1"
    MATCH_CATEGORY=false
fi

# Determine whether search if case-sensitive or not
# (Only if input contains uppercase letters)
if [[ "$SEARCH_PATTERN" =~ [A-Z] ]]; then
    GREP_OPTIONS="--text -P -m 1"
else
    GREP_OPTIONS="--text -i -P -m 1"
fi

if [ "$MATCH_CATEGORY" = true ]; then
    # Find first matching category
    CATEGORY=$(grep $GREP_OPTIONS "^[^[:space:]].*$SEARCH_PATTERN" "$COMMANDS_FILE" |
        head -n 1)

    # If no match, exist silently
    if [ -z "$CATEGORY" ]; then
        exit 0
    fi

    # Print the matched category and all following lines until the next category
    awk -v pattern="$CATEGORY" 'BEGIN { printing=0 }
        index($0, pattern) > 0 { printing=1 }
        /^[^[:space:]]/ && NR>1 && printing==1 { exit }
        printing' "$COMMANDS_FILE"
else
    # Find first matching entry (ignoring catregories)
    ENTRY=$(grep $GREP_OPTIONS "^[[:space:]].*$SEARCH_PATTERN" "$COMMANDS_FILE")

    # If no match, exit silently
    if [ -z "$ENTRY" ]; then
        exit 0
    fi

    # Print the matched entry along with its category
    awk -v entry="$ENTRY" 'BEGIN { printing=0 }
        /^[^[:space:]]/ { category=$0 }
        $0 == entry { printing=1; print category; print $0 }
        printing && /^[^[:space:]]/ && NR>1 { exit }' "$COMMANDS_FILE"
fi
