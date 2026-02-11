return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  cmd = "Telescope",
  keys = {
    { "<leader><CR>", desc = "Resume previous search" },
    { "<leader>f'",   desc = "Marks" },
    { "<leader>fb",   desc = "Buffers" },
    { "<leader>fc",   desc = "Word at cursor" },
    { "<leader>fC",   desc = "Commands" },
    { "<leader>ff",   desc = "Find files" },
    { "<leader>fF",   desc = "Find files (include hidden)" },
    { "<leader>fh",   desc = "Help Tags" },
    { "<leader>fk",   desc = "Keymaps" },
    { "<leader>fm",   desc = "Man Pages" },
    { "<leader>fn",   desc = "Notifications" },
    { "<leader>fo",   desc = "Old Files" },
    { "<leader>fr",   desc = "Registers" },
    { "<leader>ft",   desc = "Colorschemes" },
    { "<leader>fw",   desc = "Live Grep" },
    { "<space>fB",    desc = "File Browser" },
    { "<leader>fW",   desc = "Live Grep (include hidden)" },
    { "<leader>ls",   desc = "LSP Symbols" },
    { "<leader>lG",   desc = "LSP Workspace Symbols" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "andrew-george/telescope-themes",
    "nvim-telescope/telescope-file-browser.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local transform_mod = require("telescope.actions.mt").transform_mod

    telescope.load_extension("themes")

    telescope.setup({
      defaults = {
        file_ignore_patterns = {
          "%.md",
        },
        path_display = { "smart" },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        sorting_strategy = "descending",

        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next,     -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-s>"] = actions.select_vertical,
          },
        },
      },
      pickers = {
        find_files = {
          file_sorter = require("telescope.sorters").get_fuzzy_file,
        },
      },
      extensions = {
        file_browser = {
          path = "%:p:h",
          cwd = vim.loop.cwd(),
          cwd_to_path = false,
          grouped = false,
          files = true,
          add_dirs = true,
          depth = 1,
          auto_depth = false,
          select_buffer = false,
          hidden = { file_browser = false, folder_browser = false },
          respect_gitignore = vim.fn.executable("fd") == 1,
          no_ignore = false,
          follow_symlinks = false,
          browse_files = require("telescope._extensions.file_browser.finders").browse_files,
          browse_folders = require("telescope._extensions.file_browser.finders").browse_folders,
          hide_parent_dir = false,
          collapse_dirs = false,
          prompt_path = false,
          quiet = false,
          dir_icon = "",
          dir_icon_hl = "Default",
          display_stat = { date = false, size = true, mode = false },
          hijack_netrw = false,
          use_fd = true,
          git_status = true,
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("file_browser")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader><CR>", "<cmd>Telescope resume<cr>", { desc = "Resume previous search" })
    keymap.set("n", "<leader>f'", "<cmd>Telescope marks<cr>", { desc = "Marks" })
    keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Word at cursor" })
    keymap.set("n", "<leader>fC", "<cmd>Telescope commands<cr>", { desc = "Commands" })
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
    keymap.set(
      "n",
      "<leader>fF",
      "<cmd>Telescope find_files hidden=true<cr>",
      { desc = "Find files (include hidden files)" }
    )
    keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
    keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
    keymap.set("n", "<leader>fm", "<cmd>Telescope man_pages<cr>", { desc = "Man Pages" })
    keymap.set("n", "<leader>fn", "<cmd>Telescope notifications<cr>", { desc = "Notifications" })
    keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Old Files" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope registers<cr>", { desc = "Registers" })
    keymap.set("n", "<leader>ft", "<cmd>Telescope colorscheme<cr>", { desc = "Colorschemes" })
    keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
    keymap.set("n", "<space>fB", ":Telescope file_browser<CR>")
    keymap.set(
      "n",
      "<leader>fW",
      "<cmd>Telescope live_grep hidden=true<cr>",
      { desc = "Live Grep (include hidden files)" }
    )
    keymap.set("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "LSP Symbols" })
    keymap.set("n", "<leader>lG", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "LSP Workspace Symbols" })
  end,
}
