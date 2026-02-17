#!/bin/bash

source ./validation.sh

DB_FILE="database"
NEW_TASK=""
NEW_ID=""

print_table() {
        cat | column -t -s '|' -o '  |  '
}

read_all_from_db() {
        cat "$DB_FILE" | print_table
}

read_filter_by_priority() {
	priority_valid
	awk -F '[ \t]*\\|[ \t]*' -v p="$priority" '$3 == p || NR == 1' "$DB_FILE" | print_table
}

read_filter_by_status() {
	status_valid
	awk -F '[ \t]*\\|[ \t]*' -v s="$status" '$5 == s || NR == 1' "$DB_FILE" | print_table
}

search_in_db() {
	line_nums=( $(awk '{print $3}' "$DB_FILE" | grep -n "$title" | cut -d ':' -f 1) )
	echo "Found: ${#line_nums[@]}"

	awk 'NR == 1 {print $0}' "$DB_FILE" > dummy_line
	for item in "${line_nums[@]}"; do 
		awk -v ln="$item" 'NR == ln {print $0}' "$DB_FILE" >> dummy_line
	done
	cat dummy_line | print_table
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
