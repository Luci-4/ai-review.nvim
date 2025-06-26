local config = require("ai_review.config")
local api = require("ai_review.api")
local diagnostics = require("ai_review.diagnostics")
local prompt = require("ai_review.prompt")

local M = {}

function M.setup(opts)
  config.setup(opts)
  diagnostics.setup() -- e.g., set highlights, autocmds
end

function ask(is_long)
  if not config.api_key or config.api_key == "" then
    vim.notify("GROQ_API_KEY is not set! Please set it via setup() or environment variable.", vim.log.levels.ERROR)
    return
  end
  local prompt = prompt.compose_prompt_from_current_buffer(is_long)
  api.ask_groq(config.api_key, prompt, is_long)
end

function M.ask_inline()
  ask(false)
end

function M.ask_long()
  ask(true)
end


return M