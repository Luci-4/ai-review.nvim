-- Loads the plugin and creates user commands

vim.api.nvim_create_user_command("AiReviewAsk", function()
  require("ai_review").ask()
end, {})

-- Optionally call setup here or leave it to user
-- require("ai_review").setup()