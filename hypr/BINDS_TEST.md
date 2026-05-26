# Hyprland Keybindings Test Checklist

All bindings extracted from `hyprland.lua`. Tick each one as you verify it works.

## Apps

- [x] `SUPER + Q` — Launch terminal (kitty)
- [x] `SUPER + F` — Toggle fullscreen
- [x] `SUPER + B` — Launch browser (helium-browser) + run `./open.sh`
- [x] `SUPER + C` — Close active window
- [ ] `SUPER + M` — Exit Hyprland
- [x] `SUPER + V` — Toggle floating
- [x] `SUPER + CTRL + V` — Toggle floating + center + resize to 1920×1080
- [x] `SUPER + SPACE` — Launch app menu (walker)
- [x] `SUPER + O` — Launch Obsidian
- [x] `SUPER + R` — Reload Hyprland config

## System pane / popups

- [x] `SUPER + P` — Toggle floating tmux system pane (cliamp + yazi + btop)
- [x] `SUPER + E` — Toggle Yazi popup

## Mouse side buttons (workspace cycle)

- [x] `mouse:275` — Previous workspace (e-1)
- [x] `mouse:276` — Next workspace (e+1)

## Move focus (vim keys)

- [x] `SUPER + H` — Focus left
- [x] `SUPER + J` — Focus down
- [x] `SUPER + K` — Focus up
- [x] `SUPER + L` — Focus right

## Move window (vim keys)

- [x] `SUPER + SHIFT + H` — Move window left
- [x] `SUPER + SHIFT + J` — Move window down
- [x] `SUPER + SHIFT + K` — Move window up
- [x] `SUPER + SHIFT + L` — Move window right

## Resize active window

- [x] `SUPER + ALT + L` — Resize +100 width
- [x] `SUPER + ALT + H` — Resize -100 width
- [x] `SUPER + ALT + K` — Resize -100 height
- [x] `SUPER + ALT + J` — Resize +100 height
- [x] `SUPER + ALT + R` — Resize to exact 1000×800
- [x] `SUPER + SHIFT + C` — Force float + resize 1920×1080 + center

## External monitor brightness (ddccontrol) [not configured]

- [x] `SUPER + CTRL + 1` — Brightness 10
- [x] `SUPER + CTRL + 2` — Brightness 20
- [x] `SUPER + CTRL + 3` — Brightness 30
- [x] `SUPER + CTRL + 4` — Brightness 40
- [x] `SUPER + CTRL + 5` — Brightness 50
- [x] `SUPER + CTRL + 6` — Brightness 60
- [x] `SUPER + CTRL + 7` — Brightness 70
- [x] `SUPER + CTRL + 8` — Brightness 80
- [x] `SUPER + CTRL + 9` — Brightness 90
- [x] `SUPER + CTRL + 0` — Brightness 100
- [x] `SUPER + CTRL + R` — Brightness 100 (reset)

## Move floating windows + hyprpanel

- [x] `SUPER + CTRL + H` — Toggle hyprpanel + move floating -50 X
- [x] `SUPER + CTRL + L` — Move floating +50 X
- [x] `SUPER + CTRL + K` — Move floating -50 Y
- [x] `SUPER + CTRL + J` — Move floating +50 Y

## Workspaces — focus

- [x] `SUPER + 1` — Focus workspace 1
- [x] `SUPER + 2` — Focus workspace 2
- [x] `SUPER + 3` — Focus workspace 3
- [x] `SUPER + 4` — Focus workspace 4
- [x] `SUPER + 5` — Focus workspace 5
- [x] `SUPER + 6` — Focus workspace 6
- [x] `SUPER + 7` — Focus workspace 7
- [x] `SUPER + 8` — Focus workspace 8
- [x] `SUPER + 9` — Focus workspace 9
- [x] `SUPER + 0` — Focus workspace 10

## Workspaces — move window

- [x] `SUPER + SHIFT + 1` — Move window to workspace 1
- [x] `SUPER + SHIFT + 2` — Move window to workspace 2
- [x] `SUPER + SHIFT + 3` — Move window to workspace 3
- [x] `SUPER + SHIFT + 4` — Move window to workspace 4
- [x] `SUPER + SHIFT + 5` — Move window to workspace 5
- [x] `SUPER + SHIFT + 6` — Move window to workspace 6
- [x] `SUPER + SHIFT + 7` — Move window to workspace 7
- [x] `SUPER + SHIFT + 8` — Move window to workspace 8
- [x] `SUPER + SHIFT + 9` — Move window to workspace 9
- [x] `SUPER + SHIFT + 0` — Move window to workspace 10

## Volume (swayosd-client) [not configured]

- [ ] `XF86AudioRaiseVolume` — Volume +1 (precise)
- [ ] `XF86AudioLowerVolume` — Volume -1 (precise)
- [ ] `XF86AudioMute` — Toggle output mute
- [ ] `XF86AudioMicMute` — Toggle mic mute

## Laptop brightness fallback [not configured]

- [ ] `XF86MonBrightnessUp` — brightnessctl +10%
- [ ] `XF86MonBrightnessDown` — brightnessctl -10%

## Screenshots (hyprshot) [not configured]

- [x] `ALT + SHIFT + 2` — Region screenshot
- [x] `ALT + SHIFT + 3` — Window screenshot
- [x] `ALT + SHIFT + 4` — Full output screenshot

## Special workspaces

- [x] `SUPER + S` — Toggle scratchpad + toggle-hyprpanel.sh
- [x] `SUPER + CTRL + SHIFT + 5` — Move active window to `special:magic`

## Scroll-switch workspaces

- [x] `SUPER + mouse_down` — Next workspace (e+1)
- [x] `SUPER + mouse_up` — Previous workspace (e-1)

## Mouse drag (move/resize)

- [x] `SUPER + mouse:272` (LMB) — Drag to move window
- [x] `SUPER + mouse:273` (RMB) — Drag to resize window
