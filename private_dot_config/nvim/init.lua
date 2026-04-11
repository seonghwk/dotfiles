-- 1. Leader key (entry point for all custom shortcuts, typically Space)
vim.g.mapleader = " "

-- 2. Core editor settings (line numbers, indentation, etc.)
local opt = vim.opt
opt.number = true           -- show line numbers
opt.relativenumber = true   -- relative line numbers (useful for jump motions)
opt.tabstop = 4             -- tab width of 4 spaces
opt.shiftwidth = 4
opt.expandtab = true        -- expand tabs to spaces
opt.smartindent = true
opt.cursorline = true       -- highlight the current line
opt.termguicolors = true    -- enable true color support
opt.clipboard = "unnamedplus" -- use system clipboard

-- 3. Plugin manager (Lazy.nvim) — auto-install bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 4. Core plugin list
require("lazy").setup({
  -- theme (Catppuccin: easy on the eyes and widely supported)
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  -- file explorer (NvimTree)
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- syntax highlighting (Treesitter)
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- LSP (language server: auto-complete, error checking, etc.)
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },           -- LSP installer/manager
  { "williamboman/mason-lspconfig.nvim" }, -- bridge between Mason and lspconfig

  -- fuzzy finder (Telescope: fzf equivalent inside Neovim)
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
})

-- Apply theme
vim.cmd.colorscheme "catppuccin"

-- 5. Key mappings
local keymap = vim.keymap
keymap.set("i", "jk", "<ESC>")                                  -- exit insert mode with jk
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")              -- Space+e: toggle file explorer
keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")       -- Space+ff: find files
keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")        -- Space+fg: live grep
