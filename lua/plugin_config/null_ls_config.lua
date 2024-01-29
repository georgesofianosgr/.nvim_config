local module = {}

module.setup = function()
	local null_ls = require("null-ls")

	null_ls.setup({
		sources = {
			-- null_ls.builtins.diagnostics.eslint,
			-- null_ls.builtins.code_actions.eslint,
			-- null_ls.builtins.formatting.prettier,
			null_ls.builtins.formatting.prettier,
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.goimports_reviser,
		},
		on_attach = function(client)
			if client.server_capabilities.documentFormattingProvider then
				-- wrap in an augroup to prevent duplicate autocmds
				vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
            augroup END
            ]])
			end
		end,
	})
end

return module
