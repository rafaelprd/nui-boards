local Popup = require("nui.popup")
local Layout = require("nui.layout")

package.path = package.path .. ';./lua/?.lua'

local board1 = require("boards.board1.init")
local board2 = require("boards.board2.init")
local current_board = 'BOARD1'

local BOARDS = {
  ['BOARD1'] = board1,
  ['BOARD2'] = board2,
}

function BuildHeader()
  local header = Popup({
    enter = false,
    border = "single",
  })
  local content = {
    "Board [1] - Board [2]"
  }
  vim.api.nvim_buf_set_lines(header.bufnr, 0, 1, false, content)
  return header
end

function BuildCommands(content)
  local commands = Popup({
    enter = false,
    border = "single",
  })
  vim.api.nvim_buf_set_lines(commands.bufnr, 0, 1, false, content)
  return commands
end

local layout = Layout(
  {
    position = "50%",
    size = {
      width = 80,
      height = "60%",
    },
  },
  -- dummy
  Layout.Box({
    Layout.Box(Popup({ border = "single" }), { size = "50%" })
  }, { dir = "col" })
)


function UpdateLayout()
  layout:update(Layout.Box({
    Layout.Box(BuildHeader(), { size = "40%" }),
    Layout.Box(BuildCommands(BOARDS[current_board].AvailableCommands), { size = "40%" }),
    Layout.Box(BOARDS[current_board].BuildBody(), { size = "60%" }),
  }, { dir = "col" }))
end

function SetBoard(key)
  current_board = key
  UpdateLayout()
end

UpdateLayout()
layout:mount()

--
--
--
--
--
-- TEST/DEBUG AREA
--
function FecharLayout()
  layout:unmount()
end

vim.api.nvim_set_keymap("n", "<Esc>", ":lua FecharLayout()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "1", ":lua SetBoard('BOARD1')<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "2", ":lua SetBoard('BOARD2')<CR>", { noremap = true })
