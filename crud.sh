#!/bin/bash

DB_FILE="database"
NEW_TASK=""
NEW_ID=""

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
