local opt = vim.opt

-- Search
opt.hlsearch = false -- Don't highlight all search matches
opt.incsearch = true -- Show match while typing
opt.ignorecase = true -- Case-insensitive search
opt.smartcase = true -- But case-sensitive if capital letter used

-- Interface
opt.number = true -- Show line numbers
opt.relativenumber = true -- Relative line numbers
opt.signcolumn = "yes" -- Always show signcolumn
opt.cursorline = false -- Disable current line highlight
opt.showmode = false -- Don't show -- INSERT --
opt.cmdheight = 1 -- Command line height
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.wrap = false -- Don't wrap lines
opt.linebreak = true -- Break lines at word boundaries (if wrap is enabled)
opt.scrolloff = 8 -- Minimum lines above/below cursor
opt.sidescrolloff = 8 -- Minimum columns left/right of cursor
opt.numberwidth = 4 -- Width of number column
opt.pumheight = 10 -- Popup menu height
opt.showtabline = 2 -- Always show tabline

-- Indentation
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true -- Use spaces instead of tabs

-- File & Backup
opt.undofile = true -- Save undo history
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.fileencoding = "utf-8"

-- Clipboard & Mouse
opt.mouse = "a" -- Enable mouse
opt.clipboard = "unnamedplus" -- Use system clipboard

-- Split behavior
opt.splitbelow = true
opt.splitright = true

-- Completion
opt.completeopt = { "menuone", "noselect" }

-- Performance
opt.updatetime = 250 -- CursorHold delay
opt.timeoutlen = 300 -- Mapped sequence wait time

-- Misc
opt.whichwrap = "b,s,<,>,[,],h,l"
opt.backspace = { "indent", "eol", "start" }
opt.conceallevel = 0 -- For Markdown, keep `` visible

-- Plugin-friendly tweaks
opt.shortmess:append("c") -- No "match x of y" messages
opt.iskeyword:append("-") -- Treat hyphenated-words as whole
opt.runtimepath:remove("/usr/share/vim/vimfiles") -- Avoid loading Vim plugins

-- Remove auto comment continuation *every time* a file is opened
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})
