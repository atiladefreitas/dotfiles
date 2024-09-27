return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- Configure linters for different file types
		lint.linters_by_ft = {
			javascript = { "biome" },
			typescript = { "biome" },
			javascriptreact = { "biome" },
			typescriptreact = { "biome" },
			svelte = { "biome" },
			python = { "pylint" },
			lua = { "luacheck" },
			css = { "stylelint" },
			html = { "htmlhint" },
		}

		-- Set up an autogroup for linting
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		-- Create autocommands for linting
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		-- Keybinding to trigger linting for the current file
		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })

		-- Keybinding to toggle linting messages
		vim.keymap.set("n", "<leader>lt", function()
			lint.toggle_lint()
		end, { desc = "Toggle linting messages" })

		-- Configure Biome linter
		lint.linters.biome = {
			cmd = "biome",
			args = {
				"check",
				"--stdin-filepath",
				vim.api.nvim_buf_get_name(0),
				"--json",
			},
			stdin = true,
			stream = "stdout",
			ignore_exitcode = true,
			parser = function(output, bufnr)
				local results = {}
				local decoded = vim.fn.json_decode(output)
				if not decoded then
					return results
				end

				for _, diag in ipairs(decoded.diagnostics) do
					local severity = vim.diagnostic.severity.ERROR
					if diag.severity == "warning" then
						severity = vim.diagnostic.severity.WARN
					elseif diag.severity == "info" then
						severity = vim.diagnostic.severity.INFO
					elseif diag.severity == "hint" then
						severity = vim.diagnostic.severity.HINT
					end

					table.insert(results, {
						lnum = diag.range.start.line,
						col = diag.range.start.character,
						end_lnum = diag.range["end"].line,
						end_col = diag.range["end"].character,
						severity = severity,
						source = "biome",
						message = diag.message,
						code = diag.code,
					})
				end

				return results
			end,
		}

		-- Add any additional configuration for specific linters as needed
	end,
}
