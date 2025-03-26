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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "github/copilot.vim",
    },
    {
      "catppuccin/nvim",
      lazy = false,
      name = "catppuccin",
      priority = 1000
    },
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim"},
    {"neovim/nvim-lspconfig"},
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
          ensure_installed = { "c", "cpp", "python", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
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
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true, notify = false },
})

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
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {"lua_ls", "rust_analyzer", "clangd", "bashls", "pyre" },
})
require("lspconfig").rust_analyzer.setup({})
require("lspconfig").lua_ls.setup({})
require("lspconfig").clangd.setup({})
require("lspconfig").pyre.setup({})
require("lspconfig").bashls.setup({})

vim.cmd("set number")
vim.cmd("set autoindent expandtab tabstop=4 shiftwidth=4")
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})

