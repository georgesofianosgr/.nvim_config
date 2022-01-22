local nvimtree = require'nvim-tree'
local module = {}

module.setup = function()
	vim.g.nvim_tree_width = 40
	vim.g.nvim_tree_quit_on_open = 1
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
    },
    git = {
      enable = true,
      ignore = true,
      timeout = 500,
    },
    update_focused_file = {
      enable      = true,
      update_cwd  = false,
      ignore_list = {'.git','node_modules','.cache'}
    },
	}
end

return module;

