local module = {}

module.setup = function()
	vim.g.ale_fixers = {javascript = {'eslint'}}
	vim.g.ale_fix_on_save = 0
	vim.g.ale_lint_on_insert_leave = 1
	vim.g.ale_sign_error='█'
	vim.g.ale_sign_warning='█'
	vim.g.ale_virtualtext_cursor = 1
	vim.g.ale_virtualtext_prefix = '   '
	vim.g.ale_disable_lsp = 1

	-- Connect lsp to ale
	local ale_diagnostic_severity_map = {
		[vim.lsp.protocol.DiagnosticSeverity.Error] = "E";
		[vim.lsp.protocol.DiagnosticSeverity.Warning] = "W";
		[vim.lsp.protocol.DiagnosticSeverity.Information] = "I";
		[vim.lsp.protocol.DiagnosticSeverity.Hint] = "I";
	}

	vim.lsp.diagnostic.original_clear = vim.lsp.diagnostic.clear
	vim.lsp.diagnostic.clear = function(bufnr, client_id, diagnostic_ns, sign_ns)
		vim.lsp.diagnostic.original_clear(bufnr, client_id, diagnostic_ns, sign_ns)
		-- Clear ALE
		vim.api.nvim_call_function('ale#other_source#ShowResults', {bufnr, "nvim-lsp", {}})
	end

	vim.lsp.diagnostic.set_signs = function(diagnostics, bufnr, _, _, _)
		if not diagnostics then
			return
		end

		local items = {}
		for _, item in ipairs(diagnostics) do
			table.insert(items, {
				nr = item.code,
				text = item.message,
				lnum = item.range.start.line+1,
				end_lnum = item.range['end'].line,
				col = item.range.start.character+1,
				end_col = item.range['end'].character,
				type = ale_diagnostic_severity_map[item.severity]
			})
		end

		vim.api.nvim_call_function('ale#other_source#ShowResults', {bufnr, "nvim-lsp", items})
		end

		vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
			vim.lsp.diagnostic.on_publish_diagnostics, {
				underline = false,
				virtual_text = false,
				signs = true,
				update_in_insert = false,
			}
		)
end

return module;
