# Sound Files Directory

Organize your sound files into category subdirectories. Each category corresponds to a Claude Code event:

## Directory Structure

```
sounds/
├── session-start/       # Played when Claude starts a session
├── user-prompt-submit/  # Played when you submit a prompt
└── notification/        # Played when Claude needs permission
```

## Adding Sounds

1. Place sound files (MP3 or WAV) in the appropriate category folder
2. You can add multiple files per category - one will be randomly selected
3. You can skip categories you don't want sounds for

## Examples

**Session Start** (Claude is ready):
- Greeting or ready acknowledgment sounds
- Multiple files for variety

**User Prompt Submit** (You give a command):
- Confirmation or acknowledgment sounds
- Multiple files for variety

**Notification** (Needs permission):
- Alert or attention sounds
- Single or multiple files

## Sound Ideas

- **Warcraft 3**: Peon/Peasant voice lines
- **StarCraft**: SCV/Probe/Drone quotes
- **Portal**: GLaDOS or Wheatley
- **Custom**: Any sound files you want

The install script will copy all sound files from these subdirectories to `~/.claude/sounds/` maintaining the category structure.
