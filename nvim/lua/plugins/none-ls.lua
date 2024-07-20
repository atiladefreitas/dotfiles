-- return {
--   "nvimtools/none-ls.nvim",
--   opts = function(_, config)
--     local null_ls = require "null-ls"
--
--     config.sources = {
--
--       null_ls.builtins.formatting.stylua,
--       null_ls.builtins.formatting.prettier,
--       null_ls.builtins.diagnostics.eslint_d,
--     }
--     return config
--   end,
-- }
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
  },
  config = function()
    -- Carrega corretamente o módulo `null-ls`
    local null_ls = require "null-ls"

    -- Configure os builtins diretamente através de `null_ls.builtins`
    null_ls.setup {
      sources = {
        require "none-ls.diagnostics.eslint_d",
        -- null_ls.builtins.diagnostics.eslint_d,  -- Linter ESLint
        null_ls.builtins.formatting.stylua, -- Formatador Lua
        null_ls.builtins.formatting.prettier, -- Formatador JS/HTML/CSS
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports_reviser,
        null_ls.builtins.formatting.golines,
      },
    }

    -- Exemplo de mapeamento de teclado para formatação
    vim.keymap.set("n", "<leader>ll", vim.lsp.buf.format, {})
  end,
}
