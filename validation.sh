#!/bin/bash

title_valid() {

    while true; do
        read -p "Enter the title: " title

        if [[ -z "$title" ]]; then
            echored "Error: Title cannot be empty."
        elif [[ "$title" == *"|"* ]]; then
            echored "Error: Title cannot contain the '|' character."
        elif [[ "$title" == *","* ]]; then
            echored "Error: Title cannot contain the ',' character."
        elif [[ ! "$title" =~ ^[a-zA-Z] ]]; then
            echored "Error: Title must start with a letter (cannot be only numbers or symbols)."
        else
            break
        fi
    done
}

priority_valid() {
    PS3="Select the priority (1-3): "    
    options=("high" "medium" "low")
    select choice in "${options[@]}"; do
        case "$choice" in
            "high")
                priority=$choice
                echogreen "Priority set to: $priority"
                break
                ;;
            "medium")
                priority=$choice
                echogreen "Priority set to: $priority"
                break
                ;;
            "low")
                priority=$choice
                echogreen "Priority set to: $priority"
                break
                ;;
            *)
                echored "Invalid selection. Please enter 1, 2, or 3."
                ;;
        esac
    done
}

date_valid() {
    while true; do
        read -p "Enter a duedate (e.g., 2026/12/31, 'next Friday', 'tomorrow'): " date_input

        formatted_date=$(date -d "$date_input" "+%Y-%m-%d" 2>/dev/null)

        if [[ $? -eq 0 ]]; then
            duedate=$formatted_date
            echogreen "Date validated and saved as: $duedate"
            break
        else
            echored "Error: '$date_input' is not a recognized date. Please try again."
        fi
    done
}

status_valid() {
    PS3="Select the priority (1-3): "    
    options=("pending" "in-progress" "done")

    select choice in "${options[@]}"; do
        case "$choice" in
            "pending")
                status=$choice
                echogreen "Status set to: $status"
                break
                ;;
            "in-progress")
                status=$choice
                echogreen "Status set to: $status"
                break
                ;;
            "done")
                status=$choice
                echogreen "Status set to: $status"
                break
                ;;
            *)
                echored "Invalid selection. Please enter 1, 2, or 3."
                ;;
        esac
    done
}
