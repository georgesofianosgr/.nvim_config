local actions = require("telescope.actions")
local module = {}

module.setup = function()
	require("telescope").setup({
		-- defaults = { file_ignore_patterns = {"node_modules","bower_components"} },
		defaults = {
			file_ignore_patterns = { "node_modules", "bower_components", "yarn.lock" },
			layout_strategy = "flex",
			mappings = {
				i = {
					["<esc>"] = actions.close,
					["<C-o>"] = function(prompt_bufnr)
						require("telescope.actions").select_default(prompt_bufnr)
						require("telescope.builtin").resume()
					end,
					["<C-q>"] = actions.send_selected_to_qflist,
				},
			},
		},
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
					"build",
					"--exclude",
					".vscode",
					"--exclude",
					"client/bower_components",
					"--exclude",
					".cache",
				},
			},
			buffers = {
				theme = "dropdown",
				previewer = false,
				path_display = {
					"smart",
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
			command_palette = {
				{
					"File",
					{ "entire selection (C-a)", ':call feedkeys("GVgg")' },
					{ "save current file (C-s)", ":w" },
					{ "save all files (C-A-s)", ":wa" },
					{ "quit (C-q)", ":qa" },
					{
						"file browser (C-i)",
						":lua require'telescope'.extensions.file_browser.file_browser()",
						1,
					},
					{
						"search word (,-f)",
						":lua require('telescope.builtin').live_grep()",
						1,
					},
					{
						"git files (,-g)",
						":lua require('telescope.builtin').git_files()",
						1,
					},
					{
						"files (,-P)",
						":lua require('telescope.builtin').find_files()",
						1,
					},
				},
				{
					"Git",
					{ "File History", ":VGit buffer_history_preview" },
				},
				{
					"Help",
					{ "tips", ":help tips" },
					{ "cheatsheet", ":help index" },
					{ "tutorial", ":help tutor" },
					{ "summary", ":help summary" },
					{ "quick reference", ":help quickref" },
					{ "search help(F1)", ":lua require('telescope.builtin').help_tags()", 1 },
				},
				{
					"Vim",
					{ "reload vimrc", ":source $MYVIMRC" },
					{ "check health", ":checkhealth" },
					{ "jumps (Alt-j)", ":lua require('telescope.builtin').jumplist()" },
					{ "commands", ":lua require('telescope.builtin').commands()" },
					{ "command history", ":lua require('telescope.builtin').command_history()" },
					{ "registers (A-e)", ":lua require('telescope.builtin').registers()" },
					{ "colorshceme", ":lua require('telescope.builtin').colorscheme()", 1 },
					{ "vim options", ":lua require('telescope.builtin').vim_options()" },
					{ "keymaps", ":lua require('telescope.builtin').keymaps()" },
					{ "buffers", ":Telescope buffers" },
					{ "search history (C-h)", ":lua require('telescope.builtin').search_history()" },
					{ "paste mode", ":set paste!" },
					{ "cursor line", ":set cursorline!" },
					{ "cursor column", ":set cursorcolumn!" },
					{ "spell checker", ":set spell!" },
					{ "relative number", ":set relativenumber!" },
					{ "search highlighting (F12)", ":set hlsearch!" },
				},
			},
		},
	})

	require("telescope").load_extension("command_palette")
	require("telescope").load_extension("fzf")

	vim.api.nvim_set_keymap(
		"n",
		"<Leader>p",
		"<Cmd>Telescope find_files<CR>",
		-- "<Cmd>lua require('telescope.builtin').find_files({no_ignore=true})<cr>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap("n", "<Leader>f", "<Cmd>Telescope live_grep<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<Leader>b", "<Cmd>Telescope buffers<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<Leader>r", "<Cmd>Telescope lsp_references<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<Leader>q", "<Cmd>Telescope quickfix<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<Leader>*", "<Cmd>Telescope grep_string<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<Leader>g", "<Cmd>Telescope git_status<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<Leader>P", "<Cmd>Telescope command_palette<CR>", { noremap = true, silent = true })
end
return module
