--------------------------------
---- LOCAL (ENV + MONITORS) ----
--------------------------------

local function load_local()
    local path = (os.getenv("HOME") or "") .. "/.config/hypr/local.lua"
    local file = io.open(path, "r")
    if not file then return { env = {}, monitors = {} } end
    file:close()

    local chunk, err = loadfile(path)               -- не require: изменения подхватываются при reload
    if not chunk then
        print("hyprland: local.lua: " .. tostring(err))
        return { env = {}, monitors = {} }
    end

    local ok, conf = pcall(chunk)
    if not ok or type(conf) ~= "table" then
        print("hyprland: local.lua: " .. tostring(ok and "expected a table" or conf))
        return { env = {}, monitors = {} }
    end

    return conf
end

local localconf = load_local()

for name, value in pairs(localconf.env or {}) do
    hl.env(name, value)
end

for _, monitor in ipairs(localconf.monitors or {}) do
    hl.monitor(monitor)
end

-------------------
---- PROGRAMS ----
-------------------

local term = "kitty"
local menu = "~/.config/wofi/launch.sh"

---------------------
---- ANIMATIONS -----
---------------------

hl.animation({ leaf = "layersIn",  enabled = true, speed = 5, bezier = "default", style = "popin 90%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2, bezier = "default", style = "fade" })

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("mako")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("eww --config ~/.config/eww open-many bar-left bar-right")
    hl.timer(function()
        local monitor = hl.get_active_monitor()
        if monitor then
            hl.exec_cmd("eww update active_monitor=" .. monitor.name)
        end
    end, { timeout = 1000, type = "oneshot" })
end)

-------------------
--- UNIX-SOCKET ---
-------------------

hl.on("monitor.focused", function(monitor)
    if monitor then
        hl.exec_cmd("eww update active_monitor=" .. monitor.name)
    end
end)

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout           = "us,ru",
        kb_options          = "grp:win_space_toggle",
        numlock_by_default  = true,
        sensitivity         = -0.2,
        accel_profile       = "flat",
    },
})


hl.config({
    general = {
        border_size             = 2,
        gaps_in                 = 5,
        gaps_out                = 10,
        ["col.active_border"]   = "rgb(d6acff)",
        ["col.inactive_border"] = "rgb(392b4d)",
    },
    decoration = {
        rounding = 10,
    },
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(term))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())

-- Перемещение фокуса стрелками
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Переключение воркспейсов (SUPER + 1..0) и перенос окна (SUPER + SHIFT + 1..0)
package.path = package.path .. ";./?.lua;./?/init.lua"
local smw = require("plugins.split-monitor-workspaces")

local priority = localconf.monitor_priority or {}
if #priority == 0 then
    for _, m in ipairs(localconf.monitors or {}) do
        priority[#priority + 1] = m.output
    end
end

smw.setup({
    workspace_count = 10,
    monitor_priority = priority,
    enable_persistent_workspaces = true,
    keep_focused = true,
})

for i = 1, smw.get_amount_of_workspaces() do
    local n = tostring(i)
    if n == "10" then n = "0" end
    hl.bind(mainMod .. " + " .. n,         smw.workspace(n))
    hl.bind(mainMod .. " + SHIFT + " .. n, smw.move_to_workspace_silent(n))
end

-- Перетаскивание/ресайз окна мышью
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    match          = { class = ".*" },
    suppress_event = "maximize",
})
