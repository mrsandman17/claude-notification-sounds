# Sound Files Directory

Organize your sound files into category subdirectories. Each category corresponds to a Claude Code event:

## Directory Structure

```
sounds/
├── session-start/       # Played when Claude starts a session
├── user-prompt-submit/  # Played when you submit a prompt
├── notification/        # Played when Claude needs permission
└── stop/                # Played when Claude finishes work
```

## Adding Sounds

1. Place sound files (MP3 or WAV) in the appropriate category folder
2. You can add multiple files per category - one will be randomly selected
3. You can skip categories you don't want sounds for

## Examples

**Session Start** (Claude is ready):
- ready_to_work.mp3
- something_need_doing.mp3
- yes_me_lord.mp3

**User Prompt Submit** (You give a command):
- okeydokey.mp3
- righto.mp3

**Notification** (Needs permission):
- more_work.mp3

**Stop** (Work complete):
- me_busy.mp3
- jobs_done.mp3

## Sound Ideas

- **Warcraft 3**: Peon/Peasant voice lines
- **StarCraft**: SCV/Probe/Drone quotes
- **Portal**: GLaDOS or Wheatley
- **Custom**: Any sound files you want

The install script will copy all sound files from these subdirectories to `~/.claude/sounds/` maintaining the category structure.
