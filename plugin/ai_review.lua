vim.api.nvim_create_user_command("AIReviewAsk", function()
  require("ai_review").ask()
end, {})