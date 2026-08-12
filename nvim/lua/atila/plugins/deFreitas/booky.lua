return {
    -- bookmark manager
    {
        dir = "~/Documents/projects/booky.nvim",
        cmd = { "BookyAdd", "BookyRemove", "BookyToggle", "BookyAddLine", "BookyList", "BookyGlobal" },
        keys = {
            { "<leader>ba", "<cmd>BookyToggle<cr>", desc = "Booky: toggle bookmark for this file" },
            { "<leader>bl", "<cmd>BookyAddLine<cr>", desc = "Booky: bookmark this line" },
            { "<leader>bb", "<cmd>BookyList<cr>", desc = "Booky: project bookmarks" },
            { "<leader>bg", "<cmd>BookyGlobal<cr>", desc = "Booky: global bookmarks" },
        },
        config = function()
            require("booky").setup({})
        end,
    },
}
