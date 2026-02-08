#!/bin/bash

# Script to cycle through system color themes
# Available themes: 5 different color schemes

THEME_FILE="$HOME/.config/waybar/current_theme"

# Function to darken color for glow effect
darken_color() {
    local color=$1
    # Remove # if present
    color=${color#\#}
    
    # Extract RGB components
    local r=$((16#${color:0:2}))
    local g=$((16#${color:2:2}))
    local b=$((16#${color:4:2}))
    
    # Darken by 20% (less darkening for more visible glow)
    r=$((r * 8 / 10))
    g=$((g * 8 / 10))
    b=$((b * 8 / 10))
    
    # Ensure minimum values for visibility
    r=$((r < 32 ? 32 : r))
    g=$((g < 32 ? 32 : g))
    b=$((b < 32 ? 32 : b))
    
    # Convert back to hex
    printf "#%02x%02x%02x" $r $g $b
}

# Define all themes
THEME_NAMES=("theme1" "theme2" "theme3" "theme4" "theme5")
THEME_COLORS=("#f8f8ff" "#00ff00" "#df3079" "#e9b200" "#aaf9b6")
GLOW_COLOR=("#000000" "#00ff00" "#00ff00" "#00ff00" "#21BF36")
THEME_BGS=("#000000" "#000000" "#000000" "#000000" "#000000")
THEME_ACCENTS=("#df3079" "#ff0000" "#ff6b9d" "#00ff88" "#ffcc00")

# Read current theme index
if [ -f "$THEME_FILE" ]; then
    CURRENT_THEME=$(cat "$THEME_FILE")
    # Find current theme index
    CURRENT_INDEX=-1
    for i in "${!THEME_NAMES[@]}"; do
        if [ "${THEME_NAMES[$i]}" = "$CURRENT_THEME" ]; then
            CURRENT_INDEX=$i
            break
        fi
    done
    if [ $CURRENT_INDEX -eq -1 ]; then
        CURRENT_INDEX=0
    fi
else
    CURRENT_INDEX=0
fi

# Cycle to next theme
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#THEME_NAMES[@]} ))
NEW_THEME="${THEME_NAMES[$NEXT_INDEX]}"
COLOR="${THEME_COLORS[$NEXT_INDEX]}"
GLOW="${GLOW_COLOR[$NEXT_INDEX]}"
BG="${THEME_BGS[$NEXT_INDEX]}"
ACCENT="${THEME_ACCENTS[$NEXT_INDEX]}"

# Calculate glow color (darker version of text color)
# GLOW_COLOR=$(darken_color "$COLOR")

# Update Waybar style.css
WAYBAR_STYLE="$HOME/.config/waybar/style.css"
sed -i "s/color: #[0-9a-fA-F]\{6\};/color: $COLOR;/" "$WAYBAR_STYLE"
sed -i "s/border.*solid #[0-9a-fA-F]\{6\};/border-bottom: 2px solid $COLOR;/" "$WAYBAR_STYLE"
sed -i "s/background: #[0-9a-fA-F]\{6\};/background: $BG;/" "$WAYBAR_STYLE"
sed -i "s/text-shadow: 0 0 2px #[0-9a-fA-F]\{6\}, 0 0 4px #[0-9a-fA-F]\{6\};/text-shadow: none;/" "$WAYBAR_STYLE"

# Update Hyprland config
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"
sed -i "s/col\.active_border = rgba([0-9a-fA-F]\{8\})/col.active_border = rgba(${COLOR:1}ff)/" "$HYPR_CONF"

# Update Kitty config
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
sed -i "s/foreground            #[0-9a-fA-F]\{6\}/foreground            $COLOR/" "$KITTY_CONF"
sed -i "s/background            #[0-9a-fA-F]\{6\}/background            $BG/" "$KITTY_CONF"
sed -i "s/cursor                #[0-9a-fA-F]\{6\}/cursor                $COLOR/" "$KITTY_CONF"
sed -i "s/selection_background  #[0-9a-fA-F]\{6\}/selection_background  $COLOR/" "$KITTY_CONF"
sed -i "s/selection_foreground  #[0-9a-fA-F]\{6\}/selection_foreground  $BG/" "$KITTY_CONF"

# Update Wofi style.css
WOFI_STYLE="$HOME/.config/wofi/style.css"
sed -i "s/border: 2px solid #[0-9a-fA-F]\{6\};/border: 2px solid $COLOR;/" "$WOFI_STYLE"
sed -i "s/color: #[0-9a-fA-F]\{6\};/color: $COLOR;/" "$WOFI_STYLE"
sed -i "s/border: 1px solid #[0-9a-fA-F]\{6\};/border: 1px solid $COLOR;/" "$WOFI_STYLE"

# Save new theme
echo "$NEW_THEME" > "$THEME_FILE"

# Reload configs
hyprctl reload
killall waybar && waybar &
killall kitty
pkill -USR1 kitty  # Reload kitty configs

# Show theme info with color preview
THEME_DISPLAY_NAME=""
case $NEW_THEME in
    "theme1") THEME_DISPLAY_NAME="👻 Branco Fantasma" ;;
    "theme2") THEME_DISPLAY_NAME="🟢 Verde Matrix" ;;
    "theme3") THEME_DISPLAY_NAME="🌸 Rosa Magenta" ;;
    "theme4") THEME_DISPLAY_NAME="💚 Verde Neon" ;;
    "theme5") THEME_DISPLAY_NAME="🌟 Dourado" ;;
    *) THEME_DISPLAY_NAME="$NEW_THEME" ;;
esac