local nvimtree = require'nvim-tree'
local module = {}

module.setup = function()
	vim.g.nvim_tree_follow = 1
	vim.g.nvim_tree_width = 40
	vim.g.nvim_tree_ignore = {'.git','node_modules','.cache'}
	vim.g.nvim_tree_quit_on_open = 1
	vim.g.nvim_tree_gitignore = 1
	vim.g.nvim_tree_indent_markers = 1
	vim.g.nvim_tree_highlight_opened_files = 1
	
	vim.api.nvim_set_keymap(
		"n", 
		"<C-b>", 
		":NvimTreeFindFileToggle<CR>", 
		{noremap = true, silent = true}
	)

	nvimtree.setup {
	  view = {
      width = 45,
      hide_root_folder = true,
      side = 'left',
      auto_resize = true,
    }
	}
end

return module;

