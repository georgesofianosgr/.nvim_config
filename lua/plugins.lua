local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local function is_active()
	local ok, hydra = pcall(require, "hydra.statusline")
	return ok and hydra.is_active()
end

local function get_name()
	local ok, hydra = pcall(require, "hydra.statusline")
	if ok then
		return hydra.get_name()
	end
	return ""
end

return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("plugin_config.telescope_config").setup()
		end,
	},

	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = false }, -- 1.65x speed of fzf

	{
		"kyazdani42/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugin_config/nvimtree_config").setup()
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
	},

	{
		"glepnir/dashboard-nvim",
		event = "VimEnter",
		cond = false,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
		config = function()
			require("plugin_config/dashboard_config").setup()
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("plugin_config/treesitter_config").setup()
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		lazy = false,
		tag = "release",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
		-- config = function()
		--   require("gitsigns").setup()
		-- end,
	},

	-- LSP
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("plugin_config/null_ls_config").setup()
		end,
	},
	-- "hrsh7th/cmp-nvim-lsp",
	-- "hrsh7th/cmp-buffer",
	-- "SirVer/ultisnips",
	{
		"hrsh7th/nvim-cmp",
		dependencies = { { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer" } },
		config = function()
			require("plugin_config/cmp_nvim_config").setup()
		end,
	},

	"onsails/lspkind.nvim",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "onsails/lspkind.nvim" },
		},
		config = function()
			require("plugin_config/lsp_config").setup()
		end,
	},

	"tpope/vim-commentary", -- comment plugin
	"arcticicestudio/nord-vim", -- Nord theme
	"loctvl842/monokai-pro.nvim",
	"Mofiqul/vscode.nvim",
	{
		"folke/tokyonight.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("tokyonight").setup({
				hide_inactive_statusline = true,
				lualine_bold = true,
			})
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},
	"georgesofianosgr/onehalf-vim",
	"rakr/vim-one", -- Atom theme
	"kvrohit/mellow.nvim", -- Mellow theme
	"dstein64/nvim-scrollview", -- Show scrollbar
	"aserebryakov/vim-todo-lists", -- Todo checbox list
	{
		-- Status Line
		-- 'NTBBloodbath/galaxyline.nvim', -- FORKED until updated
		"glepnir/galaxyline.nvim",
		branch = "main",
		enabled = false,
		dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
		config = function()
			require("plugin_config/galaxyline_config")
		end,
	},
	{
		"smoka7/multicursors.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"smoka7/hydra.nvim",
		},
		opts = function()
			local N = require("multicursors.normal_mode")
			local I = require("multicursors.insert_mode")
			return {
				hint_config = false,
				normal_keys = {
					-- to change default lhs of key mapping change the key
					[","] = {
						-- assigning nil to method exits from multi cursor mode
						method = N.clear_others,
						-- you can pass :map-arguments here
						opts = { desc = "Clear others" },
					},
				},
				insert_keys = {
					-- to change default lhs of key mapping change the key
					["<CR>"] = {
						-- assigning nil to method exits from multi cursor mode
						method = I.Cr_method,
						-- you can pass :map-arguments here
						opts = { desc = "New line" },
					},
				},
			}
		end,
		cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
		keys = {
			{
				mode = { "v", "n" },
				"<Leader>m",
				"<cmd>MCstart<cr>",
				desc = "Create a selection for selcted text or word under the cursor",
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
		config = function()
			require("lualine").setup({
				options = {
					theme = "tokyonight",
					extensions = { "quickfix", "nvim-tree", "lazy" },
					sections = {
						lualine_b = {
							{ get_name, cond = is_active },
						},
					},
				},
			})
			-- require("plugin_config/galaxyline_config")
		end,
	},
	"wellle/targets.vim",
	"tpope/vim-surround",
	"psliwka/vim-smoothie",
	-- use("github/copilot.vim")
	-- use({
	-- 	"zbirenbaum/copilot-cmp",
	-- 	config = function()
	-- 		require("copilot_cmp").setup()
	-- 	end,
	-- })
	--
	-- use({
	-- 	"TaDaa/vimade",
	-- 	config = function()
	-- 		vim.g.vimade = { fadelevel = 0.7, enablesigns = 1 }
	-- 	end,
	-- })

	-- use("kkoomen/vim-doge") -- JSDOC produce
	{ "kevinhwang91/nvim-bqf", ft = "qf" }, -- quickfix list
	-- use({ "akinsho/bufferline.nvim", tag = "v3.*", requires = "nvim-tree/nvim-web-devicons" })

	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		opts = {
			-- options
		},
	},
	-- {
	--     "j-hui/fidget.nvim",
	--     dependencies = { { "neovim/nvim-lspconfig" } },
	--     config = true,
	--     -- config = function()
	--     -- 	require("fidget").setup()
	--     -- end,
	-- },

	{
		"LinArcX/telescope-command-palette.nvim",
		dependencies = { { "nvim-telescope/telescope.nvim" } },
	},

	{
		"tanvirtin/vgit.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("vgit").setup()
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				-- for example, context is off by default, use this to turn it on
				show_current_context = true,
				show_current_context_start = false,
			})
		end,
	},

	{
		"folke/noice.nvim",
		enabled = false,
		config = function()
			require("noice").setup({
				routes = {
					{
						view = "notify",
						filter = { event = "msg_showmode" },
					},
				},
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
			})
		end,
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},

	-- "folke/neodev.nvim",
}
