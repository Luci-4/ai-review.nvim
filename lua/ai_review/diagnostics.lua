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
  vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
  for _, diag in ipairs(diagnostics) do
    vim.api.nvim_buf_set_extmark(buf, ns_id, diag.line - 1, 0, {
      virt_text = {
        { "→ ", "Normal" },
        { diag.message, "AiReviewDiagnosticHint" },
      },
      virt_text_pos = "eol",
    })
  end
end

return M