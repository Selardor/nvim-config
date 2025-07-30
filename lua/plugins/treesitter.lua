-- Highlight, edit, and navigate code
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			-- Add languages to be installed here that you want installed for treesitter
			ensure_installed = {
				"lua",
				"python",
				"javascript",
				"typescript",
				"vimdoc",
				"vim",
				"regex",
				"sql",
				"toml",
				"json",
				"groovy",
				"go",
				"gitignore",
				"yaml",
				"make",
				"cmake",
				"markdown",
				"markdown_inline",
				"bash",
				"tsx",
				"css",
				"html",
			},

			-- Autoinstall languages that are not installed
			auto_install = true,

			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<c-space>",
					node_incremental = "<c-space>",
					scope_incremental = "<c-s>",
					node_decremental = "<M-space>",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
		})

		-- Register additional file extensions
		vim.filetype.add({ extension = { tf = "terraform" } })
		vim.filetype.add({ extension = { tfvars = "terraform" } })
		vim.filetype.add({ extension = { pipeline = "groovy" } })
		vim.filetype.add({ extension = { multibranch = "groovy" } })

		-- Automatically insert `f` for Python f-strings when typing `{` inside a string
		vim.api.nvim_create_autocmd("InsertCharPre", {
			pattern = "*.py",
			callback = function()
				if vim.v.char ~= "{" then
					return
				end

				local ts_utils = require("nvim-treesitter.ts_utils")
				local node = ts_utils.get_node_at_cursor()
				if not node then
					return
				end

				while node and node:type() ~= "string" do
					node = node:parent()
				end
				if not node then
					return
				end

				local bufnr = vim.api.nvim_get_current_buf()
				local start_row, start_col = node:start()
				local line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]

				-- Grab the first few characters of the string prefix
				local prefix = line:sub(start_col, start_col + 4):lower()

				-- Only insert 'f' if it's not already there before the opening quote
				if not prefix:match("f") then
					vim.schedule(function()
						vim.api.nvim_buf_set_text(bufnr, start_row, start_col, start_row, start_col, { "f" })
					end)
				end
			end,
		})
	end,
}
