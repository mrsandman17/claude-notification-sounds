# 🔊 Custom Notification Sounds for Claude Code

Add custom audio notifications to Claude Code. Hear **specific sounds** for different events - when Claude starts, when you submit prompts, when permission is needed, and when work is done.

**⚠️ macOS Only** - Uses `afplay` command (built-in on macOS)

## 📦 Installation

Follow these steps **in order**:

### Step 1: Clone the Repository

```bash
git clone https://github.com/mrsandman17/claude-notification-sounds.git /tmp/claude-notification-sounds
cd /tmp/claude-notification-sounds
```

### Step 2: Add Your Sound Files

Add sound files (MP3 or WAV) to the appropriate category subdirectories:

```
sounds/
├── session-start/       # Played when Claude starts
├── user-prompt-submit/  # Played when you submit a prompt
├── notification/        # Played when Claude needs permission
└── stop/                # Played when Claude finishes work
```

**Add your sound files:**

```bash
# Copy sound files to each category
cp /path/to/your/sounds/start1.mp3 sounds/session-start/
cp /path/to/your/sounds/start2.mp3 sounds/session-start/

cp /path/to/your/sounds/submit1.mp3 sounds/user-prompt-submit/
cp /path/to/your/sounds/submit2.mp3 sounds/user-prompt-submit/

cp /path/to/your/sounds/alert.mp3 sounds/notification/

cp /path/to/your/sounds/complete.mp3 sounds/stop/
```

**Tips:**
- Add multiple files per category for variety (one will be randomly selected)
- You can skip categories you don't want sounds for
- Supports both MP3 and WAV formats

### Step 3: Verify Sound Files

```bash
# Check that you have sounds in the categories you want
ls sounds/*/
```

You should see your sound files in the subdirectories. At least one category must have files.

### Step 4: Run the Installer

```bash
./install.sh
```

**Done!** You'll now hear category-specific sounds for each event type.

## ✅ What the Installer Does

The install script automatically:
1. Creates category subdirectories in `~/.claude/sounds/`:
   - `session-start/`
   - `user-prompt-submit/`
   - `notification/`
   - `stop/`
2. Copies sound files from each category to the corresponding `~/.claude/sounds/` subdirectory
3. Installs the plugin to `~/.claude/plugins/cache/custom/notification-sounds/1.0.0/`
4. **Non-destructively** adds hooks to `~/.claude/settings.json`:
   - **SessionStart**: Plays when Claude starts (random from session-start/)
   - **UserPromptSubmit**: Plays when you submit a prompt (random from user-prompt-submit/)
   - **Notification**: Plays when Claude needs permission (random from notification/)
   - **Stop**: Plays when Claude finishes work (random from stop/)
   - **Preserves existing hooks** - appends rather than replaces
   - **Skips if already installed** - safe to run multiple times
5. Enables the plugin in your settings

**Important:** The installer preserves all your existing settings and hooks. It only adds the notification sound hooks without removing anything.

## 🎯 How It Works

When configured, Claude Code plays a random sound from the appropriate category folder:

- **SessionStart**: When Claude starts → plays random sound from `~/.claude/sounds/session-start/`
- **UserPromptSubmit**: When you submit a prompt → plays random sound from `~/.claude/sounds/user-prompt-submit/`
- **Notification**: When Claude needs permission → plays random sound from `~/.claude/sounds/notification/`
- **Stop**: When Claude finishes → plays random sound from `~/.claude/sounds/stop/`

If a category has only one sound, it plays that sound every time. If multiple sounds exist, it randomly picks one.

The plugin uses macOS's built-in `afplay` command to play sounds.

## 🎨 Sound Ideas by Category

**Session Start** (Claude is ready):
- Greeting sounds or "ready" acknowledgments
- Game character startup sounds
- Custom voice recordings
- Startup chimes

**User Prompt Submit** (You give a command):
- Acknowledgment sounds
- Confirmation beeps or chimes
- Game character "yes" or "affirmative" sounds
- Short positive sounds

**Notification** (Needs permission):
- Alert or attention sounds
- Question sounds
- Notification chimes
- Prompt sounds

**Stop** (Work complete):
- Completion sounds
- Success chimes
- Game character completion sounds
- "Done" acknowledgments

## 🛠️ Customization

After installation, you can customize by editing `~/.claude/settings.json`:

**Play a specific sound instead of random:**
```json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "afplay ~/.claude/sounds/stop/your_sound.mp3"
      }]
    }]
  }
}
```

**Add more sounds to a category:**
```bash
# Add more sounds to any category
cp your_sound.mp3 ~/.claude/sounds/session-start/
```

**Remove a category** (if you don't want sounds for an event):
Simply remove or comment out that hook section in `~/.claude/settings.json`

## 🐛 Troubleshooting

**No sound playing?**
- Check your volume is on
- Test manually: `afplay ~/.claude/sounds/session-start/your_sound.mp3`
- Verify files exist: `ls ~/.claude/sounds/*/`
- Make sure category folders have sound files in them

**Wrong sounds playing?**
- Check that sound files are in the correct category subdirectory
- Session start sounds go in `~/.claude/sounds/session-start/`
- User prompt sounds go in `~/.claude/sounds/user-prompt-submit/`
- Notification sounds go in `~/.claude/sounds/notification/`
- Stop sounds go in `~/.claude/sounds/stop/`

**Plugin not working?**
- Check `~/.claude/settings.json` has `"notification-sounds@custom": true`
- Verify hooks are configured for all 4 events (SessionStart, UserPromptSubmit, Notification, Stop)

**Install script fails?**
- Make sure you added sound files to category subdirectories before running
- At least one category must have sound files
- Check you have Python 3 installed: `python3 --version`

**Want to add sounds to only some events?**
- You can skip categories you don't want - just don't put files in those folders
- The installer only configures hooks for categories that have sound files

## 📄 License

MIT License
