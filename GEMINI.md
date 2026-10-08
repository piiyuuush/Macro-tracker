# Antigravity Workspace Protocol

CRITICAL SYSTEM DIRECTIVES:
1. All workflow execution is governed by `.agents/rules/coordinator.md`.
2. All agents modify application code directly in the root directory. No git isolation or worktrees are required.
3. Before executing any user task:
   - Identify your active role defined in `.agents/agents.md`.
   - Read `conductor/state.json` to verify current milestone and task IDs.
   - Execute strictly using registered capabilities in `.agents/skills/`.
