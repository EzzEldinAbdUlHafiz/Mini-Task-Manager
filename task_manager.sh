#!/bin/bash

DB_FILE="database"
NEW_TASK=""
NEW_ID=""

VALID_PRIORITIES=("high" "medium" "low")
VALID_STATUS=("pending" "in-progress" "done")

TODAY=$(date +%F)

#DATABASE FUNCTIONS
init_db(){
	if [ -f $DB_FILE ]; then
    		echo "$DB_FILE exists."
	else
    		echo -e "$DB_FILE does not exist \n creating the $DB_FILE"
    		touch $DB_FILE
		printf "%-10s | %-30s | %-10s| %-10s | %-10s \n" \
			"ID" "TITLE" "PRIORITY" "DUE DATE" "STATUS" > $DB_FILE
		echo "-------------------------------------------------------------------------------------" >> $DB_FILE
	fi
}

read_tasks(){
	awk '{print $0}' $DB_FILE
}

generate_id() {
	last_id=$(awk 'END {print $1}' "$DB_FILE")

	if [[ $last_id =~ ^[0-9]+$ ]]; then
		NEW_ID=$((last_id + 1))
	else
		NEW_ID=1
	fi
}


write_task_line(){
	generate_id
	read -p "Enter the title::" title
	read -p "Enter the priority::" priority
	read -p "Enter a duedate::" duedate
	read -p "Enter the status::" status

	printf "%-10s | %-20s | %-10s| %-10s | %-10s \n" \
	       "$NEW_ID" "$title" "$priority" "$duedate" "$status" >> "$DB_FILE"
}





main(){
	init_db
	write_task_line
}

main
