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
├── session-start/       # "Ready to work", "Something need doing", "Yes me lord"
├── user-prompt-submit/  # "Okeydokey", "Righto"
├── notification/        # "More work"
└── stop/                # "Me busy leave me alone"
```

**Option A: Use Your Own Sounds**

```bash
# Add sounds for each category
cp ready_to_work.mp3 sounds/session-start/
cp something_need_doing.mp3 sounds/session-start/
cp yes_me_lord.mp3 sounds/session-start/

cp okeydokey.mp3 sounds/user-prompt-submit/
cp righto.mp3 sounds/user-prompt-submit/

cp more_work.mp3 sounds/notification/

cp me_busy.mp3 sounds/stop/
```

**Option B: Download Warcraft 3 Peon Sounds**

Ask Claude Code (or any AI assistant):

```
Please help me download these Warcraft 3 Peon sound files and organize them:

Session Start sounds (save to sounds/session-start/):
- "Ready to work" → ready_to_work.mp3
- "Something need doing?" → something_need_doing.mp3
- "Yes me lord" → yes_me_lord.mp3

User Prompt Submit sounds (save to sounds/user-prompt-submit/):
- "Okey dokey" → okeydokey.mp3
- "Righto" → righto.mp3

Notification sound (save to sounds/notification/):
- "More work" → more_work.mp3

Stop sound (save to sounds/stop/):
- "Me busy, leave me alone" → me_busy.mp3
```

### Step 3: Verify Sound Files

```bash
# Check that you have sounds in each category
ls sounds/*/
```

You should see files in each subdirectory. If not, go back to Step 2.

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
- "Ready to work" / "Something need doing?" / "Yes me lord" (Warcraft Peon)
- "I live to serve" (Protoss Probe)
- "GLaDOS: Good morning"
- Custom: "Let's do this" / "Ready when you are"

**User Prompt Submit** (You give a command):
- "Okeydokey" / "Righto" (Warcraft Peon)
- "Affirmative" / "Roger roger" (StarCraft)
- "On it" / "You got it"
- Short confirmation sounds

**Notification** (Needs permission):
- "More work?" (Warcraft Peon)
- "Awaiting orders" / "What now?"
- Alert/notification chimes
- "Your attention please"

**Stop** (Work complete):
- "Me busy, leave me alone" / "Work work" (Warcraft Peon)
- "Jobs done" / "Complete"
- Success chimes
- "All done" / "Finished"

## 🛠️ Customization

After installation, you can customize by editing `~/.claude/settings.json`:

**Play a specific sound instead of random:**
```json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "afplay ~/.claude/sounds/stop/specific_sound.mp3"
      }]
    }]
  }
}
```

**Add more sounds to a category:**
```bash
# Add another session-start sound
cp new_ready_sound.mp3 ~/.claude/sounds/session-start/
```

**Remove a category** (if you don't want sounds for an event):
Simply remove or comment out that hook section in `~/.claude/settings.json`

## 🐛 Troubleshooting

**No sound playing?**
- Check your volume is on
- Test manually: `afplay ~/.claude/sounds/session-start/ready_to_work.mp3`
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
