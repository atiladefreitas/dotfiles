local nvim_lsp = require "lspconfig"

nvim_lsp.tsserver.setup {
  on_attatch = function(client, bufnr)
    client.resolver_capabilities.document_formmating = false
    client.resolver_capabilities.document_rage_formmating = false
  end,
  flags = {
    debounce_text_changes = 150,
  },
}
