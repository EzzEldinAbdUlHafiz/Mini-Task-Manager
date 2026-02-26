#!/bin/bash
source ./crud.sh

DB_FILE="database"

report_summary() {
    sum_pending=$(awk -F '[ \t]*\\|[ \t]*' -v s="pending" -v i=0 '$5 == s {i++} END {print i}' "$DB_FILE")
    sum_progress=$(awk -F '[ \t]*\\|[ \t]*' -v s="in-progress" -v i=0 '$5 == s {i++} END {print i}' "$DB_FILE")
    sum_done=$(awk -F '[ \t]*\\|[ \t]*' -v s="done" -v i=0 '$5 == s {i++} END {print i}' "$DB_FILE")

    echoyellow "pending: ${sum_pending}"
    echoblue "progress: ${sum_progress}"
    echogreen "done: ${sum_done}"
}

report_overdue() {
    current_date=$(date "+%Y/%m/%d")
    (echogreen "$(awk -F '[ \t]*\\|[ \t]*' 'NR==1{print $0}' "$DB_FILE")"; \
    awk -F '[ \t]*\\|[ \t]*' -v d="$current_date" -v s="done" '$4 < d && $5 != s {print $0}' "$DB_FILE") | print_table
}

report_priority() {
    echo
    echoyellow "---- LOW PRIORITY ----"
    sum_low=$(awk -F '[ \t]*\\|[ \t]*' -v p="low" -v i=0 '$3 == p {i++} END {print i}' "$DB_FILE")
    echogreen "Found: ${sum_low}"
    (echogreen "$(awk -F '[ \t]*\\|[ \t]*' 'NR==1{print $0}' "$DB_FILE")"; \
    awk -F '[ \t]*\\|[ \t]*' -v p="low" '$3 == p' "$DB_FILE") | print_table
    echo

    echoyellow "---- MEDIUM PRIORITY ----"
    sum_medium=$(awk -F '[ \t]*\\|[ \t]*' -v p="medium" -v i=0 '$3 == p {i++} END {print i}' "$DB_FILE")
    echogreen "Found: ${sum_medium}"
    (echogreen "$(awk -F '[ \t]*\\|[ \t]*' 'NR==1{print $0}' "$DB_FILE")"; \
    awk -F '[ \t]*\\|[ \t]*' -v p="medium" '$3 == p' "$DB_FILE") | print_table
    echo

    echoyellow "---- HIGI PRIORITY ----"
    sum_high=$(awk -F '[ \t]*\\|[ \t]*' -v p="high" -v i=0 '$3 == p {i++} END {print i}' "$DB_FILE")
    echogreen "Found: ${sum_high}"
    (echogreen "$(awk -F '[ \t]*\\|[ \t]*' 'NR==1{print $0}' "$DB_FILE")"; \
    awk -F '[ \t]*\\|[ \t]*' -v p="high" '$3 == p' "$DB_FILE") | print_table
}