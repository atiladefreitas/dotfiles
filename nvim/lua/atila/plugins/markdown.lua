return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "md", "Avante" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      render_modes = { "n", "c", "t" },
      anti_conceal = { enabled = true },
      max_file_size = 10.0,
      debounce = 100,

      -- Headings with gradient colors and icons
      heading = {
        enabled = true,
        sign = true,
        position = "overlay",
        icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
        signs = { "󰫎 " },
        width = "full",
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = false,
        border_virtual = false,
        border_prefix = false,
        above = "▄",
        below = "▀",
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
        foregrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },

      -- Beautiful code blocks
      code = {
        enabled = true,
        sign = true,
        style = "full",
        position = "left",
        language_pad = 0,
        language_name = true,
        disable_background = { "diff" },
        width = "full",
        left_margin = 0,
        left_pad = 2,
        right_pad = 2,
        min_width = 45,
        border = "thin",
        above = "▄",
        below = "▀",
        highlight = "RenderMarkdownCode",
        highlight_inline = "RenderMarkdownCodeInline",
        highlight_language = nil,
      },

      -- Dash/horizontal rule
      dash = {
        enabled = true,
        icon = "─",
        width = "full",
        highlight = "RenderMarkdownDash",
      },

      -- Bullet points with nice icons
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
        ordered_icons = function(ctx)
          local value = vim.trim(ctx.value or "")
          local num = tonumber(value:sub(1, #value - 1))
          local value_index = num and num > 1 and num or ctx.index
          return string.format("%d.", value_index)
        end,
        left_pad = 0,
        right_pad = 1,
        highlight = "RenderMarkdownBullet",
      },

      -- Checkboxes with multiple states
      checkbox = {
        enabled = true,
        position = "inline",
        unchecked = {
          icon = "󰄱 ",
          highlight = "RenderMarkdownUnchecked",
          scope_highlight = nil,
        },
        checked = {
          icon = "󰄵 ",
          highlight = "RenderMarkdownChecked",
          scope_highlight = "@markup.strikethrough",
        },
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
          important = { raw = "[!]", rendered = " ", highlight = "DiagnosticError" },
          question = { raw = "[?]", rendered = " ", highlight = "DiagnosticWarn" },
          star = { raw = "[*]", rendered = "󰓎 ", highlight = "DiagnosticHint" },
        },
      },

      -- Quote/blockquote styling
      quote = {
        enabled = true,
        icon = "▋",
        repeat_linebreak = false,
        highlight = "RenderMarkdownQuote",
      },

      -- Pipe tables - heavy borders
      pipe_table = {
        enabled = true,
        preset = "heavy",
        style = "full",
        cell = "padded",
        padding = 1,
        min_width = 0,
        border = {
          "┏", "━", "┓", "┳",
          "┣", "━", "┗", "┻",
          "┛", "┃", "━", "1",
          "┃", "┃",
        },
        alignment_indicator = "━",
        head = "RenderMarkdownTableHead",
        row = "RenderMarkdownTableRow",
        filler = "RenderMarkdownTableFill",
      },

      -- Callouts (GitHub-style alerts)
      callout = {
        note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
        tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
        important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
        warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
        caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
        abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
        summary = { raw = "[!SUMMARY]", rendered = "󰨸 Summary", highlight = "RenderMarkdownInfo" },
        tldr = { raw = "[!TLDR]", rendered = "󰨸 TL;DR", highlight = "RenderMarkdownInfo" },
        info = { raw = "[!INFO]", rendered = "󰋽 Info", highlight = "RenderMarkdownInfo" },
        todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo" },
        hint = { raw = "[!HINT]", rendered = "󰌶 Hint", highlight = "RenderMarkdownSuccess" },
        success = { raw = "[!SUCCESS]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
        check = { raw = "[!CHECK]", rendered = "󰄬 Check", highlight = "RenderMarkdownSuccess" },
        done = { raw = "[!DONE]", rendered = "󰄬 Done", highlight = "RenderMarkdownSuccess" },
        question = { raw = "[!QUESTION]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
        help = { raw = "[!HELP]", rendered = "󰘥 Help", highlight = "RenderMarkdownWarn" },
        faq = { raw = "[!FAQ]", rendered = "󰘥 FAQ", highlight = "RenderMarkdownWarn" },
        attention = { raw = "[!ATTENTION]", rendered = "󰀪 Attention", highlight = "RenderMarkdownWarn" },
        failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
        fail = { raw = "[!FAIL]", rendered = "󰅖 Fail", highlight = "RenderMarkdownError" },
        missing = { raw = "[!MISSING]", rendered = "󰅖 Missing", highlight = "RenderMarkdownError" },
        danger = { raw = "[!DANGER]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
        error = { raw = "[!ERROR]", rendered = "󱐌 Error", highlight = "RenderMarkdownError" },
        bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
        example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
        quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
        cite = { raw = "[!CITE]", rendered = "󱆨 Cite", highlight = "RenderMarkdownQuote" },
      },

      -- Links
      link = {
        enabled = true,
        footnote = {
          superscript = true,
          prefix = "",
          suffix = "",
        },
        image = "󰥶 ",
        email = "󰀓 ",
        hyperlink = "󰌹 ",
        highlight = "RenderMarkdownLink",
        wiki = { icon = "󱗖 ", highlight = "RenderMarkdownWikiLink" },
        custom = {
          web = { pattern = "^http", icon = "󰖟 " },
          github = { pattern = "github%.com", icon = " " },
          youtube = { pattern = "youtube%.com", icon = "󰗃 " },
          discord = { pattern = "discord%.com", icon = "󰙯 " },
          reddit = { pattern = "reddit%.com", icon = " " },
          stackoverflow = { pattern = "stackoverflow%.com", icon = " " },
        },
      },

      -- Sign column
      sign = {
        enabled = true,
        highlight = "RenderMarkdownSign",
      },

      -- Indent guide
      indent = {
        enabled = false,
        per_level = 2,
        skip_level = 1,
        skip_heading = false,
      },

      -- Window options when rendering
      win_options = {
        conceallevel = { default = vim.o.conceallevel, rendered = 3 },
        concealcursor = { default = vim.o.concealcursor, rendered = "" },
      },

      -- Overrides for specific filetypes
      overrides = {
        buftype = {
          nofile = { render_modes = { "n", "c", "t", "i" } },
        },
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      -- Custom highlight groups for a cohesive look
      local colors = {
        h1 = "#f38ba8", -- Pink/Red
        h2 = "#fab387", -- Peach/Orange
        h3 = "#f9e2af", -- Yellow
        h4 = "#a6e3a1", -- Green
        h5 = "#89dceb", -- Teal
        h6 = "#b4befe", -- Lavender
        code_bg = "#1e1e2e",
        quote = "#6c7086",
      }

      -- Heading colors (gradient effect)
      vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = colors.h1, bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH2", { fg = colors.h2, bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH3", { fg = colors.h3, bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = colors.h4, bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH5", { fg = colors.h5, bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH6", { fg = colors.h6, bold = true })

      -- Heading backgrounds (subtle)
      vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "#2a2030" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "#2a2520" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "#2a2820" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = "#202a20" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = "#202a2a" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = "#25202a" })

      -- Code blocks
      vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#181825" })
      vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { bg = "#313244", fg = "#f5c2e7" })

      -- Checkboxes
      vim.api.nvim_set_hl(0, "RenderMarkdownUnchecked", { fg = "#6c7086" })
      vim.api.nvim_set_hl(0, "RenderMarkdownChecked", { fg = "#a6e3a1" })
      vim.api.nvim_set_hl(0, "RenderMarkdownTodo", { fg = "#f9e2af" })

      -- Callouts
      vim.api.nvim_set_hl(0, "RenderMarkdownInfo", { fg = "#89b4fa" })
      vim.api.nvim_set_hl(0, "RenderMarkdownSuccess", { fg = "#a6e3a1" })
      vim.api.nvim_set_hl(0, "RenderMarkdownHint", { fg = "#cba6f7" })
      vim.api.nvim_set_hl(0, "RenderMarkdownWarn", { fg = "#f9e2af" })
      vim.api.nvim_set_hl(0, "RenderMarkdownError", { fg = "#f38ba8" })
      vim.api.nvim_set_hl(0, "RenderMarkdownQuote", { fg = colors.quote, italic = true })

      -- Links
      vim.api.nvim_set_hl(0, "RenderMarkdownLink", { fg = "#89b4fa", underline = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownWikiLink", { fg = "#cba6f7", underline = true })

      -- Tables - visible with good contrast
      vim.api.nvim_set_hl(0, "RenderMarkdownTableHead", { fg = "#cba6f7", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownTableRow", { fg = "#bac2de" })
      vim.api.nvim_set_hl(0, "RenderMarkdownTableFill", { fg = "#585b70" })

      -- Misc
      vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = "#89dceb" })
      vim.api.nvim_set_hl(0, "RenderMarkdownDash", { fg = "#45475a" })
    end,
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = { "markdown", "md" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/Documents/notes",
        },
      },
      notes_subdir = "notes",
      log_level = vim.log.levels.INFO,

      daily_notes = {
        folder = "journal/03-Mar",
        date_format = "%d-%m-%Y",
        alias_format = "%B %-d, %Y",
        default_tags = { "daily-notes" },
        template = nil,
      },

      completion = {
        nvim_cmp = false,
        min_chars = 2,
      },

      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },

      new_notes_location = "notes_subdir",
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

      note_path_func = function(spec)
        local is_daily = string.match(spec.title or "", "%d%d%-%d%d%-%d%d%d%d")

        if is_daily then
          local month_names = {
            "01-Jan",
            "02-Feb",
            "03-Mar",
            "04-Apr",
            "05-May",
            "06-Jun",
            "07-Jul",
            "08-Aug",
            "09-Sep",
            "10-Oct",
            "11-Nov",
            "12-Dec",
          }
          local current_month = tonumber(os.date("%m"))
          local month_folder = month_names[current_month]

          local path = spec.dir / "journal" / month_folder / spec.id
          return path:with_suffix(".md")
        end

        -- For non-daily notes, use the default behavior
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end,

      wiki_link_func = function(opts)
        return require("obsidian.util").wiki_link_id_prefix(opts)
      end,

      markdown_link_func = function(opts)
        return require("obsidian.util").markdown_link(opts)
      end,

      preferred_link_style = "wiki",

      disable_frontmatter = false,

      note_frontmatter_func = function(note)
        if note.title then
          note:add_alias(note.title)
        end

        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,

      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {},
      },

      follow_url_func = function(url)
        vim.fn.jobstart({ "open", url }) -- Mac OS
      end,

      follow_img_func = function(img)
        vim.fn.jobstart({ "qlmanage", "-p", img }) -- Mac OS quick look preview
      end,

      use_advanced_uri = false,

      open_app_foreground = false,

      picker = {
        name = "telescope.nvim",
        note_mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
        tag_mappings = {
          tag_note = "<C-x>",
          insert_tag = "<C-l>",
        },
      },

      sort_by = "modified",
      sort_reversed = true,
      search_max_lines = 1000,
      open_notes_in = "current",

      callbacks = {
        post_setup = function(client) end,
        enter_note = function(client, note) end,
        leave_note = function(client, note) end,
        pre_write_note = function(client, note) end,
        post_set_workspace = function(client, workspace) end,
      },
      ui = {
        enable = true,          -- set to false to disable all additional syntax features
        update_debounce = 200,  -- update delay after a text change (in milliseconds)
        max_file_length = 5000, -- disable UI features for files with more than this many lines
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          ["!"] = { char = "", hl_group = "ObsidianImportant" },
        },
        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        -- Replace the above with this if you don't have a patched font:
        -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        block_ids = { hl_group = "ObsidianBlockID" },
        hl_groups = {
          ObsidianTodo = { bold = true, fg = "#f78c6c" },
          ObsidianDone = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianImportant = { bold = true, fg = "#d73128" },
          ObsidianBullet = { bold = true, fg = "#89ddff" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianBlockID = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
        },
      },
      attachments = {
        img_folder = "assets/imgs", -- This is the default

        img_name_func = function()
          return string.format("%s-", os.time())
        end,

        img_text_func = function(client, path)
          path = client:vault_relative_path(path) or path
          return string.format("![%s](%s)", path.name, path)
        end,
      },
    },
  },
}
