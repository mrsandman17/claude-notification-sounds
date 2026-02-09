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

# Check if sound categories exist and have files
CATEGORIES=("session-start" "user-prompt-submit" "notification" "stop")
TOTAL_SOUND_COUNT=0

for category in "${CATEGORIES[@]}"; do
    if [ -d "$SCRIPT_DIR/sounds/$category" ]; then
        COUNT=$(find "$SCRIPT_DIR/sounds/$category" -name "*.mp3" -o -name "*.wav" 2>/dev/null | wc -l | tr -d ' ')
        TOTAL_SOUND_COUNT=$((TOTAL_SOUND_COUNT + COUNT))
    fi
done

if [ "$TOTAL_SOUND_COUNT" -eq 0 ]; then
    echo "⚠️  No sound files found in sounds/ subdirectories!"
    echo ""
    echo "Please add your sound files to these subdirectories:"
    echo "  • sounds/session-start/ - Played when Claude starts"
    echo "  • sounds/user-prompt-submit/ - Played when you submit a prompt"
    echo "  • sounds/notification/ - Played when Claude needs permission"
    echo "  • sounds/stop/ - Played when Claude finishes"
    echo ""
    echo "See README.md for examples and instructions."
    echo ""
    exit 1
fi

# Create directories
mkdir -p "$PLUGIN_DIR"
mkdir -p "$SOUNDS_DIR"

# Create category subdirectories
for category in "${CATEGORIES[@]}"; do
    mkdir -p "$SOUNDS_DIR/$category"
done

# Copy plugin files
echo "📦 Copying plugin files..."
cp -r "$SCRIPT_DIR"/.claude-plugin "$PLUGIN_DIR/"
cp "$SCRIPT_DIR"/README.md "$PLUGIN_DIR/"

# Copy sound files by category
echo "🔊 Installing sound files..."
for category in "${CATEGORIES[@]}"; do
    if [ -d "$SCRIPT_DIR/sounds/$category" ]; then
        COUNT=$(find "$SCRIPT_DIR/sounds/$category" \( -name "*.mp3" -o -name "*.wav" \) 2>/dev/null | wc -l | tr -d ' ')
        if [ "$COUNT" -gt 0 ]; then
            cp "$SCRIPT_DIR/sounds/$category"/*.mp3 "$SOUNDS_DIR/$category/" 2>/dev/null || true
            cp "$SCRIPT_DIR/sounds/$category"/*.wav "$SOUNDS_DIR/$category/" 2>/dev/null || true
            echo "  ✅ $category: $COUNT sound(s)"
        fi
    fi
done
echo "✅ Installed $TOTAL_SOUND_COUNT sound files to $SOUNDS_DIR"

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

# Configure hooks with category-based sounds
if 'hooks' not in settings:
    settings['hooks'] = {}

# Define hooks with their category folders
hook_configs = {
    'SessionStart': {
        'category': 'session-start',
        'matcher': None  # No matcher for SessionStart
    },
    'UserPromptSubmit': {
        'category': 'user-prompt-submit',
        'matcher': None  # No matcher for UserPromptSubmit
    },
    'Notification': {
        'category': 'notification',
        'matcher': 'permission_prompt'
    },
    'Stop': {
        'category': 'stop',
        'matcher': None  # No matcher for Stop
    }
}

# Helper function to check if a hook is a notification sound hook
def is_notification_sound_hook(hook_group):
    if 'hooks' not in hook_group:
        return False
    for hook in hook_group['hooks']:
        cmd = hook.get('command', '')
        if hook.get('type') == 'command' and '~/.claude/sounds/' in cmd and 'afplay' in cmd:
            return True
    return False

# Configure each hook type - REPLACE existing notification sound hooks to prevent duplicates
for hook_name, config in hook_configs.items():
    category = config['category']
    matcher = config['matcher']

    # Command to play random sound from category folder
    sound_cmd = f'afplay "$(find ~/.claude/sounds/{category} \\( -name \'*.mp3\' -o -name \'*.wav\' \\) | sort -R | head -n 1)"'

    # Build hook configuration
    hook_config = {
        'hooks': [{
            'type': 'command',
            'command': sound_cmd
        }]
    }

    # Add matcher if specified
    if matcher:
        hook_config['matcher'] = matcher

    # Initialize hook list if not present
    if hook_name not in settings['hooks']:
        settings['hooks'][hook_name] = []

    # Remove old notification sound hooks to prevent duplicates
    settings['hooks'][hook_name] = [
        h for h in settings['hooks'][hook_name]
        if not is_notification_sound_hook(h)
    ]

    # Add our hook
    settings['hooks'][hook_name].append(hook_config)
    print(f"✅ Configured {hook_name} hook")

# Write updated settings
with open(settings_file, 'w') as f:
    json.dump(settings, f, indent=2)

print("✅ Settings updated successfully")
PYTHON_SCRIPT

echo ""
echo "✅ Installation complete!"
echo ""
echo "🔊 Plugin configured with $TOTAL_SOUND_COUNT custom sounds"
echo "   • Plugin: notification-sounds@custom"
echo "   • Sounds directory: $SOUNDS_DIR"
echo "   • Categories: session-start, user-prompt-submit, notification, stop"
echo ""
echo "You'll now hear sounds when:"
echo "   • SessionStart: Claude is ready (session-start sounds)"
echo "   • UserPromptSubmit: You submit a prompt (user-prompt-submit sounds)"
echo "   • Notification: Claude needs permission (notification sounds)"
echo "   • Stop: Claude finishes work (stop sounds)"
echo ""
echo "💡 To customize: edit $SETTINGS_FILE"
echo "💡 To add more sounds: copy files to $SOUNDS_DIR/<category>/"
echo ""
echo "Enjoy! 🎉"
