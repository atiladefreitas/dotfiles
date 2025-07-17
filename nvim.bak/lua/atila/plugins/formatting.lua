-- formatter and linter
return {
  "stevearc/conform.nvim",
  event = { "bufreadpre", "bufnewfile" },
  config = function()
    local conform = require("conform")

    local markdown_folder = vim.fn.expand("~/Documents/notes")
    local excluded_subfolder = vim.fn.expand("~/Documents/notes/articles")

    conform.setup({
      formatters_by_ft = {
        javascript = { "biome", "prettier", "rustywind" },
        typescript = { "biome", "prettier", "rustywind" },
        javascriptreact = { "biome", "prettier", "rustywind" },
        typescriptreact = { "biome", "prettier", "rustywind" },
        svelte = { "biome", "prettier", "rustywind" },
        markdown = function()
          local current_file = vim.fn.expand("%:p")
          if current_file:find(excluded_subfolder, 1, true) then
            return {}             -- Disable formatting for files in excluded folder
          elseif current_file:find(markdown_folder, 1, true) then
            return { "prettier" } -- Enable formatting for other files in notes
          else
            return {}             -- Default to no formatter
          end
        end,
        css = { "prettier", "rustywind" },
        html = { "prettier", "rustywind" },
        json = { "biome" },
        yaml = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
      },
      format_after_save = {
        enable = false,
        lsp_fallback = true,
        async = true,
        timeout_ms = 1000,
      },
      formatters = {
        rustywind = {
          command = "rustywind",
          args = { "--stdin" },
          stdin = true,
        },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = true,
        timeout_ms = 1000,
      })
    end, { desc = "format file or range (in visual mode)" })
  end,
}
