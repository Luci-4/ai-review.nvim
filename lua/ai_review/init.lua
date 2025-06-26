local config = require("ai_review.config")
local api = require("ai_review.api")
local diagnostics = require("ai_review.diagnostics")
local prompt = require("ai_review.prompt")

local M = {}

function M.setup(opts)
  config.setup(opts)
  diagnostics.setup() -- e.g., set highlights, autocmds
end

function M.ask()
  if not config.api_key or config.api_key == "" then
    vim.notify("GROQ_API_KEY is not set! Please set it via setup() or environment variable.", vim.log.levels.ERROR)
    return
  end
  local prompt = prompt.compose_prompt_from_current_buffer()
  api.ask_groq(config.api_key, prompt)
end

return M