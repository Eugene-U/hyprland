------------------
---- MONITORS ----
------------------

hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "0x0",    scale = 1 })
hl.monitor({ output = "DP-1",     mode = "1920x1080@75", position = "1920x0", scale = 1 })

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
hl.env("XCURSOR_SIZE", "24")

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
    hl.exec_cmd("eww --config ~/.config/eww open bar")
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
        ["col.active_border"]   = "rgb(bd93f9)",
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
for i = 1, 10 do
    local key = i % 10 -- 10 -> клавиша 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
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
