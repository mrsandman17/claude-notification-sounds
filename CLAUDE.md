# Development Guidelines

This file guides AI agents (and humans) working on this project.

## Core Principles

1. **Non-destructive**: Never break existing user configurations
2. **Simple**: This is a small plugin - avoid over-engineering
3. **Clear**: Both humans and AI agents should understand the code

## Git Workflow

### For All Changes:

1. **Create a branch** from main:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/bug-description
   ```

2. **Make your changes** and test thoroughly

3. **Commit with clear messages**:
   ```bash
   git add -A
   git commit -m "Type: Brief description

   - Detailed point 1
   - Detailed point 2"
   ```

4. **Push and open a PR**:
   ```bash
   git push -u origin feature/your-feature-name
   ```
   Then open a Pull Request on GitHub for review

### Never Push Directly to Main

Always use branches and PRs, even for small fixes. This allows for review and discussion.

## Testing Changes

Before opening a PR:

1. **Uninstall** the current plugin:
   ```bash
   rm -rf ~/.claude/plugins/cache/custom/notification-sounds
   rm ~/.claude/sounds/*.mp3
   ```
   Remove hooks from `~/.claude/settings.json`

2. **Test fresh install** following README exactly:
   ```bash
   git clone https://github.com/mrsandman17/claude-notification-sounds.git /tmp/test-install
   cd /tmp/test-install
   # Add test sound files
   cp ~/path/to/test.mp3 sounds/
   ./install.sh
   ```

3. **Verify**:
   - Sounds copied to `~/.claude/sounds/`
   - Plugin installed to correct directory
   - Settings.json has hooks configured
   - **Existing hooks preserved** (critical!)
   - Test with actual Claude Code usage

## Code Changes

### Installation Script (install.sh)

- **Must be idempotent**: Safe to run multiple times
- **Must preserve existing settings**: Append, never overwrite
- **Must validate inputs**: Check for sound files before proceeding
- Test error cases (no sounds, no Python, etc.)

### Documentation (README.md)

- **Step-by-step clarity**: Both humans and AI should follow easily
- **Numbered steps in order**: Clone → Add sounds → Verify → Install
- Test by following README exactly from scratch
- Include troubleshooting for common issues

## Platform Support

- **Currently**: macOS only (`afplay`)
- **Future**: If adding cross-platform support, detect OS first
- **Don't break macOS**: Keep existing behavior when adding platforms

## What Not to Do

- ❌ Push sound files to git (they're in .gitignore)
- ❌ Overwrite user's existing hooks
- ❌ Add dependencies beyond Python 3 and bash
- ❌ Make breaking changes without clear migration path
- ❌ Push directly to main
- ❌ Over-engineer for hypothetical features

## When to Update This File

Update CLAUDE.md when:
- A mistake is made and corrected (add a rule to prevent it)
- Workflow changes (new testing requirements, etc.)
- Common issues discovered (add to troubleshooting)

Keep this file concise - delete outdated rules as the project evolves.
