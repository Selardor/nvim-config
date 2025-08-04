-- Standalone plugins with less than 10 lines of config go here
return {
	{
		-- autoclose tags
		"windwp/nvim-ts-autotag",
	},
	{
		-- detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
	},
	{
		-- Powerful Git integration for Vim
		"tpope/vim-fugitive",
	},
	{
		-- GitHub integration for vim-fugitive
		"tpope/vim-rhubarb",
	},
	--{
	--	-- Hints keybinds
	--	"folke/which-key.nvim",
	--	opts = {
	--		win = {
	--			border = {
	--				{ "┌", "FloatBorder" },
	--				{ "─", "FloatBorder" },
	--				{ "┐", "FloatBorder" },
	--				{ "│", "FloatBorder" },
	--				{ "┘", "FloatBorder" },
	--				{ "─", "FloatBorder" },
	--				{ "└", "FloatBorder" },
	--				{ "│", "FloatBorder" },
	--			},
	--		},
	--	},
	--},
	{
		-- Autoclose parentheses, brackets, quotes, etc.
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {},
	},
	{
		-- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		-- high-performance color highlighter
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		-- Toggle comments with gc
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
	},
	{
		-- Add snippet completion
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
		-- Autoclose html tags
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}
