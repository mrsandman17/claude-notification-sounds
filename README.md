# 🔊 Custom Notification Sounds for Claude Code

Add custom audio notifications to Claude Code. Hear sounds when Claude finishes tasks or needs your attention.

**⚠️ macOS Only** - Uses `afplay` command (built-in on macOS)

## 📦 Installation

### Step 1: Get Sound Files

Add your MP3 sound files to the `sounds/` directory. You can use any sounds you want!

**Example: Warcraft 3 Peon Sounds**

Ask Claude to download them for you:

```
Please help me download the following Warcraft 3 Peon sound files as MP3s and save them to the sounds/ directory:
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

### Step 2: Install the Plugin

```bash
git clone https://github.com/mrsandman17/claude-notification-sounds.git /tmp/claude-notification-sounds
cd /tmp/claude-notification-sounds
./install.sh
```

Done! Random sounds will now play when Claude finishes tasks.

## 🎯 How It Works

The plugin:
1. Copies your MP3 files to `~/.claude/sounds/`
2. Configures Claude hooks to play random sounds on:
   - **Stop**: When Claude finishes a task
   - **Notification**: When Claude needs permission

## 🎨 Sound Ideas

- **Game sounds**: Warcraft, StarCraft, Portal, Half-Life
- **Movie quotes**: Star Wars, LotR, Marvel
- **Meme sounds**: Vine booms, "Bruh", "Oof"
- **Music clips**: Short instrument riffs or beats
- **Voice lines**: Custom recordings

## 🛠️ Customization

After installation, edit `~/.claude/settings.json` to:
- Change which events trigger sounds
- Use specific sounds instead of random
- Add more hook types (Start, Error)

## 📄 License

MIT License
