return {
	"rachartier/tiny-glimmer.nvim",
	event = "VeryLazy",
	config = function()
		require("tiny-glimmer").setup({
			enabled = true,

			-- Disable this if you wants to debug highlighting issues
			disable_warnings = true,

			default_animation = "bounce",
			refresh_interval_ms = 6,

			overwrite = {
				-- Automatically map keys to overwrite operations
				-- If set to false, you will need to call the API functions to trigger the animations
				-- WARN: You should disable this if you have already mapped these keys
				-- 		 or if you want to use the API functions to trigger the animations
				auto_map = true,

				-- For search and paste, you can easily modify the animation to suit your needs
				-- For example you can set a table to default_animation with custom parameters:
				-- default_animation = {
				--     name = "fade",
				--
				--     settings = {
				--         max_duration = 1000,
				--         min_duration = 1000,
				--
				--         from_color = "DiffDelete",
				--         to_color = "Normal",
				--     },
				-- },
				-- settings needs to respect the animation you choose settings
				--
				-- All "mapping" can be set in 2 ways:
				-- 1. A string with the key you want to map
				-- 		  Example:
				-- 			paste_mapping = "p"
				-- 2. A table with the key you want to map and its actions
				-- 		  Example:
				-- 			paste_mapping = {
				-- 				lhs = "p"
				-- 				rhs = "<Plug>(YankyPutAfter)"
				--      }
				search = {
					enabled = false,
					default_animation = "pulse",

					-- Keys to navigate to the next match
					next_mapping = "nzzzv",

					-- Keys to navigate to the previous match
					prev_mapping = "Nzzzv",
				},
				paste = {
					enabled = false,
					default_animation = "reverse_fade",

					-- Keys to paste
					paste_mapping = "p",

					-- Keys to paste above the cursor
					Paste_mapping = "P",
				},
				undo = {
					enabled = false,

					default_animation = {
						name = "fade",

						settings = {
							from_color = "DiffDelete",

							max_duration = 500,
							min_duration = 500,
						},
					},
					undo_mapping = "u",
				},
				redo = {
					enabled = false,

					default_animation = {
						name = "fade",

						settings = {
							from_color = "DiffAdd",

							max_duration = 500,
							min_duration = 500,
						},
					},

					redo_mapping = "<c-r>",
				},
			},

			support = {
				-- Enable support for gbprod/substitute.nvim
				-- You can use it like so:
				-- require("substitute").setup({
				--     on_substitute = require("tiny-glimmer.support.substitute").substitute_cb,
				--     highlight_substituted_text = {
				--         enabled = false,
				--     },
				--})
				substitute = {
					enabled = false,

					-- Can also be a table. Refer to overwrite.search for more information
					default_animation = "fade",
				},
			},

			-- Animations for other operations
			presets = {
				-- Enable animation on cursorline when an event in `on_events` is triggered
				-- Similar to `pulsar.el`
				pulsar = {
					enabled = false,
					on_events = { "CursorMoved", "CmdlineEnter", "WinEnter" },
					default_animation = {
						name = "fade",

						settings = {
							max_duration = 1000,
							min_duration = 1000,

							from_color = "DiffDelete",
							to_color = "Normal",
						},
					},
				},
			},

			-- Only use if you have a transparent background
			-- It will override the highlight group background color for `to_color` in all animations
			transparency_color = nil,
			animations = {
				fade = {
					max_duration = 400,
					min_duration = 300,
					easing = "outQuad",
					chars_for_max_duration = 10,
				},
				reverse_fade = {
					max_duration = 380,
					min_duration = 300,
					easing = "outBack",
					chars_for_max_duration = 10,
				},
				bounce = {
					max_duration = 500,
					min_duration = 400,
					chars_for_max_duration = 20,
					oscillation_count = 1,
				},
				left_to_right = {
					max_duration = 350,
					min_duration = 350,
					min_progress = 0.85,
					chars_for_max_duration = 25,
					lingering_time = 50,
				},
				pulse = {
					max_duration = 600,
					min_duration = 400,
					chars_for_max_duration = 15,
					pulse_count = 2,
					intensity = 1.2,
				},

				-- You can add as many animations as you want
				custom = {
					-- You can also add as many custom options as you want
					-- Only `max_duration` and `chars_for_max_duration` is required
					max_duration = 350,
					chars_for_max_duration = 40,

					color = hl_visual_bg,

					-- Custom effect function
					-- @param self table The effect object
					-- @param progress number The progress of the animation [0, 1]
					--
					-- Should return a color and a progress value
					-- that represents how much of the animation should be drawn
					-- self.settings represents the settings of the animation that you defined above
					effect = function(self, progress)
						return self.settings.color, progress
					end,
				},
			},
			virt_text = {
				priority = 2048,
			},
		})
	end,
}
