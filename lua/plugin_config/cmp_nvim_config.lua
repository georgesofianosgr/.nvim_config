local cmp = require("cmp")
local module = {}

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

module.setup = function()
  local lspkind = require("lspkind")
  cmp.setup({
      -- completion settings
      formatting = {
          format = lspkind.cmp_format({ with_text = true, maxwidth = 50 }),
      },
      completion = {
          --completeopt = 'menu,menuone,noselect'
          keyword_length = 2,
      },
      snippet = {
          expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
          end,
      },
      -- key mapping
      mapping = {
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs( -4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
          }),

          -- Tab mapping
          ["<Tab>"] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
              -- elseif luasnip.expand_or_jumpable() then
              -- 	luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end,
          ["<S-Tab>"] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
              -- elseif luasnip.jumpable(-1) then
              -- 	luasnip.jump(-1)
            else
              fallback()
            end
          end,
      },
      -- load sources, see: https://github.com/topics/nvim-cmp
      sources = {
          { name = "nvim_lsp" },
          -- { name = 'path' },
          { name = "buffer" },
      },
  })
end

return module
