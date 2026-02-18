-- Custom filetype detection configuration
vim.filetype.add({
  extension = {
    -- Ensure regular HTML files are detected as html, not htmldjango.
    -- jinja.vim will adjust to html.jinja when Jinja syntax is detected.
    html = "html",
    jinja = "jinja",
    jinja2 = "jinja",
    j2 = "jinja",
  },
}) 