-- Filetype override for .env
vim.filetype.add({
	extension = {
		env = "sh",
	},
	filename = {
		[".env"] = "sh",
	},
})
