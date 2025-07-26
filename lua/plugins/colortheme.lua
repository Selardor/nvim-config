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
