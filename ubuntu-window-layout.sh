#!/bin/bash
LAYOUT_FILE="$HOME/.current_window_layout"

save_layout() {
    > "$LAYOUT_FILE"
    # Capture all active, visible window IDs
    wmctrl -l | awk '{print $1}' | while read -r win_hex; do
        # Convert hex ID to decimal for xdotool
        win_id=$(printf "%d" "$win_hex" 2>/dev/null)
        [ -z "$win_id" ] && continue

        # Get window name and class
        name=$(xdotool getwindowname "$win_id" 2>/dev/null)
        class=$(xdotool getwindowclassname "$win_id" 2>/dev/null)
        
        # Skip desktop backgrounds, panels, and empty items
        if [[ -z "$name" || "$class" == "Nautilus" || "$name" == "gnome-shell" || "$name" == "Desktop" ]]; then
            continue
        fi
        
        # Capture the absolute multi-monitor X, Y, width, and height coordinates
        eval $(xdotool getwindowgeometry --shell "$win_id")
        echo "$win_id $X $Y $WIDTH $HEIGHT" >> "$LAYOUT_FILE"
     done
}

restore_layout() {
    if [ -f "$LAYOUT_FILE" ]; then
        while read -r win_id x y width height; do
            if xdotool getwindowname "$win_id" &>/dev/null; then
                # 1. Strip structural maximize/fullscreen constraints that lock position
                wmctrl -i -r "$win_id" -b remove,maximized_vert,maximized_horz,fullscreen
                
                # 2. Force wake the window context
                xdotool windowactivate "$win_id" 2>/dev/null
                
                # 3. Apply the absolute cross-monitor coordinates
                xdotool windowmove "$win_id" "$x" "$y"
                xdotool windowsize "$win_id" "$width" "$height"
            fi
        done < "$LAYOUT_FILE"
    fi
}

# Monitor system DBus for screen lock states
dbus-monitor --session "type='signal',interface='org.gnome.ScreenSaver'" | while read -r line; do
    if echo "$line" | grep -q "boolean true"; then
        # Screen is locking -> Immediately save geometry across all monitors
        save_layout
    elif echo "$line" | grep -q "boolean false"; then
        # Screen unlocked -> Wait 3 seconds for X11 multi-display outputs to initialize
        sleep 3
        restore_layout
    fi
done

save_layout
