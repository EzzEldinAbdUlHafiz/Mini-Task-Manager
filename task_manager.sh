#!/bin/bash

source ./crud.sh

#Colors
echored()    { echo -e "\033[31m$*\033[0m"; }
echogreen()  { echo -e "\033[32m$*\033[0m"; }
echoyellow() { echo -e "\033[33m$*\033[0m"; }
echoblue()   { echo -e "\033[34m$*\033[0m"; }
echopurple() { echo -e "\033[35m$*\033[0m"; }

add_task(){
    generate_id
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

    # 2. Priority Validation (Choice: high, medium, low)
    while true; do
        read -p "Enter the priority (high/medium/low): " priority
        case "${priority,,}" in  # ,, converts input to lowercase for easier matching
            high|medium|low) break ;;
            *) echo "Error: Please enter 'high', 'medium', or 'low'." ;;
        esac
    done

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

    write_task "$title" "$priority" "$duedate"
}


# MAIN MENU DISPLAY
show_menu() {

    echopurple "=========================================="
    echopurple "            MINI TASK MANAGER"
    echopurple "=========================================="
    echo
    echoblue "1) Add Task"
    echoblue "2) List Tasks"
    echoblue "3) Update Task"
    echoblue "4) Delete Task"
    echoblue "5) Search Task"
    echoblue "6) Reports"
    echoblue "7) Exit"
    echo
}

# REPORTS MENU
show_reports_menu() {

    while true; do

        echopurple "=========================================="
        echopurple "                REPORTS"
        echopurple "=========================================="
        echo
        echoblue "1) Task Summary"
        echoblue "2) Overdue Tasks"
        echoblue "3) Priority Report"
        echoblue "4) Back to Main Menu"
        echo

        read -rp "Enter your choice: " report_choice

        case "$report_choice" in

            1)
                clear
                echo "---- TASK SUMMARY ----"
                report_summary
                ;;

            2)
                clear
                echo "---- OVERDUE TASKS ----"
                report_overdue
                ;;

            3)
                clear
                echo "---- PRIORITY REPORT ----"
                report_priority
                ;;

            4)
                clear
                return
                ;;

            *)
                echored "Invalid option! Please choose 1-4."
                ;;

        esac

    done
}



# MAIN PROGRAM LOOP
main() {

    # Initialize database file if not exists
    clear

    echopurple "=========================================="
    echopurple "        MINI TASK MANAGER STARTED"
    echopurple "=========================================="

    init_db

    # Infinite loop
    while true; do
	show_menu
        read -rp "Enter your choice: " choice

        case "$choice" in

            1)
                clear
                echo "---- ADD TASK ----"
                add_task
                ;;

            2)
                clear
                echoyellow "---- LIST TASKS ----"
                #list_tasks
		read_tasks
                ;;

            3)
                clear
                echoyellow "---- UPDATE TASK ----"
                update_task
                ;;

            4)
                clear
                echoyellow "---- DELETE TASK ----"
                delete_task
                ;;

            5)
                clear
                echoyellow "---- SEARCH TASK ----"
                search_task
                ;;

            6)
                clear
                show_reports_menu
                ;;

            7)
                echo
                echoyellow "Exiting Task Manager..."
                echoyellow "Goodbye!"
                exit 0
                ;;

            *)
                echo
                echored "Invalid option! Please choose between 1-7."
                ;;

        esac

    done
}

# Run Main
main

