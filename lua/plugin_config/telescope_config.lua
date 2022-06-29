local module = {}

module.setup = function()
	require("telescope").setup({
		-- defaults = { file_ignore_patterns = {"node_modules","bower_components"} },
		pickers = {
			find_files = {
				find_command = {
					"fd",
					"--type",
					"f",
					"--strip-cwd-prefix",
					"-HI",
					"--exclude",
					".git",
					"--exclude",
					"node_modules",
					"--exclude",
					"dist",
					"--exclude",
					".vscode",
					"--exclude",
					"client/bower_components",
					"--exclude",
					".cache",
				},
			},
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = false, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			},
		},
	})
	vim.api.nvim_set_keymap(
		"n",
		"<C-p>",
		"<Cmd>Telescope find_files<CR>",
		-- "<Cmd>lua require('telescope.builtin').find_files({no_ignore=true})<cr>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap("n", "<C-f>", "<Cmd>Telescope live_grep<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<Leader>b", "<Cmd>Telescope buffers<CR>", { noremap = true, silent = true })
end

return module
