return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "md", "Avante" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      render_modes = { "n", "c", "t" },
      anti_conceal = { enabled = true },
      max_file_size = 10.0,
      debounce = 100,

      -- Editorial heading hierarchy
      -- H1/H2: block-style with subtle background
      -- H3+: lighter touch, descending refinement
      heading = {
        enabled = true,
        sign = false,
        position = "overlay",
        icons = { "█  ", "▌  ", "›  ", "·  ", "·  ", "·  " },
        width = "block",
        left_margin = 0,
        left_pad = 1,
        right_pad = 4,
        min_width = 60,
        border = false,
        border_virtual = false,
        border_prefix = false,
        above = "▁",
        below = "▔",
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

      -- Generous, centered-feeling code blocks
      code = {
        enabled = true,
        sign = false,
        style = "full",
        position = "left",
        language_pad = 2,
        language_name = true,
        language_icon = true,
        disable_background = { "diff" },
        width = "block",
        left_margin = 2,
        left_pad = 3,
        right_pad = 3,
        min_width = 70,
        border = "thick",
        above = "▁",
        below = "▔",
        highlight = "RenderMarkdownCode",
        highlight_inline = "RenderMarkdownCodeInline",
        highlight_language = "RenderMarkdownCodeLanguage",
        inline_pad = 1,
      },

      -- Soft horizontal rule, like a manuscript section break
      dash = {
        enabled = true,
        icon = "─",
        width = 80,
        left_margin = 0,
        highlight = "RenderMarkdownDash",
      },

      -- Refined bullets: filled circle, open circle, diamond, dot
      bullet = {
        enabled = true,
        icons = { "•", "◦", "▸", "·" },
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

      -- Refined checkboxes
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

      -- Magazine-style pull-quote with thick magenta rule
      quote = {
        enabled = true,
        icon = "▎",
        repeat_linebreak = true,
        highlight = "RenderMarkdownQuote",
      },

      -- Refined tables: rounded preset, calmer borders
      pipe_table = {
        enabled = true,
        preset = "round",
        style = "full",
        cell = "padded",
        padding = 1,
        min_width = 0,
        alignment_indicator = "─",
        head = "RenderMarkdownTableHead",
        row = "RenderMarkdownTableRow",
        filler = "RenderMarkdownTableFill",
      },

      -- Editorial callouts: rounded labels with breathing room
      callout = {
        note = { raw = "[!NOTE]", rendered = "  Note", highlight = "RenderMarkdownInfo" },
        tip = { raw = "[!TIP]", rendered = "  Tip", highlight = "RenderMarkdownSuccess" },
        important = { raw = "[!IMPORTANT]", rendered = "  Important", highlight = "RenderMarkdownHint" },
        warning = { raw = "[!WARNING]", rendered = "  Warning", highlight = "RenderMarkdownWarn" },
        caution = { raw = "[!CAUTION]", rendered = "  Caution", highlight = "RenderMarkdownError" },
        abstract = { raw = "[!ABSTRACT]", rendered = "  Abstract", highlight = "RenderMarkdownInfo" },
        summary = { raw = "[!SUMMARY]", rendered = "  Summary", highlight = "RenderMarkdownInfo" },
        tldr = { raw = "[!TLDR]", rendered = "  TL;DR", highlight = "RenderMarkdownInfo" },
        info = { raw = "[!INFO]", rendered = "  Info", highlight = "RenderMarkdownInfo" },
        todo = { raw = "[!TODO]", rendered = "  Todo", highlight = "RenderMarkdownInfo" },
        hint = { raw = "[!HINT]", rendered = "  Hint", highlight = "RenderMarkdownSuccess" },
        success = { raw = "[!SUCCESS]", rendered = "  Success", highlight = "RenderMarkdownSuccess" },
        check = { raw = "[!CHECK]", rendered = "  Check", highlight = "RenderMarkdownSuccess" },
        done = { raw = "[!DONE]", rendered = "  Done", highlight = "RenderMarkdownSuccess" },
        question = { raw = "[!QUESTION]", rendered = "  Question", highlight = "RenderMarkdownWarn" },
        help = { raw = "[!HELP]", rendered = "  Help", highlight = "RenderMarkdownWarn" },
        faq = { raw = "[!FAQ]", rendered = "  FAQ", highlight = "RenderMarkdownWarn" },
        attention = { raw = "[!ATTENTION]", rendered = "  Attention", highlight = "RenderMarkdownWarn" },
        failure = { raw = "[!FAILURE]", rendered = "  Failure", highlight = "RenderMarkdownError" },
        fail = { raw = "[!FAIL]", rendered = "  Fail", highlight = "RenderMarkdownError" },
        missing = { raw = "[!MISSING]", rendered = "  Missing", highlight = "RenderMarkdownError" },
        danger = { raw = "[!DANGER]", rendered = "  Danger", highlight = "RenderMarkdownError" },
        error = { raw = "[!ERROR]", rendered = "  Error", highlight = "RenderMarkdownError" },
        bug = { raw = "[!BUG]", rendered = "  Bug", highlight = "RenderMarkdownError" },
        example = { raw = "[!EXAMPLE]", rendered = "  Example", highlight = "RenderMarkdownHint" },
        quote = { raw = "[!QUOTE]", rendered = "  Quote", highlight = "RenderMarkdownQuote" },
        cite = { raw = "[!CITE]", rendered = "  Cite", highlight = "RenderMarkdownQuote" },
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

      -- Quiet sign column
      sign = {
        enabled = false,
        highlight = "RenderMarkdownSign",
      },

      -- Indent guide off — cleaner long-form reading
      indent = {
        enabled = false,
        per_level = 2,
        skip_level = 1,
        skip_heading = false,
      },

      -- Window options when rendering
      win_options = {
        conceallevel = { default = vim.o.conceallevel, rendered = 2 },
        concealcursor = { default = vim.o.concealcursor, rendered = "" },
      },

      -- Disable yaml frontmatter rendering so dashes stay visible
      yaml = {
        enabled = false,
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

      -- ────────────────────────────────────────────────────────────────
      --  Editorial palette tuned for Tokyo Night (bg #090a12)
      -- ────────────────────────────────────────────────────────────────
      local p = {
        -- Foreground tones (warm-paper hierarchy)
        h1 = "#c0caf5", -- bright vellum, the title
        h2 = "#bb9af7", -- magenta, section
        h3 = "#7aa2f7", -- blue, subsection
        h4 = "#7dcfff", -- cyan
        h5 = "#9ece6a", -- soft green
        h6 = "#e0af68", -- amber

        -- Heading backgrounds (very subtle, layered tints)
        h1_bg = "#13141f",
        h2_bg = "#11121c",
        h3_bg = "#0f1019",
        h4_bg = "#0d0e16",
        h5_bg = "#0c0d14",
        h6_bg = "#0b0c12",

        -- Surfaces
        code_bg = "#0c0e18",
        code_inline_bg = "#1a1b2e",
        code_inline_fg = "#7dcfff", -- cyan
        code_lang_fg = "#7dcfff",

        -- Type
        body = "#a9b1d6",
        muted = "#565f89",
        rule = "#1f2335",

        -- Accents
        link = "#7aa2f7",
        wiki = "#bb9af7",
        bullet = "#7dcfff",
        quote = "#bb9af7",
        quote_text = "#9aa5ce",
      }

      -- Headings: bold foregrounds, whisper-quiet backgrounds
      vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = p.h1, bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH2", { fg = p.h2, bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH3", { fg = p.h3, bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = p.h4, bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH5", { fg = p.h5, bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH6", { fg = p.h6, bold = true, italic = true })

      vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = p.h1_bg })
      vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = p.h2_bg })
      vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = p.h3_bg })
      vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = p.h4_bg })
      vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = p.h5_bg })
      vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = p.h6_bg })

      -- Heading borders (top/bottom rule under H1, H2)
      vim.api.nvim_set_hl(0, "RenderMarkdownH1Border", { fg = p.h2, bg = p.h1_bg })
      vim.api.nvim_set_hl(0, "RenderMarkdownH2Border", { fg = p.muted, bg = p.h2_bg })

      -- Code blocks: deep, refined, with cyan language tag
      vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = p.code_bg })
      vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { bg = p.code_inline_bg, fg = p.code_inline_fg })
      vim.api.nvim_set_hl(0, "RenderMarkdownCodeLanguage", { fg = p.code_lang_fg, bg = p.code_bg, italic = true })

      -- Checkboxes
      vim.api.nvim_set_hl(0, "RenderMarkdownUnchecked", { fg = p.muted })
      vim.api.nvim_set_hl(0, "RenderMarkdownChecked", { fg = "#9ece6a" })
      vim.api.nvim_set_hl(0, "RenderMarkdownTodo", { fg = "#e0af68" })

      -- Callouts: refined Tokyo Night accents
      vim.api.nvim_set_hl(0, "RenderMarkdownInfo", { fg = "#7aa2f7", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownSuccess", { fg = "#9ece6a", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownHint", { fg = "#bb9af7", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownWarn", { fg = "#e0af68", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownError", { fg = "#f7768e", bold = true })

      -- Quote: magenta rule + softly muted italic body
      vim.api.nvim_set_hl(0, "RenderMarkdownQuote", { fg = p.quote, italic = true })
      vim.api.nvim_set_hl(0, "@markup.quote.markdown", { fg = p.quote_text, italic = true })

      -- Links
      vim.api.nvim_set_hl(0, "RenderMarkdownLink", { fg = p.link, underline = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownWikiLink", { fg = p.wiki, underline = true })

      -- Tables: subtle, readable
      vim.api.nvim_set_hl(0, "RenderMarkdownTableHead", { fg = p.h2, bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownTableRow", { fg = p.body })
      vim.api.nvim_set_hl(0, "RenderMarkdownTableFill", { fg = p.rule })

      -- Misc
      vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = p.bullet, bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownDash", { fg = p.muted })
      vim.api.nvim_set_hl(0, "RenderMarkdownSign", { fg = p.muted })

      -- ────────────────────────────────────────────────────────────────
      --  Treesitter polish: italics, bold, strikethrough, emphasis
      --  These make body prose feel like a magazine
      -- ────────────────────────────────────────────────────────────────
      vim.api.nvim_set_hl(0, "@markup.strong.markdown_inline", { fg = "#c0caf5", bold = true })
      vim.api.nvim_set_hl(0, "@markup.italic.markdown_inline", { fg = "#bb9af7", italic = true })
      vim.api.nvim_set_hl(0, "@markup.strikethrough.markdown_inline", { fg = p.muted, strikethrough = true })
      vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { fg = p.code_inline_fg, bg = p.code_inline_bg })
      vim.api.nvim_set_hl(0, "@markup.link.label.markdown_inline", { fg = p.link, italic = true })
      vim.api.nvim_set_hl(0, "@markup.link.url.markdown_inline", { fg = p.muted, italic = true, underline = true })

      -- ────────────────────────────────────────────────────────────────
      --  Reading-mode ergonomics for markdown buffers
      --  Soft wrap at 80 columns, breathing line height
      --
      --  Neovim has no native "soft wrap at column N" — `linebreak` only
      --  wraps at the window edge. Trick: pad the window with foldcolumn
      --  so the *effective* text area is 80 columns, then `linebreak`
      --  wraps there naturally. We recompute padding on resize.
      -- ────────────────────────────────────────────────────────────────
      local TARGET_WIDTH = 80

      local function apply_reading_padding(win)
        if not win or not vim.api.nvim_win_is_valid(win) then return end
        local buf = vim.api.nvim_win_get_buf(win)
        if not vim.api.nvim_buf_is_valid(buf) then return end
        local ft = vim.bo[buf].filetype
        if ft ~= "markdown" then return end
        -- Skip floating windows and special buffers
        local cfg = vim.api.nvim_win_get_config(win)
        if cfg.relative and cfg.relative ~= "" then return end
        if vim.bo[buf].buftype ~= "" then return end

        local win_width = vim.api.nvim_win_get_width(win)
        local gutter = 6 -- sign column + small breathing room
        local available = win_width - gutter
        local padding = math.max(0, math.floor((available - TARGET_WIDTH) / 2))
        padding = math.min(padding, 9) -- foldcolumn maxes at 9
        local target = tostring(padding)
        -- Only update if changed (avoids re-render storm)
        if vim.wo[win].foldcolumn ~= target then
          vim.wo[win].foldcolumn = target
        end
      end

      -- Make the foldcolumn invisible (it's just padding)
      vim.api.nvim_set_hl(0, "FoldColumn", { fg = "NONE", bg = "NONE" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(ev)
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          vim.opt_local.breakindent = true
          vim.opt_local.showbreak = "  ↳ "
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = ""
          vim.opt_local.spell = false
          vim.opt_local.cursorline = false
          vim.opt_local.signcolumn = "yes:1"
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.scrolloff = 8
          vim.opt_local.textwidth = 0
          vim.opt_local.formatoptions:remove("t")
          vim.opt_local.formatoptions:remove("c")
          vim.opt_local.colorcolumn = ""
          -- Defer padding so render-markdown can register the buffer first
          vim.schedule(function()
            apply_reading_padding(vim.api.nvim_get_current_win())
          end)
        end,
      })

      -- Recompute padding only when actually needed, deferred
      vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
        callback = function()
          vim.schedule(function()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              apply_reading_padding(win)
            end
          end)
        end,
      })
    end,
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/Documents/notes-2026",
        },
      },
      notes_subdir = "notes",
      log_level = vim.log.levels.INFO,

      daily_notes = {
        folder = "journal/" .. os.date("%m") .. "-" .. os.date("%b"),
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
        enable = true,      -- set to false to disable all additional syntax features
        update_debounce = 200, -- update delay after a text change (in milliseconds)
        max_file_length = 5000, -- disable UI features for files with more than this many lines
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          ["!"] = { char = "", hl_group = "ObsidianImportant" },
        },
        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        block_ids = { hl_group = "ObsidianBlockID" },
        hl_groups = {
          -- Tokyo Night-tuned Obsidian UI
          ObsidianTodo = { bold = true, fg = "#e0af68" },
          ObsidianDone = { bold = true, fg = "#9ece6a" },
          ObsidianRightArrow = { bold = true, fg = "#7aa2f7" },
          ObsidianTilde = { bold = true, fg = "#bb9af7" },
          ObsidianImportant = { bold = true, fg = "#e0af68" },
          ObsidianBullet = { bold = true, fg = "#7dcfff" },
          ObsidianRefText = { underline = true, fg = "#bb9af7" },
          ObsidianExtLinkIcon = { fg = "#bb9af7" },
          ObsidianTag = { italic = true, fg = "#7dcfff" },
          ObsidianBlockID = { italic = true, fg = "#7dcfff" },
          ObsidianHighlightText = { bg = "#3d2f1f", fg = "#e0af68" },
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
