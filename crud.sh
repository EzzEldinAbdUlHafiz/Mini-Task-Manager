#!/bin/bash

source ./validation.sh

DB_FILE="database"
NEW_TASK=""
NEW_ID=""

read_all_from_db() {
        awk '{print $0}' "$DB_FILE" | column -t -s '|' -o ' | '
}

read_filter_by_priority() {
	priority_valid
	awk -v p="$priority" 'BEGIN {FS="[ \t]*\\|[ \t]*"} $3 == p {print $0}' "$DB_FILE" | column -t -s '|' -o ' | '
}

read_filter_by_status() {
	status_valid
	awk -v s="$status" 'BEGIN {FS="[ \t]*\\|[ \t]*"} $5 == s {print $0}' "$DB_FILE" | column -t -s '|' -o ' | '
}

generate_id() {
        last_id=$(awk 'END {print $1}' "$DB_FILE")

        if [[ $last_id =~ ^[0-9]+$ ]]; then
                NEW_ID=$((last_id + 1))
        else
                NEW_ID=1
        fi
}

write_task_in_db() {
        echo "${NEW_ID} | ${1} | ${2} | ${3} | pending" >> "$DB_FILE"
        echo "Task added successfully."
}

delete_task_from_db() {
	line_num=$(awk -v id="${1}" '$1 == id {print NR}' $DB_FILE)
        sed -i "${line_num}d" "$DB_FILE"
}

update_task_in_db() {
    	formatted_line="${6} | ${2} | ${3} | ${4} | ${5}"
    	sed -i "${1}s#.*#${formatted_line}#" "$DB_FILE"
    	echo "Task updated successfully."
}
