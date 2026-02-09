# Plan Subdivider - Claude Code Plugin

**Structured planning system with automatic task subdivision for Claude Code**

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/sanghyun-io/plan-subdivider)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 📋 Overview

This plugin provides a comprehensive planning workflow for Claude Code, enabling automatic subdivision of complex plans into structured, actionable tasks with built-in verification and navigation.

### ✨ Features

- ✅ **Automatic Plan Subdivision**: Split complex plans into manageable task files
- ✅ **Checklist Generation**: Auto-generate actionable checklists for each task
- ✅ **Task Navigation**: Previous/next task links for sequential execution
- ✅ **Verification Automation**: Built-in verification commands per task
- ✅ **Pre-work Workflow**: Automatic subdivision suggestions before plan execution
- ✅ **Rule-based Structure**: Consistent plan formatting with validation

## 🚀 Installation

### Via Claude Code Marketplace

```bash
# Add marketplace (if not already added)
/plugin marketplace add your-marketplace-url

# Install plugin
/plugin install plan-subdivider
```

### Manual Installation

```bash
# Clone repository
git clone https://github.com/sanghyun-io/plan-subdivider.git

# Install to Claude Code
cp -r plan-subdivider ~/.claude/plugins/plan-structure

# Or install to project
cp -r plan-subdivider .claude/plugins/plan-structure
```

### Post-Installation

The plugin automatically installs rule files to `.claude/rules/` on first session start.

**Verify installation:**
```bash
ls .claude/rules/
# Should show: plan-structure.md, rule-format.md
```

## 📖 Quick Start

### 1. Create a Plan

```bash
/plan Implement user authentication system
```

Claude (Prometheus agent) will interview you about requirements and create a structured plan.

### 2. Subdivide the Plan

When you're ready to start implementation:

```bash
/subdivide
```

Claude will:
- Analyze the plan structure
- Propose task breakdown
- Ask for confirmation via `AskUserQuestion`
- Generate detailed task files with checklists

### 3. Execute Tasks

Navigate to the first task and start implementation:

```markdown
~/.claude/plans/your-plan/01-first-task.md
```

Each task includes:
- Goal and context
- Detailed checklist
- Completion criteria
- Verification commands
- Link to next task

## 📁 File Structure

### Generated Plan Structure

```
~/.claude/plans/
├── your-plan.md                # Main plan with task index
└── your-plan/                  # Task folder
    ├── 01-first-task.md        # Task 1 with checklist
    ├── 02-second-task.md       # Task 2 with checklist
    └── ...
```

### Main Plan File

```markdown
# {Plan Title}

> **Created**: YYYY-MM-DD
> **Purpose**: {One-line description}

---

## Implementation Tasks

| # | Task | File | Description |
|:-:|------|------|-------------|
| 1 | **Task 1** | [01-task.md](./plan/01-task.md) | ... |
| 2 | **Task 2** | [02-task.md](./plan/02-task.md) | ... |

### Task Rules

1. **Sequential execution**: Start from Task 01
2. **Checklist completion**: Check all items before moving to next
3. **Verification**: Run verification commands per task
4. **Navigation**: Use "Next Task" links to proceed
```

### Task File Template

```markdown
# Task {N}: {Task Name}

> **Order**: {current}/{total}
> **Previous**: [{prev-task}](./{prev-file}) or (None - first task)
> **Next**: [{next-task}](./{next-file}) or (None - last task)

---

## Goal

{Task objective from original plan}

---

## Checklist

### 1. {Step 1}
- [ ] {Subtask 1}
- [ ] {Subtask 2}

### 2. {Step 2}
- [ ] {Subtask 3}

---

## Completion Criteria

1. All checklist items completed
2. Build successful
3. Tests passing

---

## Verification

\`\`\`bash
{Project-specific verification commands}
\`\`\`

---

## Next Task

**[Task {N+1}: {Next Task Name}](./{next-file})**
```

## 🎯 Subdivision Criteria

### When to Subdivide

| Criteria | Description |
|----------|-------------|
| Independent deliverables | Each task can be completed independently |
| Logical steps | Sequential stages of implementation |
| Different areas | Separate code/file domains |
| Verifiable | Each task completion can be verified |

### Example Breakdown

| Task Type | Subdivision |
|-----------|-------------|
| Entity addition | Domain → Repository → Service → Controller |
| API development | Per endpoint or per feature |
| Refactoring | Per module or per layer |
| Migration | Prepare → Execute → Verify → Cleanup |

## 🔧 Advanced Usage

### Pre-work Workflow

When executing a plan, Claude automatically:

1. **Checks task count**: If ≥ 3 tasks, suggests `/subdivide`
2. **Checks complexity**: If multi-file changes, suggests `/review`
3. **Asks for confirmation**: Via `AskUserQuestion` tool

**Example**:
```json
{
  "question": "Run Pre-work before implementation?",
  "options": [
    "Skip and start immediately",
    "Run /subdivide",
    "Run /review"
  ]
}
```

### Manual Subdivision

```bash
# Subdivide latest plan
/subdivide

# Subdivide specific plan
/subdivide ~/.claude/plans/my-plan.md
```

### Customizing Installation

Control where rules are installed:

```bash
# Install to global ~/.claude/rules (default for project plugins)
CLAUDE_PLUGIN_INSTALL_MODE=global /plugin install plan-subdivider

# Install to project .claude/rules (default)
CLAUDE_PLUGIN_INSTALL_MODE=project /plugin install plan-subdivider
```

## 📚 Rule Files

This plugin installs the following rule files:

### `plan-structure.md`
- Main plan file structure
- Task file template
- Subdivision criteria
- Pre-work workflow
- Linked skills integration

### `rule-format.md`
- Rule file format standard
- Frontmatter structure
- Required sections
- Linked skills table format
- Validation checklist

## 🤝 Integration with Other Systems

### Sisyphus Multi-Agent System

This plugin integrates seamlessly with the Sisyphus orchestration system:

```markdown
# In your CLAUDE.md

## Plan Structure (see @.claude/rules/plan-structure.md)

Plans are automatically structured with subdivision support.

### Pre-work
- Task ≥ 3: `/subdivide` suggested
- Multi-file: `/review` suggested
```

### Compatible Agents

- **Prometheus**: Strategic planning agent (creates plans)
- **Momus**: Critical plan review agent
- **Orchestrator-Sisyphus**: Multi-step task coordination

## 🛠️ Troubleshooting

### Rules not installed

```bash
# Manually run installation script
bash ~/.claude/plugins/plan-structure/scripts/install-rules.sh
```

### Skill not recognized

```bash
# Verify skill installation
ls ~/.claude/plugins/plan-structure/skills/plan-subdivide/

# Should show: SKILL.md
```

### Subdivision not working

1. Check you're not in Plan mode: Exit with `/exit` or complete planning
2. Verify plan file exists: `ls ~/.claude/plans/*.md`
3. Check rule files: `ls .claude/rules/plan-structure.md`

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

- Claude Code team for the extensibility framework
- Sisyphus system developers
- Claude Code community

---

**Questions or issues?** Open an issue on [GitHub](https://github.com/sanghyun-io/plan-subdivider/issues)

**Made with ❤️ for Claude Code**
