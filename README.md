# ai-review.nvim

A Neovim plugin that provides AI-powered code review using Groq's API.


## Features

- Get inline code review suggestions as virtual text
- Get detailed code review in a split buffer
- Jump to relevant lines from review suggestions
- Customizable prompts and display options

### Inline Suggestions
![Screenshot (1057)](https://github.com/user-attachments/assets/74350698-a720-4a18-8dc9-22dff525565c)

### Detailed Review Panel  
![Screenshot (1056)](https://github.com/user-attachments/assets/a36d482f-3d66-4d2e-b132-b88c416da980)

## Installation

Using packer.nvim:

```lua
use({
  'your-username/ai-review.nvim',
  config = function()
    require('ai-review').setup({
      api_key = "your-groq-api-key", -- or set GROQ_API_KEY environment variable
      -- other config options
    })
  end
})
```

Using lazy.nvim:
```lua
{
  'your-username/ai-review.nvim',
  opts = {
    api_key = "your-groq-api-key",
    -- other config options
  }
}
```

## Configuration
```lua
require('ai-review').setup({
  api_key = vim.env.GROQ_API_KEY or "", -- Required
  attributes = "readability, efficiency, best practices, maintainability, clarity",
  tip_character = "Your tips should be non-obvious, assume I'm already an advanced programmer that is dealing with a new language.",
  model = "llama-3.3-70b-versatile",
  api_url = "https://api.groq.com/openai/v1/chat/completions",
  virtual_text_prefix = "→ ",
  virtual_text_hl = "AiReviewDiagnosticHint",
  buffer_highlight = "AiReviewPrintArrow",
})
```


## Usage
```vim
" Get quick inline code review suggestions
:AIReviewInline

" Get detailed review in a split buffer
:AIReviewLong
```

## Requirements
- Neovim 0.9.0 or higher
- curl (for API requests)
- Groq API key (free tier available) https://console.groq.com/keys

## Dependencies
This plugin uses a local copy of `json.lua` from:
- [rxi/json.lua](https://github.com/rxi/json.lua)

The file should be placed in your Neovim config's `lua/config/json.lua` path
to function properly. This is not automatically installed - you'll need to:
1. Download json.lua from the repository
2. Place it at `.../nvim/lua/config/json.lua`

## Known Issues
- Errors may not always be handled gracefully, so if AI returns something stupid expect a lot of red
- Check your token limits, they might depend on the model. For groq they can be found here: https://console.groq.com/dashboard/limits
- The JSON response must be strictly formatted

## Roadmap
- Create a fallback to an unstructured display of the feedback
- Some local caching would be nice
- Automate json.lua download
