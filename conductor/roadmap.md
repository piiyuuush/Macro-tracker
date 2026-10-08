# Conductor Roadmap

## Current Status
The repository (`macro_tracker`) is an active Flutter project managing local state with Riverpod and persistent storage with Drift (SQLite).
The `main` branch is clean with minor uncommitted property changes (`android/gradle.properties`).
The Conductor Agentic Workflow has been fully initialized.

## Architectural Baseline
- **Framework**: Flutter / Dart
- **State Management**: Riverpod (`flutter_riverpod`)
- **Database**: Drift / SQLite (`drift`, `sqlite3_flutter_libs`)
- **UI Components**: Custom UI, `fl_chart` for graphs, `table_calendar` for dates.

## Immediate Next Steps
1. Execute `architecture_audit` to gain a comprehensive understanding of module bounds.
2. Address open tasks in `conductor/state.json`.
3. Stand up the `Implementation_Agent` via `task_dispatch` to tackle the next requested feature in an isolated `.worktree/`.
