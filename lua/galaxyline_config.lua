--------------------------- Galaxxy Line ---------------------------
--https://github.com/LoydAndrew/nvim/blob/main/evilline.lua
--https://github.com/Th3Whit3Wolf/dots/blob/main/private_dot_config/private_nvim/private_lua/private_plugins/statusline/private_init.lua
local galaxy = require('galaxyline')
local diagnostic = require('galaxyline.provider_diagnostic')
local vcs = require('galaxyline.provider_vcs')
local fileinfo = require('galaxyline.provider_fileinfo')
local extension = require('galaxyline.provider_extensions')
-- local colors = require('galaxyline.colors')
local buffer = require('galaxyline.provider_buffer')
local whitespace = require('galaxyline.provider_whitespace')
local lspclient = require('galaxyline.provider_lsp')

-- provider 
BufferIcon  = buffer.get_buffer_type_icon
BufferNumber = buffer.get_buffer_number
FileTypeName = buffer.get_buffer_filetype
-- Git Provider
GitBranch = vcs.get_git_branch
DiffAdd = vcs.diff_add             -- support vim-gitgutter vim-signify gitsigns
DiffModified = vcs.diff_modified   -- support vim-gitgutter vim-signify gitsigns
DiffRemove = vcs.diff_remove       -- support vim-gitgutter vim-signify gitsigns
-- File Provider
LineColumn = fileinfo.line_column
FileFormat = fileinfo.get_file_format
FileEncode = fileinfo.get_file_encode
FileSize = fileinfo.get_file_size
FileIcon = fileinfo.get_file_icon
FileName = fileinfo.get_current_file_name
LinePercent = fileinfo.current_line_percent
ScrollBar = extension.scrollbar_instance
VistaPlugin = extension.vista_nearest
-- Whitespace
Whitespace = whitespace.get_item
-- Diagnostic Provider
DiagnosticError = diagnostic.get_diagnostic_error
DiagnosticWarn = diagnostic.get_diagnostic_warn
DiagnosticHint = diagnostic.get_diagnostic_hint
DiagnosticInfo = diagnostic.get_diagnostic_info
-- LSP
GetLspClient = lspclient.get_lsp_client
-- Ale
local aleError = function()
  local buffer = vim.fn.bufnr('') 
  local counts = vim.fn['ale#statusline#Count'](buffer)
  return counts['error']
end

local aleWarning = function()
  local buffer = vim.fn.bufnr('') 
  local counts = vim.fn['ale#statusline#Count'](buffer)
  return counts['warning']
end

local aleInfo = function()
  local buffer = vim.fn.bufnr('') 
  local counts = vim.fn['ale#statusline#Count'](buffer)
  return counts['info']
end

local aleLintingBit = 0;
local aleLinting = function()
  local icon1 = ""
  local icon2 = ""
  local icon3 = ""
  local buffer = vim.fn.bufnr('') 
  local ale_running = vim.fn['ale#engine#IsCheckingBuffer'](buffer)
  if ale_running == 1 and aleLintingBit == 0 then
    aleLintingBit = 1;
    return icon1
  elseif ale_running == 1 and aleLintingBit == 1 then
    aleLintingBit = 2;
    return icon2
  elseif ale_running == 1 and aleLintingBit == 2 then
    aleLintingBit = 0;
    return icon3
  else
    aleLintingBit = 0;
    return ""
  end
end


-- TODO apply to own pluggins
galaxy.short_line_list = {
    'LuaTree',
    'vista',
    'dbui',
    'startify',
    'term',
    'nerdtree',
    'fugitive',
    'fugitiveblame',
    'plug',
	'NvimTree',
	'Packager',
}


local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

local colors = {
    bg = '#282c34',
    line_bg = '#353644',
    fg = '#8FBCBB',
    fg_green = '#65a380',

    yellow = '#fabd2f',
    cyan = '#008080',
    darkblue = '#081633',
    green = '#afd700',
    orange = '#FF8800',
    purple = '#5d4d7a',
    magenta = '#c678dd',
    blue = '#51afef';
    red = '#ec5f67'
}

galaxy.section.left[1] = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local alias = {
          -- n = 'NORMAL',
          -- i = 'INSERT',
          -- c= 'COMMAND',
          -- v ='VISUAL',
          -- V= 'VISUAL-LINE',
		  -- ["�"] = 'VISUAL-BLOCK',
          -- ['r?'] = ':CONFIRM',
          -- rm = '--MORE',
          -- R  = 'REPLACE',
          -- Rv = 'VIRTUAL',
          -- s  = 'SELECT',
          -- S  = 'SELECT',
          -- ['r']  = 'HIT-ENTER',
		  -- ["�"] = 'SELECT',
          -- t  = 'TERMINAL',
          -- ['!']  = 'SHELL',

        -- [110] = "🅝",
        -- [105] = "🅘",
        -- [118]  = "🅥",
        -- [22]  = "🅥",
        -- [86]  = "🅥",
        -- [99] = "🅒",
        -- [116] = "🅣",
        -- [82] = "🅡",
        -- [115] = "🅢",
        -- [83] = "🅢",

		[110] = 'NORMAL',
		[105] = 'INSERT',
		[118] = 'VISUAL',
		[22] = 'V-BLOCK',
		[86] = 'V-LINE',
		[99] = 'COMMAND',
		[116] = 'TERMINAL',
		[82] = 'REPLACE',
		[115] = 'SELECT',
		[83] = 'S-LINE'

      }
	  local vim_mode_byte = vim.fn.mode():byte()

      local mode_color = {
          [110] = colors.green, -- NORMAL
          [105] = colors.blue, -- INSERT
		  [118] = colors.magenta, -- VISUAL
		  [22] = colors.magenta, -- VISUAL BLOCK
		  [86] = colors.magenta, -- VISUAL LINE
          [99] = colors.red, -- Command
		  [116] =  colors.green, -- Terminal
		  [82] = colors.yellow, -- Replace
		  [115] = colors.orange, -- Select
		  [83] = colors.orange, -- S-LINE
      }
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim_mode_byte])
      return '  ' .. alias[vim_mode_byte]
    end,
	separator = "    ",
    highlight = {colors.red,colors.line_bg,'bold'},
  },
}


galaxy.section.left[2] = {
  fileIcon = {
    provider = 'FileIcon',
    condition = buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.line_bg},
  },
}

galaxy.section.left[3] = {
	fileName = {
	  provider = FileName,
	  separator = "   ",
      condition = buffer_not_empty,
	}
}

-- galaxy.section.left[4] = {
-- 	fileEnd = {
-- 		provider = whitespace.get_item,
-- 		icon = "    "
--     }
-- }

-- galaxy.section.left[4] = {
--   GitIcon = {
--     provider = function() return '  ' end,
--     condition = require('galaxyline.provider_vcs').check_git_workspace,
--     highlight = {colors.orange,colors.line_bg},
--   }
-- }
galaxy.section.left[5] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = require('galaxyline.provider_vcs').check_git_workspace,
	separator = "  ",
	icon = " ",
    highlight = {'#8FBCBB',colors.line_bg,'bold'},
  }
}

local checkwidth = function()
  local squeeze_width  = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

galaxy.section.left[6] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = checkwidth,
    icon = ' ',
    highlight = {colors.green,colors.line_bg},
  }
}
galaxy.section.left[7] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = checkwidth,
    icon = ' ',
    highlight = {colors.orange,colors.line_bg},
  }
}
galaxy.section.left[8] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = checkwidth,
    icon = ' ',
    highlight = {colors.red,colors.line_bg},
  }
}

galaxy.section.left[9] = {
  LeftEnd = {
    provider = function() return ' ⏽' end,
    separator = ' ⏽',
    separator_highlight = {colors.bg,colors.line_bg},
    highlight = {colors.line_bg,colors.line_bg}
  }
}

galaxy.section.right[1] = {
	AleLintingStatus = {
		provider = aleLinting,
    highlight = {'#8FBCBB',colors.line_bg},
    separator='  '
		}
}

galaxy.section.right[2] = {
	DiagError = {
		provider = aleError, -- diagnostic.get_diagnostic_error,
	    icon= ' ',
    highlight = {colors.red,colors.line_bg},
    separator='  '
		}
}

galaxy.section.right[3] = {
	DiagWarn = {
		provider = aleWarning, -- diagnostic.get_diagnostic_warn,
		icon= ' ',
    highlight = {colors.orange,colors.line_bg},
    separator='  '
		}
}

galaxy.section.right[4] = {
	DiagInfo = {
		provider = aleInfo, --diagnostic.get_diagnostic_info,
		icon= ' ',
    highlight = {colors.blue,colors.line_bg},
    separator='  '
		}
}

-- galaxy.section.right[4] = {
-- 	DiagHint = {
-- 		provider = diagnostic.get_diagnostic_hint,
-- 		icon= ' ',
--     highlight = {colors.blue,colors.line_bg},
-- 		}
-- }

galaxy.section.right[5] = {
	LSPClient = {
		provider = lspclient.get_lsp_client,
    highlight = {'#8FBCBB',colors.line_bg},
    separator='  '
		}
}

