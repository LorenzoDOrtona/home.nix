-- Hyprland Lua config
-- https://wiki.hypr.land/Configuring/

------------------
---- MONITORS ----
------------------

-- Monitor Superiore (UltraWide)
hl.monitor({
	output = "DP-1",
	mode = "2560x1080@60",
	position = "0x0",
	scale = 1,
})

-- Monitor Inferiore (Portatile)
hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "480x1080", -- centrato sotto l'ultrawide (2560-1600)/2
	scale = 1.6, -- 2560x1664 / 1.6 = 1600x1040 logici (prima 2 => tutto troppo grande)
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local fileManager = "nemo"
local menu = "hyprlauncher"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE && systemctl --user start hyprland-session.target")
	hl.exec_cmd("hyprlock")
	hl.exec_cmd("dms run")
	hl.exec_cmd("waypaper")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("blueman-applet")
	hl.exec_cmd("firefox")
	hl.exec_cmd("brightnessctl --device='*kbd_backlight*' set 50%")
	hl.exec_cmd("brightnessctl set 10%")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("hyprctl setcursor Banana 24")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_THEME", "Banana")
hl.env("HYPRCURSOR_THEME", "Banana")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("WLR_DRM_NO_ATOMIC", "1")
hl.env("WLR_BACKEND", "drm")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 3,

		border_size = 2,

		-- I colori dei bordi sono dinamici: vedi "COLORI DINAMICI" in fondo al file

		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,

		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = false,
		},
	},

	animations = {
		enabled = true,
	},
})

-- Curves
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Animations
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "linear", style = "loop" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Layouts
hl.config({
	dwindle = {
		preserve_split = true,
		-- nuove finestre: la prima occupa il 55% invece del 50% (1.0 = metà esatta, max 1.9)
		default_split_ratio = 1.1,
	},
	master = {
		new_status = "master",
	},
})

-- Misc
hl.config({
	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = false,
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "it",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,
		sensitivity = 0,

		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"
-- Lock screen when laptop lid is closed physically
-- Ensure the string matches the output of 'hyprctl devices'
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"), { locked = true })
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit")
)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("firefox"))
-- Exit Hyprland session natively
hl.bind(mainMod .. " + M", hl.dsp.exit())
-- Focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Sposta finestra (SUPER + SHIFT + frecce): mettendola sopra/sotto crei lo split verticale
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Ridimensiona finestra (SUPER + CTRL + frecce), tenendo premuto si ripete
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })

-- Workspaces
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Screenshot
hl.bind(
	mainMod .. " + SHIFT + P",
	hl.dsp.exec_cmd(
		"grim -g \"$(slurp)\" - | tee ~/Pictures/Screenshots/$(date +'%Y-%m-%d-%H%M%S_screenshot.png') | wl-copy"
	)
)

-- Scratchpad
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume & brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Media
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Ignore maximize requests from all apps
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fix dragging issues with XWayland
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- hyprland-run: float e posizione
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	float = true,
	move = "20 monitor_h-120",
})
-- Okular: se viene ridimensionato mentre il suo workspace è nascosto (es.
-- spostando via la finestra affiancata) Qt non riceve frame callback e il
-- PDF resta nero. render_unfocused gli fa credere di essere ancora visibile.
hl.window_rule({
	name = "okular-render-unfocused",
	match = { class = "^org\\.kde\\.okular$" },
	render_unfocused = true,
})

-- Floating rules for Network Manager
hl.window_rule({
	name = "float-network-manager",
	match = { class = "^nm-connection-editor$" },
	float = true,
	size = "600 450", -- Force window size
})

-- Floating rules for Bluetooth Manager
hl.window_rule({
	name = "float-bluetooth-manager",
	match = { class = "^blueman-manager$" },
	float = true,
	size = "600 450", -- Force window size
})

---------------------------------------
---- WORKSPACE DINAMICI (compatta) ----
---------------------------------------
-- Quando un workspace si svuota e viene rimosso (es. il 4), le finestre dei
-- workspace successivi scalano di uno (5 -> 4, 6 -> 5, ...), stile GNOME.

local compacting = false

local function compact_workspaces()
	if compacting then
		return
	end
	compacting = true

	local ids = {}
	for _, ws in ipairs(hl.get_workspaces()) do
		if not ws.special and ws.id > 0 then
			table.insert(ids, ws.id)
		end
	end
	table.sort(ids)

	local active = hl.get_active_workspace()
	local active_id = active and active.id or nil
	local new_active = nil

	for idx, id in ipairs(ids) do
		if id ~= idx then
			for _, win in ipairs(hl.get_workspace_windows(id)) do
				hl.dispatch(hl.dsp.window.move({ workspace = idx, window = "address:" .. win.address, follow = false }))
			end
			if id == active_id then
				new_active = idx
			end
		end
	end

	if new_active then
		hl.dispatch(hl.dsp.focus({ workspace = new_active }))
	end

	compacting = false
end

hl.on("workspace.removed", function()
	-- piccolo ritardo per lasciare a Hyprland il tempo di distruggere il workspace
	hl.timer(compact_workspaces, { timeout = 50, type = "oneshot" })
end)

--------------------------
---- COLORI DINAMICI ----
--------------------------
-- Impostazioni generate da DankMaterialShell (prima non venivano caricate!)
for _, mod in ipairs({ "dms.colors", "dms.layout", "dms.cursor", "dms.binds-user", "dms.windowrules" }) do
	local ok, err = pcall(require, mod)
	if not ok then
		print("errore caricando " .. mod .. ": " .. tostring(err))
	end
end

-- SUPER + O: Obsidian è single-instance (Electron), rilanciarlo riattiva la
-- finestra sul suo workspace. Qui invece la portiamo nel workspace corrente,
-- e la lanciamo solo se non è già aperta. Definito dopo dms.binds-user così
-- vince anche se DMS rigenera quel file.
hl.unbind("SUPER + O")
hl.bind("SUPER + O", function()
	local win = hl.get_windows({ class = "md.obsidian.Obsidian" })[1]
	if not win then
		hl.dispatch(hl.dsp.exec_cmd("obsidian"))
		return
	end
	local ws = hl.get_active_workspace()
	if ws and (not win.workspace or win.workspace.id ~= ws.id) then
		hl.dispatch(hl.dsp.window.move({ workspace = ws.id, window = "address:" .. win.address, follow = false }))
	end
	hl.dispatch(hl.dsp.focus({ window = "address:" .. win.address }))
end)

-- dms/colors.lua contiene il colore primario estratto dallo sfondo (matugen).
-- Lo trasformiamo in un gradiente che ruota (animazione "borderangle" sopra).
do
	local f = io.open(os.getenv("HOME") .. "/.config/hypr/dms/colors.lua", "r")
	if f then
		local txt = f:read("*a")
		f:close()
		local primary = txt:match('active_border%s*=%s*"rgb%((%x+)%)"')
		local inactive = txt:match('inactive_border%s*=%s*"rgb%((%x+)%)"')
		if primary and inactive then
			hl.config({
				general = {
					col = {
						active_border = {
							colors = { "rgba(" .. primary .. "ff)", "rgba(" .. inactive .. "66)", "rgba(" .. primary .. "ff)" },
							angle = 45,
						},
						inactive_border = "rgba(" .. inactive .. "55)",
					},
				},
			})
		end
	end
end
