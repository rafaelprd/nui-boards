local Popup = require("nui.popup")
local Layout = require("nui.layout")

package.path = package.path .. ';./lua/?.lua'

local board1 = require("boards.board1.init")
local board2 = require("boards.board2.init")
local current_board = 'BOARD1'

local BOARDS = {
  ['BOARD2'] = { board = board2, label = "Board [2]" },
  ['BOARD1'] = { board = board1, label = "Board [1]" },
}

local win_options = {
  winblend = 10, winhighlight = "Normal:Normal,FloatBorder:FloatBorder"
}

function BuildHeader()
  local header = Popup({
    enter = false,
    border = {
      style = "single",
      text = {
        top = "Boards",
        top_align = "center",
        bottom = "bottom?",
        bottom_align = "center"
      }
    },
    win_options = win_options
  })

  local content = ""
  for key, value in pairs(BOARDS)
  do
    local board_label = value["label"]
    if key == current_board then
      board_label = '>' .. board_label .. '<'
    end
    content = content .. board_label
  end

  vim.api.nvim_buf_set_lines(header.bufnr, 0, 1, false, { content })
  return header
end

function BuildCommands(content)
  local commands = Popup({
    enter = false,
    border = {
      style = "single",
      text = {
        top = "Commands",
        top_align = "center",
        bottom = "bottom?",
        bottom_align = "center"
      }
    },
    win_options = win_options,
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
    Layout.Box(BuildHeader(), { size = "20%" }),
    Layout.Box(BuildCommands(BOARDS[current_board].board.AvailableCommands), { size = "20%" }),
    Layout.Box(BOARDS[current_board].board.BuildBody(), { size = "60%" }),
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
