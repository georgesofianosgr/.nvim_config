local module = {}

module.setup = function()
  vim.api.nvim_exec([[
      autocmd!
      autocmd BufWritePre * Neoformat
      augroup END
  ]], false)

  vim.api.nvim_exec(
[[
if isdirectory($PWD .'/node_modules')
let $PATH .= ':' . $PWD . '/node_modules/.bin'
endif
]],false
)

  -- Add prettier globally for now
  -- local newPath = vim.env.PATH .. ':' .. vim.env.PWD .. '/node_modules/.bin/prettier'
  -- print(newPath)
	-- vim.env.PATH = newPath
end

return module;
