#!/bin/bash

# Custom Notification Sounds Plugin Installer for Claude Code
# This script installs the plugin and configures notification sounds

set -e

PLUGIN_DIR="$HOME/.claude/plugins/cache/custom/notification-sounds/1.0.0"
SOUNDS_DIR="$HOME/.claude/sounds"
SETTINGS_FILE="$HOME/.claude/settings.json"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔊 Installing Custom Notification Sounds Plugin for Claude Code..."
echo ""

# Check if there are any sound files
SOUND_COUNT=$(find "$SCRIPT_DIR/sounds" -name "*.mp3" 2>/dev/null | wc -l | tr -d ' ')
if [ "$SOUND_COUNT" -eq 0 ]; then
    echo "⚠️  No MP3 files found in sounds/ directory!"
    echo ""
    echo "Please add your MP3 sound files to the sounds/ directory first."
    echo "See README.md for examples and instructions."
    echo ""
    exit 1
fi

# Create directories
mkdir -p "$PLUGIN_DIR"
mkdir -p "$SOUNDS_DIR"

# Copy plugin files
echo "📦 Copying plugin files..."
cp -r "$SCRIPT_DIR"/.claude-plugin "$PLUGIN_DIR/"
cp "$SCRIPT_DIR"/README.md "$PLUGIN_DIR/"

# Copy sound files
echo "🔊 Installing sound files..."
cp "$SCRIPT_DIR"/sounds/*.mp3 "$SOUNDS_DIR/" 2>/dev/null
echo "✅ Installed $SOUND_COUNT sound files to $SOUNDS_DIR"

# Check if settings.json exists
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "⚠️  Settings file not found at $SETTINGS_FILE"
    echo "Creating default settings..."
    echo '{
  "model": "sonnet",
  "hooks": {},
  "enabledPlugins": {}
}' > "$SETTINGS_FILE"
fi

# Update settings.json to enable the plugin and configure hooks
echo "⚙️  Configuring Claude settings..."

# Use Python to safely update JSON (more reliable than sed/awk)
python3 << 'PYTHON_SCRIPT'
import json
import sys
import os

settings_file = os.path.expanduser("~/.claude/settings.json")

# Read current settings
with open(settings_file, 'r') as f:
    settings = json.load(f)

# Add plugin to enabledPlugins
if 'enabledPlugins' not in settings:
    settings['enabledPlugins'] = {}
settings['enabledPlugins']['notification-sounds@custom'] = True

# Configure hooks with randomized sounds
if 'hooks' not in settings:
    settings['hooks'] = {}

# Random sound command (macOS compatible)
random_sound_cmd = 'afplay "$(find ~/.claude/sounds -name \'*.mp3\' | sort -R | head -n 1)"'

# Helper function to check if our hook already exists
def has_notification_sound_hook(hooks_list):
    if not hooks_list:
        return False
    for hook_group in hooks_list:
        if 'hooks' in hook_group:
            for hook in hook_group['hooks']:
                if hook.get('type') == 'command' and '~/.claude/sounds' in hook.get('command', ''):
                    return True
    return False

# Configure Stop hook (only if not already present)
if 'Stop' not in settings['hooks']:
    settings['hooks']['Stop'] = []

if not has_notification_sound_hook(settings['hooks']['Stop']):
    # Append our hook to existing hooks (non-destructive)
    settings['hooks']['Stop'].append({
        'hooks': [{
            'type': 'command',
            'command': random_sound_cmd
        }]
    })
    print("✅ Added Stop hook")
else:
    print("ℹ️  Stop hook already configured, skipping")

# Configure Notification hook (only if not already present)
if 'Notification' not in settings['hooks']:
    settings['hooks']['Notification'] = []

# Check if our notification hook exists
notification_exists = False
for hook_group in settings['hooks']['Notification']:
    if hook_group.get('matcher') == 'permission_prompt':
        if has_notification_sound_hook([hook_group]):
            notification_exists = True
            break

if not notification_exists:
    # Append our hook to existing hooks (non-destructive)
    settings['hooks']['Notification'].append({
        'matcher': 'permission_prompt',
        'hooks': [{
            'type': 'command',
            'command': random_sound_cmd
        }]
    })
    print("✅ Added Notification hook")
else:
    print("ℹ️  Notification hook already configured, skipping")

# Write updated settings
with open(settings_file, 'w') as f:
    json.dump(settings, f, indent=2)

print("✅ Settings updated successfully")
PYTHON_SCRIPT

echo ""
echo "✅ Installation complete!"
echo ""
echo "🔊 Plugin configured with $SOUND_COUNT custom sounds"
echo "   • Plugin: notification-sounds@custom"
echo "   • Sounds directory: $SOUNDS_DIR"
echo "   • Hooks: Stop and Notification events"
echo ""
echo "You'll now hear random sounds when:"
echo "   • Claude finishes a task (Stop event)"
echo "   • Claude needs permission (Notification event)"
echo ""
echo "💡 To customize: edit $SETTINGS_FILE"
echo "💡 To add more sounds: copy MP3 files to $SOUNDS_DIR"
echo ""
echo "Enjoy! 🎉"
