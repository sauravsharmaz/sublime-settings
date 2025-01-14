-- Lazy.nvim setup: A plugin manager for Neovim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Use the stable branch
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic Neovim settings
vim.g.mapleader = " " -- Set the leader key to space
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.number = true -- Show absolute line number for the current line
vim.opt.swapfile = false -- Disable swap files
vim.opt.undofile = true -- Enable persistent undo
vim.opt.incsearch = true -- Highlight matches as you type
vim.opt.hidden = true -- Allow switching buffers without saving
vim.opt.wrap = false -- Disable line wrapping

-- Key mappings for common actions (kept natural and simple)
vim.keymap.set("n", "<C-s>", ":w<CR>") -- Save in normal mode
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>") -- Save in insert mode
vim.keymap.set("n", "<C-q>", ":wq<CR>") -- Save and quit
vim.keymap.set("i", "jj", "<Esc>") -- Exit insert mode by typing 'jj'
vim.keymap.set("n", "<C-w>", ":bd<CR>") -- Close the current buffer
vim.keymap.set("n", "<S-h>", ":bprevious<CR>") -- Go to the previous buffer
vim.keymap.set("n", "<S-l>", ":bnext<CR>") -- Go to the next buffer
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>") -- Move to the left window
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>") -- Move to the bottom window
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>") -- Move to the top window
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>") -- Move to the right window
vim.keymap.set("n", "<leader>f", ":Telescope find_files hidden=true<CR>") -- Find files with Telescope
vim.keymap.set("n", "<leader>fw", ":Telescope live_grep<CR>") -- Search text in files
vim.keymap.set("n", "<leader>g", ":lua require('telescope.builtin').live_grep({ default_text = vim.fn.expand('<cword>') })<CR>") -- Search for the word under the cursor
vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>") -- Show diagnostics in a floating window
vim.keymap.set("n", "gk", ":lua vim.lsp.buf.hover()<CR>") -- Show LSP hover information
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- Toggle the file explorer

-- Plugin setup using lazy.nvim
require("lazy").setup({
  -- Theme (choose your preferred one)
  { "bluz71/vim-moonfly-colors", name = "moonfly" },

  -- Treesitter for syntax highlighting
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Telescope for fuzzy finding
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  -- File Explorer
  { "kyazdani42/nvim-tree.lua", dependencies = { "kyazdani42/nvim-web-devicons" } },

  -- Bufferline and which-key
  { "akinsho/bufferline.nvim", dependencies = { "kyazdani42/nvim-web-devicons" } },
  { "folke/which-key.nvim" },

  -- Git integration with Gitsigns
  { "lewis6991/gitsigns.nvim" },

  -- Commenting utility
  { "numToStr/Comment.nvim" },

  -- UI Enhancements
  { "stevearc/dressing.nvim" }, -- Optional, enhances UI components

  -- GitHub Copilot integration
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<Tab>", -- Accept suggestion
            next = "<M-]>", -- Next suggestion
            prev = "<M-[>", -- Previous suggestion
            dismiss = "<C-]>", -- Dismiss suggestion
          },
        },
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            open = "<M-CR>", -- Open Copilot panel
            refresh = "gr", -- Refresh suggestions
            jump_prev = "[[", -- Jump to previous suggestion
            jump_next = "]]", -- Jump to next suggestion
            accept = "<CR>", -- Accept suggestion
          },
        },
        filetypes = {
          yaml = false, -- Disable Copilot for YAML
          markdown = false, -- Disable Copilot for Markdown
          help = false, -- Disable Copilot for help files
          gitcommit = false, -- Disable Copilot for git commits
          ["*"] = true, -- Enable Copilot for all other filetypes
        },
        copilot_node_command = "node", -- Node.js command for Copilot
      })
    end,
  },

  -- Blink LSP
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',
  
    -- use a release tag to download pre-built binaries
    version = 'v0.10.0',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',
  
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      fuzzy = {
        prebuilt_binaries = {
          force_version = "v0.10.0"
        }
      },
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = { preset = 'enter' },
  
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },
  
      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
    opts_extend = { "sources.default" },
    signature = {
      enabled = true,
    },
  },

  -- Mason for LSP server management
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "pyright",    -- Python
        "ts_ls",   -- JavaScript/TypeScript
      },
    },
  },

  -- LSP Support
  {
    "neovim/nvim-lspconfig",
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local lspconfig = require('lspconfig')

      -- Python (Django) setup
      lspconfig.pyright.setup({ capabilities = capabilities })
      
      -- JavaScript setup
      lspconfig.ts_ls.setup({ capabilities = capabilities })
    end
  },
})

-- Treesitter configuration
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "vim", "python", "rust", "json", "javascript", "html", "css" },
  highlight = { enable = true },
  auto_install = true,
})

-- Telescope configuration
local telescope = require("telescope")
telescope.setup({
  defaults = {
    file_ignore_patterns = { "node_modules", ".git/", "venv", "env" },
  },
})
telescope.load_extension("fzf") -- Load FZF extension for Telescope

-- Bufferline configuration
require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    offsets = {
      { filetype = "NvimTree", text = "File Explorer", highlight = "Directory", text_align = "left" },
    },
  },
})

-- NvimTree configuration
require("nvim-tree").setup({})

-- Gitsigns configuration
require("gitsigns").setup()

-- Comment.nvim configuration
require("Comment").setup()

-- Customize diagnostics UI
vim.diagnostic.config({
  underline = true,
  virtual_text = { spacing = 4, prefix = "●" },
  signs = true,
  update_in_insert = false,
})

-- Restore the last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Set the colorscheme
vim.cmd("colorscheme moonfly")

require("which-key").setup({})
