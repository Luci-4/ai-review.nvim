local M = {
  api_key = vim.env.GROQ_API_KEY or "",
  attributes = "readability, efficiency, best practices, maintainability, clarity",
  tip_character = "Your tips should be non-obvious, assume I'm already an advanced programmer.",
}
local default_prompt_start = [[
You are acting as a programming teacher and reviewer.

I will provide source code. Your task is to return constructive feedback as a list of suggestions to improve the code in terms of]]
local default_prompt_formatting = [[Each suggestion must include:
- The line number where it applies.
- A category (type) of suggestion, such as: readability, efficiency, best_practice, bug_risk, style, maintainability.
- A short, clear message explaining the suggestion.

Return ONLY a JSON array with this format:
[
  {
    "line": <line_number>,
    "type": "<type>",
    "message": "<message>"
  },
  ...
]

Do not include any other text before or after the JSON output.

Here is the code:

]]

local function compose_prompt(attributes, tip_character)
  return default_prompt_start .. " " .. attributes .. "\n" .. tip_character .. "\n" .. default_prompt_formatting
end


function M.setup(opts)
  opts = opts or {}
  M.api_key = opts.api_key or M.api_key
  M.attributes = opts.attributes or M.attributes
  M.tip_character = opts.tip_character or M.tip_character
end

function M.get_prompt_base()
  return compose_prompt(M.attributes, M.tip_character)
end

return M