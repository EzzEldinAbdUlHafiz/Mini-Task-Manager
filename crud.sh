#!/bin/bash

source ./validation.sh

DB_FILE="database"
NEW_TASK=""
NEW_ID=""

print_table() {
    cat | column -t -s '|' -o '  |  '
}

read_all_from_db() {
    (echogreen "$(awk -F '[ \t]*\\|[ \t]*' 'NR==1{print $0}' "$DB_FILE")"; awk -F '[ \t]*\\|[ \t]*' 'NR>1{print $0}' "$DB_FILE") | print_table
}

read_filter_by_priority() {
    priority_valid
    (echogreen "$(awk -F '[ \t]*\\|[ \t]*' 'NR==1{print $0}' "$DB_FILE")"; awk -F '[ \t]*\\|[ \t]*' -v p="$priority" '$3 == p' "$DB_FILE") | print_table
}

read_filter_by_status() {
    status_valid
    (echogreen "$(awk -F '[ \t]*\\|[ \t]*' 'NR==1{print $0}' "$DB_FILE")"; awk -F '[ \t]*\\|[ \t]*' -v s="$status" '$5 == s' "$DB_FILE") | print_table
}

search_in_db() {
    (echogreen "$(awk -F '[ \t]*\\|[ \t]*' 'NR==1{print $0}' "$DB_FILE")"; awk -F '[ \t]*\\|[ \t]*' -v t="$title" 'NR>1 && tolower($2) ~ tolower(t){print $0}' "$DB_FILE") | print_table
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
    echogreen "Task added successfully."
	(echogreen "$(awk -F '[ \t]*\\|[ \t]*' 'NR==1{print $0}' "$DB_FILE")"; awk -F '[ \t]*\\|[ \t]*' -v id="$NEW_ID" 'NR>1 && $1 == id {print $0}' "$DB_FILE") | print_table
	read -p "Press any key to continue"
}

delete_task_from_db() {
    sed -i "${1}d" "$DB_FILE"
    echogreen "Task id ${1} has been deleted"
}

update_task_in_db() {
    formatted_line="${6} | ${2} | ${3} | ${4} | ${5}"
    sed -i "${1}s#.*#${formatted_line}#" "$DB_FILE"
    echogreen "Task updated successfully."
	(echogreen "$(awk -F '[ \t]*\\|[ \t]*' 'NR==1{print $0}' "$DB_FILE")"; awk -F '[ \t]*\\|[ \t]*' -v id="${6}" 'NR>1 && $1 == id {print $0}' "$DB_FILE") | print_table
	read -p "Press any key to continue"
}

export_db_to_CSV() {
    sed 's/|/,/g' "$DB_FILE" >> "$1".csv
}

sort_by_date() {
    (echogreen "$(awk -F '[ \t]*\\|[ \t]*' 'NR == 1{print $0}' "$DB_FILE")"; \
    awk -F '[ \t]*\\|[ \t]*' 'NR > 1 {print $0}' "$DB_FILE" | sort -t '|' -k4) | print_table
}

sort_by_priority() {
    (echogreen "$(awk -F '[ \t]*\\|[ \t]*' 'NR == 1{print $0}' "$DB_FILE")"; \
    awk -F '[ \t]*\\|[ \t]*' -v p="high" '$3 == p' "$DB_FILE"; \
    awk -F '[ \t]*\\|[ \t]*' -v p="medium" '$3 == p' "$DB_FILE"; \
    awk -F '[ \t]*\\|[ \t]*' -v p="low" '$3 == p' "$DB_FILE") | print_table
}