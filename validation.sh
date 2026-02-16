#!/bin/bash

title_valid() {
        # 1. Title Validation (No pipes, not empty)
    while true; do
        read -p "Enter the title: " title
        if [[ -z "$title" ]]; then
            echo "Error: Title cannot be empty."
        elif [[ "$title" == *"|"* ]]; then
            echo "Error: Title cannot contain the '|' character."
        else
            break
        fi
    done
}

priority_valid() {
        # 2. Priority Validation (Choice: high, medium, low)
    while true; do
        read -p "Enter the priority (high/medium/low): " priority
        case "${priority,,}" in  # ,, converts input to lowercase for easier matching
            high|medium|low) break ;;
            *) echo "Error: Please enter 'high', 'medium', or 'low'." ;;
        esac
    done
}

date_valid() {
        # 3. Date Validation: Accept any input and normalize via 'date' command
    while true; do
        read -p "Enter a duedate (e.g., 2026/12/31, 'next Friday', 'tomorrow'): " date_input

        # This takes the user input and tries to format it to YYYY/MM/DD
        # 2>/dev/null hides the system error so we can show our own
        formatted_date=$(date -d "$date_input" "+%Y/%m/%d" 2>/dev/null)

        if [[ $? -eq 0 ]]; then
            duedate=$formatted_date
            echo "Date validated and saved as: $duedate"
            break
        else
            echo "Error: '$date_input' is not a recognized date. Please try again."
        fi
    done
}

status_valid() {
	while true; do
	    read -p "Enter status (pending/in-progress/done): " status

    		# Convert to lowercase to make it user-friendly
    		status_lower="${status,,}"

    		case "$status_lower" in
        		pending|in-progress|done)
            			status="$status_lower"
            			break
            			;;
        		*)
            			echo "Error: Invalid status. Please enter 'pending', 'in-progress', or 'done'."
            			;;
    		esac
	done
}
