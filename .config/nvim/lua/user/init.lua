require("user.mappings")
require("user.autorun")
require("user.settings")

-- vim.api.nvim_create_autocmd("FileType", {
-- 	callback = function(args)
-- 		local lang = vim.treesitter.language.get_lang(args.match)
-- 		if lang then
-- 			vim.treesitter.start(args.buf, lang)
-- 		end
-- 	end,
-- })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python" },
	callback = function()
		vim.treesitter.start()
	end,
})
