return {
	enabled = true,
	dir = vim.fn.stdpath("config"),
	name = "widgy",
	cmd = "Widgy",
	config = function()
		local function create_widgy_command()
			vim.api.nvim_create_user_command("Widgy", function(opts)
				local start_line = opts.line1
				local end_line = opts.line2
				local buf = vim.api.nvim_get_current_buf()

				local selected_lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)

				vim.ui.input({ prompt = "Widget name: " }, function(input)
					if input == nil or input == "" then
						vim.notify("Widget creation cancelled", vim.log.levels.INFO)
						return
					end

					local widget_name = input:gsub("%s+", "_"):lower()

					local label = input:gsub("(%a)([%w_']*)", function(first, rest)
						return first:upper() .. rest:lower()
					end)

					local widget_lines = {
						string.format(
							"      {%% widget_block rich_text '%s' label='%s', overrideable=True, no_wrapper=false %%}",
							widget_name,
							label
						),
						"      {% widget_attribute 'html' %}",
					}

					for _, line in ipairs(selected_lines) do
						table.insert(widget_lines, line)
					end

					table.insert(widget_lines, "      {% end_widget_attribute %}")
					table.insert(widget_lines, "      {% end_widget_block %}")

					vim.api.nvim_buf_set_lines(buf, start_line - 1, end_line, false, widget_lines)

					vim.notify(
						string.format("Widget created: name='%s', label='%s'", widget_name, label),
						vim.log.levels.INFO
					)
				end)
			end, { range = true })
		end

		create_widgy_command()
	end,
}
