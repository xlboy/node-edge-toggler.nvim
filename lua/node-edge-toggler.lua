-- 获取两个位置之间的文本
local function get_text_between(cursor_row, cursor_col, target_row, target_col)
  local buf = vim.api.nvim_get_current_buf()

  local start_row, end_row = math.min(cursor_row, target_row), math.max(cursor_row, target_row)
  local start_col, end_col = cursor_col, target_col

  -- 当光标在目标之后时，调换起始和结束列
  if cursor_row > target_row or (cursor_row == target_row and cursor_col > target_col) then
    start_col, end_col = target_col, cursor_col
  end

  local lines = vim.api.nvim_buf_get_lines(buf, start_row, end_row + 1, false)

  if start_row == end_row then
    lines[1] = lines[1]:sub(start_col + 1, end_col)
  else
    lines[1] = lines[1]:sub(start_col + 1)
    lines[#lines] = lines[#lines]:sub(1, end_col)
  end

  return table.concat(lines, "\n")
end

-- 获取当前光标节点的近端或远端位置
local function get_recent_pos()
  local ts_utils = require("nvim-treesitter.ts_utils")

  local cursor_node = ts_utils.get_node_at_cursor()
  if not cursor_node then
    vim.notify(
      "No Treesitter node found at cursor position.",
      vim.log.levels.WARN,
      { title = "node-edge-toggler.nvim" }
    )
    return nil
  end

  local start_row, start_col, end_row, end_col = vim.treesitter.get_node_range(cursor_node)

  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
  cursor_row = cursor_row - 1 -- 转换为0-based索引

  local start_text = get_text_between(cursor_row, cursor_col, start_row, start_col)
  local end_text = get_text_between(cursor_row, cursor_col, end_row, end_col)

  -- 判断光标移动方向：向前还是向后
  local is_forward = #start_text > #end_text

  return is_forward and { start_row + 1, start_col } or { end_row + 1, end_col - 1 }
end

return {
  toggle = function()
    local recent_pos = get_recent_pos()
    if not recent_pos then return end
    vim.api.nvim_win_set_cursor(0, recent_pos)
  end,
}
