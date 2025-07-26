return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		attach_to_untracked = true,
		watch_gitdir = {
			interval = 1000,
			follow_files = true,
		},
		current_line_blame = false,
	},
}
