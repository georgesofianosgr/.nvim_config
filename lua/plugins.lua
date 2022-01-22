local default_finder = "TELESCOPE" -- SNAP | TELESCOPE
local isDefaultFinder = function(value) return string.match(default_finder, value) end

-- Install packer if not available
local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end


return require('packer').startup({function()
		use 'wbthomason/packer.nvim'

		----- Default finder ----
		use { 'camspiers/snap', 
			disable = not(isDefaultFinder("SNAP")),
		  rocks = {'fzy'}, 
		  config = function() 
				require('plugin_config/snap_config').setup()
			end
		}
		use { 'nvim-telescope/telescope.nvim',
			disable = not(isDefaultFinder("TELESCOPE")),
			requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
		  config = function() 
				require('plugin_config/telescope_config').setup()
			end
		}
		if(isDefaultFinder("TELESCOPE")) then
		  use { 'nvim-telescope/telescope-fzf-native.nvim',
		  run = 'make',
		  requires = {{'nvim-telescope/telescope.nvim'}},
		  config = function ()
		    require('telescope').load_extension('fzf')
      end
		}
    end


		-- Other
		use { 'kyazdani42/nvim-tree.lua', 
			requires = {"kyazdani42/nvim-web-devicons"},
		  config = function() 
				require('plugin_config/nvimtree_config').setup()
			end
	  } -- Nerd tree alternative for listing files

		use { "glepnir/dashboard-nvim",
			config = function() 
				require('plugin_config/dashboard_config').setup()
			end
		} -- startup view

		use { "sbdchd/neoformat",
			config = function() 
				require('plugin_config/neoformat_config').setup()
			end
		}

    -- use { "dgkf/blamer.nvim",  branch = "dev/virt-text-hl-mode" }
		use { 
		-- '~/Development/repos/blamer.nvim',
		'APZelos/blamer.nvim',
		  config = function ()
		    vim.g.blamer_relative_time = 1
      end
    }
		use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
		-- use {
		-- 	'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
		-- 	config = function() 
		-- 		require('gitsigns').setup() 
		-- 	end
		-- }
	  use 'hrsh7th/cmp-nvim-lsp'
	  use 'hrsh7th/cmp-buffer'
    use { "hrsh7th/nvim-cmp",
		  requires = {{'hrsh7th/cmp-nvim-lsp','hrsh7th/cmp-buffer'}},
			config = function() 
				require('plugin_config/cmp_nvim_config').setup()
			end
		}

		use { "neovim/nvim-lspconfig",
		  requires = {{'hrsh7th/cmp-nvim-lsp'}},
			config = function() 
				require('plugin_config/nvimlsp_config').setup()
			end
		}-- Basic lsp setup
		use { "dense-analysis/ale",
			config = function() 
				require('plugin_config/ale_config').setup()
			end
		}
		-- use "mhinz/vim-startify"
		-- use "nvim-lua/completion-nvim"
		-- use 'hrsh7th/nvim-compe' -- Autocompletion plugin -- DEPRECATED -> setup is in init.lua, should move to own config (use nvim-cmp instead)
		use "tpope/vim-commentary" -- comment plugin
		use "arcticicestudio/nord-vim" -- Nord theme
	  use 'folke/tokyonight.nvim'
		use "rakr/vim-one" -- Atom theme
		use {"jose-elias-alvarez/nvim-lsp-ts-utils",
			requires = { 
				'nvim-lua/plenary.nvim', 
				"jose-elias-alvarez/null-ls.nvim" 
			}
			} -- lsp tsserver setup
		-- use "jose-elias-alvarez/null-ls.nvim" -- setup eslint & prettier
		use "dstein64/nvim-scrollview" -- Show scrollbar
		use "aserebryakov/vim-todo-lists" -- Todo checbox list
		use { -- Status Line
		'glepnir/galaxyline.nvim',
			branch = 'main',
			-- your statusline
			-- config = function() require('galaxyline_config') end,
			-- some optional icons
			requires = {'kyazdani42/nvim-web-devicons', opt = true},
			config = function() 
        require('galaxyline_config')
			end
		}
		use "wellle/targets.vim"
		use "tpope/vim-surround"
		use "psliwka/vim-smoothie"
	end,
	config = {
		display = {
			open_fn = function()
      	return require('packer.util').float({ border = 'single' })
			end
		}
	}
})
