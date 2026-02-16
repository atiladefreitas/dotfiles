return {
	{
		"nvim-mini/mini.cursorword",
		version = false,
		event = { "BufReadPost", "BufNewFile" },
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
		"nvim-mini/mini.nvim",
		version = false,
		event = { "BufReadPost", "BufNewFile" },
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
		"nvim-mini/mini.pairs",
		version = false,
		event = "InsertEnter",
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
	-- {
	-- 	"nvim-mini/mini.files",
	-- 	version = "*",
	-- 	keys = {
	-- 		{ "<leader>e", function() require("mini.files").open() end, desc = "Open file explorer" },
	-- 	},
	-- 	config = function()
	-- 		local MiniFiles = require("mini.files")
	--
	-- 		local sync = function()
	-- 			MiniFiles.synchronize()
	-- 		end
	--
	-- 		-- Create file or directory (append / for directory)
	-- 		local create = function()
	-- 			local entry = MiniFiles.get_fs_entry()
	-- 			local dir = entry and entry.fs_type == "directory" and entry.path
	-- 				or vim.fn.fnamemodify(entry and entry.path or "", ":h")
	-- 			local name = vim.fn.input("Create: ", dir .. "/")
	-- 			if name == "" or name == dir .. "/" then
	-- 				return
	-- 			end
	-- 			if vim.endswith(name, "/") then
	-- 				vim.fn.mkdir(name, "p")
	-- 			else
	-- 				vim.fn.mkdir(vim.fn.fnamemodify(name, ":h"), "p")
	-- 				vim.fn.writefile({}, name)
	-- 			end
	-- 			sync()
	-- 		end
	--
	-- 		-- Rename entry under cursor
	-- 		local rename = function()
	-- 			local entry = MiniFiles.get_fs_entry()
	-- 			if not entry then
	-- 				return
	-- 			end
	-- 			local new_name = vim.fn.input("Rename: ", entry.path)
	-- 			if new_name == "" or new_name == entry.path then
	-- 				return
	-- 			end
	-- 			vim.fn.rename(entry.path, new_name)
	-- 			sync()
	-- 		end
	--
	-- 		-- Delete entry under cursor and wipe associated buffers
	-- 		local delete = function()
	-- 			local entry = MiniFiles.get_fs_entry()
	-- 			if not entry then
	-- 				return
	-- 			end
	-- 			local confirm = vim.fn.confirm("Delete " .. entry.path .. "?", "&Yes\n&No", 2)
	-- 			if confirm ~= 1 then
	-- 				return
	-- 			end
	-- 			-- Close any buffers matching the deleted path
	-- 			local path = vim.fn.fnamemodify(entry.path, ":p")
	-- 			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
	-- 				if vim.api.nvim_buf_is_loaded(buf) then
	-- 					local buf_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":p")
	-- 					-- Match exact file or any file inside deleted directory
	-- 					if buf_path == path or vim.startswith(buf_path, path) then
	-- 						vim.api.nvim_buf_delete(buf, { force = true })
	-- 					end
	-- 				end
	-- 			end
	-- 			vim.fn.delete(entry.path, "rf")
	-- 			sync()
	-- 		end
	--
	-- 		-- Copy entry under cursor
	-- 		local copy = function()
	-- 			local entry = MiniFiles.get_fs_entry()
	-- 			if not entry then
	-- 				return
	-- 			end
	-- 			local dest = vim.fn.input("Copy to: ", entry.path)
	-- 			if dest == "" or dest == entry.path then
	-- 				return
	-- 			end
	-- 			if entry.fs_type == "directory" then
	-- 				vim.fn.system({ "cp", "-r", entry.path, dest })
	-- 			else
	-- 				vim.fn.system({ "cp", entry.path, dest })
	-- 			end
	-- 			sync()
	-- 		end
	--
	-- 		-- Move entry under cursor
	-- 		local move = function()
	-- 			local entry = MiniFiles.get_fs_entry()
	-- 			if not entry then
	-- 				return
	-- 			end
	-- 			local dest = vim.fn.input("Move to: ", entry.path)
	-- 			if dest == "" or dest == entry.path then
	-- 				return
	-- 			end
	-- 			vim.fn.rename(entry.path, dest)
	-- 			sync()
	-- 		end
	--
	-- 		MiniFiles.setup({
	-- 			content = {
	-- 				filter = nil,
	-- 				highlight = nil,
	-- 				prefix = nil,
	-- 				sort = nil,
	-- 			},
	--
	-- 			mappings = {
	-- 				close = "q",
	-- 				go_in = "l",
	-- 				go_in_plus = "L",
	-- 				go_out = "h",
	-- 				go_out_plus = "H",
	-- 				mark_goto = "'",
	-- 				mark_set = "m",
	-- 				reset = "<BS>",
	-- 				reveal_cwd = "@",
	-- 				show_help = "g?",
	-- 				synchronize = "=",
	-- 				trim_left = "<",
	-- 				trim_right = ">",
	-- 			},
	--
	-- 			options = {
	-- 				permanent_delete = true,
	-- 				use_as_default_explorer = true,
	-- 			},
	--
	-- 			windows = {
	-- 				max_number = math.huge,
	-- 				preview = false,
	-- 				width_focus = 50,
	-- 				width_nofocus = 15,
	-- 				width_preview = 25,
	-- 			},
	-- 		})
	--
	-- 		-- Neo-tree style keybindings inside mini.files buffers
	-- 		vim.api.nvim_create_autocmd("User", {
	-- 			pattern = "MiniFilesBufferCreate",
	-- 			callback = function(args)
	-- 				local buf = args.data.buf_id
	-- 				local opts = { buffer = buf, noremap = true, silent = true }
	--
	-- 				vim.keymap.set("n", "a", create, vim.tbl_extend("force", opts, { desc = "Create file/directory" }))
	-- 				vim.keymap.set("n", "r", rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
	-- 				vim.keymap.set("n", "d", delete, vim.tbl_extend("force", opts, { desc = "Delete" }))
	-- 				vim.keymap.set("n", "c", copy, vim.tbl_extend("force", opts, { desc = "Copy" }))
	-- 				vim.keymap.set("n", "x", move, vim.tbl_extend("force", opts, { desc = "Cut/Move" }))
	-- 			end,
	-- 		})
	--
	-- 		-- Auto-close mini.files when opening a file
	-- 		vim.api.nvim_create_autocmd("User", {
	-- 			pattern = "MiniFilesActionOpen",
	-- 			callback = function()
	-- 				MiniFiles.close()
	-- 			end,
	-- 		})
	-- 	end,
	-- },

	-- {
	-- 	"nvim-mini/mini.statusline",
	-- 	version = "*",
	-- 	config = function()
	-- 		require("mini.statusline").setup({
	-- 			content = {
	-- 				-- Content for active window
	-- 				active = nil,
	-- 				-- Content for inactive window(s)
	-- 				inactive = nil,
	-- 			},
	--
	-- 			-- Whether to use icons by default
	-- 			use_icons = true,
	--
	-- 			-- Whether to set Vim's settings for statusline (make it always shown)
	-- 			set_vim_settings = true,
	-- 		})
	-- 	end,
	-- },

	{
		"nvim-mini/mini.surround",
		version = false,
		keys = {
			{ "<leader>sa", mode = { "n", "x" }, desc = "Add surround" },
			{ "<leader>sd", desc = "Delete surround" },
			{ "<leader>sr", desc = "Replace surround" },
			{ "<leader>sf", desc = "Find surround" },
			{ "<leader>sF", desc = "Find surround left" },
			{ "<leader>sh", desc = "Highlight surround" },
			{ "<leader>sn", desc = "Update n lines" },
		},
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
