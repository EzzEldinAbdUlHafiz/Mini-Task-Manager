#!/bin/bash

DB_FILE="database"
DELIMITER="|"
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
		printf "%-10s | %-20s | %-10s| %-10s | %-10s \n" "ID" "TITLE" "PRIORITY" "DUE DATE" "STATUS" > $DB_FILE
		echo "-------------------------------------------------------------------------------------" >> $DB_FILE
	fi
}

read_tasks(){
	awk '{print $0}' $DB_FILE
}

generate_id(){
	NEW_ID=$(awk 'END {print $1}' $DB_FILE)
	let "NEW_ID += 1"
	echo $NEW_ID
}

write_task_line(){
	generate_id
	NEW_TASK="EZZ|50|60"
	echo $NEW_ID" "$NEW_TASK >> $DB_FILE
}





main(){
	init_db
}

main
