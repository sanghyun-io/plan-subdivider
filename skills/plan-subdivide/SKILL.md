---
name: subdivide
description: Subdivide a plan file into detailed task files. Used to structure detailed plans after completing Plan mode.
invocation:
  command: subdivide
  user_invocable: true
  args:
    - name: plan_path
      description: Path to the plan file to subdivide (defaults to most recent plan if omitted)
      required: false
---

# Plan Subdivide Skill

A skill that breaks down an existing plan file into detailed task files.

---

## ⚠️ Plan Mode Check (Top Priority)

> **IMPORTANT**: If you are in Plan mode, exit it first before running this skill.

### Behavior When Plan Mode is Detected

1. **Run ExitPlanMode**: Exit Plan mode first
2. **Then run `/subdivide` normally**: Proceed from Step 1 after exiting

### Why Is Exiting Plan Mode Necessary?

- In Plan mode, file creation (Write) is interpreted as a plan file
- During plan analysis, the system attempts to write a new plan
- After exiting Plan mode, subdivision work can proceed normally

---

## Usage

```bash
/subdivide                           # Subdivide the most recent plan file
/subdivide ~/.claude/plans/my-plan.md  # Subdivide a specific plan file
```

---

## Execution Steps

### Step 0: Exit Plan Mode

1. Check if currently in Plan mode
2. If in Plan mode, run `ExitPlanMode` to exit
3. After exiting, proceed to Step 1

### Step 1: Locate Plan File

1. If a path is provided as an argument, use that file
2. **Search the current conversation context for the Plan file**:
   - If the context contains Plan content (plan title, file path, etc.), use that file
   - If immediately after ExitPlanMode, prioritize the plan file just created
   - If the Plan filename cannot be extracted from context, proceed to next step
3. If neither of the above applies, select the most recently modified `.md` file from `~/.claude/plans/`
4. If the plan is already subdivided (folder exists), warn and request confirmation

### Step 2: Analyze Plan

Read the plan file and extract:

1. **Overall objective**: The main purpose of the plan
2. **Task list**: Tasks to be performed
3. **Dependencies**: Order/dependencies between tasks
4. **Reference sections**: Section numbers in the original plan

Analysis criteria (Rules reference: @~/.claude/rules/plan-structure.md):
- Separate by independent deliverable units
- Consider logical ordering
- Compose into verifiable units

### Step 3: Define Detailed Tasks

Define detailed tasks based on extracted information:

```
Task 1: {task name}
  - Objective: {objective}
  - Checklist: [{items}]
  - Reference: {original section}

Task 2: {task name}
  ...
```

### Step 4: User Confirmation

Show the subdivision plan to the user and confirm **using AskUserQuestion**:

```
## Subdivision Plan

Source: {plan filename}
Number of tasks: {N}

| Order | Task Name | Description |
|:-----:|-----------|-------------|
| 1 | {task1} | {description1} |
| 2 | {task2} | {description2} |
...
```

Then **you must use the AskUserQuestion tool**:

```json
{
  "questions": [{
    "question": "Proceed with this subdivision plan?",
    "header": "Confirm",
    "multiSelect": false,
    "options": [
      {
        "label": "Proceed",
        "description": "Start creating files as planned (use Shift+Tab to allow all at once)"
      },
      {
        "label": "Needs revision",
        "description": "Review and revise the plan"
      },
      {
        "label": "Cancel",
        "description": "Abort subdivision"
      }
    ]
  }]
}
```

**⚠️ Important**:
- Do NOT ask "Shall we proceed with this subdivision?" as plain text
- You MUST use the AskUserQuestion tool to provide choices

### Step 5: File Generation

After user approval:

1. **Create folder**: `~/.claude/plans/{plan-name}/`
2. **Create task files**: `{2-digit-order}-{task-name}.md`
3. **Update main file**: Add table of contents

> **⚠️ Important**: Once the user approves in Step 4, create all task files **at once**.
> Do not ask for individual confirmation for each file.
> - Execute all Write operations **in parallel within a single message**
> - Do not ask the user for confirmation for each file
> - The approval in Step 4 covers all file generation

### Step 6: Completion Report and Next Steps

After the completion report, suggest next steps **using AskUserQuestion**:

```
## Subdivision Complete ✅

{plan name} has been successfully divided into {N} detailed tasks.

Generated files:
- Main plan: ~/.claude/plans/{plan-name}.md
- Task files: ~/.claude/plans/{plan-name}/01-{first}.md ~ {N}-{last}.md
```

Then **you must use the AskUserQuestion tool**:

```json
{
  "questions": [{
    "question": "Select the next step",
    "header": "Next step",
    "multiSelect": false,
    "options": [
      {
        "label": "Start first task",
        "description": "Open Task 01 file and begin implementation immediately"
      },
      {
        "label": "Review entire plan",
        "description": "Review the main plan file and all task files"
      },
      {
        "label": "Later",
        "description": "Just generate the files for now, work on them later"
      }
    ]
  }]
}
```

**⚠️ Important**:
- Do NOT just give instructions like "Start working on the task" as plain text
- You MUST use the AskUserQuestion tool to provide choices

### Step 7: Work Environment Setup (conditional)

> **Trigger**: Only when user selects **"Start first task"** in Step 6.
> Skip this step if user selects "Review entire plan" or "Later".

Before starting implementation, ask the user about the work environment **using AskUserQuestion**:

```json
{
  "questions": [{
    "question": "Where should the work be performed?",
    "header": "Environment",
    "multiSelect": false,
    "options": [
      {
        "label": "Current environment",
        "description": "Work on the current branch in the current directory as-is"
      },
      {
        "label": "New branch",
        "description": "Create a new branch (git switch -c) in the current directory"
      },
      {
        "label": "Git worktree",
        "description": "Create a separate working directory with a new branch (git worktree add)"
      }
    ]
  }]
}
```

#### Behavior per selection

**Current environment**:
1. Proceed directly — open Task 01 and begin implementation

**New branch**:
1. Derive branch name from the plan name (e.g., `feature/{plan-name}`)
2. Run `git switch -c {branch-name}`
3. If branch creation fails, report to user and wait for instructions
4. On success, open Task 01 and begin implementation

**Git worktree**:
1. Derive branch name from the plan name (e.g., `feature/{plan-name}`)
2. Determine worktree path: `../{repo-name}-{plan-name}` (sibling of current repo)
3. Run `git worktree add {worktree-path} -b {branch-name}`
4. If worktree creation fails, report to user and wait for instructions
5. On success, inform the user of the new working directory path
6. Open Task 01 and begin implementation in the new worktree

**⚠️ Important**:
- Do NOT skip this step when "Start first task" is selected
- Do NOT assume the user wants the current environment by default
- You MUST use the AskUserQuestion tool (not plain text)
- If any git command fails, STOP and report — do not retry autonomously

---

## Task File Template

Each task file is generated with the following structure:

```markdown
# Task {order}: {task name}

> **Order**: {current}/{total}
> **Previous task**: [{previous task name}](./{previous file}) or (none - first task)
> **Next task**: [{next task name}](./{next file}) or (none - last task)
> **Reference**: Original plan {section reference}

---

## Objective

{Objective for this task extracted from the original plan}

---

## Checklist

### 1. {First step}

- [ ] {Sub-task 1}
- [ ] {Sub-task 2}

### 2. {Second step}

- [ ] {Sub-task 3}

---

## Completion Criteria

1. All Checklist items checked
2. Build succeeds (if applicable)
3. Tests pass (if applicable)

---

## Verification Commands

```bash
# Auto-detected based on project context
# Kotlin/Java: ./gradlew build or ./gradlew ktlintCheck
# Node.js: npm test or npm run lint
# Python: pytest or ruff check
```

---

## Next Task

After verification passes, proceed to the next task:

**[Task {next}: {next task name}](./{next file})**

In the next task:
- {Next task summary}

---

*Created: {today's date}*
```

---

## Main File Update

Add a table of contents to the top of the main plan file:

```markdown
## Implementation Tasks

This plan has been divided into {N} detailed tasks.

| Order | Task Name | File | Description |
|:-----:|-----------|------|-------------|
| 1 | **{task1}** | [01-{filename}.md](./{folder}/01-{filename}.md) | {description} |
| 2 | **{task2}** | [02-{filename}.md](./{folder}/02-{filename}.md) | {description} |
...

### Task Rules

1. **Sequential execution**: Proceed in order starting from Task 01
2. **Checklist**: Check all items in each task before moving to the next
3. **Run verification**: Execute verification commands upon completing each task
4. **Follow links**: Navigate using the "Next Task" link at the bottom of each task file

---
```

---

## Subdivision Criteria Guide

### Good Subdivision Examples

| Project Type | Subdivision Unit |
|-------------|-----------------|
| Adding entities | Domain → Repository → Service → Controller → Test |
| API development | Per endpoint or per CRUD operation |
| Refactoring | Per module or per layer |
| Migration | Preparation → Execution → Verification → Cleanup |
| Adding features | Backend → Frontend → Integration tests |

### When NOT to Subdivide

- Tasks completable within 5 minutes
- Single file modifications
- Tasks with dependencies too tightly coupled to separate

---

## Related Rules

- @~/.claude/rules/plan-structure.md - Plan structure rules

---

## Example

### Input (Original Plan)

```markdown
# Implement User Authentication

## Objective
Implement JWT-based authentication system

## Implementation
1. Create User entity
2. Create UserRepository
3. Implement AuthService
4. Write AuthController API
5. Write tests
```

### Output (Subdivision Result)

```
user-authentication/
├── 01-user-entity.md
├── 02-user-repository.md
├── 03-auth-service.md
├── 04-auth-controller.md
└── 05-integration-tests.md
```

---

*This skill is used to structure plans after Plan mode is complete.*
