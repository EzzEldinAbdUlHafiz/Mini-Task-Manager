#!/bin/bash

source ./crud.sh
source ./validation.sh


#Colors
echored()    { echo -e "\033[31m$*\033[0m"; }
echogreen()  { echo -e "\033[32m$*\033[0m"; }
echoyellow() { echo -e "\033[33m$*\033[0m"; }
echoblue()   { echo -e "\033[34m$*\033[0m"; }
echopurple() { echo -e "\033[35m$*\033[0m"; }

DB_FILE="database"

init_db() {
        if [ -f $DB_FILE ]; then
                echo "$DB_FILE exists."
        else
                echo -e "$DB_FILE does not exist \n creating the $DB_FILE"
                touch $DB_FILE
                echo "ID|TITLE|PRIORITY|DUE-DATE|STATUS" > $DB_FILE
        fi
}

list_tasks() {
	while true; do

                echo
                echoblue "1) List All Tasks"
                echoblue "2) Filter By Priority"
                echoblue "3) Filter By status"
                echoblue "4) Back to Main Menu"
                echo

                read -rp "Choose what to list: " list_choice

                case "$list_choice" in
                        1)
                                clear
                                echo "---- UPDATE TITLE ----"
                                read_all_from_db
                                ;;
                        2)
                                clear
                                echo "---- UPDATE PRIORITY ----"
                                read_filter_by_priority
                                ;;

                        3)
                                clear
                                echo "---- UPDATE DUE DATE ----"
                                read_filter_by_status
                                ;;

                        4)
                                break
                                ;;

                        *)
                                echored "Invalid option! Please choose 1-4."
                                ;;

                esac

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

	title=$(awk -v id="$task_id" '$1 == id {print $3}' $DB_FILE)
        priority=$(awk -v id="$task_id" '$1 == id {print $5}' $DB_FILE)
        duedate=$(awk -v id="$task_id" '$1 == id {print $7}' $DB_FILE)
        status=$(awk -v id="$task_id" '$1 == id {print $9}' $DB_FILE)

	while true; do

                echo
                echoblue "1) Update Title"
                echoblue "2) Update Priority"
                echoblue "3) Update Due Date"
                echoblue "4) Update Status"
                echoblue "5) Back to Main Menu"
                echo

                read -rp "Choose what you want to update: " update_choice

                case "$update_choice" in
                        1)
                                clear
                                echo "---- UPDATE TITLE ----"
                                title_valid
				break
                                ;;
                        2)
                                clear
                                echo "---- UPDATE PRIORITY ----"
                                priority_valid
				break
                                ;;

                        3)
                                clear
                                echo "---- UPDATE DUE DATE ----"
                                date_valid
				break
                                ;;

                        4)
                                clear
                                echo "---- UPDATE STATUS ----"
                                status_valid
				break
                                ;;
                        5)
                                break
                                ;;

                        *)
                                echored "Invalid option! Please choose 1-5."
                                ;;

                esac

        done

	update_task_in_db "$line_num" "$title" "$priority" "$duedate" "$status" "$task_id"

}

delete_task() {
	read_all_from_db
	read -p "Enter the task ID:: " task_id
	while true; do

		echo "Are you sure you want to delete task ID number "${task_id}
                echo
                echoblue "1) YES"
                echoblue "2) NO"
                echo

		read -rp "Your choice: " delete_choice

                case "$delete_choice" in
                        1)
                                clear
				delete_task_from_db "${task_id}"
                                break
                                ;;
                        2)
				clear
                                break
                                ;;

                        *)
                                echored "Invalid option! Please choose YES or NO."
                                ;;

                esac

        done
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
                list_tasks
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

