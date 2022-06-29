local lsp_installer = require("nvim-lsp-installer")
local module = {}

local PUBLISH_DIAGNOSTICS = "textDocument/publishDiagnostics"

local make_diagnostics_handler = function(original_handler)
	return function(...)
		local config_or_client_id = select(4, ...)
		local is_new = type(config_or_client_id) ~= "number"
		local result = is_new and select(2, ...) or select(3, ...)

		local filter_out_diagnostics_by_code = {
			80001, -- RequireJS modules hint
			6133, -- defined but never used --> let eslint report this
		}

		local filtered_diagnostics = vim.tbl_filter(function(diagnostic)
			-- -- Only filter out Typescript LS diagnostics
			-- if diagnostic.source ~= "typescript" then
			--     return true
			-- end

			-- Filter out diagnostics with forbidden code
			if vim.tbl_contains(filter_out_diagnostics_by_code, diagnostic.code) then
				return false
			end

			return true
		end, result.diagnostics)

		result.diagnostics = filtered_diagnostics

		local config_idx = is_new and 4 or 6
		local config = select(config_idx, ...) or {}

		if is_new then
			original_handler(select(1, ...), select(2, ...), select(3, ...), config)
		else
			original_handler(select(1, ...), select(2, ...), select(3, ...), select(4, ...), select(5, ...), config)
		end
	end
end

local function setupBindings(bufnr)
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"gh",
		"<Cmd>lua vim.diagnostic.open_float({border = 'rounded', source = 'always'})<CR>",
		opts
	)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", { silent = true })
	vim.api.nvim_buf_set_keymap(bufnr, "n", "qq", ":TSLspFixCurrent<CR>", { silent = true })
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", { silent = true })
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", { silent = true })
end

local on_attach = function(client, bufnr)
	if client.name == "tsserver" then
		local diagnostics_handler = client.handlers[PUBLISH_DIAGNOSTICS] or vim.lsp.handlers[PUBLISH_DIAGNOSTICS]
		client.handlers[PUBLISH_DIAGNOSTICS] = make_diagnostics_handler(diagnostics_handler)
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
	end
	setupBindings(bufnr)
end

-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).
module.setup = function()
	vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = " ", numhl = "" })
	vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = " ", numhl = "" })
	vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", text = " ", numhl = "" })
	vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = " ", numhl = "" })
	-- vim.fn.sign_define("DiagnosticSignWarn",{texthl= "DiagnosticSignWarn", text = "❚", numhl=""})
	--
	-- vim.fn.sign_define("DiagnosticSignError",{texthl= "DiagnosticSignError", text = "│", numhl=""})
	-- vim.fn.sign_define("DiagnosticSignWarn",{texthl= "DiagnosticSignWarn", text = "│", numhl=""})
	-- vim.fn.sign_define("DiagnosticSignInfo",{texthl= "DiagnosticSignInfo", text = "│", numhl=""})
	-- vim.fn.sign_define("DiagnosticSignHint",{texthl= "DiagnosticSignHint", text = "│", numhl=""})

	vim.diagnostic.config({
		virtual_text = {
			source = false,
			format = function(diagnostic)
				-- 	local prefix = ""
				-- 	if diagnostic.severity == vim.diagnostic.severity.ERROR then
				-- 		prefix = "🔥"
				-- 	elseif diagnostic.severity == vim.diagnostic.severity.WARN then
				-- 		prefix = "🚧"
				-- 	else
				-- 		prefix = "💬"
				-- 	end
				return string.format("%s (%s)", diagnostic.message, diagnostic.user_data.lsp.code)
			end,
		},
		float = {
			source = true,
			format = function(diagnostic)
				return string.format("%s (%s)", diagnostic.message, diagnostic.user_data.lsp.code)
			end,
		},
		underline = true,
		update_in_insert = false,
		signs = true,
		severity_sort = true,
	})

	-- You will likely want to reduce updatetime which affects CursorHold
	-- note: this setting is global and should be set only once
	-- vim.o.updatetime = 250
	-- vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

	local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
	lsp_installer.on_server_ready(function(server)
		local opts = {
			on_attach = on_attach,
			capabilities = capabilities,
		}

		if server.name == "sumneko_lua" then
			opts = {
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			}
		end

		server:setup(opts)
	end)
end

return module
