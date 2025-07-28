return {
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			local bg_transparency = true

			local function load_tokyonight()
				require("tokyonight").setup({
					transparent = bg_transparency,
					styles = {
						comments = { italic = false },
					},
				})
				vim.cmd.colorscheme("tokyonight-night")

				-- ✨ Add highlight override here (for better Visual selection)
				vim.api.nvim_set_hl(0, "Visual", { reverse = true })

				-- Optional: Improve visibility for CursorLine, Search
				vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2a2f38" })
				vim.api.nvim_set_hl(0, "Search", { reverse = true })
				vim.api.nvim_set_hl(0, "IncSearch", { reverse = true })
			end

			-- Load the theme initially
			load_tokyonight()

			-- Toggle background transparency
			local function toggle_transparency()
				bg_transparency = not bg_transparency
				load_tokyonight()
			end

			vim.keymap.set("n", "<leader>bg", toggle_transparency, { noremap = true, silent = true })
		end,
	},
}
