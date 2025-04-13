return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  event = "BufReadPre",
  ft = "markdown",
  enabled = function()
    local Path = require("plenary.path")
    local cwd = vim.fn.getcwd()
    local vault_path = Path:new(cwd):joinpath(".obsidian")
    return vault_path:exists()
  end,
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = function()
    local cwd = vim.fn.getcwd()
    return {
      workspaces = {
        {
          name = "second-brain",
          path = cwd,
        },
      },
      notes_subdir = "inbox",
      daily_notes = {
        folder = "daily",
        template = "templates/daily.md",
      },
      templates = {
        subdir = "templates",
      },
    }
  end,
  keys = {
    -- Note creation
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Note" },
    { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Open today's note" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Open yesterday's note" },
    { "<leader>oT", "<cmd>ObsidianTemplate<cr>", desc = "Insert template" },

    -- Note linking and reference
    { "<leader>ol", "<cmd>ObsidianLink<cr>", desc = "Insert link to note" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show backlinks" },
    { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open current file in Obsidian app" },

    -- Search (Telescope or internal)
    { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch between notes" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search in vault" },
    { "<leader>og", "<cmd>Telescope live_grep<cr>", desc = "Search contents in vault" },
    -- { "<leader>otg", "<cmd>Telescope tags<cr>", desc = "Search tags" },
  },
  -- see below for full list of options 👇
}
