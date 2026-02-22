#!/bin/bash

source ./validation.sh

DB_FILE="database"
NEW_TASK=""
NEW_ID=""

print_table() {
        cat | column -t -s '|' -o '  |  '
}

read_all_from_db() {
		awk -F '[ \t]*\\|[ \t]*' '{print $0}' "$DB_FILE" | print_table
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
	line_nums=( $(awk -F '[ \t]*\\|[ \t]*' '{print $2}' "$DB_FILE" | grep -n "$title" | cut -d ':' -f 1) )
	echo "Found: ${#line_nums[@]}"
	res=$(awk 'NR == 1 {print $0}' "$DB_FILE")
	for item in "${line_nums[@]}"; do 
		res+=$'\n'$(awk -v ln="$item" 'NR == ln {print $0}' "$DB_FILE" )
	done
	echo "$res" | print_table
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
	sed -i "${1}d" "$DB_FILE"
	echo "Task id ${1} has been deleted"
}

update_task_in_db() {
    	formatted_line="${6} | ${2} | ${3} | ${4} | ${5}"
    	sed -i "${1}s#.*#${formatted_line}#" "$DB_FILE"
    	echo "Task updated successfully."
}

export_db_to_CSV() {
	sed 's/|/,/g' "$DB_FILE" >> "$1".csv				
}

sort_by_date() {
	res=$(awk -F '[ \t]*\\|[ \t]*' 'NR == 1{print $0}' "$DB_FILE")
	res+=$'\n'$(awk -F '[ \t]*\\|[ \t]*' 'NR > 1 {print $0}' "$DB_FILE" | sort -t '|' -k4)
	echo "$res" | print_table
}

sort_by_priority() {
	res=$(awk -F '[ \t]*\\|[ \t]*' 'NR == 1{print $0}' "$DB_FILE")
	res+=$'\n'$(awk -F '[ \t]*\\|[ \t]*' -v p="high" '$3 == p' "$DB_FILE")
	res+=$'\n'$(awk -F '[ \t]*\\|[ \t]*' -v p="medium" '$3 == p' "$DB_FILE")
	res+=$'\n'$(awk -F '[ \t]*\\|[ \t]*' -v p="low" '$3 == p' "$DB_FILE")
	echo "$res" | print_table
}