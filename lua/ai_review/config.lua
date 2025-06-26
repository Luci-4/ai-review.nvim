local M = {
  api_key = vim.env.GROQ_API_KEY or "",
  prompt_base = [[
You are acting as a programming teacher and reviewer.

I will provide source code. Your task is to return constructive feedback as a list of suggestions to improve the code in terms of readability, efficiency, best practices, maintainability, and clarity. Your tips should be non-obvious, assume I'm already an advanced programmer.
Each suggestion must include:
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

]],
}

function M.setup(opts)
  opts = opts or {}
  M.api_key = opts.api_key or M.api_key
  if opts.prompt_base then
    M.prompt_base = opts.prompt_base
  end
end

return M