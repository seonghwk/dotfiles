-- =============================================================================
-- Neovim Configuration — Development & Code Analysis
-- =============================================================================

-- 1. Leader key (Space: entry point for all custom shortcuts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw (replaced by nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- =============================================================================
-- 2. Core Editor Options
-- =============================================================================
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Display
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"         -- always show sign column (prevents layout shift)
opt.scrolloff = 8              -- keep 8 lines above/below cursor
opt.sidescrolloff = 8
opt.wrap = false               -- no line wrapping
opt.colorcolumn = "120"        -- visual ruler at 120 chars

-- Search
opt.ignorecase = true
opt.smartcase = true           -- case-sensitive when uppercase is used
opt.hlsearch = true
opt.incsearch = true

-- System
opt.clipboard = "unnamedplus"  -- use system clipboard
opt.undofile = true            -- persistent undo history
opt.swapfile = false
opt.backup = false
opt.updatetime = 250           -- faster CursorHold events (LSP diagnostics)
opt.timeoutlen = 300           -- which-key popup delay

-- Splits
opt.splitright = true          -- vertical splits open to the right
opt.splitbelow = true          -- horizontal splits open below

-- =============================================================================
-- 3. Plugin Manager — Lazy.nvim (auto-install bootstrap)
-- =============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- 4. Plugins
-- =============================================================================
require("lazy").setup({

  -- ── Theme ────────────────────────────────────────────────────────────────
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ── Status Line ──────────────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } }, -- show relative path
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- ── File Explorer ─────────────────────────────────────────────────────────
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 35 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
        git = { enable = true },
      })
    end,
  },

  -- ── Syntax Highlighting ───────────────────────────────────────────────────
  -- nvim-treesitter v1.0+ (rewrite): nvim-treesitter.configs module removed.
  -- Highlight/indent are now handled natively by Neovim's vim.treesitter.
  -- setup() only manages parser installation; parsers activate automatically.
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua", "python", "javascript", "typescript", "tsx",
          "html", "css", "json", "yaml", "toml", "markdown",
          "bash", "go", "rust", "c", "cpp",
        },
        auto_install = true,
      })
    end,
  },

  -- ── LSP ───────────────────────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Mason: auto-install LSP servers
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",        -- Lua
          "pyright",       -- Python
          "ts_ls",         -- TypeScript / JavaScript
          "bashls",        -- Bash
          "jsonls",        -- JSON
          "yamlls",        -- YAML
          "html",          -- HTML
          "cssls",         -- CSS
        },
        automatic_installation = true,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Extend capabilities with nvim-cmp if available
      local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- Shared on_attach: set LSP keymaps when a server attaches
      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end
        map("gd", vim.lsp.buf.definition,          "Go to Definition")
        map("gD", vim.lsp.buf.declaration,         "Go to Declaration")
        map("gr", vim.lsp.buf.references,          "Find References")
        map("gi", vim.lsp.buf.implementation,      "Go to Implementation")
        map("K",  vim.lsp.buf.hover,               "Hover Documentation")
        map("<leader>rn", vim.lsp.buf.rename,      "Rename Symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("[d", vim.diagnostic.goto_prev,        "Prev Diagnostic")
        map("]d", vim.diagnostic.goto_next,        "Next Diagnostic")
        map("<leader>d", vim.diagnostic.open_float, "Show Diagnostic")
      end

      -- Neovim 0.11+ native API: vim.lsp.config / vim.lsp.enable
      -- nvim-lspconfig provides per-server defaults (cmd, filetypes, root_dir)
      -- which are merged automatically when vim.lsp.enable() is called.

      -- Apply shared settings to all servers
      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Server-specific overrides
      vim.lsp.config("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })

      -- Activate servers
      vim.lsp.enable({
        "lua_ls", "pyright", "ts_ls", "bashls",
        "jsonls", "yamlls", "html", "cssls",
      })

      -- Diagnostic display settings
      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
      })
    end,
  },

  -- ── Autocompletion ────────────────────────────────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",   -- LSP source
      "hrsh7th/cmp-buffer",     -- buffer words
      "hrsh7th/cmp-path",       -- file paths
      "L3MON4D3/LuaSnip",       -- snippet engine
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets", -- pre-built snippets
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          -- Tab: cycle through items or expand/jump snippet
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(entry, item)
            local source_names = {
              nvim_lsp = "[LSP]",
              luasnip  = "[Snip]",
              buffer   = "[Buf]",
              path     = "[Path]",
            }
            item.menu = source_names[entry.source.name] or ""
            return item
          end,
        },
      })
    end,
  },

  -- ── Formatter ─────────────────────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua        = { "stylua" },
          python     = { "black", "isort" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          html       = { "prettier" },
          css        = { "prettier" },
          json       = { "prettier" },
          yaml       = { "prettier" },
          markdown   = { "prettier" },
          sh         = { "shfmt" },
        },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
      })
    end,
  },

  -- ── Fuzzy Finder ─────────────────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = { preview_width = 0.55 },
          mappings = {
            i = { ["<C-k>"] = "move_selection_previous", ["<C-j>"] = "move_selection_next" },
          },
        },
      })
      pcall(telescope.load_extension, "fzf")
    end,
  },

  -- ── Code Structure Overview ───────────────────────────────────────────────
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("aerial").setup({
        layout = { default_direction = "right", min_width = 30 },
        attach_mode = "global",
      })
    end,
  },

  -- ── Diagnostics Panel ─────────────────────────────────────────────────────
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup()
    end,
  },

  -- ── Git Integration ───────────────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Git: " .. desc })
          end
          map("]c", gs.next_hunk,        "Next Hunk")
          map("[c", gs.prev_hunk,        "Prev Hunk")
          map("<leader>hs", gs.stage_hunk,   "Stage Hunk")
          map("<leader>hr", gs.reset_hunk,   "Reset Hunk")
          map("<leader>hb", gs.blame_line,   "Blame Line")
          map("<leader>hd", gs.diffthis,     "Diff This")
        end,
      })
    end,
  },

  -- ── Comment Toggle ────────────────────────────────────────────────────────
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
      -- gcc: toggle line comment, gbc: toggle block comment
      -- gc{motion}: e.g. gc5j to comment 5 lines down
    end,
  },

  -- ── Auto Pairs ────────────────────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({ check_ts = true })
      -- integrate with nvim-cmp
      local ok, cmp = pcall(require, "cmp")
      if ok then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- ── Surround ──────────────────────────────────────────────────────────────
  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup()
      -- ys{motion}{char}: add surround, e.g. ysiw" to wrap word in quotes
      -- ds{char}: delete surround, cs{old}{new}: change surround
    end,
  },

  -- ── Indent Guides ─────────────────────────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope = { enabled = true },
      })
    end,
  },

  -- ── Which-key (keymap hints) ──────────────────────────────────────────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({ delay = 300 })
      -- Register group labels for Space-prefixed keymaps
      require("which-key").add({
        { "<leader>f", group = "Find (Telescope)" },
        { "<leader>h", group = "Git Hunk" },
        { "<leader>x", group = "Diagnostics (Trouble)" },
        { "<leader>o", group = "Outline (Aerial)" },
      })
    end,
  },

  -- ── Terminal ─────────────────────────────────────────────────────────────
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<C-\>]],  -- Ctrl+\ to toggle terminal
        direction = "horizontal",
        shade_terminals = true,
      })
    end,
  },

}, {
  -- Lazy.nvim UI settings
  ui = { border = "rounded" },
})

-- =============================================================================
-- 5. Key Mappings
-- =============================================================================
local map = vim.keymap.set

-- Insert mode escape
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Clear search highlight
map("n", "<leader>/", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- File Explorer (NvimTree)
map("n", "<leader>e", ":NvimTreeToggle<CR>",  { desc = "Toggle file explorer" })
map("n", "<leader>E", ":NvimTreeFindFile<CR>", { desc = "Reveal current file in explorer" })

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>",              { desc = "Find files" })
map("n", "<leader>fg", ":Telescope live_grep<CR>",               { desc = "Live grep (search text)" })
map("n", "<leader>fb", ":Telescope buffers<CR>",                 { desc = "Find open buffers" })
map("n", "<leader>fh", ":Telescope help_tags<CR>",               { desc = "Find help tags" })
map("n", "<leader>fr", ":Telescope oldfiles<CR>",                { desc = "Find recent files" })
map("n", "<leader>fd", ":Telescope diagnostics<CR>",             { desc = "Find diagnostics" })
map("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>",    { desc = "Find document symbols" })
map("n", "<leader>fS", ":Telescope lsp_workspace_symbols<CR>",   { desc = "Find workspace symbols" })

-- Aerial (code structure)
map("n", "<leader>oo", ":AerialToggle<CR>", { desc = "Toggle code outline" })
map("n", "<leader>on", ":AerialNext<CR>",   { desc = "Next symbol" })
map("n", "<leader>op", ":AerialPrev<CR>",   { desc = "Prev symbol" })

-- Trouble (diagnostics panel)
map("n", "<leader>xx", ":Trouble diagnostics toggle<CR>",        { desc = "All diagnostics" })
map("n", "<leader>xd", ":Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics" })
map("n", "<leader>xl", ":Trouble loclist toggle<CR>",            { desc = "Location list" })
map("n", "<leader>xq", ":Trouble qflist toggle<CR>",             { desc = "Quickfix list" })

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>",     { desc = "Next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Prev buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Window navigation (without needing prefix)
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Window resizing
map("n", "<C-Up>",    ":resize -2<CR>",          { desc = "Shrink window height" })
map("n", "<C-Down>",  ":resize +2<CR>",          { desc = "Grow window height" })
map("n", "<C-Left>",  ":vertical resize -2<CR>", { desc = "Shrink window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Grow window width" })

-- Indent while keeping selection in visual mode
map("v", "<", "<gv", { desc = "Outdent selection" })
map("v", ">", ">gv", { desc = "Indent selection" })

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

-- Format buffer
map("n", "<leader>fm", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- Lazygit (if installed via zshrc alias)
map("n", "<leader>gg", ":terminal lazygit<CR>i", { desc = "Open Lazygit" })
