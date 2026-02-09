# Deployment Guide

This guide explains how to deploy the Plan Subdivider Plugin to GitHub and make it available via Claude Code Marketplace.

## 📦 Plugin Structure (Complete)

```
plan-subdivider/
├── .claude-plugin/
│   ├── plugin.json           ✅ Plugin metadata
│   └── marketplace.json      ✅ Marketplace configuration
├── .gitignore                ✅ Git ignore rules
├── README.md                 ✅ Installation & usage guide
├── CHANGELOG.md              ✅ Version history
├── LICENSE                   ✅ MIT License
├── DEPLOYMENT.md             ✅ This file
├── hooks/
│   └── hooks.json            ✅ Post-install automation
├── scripts/
│   └── install-rules.sh      ✅ Rule installation script
├── rules/
│   ├── plan-structure.md     ✅ Main plan structure rules
│   └── rule-format.md        ✅ Rule format standard
├── skills/
│   └── plan-subdivide/
│       └── SKILL.md          ✅ Subdivision skill
└── examples/
    └── sample-plan.md        ✅ Example plan file
```

## 🚀 Deployment Steps

### 1. Create GitHub Repository

```bash
cd C:/Users/QESG/Desktop/plan-subdivider

# Initialize git repository
git init

# Add all files
git add .

# First commit
git commit -m "Initial release: Plan Subdivider Plugin v1.0.0

- Automatic plan subdivision with /subdivide skill
- Rule files for structured planning
- Pre-work workflow integration
- Task navigation and verification
- AskUserQuestion pattern for confirmations
"

# Create repository on GitHub (via web or gh CLI)
# Option A: Using gh CLI
gh repo create plan-subdivider --public --source=. --remote=origin

# Option B: Manual
# 1. Go to https://github.com/new
# 2. Create repository named "plan-subdivider"
# 3. Add remote:
git remote add origin https://github.com/sanghyun-io/plan-subdivider.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### 2. Create Release

```bash
# Tag version 1.0.0
git tag -a v1.0.0 -m "Version 1.0.0

First stable release of Plan Subdivider Plugin.

Features:
- Automatic plan subdivision
- Structured task files with checklists
- Pre-work workflow
- Rule-based formatting
- AskUserQuestion integration
"

# Push tag
git push origin v1.0.0

# Create GitHub release (via gh CLI)
gh release create v1.0.0 \
  --title "Plan Subdivider Plugin v1.0.0" \
  --notes-file CHANGELOG.md

# Or create release manually at:
# https://github.com/sanghyun-io/plan-subdivider/releases/new
```

### 3. Update Plugin Configuration

Before deploying, update these files with your actual GitHub information:

#### `.claude-plugin/plugin.json`
```json
{
  "homepage": "https://github.com/sanghyun-io/plan-subdivider",
  "repository": "https://github.com/sanghyun-io/plan-subdivider"
}
```

#### `.claude-plugin/marketplace.json`
```json
{
  "owner": {
    "name": "sanghyun-io",
    "email": "ppkimsanh@gmail.com"
  },
  "plugins": [{
    "repo": "sanghyun-io/plan-subdivider"
  }]
}
```

#### `README.md`
Replace all instances of:
- `sanghyun-io` → Your GitHub username
- `ppkimsanh@gmail.com` → Your email

### 4. Test Installation Locally

Before publishing, test the plugin locally:

```bash
# Copy to Claude plugins directory
cp -r plan-subdivider ~/.claude/plugins/plan-structure

# Start Claude Code and verify
claude-code

# In Claude session, check:
/plugin list
# Should show "plan-structure"

# Test subdivision
/subdivide
```

### 5. Publish to Marketplace

#### Option A: Official Claude Code Marketplace (if available)

Follow Claude Code's official marketplace submission process.

#### Option B: Self-Hosted Marketplace

```bash
# Create marketplace repository
gh repo create claude-plugins-marketplace --public

# Create marketplace index
cat > marketplace.json << 'EOF'
{
  "name": "sanghyun-io Plugins",
  "owner": {
    "name": "sanghyun-io",
    "email": "ppkimsanh@gmail.com"
  },
  "plugins": [
    {
      "name": "plan-structure",
      "source": "github",
      "repo": "sanghyun-io/plan-subdivider",
      "description": "Structured planning system with automatic task subdivision",
      "version": "1.0.0",
      "keywords": ["planning", "workflow", "subdivision"]
    }
  ]
}
EOF

# Push to GitHub
git init
git add marketplace.json
git commit -m "Add Plan Subdivider Plugin to marketplace"
git remote add origin https://github.com/sanghyun-io/claude-plugins-marketplace.git
git push -u origin main
```

#### Option C: Direct Installation URL

Users can install directly from GitHub:

```bash
# Users run:
/plugin install https://github.com/sanghyun-io/plan-subdivider
```

## 🧪 Testing Checklist

Before publishing, verify:

- [ ] All files are present (check structure above)
- [ ] GitHub URLs updated in all files
- [ ] Plugin installs successfully locally
- [ ] Rules are auto-installed to `.claude/rules/`
- [ ] `/subdivide` skill works correctly
- [ ] AskUserQuestion prompts appear
- [ ] Example plan can be subdivided
- [ ] README documentation is clear
- [ ] License is correct

## 📣 Promotion

After deployment, share your plugin:

### Claude Code Community
- Post in Claude Code Discord/Slack
- Share on relevant forums

### Documentation
- Update your project's documentation
- Add usage examples
- Create tutorial videos (optional)

### Social Media
```markdown
🚀 Just released Plan Subdivider Plugin for Claude Code!

✅ Auto-subdivide complex plans
✅ Structured task checklists
✅ Sequential navigation
✅ Built-in verification

Install: /plugin install https://github.com/sanghyun-io/plan-subdivider

#ClaudeCode #ProductivityTools
```

## 🔄 Future Updates

When releasing new versions:

```bash
# Update version in plugin.json and marketplace.json
# Update CHANGELOG.md
# Commit changes
git add .
git commit -m "Release v1.1.0: [describe changes]"

# Tag new version
git tag -a v1.1.0 -m "Version 1.1.0"
git push origin main
git push origin v1.1.0

# Create GitHub release
gh release create v1.1.0 --title "v1.1.0" --notes-file CHANGELOG.md
```

## 📞 Support

- **Issues**: https://github.com/sanghyun-io/plan-subdivider/issues
- **Discussions**: https://github.com/sanghyun-io/plan-subdivider/discussions
- **Email**: ppkimsanh@gmail.com

---

**Happy deploying! 🎉**
