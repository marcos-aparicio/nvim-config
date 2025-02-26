return {
	{
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			require("mini.ai").setup()
			require("mini.surround").setup()
			require("mini.operators").setup()
			require("mini.jump2d").setup()
		end,
	},
}
--
-- (
--   (first) (second) (third)
-- ) [outside]
-- first second third fourth
