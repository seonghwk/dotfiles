 -- 1. 리더 키 설정 (단축키의 시작점, 보통 Space)
 vim.g.mapleader = " "

 -- 2. 기본 편집 설정 (줄 번호, 들여쓰기 등)
 local opt = vim.opt
 opt.number = true           -- 줄 번호 표시
 opt.relativenumber = true   -- 상대 줄 번호 (이동 시 편리)
 opt.tabstop = 4             -- Tab을 4칸으로
 opt.shiftwidth = 4
 opt.expandtab = true        -- Tab을 공백으로 변환
 opt.smartindent = true
 opt.cursorline = true       -- 현재 줄 강조
 opt.termguicolors = true    -- 256색 이상 지원
 opt.clipboard = "unnamedplus" -- 시스템 클립보드 공유

 -- 3. 플러그인 매니저 (Lazy.nvim) 자동 설치 스크립트
 local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
 if not vim.loop.fs_stat(lazypath) then
   vim.fn.system({
     "git", "clone", "--filter=blob:none",
     "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
   })
 end
 vim.opt.rtp:prepend(lazypath)

 -- 4. 핵심 플러그인 설치 목록
 require("lazy").setup({
   -- 테마 (Catppuccin 추천: 눈이 편하고 범용적임)
   { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

   -- 파일 탐색기 (NvimTree)
   { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

   -- 구문 강조 (Treesitter)
   { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

   -- LSP (언어 서버: 자동 완성, 에러 체크 등)
   { "neovim/nvim-lspconfig" },
   { "williamboman/mason.nvim" },           -- LSP 관리자
   { "williamboman/mason-lspconfig.nvim" }, -- Mason과 lspconfig 연결

   -- 퍼지 파인더 (Telescope: fzf의 nvim 버전)
   { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
 })

 -- 테마 적용
 vim.cmd.colorscheme "catppuccin"

 -- 5. 필수 단축키 (Keymaps)
 local keymap = vim.keymap
 keymap.set("i", "jk", "<ESC>") -- jk로 입력 모드 탈출
 keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")      -- Space + e : 파일 탐색기
 keymap.set("n", "<leader>ff", ":Telescope find_files<CR>") -- Space + ff : 파일 찾기
 keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")  -- Space + fg : 내용 검색
