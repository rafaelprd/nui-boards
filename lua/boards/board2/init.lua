local Popup = require("nui.popup")

local M = {}

M.AvailableCommands = { "Command 1 - Command 2" }

function M.BuildBody()
	local body = Popup({ border = "double" })
	local content = { "", "Conteúdo do board2" }
	vim.api.nvim_buf_set_lines(body.bufnr, 0, 1, false, content)
	return body
end

return M
