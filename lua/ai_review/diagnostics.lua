local ns_id = vim.api.nvim_create_namespace("ai_review_virtual_text")

local M = {}

function M.setup()
  vim.api.nvim_set_hl(0, "AiReviewPrintArrow", {
    fg = "#40E0D0",
    bold = true,
    underline = false,
  })

  vim.api.nvim_set_hl(0, "AiReviewDiagnosticHint", {
    fg = "#40E0D0",
    bold = true,
    underline = true,
  })


  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      vim.api.nvim_set_hl(0, "AiReviewPrintArrow", {
        fg = "#40E0D0",
        bold = true,
        underline = false,
      })
      vim.api.nvim_set_hl(0, "AiReviewDiagnosticHint", {
        fg = "#40E0D0",
        bold = true,
        underline = true,
      })
    end,
  })
end

function M.show_virtual_text_tips(diagnostics, buf)
  local config = require("ai_review.config")
  vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
  for _, diag in ipairs(diagnostics) do
    vim.api.nvim_buf_set_extmark(buf, ns_id, diag.line - 1, 0, {
      virt_text = {
        { config.virtual_text_prefix, "Normal" },
        { diag.message, config.virtual_text_hl },
      },
      virt_text_pos = "eol",
    })
  end
end

local message_mappings = {}

function M.show_buffer_tips(messages, source_bufnr)
  local config = require("ai_review.config")
  vim.cmd('vsplit')

  local info_buf = vim.api.nvim_create_buf(false, true)
  if not info_buf then
    print("Failed to create buffer")
    return
  end

  vim.api.nvim_win_set_buf(0, info_buf)

  local lines = {}
  local current_line_index = 1

  for _, msg in ipairs(messages) do

    if type(msg.message) == "string" and type(msg.line) == "number" then
      
      local message_lines = vim.split(msg.message, "\n", true)

      if #message_lines > 0 then
        message_lines[1] = string.format("[line %d] %s", msg.line, message_lines[1])
      end
      for _, l in ipairs(message_lines) do
        table.insert(lines, l)
        message_mappings[current_line_index] = { line = msg.line, bufnr = source_bufnr }
        current_line_index = current_line_index + 1
      end
    end
  end

  vim.api.nvim_buf_set_lines(info_buf, 0, -1, false, lines)
  for i, line in ipairs(lines) do
    local start_pos, end_pos = line:find("%[line %d+%]")
    if start_pos and end_pos then
      vim.api.nvim_buf_add_highlight(info_buf, -1, config.buffer_highlight, i - 1, start_pos - 1, end_pos)
    end
  end
  vim.bo[info_buf].buftype = 'nofile'
  vim.bo[info_buf].bufhidden = 'wipe'
  vim.bo[info_buf].swapfile = false
  vim.bo[info_buf].modifiable = false
  vim.bo[info_buf].readonly = true
  vim.api.nvim_win_set_buf(0, info_buf)
  vim.api.nvim_win_set_option(0, 'wrap', true)

  vim.api.nvim_buf_set_keymap(info_buf, 'n', '<leader>j', '', {
    noremap = true,
    silent = true,
    callback = function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local row = cursor[1]
      local target = message_mappings[row]
      if target then
        local win_found = nil
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_buf(win) == target.bufnr then
            win_found = win
            break
          end
        end
        if win_found then
          vim.api.nvim_set_current_win(win_found)
          vim.api.nvim_win_set_cursor(win_found, { target.line, 0 })
        else
          print("Target buffer not visible in any window")
        end
      else
        print("No jump target for this line")
      end
    end
  })
end


return M