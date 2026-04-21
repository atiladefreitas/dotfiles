return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	cmd = "Telescope",
	keys = {
		{ "<leader><CR>", desc = "Resume previous search" },
		{ "<leader>fb", desc = "Buffers" },
		{ "<leader>fc", desc = "Word at cursor" },
		{ "<leader>ff", desc = "Find files" },
		{ "<leader>fF", desc = "Find files (include hidden)" },
		{ "<leader>fi", desc = "Find images" },
		{ "<leader>fh", desc = "Help Tags" },
		{ "<leader>fk", desc = "Keymaps" },
		{ "<leader>ft", desc = "Colorschemes" },
		{ "<leader>fw", desc = "Live Grep" },
		{ "<space>fB", desc = "File Browser" },
		{ "<leader>fW", desc = "Live Grep (include hidden)" },
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

		-- tokyonight-inspired highlight overrides for telescope
		local bg_dark = "#0a0b11"
		local bg = "#0f1019"
		local bg_highlight = "#1a1d29"
		local blue = "#7aa2f7"
		local cyan = "#7dcfff"
		local green = "#9ece6a"
		local fg = "#c0caf5"
		local fg_dark = "#565f89"

		local TelescopeColor = {
			TelescopeMatching = { fg = cyan },
			TelescopeSelection = { fg = fg, bg = bg_highlight, bold = true },
			TelescopeSelectionCaret = { fg = blue, bg = bg_highlight },

			TelescopePromptPrefix = { fg = blue, bg = bg_dark },
			TelescopePromptNormal = { bg = bg_dark },
			TelescopePromptBorder = { bg = bg_dark, fg = bg_dark },
			TelescopePromptTitle = { bg = blue, fg = bg_dark, bold = true },
			TelescopePromptCounter = { fg = fg_dark },

			TelescopeResultsNormal = { bg = bg },
			TelescopeResultsBorder = { bg = bg, fg = bg },
			TelescopeResultsTitle = { fg = bg },

			TelescopePreviewNormal = { bg = bg_highlight },
			TelescopePreviewBorder = { bg = bg_highlight, fg = bg_highlight },
			TelescopePreviewTitle = { bg = green, fg = bg_dark, bold = true },
		}
		for hl, col in pairs(TelescopeColor) do
			vim.api.nvim_set_hl(0, hl, col)
		end

		-- image preview via image.nvim
		local previewers = require("telescope.previewers")
		local from_entry = require("telescope.from_entry")
		local last_image = nil
		local debounce_timer = nil

		local image_previewer = previewers.new_buffer_previewer({
			title = "Image Preview",
			get_buffer_by_name = function(_, entry)
				return from_entry.path(entry, false, false)
			end,
			define_preview = function(self, entry)
				local filepath = from_entry.path(entry, true, false)
				if not filepath or filepath == "" then return end

				-- clear previous image
				if last_image then
					pcall(function() last_image:clear() end)
					last_image = nil
				end

				-- debounce rapid scrolling
				if debounce_timer then
					debounce_timer:stop()
					debounce_timer:close()
				end

				local bufnr = self.state.bufnr
				local winid = self.state.winid

				debounce_timer = vim.uv.new_timer()
				debounce_timer:start(
					100,
					0,
					vim.schedule_wrap(function()
						debounce_timer:stop()
						debounce_timer:close()
						debounce_timer = nil

						if not vim.api.nvim_buf_is_valid(bufnr) then return end

						-- downscale for faster preview
						local tmp = vim.fn.tempname() .. ".png"
						vim.fn.system({
							"magick", filepath,
							"-resize", "400x400>",
							"-quality", "50",
							tmp,
						})

						local ok, image = pcall(require, "image")
						if not ok then
							vim.fn.delete(tmp)
							return
						end

						local img = image.from_file(tmp, {
							window = winid,
							buffer = bufnr,
							with_virtual_padding = true,
						})
						if img then
							img:render()
							last_image = img
						end
						vim.fn.delete(tmp)
					end)
				)
			end,
		})

		-- image extensions to exclude from find_files
		local image_patterns = {
			"%.png$", "%.jpg$", "%.jpeg$", "%.gif$", "%.webp$",
			"%.avif$", "%.ico$", "%.bmp$", "%.svg$", "%.tiff?$",
		}

		-- code-first sorter: jsx/tsx > js/ts > everything else
		local jsx_exts = { jsx = true, tsx = true }
		local js_exts = { js = true, ts = true }

		local function file_tier(path)
			local ext = (path:match("%.([^./\\]+)$") or ""):lower()
			if jsx_exts[ext] then return 0 end
			if js_exts[ext] then return 1 end
			return 2
		end

		local function make_code_first_sorter(base_fn)
			return function(opts)
				local base = base_fn(opts)
				local original = base.scoring_function
				base.scoring_function = function(self, prompt, line, ...)
					local score = original(self, prompt, line, ...)
					if score == -1 then return score end

					local query = prompt:lower()
					if query ~= "" then
						-- extract only the filename (strip directories and extension)
						local basename = (line:match("[^/\\]+$") or line)
						local name_no_ext = (basename:match("^(.+)%.[^.]+$") or basename):lower()

						if name_no_ext:find(query, 1, true) then
							-- filename contains query: best priority
							return file_tier(line)
						else
							-- query only matches in path, not filename: push down
							return score + 50 + file_tier(line) * 10
						end
					end

					return score + file_tier(line) * 10
				end
				return base
			end
		end

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				sorting_strategy = "descending",

				-- visual polish
				prompt_prefix = "   ",
				selection_caret = "  ",
				entry_prefix = "  ",
				multi_icon = "  ",
				results_title = false,
				borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },

				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "bottom",
						preview_width = 0.55,
						results_width = 0.8,
					},
					vertical = {
						mirror = false,
					},
					width = 0.85,
					height = 0.80,
					preview_cutoff = 120,
				},

				winblend = 0,

				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-s>"] = actions.select_vertical,
					},
				},
			},
			pickers = {
				find_files = {
					file_ignore_patterns = image_patterns,
				},
			},
			extensions = {
				file_browser = {
					path = "%:p:h",
					cwd = vim.uv.cwd(),
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
					dir_icon = "",
					dir_icon_hl = "Default",
					display_stat = { date = false, size = true, mode = false },
					hijack_netrw = false,
					use_fd = true,
					git_status = true,
				},
			},
		})

		telescope.load_extension("themes")
		telescope.load_extension("fzf")

		-- wrap fzf's sorter with our code-first + filename-match boosting
		local conf_values = require("telescope.config").values
		conf_values.file_sorter = make_code_first_sorter(conf_values.file_sorter)

		telescope.load_extension("file_browser")

		-- keymaps
		local keymap = vim.keymap

		keymap.set("n", "<leader><CR>", "<cmd>Telescope resume<cr>", { desc = "Resume previous search" })
		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Word at cursor" })
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
		keymap.set(
			"n",
			"<leader>fF",
			"<cmd>Telescope find_files hidden=true<cr>",
			{ desc = "Find files (include hidden files)" }
		)
		keymap.set("n", "<leader>fi", function()
			require("telescope.builtin").find_files({
				prompt_title = "Find Images",
				find_command = {
					"fd", "--type", "f", "-e", "png", "-e", "jpg", "-e", "jpeg",
					"-e", "gif", "-e", "webp", "-e", "avif", "-e", "ico",
					"-e", "bmp", "-e", "svg", "-e", "tiff", "-e", "tif",
				},
				file_ignore_patterns = {},
				previewer = image_previewer,
			})
		end, { desc = "Find images" })
		keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
		keymap.set("n", "<leader>ft", "<cmd>Telescope colorscheme<cr>", { desc = "Colorschemes" })
		keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
		keymap.set("n", "<space>fB", "<cmd>Telescope file_browser<cr>", { desc = "File Browser" })
		keymap.set(
			"n",
			"<leader>fW",
			"<cmd>Telescope live_grep hidden=true<cr>",
			{ desc = "Live Grep (include hidden files)" }
		)
	end,
}
