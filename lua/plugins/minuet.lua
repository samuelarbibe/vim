-- Cache gcloud token to avoid spawning a subprocess on every keystroke
local _gcp_token = nil
local _gcp_token_time = 0
local GCP_TOKEN_TTL = 1800 -- refresh every 30 minutes

local function get_gcp_token()
  local now = os.time()
  if _gcp_token and (now - _gcp_token_time) < GCP_TOKEN_TTL then
    return _gcp_token
  end
  _gcp_token = vim.fn.system("gcloud auth print-access-token"):gsub("%s+$", "")
  _gcp_token_time = now
  return _gcp_token
end

---@type LazySpec
return {
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {
      provider = "claude",
      provider_options = {
        claude = {
          model = "claude-haiku-4-5",
          max_tokens = 512,
          api_key = get_gcp_token,
          end_point = "https://us-east5-aiplatform.googleapis.com/v1/projects/pb-engineering-ai/locations/us-east5/publishers/anthropic/models/claude-haiku-4-5:streamRawPredict",
          stream = true,
          transform = {
            function(data)
              data.headers["Authorization"] = "Bearer " .. data.headers["x-api-key"]
              data.headers["x-api-key"] = nil
              data.headers["anthropic-version"] = nil
              data.body["anthropic_version"] = "vertex-2023-10-16"
              data.body["model"] = nil
              return data
            end,
          },
        },
      },
      virtualtext = {
        auto_trigger_ft = { "typescript", "typescriptreact" },
        keymap = {
          accept = "<A-y>",
          accept_line = "<A-l>",
          prev = "<A-[>",
          next = "<A-]>",
          dismiss = "<A-e>",
        },
      },
    },
  },
}
