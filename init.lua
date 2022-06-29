vim.g.blamer_enabled = 1
require("plugins")

local api = vim.api

vim.opt.showmode = false -- do not show mode
vim.opt.cursorline = true
vim.opt.wildmenu = true
vim.opt.showmatch = true
vim.opt.scrolloff = 5
vim.opt.showtabline = 2
vim.opt.laststatus = 3

vim.g.mapleader = ","
-- vim.opt.completeopt =  "menuone,noinsert,noselect"
vim.opt.completeopt = { "menuone", "noselect" }

--Incremental live completion
vim.o.inccommand = "nosplit"

--Set highlight on search
vim.o.hlsearch = true
vim.o.incsearch = true

--Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

--Do not save when switching buffers
vim.o.hidden = true

--Enable mouse mode
vim.o.mouse = "a"

--Enable break indent
vim.o.breakindent = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

--Set colorscheme (order is important here)
vim.o.termguicolors = true

-- Set clipboard to system
vim.o.clipboard = "unnamedplus"

-- maintain undo history between sessions
vim.cmd([[
set undofile
]])

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.shiftround = true
vim.o.autoindent = true
vim.o.copyindent = true

vim.opt.swapfile = false
vim.opt.backup = false

-- Fixe bellow statement by maping Ctrl+c -> esc
-- CTRL-C  Quit insert mode, go back to Normal mode.  Do not check for
--      abbreviations.  Does not trigger the |InsertLeave| autocommand
--      event.
api.nvim_set_keymap("n", "<C-c>", "<ESC>", { noremap = true })
api.nvim_set_keymap("i", "<C-c>", "<ESC>", { noremap = true })

-- To remove highlight from searched word
-- C-l redraws the screen. We change it so that it also removes all highlights
-- C-u so that we remove any ranges which might be there due to visual mode
api.nvim_set_keymap("n", "<C-l>", ":<C-u>noh<CR><C-l>", { noremap = true, silent = true })

-- remap j and k to move across display lines and not real lines
api.nvim_set_keymap("n", "k", "gk", { noremap = true })
api.nvim_set_keymap("n", "gk", "k", { noremap = true })
api.nvim_set_keymap("n", "j", "gj", { noremap = true })
api.nvim_set_keymap("n", "gj", "j", { noremap = true })

-- Delete is delete, leader-delete is cut
api.nvim_set_keymap("n", "d", '"_d', { noremap = true, silent = true })
api.nvim_set_keymap("n", "D", '"_D', { noremap = true, silent = true })
api.nvim_set_keymap("v", "d", '"_d', { noremap = true, silent = true })

api.nvim_set_keymap("n", "<leader>d", '"+d', { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>D", '"+D', { noremap = true, silent = true })
api.nvim_set_keymap("v", "<leader>d", '"+d', { noremap = true, silent = true })

api.nvim_set_keymap("n", "c", '"_c', { noremap = true, silent = true })
api.nvim_set_keymap("n", "C", '"_C', { noremap = true, silent = true })
api.nvim_set_keymap("v", "c", '"_c', { noremap = true, silent = true })

-- Move between splits (<control> not working)
-- api.nvim_set_keymap('n', "<control>j", ":wincmd j<CR>", { noremap = true, silent = true })
-- api.nvim_set_keymap('n', "<control>k", ":wincmd k<CR>", { noremap = true, silent = true })
-- api.nvim_set_keymap('n', "<control>h", ":wincmd h<CR>", { noremap = true, silent = true })
-- api.nvim_set_keymap('n', "<control>l", ":wincmd l<CR>", { noremap = true, silent = true })

-- <Cmd>lua vim.lsp.buf.declaration()<CR>

-- api.nvim_set_keymap("n", "d", "_d", {noremap = true})
-- api.nvim_set_keymap("n", "D", "_D", {noremap = true})
-- api.nvim_set_keymap("v", "d", "_d", {noremap = true})
-- api.nvim_set_keymap("n", "<leader>d", "+d", {noremap = true})
-- api.nvim_set_keymap("n", "<leader>D", "+D", {noremap = true})
-- api.nvim_set_keymap("v", "<leader>d", "+d", {noremap = true})

-- api.nvim_set_keymap("n", "c", "_c", {noremap = true})
-- api.nvim_set_keymap("n", "C", "_C", {noremap = true})
-- api.nvim_set_keymap("v", "c", "_c", {noremap = true})
-- api.nvim_set_keymap("n", "<leader>c", "+c", {noremap = true})
-- api.nvim_set_keymap("n", "<leader>C", "+C", {noremap = true})
-- api.nvim_set_keymap("v", "<leader>c", "+c", {noremap = true})

-- api.nvim_set_keymap("xn", "<leader>c", "+c", {noremap = true})

-- " P is for paste, won't replace register on visual select
-- TODO
-- xnoremap <expr> p 'pgv"'.v:register.'y'

-- Highlight on yank
vim.api.nvim_exec(
	[[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
	false
)

vim.g.VimTodoListsUndoneItem = "- "
vim.g.VimTodoListsDoneItem = "- "

------------------------- Tree Sitter ------------------------------
require("nvim-treesitter.configs").setup({
	ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	highlight = {
		enable = true, -- false will disable the whole extension
	},
	indent = {
		enable = true,
	},
})

local function getExtension(buffer)
	if buffer == nil then
		return
	end

	return buffer:match("[^.]+$")
end

function ChangeStyled()
	local current_buffer_path = vim.fn.expand("%")
	if current_buffer_path == nil then
		return
	end

	local extension = getExtension(current_buffer_path)

	if extension ~= "js" and extension ~= "jsx" and extension ~= "ts" and extension ~= "tsx" then
		print("Unsupported extension " .. extension)
		return
	end

	local jsFile = current_buffer_path:match("[^/]*." .. extension .. "$")
	local styledFile = current_buffer_path:match("[^/]*Styled." .. extension .. "$")
	local isStyled = jsFile == styledFile
	local extRegex = isStyled and "(Styled." .. extension .. ")$" or "(" .. extension .. ")$"
	local newExt = isStyled and extension or "Styled." .. extension
	local nextFile = string.gsub(current_buffer_path, extRegex, newExt)

	local f = io.open(nextFile, "r")
	local fileExists = f ~= nil
	if fileExists then
		io.close(f)
		vim.api.nvim_exec(":e " .. nextFile, false)
	end
end

local function doesFileExist(path)
	local f = io.open(path, "r")
	local fileExists = f ~= nil
	if fileExists then
		io.close(f)
	end
	return fileExists
end

function CreateStyled()
	local current_buffer_path = vim.fn.expand("%")
	if current_buffer_path == nil then
		return
	end

	local extension = getExtension(current_buffer_path)

	if extension ~= "js" and extension ~= "jsx" and extension ~= "ts" and extension ~= "tsx" then
		print("Unsupported extension " .. extension)
		return
	end

	local file = current_buffer_path:match("[^/]*." .. extension .. "$")
	local styledFile = current_buffer_path:match("[^/]*Styled." .. extension .. "$")
	local isStyled = file == styledFile
	if isStyled then
		print("Cannot create styled file from styled file", file, styledFile)
		return
	end

	local nextFile = string.gsub(current_buffer_path, "(" .. extension .. ")$", "Styled." .. extension)
	local fileExists = doesFileExist(nextFile)
	if fileExists == false then
		vim.api.nvim_exec(":enew", false)
		vim.api.nvim_exec(":r ~/.local/share/nvim/templates/styled." .. extension, false)
		vim.api.nvim_exec(":w " .. nextFile, false)
	else
		print("Styled file already exists")
	end
end

vim.api.nvim_set_keymap("n", "gst", "<Cmd>:lua ChangeStyled()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gns", "<Cmd>:lua CreateStyled()<CR>", { noremap = true, silent = true })

----------------------------------------
