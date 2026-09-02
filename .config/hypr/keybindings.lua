-- ~/.config/hypr/keybindings.lua

local mainMod = "SUPER"
local alt = "ALT"
local ctrlShift = "CTRL + SHIFT"
local altShift = "ALT + SHIFT"
local mainModShift = "SUPER + SHIFT"

local editor = "code"
local terminal = "kitty"
local fileManager = "nautilus"
local reload_shell = "pkill quickshell && uwsm app -- quickshell"
local browser = "google-chrome-stable"
local sysmon = "kitty --class btop -e btop"

-- Basic Binds
hl.bind(alt .. " + F4", hl.dsp.window.close())
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(reload_shell))
hl.bind(ctrlShift .. " + Escape", hl.dsp.exec_cmd(sysmon))
hl.bind(mainMod .. " + Escape", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("uwsm stop"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(altShift .. " + P", hl.dsp.exec_cmd("hyprpicker -an"))
hl.bind(alt .. " + Escape", hl.dsp.exec_cmd("quickshell ipc call powermenu toggle"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("quickshell ipc call qspanel toggle"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("quickshell ipc call settings toggle"))
hl.bind(ctrlShift .. " + W", hl.dsp.exec_cmd("quickshell ipc call wallpaper randomize"))
hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd("quickshell ipc call launcher toggle"), { release = true })

-- Screenshot Binds
hl.bind(alt .. " + S", hl.dsp.exec_cmd("$HOME/.config/quickshell/scripts/screenshot.sh s"), { locked = true })
hl.bind(altShift .. " + S", hl.dsp.exec_cmd("$HOME/.config/quickshell/scripts/screenshot.sh p"), { locked = true })

-- Move Focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Workspaces
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. tostring(i), hl.dsp.focus({ workspace = i }))
    hl.bind(mainModShift .. " + " .. tostring(i), hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainModShift .. " + 0", hl.dsp.window.move({ workspace = 10 }))

-- Special Workspaces
hl.bind(mainMod .. " + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainModShift .. " + S", hl.dsp.workspace.toggle_special("magic"))

-- Scroll Workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Cycle Windows (Wrapped in a function to execute sequentially)
hl.bind(alt .. " + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- Mouse Binds
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media Controls
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("quickshell ipc call osd volUp"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("quickshell ipc call osd volDown"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("quickshell ipc call osd volMute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("quickshell ipc call osd micMute"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("quickshell ipc call osd brightUp"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("quickshell ipc call osd brightDown"), { repeating = true, locked = true })
