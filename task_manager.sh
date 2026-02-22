#!/bin/bash

#Colors
echored()    { echo -e "\033[31m$*\033[0m"; }
echogreen()  { echo -e "\033[32m$*\033[0m"; }
echoyellow() { echo -e "\033[33m$*\033[0m"; }
echoblue()   { echo -e "\033[34m$*\033[0m"; }
echopurple() { echo -e "\033[35m$*\033[0m"; }

source ./crud.sh
source ./validation.sh
source ./reports.sh

DB_FILE="database"

init_db() {
        if [ -f $DB_FILE ]; then
                echo "$DB_FILE exists."
        else
                echo -e "$DB_FILE does not exist \n creating the $DB_FILE"
                touch $DB_FILE
                echo "ID | TITLE | PRIORITY | DUE-DATE | STATUS" > $DB_FILE
        fi
}

list_tasks() {
	while true; do
                echo
                PS3="Choose what to list: "
                options=("List All Tasks" "Filter By Priority" "Filter By status" "Back to Main Menu")
                select list_choice in "${options[@]}"; do
                    case "$list_choice" in
                        "List All Tasks")
                                clear
                                read_all_from_db
                                break
                                ;;
                        "Filter By Priority")
                                clear
                                read_filter_by_priority
                                break
                                ;;

                        "Filter By status")
                                clear
                                read_filter_by_status
                                break
                                ;;

                        "Back to Main Menu")
                                break 2
                                ;;

                        *)
                                echored "Invalid option! Please choose a number from the menu."
                                ;;

                    esac
                done
        done
}

add_task(){
    generate_id
    title_valid
    priority_valid
    date_valid
    write_task_in_db "$title" "$priority" "$duedate"
}

update_task() {
	read_all_from_db
        read -p "Enter the task ID: " task_id

        line_num=$(awk -v id="$task_id" '$1 == id {print NR}' $DB_FILE)

        if [ -z "$line_num" ]; then
                echo "Error: Task ID not found."
                return
        fi

	title=$(awk -v id="$task_id" -F '[ \t]*\\|[ \t]*' '$1 == id {print $2}' $DB_FILE)
        priority=$(awk -v id="$task_id"  -F '[ \t]*\\|[ \t]*' '$1 == id {print $3}' $DB_FILE)
        duedate=$(awk -v id="$task_id"  -F '[ \t]*\\|[ \t]*' '$1 == id {print $4}' $DB_FILE)
        status=$(awk -v id="$task_id"  -F '[ \t]*\\|[ \t]*' '$1 == id {print $5}' $DB_FILE)

	while true; do
                echo
                PS3="Choose what you want to update: "
                options=("Update Title" "Update Priority" "Update Due Date" "Update Status" "Back to Main Menu")
                select update_choice in "${options[@]}"; do
                    case "$update_choice" in
                        "Update Title")
                                clear
                                echo "---- UPDATE TITLE ----"
                                title_valid
				break
                                ;;
                        "Update Priority")
                                clear
                                echo "---- UPDATE PRIORITY ----"
                                priority_valid
				break
                                ;;

                        "Update Due Date")
                                clear
                                echo "---- UPDATE DUE DATE ----"
                                date_valid
				break
                                ;;

                        "Update Status")
                                clear
                                echo "---- UPDATE STATUS ----"
                                status_valid
				break
                                ;;
                        "Back to Main Menu")
                                break 2
                                ;;

                        *)
                                echored "Invalid option! Please choose a number from the menu."
                                ;;

                    esac
                done
        done

	update_task_in_db "$line_num" "$title" "$priority" "$duedate" "$status" "$task_id"

}

delete_task() {
	read_all_from_db
	read -p "Enter the task ID:: " task_id

        line_num=$(awk -v id="${task_id}" '$1 == id {print NR}' $DB_FILE)
	if [ -z "$line_num" ]; then
                echo "Error: Task ID not found."
                return
        fi

	while true; do
		echo "Are you sure you want to delete task ID number "${task_id}
                echo
                PS3="Your choice: "
                options=("YES" "NO")
                select delete_choice in "${options[@]}"; do
                    case "$delete_choice" in
                        "YES")
                                clear
				delete_task_from_db "${line_num}"
                                break 2
                                ;;
                        "NO")
				clear
                                break 2
                                ;;

                        *)
                                echored "Invalid option! Please choose YES or NO."
                                ;;

                    esac
                done
        done
}

search_task() {
	title_valid
	clear
	search_in_db
    read -p "Press any key to continue"
}

export_to_CSV() {
        read -rp "Enter the file name:" filename
        export_db_to_CSV "${filename}"
        echo "${filename}.csv has been created"
                                        
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
    echoblue "7) Export To A CSV File"
    echoblue "8) Sort tasks"
    echoblue "9) Exit"
    echo
}

# REPORTS MENU
show_reports_menu() {

    while true; do
        echopurple "=========================================="
        echopurple "                REPORTS"
        echopurple "=========================================="
        echo
        PS3="Enter your choice: "
        options=("Task Summary" "Overdue Tasks" "Priority Report" "Back to Main Menu")
        select report_choice in "${options[@]}"; do
            case "$report_choice" in

                "Task Summary")
                    clear
                    echo "---- TASK SUMMARY ----"
                    report_summary
                    break
                    ;;

                "Overdue Tasks")
                    clear
                    echo "---- OVERDUE TASKS ----"
                    report_overdue
                    break
                    ;;

                "Priority Report")
                    clear
                    echo "---- PRIORITY REPORT ----"
                    report_priority
                    break
                    ;;

                "Back to Main Menu")
                    clear
                    return
                    ;;

                *)
                    echored "Invalid option! Please choose a number from the menu."
                    ;;

            esac
        done
    done
}

sorting_menu() {

    while true; do
        echopurple "=========================================="
        echopurple "                SORTING"
        echopurple "=========================================="
        echo
        PS3="Enter your choice: "
        options=("Sort By Date" "Sort By Priority" "Back to Main Menu")
        select report_choice in "${options[@]}"; do
            case "$report_choice" in

                "Sort By Date")
                    clear
                    echo "---- Sort By Date ----"
                    sort_by_date
                    break
                    ;;

                "Sort By Priority")
                    clear
                    echo "---- Sort By Priority ----"
                    sort_by_priority
                    break
                    ;;

                "Back to Main Menu")
                    clear
                    return
                    ;;

                *)
                    echored "Invalid option! Please choose a number from the menu."
                    ;;

            esac
        done
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
        clear
        echopurple "=========================================="
        echopurple "            MINI TASK MANAGER"
        echopurple "=========================================="
        echo

        # Using select for the main menu
        PS3="Enter your choice: "
        options=("Add Task" "List Tasks" "Update Task" "Delete Task" "Search Task" "Reports" "Export To A CSV File" "Sort tasks" "Exit")
        select choice in "${options[@]}"; do
            case "$choice" in
                "Add Task")
                    clear
                    echo "---- ADD TASK ----"
                    add_task
                    break
                    ;;

                "List Tasks")
                    clear
                    echoyellow "---- LIST TASKS ----"
                    list_tasks
                    break
                    ;;

                "Update Task")
                    clear
                    echoyellow "---- UPDATE TASK ----"
                    update_task
                    break
                    ;;

                "Delete Task")
                    clear
                    echoyellow "---- DELETE TASK ----"
                    delete_task
                    break
                    ;;

                "Search Task")
                    clear
                    echoyellow "---- SEARCH TASK ----"
                    search_task
                    break
                    ;;

                "Reports")
                    clear
                    show_reports_menu
                    break
                    ;;
                    
                "Export To A CSV File")
                    clear
                    export_to_CSV
                    break
                    ;;

                "Sort tasks")
                    clear
                    sorting_menu
                    break
                    ;;

                "Exit")
                    echo
                    echoyellow "Exiting Task Manager..."
                    echoyellow "Goodbye!"
                    exit 0
                    ;;

                *)
                    echo
                    echored "Invalid option! Please choose a number from the menu."
                    ;;
            esac
        done # End of select loop
    done # End of main while true loop
}

# Run Main
main

