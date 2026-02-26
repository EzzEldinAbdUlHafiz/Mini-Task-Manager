#!/bin/bash

source ./crud.sh

DB_FILE="database"

report_summary() {
    sum_pending=$(awk -F '[ \t]*\\|[ \t]*' -v s="pending" -v i=0 '$5 == s {i++} END {print i}' "$DB_FILE")
    sum_progress=$(awk -F '[ \t]*\\|[ \t]*' -v s="in-progress" -v i=0 '$5 == s {i++} END {print i}' "$DB_FILE")
    sum_done=$(awk -F '[ \t]*\\|[ \t]*' -v s="done" -v i=0 '$5 == s {i++} END {print i}' "$DB_FILE")

    echo "pending: ${sum_pending}"
    echo "progress: ${sum_progress}"
    echo "done: ${sum_done}"
}

report_overdue() {
    current_date=$(date "+%Y/%m/%d")
    awk -F '[ \t]*\\|[ \t]*' -v d="$current_date" -v s="done" '$4 < d && $5 != s || NR == 1 {print $0}' "$DB_FILE" | print_table
}

report_priority() {
    echo
    echo "---- LOW PRIORITY ----"
    sum_low=$(awk -F '[ \t]*\\|[ \t]*' -v p="low" -v i=0 '$3 == p {i++} END {print i}' "$DB_FILE")
    echo "Found: ${sum_low}"
    awk -F '[ \t]*\\|[ \t]*' -v p="low" '$3 == p || NR == 1 {print $0}' "$DB_FILE" | print_table
    echo

    echo "---- MEDIUM PRIORITY ----"
    sum_medium=$(awk -F '[ \t]*\\|[ \t]*' -v p="medium" -v i=0 '$3 == p {i++} END {print i}' "$DB_FILE")
    echo "Found: ${sum_medium}"
    awk -F '[ \t]*\\|[ \t]*' -v p="medium" '$3 == p || NR == 1 {print $0}' "$DB_FILE" | print_table
    echo

    echo "---- HIGI PRIORITY ----"
    sum_high=$(awk -F '[ \t]*\\|[ \t]*' -v p="high" -v i=0 '$3 == p {i++} END {print i}' "$DB_FILE")
    echo "Found: ${sum_high}"
    awk -F '[ \t]*\\|[ \t]*' -v p="high" '$3 == p || NR == 1 {print $0}' "$DB_FILE" | print_table
}