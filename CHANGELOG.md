# Changelog

All notable changes to the Plan Subdivider Plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned Features
- Task status tracking integration
- Plan templates library
- Interactive task progress visualization
- Git integration for task commits
- Estimated time tracking per task
- Dependency graph visualization

## [1.2.0] - 2026-02-11

### Added
- **Work Environment Setup (Step 7)**: New pre-implementation step that asks where to perform the work
  - Current environment: Work on the current branch as-is
  - New branch: Create a feature branch via `git switch -c`
  - Git worktree: Create a separate working directory with `git worktree add`
  - Triggered only when user selects "Start first task" in Step 6

## [1.1.0] - 2026-02-11

### Changed
- Localize all core plugin files to English for global consistency
  - `skills/plan-subdivide/SKILL.md`: Translated frontmatter, step descriptions, AskUserQuestion JSON examples, and templates
  - `rules/plan-structure.md`: Translated frontmatter, section headers, tables, and template placeholders
  - `rules/rule-format.md`: Translated frontmatter, section headers, tables, and code examples
  - `scripts/install-rules.sh`: Translated comments

## [1.0.0] - 2026-02-09

### Added
- Initial release of Plan Subdivider Plugin
- Automatic plan subdivision with `/subdivide` skill
- Rule files for structured planning:
  - `plan-structure.md`: Main plan structure rules
  - `rule-format.md`: Rule file format standard
- Automatic rule installation via post-install hook
- Pre-work workflow integration
- Task navigation with previous/next links
- Checklist generation for each task
- Verification command templates
- AskUserQuestion integration for user confirmations
- Support for both global and project-level installation

### Features
- **Plan Subdivision**: Automatically break down complex plans into manageable tasks
- **Structured Templates**: Consistent task file format with checklists
- **Navigation**: Inter-task linking for sequential execution
- **Verification**: Built-in verification steps per task
- **Pre-work Detection**: Auto-suggest subdivision for plans with ≥3 tasks

### Documentation
- Comprehensive README with installation and usage guide
- Troubleshooting section
- Integration guide for Sisyphus system
- Example file structures

### Installation
- Automated rule file installation script
- Support for custom installation modes (global/project)
- Skip existing files during installation

---

## Release Notes

### v1.0.0 - Initial Release

This is the first stable release of the Plan Subdivider Plugin. It provides a complete workflow for structured planning in Claude Code, from plan creation with Prometheus to automatic subdivision and sequential task execution.

**Breaking Changes**: None (initial release)

**Migration Guide**: Not applicable (initial release)

**Known Issues**:
- None currently known

**Compatibility**:
- Claude Code: v0.1.0+
- Works with Sisyphus Multi-Agent System
- Compatible with Prometheus, Momus agents

---

For more details on each release, see the [GitHub releases page](https://github.com/sanghyun-io/plan-subdivider/releases).
