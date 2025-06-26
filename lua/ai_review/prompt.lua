local config = require("ai_review.config")

local M = {}

function M.compose_prompt_from_current_buffer(is_long)
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for i, line in ipairs(lines) do
    lines[i] = tostring(i) .. ": " .. line
  end
  local full_text = table.concat(lines, "\n")
  return config.get_prompt_base(is_long) .. full_text
end

return M