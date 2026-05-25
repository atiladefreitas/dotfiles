-- Hyprland Lua config (0.55+)
-- Merged from hypr-omarchy (bindings, animations, styles, window rules, input, autostart)

------------------
---- MONITORS ----
------------------

hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@120", position = "0x0", scale = 1 })
hl.monitor({ output = "eDP-2", disabled = true })


---------------------
---- MY PROGRAMS ----
---------------------

local terminal         = "kitty"
local fileManager      = "nautilus"
local menu             = "walker"
local browser          = "helium-browser"
local obsidian         = "obsidian"

-- swayosd-client targeted at the currently-focused monitor
local osdclient        = [[swayosd-client --monitor "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')"]]

-- External-monitor brightness via ddccontrol (omarchy uses i2c-2)
local brightness10     = "ddccontrol -r 0x10 -w 00 dev:/dev/i2c-2"
local brightness20     = "ddccontrol -r 0x10 -w 20 dev:/dev/i2c-2"
local brightness30     = "ddccontrol -r 0x10 -w 30 dev:/dev/i2c-2"
local brightness40     = "ddccontrol -r 0x10 -w 40 dev:/dev/i2c-2"
local brightness50     = "ddccontrol -r 0x10 -w 50 dev:/dev/i2c-2"
local brightness60     = "ddccontrol -r 0x10 -w 60 dev:/dev/i2c-2"
local brightness70     = "ddccontrol -r 0x10 -w 70 dev:/dev/i2c-2"
local brightness80     = "ddccontrol -r 0x10 -w 80 dev:/dev/i2c-2"
local brightness90     = "ddccontrol -r 0x10 -w 90 dev:/dev/i2c-2"
local brightness0      = "ddccontrol -r 0x10 -w 100 dev:/dev/i2c-2"

-- Floating tmux "system pane" (mocp/cliamp + yazi + btop), toggled via SUPER+P
local systempaneScript =
[[bash -c 'PID=$(hyprctl clients -j | jq -r ".[] | select(.class == \"floating-systempane\") | .pid"); if [ -n "$PID" ]; then kill "$PID"; elif tmux has-session -t workspace 2>/dev/null; then kitty --class floating-systempane --override initial_window_width=1920 --override initial_window_height=1500 -e tmux attach -t workspace; else tmux new-session -d -s workspace \; split-window -h -p 80 \; select-pane -t 1 \; split-window -v -p 70 \; select-pane -t 0 \; send-keys "sleep 0.5 && clear && cliamp ~/Music" C-m \; select-pane -t 1 \; send-keys "yazi" C-m \; select-pane -t 2 \; send-keys "btop" C-m \; select-pane -t 0 && kitty --class floating-systempane --override initial_window_width=1920 --override initial_window_height=1500 -e tmux attach -t workspace; fi']]

-- Yazi popup, toggled via SUPER+E
local yaziToggleScript =
[[bash -c 'PID=$(hyprctl clients -j | jq -r ".[] | select(.title == \"Yazi\") | .pid"); if [ -n "$PID" ]; then kill "$PID"; else kitty -T Yazi -e tmux new-session -A -s yazi "yazi"; fi']]


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
  hl.exec_cmd("env GDK_BACKEND=wayland GTK_USE_PORTAL=1 waybar &")
  hl.exec_cmd("uwsm-app -- hypridle")
  hl.exec_cmd("uwsm-app -- mako")
  hl.exec_cmd("uwsm-app -- fcitx5")
  -- hl.exec_cmd("uwsm-app -- swaybg -i ~/.config/omarchy/current/background -m fill")
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  -- hl.exec_cmd("omarchy-cmd-first-run")
  hl.exec_cmd("uwsm-app -- elephant")
  hl.exec_cmd("uwsm-app -- walker --gapplication-service")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("WLR_DRM_DEVICES", "/dev/dri/card2")
hl.env("QT_IM_MODULE", "cedilla")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
  general = {
    gaps_in          = 0,
    gaps_out         = 0,
    border_size      = 1,

    col              = {
      active_border   = "rgba(ffffff80)",
      inactive_border = "rgba(595959aa)",
    },

    resize_on_border = false,
    allow_tearing    = true,
    layout           = "dwindle",
  },

  decoration = {
    rounding    = 0,
    dim_around  = 0.4,
    dim_special = 0.4,

    blur        = {
      enabled           = true,
      size              = 3,
      passes            = 3,
      noise             = 0.02,
      contrast          = 1.30,
      brightness        = 1.2,
      vibrancy          = 0.1696,
      vibrancy_darkness = 0.5,
      special           = true,
    },
  },

  cursor = {
    no_hardware_cursors = true,
  },

  xwayland = {
    force_zero_scaling = true,
  },

  misc = {
    vrr                     = 1,
    force_default_wallpaper = -1,
    disable_hyprland_logo   = false,
  },

  dwindle = {
    preserve_split = true,
  },

  master = {
    new_status = "master",
  },
})


--------------------
---- ANIMATIONS ----
--------------------

hl.config({ animations = { enabled = true } })

hl.curve("smooth", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "smooth", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, bezier = "smooth", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "smooth", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2, bezier = "smooth" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "smooth" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "smooth" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "smooth", style = "fade" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "easeOutQuint", style = "slidevert" })


------------------
---- GESTURES ----
------------------

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "up", action = "float" })
hl.gesture({ fingers = 3, direction = "down", action = "fullscreen" })


---------------
---- INPUT ----
---------------

hl.config({
  input = {
    kb_layout          = "us",
    kb_variant         = "intl",
    kb_options         = "",

    repeat_rate        = 40,
    repeat_delay       = 600,
    numlock_by_default = true,

    natural_scroll     = true,

    touchpad           = {
      scroll_factor  = 0.4,
      natural_scroll = true,
    },
  },
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Apps
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser .. " & ./open.sh"))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + CTRL + V", function()
  hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
  hl.dispatch(hl.dsp.window.resize({ x = 1920, y = 1080, exact = true }))
  hl.dispatch(hl.dsp.window.center())
end)
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd(menu))

-- System pane (floating tmux: cliamp + yazi + btop)
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(systempaneScript))

hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(obsidian))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("hyprctl reload"))
-- hl.bind("SUPER + ALT + space", hl.dsp.exec_cmd("omarchy-menu"), { description = "Omarchy menu" })

-- Mouse side buttons → cycle workspaces
hl.bind("mouse:275", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("mouse:276", hl.dsp.focus({ workspace = "e+1" }))

-- Move focus (vim keys)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Move window (vim keys)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- Resize active window (relative via hyprctl; Lua resize() rejects 0/negative as invalid size)
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 100 0"))
hl.bind(mainMod .. " + ALT + H", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -100 0"))
hl.bind(mainMod .. " + ALT + K", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -100"))
hl.bind(mainMod .. " + ALT + J", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 100"))
hl.bind(mainMod .. " + ALT + R", hl.dsp.window.resize({ x = 1000, y = 800, exact = true }))
hl.bind(mainMod .. " + SHIFT + C", function()
  hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
  hl.dispatch(hl.dsp.window.resize({ x = 1920, y = 1080, exact = true }))
  hl.dispatch(hl.dsp.window.center())
end)

-- External monitor brightness (ddccontrol)
hl.bind(mainMod .. " + CTRL + 1", hl.dsp.exec_cmd(brightness10))
hl.bind(mainMod .. " + CTRL + 2", hl.dsp.exec_cmd(brightness20))
hl.bind(mainMod .. " + CTRL + 3", hl.dsp.exec_cmd(brightness30))
hl.bind(mainMod .. " + CTRL + 4", hl.dsp.exec_cmd(brightness40))
hl.bind(mainMod .. " + CTRL + 5", hl.dsp.exec_cmd(brightness50))
hl.bind(mainMod .. " + CTRL + 6", hl.dsp.exec_cmd(brightness60))
hl.bind(mainMod .. " + CTRL + 7", hl.dsp.exec_cmd(brightness70))
hl.bind(mainMod .. " + CTRL + 8", hl.dsp.exec_cmd(brightness80))
hl.bind(mainMod .. " + CTRL + 9", hl.dsp.exec_cmd(brightness90))
hl.bind(mainMod .. " + CTRL + 0", hl.dsp.exec_cmd(brightness0))
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd(brightness0))

-- Yazi popup (toggle)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(yaziToggleScript))

-- Move floating windows + (on H) also toggle hyprpanel
hl.bind(mainMod .. " + CTRL + H", function()
  hl.exec_cmd("bash -c 'if pgrep -x hyprpanel; then pkill hyprpanel; else hyprpanel & fi'")
  hl.window.move({ x = -50, y = 0 })
end)
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.move({ x = 50, y = 0 }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.move({ x = 0, y = -50 }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.move({ x = 0, y = 50 }))

-- Workspaces (focus + move)
for i = 1, 10 do
  local key = i % 10 -- 10 maps to "0"
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Volume (precise, via swayosd-client)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(osdclient .. " --output-volume +1"),
  { locked = true, repeating = true, description = "Volume up precise" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(osdclient .. " --output-volume -1"),
  { locked = true, repeating = true, description = "Volume down precise" })

-- Mute / mic-mute / brightness fallbacks
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

-- Screenshots
hl.bind("ALT + SHIFT + 2", hl.dsp.exec_cmd("hyprshot -m region --raw | satty --filename -"))

hl.window_rule({
  match = { class = "com.gabm.satty" },
  float = true,
  center = true,
})

hl.bind("ALT + SHIFT + 3", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("ALT + SHIFT + 4", hl.dsp.exec_cmd("hyprshot -m output"))

-- Special workspace (scratchpad) + toggle hyprpanel script
hl.bind("SUPER + S", function()
  hl.workspace.toggle_special("scratchpad")
  hl.exec_cmd("~/.config/hypr/scripts/toggle-hyprpanel.sh")
end)
hl.bind(mainMod .. " + CTRL + SHIFT + 5", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll-switch workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize with mouse drag
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
  name           = "suppress-maximize",
  match          = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  name  = "yazi-floating-rule",
  match = { title = "^(Yazi)$" },
  float = true,
  size  = "1200 800",
})

hl.window_rule({
  name       = "floating-systempane-rule",
  match      = { class = "^(floating-systempane)$" },
  float      = true,
  size       = "1920 1080",
  center     = true,
  dim_around = true,
})

hl.window_rule({
  name       = "dim-behind-kitty",
  match      = { class = "^(kitty)$", float = true },
  dim_around = true,
})

hl.window_rule({
  name   = "high-tide-floating",
  match  = { class = "^(io\\.github\\.nokse22\\.high-tide)$" },
  float  = true,
  size   = "900 800",
  center = true,
})

hl.window_rule({
  name   = "calculator-floating",
  match  = { class = "^(org\\.gnome\\.Calculator)$" },
  float  = true,
  size   = "1 1",
  center = true,
})

hl.window_rule({
  name  = "pip",
  match = { title = "^(Picture-in-Picture)$" },
  float = true,
  pin   = true,
  move  = "69.5% 4%",
})
