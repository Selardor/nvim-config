return {
	"ray-x/lsp_signature.nvim",
	event = "VeryLazy",
	opts = {
		bind = true,
		hint_enable = true,
		floating_window = true,
		floating_window_above_cur_line = true,
		fix_pos = true,
		always_trigger = true, -- <- makes it persist while typing
		hint_prefix = "💡 ",
		handler_opts = {
			border = "rounded",
		},
	},
	config = function(_, opts)
		require("lsp_signature").setup(opts)
	end,
}
