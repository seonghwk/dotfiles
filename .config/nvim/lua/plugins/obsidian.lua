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

      follow_url_func = function(url)
        local opener
        if vim.fn.has("mac") == 1 then
          opener = "open"
        elseif vim.fn.has("unix") == 1 then
          opener = "xdg-open"
        elseif vim.fn.has("win32") == 1 then
          opener = "start"
        end

        if opener then
          vim.fn.jobstart({ opener, url }, { detach = true })
        else
          print("No valid URL opener found for this OS.")
        end
      end,
      -- create file name as title
      note_id_func = function(title)
        if title ~= nil then
          -- return title:gsub(" ", "-"):gsub("[^a-zA-Z0-9%-]", ""):lower()
          return title:gsub(" ", "_"):gsub("[^%w_%-]", "")
        else
          return tostring(os.time())
        end
      end,
    }
  end,
  config = function(_, opts)
    local obsidian = require("obsidian")
    local Note = require("obsidian.note")
    local Path = require("plenary.path")

    -- Initialize the obsidian.nvim plugin with the provided options
    obsidian.setup(opts)

    -- Define a simple function to return the timestamp of exactly one day ago (ignores working days)
    local function simple_day_before()
      return os.time() - 86400 -- subtract 24 hours from current time
    end

    -- Get the current Obsidian client
    local client = obsidian.get_client()

    -- Override the default 'yesterday' method on the client to use simple_day_before instead of working_day_before
    client.yesterday = function(self)
      return self:_daily(simple_day_before())
    end
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

    { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename current note (and update links)" },
  },
  -- see below for full list of options 👇
}
