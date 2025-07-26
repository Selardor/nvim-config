-- Set lualine as statusline
return {
	"nvim-lualine/lualine.nvim",
	config = function()
		-- Tokyo Night theme colors
		local colors = {
			bg = "#1a1b26",
			fg = "#c0caf5",
			yellow = "#e0af68",
			cyan = "#7dcfff",
			darkblue = "#16161e",
			green = "#9ece6a",
			orange = "#ff9e64",
			violet = "#9d7cd8",
			magenta = "#bb9af7",
			blue = "#7aa2f7",
			red = "#f7768e",
		}

		local tokyonight_theme = {
			normal = {
				a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
				b = { fg = colors.fg, bg = colors.darkblue },
				c = { fg = colors.fg, bg = colors.bg },
			},
			insert = { a = { fg = colors.bg, bg = colors.green, gui = "bold" } },
			visual = { a = { fg = colors.bg, bg = colors.magenta, gui = "bold" } },
			replace = { a = { fg = colors.bg, bg = colors.red, gui = "bold" } },
			command = { a = { fg = colors.bg, bg = colors.yellow, gui = "bold" } },
			inactive = {
				a = { fg = colors.fg, bg = colors.bg, gui = "bold" },
				b = { fg = colors.fg, bg = colors.bg },
				c = { fg = colors.fg, bg = colors.bg },
			},
		}

		local mode = {
			"mode",
			fmt = function(str)
				return " " .. str
			end,
		}

		local filename = {
			"filename",
			file_status = true,
			path = 0,
		}

		local hide_in_width = function()
			return vim.fn.winwidth(0) > 100
		end

		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn" },
			symbols = { error = " ", warn = " ", info = " ", hint = " " },
			colored = false,
			update_in_insert = false,
			always_visible = false,
			cond = hide_in_width,
		}

		local diff = {
			"diff",
			colored = false,
			symbols = { added = " ", modified = " ", removed = " " },
			cond = hide_in_width,
		}

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = tokyonight_theme, -- ✅ use your custom theme
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha", "neo-tree", "Avante" },
				always_divide_middle = true,
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { "branch" },
				lualine_c = { filename },
				lualine_x = {
					diagnostics,
					diff,
					{ "encoding", cond = hide_in_width },
					{ "filetype", cond = hide_in_width },
				},
				lualine_y = { "location" },
				lualine_z = { "progress" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { { "location", padding = 0 } },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "fugitive" },
		})
	end,
}
