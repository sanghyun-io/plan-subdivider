# Plan Subdivider

> **Transform complex plans into structured, actionable tasks** — automatically

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/sanghyun-io/plan-subdivider)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/sanghyun-io/plan-subdivider?style=social)](https://github.com/sanghyun-io/plan-subdivider/stargazers)

**English** | [한국어](README.ko.md)

**Plan Subdivider** is a Claude Code plugin that automatically breaks down large plans into manageable, sequential tasks with built-in checklists, verification steps, and navigation.

---

## 🎯 Why Plan Subdivider?

**Before** 😰:
```
Plan: Implement user authentication
- Setup User entity
- Create repository
- Implement service layer
- Add REST API
- Write tests
```

**After** ✨:
```
~/.claude/plans/user-authentication/
├── 01-user-entity.md          ✓ Clear goal
├── 02-user-repository.md      ✓ Step-by-step checklist
├── 03-auth-service.md         ✓ Verification commands
├── 04-auth-controller.md      ✓ Next task navigation
└── 05-integration-tests.md    ✓ Completion criteria
```

Each task file includes:
- **Clear objectives** — Know exactly what to build
- **Actionable checklists** — Step-by-step implementation guide
- **Verification commands** — Validate each step
- **Task navigation** — Seamless flow between tasks

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| **🤖 Automatic Subdivision** | Claude analyzes your plan and proposes optimal task breakdown |
| **📋 Smart Checklists** | Each task gets detailed, actionable checklist items |
| **🔗 Task Navigation** | Previous/next links for sequential execution |
| **✅ Built-in Verification** | Auto-generated verification commands per task |
| **🚦 Pre-work Workflow** | Claude suggests subdivision before starting implementation |
| **📐 Rule-based Structure** | Consistent formatting across all plans |

---

## 🚀 Quick Start

### 1. Install

```bash
/plugin install https://github.com/sanghyun-io/plan-subdivider
```

That's it! The plugin auto-installs rules to `.claude/rules/` on first run.

### 2. Create a Plan

```bash
/plan Implement user authentication with JWT
```

Claude (via Prometheus agent) interviews you and creates a structured plan.

### 3. Subdivide

```bash
/subdivide
```

Claude:
1. Analyzes your plan structure
2. Proposes task breakdown
3. Asks for confirmation
4. Generates task files with checklists

### 4. Execute

Open the first task and start coding:

```bash
~/.claude/plans/your-plan/01-first-task.md
```

Follow the checklist, run verification commands, and click "Next Task" when done!

---

## 📸 Example Output

### Main Plan File

```markdown
# User Authentication Implementation

## Implementation Tasks

| # | Task | File | Status |
|:-:|------|------|:------:|
| 1 | **User Entity** | [01-user-entity.md](./auth/01-user-entity.md) | ✓ |
| 2 | **User Repository** | [02-user-repository.md](./auth/02-user-repository.md) | 🔄 |
| 3 | **Auth Service** | [03-auth-service.md](./auth/03-auth-service.md) | ⏳ |
| 4 | **Auth Controller** | [04-auth-controller.md](./auth/04-auth-controller.md) | ⏳ |
| 5 | **Integration Tests** | [05-tests.md](./auth/05-tests.md) | ⏳ |
```

### Task File (01-user-entity.md)

```markdown
# Task 1: User Entity

> **Order**: 1/5
> **Previous**: (None - first task)
> **Next**: [Task 2: User Repository](./02-user-repository.md)

---

## Goal

Create User entity with JPA annotations for database persistence.

---

## Checklist

### 1. Create Entity Class
- [ ] Create `User.kt` in `domain/` package
- [ ] Add `@Entity` annotation
- [ ] Define fields: id, email, password, roles, createdAt
  ```kotlin
  @Entity
  data class User(
      @Id @GeneratedValue
      val id: Long? = null,
      val email: String,
      val password: String,
      // ...
  )
  ```
- [ ] Add validation annotations

### 2. Database Schema
- [ ] Create migration script `V001__create_users_table.sql`
- [ ] Test migration with `./gradlew flywayMigrate`

---

## Verification

\`\`\`bash
./gradlew build
./gradlew test
\`\`\`

---

## Next Task

**[Task 2: User Repository](./02-user-repository.md)**
```

---

## 🎨 How It Works

```
┌─────────────────────────────────────────────────────────────┐
│  You: "/plan Implement feature X"                          │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  Claude (Prometheus): Creates structured plan              │
│  - Requirements gathering                                   │
│  - Architecture design                                      │
│  - Implementation steps                                     │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  You: "Start implementation"                                │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  Claude: "This plan has 5 tasks. Run /subdivide?"          │
│  You: "Yes" ✓                                               │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  Plan Subdivider: Generates task files                     │
│  01-task.md → 02-task.md → 03-task.md → ...                │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│  You: Execute tasks sequentially with clear guidance       │
└─────────────────────────────────────────────────────────────┘
```

---

## 📦 What's Included

### Plugin Components

```
plan-subdivider/
├── .claude-plugin/
│   ├── plugin.json              # Plugin metadata
│   └── marketplace.json         # Marketplace config
├── rules/
│   ├── plan-structure.md        # Plan structure rules
│   └── rule-format.md           # Rule format standards
├── skills/
│   └── plan-subdivide/
│       └── SKILL.md             # /subdivide command
├── scripts/
│   └── install-rules.sh         # Auto-install script
├── hooks/
│   └── hooks.json               # Post-install automation
└── examples/
    └── sample-plan.md           # Example plan
```

### Automatically Installed Rules

When you install the plugin, these rules are copied to your `.claude/rules/`:

- **`plan-structure.md`**: Defines plan file structure, task templates, and subdivision criteria
- **`rule-format.md`**: Ensures consistent rule file formatting

---

## 🔧 Configuration

### Installation Modes

Choose where rules are installed:

```bash
# Global (default) - Available across all projects
/plugin install https://github.com/sanghyun-io/plan-subdivider

# Project - Shared with team via git
CLAUDE_PLUGIN_INSTALL_MODE=project /plugin install ...

# Local - Project-specific, gitignored
CLAUDE_PLUGIN_INSTALL_MODE=local /plugin install ...
```

### Subdivision Criteria

Plans are automatically subdivided when they have:
- ≥ 3 tasks
- Multiple file modifications
- Complex implementation steps

Customize criteria in `.claude/rules/plan-structure.md`

---

## 🤝 Integration

### Works With

- **Prometheus**: Creates structured plans via `/plan`
- **Momus**: Reviews plans with `/review`
- **Sisyphus**: Multi-agent task orchestration
- **Claude Plan Mode**: Native plan creation workflow

### Pre-work Workflow

When executing a plan, Claude automatically:

1. **Checks task count**: If ≥ 3 tasks → suggests `/subdivide`
2. **Checks complexity**: If multi-file changes → suggests `/review`
3. **Asks confirmation**: Via `AskUserQuestion` tool

---

## 📚 Examples

### Example 1: REST API Development

**Input**:
```bash
/plan Create REST API for blog posts with CRUD operations
```

**Output**:
```
blog-api/
├── 01-post-entity.md
├── 02-post-repository.md
├── 03-post-service.md
├── 04-post-controller.md
├── 05-exception-handling.md
└── 06-integration-tests.md
```

### Example 2: Database Migration

**Input**:
```bash
/plan Migrate user data from MongoDB to PostgreSQL
```

**Output**:
```
mongodb-to-postgres/
├── 01-schema-design.md
├── 02-migration-script.md
├── 03-data-validation.md
├── 04-cutover-plan.md
└── 05-rollback-procedure.md
```

---

## 🐛 Troubleshooting

### Rules not installed

```bash
# Manually run installation script
bash ~/.claude/plugins/plan-subdivider/scripts/install-rules.sh
```

### `/subdivide` not recognized

1. Verify plugin is enabled:
   ```bash
   /plugin list
   ```

2. Check skill installation:
   ```bash
   ls ~/.claude/plugins/plan-subdivider/skills/plan-subdivide/
   # Should show: SKILL.md
   ```

3. Restart Claude Code

### Subdivision not working

1. Exit Plan mode first: Type `/exit` or complete planning
2. Verify plan file exists: `ls ~/.claude/plans/*.md`
3. Check rule files: `ls .claude/rules/plan-structure.md`

---

## 🌟 Why Star This Project?

If Plan Subdivider helps you:

- ⭐ **Star** to show support and help others discover it
- 🐛 **Report issues** to improve the plugin
- 💡 **Suggest features** to make it even better
- 🤝 **Contribute** via pull requests

Your star helps Plan Subdivider get discovered on [ClaudeMarketplaces.com](https://claudemarketplaces.com/)!

---

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

---

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

- Built for the Claude Code community
- Inspired by GTD (Getting Things Done) methodology
- Powered by Claude Sonnet 4.5

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/sanghyun-io/plan-subdivider/issues)
- **Discussions**: [GitHub Discussions](https://github.com/sanghyun-io/plan-subdivider/discussions)
- **Email**: ppkimsanh@gmail.com

---

**Made with ❤️ for Claude Code**

⭐ **Star this repo** to help others discover Plan Subdivider!
