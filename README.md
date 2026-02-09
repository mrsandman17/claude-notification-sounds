# 🔊 Custom Notification Sounds for Claude Code

Add custom audio notifications to Claude Code. Hear sounds when Claude finishes tasks or needs your attention.

**⚠️ macOS Only** - Uses `afplay` command (built-in on macOS)

## 📦 Installation

Follow these steps **in order**:

### Step 1: Clone the Repository

```bash
git clone https://github.com/mrsandman17/claude-notification-sounds.git /tmp/claude-notification-sounds
cd /tmp/claude-notification-sounds
```

### Step 2: Add Your Sound Files

Add MP3 files to the `sounds/` directory in the cloned repository.

**Option A: Use Your Own Sounds**

```bash
# Copy your MP3 files to the sounds directory
cp /path/to/your/sounds/*.mp3 sounds/
```

**Option B: Download Warcraft 3 Peon Sounds**

Ask Claude Code (or any AI assistant) to download them:

```
Please help me download the following Warcraft 3 Peon sound files as MP3s and save them to the sounds/ directory in /tmp/claude-notification-sounds:
- Work work
- Ready to work
- Something need doing?
- Me busy, leave me alone
- Okey dokey
- Jobs done
- More work
- Yes me lord

Save each file with descriptive names like work_work.mp3, ready_to_work.mp3, etc.
```

### Step 3: Verify Sound Files

```bash
# Make sure you have MP3 files in the sounds directory
ls sounds/*.mp3
```

You should see your MP3 files listed. If not, go back to Step 2.

### Step 4: Run the Installer

```bash
./install.sh
```

**Done!** You'll now hear random sounds when Claude finishes tasks or needs permission.

## ✅ What the Installer Does

The install script automatically:
1. Copies all MP3 files from `sounds/` to `~/.claude/sounds/`
2. Installs the plugin to `~/.claude/plugins/cache/custom/notification-sounds/1.0.0/`
3. Updates `~/.claude/settings.json` to configure hooks for:
   - **Stop** event: Plays when Claude finishes a task
   - **Notification** event: Plays when Claude needs permission
4. Enables the plugin in your settings

## 🎯 How It Works

When configured, Claude Code will play a random MP3 from `~/.claude/sounds/` whenever:
- You finish working with Claude (Stop hook)
- Claude needs your permission for something (Notification hook)

The plugin uses macOS's built-in `afplay` command to play sounds.

## 🎨 Sound Ideas

- **Game sounds**: Warcraft, StarCraft, Portal, Half-Life, Zelda
- **Movie quotes**: Star Wars, LotR, Marvel, Star Trek
- **Meme sounds**: Vine booms, "Bruh", "Oof", wilhelm scream
- **Music clips**: Short instrument riffs or beats
- **Voice lines**: Custom recordings, voice memos

## 🛠️ Customization

After installation, you can customize by editing `~/.claude/settings.json`:

**Play a specific sound instead of random:**
```json
"command": "afplay ~/.claude/sounds/work_work.mp3"
```

**Add sounds to more events:**
```json
"hooks": {
  "Start": [{
    "hooks": [{
      "type": "command",
      "command": "afplay ~/.claude/sounds/start_sound.mp3"
    }]
  }],
  "Error": [{
    "hooks": [{
      "type": "command",
      "command": "afplay ~/.claude/sounds/error_sound.mp3"
    }]
  }]
}
```

**Add more sounds later:**
```bash
cp new_sound.mp3 ~/.claude/sounds/
```

## 🐛 Troubleshooting

**No sound playing?**
- Check your volume is on
- Test manually: `afplay ~/.claude/sounds/work_work.mp3`
- Verify files exist: `ls ~/.claude/sounds/`

**Plugin not working?**
- Check `~/.claude/settings.json` has `"notification-sounds@custom": true`
- Verify hooks are configured (see "What the Installer Does" section)

**Install script fails?**
- Make sure you added MP3 files to `sounds/` directory before running
- Check you have Python 3 installed: `python3 --version`

## 📄 License

MIT License
