return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    sources = {
      "filesystem",
      -- "buffers",  -- Disable buffers tab
      -- "git_status",  -- Disable git tab
    },
    filesystem = {
      filtered_items = {
        visible = true,
      },
    },
  },
}
