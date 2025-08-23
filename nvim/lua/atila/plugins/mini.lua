return {
  {
    "echasnovski/mini.cursorword",
    version = false,
    config = function()
      require("mini.cursorword").setup({
        delay = 100,
      })
      vim.api.nvim_set_keymap(
        "n",
        "<leader>cE",
        ":lua require('mini.cursorword').toggle()<CR>",
        { noremap = true, silent = true, desc = "Toggle cursorword highlight" }
      )
    end,
  },
  
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.move").setup({
        mappings = {
          -- Move visual selection in Visual mode
          down = "<a-j>",
          up = "<a-k>",
          -- Move current line in Normal mode
          line_down = "<a-j>",
          line_up = "<a-k>",
        },
        options = {
          reindent_linewise = true,
        },
      })
    end,
  },
  
  {
    "echasnovski/mini.pairs",
    version = false,
    config = function()
      require("mini.pairs").setup({
        modes = { insert = true, command = false, terminal = false },

        mappings = {
          ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
          ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
          ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

          [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
          ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
          ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

          ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
          ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
          ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
          ["*"] = { action = "closeopen", pair = "**", neigh_pattern = "[^\\].", register = { cr = false } },
        },
      })
    end,
  },
  
  {
    "echasnovski/mini.statusline",
    version = "*",
    config = function()
      require("mini.statusline").setup({
        content = {
          -- Content for active window
          active = nil,
          -- Content for inactive window(s)
          inactive = nil,
        },

        -- Whether to use icons by default
        use_icons = true,

        -- Whether to set Vim's settings for statusline (make it always shown)
        set_vim_settings = true,
      })
    end,
  },
  
  {
    "echasnovski/mini.surround",
    version = false,
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = "", -- Adicionar surround
          delete = "", -- Remover surround
          find = "", -- Encontrar surround
          find_left = "", -- Encontrar surround à esquerda
          highlight = "", -- Realçar surround
          replace = "", -- Substituir surround
          update_n_lines = "", -- Atualizar n linhas
        },
      })

      local map = vim.api.nvim_set_keymap
      local opts = { noremap = true, silent = true }

      map("n", "<leader>sa", ":lua MiniSurround.add('visual')<CR>", opts)
      map("x", "<leader>sa", ":lua MiniSurround.add('visual')<CR>", opts)
      map("n", "<leader>sd", ":lua MiniSurround.delete()<CR>", opts)
      map("n", "<leader>sr", ":lua MiniSurround.replace()<CR>", opts)
      map("n", "<leader>sf", ":lua MiniSurround.find()<CR>", opts)
      map("n", "<leader>sF", ":lua MiniSurround.find_left()<CR>", opts)
      map("n", "<leader>sh", ":lua MiniSurround.highlight()<CR>", opts)
      map("n", "<leader>sn", ":lua MiniSurround.update_n_lines()<CR>", opts)
    end,
  },
}