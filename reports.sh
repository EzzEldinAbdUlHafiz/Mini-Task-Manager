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
