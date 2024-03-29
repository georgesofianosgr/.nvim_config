local nvimtree = require("nvim-tree")
local module = {}

module.setup = function()
  vim.g.nvim_tree_width = 40
  -- vim.g.nvim_tree_quit_on_open = 1 // moved to setup
  -- vim.g.nvim_tree_indent_markers = 1 // moved to setup
  -- vim.g.nvim_tree_highlight_opened_files = 1

  vim.api.nvim_set_keymap("n", "<C-b>", ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true })

  nvimtree.setup({
    renderer = {
      root_folder_label = false,
      highlight_opened_files = "all",
      indent_markers = {
        enable = false,
      },
    },
    actions = {
      open_file = {
        resize_window = true,
        quit_on_open = true,
      },
    },
    view = {
      width = 45,
      -- hide_root_folder = true, -- depricated
      side = "left",
    },
    git = {
      enable = true,
      ignore = true,
      timeout = 500,
    },
    update_focused_file = {
      enable = true,
      update_cwd = false,
      ignore_list = { ".git", "node_modules", ".cache" },
    },
  })
end

return module
