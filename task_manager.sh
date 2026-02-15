#!/bin/bash

#Colors
echored()    { echo -e "\033[31m$*\033[0m"; }
echogreen()  { echo -e "\033[32m$*\033[0m"; }
echoyellow() { echo -e "\033[33m$*\033[0m"; }
echoblue()   { echo -e "\033[34m$*\033[0m"; }
echopurple() { echo -e "\033[35m$*\033[0m"; }

DB_FILE="database"
NEW_TASK=""
NEW_ID=""

TODAY=$(date +%F)

init_db() {
	if [ -f $DB_FILE ]; then
    		echo "$DB_FILE exists."
	else
    		echo -e "$DB_FILE does not exist \n creating the $DB_FILE"
    		touch $DB_FILE
		echo "ID|TITLE|PRIORITY|DUE-DATE|STATUS" > $DB_FILE
	fi
}

read_tasks() {
	awk '{print $0}' "$DB_FILE" | column -t -s '|' -o ' | '
}

generate_id() {
	last_id=$(awk 'END {print $1}' "$DB_FILE")

	if [[ $last_id =~ ^[0-9]+$ ]]; then
		NEW_ID=$((last_id + 1))
	else
		NEW_ID=1
	fi
}

write_task() {
	echo "${NEW_ID} | ${1} | ${2} | ${3} | pending" >> "$DB_FILE"
	echo "Task added successfully."
	return
}

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

    # 3. Date Validation (YYYY/MM/DD)
    while true; do
        read -p "Enter a duedate (YYYY/MM/DD): " duedate
        # Regex: 4 digits / 2 digits / 2 digits
        if [[ "$duedate" =~ ^[0-9]{4}/[0-9]{2}/[0-9]{2}$ ]]; then
            break
        else
            echo "Error: Date must be in YYYY/MM/DD format."
        fi
    done

    write_task "$title" "$priority" "$duedate"
}

delete_task() {
	read -p "Enter the task ID:: " task_id
	line_num=$(awk '{print $1}' database | grep -n "$task_id" | cut -d: -f1)
	sed -i "${line_num}d" "$DB_FILE"	
}

update_task() {
    read -p "Enter the task ID: " task_id

    line_num=$(awk -v id="$task_id" '$1 == id {print NR}' $DB_FILE)

    if [ -z "$line_num" ]; then
        echo "Error: Task ID not found."
        return
    fi

    read -p "Enter the title: " title
    read -p "Enter the priority: " priority
    read -p "Enter a duedate: " duedate
    read -p "Enter the status: " status
    
    formatted_line="${task_id} | ${title} | ${priority} | ${duedate} | ${status}"
    sed -i "${line_num}s#.*#${formatted_line}#" "$DB_FILE"

    echo "Task updated successfully."
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

