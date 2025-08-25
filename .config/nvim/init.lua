-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Leader keys must be set before plugins load
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "catppuccin/nvim",
      lazy = false,
      name = "catppuccin",
      priority = 1000
    },
    {
      "nvim-telescope/telescope.nvim", tag = "0.1.8",
      dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function ()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
          ensure_installed = {
            "c", "cpp", "python", "lua", "vim", "vimdoc", "query",
            "elixir", "heex", "javascript", "html", "markdown", "markdown_inline"
          },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },  
        })
      end
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      }
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end,
      config = function()
        local which_key = require("which-key")
        local builtin = require("telescope.builtin")

        which_key.setup({
          notify = false
        })

        -- Normal mode mappings
        which_key.register({
          ["<leader>f"] = {
            name = "Find (Telescope)",
            b = { builtin.buffers, "Find Buffer" },
            f = { builtin.find_files, "Find File" },
            g = { builtin.live_grep, "Live Grep" },
            h = { builtin.help_tags, "Help Tags" },
          },
          ["<leader>n"] = { "<cmd>Neotree filesystem reveal left<CR>", "Toggle Neo-tree" },
          ["<leader>q"] = { "<cmd>q<CR>", "Quit" },
          ["<leader>w"] = { "<cmd>w<CR>", "Write File" },
        })

        -- Visual mode mappings
        which_key.register({
          -- This now uses the Comment.nvim plugin
          ["<leader>/"] = { "gc", "Comment" },
        }, { mode = "v" })
      end,
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
      config = function()
        require("render-markdown").setup({})
      end
    },
    -- LSP, Autocompletion, and Snippets using lsp-zero
    {
      "VonHeikemen/lsp-zero.nvim",
      branch = "v3.x",
      dependencies = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},
        {'williamboman/mason.nvim'},
        {'williamboman/mason-lspconfig.nvim'},

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {'saadparwaiz1/cmp_luasnip'},
        {'hrsh7th/cmp-nvim-lua'},

        -- Snippets
        {'L3MON4D3/LuaSnip'},
        {'rafamadriz/friendly-snippets'},
      },
      config = function()
        local lsp_zero = require("lsp-zero")
        lsp_zero.on_attach(function(client, bufnr)
          -- See :help lsp-zero-keybindings for the default keymaps
          lsp_zero.default_keymaps({buffer = bufnr})
        end)
        
        require('mason').setup({})
        require('mason-lspconfig').setup({
          handlers = {
            lsp_zero.default_setup,
          },
        })
      end
    },

    -- Smarter commenting
    {
      'numToStr/Comment.nvim',
      config = true
    },

    -- Auto-closing pairs
    {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      config = true
    },
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true, notify = false },
})

-- Catppuccin config
require("catppuccin").setup({
  flavour = "mocha",
  background = { light = "latte", dark = "mocha" },
  transparent_background = false,
  show_end_of_buffer = false,
  term_colors = false,
  dim_inactive = { enabled = false, shade = "dark", percentage = 0.15 },
  no_italic = false,
  no_bold = false,
  no_underline = false,
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  color_overrides = {},
  custom_highlights = {},
  default_integrations = true,
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    notify = false,
    mini = { enabled = true, indentscope_color = "" },
  },
})

vim.cmd.colorscheme "catppuccin"

-- Editor options
vim.cmd("set number")
vim.cmd("set autoindent expandtab tabstop=4 shiftwidth=4")

-- Keymaps outside leader
vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', { desc = "Toggle Neo-tree" })
-- Open current file with its default application
vim.keymap.set('n', '<leader>o', ':silent !xdg-open %<CR>', {
  noremap = true,
  silent = true,
  desc = "Open file with default app"
})
