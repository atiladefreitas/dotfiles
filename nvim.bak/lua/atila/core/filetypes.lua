-- Custom filetype detection configuration
vim.filetype.add({
  extension = {
    -- Ensure regular HTML files are detected as html, not htmldjango
    html = "html",
  },
  -- Add pattern-based detection if needed
  pattern = {
    -- If you have specific patterns that should be detected as htmldjango,
    -- you can add them here, e.g., Django template files
    -- ['.*%.django%.html'] = 'htmldjango',
  },
}) 