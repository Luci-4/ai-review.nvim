local Job = require("plenary.job")
local diagnostics = require("ai_review.diagnostics")

local M = {}

local function handle_response(response, buf)
  local json = require("config.json")

  local decoded, err = json.decode(response)
  if not decoded then
    vim.schedule(function()
      vim.notify("Failed to decode JSON response: " .. tostring(err), vim.log.levels.ERROR)
    end)
    return
  end

  local reply = decoded.choices
      and decoded.choices[1]
      and decoded.choices[1].message
      and decoded.choices[1].message.content
  if not reply then
    vim.schedule(function()
      vim.notify("Unexpected API response format.", vim.log.levels.ERROR)
    end)
    return
  end

  local decoded_reply, err = json.decode(reply)
  if not decoded_reply then
    vim.schedule(function()
      vim.notify("Failed to decode nested JSON response: " .. tostring(err), vim.log.levels.ERROR)
    end)
    return
  end

  vim.schedule(function()
    diagnostics.show_virtual_text_tips(decoded_reply, buf)
  end)
end

function M.ask_groq(api_key, prompt)
  local url = "https://api.groq.com/openai/v1/chat/completions"
  local request_body = {
    model = "llama-3.3-70b-versatile",
    messages = {
      { role = "user", content = prompt },
    },
  }

  local body_json = vim.fn.json_encode(request_body)
  local buf = vim.api.nvim_get_current_buf()

  vim.notify("Sending request to Groq API...", vim.log.levels.INFO)

  Job:new({
    command = "curl",
    args = {
      "-s", "--compressed",
      "-X", "POST",
      "-H", "Content-Type: application/json",
      "-H", "Authorization: Bearer " .. api_key,
      "-d", body_json,
      url,
    },
    on_exit = function(j, return_val)
      local response = table.concat(j:result(), "\n")
      vim.schedule(function()
        vim.notify("Groq API response received (exit code: " .. return_val .. ")", vim.log.levels.INFO)
      end)

      if return_val ~= 0 then
        vim.schedule(function()
          vim.notify("Groq API call failed. Exit code: " .. return_val, vim.log.levels.ERROR)
          vim.notify("Response: " .. response, vim.log.levels.DEBUG)
        end)
        return
      end

      handle_response(response, buf)
    end,
  }):start()
end

return M