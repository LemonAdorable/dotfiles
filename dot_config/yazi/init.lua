-- gvfs.yazi
require("gvfs"):setup({
	-- (Optional) Allowed keys to select device.
	which_keys = "1234567890qwertyuiopasdfghjklzxcvbnm-=[]\\;',./!@#$%^&*()_+{}|:\"<>?",

	-- (Optional) Table of blacklisted devices. These devices will be ignored in any actions
	-- List of device properties to match, or a string to match the device name:
	-- https://github.com/boydaihungst/gvfs.yazi/blob/master/main.lua#L144
	blacklist_devices = { { name = "Wireless Device", scheme = "mtp" }, { scheme = "file" }, "Device Name" },

	-- (Optional) Save file.
	-- Default: ~/.config/yazi/gvfs.private
	save_path = os.getenv("HOME") .. "/.config/yazi/gvfs.private",

	-- (Optional) Save file for automount devices. Use with `automount-when-cd` action.
	-- Default: ~/.config/yazi/gvfs_automounts.private
	save_path_automounts = os.getenv("HOME") .. "/.config/yazi/gvfs_automounts.private",

	-- (Optional) Input box position.
	-- Default: { "top-center", y = 3, w = 60 },
	-- Position, which is a table:
	-- 	`1`: Origin position, available values: "top-left", "top-center", "top-right",
	-- 	     "bottom-left", "bottom-center", "bottom-right", "center", and "hovered".
	--         "hovered" is the position of hovered file/folder
	-- 	`x`: X offset from the origin position.
	-- 	`y`: Y offset from the origin position.
	-- 	`w`: Width of the input.
	-- 	`h`: Height of the input.
	input_position = { "center", y = 0, w = 60 },

	-- (Optional) Select where to save passwords.
	-- Default: nil
	-- Available options: "keyring", "pass", or nil
	password_vault = "keyring",

	-- (Optional) Only need if you set password_vault = "pass"
	-- Read the guide at SECURE_SAVED_PASSWORD.md to get your key_grip
	key_grip = "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB",

	-- (Optional) Auto-save password after mount.
	-- Default: false
	save_password_autoconfirm = true,
	-- (Optional) mountpoint of gvfs. Default: /run/user/USER_ID/gvfs
	-- On some system it could be ~/.gvfs
	-- You can't decide this path, it will be created automatically. Only changed if you know where gvfs mountpoint is.
	-- Use command `ps aux | grep gvfs` to search for gvfs process and get the mountpoint path.
	-- root_mountpoint = (os.getenv("XDG_RUNTIME_DIR") or ("/run/user/" .. ya.uid())) .. "/gvfs"
})

-- git.yazi
require("git"):setup({
	-- Order of status signs showing in the linemode
	order = 1500,
})

-- projects.yazi
require("projects"):setup({
	event = {
		save = {
			enable = true,
			name = "project-saved",
		},
		load = {
			enable = true,
			name = "project-loaded",
		},
		delete = {
			enable = true,
			name = "project-deleted",
		},
		delete_all = {
			enable = true,
			name = "project-deleted-all",
		},
		merge = {
			enable = true,
			name = "project-merged",
		},
	},
	save = {
		method = "yazi", -- yazi | lua
		yazi_load_event = "@projects-load", -- event name when loading projects in `yazi` method
		lua_save_path = "", -- path of saved file in `lua` method, comment out or assign explicitly
		-- default value:
		-- windows: "%APPDATA%/yazi/state/projects.json"
		-- unix: "~/.local/state/yazi/projects.json"
	},
	last = {
		update_after_save = true,
		update_after_load = true,
		update_before_quit = false,
		load_after_start = false,
	},
	merge = {
		event = "projects-merge",
		quit_after_merge = false,
	},
	notify = {
		enable = true,
		title = "Projects",
		timeout = 3,
		level = "info",
	},
})

-- recycle-bin.yazi
require("recycle-bin"):setup({
	-- Optional: Override automatic trash directory discovery
	-- trash_dir = "~/.local/share/Trash/",  -- Uncomment to use specific directory
})

-- sshfs.yazi
require("sshfs"):setup({
	sshfs_options = {
		-- reconnect
		"reconnect",
		"ServerAliveInterval=15",
		"ServerAliveCountMax=3",
		"ConnectTimeout=10",

		-- cache
		"dir_cache=yes",
		"dcache_timeout=60", -- 60秒缓存，平衡了性能和实时性
		"cache_timeout=60",

		-- allow_other user like root
		-- "allow_other",
		-- Pretend to be your local user-owned
		-- "uid=1000,gid=1000",
	},
})

-- duckdb.yazi
require("duckdb"):setup()

-- yatline.yazi
local is_root = ya.uid() == 0

local iris_palette = {
	rosewater = "#f5e0dc",
	flamingo = "#f2cdcd",
	pink = "#f5c2e7",
	mauve = is_root and "#f38ba8" or "#bca5f2", -- Dynamically set theme color
	red = "#f38ba8",
	maroon = "#eba0ac",
	peach = "#fab387",
	yellow = "#f9e2af",
	green = "#a6e3a1",
	teal = "#94e2d5",
	sky = "#89dceb",
	sapphire = "#74c7ec",
	blue = "#89b4fa",
	lavender = "#b4befe",
	text = "#cdd6f4",
	subtext1 = "#bac2de",
	subtext0 = "#a6adc8",
	overlay2 = "#9399b2",
	overlay1 = "#7f849c",
	overlay0 = "#6c7086",
	surface2 = "#585b70",
	surface1 = "#45475a",
	surface0 = "#313244",
	base = "#1e1e2e",
	mantle = "#181825",
	crust = "#11111b",
}

require("yatline"):setup({
	-- theme
	-- section_separator_open = "",
	-- section_separator_close = "" ,
	section_separator = { open = "", close = "" },

	-- inverse_separator_open = "",
	-- inverse_separator_close = "",
	inverse_separator = { open = "", close = "" },
	part_separator = { open = "|", close = " " },

	style_a = {
		fg = iris_palette.mantle,
		bg_mode = {
			normal = iris_palette.mauve, -- Automatically turns red if is_root
			select = iris_palette.yellow,
			un_set = iris_palette.red,
		},
	},
	style_b = { bg = iris_palette.surface0, fg = iris_palette.text },
	style_c = { bg = iris_palette.mantle, fg = iris_palette.text },

	permissions_t_fg = iris_palette.green,
	permissions_r_fg = iris_palette.yellow,
	permissions_w_fg = iris_palette.red,
	permissions_x_fg = iris_palette.sky,
	permissions_s_fg = iris_palette.lavender,

	selected = { icon = "󰻭", fg = iris_palette.yellow },
	copied = { icon = "", fg = iris_palette.green },
	cut = { icon = "", fg = iris_palette.red },
	files = { icon = "", fg = iris_palette.blue },
	filtereds = { icon = "", fg = iris_palette.mauve },

	total = { icon = "󰮍", fg = iris_palette.yellow },
	success = { icon = "", fg = iris_palette.green },
	failed = { icon = "", fg = iris_palette.red },

	-- theme yatline-githead
	branch_color = iris_palette.mauve, -- Fixed: Use bright color for visibility
	remote_branch_color = iris_palette.pink,
	tag_color = iris_palette.sky,
	commit_color = iris_palette.mauve,
	behind_remote_color = iris_palette.flamingo,
	ahead_remote_color = iris_palette.lavender,
	stashes_color = iris_palette.pink,
	state_color = iris_palette.maroon,
	staged_color = iris_palette.yellow,
	unstaged_color = iris_palette.peach,
	untracked_color = iris_palette.teal,

	-- layout
	show_background = true,

	display_header_line = true,
	display_status_line = true,

	component_positions = { "header", "tab", "status" },

	header_line = {
		left = {
			section_a = {
				{ type = "line", name = "tabs" },
			},
			section_b = {
				{ type = "string", custom = false, name = "search_query", params = { "󰍉 " } },
				{ type = "string", custom = false, name = "finder_query", params = { "󰈞 " } },
				{ type = "string", custom = false, name = "filter_query", params = { "󰈲 " } },
			},
			section_c = {

				{ type = "coloreds", name = "count", params = { true } },
				{ type = "coloreds", custom = false, name = "githead" },
			},
		},
		right = {
			section_a = {
				{ type = "string", name = "date", params = { " %Y-%m-%d" } },
			},
			section_b = {
				{ type = "string", name = "date", params = { " %X" } },
			},
			section_c = {
				{ type = "coloreds", custom = false, name = "task_states", params = { true } },
				{ type = "coloreds", custom = false, name = "hostname_username" },
			},
		},
	},

	status_line = {
		left = {
			section_a = {
				{ type = "string", name = "tab_mode" },
			},
			section_b = {
				{ type = "string", name = "hovered_size" },
			},
			section_c = {
				{ type = "string", name = "hovered_path" },
			},
		},
		right = {
			section_a = {
				{ type = "string", name = "cursor_position" },
			},
			section_b = {
				{ type = "string", name = "cursor_percentage" },
			},
			section_c = {
				--{ type = "coloreds", custom = false, name = "page_count", params = { false, false } },
				{ type = "string", custom = false, name = "hovered_mime" },
				{ type = "string", name = "hovered_file_extension", params = { true } },
				{ type = "coloreds", name = "permissions" },
			},
		},
	},
})
require("yatline-githead"):setup({
	order = {
		"branch",
		"remote",
		"tag",
		"commit",
		"behind_ahead_remote",
		"stashes",
		"state",
		"staged",
		"unstaged",
		"untracked",
	},

	show_numbers = true, -- shows staged, unstaged, untracked, stashes count

	show_branch = true,
	branch_prefix = "",
	branch_color = iris_palette.mauve, -- Fixed: Readable mauve
	branch_symbol = "󰊢 ",
	branch_borders = "",

	show_remote_branch = true, -- only shown if different from local branch
	always_show_remote_branch = false, -- always show remote branch even if it the same as local branch
	always_show_remote_repo = false, -- Adds `origin/` if `always_show_remote_branch` is enabled
	remote_branch_prefix = ":",
	remote_branch_color = iris_palette.pink,

	show_tag = true, -- only shown if branch is not available
	always_show_tag = false,
	tag_color = iris_palette.peach,
	tag_symbol = "󰓹 ",

	show_commit = true, -- only shown if branch AND tag are not available
	always_show_commit = false,
	commit_color = iris_palette.mauve,
	commit_symbol = "󰊣 ",

	show_behind_ahead_remote = true,
	behind_remote_color = iris_palette.red,
	behind_remote_symbol = "⇣",
	ahead_remote_color = iris_palette.green,
	ahead_remote_symbol = "⇡",

	show_stashes = true,
	stashes_color = iris_palette.teal,
	stashes_symbol = "󰘚 ",

	show_state = true,
	show_state_prefix = true,
	state_color = iris_palette.red,
	state_symbol = "󱗜 ",

	show_staged = true,
	staged_color = iris_palette.green,
	staged_symbol = " ",

	show_unstaged = true,
	unstaged_color = iris_palette.yellow,
	unstaged_symbol = " ",

	show_untracked = true,
	untracked_color = iris_palette.blue,
	untracked_symbol = " ",
})
require("yatline-page-counter"):setup({
	page_color = "cyan", -- Color for page count display
	show_icon = true, -- Show document icon (default: true)
	icon = "", -- Icon to display (default: 📄)
	supported_formats = { -- File extensions to check
		"pdf",
		"djvu",
		"epub",
		"mobi",
		"azw",
		"azw3",
		"docx",
		"doc",
		"odt",
		"pptx",
		"ppt",
		"odp",
	},
})

require("yatline-hostname-username"):setup()
