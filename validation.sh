#!/bin/bash

title_valid() {
    # 1. Title Validation (No pipes, not empty)
    while true; do
        read -p "Enter the title: " title
        if [[ -z "$title" ]]; then
            echored "Error: Title cannot be empty."
        elif [[ "$title" == *"|"* ]]; then
            echored "Error: Title cannot contain the '|' character."
        elif [[ "$title" == *","* ]]; then
            echored "Error: Title cannot contain the ',' character."
        else
            break
        fi
    done
}

priority_valid() {
    while true; do
        read -p "Enter the priority (high/medium/low): " priority
        case "${priority,,}" in
            high|medium|low) break ;;
            *) echored "Error: Please enter 'high', 'medium', or 'low'." ;;
        esac
    done
}

date_valid() {
    while true; do
        read -p "Enter a duedate (e.g., 2026/12/31, 'next Friday', 'tomorrow'): " date_input

        formatted_date=$(date -d "$date_input" "+%Y/%m/%d" 2>/dev/null)

        if [[ $? -eq 0 ]]; then
            duedate=$formatted_date
            echo "Date validated and saved as: $duedate"
            break
        else
            echored "Error: '$date_input' is not a recognized date. Please try again."
        fi
    done
}

status_valid() {
    while true; do
        read -p "Enter status (pending/in-progress/done): " status

        status_lower="${status,,}" # Convert to lowercase to make it user-friendly

        case "$status_lower" in
            pending|in-progress|done)
                status="$status_lower"
                break
                ;;
            *)
                echored "Error: Invalid status. Please enter 'pending', 'in-progress', or 'done'."
                ;;
        esac
    done
}
