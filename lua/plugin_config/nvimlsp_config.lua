local nvim_lsp = require("lspconfig")
local module = {}

-- local format_async = function(err, _, result, _, bufnr)
--     if err ~= nil or result == nil then return end
--     if not vim.api.nvim_buf_get_option(bufnr, "modified") then
--         local view = vim.fn.winsaveview()
--         vim.lsp.util.apply_text_edits(result, bufnr)
--         vim.fn.winrestview(view)
--         if bufnr == vim.api.nvim_get_current_buf() then
--             vim.api.nvim_command("noautocmd :update")
--         end
--     end
-- end

-- vim.lsp.handlers["textDocument/formatting"] = format_async

-- _G.lsp_organize_imports = function()
--     local params = {
--         command = "_typescript.organizeImports",
--         arguments = {vim.api.nvim_buf_get_name(0)},
--         title = ""
--     }
--     vim.lsp.buf.execute_command(params)
-- end

local on_attach = function(client, bufnr)
	client.resolved_capabilities.document_formatting = false
	client.resolved_capabilities.document_range_formatting = false

	-- Mappings.
	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	-- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", { silent = true })
	vim.api.nvim_buf_set_keymap(bufnr, "n", "qq", ":TSLspFixCurrent<CR>", { silent = true })
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", { silent = true })
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", { silent = true })
end

-- local filetypes = {
--     javascript = "eslint",
--     javascriptreact = "eslint",
-- }
-- local linters = {
--     eslint = {
--         sourcename = "eslint",
--         command = "eslint",
--         rootpatterns = {".eslintrc.js", "package.json"},
--         debounce = 100,
--         args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
--         parsejson = {
--             errorsroot = "[0].messages",
--             line = "line",
--             column = "column",
--             endline = "endline",
--             endcolumn = "endcolumn",
--             message = "${message} [${ruleid}]",
--             security = "severity"
--         },
--         securities = {[2] = "error", [1] = "warning"}
--     }
-- }
-- local formatters = {
--     prettier = {command = "prettier", args = {"--stdin-filepath", "%filepath"}}
-- }
-- local formatfiletypes = {
--     typescript = "prettier",
--     typescriptreact = "prettier"
-- }

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
module.setup = function()
	nvim_lsp.tsserver.setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})

	-- nvim_lsp.diagnosticls.setup {
	-- on_attach = on_attach,
	-- filetypes = vim.tbl_keys(filetypes),
	-- init_options = {
	-- filetypes = filetypes,
	-- linters = linters,
	-- formatters = formatters,
	-- formatFiletypes = formatFiletypes
	-- }
	-- }
end

return module
