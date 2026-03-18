return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		local markdown_folder = vim.fn.expand("~/Documents/notes")
		local excluded_subfolder = vim.fn.expand("~/Documents/notes/articles")

		-- HTML tag order for prose-* class sorting
		local prose_tag_order = {
			h1 = 1,
			h2 = 2,
			h3 = 3,
			h4 = 4,
			h5 = 5,
			h6 = 6,
			p = 7,
			a = 8,
			blockquote = 9,
			figure = 10,
			figcaption = 11,
			strong = 12,
			em = 13,
			kbd = 14,
			code = 15,
			pre = 16,
			ol = 17,
			ul = 18,
			li = 19,
			img = 20,
			video = 21,
			hr = 22,
			table = 23,
			thead = 24,
			tbody = 25,
			tr = 26,
			th = 27,
			td = 28,
			lead = 29,
			headings = 30,
		}

		-- Extract the prose tag from a class like "prose-h1:text-red" or "lg:prose-p:font-bold"
		local function get_prose_tag(class)
			return class:match("prose%-([%w]+):")
		end

		-- Sort classes within a class string, grouping prose-* classes by tag after regular classes
		local function sort_prose_classes(class_str)
			local classes = {}
			for class in class_str:gmatch("%S+") do
				table.insert(classes, class)
			end

			local regular = {}
			local prose_groups = {}

			for _, class in ipairs(classes) do
				local tag = get_prose_tag(class)
				if tag and prose_tag_order[tag] then
					if not prose_groups[tag] then
						prose_groups[tag] = {}
					end
					table.insert(prose_groups[tag], class)
				else
					table.insert(regular, class)
				end
			end

			-- Collect prose tags and sort by HTML document order
			local sorted_tags = {}
			for tag in pairs(prose_groups) do
				table.insert(sorted_tags, tag)
			end
			table.sort(sorted_tags, function(a, b)
				return (prose_tag_order[a] or 999) < (prose_tag_order[b] or 999)
			end)

			-- Build result: regular classes first, then prose classes grouped by tag
			local result = {}
			for _, class in ipairs(regular) do
				table.insert(result, class)
			end
			for _, tag in ipairs(sorted_tags) do
				for _, class in ipairs(prose_groups[tag]) do
					table.insert(result, class)
				end
			end

			return table.concat(result, " ")
		end

		conform.setup({
			formatters_by_ft = {
				javascript = { "rustywind", "prose_sort", "biome", "prettier" },
				typescript = { "rustywind", "prose_sort", "biome", "prettier" },
				javascriptreact = { "rustywind", "prose_sort", "biome", "prettier" },
				typescriptreact = { "rustywind", "prose_sort", "biome", "prettier" },
				svelte = { "rustywind", "prose_sort", "prettier" },
				vue = { "rustywind", "prose_sort", "prettier" },
				markdown = function()
					local current_file = vim.fn.expand("%:p")
					if current_file:find(excluded_subfolder, 1, true) then
						return {}
					elseif current_file:find(markdown_folder, 1, true) then
						return { "prettier" }
					else
						return {}
					end
				end,
				css = { "prettier" },
				scss = { "prettier" },
				html = { "djlint", "rustywind", "prose_sort", "prettier" },
				jinja = { "djlint" },
				jinja2 = { "djlint" },
				json = { "biome", "prettier" },
				jsonc = { "biome", "prettier" },
				yaml = { "prettier" },
				yml = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
			},
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				}
			end,
			formatters = {
				djlint = {
					prepend_args = {
						"--profile=jinja",
						"--indent=2",
						"--max-line-length=120",
						"--max-attribute-length=120",
					},
				},
				rustywind = {},
				prose_sort = {
					format = function(_, _, lines, callback)
						local out_lines = {}
						-- Match quoted class strings and sort prose classes within them
						for _, line in ipairs(lines) do
							local new_line = line:gsub('(["\'])(.-)%1', function(quote, content)
								-- Only process if the string contains prose- classes
								if content:match("prose%-") then
									return quote .. sort_prose_classes(content) .. quote
								end
								return quote .. content .. quote
							end)
							-- Also handle template literal / backtick strings
							new_line = new_line:gsub("`(.-)`", function(content)
								if content:match("prose%-") then
									return "`" .. sort_prose_classes(content) .. "`"
								end
								return "`" .. content .. "`"
							end)
							table.insert(out_lines, new_line)
						end
						callback(nil, out_lines)
					end,
				},
				biome = {
					condition = function(self, ctx)
						-- Only use biome when the project has a biome config
						return vim.fs.find({
							"biome.json",
							"biome.jsonc",
						}, { path = ctx.filename, upward = true })[1] ~= nil
					end,
				},
				prettier = {
					condition = function(self, ctx)
						-- Use prettier as fallback when project has no biome config
						return vim.fs.find({
							"biome.json",
							"biome.jsonc",
						}, { path = ctx.filename, upward = true })[1] == nil
					end,
				},
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
