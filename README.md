# Mini Task Manager

This is a simple, command-line based task manager built with Bash scripts. It allows you to manage your tasks efficiently from the terminal.

## Features

- **Add, Update, and Delete Tasks:** Easily manage your tasks with basic CRUD (Create, Read,Update, Delete) operations.
- **List and Filter:** View all tasks or filter them by priority (high, medium, low) or status (pending, in-progress, done).
- **Search:** Find specific tasks by their title.
- **Reporting:** Generate reports to get insights into your tasks:
  - **Summary:** Get a count of tasks by their status.
  - **Overdue:** List all tasks that are past their due date.
  - **Priority:** View tasks grouped by their priority level.
- **Sort:** Organize your task list by due date or priority.
- **Export:** Export your tasks to a CSV file for use in other applications.
- **Data Persistence:** Tasks are stored in a simple flat file named `database`.

## Prerequisites

-   Bash shell (standard on most Linux distributions and macOS)
-   `column` command for table formatting
-   `date` command (GNU version recommended for flexible date parsing like 'next Friday')

## How to Use

1.  **Clone the repository or download the script files.**
2.  **Run the main script from your terminal:**
    ```bash
    ./task_manager.sh
    ```
3.  **Follow the on-screen menu to manage your tasks.** The script will automatically create the `database` file if it doesn't exist.

## File Descriptions

-   **`task_manager.sh`**: The main script and entry point for the application. It displays the main menu and handles user interaction.
-   **`crud.sh`**: Contains all the core functions for Creating, Reading, Updating, and Deleting tasks from the database file.
-   **`validation.sh`**: Includes functions for validating user input, such as task titles, priorities, due dates, and statuses.
-   **`reports.sh`**: Houses the logic for generating different kinds of reports on the tasks.
-   **`database`**: A plain text file where all the task data is stored. Each line represents a task, with fields separated by a pipe (`|`).

## Example Usage

Here’s a quick walk-through:

1.  **Start the application:** `bash task_manager.sh`
2.  **Add a task:**
    -   Choose option `1`.
    -   Enter a title (e.g., "Finish project report").
    -   Set a priority (e.g., "high").
    -   Provide a due date (e.g., "tomorrow" or "2024/12/25").
3.  **List tasks:**
    -   Choose option `2`.
    -   Select to list all tasks, or filter by priority/status.
4.  **Update a task:**
    -   Choose option `3`.
    -   Enter the ID of the task you want to modify.
    -   Select the field to update (title, priority, etc.) and provide the new value.
5.  **Generate a report:**
    -   Choose option `6`.
    -   Select the desired report (summary, overdue, etc.).
6.  **Exit:**
    -   Choose option `9` to safely exit the application.

