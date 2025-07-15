-- sidebar
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    filesystem = {
      follow_current_file = true,
      filtered_items = {
        visible = true,
      },
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)
    -- Keymaps
    vim.keymap.set(
      "n",
      "<leader>e",
      ":Neotree toggle<CR>",
      { noremap = true, silent = true, desc = "Toggle Neotree" }
    )
  end,
}
