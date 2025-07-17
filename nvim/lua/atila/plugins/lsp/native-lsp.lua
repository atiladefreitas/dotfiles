return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
 local lspconfig = require("lspconfig")
  local capabilities = require("blink.cmp").get_lsp_capabilities()
  local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local keymap = vim.keymap.set

    keymap("n", "gd", vim.lsp.buf.definition, opts)
    keymap("n", "K", vim.lsp.buf.hover, opts)
    keymap("n", "gi", vim.lsp.buf.implementation, opts)
    keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
    keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    keymap("n", "gr", vim.lsp.buf.references, opts)
    keymap("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)

    if client.name == "biome" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end

  -- JS/TS/React (lightweight and fast)
  lspconfig.vtsls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
    },
  })

  -- Biome (Formatter + Linter)
  lspconfig.biome.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })

  -- HTML
  lspconfig.html.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })

  -- CSS
  lspconfig.cssls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })

  -- Tailwind CSS
  lspconfig.tailwindcss.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })

  -- Lua
  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  })

  -- Markdown (via marksman)
  lspconfig.marksman.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })
  end,
} 
