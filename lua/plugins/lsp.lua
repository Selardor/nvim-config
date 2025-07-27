return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ "mason-org/mason.nvim", config = true }, -- Must be loaded before dependants
		-- Bridges gap between Mason package names and LSP config names
		"mason-org/mason-lspconfig.nvim",
		-- Ensures all desired tools (LSPs, linters, formatters) are installed
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Provides useful status updates for LSP
		{
			"j-hui/fidget.nvim",
			opts = {
				notification = {
					window = {
						winblend = 0, -- Background opacity for notifications
					},
				},
			},
		},

		-- Adds extra capabilities for nvim-cmp autocomplete integration
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- Setup keymaps and behaviors on LSP attach
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Navigation and info keymaps
				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

				-- Actions on symbols
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

				-- Hover for documentation
				map("K", vim.lsp.buf.hover, "Hover Documentation")

				-- Declaration jump
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				-- Workspace folder management
				map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
				map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
				map("<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, "[W]orkspace [L]ist Folders")

				-- Highlight references on cursor hold and clear on move
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})
					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- Optional: toggle inlay hints if supported
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- Extend capabilities to include nvim-cmp capabilities
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Function to detect python interpreter inside common virtual environment folders or env variable
		local function get_python_path(workspace)
			local Path = require("plenary.path")
			local match = nil

			-- Check for active virtual environment in environment variables
			if vim.env.VIRTUAL_ENV then
				match = Path:new(vim.env.VIRTUAL_ENV) / "bin/python"
				if match:exists() then
					return match:absolute()
				end
			end

			-- Check common virtual environment folders in workspace
			for _, venv in ipairs({ ".venv", "venv", "env" }) do
				local py = Path:new(workspace) / venv / "bin/python"
				if py:exists() then
					return py:absolute()
				end
			end

			-- Fallback to system python
			return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
		end

		local servers = {
			-- Lua language server with settings optimized for neovim config
			lua_ls = {
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
						diagnostics = {
							globals = { "vim" },
							disable = { "missing-fields" },
						},
						format = { enable = false },
					},
				},
			},

			-- ✅ Replaced pylsp with basedpyright
			basedpyright = {
				on_init = function(client)
					local path = get_python_path(client.config.root_dir)
					client.config.settings = client.config.settings or {}
					client.config.settings.python = { pythonPath = path }
				end,
			},

			-- Other LSP servers you have configured
			ruff = {},
			jsonls = {},
			sqlls = {},
			terraformls = {},
			yamlls = {},
			bashls = {},
			dockerls = {},
			cssls = {},
			docker_compose_language_service = {},
			html = { filetypes = { "html", "twig", "hbs" } },
		}

		-- Ensure all servers and tools are installed
		local ensure_installed = vim.tbl_keys(servers or {})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- Setup each server with capabilities and config
		for server, cfg in pairs(servers) do
			cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
			vim.lsp.config(server, cfg)
			vim.lsp.enable(server)
		end
	end,
}
